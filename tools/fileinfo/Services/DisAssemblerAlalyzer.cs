using fileinfo.Helpers;
using fileinfo.Services.Dasm.Model;
using System.Text;

namespace fileinfo.Services
{
    internal class DisAssemblerAlalyzer
    {
        public static string[] callOpCodes = { "call ", "cc ", "cm ", "cp ", "cpe ", "cpo ", "cz " };
        public static string[] jumpOpCodes = { "jc ", "jm ", "jmp ", "jnc ", "jnz ", "jp ", "jpe ", "jpo ", "jz " };
        public static string[] retOpCodes = { "hlt", "rc", "ret", "rm", "rnc", "rnz", "rp", "rpe", "rpo", "rz" };

        public static HashSet<ushort> Alalyze(byte[] content, ushort address)
        {
            OpCodeArray opCodes = new();
            HashSet<ushort> codeAddress = new();
            using (MemoryStream memory = new(content))
            {
                AlalyzeBlock(memory, address, opCodes, codeAddress);
            }
            return codeAddress;
        }

        private static void AlalyzeBlock(MemoryStream memory, ushort address, OpCodeArray opCodes, HashSet<ushort> codeAddress)
        {
            while (true)
            {
                ushort addr = (ushort)(address + memory.Position);
                if (codeAddress.Contains(addr))
                    return;
                var code = memory.ReadByte();
                if (code == -1) return;
                var item = opCodes.List[code];
                if (item == null) return;
                item.Parse(memory);
                codeAddress.Add(addr);
                string command = item.ToString();

                // Обрабатываем команды переходов jmp
                if (jumpOpCodes.Any(c => command.StartsWith(c)))
                {
                    // При выходе за пределы код прекращаем анализ
                    if (item.ParamWord!.Value < address || item.ParamWord!.Value > address + memory.Length)
                        return;
                    // Если анализа еще не было, то делаем его.
                    if (!codeAddress.Contains(item.ParamWord.Value))
                    {
                        var position = memory.Position;
                        memory.Seek(item.ParamWord.Value - address, SeekOrigin.Begin);
                        AlalyzeBlock(memory, address, opCodes, codeAddress);
                        memory.Seek(position, SeekOrigin.Begin);
                    }
                }
                // Обрабатываем команды вызовов функций call
                if (callOpCodes.Any(c => command.StartsWith(c)))
                {
                    // При выходе за пределы кода, например вызов системных функций, продолжаем анализ
                    if (item.ParamWord!.Value < address || item.ParamWord!.Value > address + memory.Length)
                        continue;
                    // Если анализа еще не было, то делаем его.
                    if (!codeAddress.Contains(item.ParamWord.Value))
                    {
                        var position = memory.Position;
                        memory.Seek(item.ParamWord.Value - address, SeekOrigin.Begin);
                        AlalyzeBlock(memory, address, opCodes, codeAddress);
                        memory.Seek(position, SeekOrigin.Begin);
                    }
                }

                // Обрабатываем команды выхода из функций ret
                if (retOpCodes.Any(c => command.StartsWith(c)))
                    return;
            }

        }

        public static void DisAssembleCode(StringBuilder text, byte[] content, ushort address, HashSet<ushort> codeAddress, Func<byte, bool, char> encoding)
        {
            OpCodeArray opCodes = new();
            using MemoryStream memory = new(content);
            while (true)
            {
                ushort addr = (ushort)(address + memory.Position);
                if (codeAddress.Contains(addr))
                {
                    var code = memory.ReadByte();
                    if (code == -1) return;
                    var item = opCodes.List[code];
                    if (item == null) throw new IndexOutOfRangeException();
                    item.Parse(memory);
                    text.AppendFormat("{0, -32};{1}", item.ToString(), addr.ToHexAsm());
                    text.AppendLine();
                }
                else
                {
                    var data = memory.ReadByte();
                    if (data == -1) return;
                    var line = String.Format("DB   {0}", ((byte)data).ToHexAsm());
                    text.AppendFormat("{0, -32};{1} '{2}'", line, addr.ToHexAsm(), encoding((byte)data, false));
                    text.AppendLine();
                }
            }
        }
    }
}

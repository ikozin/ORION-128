using fileinfo.Helpers;
using fileinfo.Services.Dasm.Model;
using System.Text;

namespace fileinfo.Services.Dasm
{
    public class Program
    {
        public static string Process(Stream stream, ushort org,
            Dictionary<string, string> labels,
            Dictionary<string, string> datas,
            Dictionary<string, string> comments,
            Func<byte, bool, char> encoding)
        {
            OpCodeArray codeArray = new(labels);

            StringBuilder result = new(1024);

            result.AppendLine($"ORG {org.ToHexAsm()}");
            result.AppendLine();

            while (true)
            {
                try
                {
                    string? text;
                    ushort current = (ushort)(org + stream.Position);
                    string addr = current.ToHexAsm();

                    if (datas.ContainsKey(addr))
                    {
                        text = OpDataArray.Get(datas[addr]).ToString(stream, encoding);
                    }
                    else
                    {
                        if (stream.Position == stream.Length) break;
                        byte data = (byte)stream.ReadByte();
                        (byte code, text) = codeArray.Handle(data, stream, true);
                        if (String.IsNullOrEmpty(text))
                        {
                            text = $"DB   {code.ToHexAsm()}; Ошибка дизассемблирования команды";
                        }
                    }

                    text = $"{text,-32}"; // Форматируем строку
                    string note = comments.ContainsKey(addr) ? comments[addr] : "";
                    if (labels.ContainsKey(addr))
                    {
                        var label = labels[addr];
                        if (label.StartsWith(";"))
                        {
                            label = label[1..];
                            result.AppendLine();
                        }
                        result.AppendLine($"{label}:");
                    }
                    if (note.StartsWith(";"))
                    {
                        foreach (var commentLine in note.Split(new[] { ';' }, StringSplitOptions.RemoveEmptyEntries))
                            result.AppendLine($";{commentLine}");
                        result.AppendLine($"    {text};{addr}");
                    }
                    else
                        result.AppendLine($"    {text};{addr} {note}");
                }
                catch (Exception ex)
                {
                    result.AppendLine(ex.Message);
                    break;
                }
            }
            return result.ToString();
        }
    }
}

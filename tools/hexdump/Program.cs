using System;
using System.IO;

namespace HexDump
{
    class Program
    {
        private const string FormatAddr = "{0:X4} ";
        private const string FormatValue = "{0:X2} ";
        private const string FormatLineSum = "{0:X4}";
        static void Main(string[] args)
        {
            string sourcePath = String.Empty;
            bool isViewLineSum = false;
            bool isViewLineAddr = false;
            uint label = 0;

            try
            {
                foreach (var param in args)
                {
                    if (param[0] == '/')
                    {
                        switch (param.Substring(0, 2).ToLower())
                        {
                            case "/l":
                                var value = param.Remove(0, 2);
                                if (value.Length > 0)
                                {
                                    if (value[0] != ':')
                                        throw new ApplicationException("Ошибка в параметре /L");
                                    value = value.Remove(0, 1);
                                }
                                label = uint.Parse(value.Trim(), System.Globalization.NumberStyles.HexNumber);
                                break;
                            case "/a":
                                isViewLineAddr = true;
                                break;
                            case "/s":
                                isViewLineSum = true;
                                break;
                            default:
                                throw new ApplicationException("Низвестные параметры");
                        }
                    }
                    else
                    {
                        if (sourcePath != String.Empty) throw new ApplicationException("Файл не указан");
                        sourcePath = param.Trim('\"');
                    }
                }
                if (sourcePath == String.Empty) throw new ApplicationException("Файл не указан");
            }
            catch (Exception)
            {
                DisplayInfo();
                return;
            }
            try
            {
                byte[] data = File.ReadAllBytes(sourcePath);
                if (data.Length % 256 != 0) throw new ApplicationException(String.Format("Error File Length = ", data.Length));

                for (uint addr = 0; addr < data.Length; label += 16, addr += 16)
                    DisplayLine(addr, label, 16, isViewLineAddr, isViewLineSum, data);
                Console.WriteLine();

                if (isViewLineSum)
                {
                    for (uint addr = 0; addr < data.Length; addr += 256)
                        DisplayBlockSum(addr, 256, data);
                    Console.WriteLine();
                    DisplayBlockSum(0, (ulong)data.Length, data);
                }
            }
            catch (Exception ex)
            {
                Console.WriteLine(ex.Message);
            }
        }

        private static void DisplayLine(uint addr, uint label, uint len, bool isViewLineAddr, bool isViewLineSum, byte[] data)
        {
            if (isViewLineAddr) Console.Write(FormatAddr, label);
            uint stop = addr + len - 1;
            for (uint start = addr; start <= stop; label++, start++)
                Console.Write(FormatValue, data[start]);
            if (isViewLineSum)
                Console.Write(FormatLineSum, CalcBlockSum(addr, stop, data));
            Console.WriteLine();
        }

        // Алгоритм расчета сумы взят из Монитор-1
        private static ushort CalcBlockSum(ulong start, ulong stop, byte[] data)
        {
            ushort l = 0;
            ushort h = 0;
            bool flag = false;
            while (true)
            {
                byte v = data[start];
                l += v;
                flag = l > 0xFF;
                l &= 0xFF;
                if (start == stop) return (ushort)((h << 8) | l);
                h += (byte)(v + Convert.ToByte(flag));
                start++;
            }
        }

        private static void DisplayBlockSum(ulong start, ulong len, byte[] data)
        {
            ulong stop = start + len - 1;
            var result = CalcBlockSum(start, stop, data);
            Console.WriteLine("{0:X4} - {1:X4}\t{2:X4}", start, stop, result);
        }

        private static void DisplayInfo()
        {
            Console.WriteLine(
@"hexdump /L:8000 /A /S file
  /L         - адрес начала кода в HEX формате
  /A         - в начале строки показывать адрес в HEX формате
  /S         - в конце строки показывать контрольную сумму в HEX формате
  file       - путь к файлу");
        }
    }
}

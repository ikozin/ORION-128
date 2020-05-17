using System;
using System.IO;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace HexPack
{
    class Program
    {
        static void Main(string[] args)
        {
            try
            {
                if (args.Length == 0)
                    DisplayInfo();
                var fileName = String.Join(" ", args);
                using (var file = File.OpenText(fileName))
                {
                    fileName = Path.ChangeExtension(fileName, "rom");
                    using (var target = File.OpenWrite(fileName))
                    {
                        while (true)
                        {
                            var line = file.ReadLine()?.Trim();
                            if (string.IsNullOrEmpty(line))
                                break;
                            Console.WriteLine(line);
                            var addres = line.Substring(0, 4);
                            int value = 0;
                            if (!int.TryParse(addres, System.Globalization.NumberStyles.HexNumber, null, out value))
                            {
                                Console.WriteLine("Address Error");
                                break;
                            }
                            line = line.Remove(0, 5).Trim();
                            for (int i = 0; i < 16; i++)
                            {
                                var item = line.Substring(0, 2);
                                if (!int.TryParse(item, System.Globalization.NumberStyles.HexNumber, null, out value))
                                {
                                    throw new ApplicationException(String.Format("Error: {0}", item));
                                }
                                line = line.Remove(0, 2).Trim();
                                target.WriteByte((byte)value);
                            }
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                Console.WriteLine(ex.ToString());
            }
            Console.ReadLine();
        }

        private static void DisplayInfo()
        {
            Console.WriteLine(
@"hexpack file
  file       - путь к файлу
  hexpack ..\..\..\rom\ЮТ-88 Программатор ПЗУ.txt");
        }
    }
}

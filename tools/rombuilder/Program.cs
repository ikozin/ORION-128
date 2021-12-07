using System.Reflection;


namespace rombuilder
{
    class Program
    {
        static void Main(string[] args)
        {
            try
            {
                int romSize = 32 * 1024;
                string[] files = Array.Empty<string>(); ;
                string romName = "DUMP.BIN";
                string? romValues = null;
                if (args.Length == 0)
                {
                    Console.WriteLine("Перечень параметров: /s:<size> /a:<rom>,<rom> /o:<file> <values>");
                    Console.WriteLine("<size>\t\tразмер в килобайтах, по умолчанию: 32кБ");
                    Console.WriteLine("<rom>\t\tдополнительный образ");
                    Console.WriteLine("<file>\t\tимя образа, по умолчанию: DUMP.BIN");
                    Console.WriteLine("<values>\tперечень образов");
                    Console.WriteLine();
                }
                else
                {
                    foreach (var argument in args)
                    {
                        var param = argument.Substring(0, 3).ToLower();
                        switch (param)
                        {
                            case "/s:":
                                {
                                    if (!int.TryParse(argument.Substring(3), out romSize)) throw new ArgumentException(argument);
                                    romSize *= 1024;
                                    break;
                                }
                            case "/a:":
                                {
                                    files = argument.Substring(3).Trim('"').Split(',', StringSplitOptions.RemoveEmptyEntries);
                                    break;
                                }
                            case "/o:":
                                {
                                    romName = argument.Substring(3).Trim('"');
                                    break;
                                }
                            default:
                                {
                                    romValues = argument;
                                    break;
                                }
                        }
                    }
                }
                Console.WriteLine("Объем образа диска:{0}", romSize);

                Span<byte> rom = new byte[romSize];
                if (rom == null) throw new NullReferenceException(String.Format("Не удалось выделить память под образ диск: {0}", romSize));
                rom.Fill(0xFF);

                var assembly = Assembly.GetExecutingAssembly();
                if (assembly == null) throw new NullReferenceException("GetExecutingAssembly");

                Console.WriteLine("Перечень доступных ROM:");
                Console.WriteLine("0\tПусто (значения 0xFF)");
                int count = 1;
                var list = assembly.GetManifestResourceNames();
                foreach (var name in list)
                {
                    var title = String.Join('.', name.Split('.', StringSplitOptions.RemoveEmptyEntries).TakeLast(2));
                    Console.WriteLine("{0}\t{1}", count++, title);
                }
                foreach (var name in files)
                {
                    Console.WriteLine("{0}\t{1}", count++, name);
                }

                Console.WriteLine("Укажите порядок следования образов через запятую:");
                if (String.IsNullOrEmpty(romValues))
                {
                    romValues = Console.ReadLine();
                }
                else Console.WriteLine(romValues);
                if (String.IsNullOrEmpty(romValues)) return;

                int address = 0;
                var items = romValues.Split(new[] { ' ', ',' }, StringSplitOptions.RemoveEmptyEntries);
                foreach (var item in items)
                {
                    if (address >= romSize) throw new ApplicationException("Указано слишком много значений");
                    if (!int.TryParse(item, out int num)) throw new ArgumentException();
                    Console.Write("{0:X4}H-{1:X4}H:\t", address, address + 2048);

                    if (num == 0)
                    {
                        Console.WriteLine("Пусто (значения 0xFF)");
                    }
                    else
                    {
                        string title;
                        Stream stream;
                        num--;
                        if (num >= list.Length)
                        {
                            num -= list.Length;
                            if (num >= files.Length) throw new IndexOutOfRangeException();
                            string fileName = files[num];
                            if (!File.Exists(fileName)) throw new FileNotFoundException(fileName);
                            stream = File.OpenRead(fileName);
                            if (stream == null) throw new NullReferenceException(fileName);
                            title = fileName;
                        }
                        else
                        {
                            string resourceName = list[num];
#pragma warning disable CS8600 // Converting null literal or possible null value to non-nullable type.
                            stream = assembly.GetManifestResourceStream(resourceName);
#pragma warning restore CS8600 // Converting null literal or possible null value to non-nullable type.
                            if (stream == null) throw new NullReferenceException(resourceName);
                            title = String.Join('.', resourceName.Split('.', StringSplitOptions.RemoveEmptyEntries).TakeLast(2));
                        }
                        using BinaryReader reader = new BinaryReader(stream);
                        int size = reader!.Read(rom!.Slice(address, 2048));
                        stream.Dispose();
                        if (size != 2048) throw new ApplicationException(String.Format("Ошибка в размере: {0}", size));
                        Console.WriteLine(title);
                    }
                    address += 2048;
                }
                File.WriteAllBytes(romName, rom.ToArray());
                Console.WriteLine("Образ записан в файл {0}", romName);
            }
            catch (Exception ex)
            {
                Console.WriteLine(ex.Message);
            }
        }
    }
}

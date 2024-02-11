using System.CommandLine;
using System.Globalization;
using System.Text;

class BruFile
{
    const ushort headerSize = 16;
    public enum ExportType: int
    {
        Binary,
        Text
    }
    public enum ExportEncoding: int
    {
        KOI7N2,
        KOI8R,
        CP866
    }
    public static Command GetCommand()
    {
        var fileInfoExistsArgument = new Argument<FileInfo?>("file", CommandLine.Parsing.ParseFileInfoExistsOption,
            isDefault: true, description: "Имя BRU файла");


        var command = new Command("bru", "Действия с BRU файлами");

        var newCommand = new Command("new", "создать BRU файл");
        var fileNameNewArgument = new Argument<string>("file", description: "Имя BRU файла",
            parse: result =>
            {
                if (result.Tokens.Count == 0)
                {
                    result.ErrorMessage = "Не указано имя BRU файла";
                    return string.Empty;
                }
                string path = result.Tokens.Single().Value;
                if (!Path.GetExtension(path).Equals(".BRU", StringComparison.CurrentCultureIgnoreCase))
                {
                    result.ErrorMessage = "Имя файла не содержит расширение BRU";
                    return string.Empty;
                }
                return path;
            });
        newCommand.Add(fileNameNewArgument);
        var addressOption = new Option<int>("--address", description: "Адрес размещения файла в памяти",
            parseArgument: result =>
            {
                if (result.Tokens.Count == 0)
                {
                    result.ErrorMessage = "Значение адреса не указано";
                    return 0;
                }
                string value = result.Tokens.Single().Value;
                if (int.TryParse(value, out int address))
                {
                    return address;
                }
                if (int.TryParse(value, NumberStyles.HexNumber, CultureInfo.CurrentUICulture.NumberFormat, out address))
                {
                    return address;
                }
                return 0;
            })
            { 
                IsRequired = true
            };
        addressOption.AddAlias("-a");
        newCommand.Add(addressOption);
        var sourceOption = new Option<FileInfo?>("--source", description: "Исходный файл",
            parseArgument: CommandLine.Parsing.ParseFileInfoExistsOption)
            { 
                IsRequired = true
            };
        sourceOption.AddAlias("-s");
        newCommand.Add(sourceOption);
        newCommand.SetHandler(New, fileNameNewArgument, addressOption, sourceOption);
        command.Add(newCommand);

        var listommand = new Command("list", "Отобразить данные BRU файла")
        {
            fileInfoExistsArgument
        };
        listommand.SetHandler(List, fileInfoExistsArgument);
        command.Add(listommand);

        var extractCommand = new Command("extract", "Извлечь содержимое из BRU файла")
        {
            fileInfoExistsArgument
        };
        var fileNameOutOption = new Option<string>("--output", description: "Имя файла");
        fileNameOutOption.AddAlias("-o");
        extractCommand.Add(fileNameOutOption);
        var exportTypeOption = new Option<ExportType>("--type",
            description: "Преобразованин файла",
            getDefaultValue: () => ExportType.Binary);
        exportTypeOption.AddAlias("-t");
        extractCommand.Add(exportTypeOption);
        var exportTypeEncoding = new Option<ExportEncoding>("--encoding",
            description: "Кодировка файла",
            getDefaultValue: () => ExportEncoding.KOI7N2);
        exportTypeEncoding.AddAlias("-e");
        extractCommand.Add(exportTypeEncoding);

        extractCommand.SetHandler(Extract, fileInfoExistsArgument, fileNameOutOption, exportTypeOption,  exportTypeEncoding);
        command.Add(extractCommand);

        return command;
    }
    
    private static void New(string filename, int address, FileInfo? source)
    {
        byte[] content;
        using (FileStream stream = source!.OpenRead())
        using (BinaryReader reader = new(stream))
        {
            content = reader.ReadBytes((int)source!.Length);
        }
        using (FileStream stream = File.Create(filename))
        using (BinaryWriter writer = new(stream))
        {
            filename = Path.GetFileNameWithoutExtension(filename);
            if (filename.Length > 8)
            {
                filename = filename[..8];
            }
            filename = string.Format("{0,-8:S}", filename.ToUpper());
            var name = Encoding.ASCII.GetBytes(filename);
            ushort addr = (ushort)address;

            ushort size = (ushort)content.Length;
            int append = size & 0x0F;
            if (append > 0)
            {
                append = ((~append) & 0x0F) + 1;
                size += (ushort)append;
            }
            byte attr = 0;

            writer.Write(name);
            writer.Write(addr);
            writer.Write(size);
            writer.Write(attr);
            writer.Write((byte)0);
            writer.Write((byte)0);
            writer.Write((byte)0);
            writer.Write(content);
            for (int i = 0; i < append; i++)            
            {
                writer.Write((byte)0xFF);
            }
        }
    }
    
    private static void List(FileInfo? file)
    {
        const string bruListFormat = "| {0,-8:S} | {1,4:X4} | {2,5} | {3,3:X2}  |";
        try
        {
            if (file!.Length < headerSize)
            {
                throw new ApplicationException("Ошибка формата BRU файла");
            }

            using Stream stream = file.OpenRead();
            using BinaryReader reader = new(stream);
            var name = Encoding.ASCII.GetString(reader.ReadBytes(8)).Trim();
            var address = reader.ReadUInt16();
            var size = reader.ReadUInt16();
            var attribute = reader.ReadByte();
            var reserv = reader.ReadBytes(3);
            if (file.Length != size + headerSize)
            {
                throw new ApplicationException(string.Format("Ошибка размера файла \"{0}\"", file.Name));
            }
            Console.WriteLine("----------------------------------");
            Console.WriteLine("| FileName | Start | Size | Attr |");
            Console.WriteLine("----------------------------------");
            Console.WriteLine(bruListFormat, name, address, size, attribute);
            Console.WriteLine("----------------------------------");
        }
        catch (Exception ex)
        {
            Console.WriteLine(ex.Message);
        }
    }

    private static void Extract(FileInfo? file, string filename, ExportType type, ExportEncoding encoding)
    {
       try
        {
            if (file!.Length < headerSize)
            {
                throw new ApplicationException("Ошибка формата BRU файла");
            }

            byte[] content;
            using (Stream stream = file.OpenRead())
            using (BinaryReader reader = new (stream))
            {
                var name = Encoding.ASCII.GetString(reader.ReadBytes(8)).Trim();
                if (string.IsNullOrEmpty(filename))
                {
                    filename = name;
                }
                var address = reader.ReadUInt16();
                var size = reader.ReadUInt16();
                var attribute = reader.ReadByte();
                var reserv = reader.ReadBytes(3);
                if (file.Length != size + headerSize)
                {
                    throw new ApplicationException(string.Format("Ошибка размера файла \"{0}\"", file.Name));
                }
                content = reader.ReadBytes(size);
            }
            using (Stream stream = File.Create(filename))
            using (BinaryWriter writer = new(stream))
            {
                switch (type)
                {
                    case ExportType.Binary:
                    {
                        writer.Write(content);
                        break;
                    }
                    case ExportType.Text:
                    {
                        foreach (byte data in content)
                        {
                            if (data == 0xFF) break;
                            var symbol = encoding switch
                            {
                                ExportEncoding.KOI7N2 => EncodingExtension.Convert_Koi7N2(data, true),
                                ExportEncoding.KOI8R => EncodingExtension.Convert_Koi8R(data, true),
                                ExportEncoding.CP866 => EncodingExtension.Convert_Cp866(data, true),
                                _ => throw new ApplicationException(string.Format("Не известная кодировка: {0}", encoding.ToString())),
                            };
                            writer.Write(symbol);
                        }
                        break;
                    }
                    default:
                        throw new ApplicationException(string.Format("Не известный формат преобразования: {0}", type.ToString()));
                }
            }
        }
        catch (Exception ex)
        {
            Console.WriteLine(ex.Message);
        }
    }
}

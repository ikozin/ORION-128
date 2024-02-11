using System.CommandLine;
using System.Text;

public class RomFile
{
    const string loaderName = "boot.bin";
    const ushort loaderSize = 2048;

    public static Command GetCommand()
    {
        var command = new Command("rom", "Действия с ROM образами");

        var fileInfoExistsArgument = new Argument<FileInfo?>("file", CommandLine.Parsing.ParseFileInfoExistsOption,
            isDefault: true, description: "Имя файла с образом ROM диска");
        
        var newCommand = new Command("new", "Создать образ ROM диска");
        var fileNameNewArgument = new Argument<string>("file", description: "Имя файла с образом ROM диска", isDefault: true,
            parse: result =>
            {
                if (result.Tokens.Count == 0)
                {
                    return "romdisk.rom";
                }
                return result.Tokens.Single().Value;
            });
        newCommand.Add(fileNameNewArgument);
        var bootOption = new Option<FileInfo?>("--boot", CommandLine.Parsing.ParseFileInfoExistsOption,
            description: "Файл загрузчика образа ROM диска")
            {
                IsRequired = true
            };
        bootOption.AddAlias("-b");
        newCommand.Add(bootOption);
        var listArgument = new Option<FileInfo[]>("--list", CommandLine.Parsing.ParseFileInfoListOption,
            description: "Перечень BRU файлов для образа ROM диска" )
            {
                IsRequired = true,
                AllowMultipleArgumentsPerToken = true
            };
        listArgument.AddAlias("-l");
        newCommand.Add(listArgument);
        newCommand.SetHandler(New, fileNameNewArgument, bootOption, listArgument);
        command.Add(newCommand);

        var listCommand = new Command("list", "Отобразить содержимое образа ROM диска")
        {
            fileInfoExistsArgument
        };
        listCommand.SetHandler(List, fileInfoExistsArgument);
        command.Add(listCommand);

        var extractCommand = new Command("extract", "Извлечь содержимое из образа ROM диска")
        {
            fileInfoExistsArgument
        };
        var directoryRomOption = new Option<string>("--dir", CommandLine.Parsing.ParseDirectoryOption,
            isDefault: true,
            description: "Директория c BRU файлами образа ROM диска");
        directoryRomOption.AddAlias("-d");
        extractCommand.Add(directoryRomOption);
        extractCommand.SetHandler(Extract, fileInfoExistsArgument, directoryRomOption);
        command.Add(extractCommand);

        return command;
    }

    private static void New(string file, FileInfo? boot, FileInfo[] list)
    {
        try
        {
            if (boot!.Length != loaderSize)
            {
                throw new ApplicationException(string.Format("Неверный размер загрузчика: \"{0}\"", boot.FullName));
            }
            using FileStream stream = File.Create(file);
            using BinaryWriter writer = new(stream);
            writer.Write(File.ReadAllBytes(boot.FullName));
            foreach (var info in list)
            {
                if ((info.Length & 0x000F) != 0)
                {
                    throw new ApplicationException(string.Format("Длина файла \"{0}}\" не выровнена", info.FullName));
                }
                writer.Write(File.ReadAllBytes(info.FullName));
            }
            writer.Close();
        }
        catch (Exception ex)
        {
            Console.WriteLine(ex.Message);
        }
    }
    
    private static void List(FileInfo? file)
    {
        const string romListFormat = "| {0,-8:S} | {1,4:X4} | {2,5} | {3,3:X2}  |";
        try
        {
            if (file!.Length < loaderSize)
            {
                throw new ApplicationException("Ошибка формата образа ROM диска");
            }

            Console.WriteLine("----------------------------------");
            Console.WriteLine("| FileName | Start | Size | Attr |");
            Console.WriteLine("----------------------------------");

            using (Stream stream = file.OpenRead())
            using (BinaryReader reader = new (stream))
            {
                Console.WriteLine(romListFormat, loaderName, null, loaderSize, null);
                reader.BaseStream.Seek(loaderSize, SeekOrigin.Begin);
                while (reader.BaseStream.Position < file.Length)
                {
                    var name = Encoding.ASCII.GetString(reader.ReadBytes(8)).Trim();
                    var address = reader.ReadUInt16();
                    var size = reader.ReadUInt16();
                    var attribute = reader.ReadByte();
                    var reserv = reader.ReadBytes(3);
                    reader.BaseStream.Seek(size, SeekOrigin.Current);
                    Console.WriteLine(romListFormat, name, address, size, attribute);
                }

            }
            Console.WriteLine("----------------------------------");
        }
        catch (Exception ex)
        {
            Console.WriteLine(ex.Message);
        }
    }
 
    private static void Extract(FileInfo? file, string path)
    {
        try
        {
            if (file!.Length < loaderSize)
            {
                throw new ApplicationException("Ошибка формата образа ROM диска");
            }
            if (!Directory.Exists(path))
            {
                Directory.CreateDirectory(path);
            }
            using Stream stream = file.OpenRead();
            using BinaryReader reader = new(stream);
            File.WriteAllBytes(Path.Join(path, loaderName), reader.ReadBytes(loaderSize));
            while (reader.BaseStream.Position < file.Length)
            {
                var name = Encoding.ASCII.GetString(reader.ReadBytes(8)).Trim();
                var address = reader.ReadUInt16();
                var size = reader.ReadUInt16();
                var attribute = reader.ReadByte();
                var reserv = reader.ReadBytes(3);
                reader.BaseStream.Seek(-16, SeekOrigin.Current);
                File.WriteAllBytes(Path.Join(path, name + ".bru"), reader.ReadBytes(size + 16));
            }
        }
        catch (Exception ex)
        {
            Console.WriteLine(ex.Message);
        }
    }
}
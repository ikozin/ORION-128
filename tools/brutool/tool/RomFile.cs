using System.CommandLine;
using System.Text;

namespace brutool;

public class RomFile
{
    const string loaderName = "boot.bin";
    const ushort loaderSize = 2048;
    const int MaxRomSize = 0xFFFF;


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
        var indexRomOption = new Option<int>("--rom"
            ,description: "Индекс ROM образа в файле"
            ,isDefault: true
            ,parseArgument: result =>
            {
                if (result.Tokens.Count == 0)
                {
                    return -1;
                }
                return int.TryParse(result.Tokens.Single().Value, out int value) ? value : 0;;
            });
        indexRomOption.AddAlias("-r");
        extractCommand.Add(indexRomOption);

        var directoryRomOption = new Option<string>("--dir", CommandLine.Parsing.ParseDirectoryOption,
            isDefault: true,
            description: "Директория c BRU файлами образа ROM диска");
        directoryRomOption.AddAlias("-d");
        extractCommand.Add(directoryRomOption);
        extractCommand.SetHandler(Extract, fileInfoExistsArgument, indexRomOption, directoryRomOption);
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
            long size = 0;
            foreach (var info in list)
            {
                if ((info.Length & 0x000F) != 0)
                {
                    throw new ApplicationException(string.Format("Длина файла \"{0}\" не выровнена", info.FullName));
                }
                size += info.Length;
            }
            if (size + loaderSize > MaxRomSize)
            {
                throw new ApplicationException(string.Format("Общмй размер файлов:{0}, превышает емкость ROM диска", size + loaderSize));
            }
            using FileStream stream = File.Create(file);
            using BinaryWriter writer = new(stream);
            writer.Write(File.ReadAllBytes(boot.FullName));
            foreach (var info in list)
            {
                writer.Write(File.ReadAllBytes(info.FullName));
            }
            while (stream.Position <= MaxRomSize)
                writer.Write((byte)0xFF);

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

            int romIndex = 0;
            using (Stream stream = file.OpenRead())
            using (BinaryReader reader = new (stream))
            {
                while (reader.BaseStream.Position < file.Length)
                {
                    long start = 0;
                    Console.WriteLine("ROM = {0}", romIndex++);
                    Console.WriteLine("----------------------------------");
                    Console.WriteLine("| FileName | Start | Size | Attr |");
                    Console.WriteLine("----------------------------------");
                    Console.WriteLine(romListFormat, loaderName, null, loaderSize, null);
                    reader.BaseStream.Seek(loaderSize, SeekOrigin.Current);
                    while (start < MaxRomSize && reader.BaseStream.Position < file.Length)
                    {
                        start += 16;
                        var name = Encoding.ASCII.GetString(reader.ReadBytes(8)).Trim();
                        var address = reader.ReadUInt16();
                        var size = reader.ReadUInt16();
                        var attribute = reader.ReadByte();
                        var reserv = reader.ReadBytes(3);
                        if (size == MaxRomSize) break;
                        start += size;
                        reader.BaseStream.Seek(size, SeekOrigin.Current);
                        Console.WriteLine(romListFormat, name, address, size, attribute);
                    }
                    Console.WriteLine("----------------------------------");
                    Console.WriteLine();
                    
                    long pos = ((reader.BaseStream.Position >> 16) + 1) << 16;
                    if (pos >= file.Length ) break;
                    reader.BaseStream.Seek(pos, SeekOrigin.Begin);
                }
            }
        }
        catch (Exception ex)
        {
            Console.WriteLine(ex.Message);
        }
    }
 
    private static void Extract(FileInfo? file, int indexRom, string path)
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
            int currentRom = 0;
            while (true)
            {
                Console.WriteLine("ROM: {0}", currentRom);
                if (currentRom == indexRom || indexRom == -1)
                {
                    long start = 0;
                    File.WriteAllBytes(Path.Join(path, loaderName), reader.ReadBytes(loaderSize));
                    while (start < MaxRomSize && reader.BaseStream.Position < file.Length)
                    {
                        start += 16;
                        var name = Encoding.ASCII.GetString(reader.ReadBytes(8)).Trim();
                        var address = reader.ReadUInt16();
                        var size = reader.ReadUInt16();
                        var attribute = reader.ReadByte();
                        var reserv = reader.ReadBytes(3);
                        if (size == MaxRomSize) break;
                        start += size;
                        reader.BaseStream.Seek(-16, SeekOrigin.Current);
                        try
                        {
                            Console.WriteLine("Extract: {0}", name);
                            File.WriteAllBytes(Path.Join(path, name + ".bru"), reader.ReadBytes(size + 16));
                        }
                        catch (System.IO.IOException ex)
                        {
                            Console.WriteLine(ex.Message);
                            Console.WriteLine("Адрес: {0}", reader.BaseStream.Position);
                        }
                    }
                }
                Console.WriteLine();
                if (reader.BaseStream.Length <= currentRom * (MaxRomSize + 1))
                {
                    break;
                }
                reader.BaseStream.Seek(currentRom * (MaxRomSize + 1), SeekOrigin.Begin);
                currentRom ++;
            }
        }
        catch (Exception ex)
        {
            Console.WriteLine(ex.Message);
        }
    }
}
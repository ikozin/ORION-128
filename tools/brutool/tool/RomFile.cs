using System.CommandLine;
using System.Text;

namespace brutool.tool;

public class RomFile
{
    const string loaderName = "boot.bin";
    const ushort loaderSize = 2048;
    const int MaxRomSize = 0x10000; //0xFFFF;

    public static Command GetCommand()
    {
        var fileInfoExistsArgument = new Argument<FileInfo?>("file")
        {
            Arity = ArgumentArity.ZeroOrOne,
            Description = "Имя файла с образом ROM диска",
            DefaultValueFactory = Parsing.ParseFileInfoExistsOption,
        };

///////////////////////////////////////////////////////////////////////////////////////////////

        var fileNameNewArgument = new Argument<string>("file")
        {
            Arity = ArgumentArity.ZeroOrOne,
            Description = "Имя файла с образом ROM диска",
            DefaultValueFactory = result =>
            {
                if (result.Tokens.Count == 0)
                {
                    return "romdisk.rom";
                }
                return result.Tokens.Single().Value;
            },
        };
        var bootOption = new Option<FileInfo?>("--boot", "-b")
        {
            Arity = ArgumentArity.ExactlyOne,
            Description = "Файл загрузчика образа ROM диска",
            Required = true,
            DefaultValueFactory = Parsing.ParseFileInfoExistsOption,

        };
        var listOption = new Option<FileInfo[]>("--list", "-l")
        {
            Arity = ArgumentArity.ExactlyOne,
            Description = "Перечень BRU файлов для образа ROM диска",
            Required = true,
            AllowMultipleArgumentsPerToken = true,
            DefaultValueFactory = Parsing.ParseFileInfoListOption,
        };
        var newCommand = new Command("new", "Создать образ ROM диска")
        {
            Arguments = { fileNameNewArgument },
            Options = { bootOption, listOption },
        };
        newCommand.SetAction(result =>
        {
            string file = result.GetValue(fileNameNewArgument)!;
            FileInfo? boot = result.GetValue(bootOption);
            FileInfo[] list = result.GetValue(listOption)!;
            New(file, boot, list);
        });

///////////////////////////////////////////////////////////////////////////////////////////////

        var listCommand = new Command("list", "Отобразить содержимое образа ROM диска")
        {
            Arguments = { fileInfoExistsArgument },
        };
        listCommand.SetAction(result =>
        {
            FileInfo? file = result.GetValue(fileInfoExistsArgument);
            List(file);
        });

///////////////////////////////////////////////////////////////////////////////////////////////

        var indexRomOption = new Option<int>("--rom", "-r")
        {
            Arity = ArgumentArity.ExactlyOne,
            Description = "Индекс ROM образа в файле",
            DefaultValueFactory = result =>
            {
                if (result.Tokens.Count == 0)
                {
                    return -1;
                }
                return int.TryParse(result.Tokens.Single().Value, out int value) ? value : 0;
            },
        };
        var directoryRomOption = new Option<string>("--dir", "-d")
        {
            Arity = ArgumentArity.ZeroOrOne,
            Description = "Директория c BRU файлами образа ROM диска",
            DefaultValueFactory = Parsing.ParseDirectoryOption,
        };
        var extractCommand = new Command("extract", "Извлечь содержимое из образа ROM диска")
        {
            Arguments = { fileInfoExistsArgument },
            Options = { indexRomOption, directoryRomOption },
        };
        extractCommand.SetAction(result =>
        {
            FileInfo? file = result.GetValue(fileInfoExistsArgument);
            int indexRom = result.GetValue(indexRomOption);
            string path = result.GetValue(directoryRomOption)!;
            Extract(file, indexRom, path);
        });

///////////////////////////////////////////////////////////////////////////////////////////////

        var command = new Command("rom", "Действия с ROM образами");
        command.Subcommands.Add(newCommand);
        command.Subcommands.Add(listCommand);
        command.Subcommands.Add(extractCommand);

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
            while (stream.Position < MaxRomSize)
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
            using Stream stream = file.OpenRead();
            using BinaryReader reader = new(stream);
            while (reader.BaseStream.Position < file.Length)
            {
                Console.WriteLine("ROM = {0}, file pos: 0x{1:X4}", romIndex++, reader.BaseStream.Position);
                Console.WriteLine("----------------------------------");
                Console.WriteLine("| FileName | Start | Size | Attr |");
                Console.WriteLine("----------------------------------");
                Console.WriteLine(romListFormat, loaderName, null, loaderSize, null);
                reader.BaseStream.Seek(loaderSize, SeekOrigin.Current);
                long start = loaderSize;
                while (start < MaxRomSize && reader.BaseStream.Position < file.Length)
                {
                    byte[] data = reader.ReadBytes(8);
                    if (data[0] == 0xFF) break;
                    var name = Encoding.ASCII.GetString(data).Trim();
                    var address = reader.ReadUInt16();
                    var size = reader.ReadUInt16();
                    var attribute = reader.ReadByte();
                    var reserv = reader.ReadBytes(3);
                    start += size + 16;
                    if (start > MaxRomSize)
                    {
                        Console.ForegroundColor = ConsoleColor.Red;
                        Console.WriteLine(romListFormat, name, address, size, attribute);
                        Console.ResetColor();
                        break;
                    }
                    reader.BaseStream.Seek(size, SeekOrigin.Current);
                    Console.WriteLine(romListFormat, name, address, size, attribute);
                }
                Console.WriteLine("----------------------------------");
                Console.WriteLine();

                long pos = ((reader.BaseStream.Position >> 16) + 1) << 16;
                if (pos >= file.Length) break;
                reader.BaseStream.Seek(pos, SeekOrigin.Begin);
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
                    File.WriteAllBytes(Path.Join(path, loaderName), reader.ReadBytes(loaderSize));
                    long start = loaderSize;
                    while (start < MaxRomSize && reader.BaseStream.Position < file.Length)
                    {
                        byte[] data = reader.ReadBytes(8);
                        if (data[0] == 0xFF) break;
                        var name = Encoding.ASCII.GetString(data).Trim();
                        var address = reader.ReadUInt16();
                        var size = reader.ReadUInt16();
                        var attribute = reader.ReadByte();
                        var reserv = reader.ReadBytes(3);
                        start += size + 16;
                        if (start > MaxRomSize) {
                            Console.ForegroundColor = ConsoleColor.Red;
                            Console.WriteLine("Extract: {0}, ошибка размера", name);
                            Console.ResetColor();
                            break;
                        }
                        try
                        {
                            Console.WriteLine("Extract: {0}", name);
                            reader.BaseStream.Seek(-16, SeekOrigin.Current);
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
                if (reader.BaseStream.Length <= currentRom * MaxRomSize)
                {
                    break;
                }
                reader.BaseStream.Seek(currentRom * MaxRomSize, SeekOrigin.Begin);
                currentRom ++;
            }
        }
        catch (Exception ex)
        {
            Console.WriteLine(ex.Message);
        }
    }
}
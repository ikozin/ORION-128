using System.CommandLine;
using System.Net;
namespace brutool.tool;

public class BinFile
{
    public static Command GetCommand()
    {

        var fileInfoExistsArgument = new Argument<FileInfo?>("file")
        {
            Arity = ArgumentArity.ZeroOrOne,
            Description = "Имя файла",
            DefaultValueFactory = Parsing.ParseFileInfoExistsOption,
        };

///////////////////////////////////////////////////////////////////////////////////////////////

        var fileNameNewArgument = new Argument<string>("file")
        {
            Arity = ArgumentArity.ZeroOrOne,
            Description = "Имя файла",
            DefaultValueFactory = result =>
            {
                return result.Tokens.Single().Value;
            },
        };
        var alignSizeOption = new Option<long>("--align", "-a")
        {
            Arity = ArgumentArity.ExactlyOne,
            Description = "Размер выравнивания",
            DefaultValueFactory = result =>
            {
                if (result.Tokens.Count == 0)
                {
                    return 0;
                }
                return long.TryParse(result.Tokens.Single().Value, out long value) ? value : 0;
            },
        };
        var listOption = new Option<FileInfo[]>("--list", "-l")
        {
            Arity = ArgumentArity.ExactlyOne,
            Description = "Список файлов",
            Required = true,
            AllowMultipleArgumentsPerToken = true,
            DefaultValueFactory = Parsing.ParseFileInfoListOption,
        };
        var newCommand = new Command("new", "Создать файл из списка")
        { 
            Arguments = { fileNameNewArgument },
            Options = { alignSizeOption, listOption },
        };
        newCommand.SetAction(result =>
        {
            string file = result.GetValue(fileNameNewArgument)!;
            long align = result.GetValue(alignSizeOption);
            FileInfo[] list = result.GetValue(listOption)!;
            New(file, align, list);
        });

///////////////////////////////////////////////////////////////////////////////////////////////


        var indexSizeOption = new Option<uint>("--size", "-s")
        {
            Arity = ArgumentArity.ExactlyOne,
            Description = "Размер извлекаемых данных",
            Required = true,
            DefaultValueFactory = result =>
            {
                return uint.TryParse(result.Tokens.Single().Value, out uint value)
                    ? value
                    : throw new ApplicationException("Неверное значение размера извлекаемых данных");
            },
        };
        var indexAddressOption = new Option<uint>("--address", "-a")
        {
            Arity = ArgumentArity.ExactlyOne,
            Description = "Адрес начала данных",
            Required = false,
            DefaultValueFactory = result =>
            {
                if (result.Tokens.Count == 0)
                {
                    return 0;
                }
                return uint.TryParse(result.Tokens.Single().Value, out uint value)
                    ? value
                    : throw new ApplicationException("Неверный адрес начала данных");
            }
        };

        var fileNameOutOption = new Option<string>("--output", "-o")
        {
            Arity = ArgumentArity.ExactlyOne,
            Required = true,
            Description = "Имя файла"
        };
        var extractCommand = new Command("extract", "Извлечь содержимое из файла")
        {
            Arguments = { fileInfoExistsArgument },
            Options = { indexSizeOption, indexAddressOption, fileNameOutOption },
        };
        extractCommand.SetAction(result =>
        {
            FileInfo? file = result.GetValue(fileInfoExistsArgument);
            uint size = result.GetValue(indexSizeOption);
            uint address = result.GetValue(indexAddressOption);
            string filename = result.GetValue(fileNameOutOption)!;
            Extract(file, size, address, filename);
        });

///////////////////////////////////////////////////////////////////////////////////////////////

        var command = new Command("bin", "Действия с файлом");
        command.Subcommands.Add(newCommand);
        command.Subcommands.Add(extractCommand);

        return command;
    }

    private static void New(string file, long align, FileInfo[] list)
    {
        try
        {
            using FileStream stream = File.Create(file);
            using BinaryWriter writer = new(stream);
            foreach (var info in list)
            {
                writer.Write(File.ReadAllBytes(info.FullName));
                if (align >= 2)
                {
                    var item = new FileInfo(info.FullName);
                    long append = item.Length % align;
                    if (append > 0)
                    {
                        append = align - append;
                        writer.Write(Enumerable.Repeat<byte>(0xFF, (int)append).ToArray());
                    }
                }
            }
            writer.Close();
        }
        catch (Exception ex)
        {
            Console.WriteLine(ex.Message);
        }
    }

    private static void Extract(FileInfo? file, uint size, uint address, string filename)
    {
        try
        {
            using FileStream stream = file!.OpenRead();
            using BinaryReader reader = new(stream);
            stream.Seek(address, SeekOrigin.Begin);
            File.WriteAllBytes(filename, reader.ReadBytes((int)size));
        }
        catch (Exception ex)
        {
            Console.WriteLine(ex.Message);
        }
    }
}

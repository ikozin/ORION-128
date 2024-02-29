using System.CommandLine;
namespace brutool;

public class BinFile
{
    public static Command GetCommand()
    {
        var command = new Command("bin", "Действия с файлом");

        var fileInfoExistsArgument = new Argument<FileInfo?>("file", CommandLine.Parsing.ParseFileInfoExistsOption,
            isDefault: false, description: "Имя файла");
        
        var newCommand = new Command("new", "Создать файл из списка");
        var fileNameNewArgument = new Argument<string>("file", description: "Имя файла", isDefault: false,
            parse: result =>
            {
                return result.Tokens.Single().Value;
            });
        newCommand.Add(fileNameNewArgument);

        var alignSizeArgument = new Option<long>("--align", description: "Размер выравнивания", isDefault: true,
            parseArgument: result =>
            {
                if (result.Tokens.Count == 0)
                {
                    return 0;
                }
                return long.TryParse(result.Tokens.Single().Value, out long value) ? value : 0;;
            });
        alignSizeArgument.AddAlias("-a");
        newCommand.Add(alignSizeArgument);

        var listArgument = new Option<FileInfo[]>("--list", CommandLine.Parsing.ParseFileInfoListOption,
            description: "Список файлов" )
            {
                IsRequired = true,
                AllowMultipleArgumentsPerToken = true
            };
        listArgument.AddAlias("-l");
        newCommand.Add(listArgument);
        newCommand.SetHandler(New, fileNameNewArgument, alignSizeArgument, listArgument);
        command.Add(newCommand);

        var extractCommand = new Command("extract", "Извлечь содержимое из файла")
        {
            fileInfoExistsArgument
        };
        var indexSizeOption = new Option<uint>("--size"
            ,description: "Размер извлекаемых данных"
            ,isDefault: false
            ,parseArgument: result =>
            {
                return uint.TryParse(result.Tokens.Single().Value, out uint value) 
                    ? value
                    : throw new ApplicationException("Неверное значение размера извлекаемых данных");
            })
        {
            IsRequired = true
        };
        indexSizeOption.AddAlias("-s");
        extractCommand.Add(indexSizeOption);

        var indexAddressOption = new Option<uint>("--address"
            ,description: "Адрес начала данных"
            ,isDefault: true
            ,parseArgument: result =>
            {
                if (result.Tokens.Count == 0)
                {
                    return 0;
                }
                return uint.TryParse(result.Tokens.Single().Value, out uint value) 
                    ? value
                    : throw new ApplicationException("Неверный адрес начала данных");
            });
        indexAddressOption.AddAlias("-a");
        extractCommand.Add(indexAddressOption);

        var fileNameOutOption = new Option<string>("--output", description: "Имя файла")
        {
            IsRequired = true
        };
        fileNameOutOption.AddAlias("-o");
        extractCommand.Add(fileNameOutOption);

        extractCommand.SetHandler(Extract, fileInfoExistsArgument, indexSizeOption, indexAddressOption, fileNameOutOption);
        command.Add(extractCommand);

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

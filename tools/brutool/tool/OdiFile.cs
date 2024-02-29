using System.CommandLine;
using System.Text;

namespace brutool;

public static class OdiFile
{
    private const int DIR_ENTRY = 128;
    private const int BASE = 0x5000;
    private const int EXTSIZEINBYTES = 0x800;
    private const int EXT_SIZE = 128;

    public class OdiFileEntry
    {
        public byte User { get; private set; }
        public byte[] Name { get; private set; }
        public byte[] Ext { get; private set; }
        public byte RecNo { get; private set; }
        public byte Rezerv1 { get; private set; }
        public byte Rezerv2 { get; private set; }
        public byte ExtSize { get; private set; }

        public ushort[] Extent;     //16 байт, 8 слов
        public string FileName { get; private set; }    // 8 байт - имя, 3 байта - расширение

        public OdiFileEntry(BinaryReader reader)
        {
            User = reader.ReadByte();
            Name = reader.ReadBytes(8);
            Ext = reader.ReadBytes(3);
            FileName = String.Format("{0}.{1}", Encoding.ASCII.GetString(Name).Trim(), Encoding.ASCII.GetString(Ext).Trim());

            RecNo = reader.ReadByte();
            Rezerv1 = reader.ReadByte();
            Rezerv2 = reader.ReadByte();
            ExtSize = reader.ReadByte();
            Extent = new ushort[8];
            for (int i = 0; i < Extent.Length; i++)
            {
                Extent[i] = reader.ReadUInt16();
            }
        }
    }

    public static Command GetCommand()
    {
        var fileInfoExistsArgument = new Argument<FileInfo?>("file", CommandLine.Parsing.ParseFileInfoExistsOption,
            isDefault: true, description: "Имя ODI файла");


        var command = new Command("odi", "Действия с ODI файлами");

        // var newCommand = new Command("new", "создать BRU файл");
        // var fileNameNewArgument = new Argument<string>("file", description: "Имя BRU файла",
        //     parse: result =>
        //     {
        //         if (result.Tokens.Count == 0)
        //         {
        //             result.ErrorMessage = "Не указано имя BRU файла";
        //             return string.Empty;
        //         }
        //         string path = result.Tokens.Single().Value;
        //         if (!Path.GetExtension(path).Equals(".BRU", StringComparison.CurrentCultureIgnoreCase))
        //         {
        //             result.ErrorMessage = "Имя файла не содержит расширение BRU";
        //             return string.Empty;
        //         }
        //         return path;
        //     });
        // newCommand.Add(fileNameNewArgument);
        // var addressOption = new Option<int>("--address", description: "Адрес размещения файла в памяти",
        //     parseArgument: result =>
        //     {
        //         if (result.Tokens.Count == 0)
        //         {
        //             result.ErrorMessage = "Значение адреса не указано";
        //             return 0;
        //         }
        //         string value = result.Tokens.Single().Value;
        //         if (int.TryParse(value, out int address))
        //         {
        //             return address;
        //         }
        //         if (int.TryParse(value, NumberStyles.HexNumber, CultureInfo.CurrentUICulture.NumberFormat, out address))
        //         {
        //             return address;
        //         }
        //         return 0;
        //     })
        //     { 
        //         IsRequired = true
        //     };
        // addressOption.AddAlias("-a");
        // newCommand.Add(addressOption);
        // var sourceOption = new Option<FileInfo?>("--source", description: "Исходный файл",
        //     parseArgument: CommandLine.Parsing.ParseFileInfoExistsOption)
        //     { 
        //         IsRequired = true
        //     };
        // sourceOption.AddAlias("-s");
        // newCommand.Add(sourceOption);
        // newCommand.SetHandler(New, fileNameNewArgument, addressOption, sourceOption);
        // command.Add(newCommand);

        var listommand = new Command("list", "Отобразить данные ODI файла")
        {
            fileInfoExistsArgument
        };
        listommand.SetHandler(List, fileInfoExistsArgument);
        command.Add(listommand);

        var extractCommand = new Command("extract", "Извлечь содержимое из ODI файла")
        {
            fileInfoExistsArgument
        };
        var fileNameExtactOption = new Option<string>("--file", description: "Имя файла для извлечения")
        {
            IsRequired = true
        };
        fileNameExtactOption.AddAlias("-f");
        extractCommand.Add(fileNameExtactOption);
        var fileNameOutputOption = new Option<string>("--out", description: "Имя файла для сохранения")
        {
            IsRequired = true
        };
        fileNameOutputOption.AddAlias("-o");
        extractCommand.Add(fileNameOutputOption);
        extractCommand.SetHandler(Extract, fileInfoExistsArgument, fileNameExtactOption, fileNameOutputOption);
        command.Add(extractCommand);

        return command;
    }
    
    private static long ext_offset(int extent)
    {
        return (long)BASE + (long)extent * (long)EXTSIZEINBYTES;
    }
    
    public static List<OdiFileEntry> GetOdiFileEntries(this BinaryReader reader)
    {
        var entries = new List<OdiFileEntry>();
        reader.BaseStream.Position = ext_offset(0);
        entries.LoadFileInfo(reader);
        reader.BaseStream.Position = ext_offset(1);
        entries.LoadFileInfo(reader);
        return entries;
    }

    public static void LoadFileInfo(this List<OdiFileEntry> list, BinaryReader reader)
    {
        for (int i = 0; i < DIR_ENTRY; i++)
        {
            var item = new OdiFileEntry(reader);
            if (item.User == 0xE5) break;
            list.Add(item);
        }
    }
    private static MemoryStream ExtractFile(this OdiFileEntry entry, BinaryReader reader, List<OdiFileEntry> entryList)
    {
        var records = entryList
            .Where(e => e.FileName == entry.FileName)
            .OrderBy(e => e.RecNo)
            .ToArray();
        List<byte> data = new();
        foreach (OdiFileEntry record in records)
        {
            for (int i = 0; i < record.Extent.Length; i++)
            {
                if (record.Extent[i] == 0) break;

                long offset = ext_offset(record.Extent[i]);
                reader.BaseStream.Position = offset;
                var size = entry.ExtSize;
                for (int n = 0; n < 16; n++)
                {
                    reader.BaseStream.Position = offset + n * EXT_SIZE;
                    data.AddRange(reader.ReadBytes(EXT_SIZE));
                    if (--size == 0) break;
                }
            }
        }
        return new MemoryStream(data.ToArray());
    }

    private static void List(FileInfo? file)
    {
        const string odiListFormat = "| {0,-12:S} |";
        try
        {
            if (file!.Length != 819200)
            {
                throw new ApplicationException("Ошибка формата ODI файла");
            }

            Console.WriteLine("----------------");
            Console.WriteLine("| FileName     |");
            Console.WriteLine("----------------");
            using Stream stream = file.OpenRead();
            using BinaryReader reader = new(stream);
            List<OdiFileEntry> entryList = reader.GetOdiFileEntries();
            var odiList = entryList.Where(d => d.User != 0xE5 && d.RecNo == 0 && d.Name[0] != ' ');
            foreach (OdiFileEntry entry in odiList)
            {
                Console.WriteLine(odiListFormat, entry.FileName);
            }
            Console.WriteLine("----------------");
        }
        catch (Exception ex)
        {
            Console.WriteLine(ex.Message);
        }
    }
    
    private static void Extract(FileInfo? file, string filename, string outfilename)
    {
        try
        {
            if (file!.Length != 819200)
            {
                throw new ApplicationException("Ошибка формата ODI файла");
            }

            using Stream stream = file.OpenRead();
            using BinaryReader reader = new(stream);
            List<OdiFileEntry> entryList = reader.GetOdiFileEntries();
            var item = entryList.Where(d => d.User != 0xE5 && d.RecNo == 0 && d.Name[0] != ' ')
                .First(d => d.FileName.ToUpper() == filename.ToUpper());
            if (item == null) throw new ApplicationException(string.Format("Файл {0} не найден", filename));
            using var memory = item.ExtractFile(reader, entryList);
                File.WriteAllBytes(outfilename, memory.ToArray());
        }
        catch (Exception ex)
        {
            Console.WriteLine(ex.Message);
        }
    }

}

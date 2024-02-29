using SixLabors.ImageSharp;
using SixLabors.ImageSharp.ColorSpaces;
using SixLabors.ImageSharp.Formats;
using SixLabors.ImageSharp.PixelFormats;
using System.CommandLine;
using System.Globalization;
using System.Text;

namespace brutool;

class BruFile
{
    const ushort headerSize = 16;
    public enum ExportType: int
    {
        Binary,
        Text,
        Basic,
        Picture,
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
            description: "Имя BRU файла");

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
            if (file.Length <= size)
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

            ushort address;
            ushort size;
            byte attribute;
            byte[] content;

            using (Stream streamRead = file.OpenRead())
            using (BinaryReader reader = new (streamRead))
            {
                var name = Encoding.ASCII.GetString(reader.ReadBytes(8)).Trim();
                if (string.IsNullOrEmpty(filename))
                {
                    filename = name;
                }
                address = reader.ReadUInt16();
                size = reader.ReadUInt16();
                attribute = reader.ReadByte();
                var reserv = reader.ReadBytes(3);
                if (file.Length < size)
                {
                    throw new ApplicationException(string.Format("Ошибка размера файла \"{0}\"", file.Name));
                }
                content = reader.ReadBytes(size);
            }
            using (Stream streamWrite = File.Create(filename))
            using (BinaryWriter writer = new (streamWrite))
            {
                Action<BinaryWriter, byte[], ushort, byte, ExportEncoding> action = type switch
                {
                    ExportType.Binary => ExtractBinary,
                    ExportType.Text => ExtractText,
                    ExportType.Basic => ExtractBasic,
                    ExportType.Picture => ExtractPicture,
                    _ => throw new ApplicationException(string.Format("Не известный формат преобразования: {0}", type.ToString()))
                };
                action(writer, content, address, attribute, encoding);
            }
        }
        catch (Exception ex)
        {
            Console.WriteLine(ex.Message);
        }
    }

    private static void ExtractBinary(BinaryWriter writer, byte[] content,
        ushort address, byte attribute, ExportEncoding encoding)
    {
        writer.Write(content);
    }

    private static void ExtractText(BinaryWriter writer, byte[] content,
        ushort address, byte _, ExportEncoding encoding)
    {
        foreach (byte data in content)
        {
            if (data == 0xFF) break;
            char symbol = GetEncodedSymbol(encoding, data);
            if (symbol == '\n')
            {
                writer.Write(Environment.NewLine);
                continue;
            }
            writer.Write(symbol);
        }
    }

    private static void ExtractBasic(BinaryWriter writer, byte[] content,
        ushort address,  byte attribute, ExportEncoding encoding)
    {
#region  _vacabular
        Dictionary<byte, string> _vacabular = new Dictionary<byte, string>()
        {
            { 0x80, "CLS" },
            { 0x81, "FOR" },
            { 0x82, "NEXT" },
            { 0x83, "DATA" },
            { 0x84, "INPUT" },
            { 0x85, "DIM" },
            { 0x86, "READ" },
            { 0x87, "CUR" },
            { 0x88, "GOTO" },
            { 0x89, "RUN" },
            { 0x8A, "IF" },
            { 0x8B, "RESTORE" },
            { 0x8C, "GOSUB" },
            { 0x8D, "RETURN" },
            { 0x8E, "REM" },
            { 0x8F, "STOP" },
            { 0x90, "DPL" },
            { 0x91, "ON" },
            { 0x92, "PSET" },
            { 0x93, "LINE" },
            { 0x94, "POKE" },
            { 0x95, "PRINT" },
            { 0x96, "DEF" },
            { 0x97, "CONT" },
            { 0x98, "LIST" },
            { 0x99, "CLEAR" },
            { 0x9A, "LLIST" },
            { 0x9B, "LPRINT" },
            { 0x9C, "NEW" },
            { 0x9D, "EDIT" },
            { 0x9E, "COLOR" },
            { 0x9F, "BOX" },
            { 0xA0, "SCREEN" },
            { 0xA1, "PAINT" },
            { 0xA2, "SYSTEM" },
            { 0xA3, "SAVE" },
            { 0xA4, "LOAD" },
            { 0xA5, "FILES" },
            { 0xA6, "KILL" },

            { 0xA7, "TAB(" },
            { 0xA8, "TO" },
            { 0xA9, "SPC(" },
            { 0xAA, "FN" },
            { 0xAB, "THEN" },
            { 0xAC, "NOT" },
            { 0xAD, "STEP" },

            { 0xAE, "+" },
            { 0xAF, "-" },
            { 0xB0, "*" },
            { 0xB1, "/" },
            { 0xB2, "^" },
            { 0xB3, "AND" },
            { 0xB4, "OR" },
            { 0xB5, ">" },
            { 0xB6, "=" },
            { 0xB7, "<" },

            { 0xB8, "SGN" },
            { 0xB9, "INT" },
            { 0xBA, "ABS" },
            { 0xBB, "USR" },
            { 0xBC, "FRE" },
            { 0xBD, "INP" },
            { 0xBE, "POS" },
            { 0xBF, "SQR" },
            { 0xC0, "RND" },
            { 0xC1, "LOG" },
            { 0xC2, "EXP" },
            { 0xC3, "COS" },
            { 0xC4, "SIN" },
            { 0xC5, "TAN" },
            { 0xC6, "ATN" },
            { 0xC7, "PEEK" },
            { 0xC8, "LEN" },
            { 0xC9, "STR¤" },
            { 0xCA, "VAL" },
            { 0xCB, "ASC" },
            { 0xCC, "CHR¤" },
            { 0xCD, "LEFT¤" },
            { 0xCE, "RIGHT¤" },
            { 0xCF, "MID¤" },

            { 0xD0, "GET" },
            { 0xD1, "PUT" },
            { 0xD2, "SOUND" },
            { 0xD3, "DELETE" },
            { 0xD4, "AUTO" },
            { 0xD5, "RENUM" },
            { 0xD6, "MERGE" },
            { 0xD7, "ELSE" },
            { 0xD8, "END" },
            { 0xD9, "TRON" },
            { 0xDA, "TROFF" },
            { 0xDB, "OPEN" },
            { 0xDC, "CLOSE" },

            { 0xDD, "EOF" },
            { 0xDE, "LOF" },
            { 0xDF, "EXIST" },
            { 0xE0, "VARPTR" },
        };
#endregion
        var text = new StringBuilder(1024);
        using (MemoryStream stream = new (content))
        using (BinaryReader reader = new (stream))
        {
            var line = new StringBuilder(128);
            while (true)
            {
                var value = reader.Read();
                if (value != 0) break;

                line.Clear();
                var offset = reader.ReadUInt16();
                if (offset == 0) break;

                offset -= (ushort)(address + 1);
                var rowNumber = reader.ReadUInt16();
                line.AppendFormat("{0} ", rowNumber);
                while (offset > stream.Position)
                {
                    var cmd = reader.ReadByte();
                    if (cmd == 0)
                    {
                        reader.BaseStream.Seek(-1, SeekOrigin.Current);
                        break;
                    }
                    
                    line.Append(_vacabular.ContainsKey(cmd) ? _vacabular[cmd] : GetEncodedSymbol(encoding, cmd));
                }
                text.AppendLine(line.ToString());
            }
        }
        writer.Write(Encoding.UTF8.GetBytes(text.ToString()));   
    }

    public static void ExtractPicture(BinaryWriter writer, byte[] content,
        ushort address, byte attribute, ExportEncoding encoding)
    {
        using MemoryStream stream = new(content);
        using BinaryReader reader = new(stream);

        ushort addr = reader.ReadUInt16();
        ushort height = reader.ReadByte();
        ushort width = reader.ReadByte();   // Ширина в байтах
        var size = height * width;
        width <<= 3;                        // Ширина в битах
        
        using var image = new Image<Rgba64>(width, height);
        byte[] colors = Decompress(stream, size);
        byte[] bitmap = Decompress(stream, size);

        int posX = 0, posY = 0;
        for (int index = 0; index < bitmap.Length; index++)
        {
            byte value = bitmap[index];
            byte color = colors[index];
            (Color foreColor, Color backColor) = GetColors(color);

            for (int i = 0, n = 7; n >= 0; i++, n--)
            {
                Color pixel = (value & (1 << n)) > 0 ? foreColor : backColor;
                image[posX + i, posY] = pixel;
            }
            posY++;
            if (posY == height)
            {
                posX += 8;
                posY = 0;
            }

        }
        image.SaveAsBmp(writer.BaseStream);
        return;

#region Decompress
        static byte[] Decompress(MemoryStream stream, int size)
        {
            byte[] result = new byte[size];
            int pos = 0;
            do
            {
                var value = stream.ReadByte();
                if ((value & 0x80) > 0)
                {
                    var repeat = (value & 0x7F) + 1;
                    value = stream.ReadByte();
                    if (value == -1) break; // Битая картинка, штучно встречается
                    for (int n = 0; n < repeat; n++)
                    {
                        result[pos] = (byte)value;
                        pos++;
                        if (pos >= size) break; // Битая картинка, десятками встречается
                    }
                }
                else
                {
                    var repeat = (value & 0x7F) + 1;
                    for (int n = 0; n < repeat; n++)
                    {
                        value = stream.ReadByte();
                        if (value == -1) break; // Битая картинка, штучно встречается
                        result[pos] = (byte)value;
                        pos++;
                        if (pos >= size) break; // Битая картинка, десятками встречается
                    }
                }
            }
            while (pos < size);
            return result;
        }
#endregion
#region GetColors
        static (Color foreColor, Color backColor) GetColors(byte color)
        {
            Color foreColor = GetColor((byte)(color & 0x0F));
            Color backColor = GetColor((byte)((color >> 4) & 0x0F));
            return (foreColor, backColor);
        }
#endregion
#region GetColor
        static Color GetColor(byte color)
        {
            return color switch
            {
                0 => Color.FromRgb(0x00, 0x00, 0x00),
                1 => Color.FromRgb(0x00, 0x00, 0xC0),
                2 => Color.FromRgb(0x00, 0xC0, 0x00),
                3 => Color.FromRgb(0x00, 0xC0, 0xC0),
                4 => Color.FromRgb(0xC0, 0x00, 0x00),
                5 => Color.FromRgb(0xC0, 0x00, 0xC0),
                6 => Color.FromRgb(0xC0, 0xC0, 0x00),
                7 => Color.FromRgb(0xC0, 0xC0, 0xC0),
                8 => Color.FromRgb(0x00, 0x00, 0x00),
                9 => Color.FromRgb(0x00, 0x00, 0xFF),
                10 => Color.FromRgb(0x00, 0xFF, 0x00),
                11 => Color.FromRgb(0x00, 0xFF, 0xFF),
                12 => Color.FromRgb(0xFF, 0x00, 0x00),
                13 => Color.FromRgb(0xFF, 0x00, 0xFF),
                14 => Color.FromRgb(0xFF, 0xFF, 0x00),
                15 => Color.FromRgb(0xFF, 0xFF, 0xFF),
                _ => throw new IndexOutOfRangeException(),
            };
        }
#endregion
    }

    private static char GetEncodedSymbol(ExportEncoding encoding, byte value)
    {
        return encoding switch
        {
            ExportEncoding.KOI7N2 => EncodingExtension.Convert_Koi7N2(value, true),
            ExportEncoding.KOI8R => EncodingExtension.Convert_Koi8R(value, true),
            ExportEncoding.CP866 => EncodingExtension.Convert_Cp866(value, true),
            _ => throw new ApplicationException(string.Format("Не известная кодировка: {0}", encoding.ToString())),
        };
    }
}

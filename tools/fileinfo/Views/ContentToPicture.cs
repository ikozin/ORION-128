using fileinfo.Models;
using System.Text;

namespace fileinfo.Views
{
    internal static class ContentToPicture
    {
        public static string Process(FileDetails detail, Func<byte, bool, char> encoding)
        {
            if (detail.Content.Length == 0) return String.Empty;

            var text = new StringBuilder();

            try
            {
                using (MemoryStream stream = new MemoryStream(detail.Content))
                using (BinaryReader reader = new BinaryReader(stream))
                {
                    ushort addr = reader.ReadUInt16();
                    var height = reader.ReadByte();
                    var width = reader.ReadByte();
                    var size = height * width;

                    text.AppendFormat("Addr = {0} ({0:X4})", addr);
                    text.AppendLine();
                    text.AppendFormat("Width = {0}({0:X2}), Height = {1}({1:X2}), Size = {2}({2:X4})", width, height, size);
                    text.AppendLine();
                    text.AppendLine();

                    byte[] colors = Decompress(stream, size);
                    byte[] bitmap = Decompress(stream, size);

                    for (var h = 0; h < height; h++)
                    {
                        for (var w = 0; w < width; w++)
                        {
                            var value = bitmap[h + w * height];
                            text.ByteToBin(value);
                        }
                        text.AppendLine();
                    }
                }
            }
            catch (Exception ex)
            {
                text.AppendLine();
                text.Insert(0, Environment.NewLine);
                text.Insert(0, ex.Message);
            }
            return text.ToString();
        }

        public static Bitmap GetImage(FileDetails detail, Func<byte, bool, char> encoding)
        {
            if (detail.Content.Length == 0) return new Bitmap(1,1);
            try
            {
                using (MemoryStream stream = new MemoryStream(detail.Content))
                using (BinaryReader reader = new BinaryReader(stream))
                {
                    ushort addr = reader.ReadUInt16();
                    var height = reader.ReadByte();
                    var width = reader.ReadByte();
                    var size = height * width;


                    var image = new Bitmap(width * 8+1, height+1);


                    byte[] colors = Decompress(stream, size);
                    byte[] bitmap = Decompress(stream, size);

                    int posX = 0, posY = 0;
                    foreach (var value in bitmap)
                    {
                        for (int i = 0, n = 8; n >= 0; i++, n--)
                        {
                            image.SetPixel(posX + i, posY, (value & (1 << n)) > 0 ? Color.White : Color.Blue);
                        }
                        posY++;
                        if (posY == height)
                        {
                            posX += 8;
                            posY = 0;
                        }

                    }
                    return image;
                }
            }
            catch (Exception ex)
            {
                return new Bitmap(1, 1);
            }
        }

        private static byte[] Decompress(MemoryStream stream, int size)
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
                    if (value == -1) throw new IndexOutOfRangeException();
                    for (int n = 0; n < repeat; n++)
                    {
                        result[pos] = (byte)value;
                        pos++;
                    }
                }
                else
                {
                    var repeat = (value & 0x7F) + 1;
                    for (int n = 0; n < repeat; n++)
                    {
                        value = stream.ReadByte();
                        if (value == -1) throw new IndexOutOfRangeException();
                        result[pos] = (byte)value;
                        pos++;
                    }
                }
            }
            while (pos < size);
            return result;

        }
        private static void ByteToBin(this StringBuilder text, byte value)
        {
            for (int n = 8; n >= 0 ; n--)
            {
                text.Append((byte)(value & (1 << n)) > 0 ? 'X' : ' ');
            }
        }
    }
}

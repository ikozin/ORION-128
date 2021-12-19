using fileinfo.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace fileinfo.Views
{
    internal class PictureViewComponent : ViewComponent<PictureBox>
    {
        public PictureViewComponent() : base()
        {
            _control.Font = new System.Drawing.Font("Cascadia Mono", 9F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point);
            //_control.Location = new Point(0, 0);
            //_control.Size = new Size(182, 374);
            _control.TabIndex = 0;
            _control.SizeMode = System.Windows.Forms.PictureBoxSizeMode.StretchImage;
            _control.TabStop = false;
        }

        public override void ReloadData(FileDetails detail, Func<byte, bool, char> encoding)
        {
            var image = _control.Image;
            _control.Image = GetImage(detail, encoding);
            image?.Dispose();
        }

        protected Bitmap GetImage(FileDetails detail, Func<byte, bool, char> encoding)
        {
            if (detail.Content.Length == 0) return new Bitmap(1, 1);
            try
            {
                using (MemoryStream stream = new MemoryStream(detail.Content))
                using (BinaryReader reader = new BinaryReader(stream))
                {
                    ushort addr = reader.ReadUInt16();
                    var height = reader.ReadByte();
                    var width = reader.ReadByte();
                    var size = height * width;


                    var image = new Bitmap(width * 8 + 1, height + 1);


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

        protected byte[] Decompress(MemoryStream stream, int size)
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
    }
}

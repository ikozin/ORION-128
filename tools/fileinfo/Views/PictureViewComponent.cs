using fileinfo.Helpers;
using fileinfo.Models;
using fileinfo.Views.Picture;

namespace fileinfo.Views
{
    internal class PictureViewComponent : ViewComponent<PictureViewUserControl>
    {
        public PictureViewComponent() : base()
        {
            _control.TabIndex = 0;
            _control.pictureBox.SizeMode = PictureBoxSizeMode.CenterImage;
            _control.pictureBox.TabStop = false;
        }

        public override void ClearView()
        {
            _control.textBoxAddress.Text = String.Empty;
            _control.textBoxWidth.Text = String.Empty;
            _control.textBoxHeight.Text = String.Empty;
            _control.panelInfo.Enabled = false;

            var image = _control.pictureBox.Image;
            _control.pictureBox.Image = null;
            image?.Dispose();
        }

        protected override void LoadData(FileDetails? detail, Func<byte, bool, char>? encoding)
        {
            var image = _control.pictureBox.Image;
            SetImage(detail, encoding);
            image?.Dispose();
        }

        protected void SetImage(FileDetails? detail, Func<byte, bool, char>? encoding)
        {
            try
            {
                _control.textBoxAddress.Text = String.Empty;
                _control.textBoxWidth.Text = String.Empty;
                _control.textBoxHeight.Text = String.Empty;
                _control.pictureBox.Image = null;

                if (detail == null || detail.Content == null || detail.Content.Length == 0)
                {
                    return;
                }

                using (MemoryStream stream = new MemoryStream(detail.Content))
                using (BinaryReader reader = new BinaryReader(stream))
                {
                    ushort addr = reader.ReadUInt16();
                    ushort height = reader.ReadByte();
                    ushort width = reader.ReadByte();   // Ширина в байтах
                    var size = height * width;
                    width <<= 3;                        // Ширина в битах
                    _control.textBoxAddress.Text = addr.ToHexAsm();
                    _control.textBoxWidth.Text = width.ToString();
                    _control.textBoxHeight.Text = height.ToString();

                    var image = new Bitmap(width, height);

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
                            image.SetPixel(posX + i, posY, pixel);
                        }
                        posY++;
                        if (posY == height)
                        {
                            posX += 8;
                            posY = 0;
                        }

                    }
                    _control.pictureBox.Image = image;
                    _control.panelInfo.Enabled = true;
                }
            }
            catch (Exception)
            {
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

        protected (Color foreColor, Color backColor) GetColors(byte color)
        {
            Color foreColor = GetColor((byte)(color & 0x0F));
            Color backColor = GetColor((byte)((color >> 4) & 0x0F));
            return (foreColor, backColor);
        }

        protected Color GetColor(byte color)
        {
            switch (color)
            { 
                case 0:  return Color.FromArgb(0x00, 0x00, 0x00);
                case 1:  return Color.FromArgb(0x00, 0x00, 0xC0);
                case 2:  return Color.FromArgb(0x00, 0xC0, 0x00);
                case 3:  return Color.FromArgb(0x00, 0xC0, 0xC0);
                case 4:  return Color.FromArgb(0xC0, 0x00, 0x00);
                case 5:  return Color.FromArgb(0xC0, 0x00, 0xC0);
                case 6:  return Color.FromArgb(0xC0, 0xC0, 0x00);
                case 7:  return Color.FromArgb(0xC0, 0xC0, 0xC0);
                case 8:  return Color.FromArgb(0x00, 0x00, 0x00);
                case 9:  return Color.FromArgb(0x00, 0x00, 0xFF);
                case 10: return Color.FromArgb(0x00, 0xFF, 0x00);
                case 11: return Color.FromArgb(0x00, 0xFF, 0xFF);
                case 12: return Color.FromArgb(0xFF, 0x00, 0x00);
                case 13: return Color.FromArgb(0xFF, 0x00, 0xFF);
                case 14: return Color.FromArgb(0xFF, 0xFF, 0x00);
                case 15: return Color.FromArgb(0xFF, 0xFF, 0xFF);
                default: throw new ArgumentOutOfRangeException();
            }
        }
    }
}

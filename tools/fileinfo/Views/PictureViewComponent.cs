using fileinfo.Helpers;

namespace fileinfo.Views
{
    public partial class PictureViewComponent : ViewComponent
    {
        public PictureViewComponent()
        {
            InitializeComponent();
        }

        public PictureViewComponent(Func<byte, bool, char> encoding) : base(encoding)
        {
            InitializeComponent();
            ClearView();
        }

        protected override void ClearView()
        {
            textBoxAddress.Text = String.Empty;
            textBoxWidth.Text = String.Empty;
            textBoxHeight.Text = String.Empty;
            panelTool.Enabled = false;
            pictureBoxView.Enabled = false;

            var image = pictureBoxView.Image;
            pictureBoxView.Image = null;
            image?.Dispose();
        }

        protected override void LoadView()
        {
            var content = pictureBoxView.Image;
            pictureBoxView.Image = null;
            content?.Dispose();
            try
            {
                using MemoryStream stream = new(_detail!.Content);
                using BinaryReader reader = new(stream);
                ushort addr = reader.ReadUInt16();
                ushort height = reader.ReadByte();
                ushort width = reader.ReadByte();   // Ширина в байтах
                var size = height * width;
                width <<= 3;                        // Ширина в битах
                textBoxAddress.Text = addr.ToHexAsm();
                textBoxWidth.Text = width.ToString();
                textBoxHeight.Text = height.ToString();

                if (width != 0 && width < 512 && height != 0 && height < 512)
                {
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
                    pictureBoxView.Image = image;
                    pictureBoxView.Enabled = true;
                    panelTool.Enabled = true;
                }
                else
                {
                    ClearView();
                }
            }
            catch (Exception ex)
            {
            }
        }

        public override void SaveDetailToFile()
        {
            if (_detail == null) return;
            if (pictureBoxView.Image == null) return;
            using SaveFileDialog dlg = new();
            dlg.DefaultExt = "bmp";
            dlg.Filter = "Bitmap files|*.bmp";
            dlg.FileName = _detail.Name;
            if (dlg.ShowDialog(this) != DialogResult.OK) return;
            pictureBoxView.Image.Save(dlg.FileName);
        }

        protected static byte[] Decompress(MemoryStream stream, int size)
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

        protected static (Color foreColor, Color backColor) GetColors(byte color)
        {
            Color foreColor = GetColor((byte)(color & 0x0F));
            Color backColor = GetColor((byte)((color >> 4) & 0x0F));
            return (foreColor, backColor);
        }

        protected static Color GetColor(byte color)
        {
            return color switch
            {
                0 => Color.FromArgb(0x00, 0x00, 0x00),
                1 => Color.FromArgb(0x00, 0x00, 0xC0),
                2 => Color.FromArgb(0x00, 0xC0, 0x00),
                3 => Color.FromArgb(0x00, 0xC0, 0xC0),
                4 => Color.FromArgb(0xC0, 0x00, 0x00),
                5 => Color.FromArgb(0xC0, 0x00, 0xC0),
                6 => Color.FromArgb(0xC0, 0xC0, 0x00),
                7 => Color.FromArgb(0xC0, 0xC0, 0xC0),
                8 => Color.FromArgb(0x00, 0x00, 0x00),
                9 => Color.FromArgb(0x00, 0x00, 0xFF),
                10 => Color.FromArgb(0x00, 0xFF, 0x00),
                11 => Color.FromArgb(0x00, 0xFF, 0xFF),
                12 => Color.FromArgb(0xFF, 0x00, 0x00),
                13 => Color.FromArgb(0xFF, 0x00, 0xFF),
                14 => Color.FromArgb(0xFF, 0xFF, 0x00),
                15 => Color.FromArgb(0xFF, 0xFF, 0xFF),
                _ => throw new IndexOutOfRangeException(),
            };
        }
    }
}

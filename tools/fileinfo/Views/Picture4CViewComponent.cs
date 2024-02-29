using fileinfo.Helpers;
using System.Text;

namespace fileinfo.Views
{
    public partial class Picture4CViewComponent : ViewComponent
    {
        public Picture4CViewComponent()
        {
            InitializeComponent();
        }

        public Picture4CViewComponent(Func<byte, bool, char> encoding) : base(encoding)
        {
            InitializeComponent();
            ClearView();
        }

        protected override void ClearView()
        {
            checkBoxColor.CheckState = CheckState.Indeterminate;
            checkBoxCompressed.CheckState = CheckState.Indeterminate;
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
                bool isCompress = reader.ReadByte() != 0;
                bool isColor = reader.ReadByte() == 0;

                ushort height = reader.ReadByte();
                if (height == 0) height = 256;

                ushort width = reader.ReadByte();   // Ширина в байтах
                var size = height * width;
                width <<= 3;                        // Ширина в битах

                checkBoxColor.CheckState= isColor ? CheckState.Checked : CheckState.Unchecked;
                checkBoxCompressed.CheckState = isCompress ? CheckState.Checked : CheckState.Unchecked;
                textBoxWidth.Text = width.ToString();
                textBoxHeight.Text = height.ToString();

                if (width != 0 && width < 512 && height != 0 && height < 512)
                {
                    List<byte> map = new List<byte>((isColor) ? size << 1 : size);
                    try
                    {
                        while (true)
                        {
                            byte value = reader.ReadByte();
                            if (value == 0)
                                break;
                            if ((value & 0x80) > 0)
                            {
                                value = (byte)(value & 0x7F);
                                for (int i = 0; i < value; i++)
                                    map.Add(reader.ReadByte());
                            }
                            else
                            {
                                value = (byte)(value & 0x7F);
                                byte data = reader.ReadByte();
                                for (int i = 0; i < value; i++)
                                    map.Add(data);
                            }
                        }

                        var image = new Bitmap(width, height);
                        int index = 0;
                        for (int w = 0; w < width; w += 8)
                        {
                            for (int h = 0; h < height; h++)
                            {
                                byte value = map[index];
                                for (int i = 0, n = 7; n >= 0; i++, n--)
                                {
                                    byte data = (value & (1 << n)) > 0 ? (byte)0x02 : (byte)0x00;
                                    if (isColor)
                                    {
                                        byte value2 = map[index + size];
                                        data |= (value2 & (1 << n)) > 0 ? (byte)0x01 : (byte)0x00;

                                    }

                                    var pixel = data switch
                                    {
                                        0 => Color.Black,
                                        1 => Color.Red,
                                        2 => Color.Green,
                                        3 => Color.Blue,
                                        _ => Color.White,
                                    };
                                    image.SetPixel(w + i, h, pixel);
                                }
                                index++;
                            }
                        }
                        map.Clear();
                        pictureBoxView.Image = image;
                    }
                    catch (Exception)
                    {
                        throw;
                    }
                    finally
                    {
                        map.Clear();
                    }

                    pictureBoxView.Enabled = true;
                    panelTool.Enabled = true;
                }
                else
                {
                    throw new ApplicationException("Ошибка формата");
                }
            }
            catch (Exception ex)
            {
                ClearView();
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

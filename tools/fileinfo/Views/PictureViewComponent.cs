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
            _control.pictureBox.SizeMode = System.Windows.Forms.PictureBoxSizeMode.CenterImage;
            _control.pictureBox.TabStop = false;
        }

        public override void ReloadView(FileDetails detail, Func<byte, bool, char> encoding)
        {
            var image = _control.pictureBox.Image;
            SetImage(detail, encoding);
            image?.Dispose();
        }
        public override void ClearView()
        {
            _control.textBoxAddress.Text = String.Empty;
            _control.textBoxWidth.Text = String.Empty;
            _control.textBoxHeight.Text = String.Empty;

            var image = _control.pictureBox.Image;
            _control.pictureBox.Image = new Bitmap(1, 1);
            image?.Dispose();
        }

        protected void SetImage(FileDetails detail, Func<byte, bool, char> encoding)
        {
            try
            {
                using (MemoryStream stream = new MemoryStream(detail.Content))
                using (BinaryReader reader = new BinaryReader(stream))
                {
                    ushort addr = reader.ReadUInt16();
                    var height = reader.ReadByte();
                    var width = reader.ReadByte();
                    var size = height * width;
                    _control.textBoxAddress.Text = addr.ToHexAsm();
                    _control.textBoxWidth.Text = width.ToString();
                    _control.textBoxHeight.Text = height.ToString();

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
                    _control.pictureBox.Image = image;
                }
            }
            catch (Exception)
            {
                _control.pictureBox.Image = new Bitmap(1, 1);
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

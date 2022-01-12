using fileinfo.Helpers;
using System.Text;

namespace fileinfo.Views
{
    public partial class CheckSumViewComponent : ViewComponent
    {
        private const int ChunkSize = 256;

        protected string? _extension;
        protected string? _filter;

        public CheckSumViewComponent() : base()
        {
            InitializeComponent();
        }

        public CheckSumViewComponent(Func<byte, bool, char> encoding) : base(encoding)
        {
            InitializeComponent();
            ClearView();
            _extension = "";
            _filter = "All files|*.*";
        }

        private void checkBoxHeader_CheckedChanged(object sender, EventArgs e)
        {
            LoadView();
        }

        protected override void ClearView()
        {
            fastColoredTextBoxView.Text = string.Empty;
            fastColoredTextBoxView.Enabled = false;
            panelTool.Enabled = false;
        }

        protected override void LoadView()
        {
            var text = new StringBuilder();
            byte[] data = _detail!.Content;
            if (checkBoxHeader.Checked)
            {
                Array.Resize(ref data, data.Length + 16);
                Array.Copy(data, 0, data, 16, data.Length - 16);
                Array.Fill<byte>(data, 0, 0, 16);
                using (MemoryStream memory = new MemoryStream(data))
                using (BinaryWriter writer = new BinaryWriter(memory))
                {
                    writer.Write(Encoding.ASCII.GetBytes(_detail.Name));
                    while (memory.Position < 8) writer.Write((byte)0x20);
                    writer.Write(_detail.Address);
                    writer.Write(_detail.Size);
                }
            }
            int start = 0;
            while (start < data.Length)
            {
                var chunk = data.Skip(start).Take(ChunkSize).ToArray();
                var blockSum = CalculateCheckSum(chunk);
                CheckSumToString(text, start, chunk.Length, blockSum);
                start += ChunkSize;
            }

            text.AppendLine();

            var sum = CalculateCheckSum(data);
            CheckSumToString(text, _detail!.Address, data.Length, sum);

            fastColoredTextBoxView.Text = text.ToString();
            fastColoredTextBoxView.Enabled = true;
            panelTool.Enabled = true;
        }

        public override void SaveDetailToFile()
        {
            if (_detail == null) return;
            using SaveFileDialog dlg = new();
            dlg.DefaultExt = _extension;
            dlg.Filter = _filter;
            dlg.FileName = _detail.Name;
            if (dlg.ShowDialog(this) != DialogResult.OK) return;
            File.WriteAllText(dlg.FileName, fastColoredTextBoxView.Text, Encoding.UTF8);
        }

        private static ushort CalculateCheckSum(byte[] data)
        {
            int i = 0;
            ushort totalSum = 0;
            ushort cyclicSum = 0;
            while (true)
            {
                byte b = data[i++];
                totalSum += b;
                var flag = totalSum > 0xFF;
                totalSum &= 0xFF;
                if (i == data.Length) return (ushort)((cyclicSum << 8) + totalSum);
                cyclicSum += (byte)(b + (flag ? 1 : 0));
            }
        }

        private static void CheckSumToString(StringBuilder text, int address, int length, ushort sum)
        {
            text.Append(((ushort)address).ToHex());
            text.Append("-");
            text.Append(((ushort)(address + length - 1)).ToHex());
            text.Append(" ");
            text.AppendLine(sum.ToHex());
        }
    }
}

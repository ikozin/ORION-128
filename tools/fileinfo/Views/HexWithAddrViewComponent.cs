using System.Text;

namespace fileinfo.Views
{
    public partial class HexWithAddrViewComponent : TextViewComponent
    {
        public HexWithAddrViewComponent() : base()
        {
        }

        public HexWithAddrViewComponent(Func<byte, bool, char> encoding) : base(encoding)
        {
        }

        protected override void LoadView()
        {
            textBoxView.Text = ByteArrayToHex(_detail!.Address);
            textBoxView.Enabled = true;
        }

        protected string ByteArrayToHex(ushort addr)
        {
            var descr = new StringBuilder();
            var text = new StringBuilder();

            text.Append("     0   1   2   3   4   5   6   7   8   9   A   B   C   D   E   F");

            ushort start = (ushort)(addr & (ushort)0xFFF0);
            if (start < addr)
            {
                text.AppendLine();
                text.AppendFormat("{0:X4}", start);
                while (start < addr)
                {
                    text.Append("    ");
                    descr.Append(' ');
                    start++;
                }
            }

            foreach (var item in _detail!.Content)
            {
                if (addr % 16 == 0)
                {
                    text.Append(" ");
                    text.AppendLine(descr.ToString());
                    text.AppendFormat("{0:X4}", addr);
                    descr.Clear();
                }
                text.AppendFormat(" {0:X2} ", item);
                descr.Append(_encoding(item, false));
                addr++;
            }

            if (addr % 16 != 0)
            {
                start = addr;
                addr = (ushort)((addr + 16) & (ushort)0xFFF0); ;
                while (start < addr)
                {
                    text.Append("    ");
                    descr.Append(' ');
                    start++;
                }

                text.Append(" ");
                text.AppendLine(descr.ToString());
                descr.Clear();
            }
            return text.ToString();
        }
    }
}

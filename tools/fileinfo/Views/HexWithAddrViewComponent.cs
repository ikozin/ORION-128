using fileinfo.Models;
using System.Text;

namespace fileinfo.Views
{
    internal class HexWithAddrViewComponent : TextViewComponent
    {
        protected override void LoadData(FileDetails? detail, Func<byte, bool, char>? encoding)
        {
            _control.Text = String.Empty;

            if (detail == null || detail.Content == null || detail.Content.Length == 0) return;

            _control.Text = ByteArrayToHex(detail.Content, detail!.Address, encoding!);
        }

        protected string ByteArrayToHex(byte[] content, ushort? addr, Func<byte, bool, char> encoding)
        {
            if (content == null || content.Length == 0) return String.Empty;

            var descr = new StringBuilder();
            var text = new StringBuilder();

            text.Append("     0   1   2   3   4   5   6   7   8   9   A   B   C   D   E   F");

            ushort start = (ushort)(addr!.Value & (ushort)0xFFF0);
            if (start < addr!.Value)
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

            foreach (var item in content)
            {
                if (addr!.Value % 16 == 0)
                {
                    text.Append(" ");
                    text.AppendLine(descr.ToString());
                    text.AppendFormat("{0:X4}", addr!.Value);
                    descr.Clear();
                }
                text.AppendFormat(" {0:X2} ", item);
                descr.Append(encoding(item, false));
                addr++;
            }

            if (addr!.Value % 16 != 0)
            {
                start = addr!.Value;
                addr = (ushort)((addr!.Value + 16) & (ushort)0xFFF0); ;
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

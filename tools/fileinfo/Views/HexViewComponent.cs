using fileinfo.Models;

namespace fileinfo.Views
{
    internal class HexViewComponent : HexWithAddrViewComponent
    {
        protected override void LoadData(FileDetails? detail, Func<byte, bool, char>? encoding)
        {
            _control.Text = String.Empty;

            if (detail == null || detail.Content == null || detail.Content.Length == 0) return;

            _control.Text = ByteArrayToHex(detail.Content, 0, encoding!);
        }
    }
}

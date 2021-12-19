using fileinfo.Models;
using System.Text;

namespace fileinfo.Views
{
    internal class HexViewComponent: HexWithAddrViewComponent
    {
        public override void ReloadView(FileDetails detail, Func<byte, bool, char> encoding)
        {
            _control.Text = ByteArrayToHex(detail.Content, 0, encoding);
        }
    }
}

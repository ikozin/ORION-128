using fileinfo.Helpers;
using fileinfo.Models;
using System.Text;

namespace fileinfo.Views
{
    internal class DisAsmDumpViewComponent : TextViewComponent
    {
        public override void ReloadData(FileDetails detail, Func<byte, bool, char> encoding)
        {
            _control.Text = String.Empty;
            if (detail.Content == null || detail.Content.Length == 0) return;

            var text = new StringBuilder();

            text.Append("ORG ");
            text.AppendLine(detail.Address!.Value.ToHexAsm());
            text.AppendLine();

            try
            {
                ushort addr = detail.Address!.Value;
                foreach (var data in detail.Content)
                {
                    var line = String.Format("DB   {0}", data.ToHexAsm());
                    text.AppendFormat("{0, -32};{1} '{2}'", line, addr.ToHexAsm(), encoding(data, false));
                    text.AppendLine();
                }
            }
            catch (Exception ex)
            {
                text.AppendLine(ex.Message);
            }

            _control.Text = text.ToString();
        }
    }
}

using fileinfo.Helpers;
using fileinfo.Models;
using fileinfo.Services;
using System.Text;

namespace fileinfo.Views
{
    internal class DisAssemblerViewComponent : TextViewComponent
    {
        public override void ReloadView(FileDetails detail, Func<byte, bool, char> encoding)
        {
            _control.Text = String.Empty;
            if (detail.Content == null || detail.Content.Length == 0) return;

            var text = new StringBuilder();

            text.Append("ORG ");
            text.AppendLine(detail.Address!.Value.ToHexAsm());
            text.AppendLine();

            try
            {
                HashSet<ushort> codeAddress = DisAssemblerAlalyzer.Alalyze(detail.Content, detail.Address!.Value);
                DisAssemblerAlalyzer.DisAssembleCode(text, detail.Content, detail.Address!.Value, codeAddress, encoding);
            }
            catch (Exception ex)
            {
                text.AppendLine(ex.Message);
            }

            _control.Text = text.ToString();
        }
    }
}

using fileinfo.Helpers;
using fileinfo.Models;
using fileinfo.Services;
using fileinfo.Views.DisAssembler;
using System.Text;

namespace fileinfo.Views
{
    internal class DisAssemblerViewComponent : ViewComponent<DisAssemblerUserControl>
    {
        public DisAssemblerViewComponent() : base()
        {
            if (!File.Exists(_control.fastColoredTextBoxView.DescriptionFile))
                _control.fastColoredTextBoxView.DescriptionFile = "";
        }

        public override void ClearView()
        {
            _control.fastColoredTextBoxView.Text = string.Empty;
        }

        protected override void LoadData(FileDetails? detail, Func<byte, bool, char>? encoding)
        {
            _control.fastColoredTextBoxView.Text = String.Empty;

            if (detail == null || detail.Content == null || detail.Content.Length == 0) return;

            var text = new StringBuilder();

            text.Append("ORG ");
            text.AppendLine(detail.Address!.Value.ToHexAsm());
            text.AppendLine();

            try
            {
                HashSet<ushort> codeAddress = DisAssemblerAlalyzer.Alalyze(detail.Content, detail.Address!.Value);
                DisAssemblerAlalyzer.DisAssembleCode(text, detail.Content, detail.Address!.Value, codeAddress, encoding!);
            }
            catch (Exception ex)
            {
                text.AppendLine(ex.Message);
            }

            _control.fastColoredTextBoxView.Text = text.ToString();
        }
    }
}

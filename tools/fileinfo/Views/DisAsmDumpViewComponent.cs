using fileinfo.Helpers;
using fileinfo.Models;
using fileinfo.Services;
using fileinfo.Views.DisAsmDump;
using System.Text;

namespace fileinfo.Views
{
    internal class DisAsmDumpViewComponent : ViewComponent<DisAsmDumpUserControl>
    {
        private FileDetails _detail;
        private Func<byte, bool, char> _encoding;

        private int  _count = 1;

        public DisAsmDumpViewComponent(): base()
        {
            _control.comboBoxCount.SelectedIndexChanged += ComboBoxCount_SelectedIndexChanged;
            _count = int.Parse(_control.comboBoxCount.SelectedItem!.ToString()!);
        }

        public override void ClearView()
        {
            _control.textBoxView.Text = string.Empty;
        }

        public override void ReloadView(FileDetails detail, Func<byte, bool, char> encoding)
        {
            _detail = detail;
            _encoding = encoding;

            _control.textBoxView.Text = String.Empty;
            if (detail.Content == null || detail.Content.Length == 0) return;

            var text = new StringBuilder();

            text.Append("ORG ");
            text.AppendLine(detail.Address!.Value.ToHexAsm());
            text.AppendLine();

            try
            {
                int pos = 0;
                do
                {
                    var line = detail.Content.Skip(pos).Take(_count).Select(b => b.ToHexAsm());
                    if (line.Count() > 0)
                    {
                        text.Append("DB   ");
                        text.AppendLine(String.Join(", ", line));
                    }
                    pos += line.Count();
                }
                while (pos < detail.Content.Length);
            }
            catch (Exception ex)
            {
                text.AppendLine(ex.Message);
            }

            _control.textBoxView.Text = text.ToString();
        }
        private void ComboBoxCount_SelectedIndexChanged(object? sender, EventArgs e)
        {
            _count = int.Parse(((ComboBox)sender).SelectedItem!.ToString()!);
            ReloadView(_detail, _encoding);
        }
}
}

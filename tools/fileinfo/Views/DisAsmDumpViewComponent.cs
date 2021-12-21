using fileinfo.Helpers;
using fileinfo.Models;
using fileinfo.Views.DisAsmDump;
using System.Text;

namespace fileinfo.Views
{
    internal class DisAsmDumpViewComponent : ViewComponent<DisAsmDumpUserControl>
    {
        private int _count;

        public DisAsmDumpViewComponent() : base()
        {
            _control.comboBoxCount.SelectedIndexChanged += ComboBoxCount_SelectedIndexChanged;
            _count = int.Parse(_control.comboBoxCount.SelectedItem!.ToString()!);
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
                int pos = 0;
                do
                {
                    var line = detail.Content.Skip(pos).Take(_count).Select(b => b.ToHexAsm());
                    if (line.Any())
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

            _control.fastColoredTextBoxView.Text = text.ToString();
        }

        private void ComboBoxCount_SelectedIndexChanged(object? sender, EventArgs e)
        {
            _count = int.Parse(_control.comboBoxCount.SelectedItem!.ToString()!);
            LoadData(_detail, _encoding);
        }
    }
}

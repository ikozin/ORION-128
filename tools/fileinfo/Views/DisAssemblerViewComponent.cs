using fileinfo.Models;
using fileinfo.Services.Dasm.Service;
using fileinfo.Views.DisAssembler;

namespace fileinfo.Views
{
    internal class DisAssemblerViewComponent : ViewComponent<DisAssemblerUserControl>
    {
        public DisAssemblerViewComponent() : base()
        {
            if (!File.Exists(_control.fastColoredTextBoxView.DescriptionFile))
                _control.fastColoredTextBoxView.DescriptionFile = "";
            _control.btnRun.Click += BtnRun_Click;
        }

        public override void ClearView()
        {
            _control.fastColoredTextBoxView.Text = string.Empty;
            _control.textBoxLabel.Text = String.Empty;
            _control.textBoxData.Text = String.Empty;
            _control.textBoxComment.Text = String.Empty;
            _control.btnRun.Enabled = false;
        }

        protected override void LoadData(FileDetails? detail, Func<byte, bool, char>? encoding)
        {
            _control.fastColoredTextBoxView.Text = String.Empty;
            _control.textBoxLabel.Text = String.Empty;
            _control.textBoxData.Text = String.Empty;
            _control.textBoxComment.Text = String.Empty;
            _control.btnRun.Enabled = false;

            if (detail == null || detail.Content == null || detail.Content.Length == 0) return;

            try
            {
                BtnRun_Click(_control.btnRun, EventArgs.Empty);
            }
            catch (Exception ex)
            {
                _control.fastColoredTextBoxView.Text += Environment.NewLine;
                _control.fastColoredTextBoxView.Text += ex.Message;
            }

            _control.btnRun.Enabled = true;
        }

        private void BtnRun_Click(object? sender, EventArgs e)
        {
            if (_detail == null) return;
            Dictionary<string, string> labels = ConfigLoader.LoadDictionary(_control.textBoxLabel.Text);
            Dictionary< string, string> datas = ConfigLoader.LoadDictionary(_control.textBoxData.Text);
            Dictionary<string, string> comments = ConfigLoader.LoadDictionary(_control.textBoxComment.Text);
            using MemoryStream stream = new(_detail.Content);
            _control.fastColoredTextBoxView.Text = Services.Dasm.Program.Main(stream, _detail.Address!.Value, labels, datas, comments, _encoding!);
        }
    }
}

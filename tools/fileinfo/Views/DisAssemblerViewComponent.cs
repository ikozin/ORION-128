using fileinfo.Services.Dasm.Service;
using System.Text;

namespace fileinfo.Views
{
    public partial class DisAssemblerViewComponent : ViewComponent
    {
        protected string? _extension;
        protected string? _filter;

        public DisAssemblerViewComponent()
        {
            InitializeComponent();
        }

        public DisAssemblerViewComponent(Func<byte, bool, char> encoding) : base(encoding)
        {
            InitializeComponent();
            if (!File.Exists(fastColoredTextBoxView.DescriptionFile))
                fastColoredTextBoxView.DescriptionFile = "";
            ClearView();
            _extension = "asm";
            _filter = "Assemblers files|*.asm|All files|*.*";
        }

        private void ButtonDasm_Click(object? sender, EventArgs e)
        {
            Dictionary<string, string> labels = ConfigLoader.LoadDictionary(textBoxLabel.Text);
            Dictionary<string, string> datas = ConfigLoader.LoadDictionary(textBoxData.Text);
            Dictionary<string, string> comments = ConfigLoader.LoadDictionary(textBoxComment.Text);
            using MemoryStream stream = new(_detail!.Content);
            fastColoredTextBoxView.Text = Services.Dasm.Program.Process(stream, _detail.Address, labels, datas, comments, _encoding!);
        }

        protected override void ClearView()
        {
            splitContainerView.Enabled = false;
            fastColoredTextBoxView.Text = String.Empty;
            textBoxLabel.Text = String.Empty;
            textBoxData.Text = String.Empty;
            textBoxComment.Text = String.Empty;
        }

        protected override void LoadView()
        {
            try
            {
                ButtonDasm_Click(null, EventArgs.Empty);
            }
            catch (Exception ex)
            {
                fastColoredTextBoxView.Text += Environment.NewLine;
                fastColoredTextBoxView.Text += ex.Message;
            }
            splitContainerView.Enabled = true;
        }
        public override void SaveDetailToFile()
        {
            if (_detail == null) return;
            using SaveFileDialog dlg = new();
            dlg.DefaultExt = _extension;
            dlg.Filter = _filter;
            dlg.FileName = _detail.Name;
            if (dlg.ShowDialog(this) != DialogResult.OK) return;
            File.WriteAllText(dlg.FileName, fastColoredTextBoxView.Text, Encoding.UTF8);
        }
    }
}
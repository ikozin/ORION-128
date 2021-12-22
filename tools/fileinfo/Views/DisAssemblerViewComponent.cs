using fileinfo.Services.Dasm.Service;

namespace fileinfo.Views
{
    public partial class DisAssemblerViewComponent : ViewComponent
    {
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
    }
}
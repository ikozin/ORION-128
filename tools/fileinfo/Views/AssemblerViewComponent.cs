using System.Text;

namespace fileinfo.Views
{
    public partial class AssemblerViewComponent : ViewComponent
    {
        public AssemblerViewComponent(Func<byte, bool, char> encoding) : base(encoding)
        {
            InitializeComponent();
            if (!File.Exists(fastColoredTextBoxView.DescriptionFile))
                fastColoredTextBoxView.DescriptionFile = "";
            ClearView();
        }

        protected override void ClearView()
        {
            fastColoredTextBoxView.Text = String.Empty;
            fastColoredTextBoxView.Enabled = false;
        }

        protected override void LoadView()
        {
            var text = new StringBuilder();
            foreach (var item in _detail!.Content)
            {
                text.Append(_encoding!(item, true));
            }
            text.Replace("\r", Environment.NewLine);
            fastColoredTextBoxView.Text = text.ToString();
            fastColoredTextBoxView.Enabled = true;
        }
    }
}

using System.Text;

namespace fileinfo.Views
{
    public partial class TextViewComponent : ViewComponent
    {
        protected string? _extension;
        protected string? _filter;

        public TextViewComponent() : base()
        {
            InitializeComponent();
        }

        public TextViewComponent(Func<byte, bool, char> encoding) : base(encoding)
        {
            InitializeComponent();
            ClearView();
            _extension = "";
            _filter = "All files|*.*";
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

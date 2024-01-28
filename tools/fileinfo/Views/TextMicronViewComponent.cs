using System.Text;

namespace fileinfo.Views
{
    public partial class TextMicronViewComponent : TextViewComponent
    {
        public TextMicronViewComponent(Func<byte, bool, char> encoding) : base(encoding)
        {
            _extension = "";
            _filter = "All files|*.*";
        }

        protected override void LoadView()
        {
            var text = new StringBuilder();
            foreach (var item in _detail!.Content)
            {
                if (item == 0xFF) break;
                text.Append(_encoding!(item, true));
            }
            text.Replace("\r", Environment.NewLine);
            fastColoredTextBoxView.Text = text.ToString();
            fastColoredTextBoxView.Enabled = true;
        }
    }
}

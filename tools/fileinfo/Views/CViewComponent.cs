using System.Text;

namespace fileinfo.Views
{
    internal class CViewComponent : TextViewComponent
    {
        public CViewComponent(Func<byte, bool, char> encoding) : base(encoding)
        {
            if (File.Exists("SyntaxHighlighterC.xml"))
                fastColoredTextBoxView.DescriptionFile = "SyntaxHighlighterC.xml";
            _extension = "c";
            _filter = "C files|*.c|All files|*.*";
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
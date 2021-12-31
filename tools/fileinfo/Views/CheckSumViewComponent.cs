using System.Text;

namespace fileinfo.Views
{
    public partial class CheckSumViewComponent : TextViewComponent
    {
        public CheckSumViewComponent(Func<byte, bool, char> encoding) : base(encoding)
        {
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

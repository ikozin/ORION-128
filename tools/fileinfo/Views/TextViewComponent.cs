using fileinfo.Models;
using System.Text;

namespace fileinfo.Views
{
    internal class TextViewComponent : ViewComponent<TextBox>
    {
        public TextViewComponent(): base()
        {
            _control.Font = new System.Drawing.Font("Cascadia Mono", 9F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point);
            //_control.Location = new Point(0, 0);
            _control.Multiline = true;
            _control.ScrollBars = ScrollBars.Both;
            //_control.Size = new Size(182, 374);
            _control.TabIndex = 0;
            _control.WordWrap = false;

        }
        public override void ReloadData(FileDetails detail, Func<byte, bool, char> encoding)
        {
            _control.Text = String.Empty;
            if (detail.Content.Length == 0) return;

            var text = new StringBuilder();
            foreach (var item in detail.Content)
            {
                text.Append(encoding(item, true));
            }
            text.Replace("\r", Environment.NewLine);
            _control.Text = text.ToString();
        }
    }
}

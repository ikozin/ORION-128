﻿using System.Text;

namespace fileinfo.Views
{
    public partial class TextViewComponent : ViewComponent
    {
        public TextViewComponent() : base()
        {
            InitializeComponent();
        }

        public TextViewComponent(Func<byte, bool, char> encoding) : base(encoding)
        {
            InitializeComponent();
            ClearView();
        }

        protected override void ClearView()
        {
            textBoxView.Text = String.Empty;
            textBoxView.Enabled = false;
        }

        protected override void LoadView()
        {
            var text = new StringBuilder();
            foreach (var item in _detail!.Content)
            {
                text.Append(_encoding!(item, true));
            }
            text.Replace("\r", Environment.NewLine);
            textBoxView.Text = text.ToString();
            textBoxView.Enabled = true;
        }
    }
}

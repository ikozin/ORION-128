﻿namespace fileinfo.Views
{
    public partial class HexViewComponent : HexWithAddrViewComponent
    {
        public HexViewComponent() : base()
        {
        }

        public HexViewComponent(Func<byte, bool, char> encoding) : base(encoding)
        {
        }

        protected override void LoadView()
        {
            fastColoredTextBoxView.Text = ByteArrayToHex(0);
            fastColoredTextBoxView.Enabled = true;
        }
    }
}

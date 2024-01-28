namespace fileinfo.Controls
{
    internal class TextEncodingTool
    {
        public Func<byte, bool, char> CurrentHandler { get; set; }
        public Action ClickAction { get; private set; }

        private readonly ToolStripDropDownButton _parent;
        private readonly Func<bool> _enableFunc;


        public TextEncodingTool(ToolStripDropDownButton parent, Func<bool> enableFunc, Action clickAction)
        {
            _enableFunc = enableFunc;
            ClickAction = clickAction;
            CurrentHandler = DefaultCurrentHandler;
            _parent = parent;
            _parent.DropDownItems.Clear();
            _parent.DropDownOpening += ToolStripMenuItemDropDownOpening;
        }

        public void Add(string text, Func<byte, bool, char> handler)
        {
            var item = new ToolStripMenuItemEncoding(this, text, handler);
            _parent.DropDownItems.Add(item);
        }

        private void ToolStripMenuItemDropDownOpening(object? sender, EventArgs e)
        {
            bool isEnable = _enableFunc();
            foreach (var item in _parent.DropDownItems)
            {
                var itemExt = (ToolStripMenuItemEncoding)item;
                itemExt.Enabled = isEnable;
                itemExt.Checked = itemExt.Handler == CurrentHandler;
            }
        }

        private static char DefaultCurrentHandler(byte data, bool fullSupport)
        {
            throw new NotImplementedException();
        }

    }
}

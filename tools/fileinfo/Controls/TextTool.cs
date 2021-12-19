using fileinfo.Models;

namespace fileinfo.Controls
{
    internal class TextTool
    {
        internal class ToolStripMenuItemTool : ToolStripMenuItem
        {
            public Func<FileDetails, Func<byte, bool, char>, string> Handler { get; private set; }
            private readonly TextTool _tool;
            public ToolStripMenuItemTool(TextTool tool, string text, Func<FileDetails, Func<byte, bool, char>, string> handler) :
                base(text)
            {
                _tool = tool;
                Handler = handler;
            }
            protected override void OnClick(EventArgs e)
            {
                _tool.CurrentHandler = Handler;
                _tool?.ClickAction();
            }
        }

        public Func<FileDetails, Func<byte, bool, char>, string>? CurrentHandler { get; set; }
        public Action ClickAction { get; private set; }

        private readonly ToolStripDropDownButton _parent;
        private readonly Func<bool> _enableFunc;


        public TextTool(ToolStripDropDownButton parent, Func<bool> enableFunc, Action clickAction)
        {
            _enableFunc = enableFunc;
            ClickAction = clickAction;
            CurrentHandler = null;
            _parent = parent;
            _parent.DropDownItems.Clear();
            _parent.DropDownOpening += ToolStripMenuItemDropDownOpening;
        }

        public void Add(string text, Func<FileDetails, Func<byte, bool, char>, string> handler)
        {
            var item = new ToolStripMenuItemTool(this, text, handler);
            _parent.DropDownItems.Add(item);
        }

        private void ToolStripMenuItemDropDownOpening(object? sender, EventArgs e)
        {
            bool isEnable = _enableFunc();
            foreach (var item in _parent.DropDownItems)
            {
                var itemExt = (ToolStripMenuItemTool)item;
                itemExt.Enabled = isEnable;
                itemExt.Checked = itemExt.Handler == CurrentHandler;
            }
        }
    }
}

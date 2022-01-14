using fileinfo.Views;

namespace fileinfo.Controls
{
    internal class TextFormatTool
    {
        public Action ClickAction { get; private set; }

        private IViewComponent? _сurrentView;
        private readonly ToolStripDropDownButton _tool;
        private readonly Func<bool> _enableFunc;


        public TextFormatTool(ToolStripDropDownButton parent, Func<bool> enableFunc, Action clickAction)
        {
            _enableFunc = enableFunc;
            ClickAction = clickAction;
            _сurrentView = null;
            _tool = parent;
            _tool.DropDownItems.Clear();
            _tool.DropDownOpening += ToolStripMenuItemDropDownOpening;
        }
        public IViewComponent? CurrentView
        {
            get
            {
                return _сurrentView;
            }
            set
            {
                _сurrentView = value;
                ClickAction();
            }
        }

        public void Add()
        {
            var item = new ToolStripSeparator();
            _tool.DropDownItems.Add(item);
        }

        public void Add(string text, IViewComponent component, Bitmap? image = null)
        {
            var item = new ToolStripMenuItemFormat(this, text, component);
            item.ImageScaling = ToolStripItemImageScaling.None;
            item.Image = image;
            _tool.DropDownItems.Add(item);
        }

        private void ToolStripMenuItemDropDownOpening(object? sender, EventArgs e)
        {
            bool isEnable = _enableFunc();
            foreach (var item in _tool.DropDownItems)
            {
                var itemExt = item as ToolStripMenuItemFormat;
                if (itemExt == null) continue;
                itemExt.Enabled = isEnable;
                itemExt.Checked = itemExt.Component == CurrentView;
            }
        }
        public IViewComponent[] GetViews()
        {
            var result = new List<IViewComponent>();
            foreach (ToolStripItem item in _tool.DropDownItems)
            {
                var itemExt = item as ToolStripMenuItemFormat;
                if (itemExt == null) continue;
                result.Add(itemExt.Component);
            }
            return result.ToArray();
        }
    }
}

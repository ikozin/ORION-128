﻿using fileinfo.Views;

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

        public void Add(string text, IViewComponent component)
        {
            var item = new ToolStripMenuItemFormat(this, text, component);
            _tool.DropDownItems.Add(item);
        }

        private void ToolStripMenuItemDropDownOpening(object? sender, EventArgs e)
        {
            bool isEnable = _enableFunc();
            foreach (var item in _tool.DropDownItems)
            {
                var itemExt = (ToolStripMenuItemFormat)item;
                itemExt.Enabled = isEnable;
                itemExt.Checked = itemExt.Component == CurrentView;
            }
        }
        public IViewComponent[] GetViews()
        {
            var result = new List<IViewComponent>();
            foreach (ToolStripMenuItemFormat item in _tool.DropDownItems)
            {
                result.Add(item.Component);
            }
            return result.ToArray();
        }
    }
}

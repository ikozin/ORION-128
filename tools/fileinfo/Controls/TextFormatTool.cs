using fileinfo.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace fileinfo.Controls
{
    internal class TextFormatTool
    {
        public Func<FileDetails, Func<byte, bool, char>, string>? CurrentHandler { get; set; }
        public Action ClickAction { get; private set; }

        private readonly ToolStripDropDownButton _tool;
        private readonly Func<bool> _enableFunc;


        public TextFormatTool(ToolStripDropDownButton parent, Func<bool> enableFunc, Action clickAction)
        {
            _enableFunc = enableFunc;
            ClickAction = clickAction;
            CurrentHandler = null;
            _tool = parent;
            _tool.DropDownItems.Clear();
            _tool.DropDownOpening += ToolStripMenuItemDropDownOpening;
        }

        public void Add(string text, Func<FileDetails, Func<byte, bool, char>, string> handler)
        {
            var item = new ToolStripMenuItemFormat(this, text, handler);
            _tool.DropDownItems.Add(item);
        }

        private void ToolStripMenuItemDropDownOpening(object? sender, EventArgs e)
        {
            bool isEnable = _enableFunc();
            foreach (var item in _tool.DropDownItems)
            {
                var itemExt = (ToolStripMenuItemFormat)item;
                itemExt.Enabled = isEnable;
                itemExt.Checked = itemExt.Handler == CurrentHandler;
            }
        }
    }
}

using fileinfo.Models;

namespace fileinfo.Controls
{
    internal class ToolStripMenuItemFormat: ToolStripMenuItem
    {
        public Func<FileDetails, Func<byte, bool, char>, string> Handler { get; private set; }
        private readonly TextFormatTool _tool;
        public ToolStripMenuItemFormat(TextFormatTool tool, string text, Func<FileDetails, Func<byte, bool, char>, string> handler) :
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
}

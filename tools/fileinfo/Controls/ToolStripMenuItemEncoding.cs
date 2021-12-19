namespace fileinfo.Controls
{
    internal class ToolStripMenuItemEncoding: ToolStripMenuItem
    {
        public Func<byte, bool, char> Handler { get; private set; }
        private readonly TextEncodingTool _tool;
        public ToolStripMenuItemEncoding(TextEncodingTool tool, string text, Func<byte, bool, char> handler):
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

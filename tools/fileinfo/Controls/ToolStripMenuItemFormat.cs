using fileinfo.Views;

namespace fileinfo.Controls
{
    internal class ToolStripMenuItemFormat : ToolStripMenuItem
    {
        public IViewComponent Component { get; private set; }
        private readonly TextFormatTool _tool;
        public ToolStripMenuItemFormat(TextFormatTool tool, string text, IViewComponent component) :
            base(text)
        {
            _tool = tool;
            Component = component;
        }
        protected override void OnClick(EventArgs e)
        {
            _tool.CurrentView = Component;
            _tool?.ClickAction();
        }
    }
}

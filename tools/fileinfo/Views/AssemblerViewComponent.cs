namespace fileinfo.Views
{
    public partial class AssemblerViewComponent : TextViewComponent
    {
        public AssemblerViewComponent(Func<byte, bool, char> encoding) : base(encoding)
        {
            if (File.Exists("SyntaxHighlighterAsssebler.xml"))
                fastColoredTextBoxView.DescriptionFile = "SyntaxHighlighterAsssebler.xml";
            _extension = "asm";
            _filter = "Assemblers files|*.asm|All files|*.*";
        }
    }
}

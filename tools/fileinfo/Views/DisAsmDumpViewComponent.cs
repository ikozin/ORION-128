using fileinfo.Helpers;
using System.Data;
using System.Text;

namespace fileinfo.Views
{
    public partial class DisAsmDumpViewComponent : ViewComponent
    {

        protected string? _extension;
        protected string? _filter;

        private int _count;

        public DisAsmDumpViewComponent()
        {
            InitializeComponent();
        }

        public DisAsmDumpViewComponent(Func<byte, bool, char> encoding) : base(encoding)
        {
            InitializeComponent();
            if (!File.Exists(fastColoredTextBoxView.DescriptionFile))
                fastColoredTextBoxView.DescriptionFile = "";
            ClearView();
            comboBoxCount.SelectedIndex = 0;
            comboBoxCount.SelectedIndexChanged += ComboBoxCount_SelectedIndexChanged;
            _count = int.Parse(comboBoxCount.SelectedItem!.ToString()!);
            _extension = "asm";
            _filter = "Assemblers files|*.asm|All files|*.*";
        }

        private void ComboBoxCount_SelectedIndexChanged(object? sender, EventArgs e)
        {
            _count = int.Parse(comboBoxCount.SelectedItem!.ToString()!);
            LoadView();
        }

        protected override void ClearView()
        {
            fastColoredTextBoxView.Text = string.Empty;
            fastColoredTextBoxView.Enabled = false;
            panelTool.Enabled = false;
        }

        protected override void LoadView()
        {
            var text = new StringBuilder();

            text.Append("ORG ");
            text.AppendLine(_detail!.Address.ToHexAsm());
            text.AppendLine();

            try
            {
                int pos = 0;
                do
                {
                    var line = _detail.Content.Skip(pos).Take(_count).Select(b => b.ToHexAsm());
                    if (line.Any())
                    {
                        text.Append("DB   ");
                        text.AppendLine(String.Join(", ", line));
                    }
                    pos += line.Count();
                }
                while (pos < _detail.Content.Length);
            }
            catch (Exception ex)
            {
                text.AppendLine(ex.Message);
            }

            fastColoredTextBoxView.Text = text.ToString();
            fastColoredTextBoxView.Enabled = true;
            panelTool.Enabled = true;
        }
        public override void SaveDetailToFile()
        {
            if (_detail == null) return;
            using SaveFileDialog dlg = new();
            dlg.DefaultExt = _extension;
            dlg.Filter = _filter;
            dlg.FileName = _detail.Name;
            if (dlg.ShowDialog(this) != DialogResult.OK) return;
            File.WriteAllText(dlg.FileName, fastColoredTextBoxView.Text, Encoding.UTF8);
        }
    }
}

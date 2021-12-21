using fileinfo.Controls;
using fileinfo.Helpers;
using fileinfo.Models;
using fileinfo.Views;
using System.Diagnostics;

namespace fileinfo
{
    public partial class MainForm : Form
    {
        private Func<ListView, FileDetails, ListViewGroup> _actionGroup;
        private Action<ListView> _actionGroupFinish;
        private readonly TextEncodingTool _encoding;
        private readonly TextFormatTool _format;
        private readonly List<FileDetails> _listDetails = new List<FileDetails>(1024);

        public MainForm()
        {
            InitializeComponent();

            _actionGroup = GroupByExtension.GetGroupByExec;
            _actionGroupFinish = GroupByExtension.GetGroupByCommonFinish;

            _encoding = new TextEncodingTool(toolStripDropDownButtonEncoding,
                IsSelectedItem, RefreshFileView);
            _encoding.Add("КОИ-7 Н2", EncodingExtension.Convert_Koi7N2);
            _encoding.Add("КОИ-8R", EncodingExtension.Convert_Koi8R);
            _encoding.Add("CP866", EncodingExtension.Convert_Cp866);
            _encoding.CurrentHandler = EncodingExtension.Convert_Koi7N2;

            _format = new TextFormatTool(toolStripDropDownButtonFormat,
                IsSelectedItem, SetCurrentView);
            _format.Add("HEX с адреса", new HexWithAddrViewComponent());
            _format.Add("HEX", new HexViewComponent());
            _format.Add("Текст", new TextViewComponent());
            _format.Add("Картинка", new PictureViewComponent());
            _format.Add("Дизассемблер", new DisAssemblerViewComponent());
            _format.Add("Дизассемблер (Dump)", new DisAsmDumpViewComponent());
            _format.CurrentView = _format.GetViews()[3];//.Last();
            SetCurrentView();
        }

        private void toolStripButtonSelectDirectory_Click(object sender, EventArgs e)
        {
            if (folderBrowserDialog.ShowDialog(this) != DialogResult.OK) return;
            _listDetails.Clear();
            LoadFiles<BruFileDetails>(_listDetails, folderBrowserDialog.SelectedPath, "*.bru");
            //LoadFiles<OrdFileDetails>(_listDetails, folderBrowserDialog.SelectedPath, "*.ord");
            //LoadFiles<RkoFileDetails>(_listDetails, folderBrowserDialog.SelectedPath, "*.rko");
            _listDetails.Sort();

            RefreshGroupView();
        }

        private void RefreshGroupView()
        {
            listViewFile.BeginUpdate();
            listViewFile.Groups.Clear();
            listViewFile.Items.Clear();

            foreach (var f in _listDetails)
            {
                var item = listViewFile.Items.Add(Path.GetFileName(f.FileName));
                item.SubItems.Add(f.Name);
                item.SubItems.Add(f.Size.ToHexWithNumber());
                item.SubItems.Add(f.Address.ToHex());
                item.SubItems.Add(f.Hash.ToHex());
                item.SubItems.Add(f.FileName);

                item.Tag = f;
                item.ToolTipText = f.Message;

                item.Group = _actionGroup(listViewFile, f);
            }
            _actionGroupFinish(listViewFile);
            listViewFile.AutoResizeColumns(ColumnHeaderAutoResizeStyle.ColumnContent);
            listViewFile.EndUpdate();
            RefreshFileView();
        }

        private static void LoadFiles<T>(List<FileDetails> list, string path, string extension)
            where T : FileDetails, new()
        {
            var files = Directory.EnumerateFiles(path, extension, SearchOption.AllDirectories);
            foreach (var file in files)
            {
                T f = new T();
                f.LoadData(file);
                list.Add(f);
            }
        }

        private void directoryToolStripMenuItem_Click(object sender, EventArgs e)
        {

            var path = listViewFile.SelectedItems[0].SubItems[columnHeaderPath.Index].Text;
            //Process.Start(new ProcessStartInfo("explorer.exe", " /select, " + @"C:\Repos\Temp\orion_all_prog\Orion-Tech\Texts\TXT2\z80cardII.txt"));
            Process explorer = new Process();
            explorer.StartInfo.UseShellExecute = true;
            explorer.StartInfo.FileName = "explorer.exe";
            explorer.StartInfo.Arguments = String.Format("/select, \"{0}\"", path);
            explorer.Start();
        }

        private void contextMenuStripFile_Opening(object sender, System.ComponentModel.CancelEventArgs e)
        {
            directoryToolStripMenuItem.Enabled = IsSelectedItem();
        }

        private void listViewFile_ItemSelectionChanged(object sender, ListViewItemSelectionChangedEventArgs e)
        {
            RefreshFileView();
        }

        private bool IsSelectedItem()
        {
            return listViewFile.SelectedItems.Count > 0;
        }

        private void SetCurrentView()
        {
            var control = _format.CurrentView!.GetViewControl();
            if (!panelViewComponent.Controls.Contains(control))
            {
                panelViewComponent.SuspendLayout();
                panelViewComponent.Controls.Clear();
                panelViewComponent.Controls.Add(control);
                panelViewComponent.ResumeLayout();
            }
            RefreshFileView();
        }

        private void RefreshFileView()
        {
            var item = IsSelectedItem() ? listViewFile.SelectedItems[0] : null;
            if (item == null)
            {
                _format.CurrentView!.ClearView();
                toolStripStatusLabelSum.Text = String.Empty;
                return;
            }
            var detail = (FileDetails)item.Tag;
            _format.CurrentView!.ReloadView(detail, _encoding.CurrentHandler!);
            toolStripStatusLabelSum.Text = ContentToCheckSum.Process(detail, _encoding.CurrentHandler!);
        }

        private void toolStripSplitButtonGroupByExec_Click(object sender, EventArgs e)
        {
            _actionGroup = GroupByExtension.GetGroupByExec;
            _actionGroupFinish = GroupByExtension.GetGroupByCommonFinish;
            RefreshGroupView();
        }

        private void toolStripSplitButtonGroupByPath_Click(object sender, EventArgs e)
        {
            _actionGroup = GroupByExtension.GetGroupByPath;
            _actionGroupFinish = GroupByExtension.GetGroupByCommonFinish;
            RefreshGroupView();
        }

        private void toolStripSplitButtonGroupByCustom_Click(object sender, EventArgs e)
        {
            _actionGroup = GroupByExtension.GetGroupByCustom;
            _actionGroupFinish = GroupByExtension.GetGroupByCommonFinish;
            RefreshGroupView();
        }

        private void toolStripSplitButtonGroupByHash_Click(object sender, EventArgs e)
        {
            _actionGroup = GroupByExtension.GetGroupByHash;
            _actionGroupFinish = GroupByExtension.GetGroupByHashFinish;
            RefreshGroupView();
        }
    }
}
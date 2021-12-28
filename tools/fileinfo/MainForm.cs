using fileinfo.Controls;
using fileinfo.Helpers;
using fileinfo.Models;
using fileinfo.Views;
using System.Diagnostics;

namespace fileinfo
{
    public partial class MainForm : Form
    {
        private Action<ListView, List<IFileDetail>> _actionGroupStart;
        private Func<ListView, IFileDetail, ListViewGroup> _actionGroup;
        private Action<ListView> _actionGroupFinish;
        private readonly TextEncodingTool _encoding;
        private readonly TextFormatTool _format;
        private readonly List<IFileDetail> _listDetails = new(1024);

        public MainForm()
        {
            InitializeComponent();

            _actionGroupStart = GroupByExtension.GetGroupByExecStart;
            _actionGroup = GroupByExtension.GetGroupByExec;
            _actionGroupFinish = GroupByExtension.GetGroupByCommonFinish;

            _encoding = new TextEncodingTool(toolStripDropDownButtonEncoding,
                IsSelectedItem, SetFileViewEncoding);
            _encoding.Add("КОИ-7 Н2", EncodingExtension.Convert_Koi7N2);
            _encoding.Add("КОИ-8R", EncodingExtension.Convert_Koi8R);
            _encoding.Add("CP866", EncodingExtension.Convert_Cp866);
            _encoding.CurrentHandler = EncodingExtension.Convert_Koi7N2;

            _format = new TextFormatTool(toolStripDropDownButtonFormat,
                IsSelectedItem, SetFileViewCurrent);
            _format.Add("HEX с адреса", new HexWithAddrViewComponent(_encoding.CurrentHandler));
            _format.Add("HEX", new HexViewComponent(_encoding.CurrentHandler));
            _format.Add("Текст", new TextViewComponent(_encoding.CurrentHandler));
            _format.Add("Картинка", new PictureViewComponent(_encoding.CurrentHandler));
            _format.Add("Дизассемблер", new DisAssemblerViewComponent(_encoding.CurrentHandler));
            _format.Add("Дизассемблер (Dump)", new DisAsmDumpViewComponent(_encoding.CurrentHandler));
            _format.Add();
            _format.Add("Ассемблер", new AssemblerViewComponent(_encoding.CurrentHandler));
            _format.Add("Бейсик", new BasicViewComponent(_encoding.CurrentHandler));
            _format.CurrentView = _format.GetViews().First();
        }

        private void toolStripButtonSelectDirectory_Click(object sender, EventArgs e)
        {
            if (folderBrowserDialog.ShowDialog(this) != DialogResult.OK) return;
            _listDetails.Clear();
            LoadFiles<BruFileDetail>(_listDetails, folderBrowserDialog.SelectedPath, "*.bru");
            LoadFiles<OrdFileDetail>(_listDetails, folderBrowserDialog.SelectedPath, "*.ord");
            LoadFiles<RkoFileDetail>(_listDetails, folderBrowserDialog.SelectedPath, "*.rko");
            _listDetails.Sort();

            RefreshGroupView();
        }

        private static void LoadFiles<T>(List<IFileDetail> list, string path, string extension)
            where T : IFileDetail, new()
        {
            var files = Directory.EnumerateFiles(path, extension, SearchOption.AllDirectories);
            foreach (var file in files)
            {
                IFileDetail detail = new T();
                list.Add(detail.LoadData(file));
            }
        }

        private bool IsSelectedItem()
        {
            return listViewFile.SelectedItems.Count > 0;
        }

        private void SetFileViewEncoding()
        {
            _format.CurrentView?.SetEncoding(_encoding.CurrentHandler!);
        }

        private void SetFileViewCurrent()
        {
            panelViewComponent.SuspendLayout();
            panelViewComponent.Controls.Clear();
            var control = _format.CurrentView;
            if (control != null)
            {
                panelViewComponent.Controls.Add(control.Control);
                control.Control.Dock = DockStyle.Fill;
                control.Current = IsSelectedItem() ?
                    ((ListViewItemExt)listViewFile.SelectedItems[0]).Detail :
                    null;
            }
            panelViewComponent.ResumeLayout();
        }

        private void RefreshGroupView()
        {
            _format.CurrentView = null;
            listViewFile.BeginUpdate();
            listViewFile.Groups.Clear();
            listViewFile.Items.Clear();

            _actionGroupStart(listViewFile, _listDetails);
            foreach (var file in _listDetails)
            {
                ListViewItemExt item = new(file);
                listViewFile.Items.Add(item);
                item.Group = _actionGroup(listViewFile, file);
            }
            _actionGroupFinish(listViewFile);
            listViewFile.AutoResizeColumns(ColumnHeaderAutoResizeStyle.ColumnContent);
            listViewFile.EndUpdate();
        }

        private void directoryToolStripMenuItem_Click(object sender, EventArgs e)
        {

            var path = listViewFile.SelectedItems[0].SubItems[columnHeaderPath.Index].Text;
            //Process.Start(new ProcessStartInfo("explorer.exe", " /select, " + @"C:\Repos\Temp\orion_all_prog\Orion-Tech\Texts\TXT2\z80cardII.txt"));
            Process explorer = new();
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
            var control = _format.CurrentView;
            if (control != null)
            {
                if (e.IsSelected)
                {
                    control.Current = ((ListViewItemExt)e.Item).Detail;
                }
            }
        }

        private void toolStripSplitButtonGroupByExec_Click(object sender, EventArgs e)
        {
            _actionGroupStart = GroupByExtension.GetGroupByExecStart;
            _actionGroup = GroupByExtension.GetGroupByExec;
            _actionGroupFinish = GroupByExtension.GetGroupByCommonFinish;
            RefreshGroupView();
        }

        private void toolStripSplitButtonGroupByPath_Click(object sender, EventArgs e)
        {
            _actionGroupStart = GroupByExtension.GetGroupByPathStart;
            _actionGroup = GroupByExtension.GetGroupByPath;
            _actionGroupFinish = GroupByExtension.GetGroupByCommonFinish;
            RefreshGroupView();
        }

        private void toolStripSplitButtonGroupByCustom_Click(object sender, EventArgs e)
        {
            _actionGroupStart = GroupByExtension.GetGroupByCustomStart;
            _actionGroup = GroupByExtension.GetGroupByCustom;
            _actionGroupFinish = GroupByExtension.GetGroupByCommonFinish;
            RefreshGroupView();
        }

        private void toolStripSplitButtonGroupByHash_Click(object sender, EventArgs e)
        {
            _actionGroupStart = GroupByExtension.GetGroupByCommonStart;
            _actionGroup = GroupByExtension.GetGroupByHash;
            _actionGroupFinish = GroupByExtension.GetGroupByHashFinish;
            RefreshGroupView();
        }

        private void toolStripButtonSave_Click(object sender, EventArgs e)
        {
            if (_format.CurrentView == null) return;
            _format.CurrentView.SaveDetailToFile();
        }
    }
}
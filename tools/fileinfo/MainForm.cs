using fileinfo.Controls;
using fileinfo.Helpers;
using fileinfo.Models;
using fileinfo.Views;
using System.Diagnostics;

namespace fileinfo
{
    public partial class MainForm : Form
    {
        private Action<List<TreeNodeExt>> _actionGroupStart;
        private Func<TreeView, IDetail, TreeNode> _actionGroup;
        private Action<TreeView> _actionGroupFinish;
        private readonly TextEncodingTool _encoding;
        private readonly TextFormatTool _format;
        private readonly List<TreeNodeExt> _listDetails = new(4096);

        public MainForm()
        {
            InitializeComponent();

            _actionGroupStart = GroupByExtension.GetGroupByCustomStart;
            _actionGroup = GroupByExtension.GetGroupByCustom;
            _actionGroupFinish = GroupByExtension.GetGroupByCommonFinish;

            _encoding = new TextEncodingTool(toolStripDropDownButtonEncoding,
                IsSelectedItem, SetFileViewEncoding);
            _encoding.Add("КОИ-7 Н2", EncodingExtension.Convert_Koi7N2);
            _encoding.Add("КОИ-8R", EncodingExtension.Convert_Koi8R);
            _encoding.Add("CP866", EncodingExtension.Convert_Cp866);
            _encoding.CurrentHandler = EncodingExtension.Convert_Koi7N2;

            _format = new TextFormatTool(toolStripDropDownButtonFormat,
                IsSelectedItem, SetFileViewCurrent);
            _format.Add("HEX с адреса", new HexWithAddrViewComponent(_encoding.CurrentHandler), global::fileinfo.Properties.Resources.type_hex);
            _format.Add("HEX", new HexViewComponent(_encoding.CurrentHandler), global::fileinfo.Properties.Resources.type_hex);
            _format.Add("Текст", new TextViewComponent(_encoding.CurrentHandler));
            _format.Add("Контрольная сумма", new CheckSumViewComponent(_encoding.CurrentHandler));
            _format.Add("Дизассемблер", new DisAssemblerViewComponent(_encoding.CurrentHandler));
            _format.Add("Дизассемблер (Dump)", new DisAsmDumpViewComponent(_encoding.CurrentHandler));
            _format.Add();
            _format.Add("(*.AS) Ассемблер", new AssemblerViewComponent(_encoding.CurrentHandler), global::fileinfo.Properties.Resources.type_as);
            _format.Add("(*.BS) Бейсик", new BasicViewComponent(_encoding.CurrentHandler), global::fileinfo.Properties.Resources.type_bs);
            _format.Add("(*.PC) Картинка", new PictureViewComponent(_encoding.CurrentHandler), global::fileinfo.Properties.Resources.type_pc);
            _format.CurrentView = null;
        }

        private void toolStripButtonSelectDirectory_Click(object sender, EventArgs e)
        {
            if (folderBrowserDialog.ShowDialog(this) != DialogResult.OK) return;
            _listDetails.Clear();

            //LoadFiles<BruFileDetail>(_listDetails, folderBrowserDialog.SelectedPath, "*.bru");
            //LoadFiles<OrdFileDetail>(_listDetails, folderBrowserDialog.SelectedPath, "*.ord");
            //LoadFiles<RkoFileDetail>(_listDetails, folderBrowserDialog.SelectedPath, "*.rko");
            //LoadFiles<OdiFileDetail>(_listDetails, folderBrowserDialog.SelectedPath, "*.odi");

            List<Task> list = new List<Task>();
            list.Add(Task.Run(() => LoadFiles<BruFileDetail>(_listDetails, folderBrowserDialog.SelectedPath, "*.bru")));
            list.Add(Task.Run(() => LoadFiles<OrdFileDetail>(_listDetails, folderBrowserDialog.SelectedPath, "*.ord")));
            list.Add(Task.Run(() => LoadFiles<RkoFileDetail>(_listDetails, folderBrowserDialog.SelectedPath, "*.rko")));
            list.Add(Task.Run(() => LoadFiles<OdiFileDetail>(_listDetails, folderBrowserDialog.SelectedPath, "*.odi")));
            Task.WaitAll(list.ToArray());

            _listDetails.Sort();

            RefreshGroupView();
        }

        private void LoadFiles<T>(ICollection<TreeNodeExt> list, string path, string extension)
            where T : IFileDetail, new()
        {
            var files = Directory.GetFiles(path, extension, SearchOption.AllDirectories);
            Parallel.For(0, files.Length, index =>
            {
                IFileDetail detail = new T();
                detail.LoadData(files[index], list);
            });
        }

        private bool IsSelectedItem()
        {
            return treeView.SelectedNode != null && treeView.SelectedNode.Level > 0;
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
                _format.CurrentView!.SetEncoding(_encoding.CurrentHandler!);
                panelViewComponent.Controls.Add(control.Control);
                control.Control.Dock = DockStyle.Fill;
                control.Current = IsSelectedItem() ?
                    ((TreeNodeExt)treeView.SelectedNode).Detail :
                    null;
            }
            panelViewComponent.ResumeLayout();
        }

        private void RefreshGroupView()
        {
            _format.CurrentView = null;
            treeView.BeginUpdate();
            treeView.Nodes.Clear();

            _actionGroupStart(_listDetails);
            foreach (var item in _listDetails)
            {
                var group = _actionGroup(treeView, item);
                group.Nodes.Add(item);
            }
            _actionGroupFinish(treeView);
            treeView.EndUpdate();

            System.GC.Collect();
            System.GC.WaitForFullGCComplete();
        }

        private void directoryToolStripMenuItem_Click(object sender, EventArgs e)
        {
            TreeViewHitTestInfo info = treeView.HitTest(treeView.PointToClient(Control.MousePosition));
            if (info.Node != null && info.Node.Level > 0)
            {
                var nodeExt = (TreeNodeExt)info.Node;
                var path = nodeExt.Detail.FileName;
                //Process.Start(new ProcessStartInfo("explorer.exe", " /select, " + @"C:\Repos\Temp\orion_all_prog\Orion-Tech\Texts\TXT2\z80cardII.txt"));
                int index = path.IndexOf('$');
                if (index != -1)
                {
                    path = path.Substring(0, index);
                }
                Process explorer = new();
                explorer.StartInfo.UseShellExecute = true;
                explorer.StartInfo.FileName = "explorer.exe";
                explorer.StartInfo.Arguments = String.Format("/select, \"{0}\"", path);
                explorer.Start();
            }
        }

        private void contextMenuStripFile_Opening(object sender, System.ComponentModel.CancelEventArgs e)
        {
            TreeViewHitTestInfo info = treeView.HitTest(treeView.PointToClient(Control.MousePosition));
            directoryToolStripMenuItem.Enabled = info.Node != null && info.Node.Level > 0;
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
        private void toolStripButtonExport_Click(object sender, EventArgs e)
        {
            if (_format.CurrentView == null) return;
            if (_format.CurrentView.Current == null) return;
            saveFileDialog.FileName = _format.CurrentView.Current.Name;
            if (saveFileDialog.ShowDialog(this) != DialogResult.OK) return;
            File.WriteAllBytes(saveFileDialog.FileName, _format.CurrentView.Current.Content);
        }

        private void toolStripButtonOdi_Click(object sender, EventArgs e)
        {
            if (openFileDialog.ShowDialog(this) != DialogResult.OK) return;
            ExtractOdiHelper.ExtractFiles(openFileDialog.FileName, true);
        }

        private void treeView_AfterSelect(object sender, TreeViewEventArgs e)
        {
            var control = _format.CurrentView;
            if (control != null)
            {
                if (e.Node == null || e.Node.Level == 0)
                {
                    control.Current = null;
                }
                else
                {
                    control.Current = ((TreeNodeExt)e.Node).Detail;
                }
            }
        }
    }
}
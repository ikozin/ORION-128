namespace fileinfo
{
    partial class MainForm
    {
        /// <summary>
        ///  Required designer variable.
        /// </summary>
        private System.ComponentModel.IContainer components = null;

        /// <summary>
        ///  Clean up any resources being used.
        /// </summary>
        /// <param name="disposing">true if managed resources should be disposed; otherwise, false.</param>
        protected override void Dispose(bool disposing)
        {
            if (disposing && (components != null))
            {
                components.Dispose();
            }
            base.Dispose(disposing);
        }

        #region Windows Form Designer generated code

        /// <summary>
        ///  Required method for Designer support - do not modify
        ///  the contents of this method with the code editor.
        /// </summary>
        private void InitializeComponent()
        {
            components = new System.ComponentModel.Container();
            ToolStrip toolStripFileView;
            System.ComponentModel.ComponentResourceManager resources = new System.ComponentModel.ComponentResourceManager(typeof(MainForm));
            ToolStripDropDownButton toolStripDropDownButtonOpenFile;
            ToolStripMenuItem toolStripMenuItemHex;
            ToolStripMenuItem toolStripMenuItemText;
            ToolStripSeparator toolStripSeparator2;
            ToolStripMenuItem toolStripMenuItemAs;
            ToolStripMenuItem toolStripMenuItemBs;
            ToolStripMenuItem toolStripMenuItemPc;
            toolStripDropDownButtonFormat = new ToolStripDropDownButton();
            toolStripDropDownButtonEncoding = new ToolStripDropDownButton();
            toolStripButtonSave = new ToolStripButton();
            toolStripButtonExport = new ToolStripButton();
            splitContainerInfo = new SplitContainer();
            treeView = new TreeView();
            contextMenuStripFile = new ContextMenuStrip(components);
            directoryToolStripMenuItem = new ToolStripMenuItem();
            panelViewComponent = new Panel();
            folderBrowserDialog = new FolderBrowserDialog();
            saveFileDialog = new SaveFileDialog();
            toolStripButtonSelectDirectory = new ToolStripButton();
            toolStripSplitButtonGrouping = new ToolStripDropDownButton();
            toolStripSplitButtonGroupByExec = new ToolStripMenuItem();
            toolStripSplitButtonGroupByPath = new ToolStripMenuItem();
            toolStripSplitButtonGroupByCustom = new ToolStripMenuItem();
            toolStripSplitButtonGroupByHash = new ToolStripMenuItem();
            toolStripButtonOdi = new ToolStripButton();
            toolStripMain = new ToolStrip();
            toolStripSeparator1 = new ToolStripSeparator();
            openFileDialog = new OpenFileDialog();
            toolStripFileView = new ToolStrip();
            toolStripDropDownButtonOpenFile = new ToolStripDropDownButton();
            toolStripMenuItemHex = new ToolStripMenuItem();
            toolStripMenuItemText = new ToolStripMenuItem();
            toolStripSeparator2 = new ToolStripSeparator();
            toolStripMenuItemAs = new ToolStripMenuItem();
            toolStripMenuItemBs = new ToolStripMenuItem();
            toolStripMenuItemPc = new ToolStripMenuItem();
            toolStripFileView.SuspendLayout();
            ((System.ComponentModel.ISupportInitialize)splitContainerInfo).BeginInit();
            splitContainerInfo.Panel1.SuspendLayout();
            splitContainerInfo.Panel2.SuspendLayout();
            splitContainerInfo.SuspendLayout();
            contextMenuStripFile.SuspendLayout();
            toolStripMain.SuspendLayout();
            SuspendLayout();
            // 
            // toolStripFileView
            // 
            toolStripFileView.ImageScalingSize = new Size(20, 20);
            toolStripFileView.Items.AddRange(new ToolStripItem[] { toolStripDropDownButtonFormat, toolStripDropDownButtonEncoding, toolStripButtonSave, toolStripButtonExport });
            toolStripFileView.Location = new Point(0, 0);
            toolStripFileView.Name = "toolStripFileView";
            toolStripFileView.Size = new Size(530, 39);
            toolStripFileView.TabIndex = 2;
            toolStripFileView.Text = "toolStrip1";
            // 
            // toolStripDropDownButtonFormat
            // 
            toolStripDropDownButtonFormat.Image = Properties.Resources.script;
            toolStripDropDownButtonFormat.ImageScaling = ToolStripItemImageScaling.None;
            toolStripDropDownButtonFormat.ImageTransparentColor = Color.Magenta;
            toolStripDropDownButtonFormat.Name = "toolStripDropDownButtonFormat";
            toolStripDropDownButtonFormat.Size = new Size(81, 36);
            toolStripDropDownButtonFormat.Text = "Вид";
            // 
            // toolStripDropDownButtonEncoding
            // 
            toolStripDropDownButtonEncoding.Image = (Image)resources.GetObject("toolStripDropDownButtonEncoding.Image");
            toolStripDropDownButtonEncoding.ImageScaling = ToolStripItemImageScaling.None;
            toolStripDropDownButtonEncoding.ImageTransparentColor = Color.Magenta;
            toolStripDropDownButtonEncoding.Name = "toolStripDropDownButtonEncoding";
            toolStripDropDownButtonEncoding.Size = new Size(123, 36);
            toolStripDropDownButtonEncoding.Text = "Кодировка";
            // 
            // toolStripButtonSave
            // 
            toolStripButtonSave.Image = Properties.Resources.disk;
            toolStripButtonSave.ImageScaling = ToolStripItemImageScaling.None;
            toolStripButtonSave.ImageTransparentColor = Color.Magenta;
            toolStripButtonSave.Name = "toolStripButtonSave";
            toolStripButtonSave.Size = new Size(119, 36);
            toolStripButtonSave.Text = "Сохранить";
            toolStripButtonSave.Click += toolStripButtonSave_Click;
            // 
            // toolStripButtonExport
            // 
            toolStripButtonExport.Image = Properties.Resources.disk;
            toolStripButtonExport.ImageScaling = ToolStripItemImageScaling.None;
            toolStripButtonExport.ImageTransparentColor = Color.Magenta;
            toolStripButtonExport.Name = "toolStripButtonExport";
            toolStripButtonExport.Size = new Size(103, 36);
            toolStripButtonExport.Text = "Извлечь";
            toolStripButtonExport.ToolTipText = "Сохранить в формате BRU";
            toolStripButtonExport.Click += toolStripButtonExport_Click;
            // 
            // toolStripDropDownButtonOpenFile
            // 
            toolStripDropDownButtonOpenFile.DisplayStyle = ToolStripItemDisplayStyle.Text;
            toolStripDropDownButtonOpenFile.DropDownItems.AddRange(new ToolStripItem[] { toolStripMenuItemHex, toolStripMenuItemText, toolStripSeparator2, toolStripMenuItemAs, toolStripMenuItemBs, toolStripMenuItemPc });
            toolStripDropDownButtonOpenFile.Image = (Image)resources.GetObject("toolStripDropDownButtonOpenFile.Image");
            toolStripDropDownButtonOpenFile.ImageTransparentColor = Color.Magenta;
            toolStripDropDownButtonOpenFile.Name = "toolStripDropDownButtonOpenFile";
            toolStripDropDownButtonOpenFile.Size = new Size(86, 24);
            toolStripDropDownButtonOpenFile.Text = "Open File";
            toolStripDropDownButtonOpenFile.ToolTipText = "Open File";
            // 
            // toolStripMenuItemHex
            // 
            toolStripMenuItemHex.Name = "toolStripMenuItemHex";
            toolStripMenuItemHex.Size = new Size(223, 26);
            toolStripMenuItemHex.Text = "HEX ...";
            toolStripMenuItemHex.Click += toolStripMenuItemHex_Click;
            // 
            // toolStripMenuItemText
            // 
            toolStripMenuItemText.Name = "toolStripMenuItemText";
            toolStripMenuItemText.Size = new Size(223, 26);
            toolStripMenuItemText.Text = "Текст ...";
            toolStripMenuItemText.Click += toolStripMenuItemText_Click;
            // 
            // toolStripSeparator2
            // 
            toolStripSeparator2.Name = "toolStripSeparator2";
            toolStripSeparator2.Size = new Size(220, 6);
            // 
            // toolStripMenuItemAs
            // 
            toolStripMenuItemAs.Name = "toolStripMenuItemAs";
            toolStripMenuItemAs.Size = new Size(223, 26);
            toolStripMenuItemAs.Text = "(*.AS) Ассемблер ...";
            toolStripMenuItemAs.Click += toolStripMenuItemAs_Click;
            // 
            // toolStripMenuItemBs
            // 
            toolStripMenuItemBs.Name = "toolStripMenuItemBs";
            toolStripMenuItemBs.Size = new Size(223, 26);
            toolStripMenuItemBs.Text = "(*.BS) Бейсик ...";
            toolStripMenuItemBs.Click += toolStripMenuItemBs_Click;
            // 
            // toolStripMenuItemPc
            // 
            toolStripMenuItemPc.Name = "toolStripMenuItemPc";
            toolStripMenuItemPc.Size = new Size(223, 26);
            toolStripMenuItemPc.Text = "(*.PC) Картинка ...";
            toolStripMenuItemPc.Click += toolStripMenuItemPc_Click;
            // 
            // splitContainerInfo
            // 
            splitContainerInfo.Cursor = Cursors.VSplit;
            splitContainerInfo.Dock = DockStyle.Fill;
            splitContainerInfo.Location = new Point(0, 27);
            splitContainerInfo.Name = "splitContainerInfo";
            // 
            // splitContainerInfo.Panel1
            // 
            splitContainerInfo.Panel1.Controls.Add(treeView);
            splitContainerInfo.Panel1.Cursor = Cursors.Default;
            // 
            // splitContainerInfo.Panel2
            // 
            splitContainerInfo.Panel2.Controls.Add(panelViewComponent);
            splitContainerInfo.Panel2.Controls.Add(toolStripFileView);
            splitContainerInfo.Panel2.Cursor = Cursors.Default;
            splitContainerInfo.Size = new Size(800, 423);
            splitContainerInfo.SplitterDistance = 266;
            splitContainerInfo.TabIndex = 2;
            // 
            // treeView
            // 
            treeView.ContextMenuStrip = contextMenuStripFile;
            treeView.Dock = DockStyle.Fill;
            treeView.FullRowSelect = true;
            treeView.HideSelection = false;
            treeView.Location = new Point(0, 0);
            treeView.Name = "treeView";
            treeView.ShowNodeToolTips = true;
            treeView.Size = new Size(266, 423);
            treeView.TabIndex = 0;
            treeView.AfterSelect += treeView_AfterSelect;
            // 
            // contextMenuStripFile
            // 
            contextMenuStripFile.ImageScalingSize = new Size(20, 20);
            contextMenuStripFile.Items.AddRange(new ToolStripItem[] { directoryToolStripMenuItem });
            contextMenuStripFile.Name = "contextMenuStripFile";
            contextMenuStripFile.Size = new Size(305, 28);
            contextMenuStripFile.Opening += contextMenuStripFile_Opening;
            // 
            // directoryToolStripMenuItem
            // 
            directoryToolStripMenuItem.Name = "directoryToolStripMenuItem";
            directoryToolStripMenuItem.Size = new Size(304, 24);
            directoryToolStripMenuItem.Text = "Открыть расположение файла ...";
            directoryToolStripMenuItem.Click += directoryToolStripMenuItem_Click;
            // 
            // panelViewComponent
            // 
            panelViewComponent.Dock = DockStyle.Fill;
            panelViewComponent.Location = new Point(0, 39);
            panelViewComponent.Name = "panelViewComponent";
            panelViewComponent.Size = new Size(530, 384);
            panelViewComponent.TabIndex = 4;
            // 
            // folderBrowserDialog
            // 
            folderBrowserDialog.Description = "Выбрать директорию";
            folderBrowserDialog.RootFolder = Environment.SpecialFolder.MyComputer;
            folderBrowserDialog.ShowNewFolderButton = false;
            folderBrowserDialog.UseDescriptionForTitle = true;
            // 
            // saveFileDialog
            // 
            saveFileDialog.DefaultExt = "BRU";
            saveFileDialog.Filter = "BRU files|*.BRU";
            saveFileDialog.SupportMultiDottedExtensions = true;
            // 
            // toolStripButtonSelectDirectory
            // 
            toolStripButtonSelectDirectory.Image = Properties.Resources.folder;
            toolStripButtonSelectDirectory.ImageTransparentColor = Color.Magenta;
            toolStripButtonSelectDirectory.Name = "toolStripButtonSelectDirectory";
            toolStripButtonSelectDirectory.Size = new Size(196, 24);
            toolStripButtonSelectDirectory.Text = "Выбрать директорию ...";
            toolStripButtonSelectDirectory.Click += toolStripButtonSelectDirectory_Click;
            // 
            // toolStripSplitButtonGrouping
            // 
            toolStripSplitButtonGrouping.DropDownItems.AddRange(new ToolStripItem[] { toolStripSplitButtonGroupByExec, toolStripSplitButtonGroupByPath, toolStripSplitButtonGroupByCustom, toolStripSplitButtonGroupByHash });
            toolStripSplitButtonGrouping.Image = (Image)resources.GetObject("toolStripSplitButtonGrouping.Image");
            toolStripSplitButtonGrouping.ImageTransparentColor = Color.Magenta;
            toolStripSplitButtonGrouping.Name = "toolStripSplitButtonGrouping";
            toolStripSplitButtonGrouping.Size = new Size(105, 24);
            toolStripSplitButtonGrouping.Text = "Grouping";
            // 
            // toolStripSplitButtonGroupByExec
            // 
            toolStripSplitButtonGroupByExec.Name = "toolStripSplitButtonGroupByExec";
            toolStripSplitButtonGroupByExec.Size = new Size(309, 26);
            toolStripSplitButtonGroupByExec.Text = "Группировка по исполняемым";
            toolStripSplitButtonGroupByExec.Click += toolStripSplitButtonGroupByExec_Click;
            // 
            // toolStripSplitButtonGroupByPath
            // 
            toolStripSplitButtonGroupByPath.Name = "toolStripSplitButtonGroupByPath";
            toolStripSplitButtonGroupByPath.Size = new Size(309, 26);
            toolStripSplitButtonGroupByPath.Text = "Группировка по директории";
            toolStripSplitButtonGroupByPath.Click += toolStripSplitButtonGroupByPath_Click;
            // 
            // toolStripSplitButtonGroupByCustom
            // 
            toolStripSplitButtonGroupByCustom.Name = "toolStripSplitButtonGroupByCustom";
            toolStripSplitButtonGroupByCustom.Size = new Size(309, 26);
            toolStripSplitButtonGroupByCustom.Text = "Группировка по типу";
            toolStripSplitButtonGroupByCustom.Click += toolStripSplitButtonGroupByCustom_Click;
            // 
            // toolStripSplitButtonGroupByHash
            // 
            toolStripSplitButtonGroupByHash.Name = "toolStripSplitButtonGroupByHash";
            toolStripSplitButtonGroupByHash.Size = new Size(309, 26);
            toolStripSplitButtonGroupByHash.Text = "Группировка дублей";
            toolStripSplitButtonGroupByHash.Click += toolStripSplitButtonGroupByHash_Click;
            // 
            // toolStripButtonOdi
            // 
            toolStripButtonOdi.Enabled = false;
            toolStripButtonOdi.Image = (Image)resources.GetObject("toolStripButtonOdi.Image");
            toolStripButtonOdi.ImageTransparentColor = Color.Magenta;
            toolStripButtonOdi.Name = "toolStripButtonOdi";
            toolStripButtonOdi.Size = new Size(141, 24);
            toolStripButtonOdi.Text = "Извлечь из ODI";
            toolStripButtonOdi.Click += toolStripButtonOdi_Click;
            // 
            // toolStripMain
            // 
            toolStripMain.ImageScalingSize = new Size(20, 20);
            toolStripMain.Items.AddRange(new ToolStripItem[] { toolStripButtonSelectDirectory, toolStripSplitButtonGrouping, toolStripSeparator1, toolStripButtonOdi, toolStripDropDownButtonOpenFile });
            toolStripMain.Location = new Point(0, 0);
            toolStripMain.Name = "toolStripMain";
            toolStripMain.Size = new Size(800, 27);
            toolStripMain.TabIndex = 3;
            toolStripMain.Text = "toolStrip1";
            // 
            // toolStripSeparator1
            // 
            toolStripSeparator1.Name = "toolStripSeparator1";
            toolStripSeparator1.Size = new Size(6, 27);
            // 
            // openFileDialog
            // 
            openFileDialog.DefaultExt = "odi";
            openFileDialog.Filter = "ODI files|*.odi|All files|*.*";
            openFileDialog.Title = "Открыть";
            // 
            // MainForm
            // 
            AutoScaleDimensions = new SizeF(8F, 20F);
            AutoScaleMode = AutoScaleMode.Font;
            ClientSize = new Size(800, 450);
            Controls.Add(splitContainerInfo);
            Controls.Add(toolStripMain);
            Name = "MainForm";
            Text = "File Info";
            toolStripFileView.ResumeLayout(false);
            toolStripFileView.PerformLayout();
            splitContainerInfo.Panel1.ResumeLayout(false);
            splitContainerInfo.Panel2.ResumeLayout(false);
            splitContainerInfo.Panel2.PerformLayout();
            ((System.ComponentModel.ISupportInitialize)splitContainerInfo).EndInit();
            splitContainerInfo.ResumeLayout(false);
            contextMenuStripFile.ResumeLayout(false);
            toolStripMain.ResumeLayout(false);
            toolStripMain.PerformLayout();
            ResumeLayout(false);
            PerformLayout();
        }

        #endregion

        private SplitContainer splitContainerInfo;
        private FolderBrowserDialog folderBrowserDialog;
        private ContextMenuStrip contextMenuStripFile;
        private ToolStripMenuItem directoryToolStripMenuItem;
        private ToolStripDropDownButton toolStripDropDownButtonFormat;
        private ToolStripDropDownButton toolStripDropDownButtonEncoding;
        private SaveFileDialog saveFileDialog;
        private Panel panelViewComponent;
        private ToolStripButton toolStripButtonSave;
        private ToolStripButton toolStripButtonSelectDirectory;
        private ToolStripDropDownButton toolStripSplitButtonGrouping;
        private ToolStripMenuItem toolStripSplitButtonGroupByExec;
        private ToolStripMenuItem toolStripSplitButtonGroupByPath;
        private ToolStripMenuItem toolStripSplitButtonGroupByCustom;
        private ToolStripMenuItem toolStripSplitButtonGroupByHash;
        private ToolStripButton toolStripButtonOdi;
        private ToolStrip toolStripMain;
        private OpenFileDialog openFileDialog;
        private ToolStripSeparator toolStripSeparator1;
        private ToolStripButton toolStripButtonExport;
        private TreeView treeView;
    }
}
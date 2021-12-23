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
            this.components = new System.ComponentModel.Container();
            System.Windows.Forms.ColumnHeader columnHeaderName;
            System.Windows.Forms.ColumnHeader columnHeaderSize;
            System.Windows.Forms.ColumnHeader columnHeaderAddress;
            System.Windows.Forms.ColumnHeader columnHeaderHash;
            System.ComponentModel.ComponentResourceManager resources = new System.ComponentModel.ComponentResourceManager(typeof(MainForm));
            this.splitContainerInfo = new System.Windows.Forms.SplitContainer();
            this.listViewFile = new System.Windows.Forms.ListView();
            this.columnHeaderFileName = new System.Windows.Forms.ColumnHeader();
            this.columnHeaderPath = new System.Windows.Forms.ColumnHeader();
            this.contextMenuStripFile = new System.Windows.Forms.ContextMenuStrip(this.components);
            this.directoryToolStripMenuItem = new System.Windows.Forms.ToolStripMenuItem();
            this.panelViewComponent = new System.Windows.Forms.Panel();
            this.statusStripView = new System.Windows.Forms.StatusStrip();
            this.toolStripStatusLabelCrc = new System.Windows.Forms.ToolStripStatusLabel();
            this.toolStripStatusLabelSum = new System.Windows.Forms.ToolStripStatusLabel();
            this.toolStripFileView = new System.Windows.Forms.ToolStrip();
            this.toolStripDropDownButtonFormat = new System.Windows.Forms.ToolStripDropDownButton();
            this.toolStripDropDownButtonEncoding = new System.Windows.Forms.ToolStripDropDownButton();
            this.toolStripButtonSave = new System.Windows.Forms.ToolStripButton();
            this.folderBrowserDialog = new System.Windows.Forms.FolderBrowserDialog();
            this.saveFileDialog = new System.Windows.Forms.SaveFileDialog();
            this.toolStrip1 = new System.Windows.Forms.ToolStrip();
            this.toolStripButtonSelectDirectory = new System.Windows.Forms.ToolStripButton();
            this.toolStripSplitButtonGrouping = new System.Windows.Forms.ToolStripDropDownButton();
            this.toolStripSplitButtonGroupByExec = new System.Windows.Forms.ToolStripMenuItem();
            this.toolStripSplitButtonGroupByPath = new System.Windows.Forms.ToolStripMenuItem();
            this.toolStripSplitButtonGroupByCustom = new System.Windows.Forms.ToolStripMenuItem();
            this.toolStripSplitButtonGroupByHash = new System.Windows.Forms.ToolStripMenuItem();
            columnHeaderName = new System.Windows.Forms.ColumnHeader();
            columnHeaderSize = new System.Windows.Forms.ColumnHeader();
            columnHeaderAddress = new System.Windows.Forms.ColumnHeader();
            columnHeaderHash = new System.Windows.Forms.ColumnHeader();
            ((System.ComponentModel.ISupportInitialize)(this.splitContainerInfo)).BeginInit();
            this.splitContainerInfo.Panel1.SuspendLayout();
            this.splitContainerInfo.Panel2.SuspendLayout();
            this.splitContainerInfo.SuspendLayout();
            this.contextMenuStripFile.SuspendLayout();
            this.statusStripView.SuspendLayout();
            this.toolStripFileView.SuspendLayout();
            this.toolStrip1.SuspendLayout();
            this.SuspendLayout();
            // 
            // columnHeaderName
            // 
            columnHeaderName.Text = "Имя";
            columnHeaderName.Width = 100;
            // 
            // columnHeaderSize
            // 
            columnHeaderSize.Text = "Размер";
            columnHeaderSize.TextAlign = System.Windows.Forms.HorizontalAlignment.Right;
            // 
            // columnHeaderAddress
            // 
            columnHeaderAddress.Text = "Адрес";
            columnHeaderAddress.TextAlign = System.Windows.Forms.HorizontalAlignment.Right;
            // 
            // columnHeaderHash
            // 
            columnHeaderHash.Text = "Хеш";
            columnHeaderHash.Width = 180;
            // 
            // splitContainerInfo
            // 
            this.splitContainerInfo.Cursor = System.Windows.Forms.Cursors.VSplit;
            this.splitContainerInfo.Dock = System.Windows.Forms.DockStyle.Fill;
            this.splitContainerInfo.Location = new System.Drawing.Point(0, 27);
            this.splitContainerInfo.Name = "splitContainerInfo";
            // 
            // splitContainerInfo.Panel1
            // 
            this.splitContainerInfo.Panel1.Controls.Add(this.listViewFile);
            // 
            // splitContainerInfo.Panel2
            // 
            this.splitContainerInfo.Panel2.Controls.Add(this.panelViewComponent);
            this.splitContainerInfo.Panel2.Controls.Add(this.statusStripView);
            this.splitContainerInfo.Panel2.Controls.Add(this.toolStripFileView);
            this.splitContainerInfo.Panel2.Cursor = System.Windows.Forms.Cursors.Default;
            this.splitContainerInfo.Size = new System.Drawing.Size(800, 423);
            this.splitContainerInfo.SplitterDistance = 266;
            this.splitContainerInfo.TabIndex = 2;
            // 
            // listViewFile
            // 
            this.listViewFile.Columns.AddRange(new System.Windows.Forms.ColumnHeader[] {
            this.columnHeaderFileName,
            columnHeaderName,
            columnHeaderSize,
            columnHeaderAddress,
            columnHeaderHash,
            this.columnHeaderPath});
            this.listViewFile.ContextMenuStrip = this.contextMenuStripFile;
            this.listViewFile.Cursor = System.Windows.Forms.Cursors.Default;
            this.listViewFile.Dock = System.Windows.Forms.DockStyle.Fill;
            this.listViewFile.FullRowSelect = true;
            this.listViewFile.GridLines = true;
            this.listViewFile.HeaderStyle = System.Windows.Forms.ColumnHeaderStyle.Nonclickable;
            this.listViewFile.Location = new System.Drawing.Point(0, 0);
            this.listViewFile.MultiSelect = false;
            this.listViewFile.Name = "listViewFile";
            this.listViewFile.ShowItemToolTips = true;
            this.listViewFile.Size = new System.Drawing.Size(266, 423);
            this.listViewFile.TabIndex = 1;
            this.listViewFile.UseCompatibleStateImageBehavior = false;
            this.listViewFile.View = System.Windows.Forms.View.Details;
            this.listViewFile.ItemSelectionChanged += new System.Windows.Forms.ListViewItemSelectionChangedEventHandler(this.listViewFile_ItemSelectionChanged);
            // 
            // columnHeaderFileName
            // 
            this.columnHeaderFileName.Text = "Файл";
            this.columnHeaderFileName.Width = 120;
            // 
            // columnHeaderPath
            // 
            this.columnHeaderPath.Text = "Полный путь";
            // 
            // contextMenuStripFile
            // 
            this.contextMenuStripFile.ImageScalingSize = new System.Drawing.Size(20, 20);
            this.contextMenuStripFile.Items.AddRange(new System.Windows.Forms.ToolStripItem[] {
            this.directoryToolStripMenuItem});
            this.contextMenuStripFile.Name = "contextMenuStripFile";
            this.contextMenuStripFile.Size = new System.Drawing.Size(305, 28);
            this.contextMenuStripFile.Opening += new System.ComponentModel.CancelEventHandler(this.contextMenuStripFile_Opening);
            // 
            // directoryToolStripMenuItem
            // 
            this.directoryToolStripMenuItem.Name = "directoryToolStripMenuItem";
            this.directoryToolStripMenuItem.Size = new System.Drawing.Size(304, 24);
            this.directoryToolStripMenuItem.Text = "Открыть расположение файла ...";
            this.directoryToolStripMenuItem.Click += new System.EventHandler(this.directoryToolStripMenuItem_Click);
            // 
            // panelViewComponent
            // 
            this.panelViewComponent.Cursor = System.Windows.Forms.Cursors.Default;
            this.panelViewComponent.Dock = System.Windows.Forms.DockStyle.Fill;
            this.panelViewComponent.Location = new System.Drawing.Point(0, 27);
            this.panelViewComponent.Name = "panelViewComponent";
            this.panelViewComponent.Size = new System.Drawing.Size(530, 374);
            this.panelViewComponent.TabIndex = 4;
            // 
            // statusStripView
            // 
            this.statusStripView.ImageScalingSize = new System.Drawing.Size(20, 20);
            this.statusStripView.Items.AddRange(new System.Windows.Forms.ToolStripItem[] {
            this.toolStripStatusLabelCrc,
            this.toolStripStatusLabelSum});
            this.statusStripView.Location = new System.Drawing.Point(0, 401);
            this.statusStripView.Name = "statusStripView";
            this.statusStripView.Size = new System.Drawing.Size(530, 22);
            this.statusStripView.TabIndex = 3;
            this.statusStripView.Text = "statusStrip1";
            // 
            // toolStripStatusLabelCrc
            // 
            this.toolStripStatusLabelCrc.Name = "toolStripStatusLabelCrc";
            this.toolStripStatusLabelCrc.Size = new System.Drawing.Size(0, 16);
            // 
            // toolStripStatusLabelSum
            // 
            this.toolStripStatusLabelSum.Name = "toolStripStatusLabelSum";
            this.toolStripStatusLabelSum.Size = new System.Drawing.Size(0, 16);
            // 
            // toolStripFileView
            // 
            this.toolStripFileView.ImageScalingSize = new System.Drawing.Size(20, 20);
            this.toolStripFileView.Items.AddRange(new System.Windows.Forms.ToolStripItem[] {
            this.toolStripDropDownButtonFormat,
            this.toolStripDropDownButtonEncoding,
            this.toolStripButtonSave});
            this.toolStripFileView.Location = new System.Drawing.Point(0, 0);
            this.toolStripFileView.Name = "toolStripFileView";
            this.toolStripFileView.Size = new System.Drawing.Size(530, 27);
            this.toolStripFileView.TabIndex = 2;
            this.toolStripFileView.Text = "toolStrip1";
            // 
            // toolStripDropDownButtonFormat
            // 
            this.toolStripDropDownButtonFormat.Image = ((System.Drawing.Image)(resources.GetObject("toolStripDropDownButtonFormat.Image")));
            this.toolStripDropDownButtonFormat.ImageTransparentColor = System.Drawing.Color.Magenta;
            this.toolStripDropDownButtonFormat.Name = "toolStripDropDownButtonFormat";
            this.toolStripDropDownButtonFormat.Size = new System.Drawing.Size(69, 24);
            this.toolStripDropDownButtonFormat.Text = "Вид";
            // 
            // toolStripDropDownButtonEncoding
            // 
            this.toolStripDropDownButtonEncoding.Image = ((System.Drawing.Image)(resources.GetObject("toolStripDropDownButtonEncoding.Image")));
            this.toolStripDropDownButtonEncoding.ImageTransparentColor = System.Drawing.Color.Magenta;
            this.toolStripDropDownButtonEncoding.Name = "toolStripDropDownButtonEncoding";
            this.toolStripDropDownButtonEncoding.Size = new System.Drawing.Size(119, 24);
            this.toolStripDropDownButtonEncoding.Text = "Кодировка";
            // 
            // toolStripButtonSave
            // 
            this.toolStripButtonSave.Image = ((System.Drawing.Image)(resources.GetObject("toolStripButtonSave.Image")));
            this.toolStripButtonSave.ImageTransparentColor = System.Drawing.Color.Magenta;
            this.toolStripButtonSave.Name = "toolStripButtonSave";
            this.toolStripButtonSave.Size = new System.Drawing.Size(107, 24);
            this.toolStripButtonSave.Text = "Сохранить";
            this.toolStripButtonSave.Click += new System.EventHandler(this.toolStripButtonSave_Click);
            // 
            // folderBrowserDialog
            // 
            this.folderBrowserDialog.Description = "Выбрать директорию";
            this.folderBrowserDialog.RootFolder = System.Environment.SpecialFolder.MyComputer;
            this.folderBrowserDialog.ShowNewFolderButton = false;
            this.folderBrowserDialog.UseDescriptionForTitle = true;
            // 
            // toolStrip1
            // 
            this.toolStrip1.ImageScalingSize = new System.Drawing.Size(20, 20);
            this.toolStrip1.Items.AddRange(new System.Windows.Forms.ToolStripItem[] {
            this.toolStripButtonSelectDirectory,
            this.toolStripSplitButtonGrouping});
            this.toolStrip1.Location = new System.Drawing.Point(0, 0);
            this.toolStrip1.Name = "toolStrip1";
            this.toolStrip1.Size = new System.Drawing.Size(800, 27);
            this.toolStrip1.TabIndex = 3;
            this.toolStrip1.Text = "toolStrip1";
            // 
            // toolStripButtonSelectDirectory
            // 
            this.toolStripButtonSelectDirectory.Image = ((System.Drawing.Image)(resources.GetObject("toolStripButtonSelectDirectory.Image")));
            this.toolStripButtonSelectDirectory.ImageTransparentColor = System.Drawing.Color.Magenta;
            this.toolStripButtonSelectDirectory.Name = "toolStripButtonSelectDirectory";
            this.toolStripButtonSelectDirectory.Size = new System.Drawing.Size(196, 24);
            this.toolStripButtonSelectDirectory.Text = "Выбрать директорию ...";
            this.toolStripButtonSelectDirectory.Click += new System.EventHandler(this.toolStripButtonSelectDirectory_Click);
            // 
            // toolStripSplitButtonGrouping
            // 
            this.toolStripSplitButtonGrouping.DropDownItems.AddRange(new System.Windows.Forms.ToolStripItem[] {
            this.toolStripSplitButtonGroupByExec,
            this.toolStripSplitButtonGroupByPath,
            this.toolStripSplitButtonGroupByCustom,
            this.toolStripSplitButtonGroupByHash});
            this.toolStripSplitButtonGrouping.Image = ((System.Drawing.Image)(resources.GetObject("toolStripSplitButtonGrouping.Image")));
            this.toolStripSplitButtonGrouping.ImageTransparentColor = System.Drawing.Color.Magenta;
            this.toolStripSplitButtonGrouping.Name = "toolStripSplitButtonGrouping";
            this.toolStripSplitButtonGrouping.Size = new System.Drawing.Size(105, 24);
            this.toolStripSplitButtonGrouping.Text = "Grouping";
            // 
            // toolStripSplitButtonGroupByExec
            // 
            this.toolStripSplitButtonGroupByExec.Name = "toolStripSplitButtonGroupByExec";
            this.toolStripSplitButtonGroupByExec.Size = new System.Drawing.Size(309, 26);
            this.toolStripSplitButtonGroupByExec.Text = "Группировка по исполняемым";
            this.toolStripSplitButtonGroupByExec.Click += new System.EventHandler(this.toolStripSplitButtonGroupByExec_Click);
            // 
            // toolStripSplitButtonGroupByPath
            // 
            this.toolStripSplitButtonGroupByPath.Name = "toolStripSplitButtonGroupByPath";
            this.toolStripSplitButtonGroupByPath.Size = new System.Drawing.Size(309, 26);
            this.toolStripSplitButtonGroupByPath.Text = "Группировка по директории";
            this.toolStripSplitButtonGroupByPath.Click += new System.EventHandler(this.toolStripSplitButtonGroupByPath_Click);
            // 
            // toolStripSplitButtonGroupByCustom
            // 
            this.toolStripSplitButtonGroupByCustom.Name = "toolStripSplitButtonGroupByCustom";
            this.toolStripSplitButtonGroupByCustom.Size = new System.Drawing.Size(309, 26);
            this.toolStripSplitButtonGroupByCustom.Text = "Группировка по типу";
            this.toolStripSplitButtonGroupByCustom.Click += new System.EventHandler(this.toolStripSplitButtonGroupByCustom_Click);
            // 
            // toolStripSplitButtonGroupByHash
            // 
            this.toolStripSplitButtonGroupByHash.Name = "toolStripSplitButtonGroupByHash";
            this.toolStripSplitButtonGroupByHash.Size = new System.Drawing.Size(309, 26);
            this.toolStripSplitButtonGroupByHash.Text = "Группировка дублей";
            this.toolStripSplitButtonGroupByHash.Click += new System.EventHandler(this.toolStripSplitButtonGroupByHash_Click);
            // 
            // MainForm
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(8F, 20F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(800, 450);
            this.Controls.Add(this.splitContainerInfo);
            this.Controls.Add(this.toolStrip1);
            this.Name = "MainForm";
            this.Text = "File Info";
            this.splitContainerInfo.Panel1.ResumeLayout(false);
            this.splitContainerInfo.Panel2.ResumeLayout(false);
            this.splitContainerInfo.Panel2.PerformLayout();
            ((System.ComponentModel.ISupportInitialize)(this.splitContainerInfo)).EndInit();
            this.splitContainerInfo.ResumeLayout(false);
            this.contextMenuStripFile.ResumeLayout(false);
            this.statusStripView.ResumeLayout(false);
            this.statusStripView.PerformLayout();
            this.toolStripFileView.ResumeLayout(false);
            this.toolStripFileView.PerformLayout();
            this.toolStrip1.ResumeLayout(false);
            this.toolStrip1.PerformLayout();
            this.ResumeLayout(false);
            this.PerformLayout();

        }

        #endregion

        private SplitContainer splitContainerInfo;
        private ListView listViewFile;
        private FolderBrowserDialog folderBrowserDialog;
        private ToolStrip toolStripFileView;
        private ColumnHeader columnHeaderFileName;
        private ContextMenuStrip contextMenuStripFile;
        private ToolStripMenuItem directoryToolStripMenuItem;
        private ColumnHeader columnHeaderPath;
        private ToolStripDropDownButton toolStripDropDownButtonFormat;
        private ToolStripDropDownButton toolStripDropDownButtonEncoding;
        private SaveFileDialog saveFileDialog;
        private ToolStrip toolStrip1;
        private ToolStripButton toolStripButtonSelectDirectory;
        private StatusStrip statusStripView;
        private ToolStripStatusLabel toolStripStatusLabelCrc;
        private ToolStripStatusLabel toolStripStatusLabelSum;
        private Panel panelViewComponent;
        private ToolStripButton toolStripButtonSave;
        private ToolStripDropDownButton toolStripSplitButtonGrouping;
        private ToolStripMenuItem toolStripSplitButtonGroupByExec;
        private ToolStripMenuItem toolStripSplitButtonGroupByPath;
        private ToolStripMenuItem toolStripSplitButtonGroupByCustom;
        private ToolStripMenuItem toolStripSplitButtonGroupByHash;
    }
}
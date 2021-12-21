namespace fileinfo.Views.DisAssembler
{
    partial class DisAssemblerUserControl
    {
        /// <summary> 
        /// Required designer variable.
        /// </summary>
        private System.ComponentModel.IContainer components = null;

        /// <summary> 
        /// Clean up any resources being used.
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

        #region Component Designer generated code

        /// <summary> 
        /// Required method for Designer support - do not modify 
        /// the contents of this method with the code editor.
        /// </summary>
        private void InitializeComponent()
        {
            this.components = new System.ComponentModel.Container();
            System.Windows.Forms.TableLayoutPanel tableLayoutPanel;
            System.ComponentModel.ComponentResourceManager resources = new System.ComponentModel.ComponentResourceManager(typeof(DisAssemblerUserControl));
            this.textBoxLabel = new System.Windows.Forms.TextBox();
            this.textBoxData = new System.Windows.Forms.TextBox();
            this.textBoxComment = new System.Windows.Forms.TextBox();
            this.fastColoredTextBoxView = new FastColoredTextBoxNS.FastColoredTextBox();
            this.btnRun = new System.Windows.Forms.Button();
            this.toolTip = new System.Windows.Forms.ToolTip(this.components);
            this.splitContainer = new System.Windows.Forms.SplitContainer();
            tableLayoutPanel = new System.Windows.Forms.TableLayoutPanel();
            tableLayoutPanel.SuspendLayout();
            ((System.ComponentModel.ISupportInitialize)(this.fastColoredTextBoxView)).BeginInit();
            ((System.ComponentModel.ISupportInitialize)(this.splitContainer)).BeginInit();
            this.splitContainer.Panel1.SuspendLayout();
            this.splitContainer.Panel2.SuspendLayout();
            this.splitContainer.SuspendLayout();
            this.SuspendLayout();
            // 
            // tableLayoutPanel
            // 
            tableLayoutPanel.Anchor = ((System.Windows.Forms.AnchorStyles)((((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Bottom) 
            | System.Windows.Forms.AnchorStyles.Left) 
            | System.Windows.Forms.AnchorStyles.Right)));
            tableLayoutPanel.AutoSize = true;
            tableLayoutPanel.ColumnCount = 1;
            tableLayoutPanel.ColumnStyles.Add(new System.Windows.Forms.ColumnStyle(System.Windows.Forms.SizeType.Percent, 100F));
            tableLayoutPanel.Controls.Add(this.textBoxLabel, 0, 0);
            tableLayoutPanel.Controls.Add(this.textBoxData, 0, 1);
            tableLayoutPanel.Controls.Add(this.textBoxComment, 0, 2);
            tableLayoutPanel.Location = new System.Drawing.Point(2, 38);
            tableLayoutPanel.Name = "tableLayoutPanel";
            tableLayoutPanel.RowCount = 3;
            tableLayoutPanel.RowStyles.Add(new System.Windows.Forms.RowStyle(System.Windows.Forms.SizeType.Percent, 33F));
            tableLayoutPanel.RowStyles.Add(new System.Windows.Forms.RowStyle(System.Windows.Forms.SizeType.Percent, 33F));
            tableLayoutPanel.RowStyles.Add(new System.Windows.Forms.RowStyle(System.Windows.Forms.SizeType.Percent, 34F));
            tableLayoutPanel.Size = new System.Drawing.Size(247, 454);
            tableLayoutPanel.TabIndex = 4;
            // 
            // textBoxLabel
            // 
            this.textBoxLabel.Dock = System.Windows.Forms.DockStyle.Fill;
            this.textBoxLabel.Location = new System.Drawing.Point(3, 3);
            this.textBoxLabel.Multiline = true;
            this.textBoxLabel.Name = "textBoxLabel";
            this.textBoxLabel.ScrollBars = System.Windows.Forms.ScrollBars.Both;
            this.textBoxLabel.Size = new System.Drawing.Size(241, 143);
            this.textBoxLabel.TabIndex = 0;
            this.toolTip.SetToolTip(this.textBoxLabel, "Именование меток\r\nФормат\r\n<Адрес в HEX формате>:<Наименование метки>\r\nПример:\r\n0B" +
        "FFDH:Run_0BFFDH\r\n");
            this.textBoxLabel.WordWrap = false;
            // 
            // textBoxData
            // 
            this.textBoxData.Dock = System.Windows.Forms.DockStyle.Fill;
            this.textBoxData.Location = new System.Drawing.Point(3, 152);
            this.textBoxData.Multiline = true;
            this.textBoxData.Name = "textBoxData";
            this.textBoxData.ScrollBars = System.Windows.Forms.ScrollBars.Both;
            this.textBoxData.Size = new System.Drawing.Size(241, 143);
            this.textBoxData.TabIndex = 1;
            this.toolTip.SetToolTip(this.textBoxData, resources.GetString("textBoxData.ToolTip"));
            this.textBoxData.WordWrap = false;
            // 
            // textBoxComment
            // 
            this.textBoxComment.Dock = System.Windows.Forms.DockStyle.Fill;
            this.textBoxComment.Location = new System.Drawing.Point(3, 301);
            this.textBoxComment.Multiline = true;
            this.textBoxComment.Name = "textBoxComment";
            this.textBoxComment.ScrollBars = System.Windows.Forms.ScrollBars.Both;
            this.textBoxComment.Size = new System.Drawing.Size(241, 150);
            this.textBoxComment.TabIndex = 2;
            this.textBoxComment.WordWrap = false;
            // 
            // fastColoredTextBoxView
            // 
            this.fastColoredTextBoxView.AllowMacroRecording = false;
            this.fastColoredTextBoxView.AutoCompleteBracketsList = new char[] {
        '(',
        ')',
        '{',
        '}',
        '[',
        ']',
        '\"',
        '\"',
        '\'',
        '\''};
            this.fastColoredTextBoxView.AutoIndentCharsPatterns = "^\\s*[\\w\\.]+(\\s\\w+)?\\s*(?<range>=)\\s*(?<range>[^;=]+);\n^\\s*(case|default)\\s*[^:]*(" +
    "?<range>:)\\s*(?<range>[^;]+);";
            this.fastColoredTextBoxView.AutoScrollMinSize = new System.Drawing.Size(31, 18);
            this.fastColoredTextBoxView.BackBrush = null;
            this.fastColoredTextBoxView.CharHeight = 18;
            this.fastColoredTextBoxView.CharWidth = 10;
            this.fastColoredTextBoxView.CommentPrefix = ";";
            this.fastColoredTextBoxView.Cursor = System.Windows.Forms.Cursors.IBeam;
            this.fastColoredTextBoxView.DefaultMarkerSize = 8;
            this.fastColoredTextBoxView.DescriptionFile = "DocAsssebler.xml";
            this.fastColoredTextBoxView.DisabledColor = System.Drawing.Color.FromArgb(((int)(((byte)(100)))), ((int)(((byte)(180)))), ((int)(((byte)(180)))), ((int)(((byte)(180)))));
            this.fastColoredTextBoxView.Dock = System.Windows.Forms.DockStyle.Fill;
            this.fastColoredTextBoxView.IsReplaceMode = false;
            this.fastColoredTextBoxView.Location = new System.Drawing.Point(0, 0);
            this.fastColoredTextBoxView.Name = "fastColoredTextBoxView";
            this.fastColoredTextBoxView.Paddings = new System.Windows.Forms.Padding(0);
            this.fastColoredTextBoxView.SelectionColor = System.Drawing.Color.FromArgb(((int)(((byte)(60)))), ((int)(((byte)(0)))), ((int)(((byte)(0)))), ((int)(((byte)(255)))));
            this.fastColoredTextBoxView.ServiceColors = ((FastColoredTextBoxNS.ServiceColors)(resources.GetObject("fastColoredTextBoxView.ServiceColors")));
            this.fastColoredTextBoxView.Size = new System.Drawing.Size(397, 496);
            this.fastColoredTextBoxView.TabIndex = 0;
            this.fastColoredTextBoxView.Zoom = 100;
            // 
            // btnRun
            // 
            this.btnRun.Anchor = ((System.Windows.Forms.AnchorStyles)(((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Left) 
            | System.Windows.Forms.AnchorStyles.Right)));
            this.btnRun.Location = new System.Drawing.Point(2, 3);
            this.btnRun.Name = "btnRun";
            this.btnRun.Size = new System.Drawing.Size(247, 29);
            this.btnRun.TabIndex = 3;
            this.btnRun.Text = "Дизассемблировать";
            this.btnRun.UseVisualStyleBackColor = true;
            // 
            // splitContainer
            // 
            this.splitContainer.Cursor = System.Windows.Forms.Cursors.VSplit;
            this.splitContainer.Dock = System.Windows.Forms.DockStyle.Fill;
            this.splitContainer.Location = new System.Drawing.Point(0, 0);
            this.splitContainer.Name = "splitContainer";
            // 
            // splitContainer.Panel1
            // 
            this.splitContainer.Panel1.Controls.Add(this.fastColoredTextBoxView);
            this.splitContainer.Panel1.Cursor = System.Windows.Forms.Cursors.Default;
            // 
            // splitContainer.Panel2
            // 
            this.splitContainer.Panel2.Controls.Add(tableLayoutPanel);
            this.splitContainer.Panel2.Controls.Add(this.btnRun);
            this.splitContainer.Panel2.Cursor = System.Windows.Forms.Cursors.Default;
            this.splitContainer.Panel2MinSize = 100;
            this.splitContainer.Size = new System.Drawing.Size(653, 496);
            this.splitContainer.SplitterDistance = 397;
            this.splitContainer.TabIndex = 2;
            // 
            // DisAssemblerUserControl
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(8F, 20F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.Controls.Add(this.splitContainer);
            this.Name = "DisAssemblerUserControl";
            this.Size = new System.Drawing.Size(653, 496);
            tableLayoutPanel.ResumeLayout(false);
            tableLayoutPanel.PerformLayout();
            ((System.ComponentModel.ISupportInitialize)(this.fastColoredTextBoxView)).EndInit();
            this.splitContainer.Panel1.ResumeLayout(false);
            this.splitContainer.Panel2.ResumeLayout(false);
            this.splitContainer.Panel2.PerformLayout();
            ((System.ComponentModel.ISupportInitialize)(this.splitContainer)).EndInit();
            this.splitContainer.ResumeLayout(false);
            this.ResumeLayout(false);

        }

        #endregion

        public FastColoredTextBoxNS.FastColoredTextBox fastColoredTextBoxView;
        public TextBox textBoxComment;
        public TextBox textBoxData;
        public TextBox textBoxLabel;
        public Button btnRun;
        private ToolTip toolTip;
        private SplitContainer splitContainer;
    }
}

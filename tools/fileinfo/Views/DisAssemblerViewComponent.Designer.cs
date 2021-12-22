namespace fileinfo.Views
{
    partial class DisAssemblerViewComponent
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
            System.ComponentModel.ComponentResourceManager resources = new System.ComponentModel.ComponentResourceManager(typeof(DisAssemblerViewComponent));
            System.Windows.Forms.TableLayoutPanel tableLayoutPanel;
            System.Windows.Forms.Button btnDasm;
            this.splitContainerView = new System.Windows.Forms.SplitContainer();
            this.fastColoredTextBoxView = new FastColoredTextBoxNS.FastColoredTextBox();
            this.textBoxLabel = new System.Windows.Forms.TextBox();
            this.textBoxData = new System.Windows.Forms.TextBox();
            this.textBoxComment = new System.Windows.Forms.TextBox();
            this.toolTip = new System.Windows.Forms.ToolTip(this.components);
            tableLayoutPanel = new System.Windows.Forms.TableLayoutPanel();
            btnDasm = new System.Windows.Forms.Button();
            ((System.ComponentModel.ISupportInitialize)(this.splitContainerView)).BeginInit();
            this.splitContainerView.Panel1.SuspendLayout();
            this.splitContainerView.Panel2.SuspendLayout();
            this.splitContainerView.SuspendLayout();
            ((System.ComponentModel.ISupportInitialize)(this.fastColoredTextBoxView)).BeginInit();
            tableLayoutPanel.SuspendLayout();
            this.SuspendLayout();
            // 
            // splitContainerView
            // 
            this.splitContainerView.Cursor = System.Windows.Forms.Cursors.VSplit;
            this.splitContainerView.Dock = System.Windows.Forms.DockStyle.Fill;
            this.splitContainerView.Location = new System.Drawing.Point(0, 0);
            this.splitContainerView.Name = "splitContainerView";
            // 
            // splitContainerView.Panel1
            // 
            this.splitContainerView.Panel1.Controls.Add(this.fastColoredTextBoxView);
            // 
            // splitContainerView.Panel2
            // 
            this.splitContainerView.Panel2.Controls.Add(tableLayoutPanel);
            this.splitContainerView.Panel2.Controls.Add(btnDasm);
            this.splitContainerView.Size = new System.Drawing.Size(724, 622);
            this.splitContainerView.SplitterDistance = 497;
            this.splitContainerView.TabIndex = 0;
            // 
            // fastColoredTextBoxView
            // 
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
            this.fastColoredTextBoxView.Cursor = System.Windows.Forms.Cursors.IBeam;
            this.fastColoredTextBoxView.DefaultMarkerSize = 8;
            this.fastColoredTextBoxView.DescriptionFile = "SyntaxHighlighterAsssebler.xml";
            this.fastColoredTextBoxView.DisabledColor = System.Drawing.Color.FromArgb(((int)(((byte)(100)))), ((int)(((byte)(180)))), ((int)(((byte)(180)))), ((int)(((byte)(180)))));
            this.fastColoredTextBoxView.Dock = System.Windows.Forms.DockStyle.Fill;
            this.fastColoredTextBoxView.Font = new System.Drawing.Font("Courier New", 9.75F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point);
            this.fastColoredTextBoxView.IsReplaceMode = false;
            this.fastColoredTextBoxView.Location = new System.Drawing.Point(0, 0);
            this.fastColoredTextBoxView.Name = "fastColoredTextBoxView";
            this.fastColoredTextBoxView.Paddings = new System.Windows.Forms.Padding(0);
            this.fastColoredTextBoxView.SelectionColor = System.Drawing.Color.FromArgb(((int)(((byte)(60)))), ((int)(((byte)(0)))), ((int)(((byte)(0)))), ((int)(((byte)(255)))));
            this.fastColoredTextBoxView.ServiceColors = ((FastColoredTextBoxNS.ServiceColors)(resources.GetObject("fastColoredTextBoxView.ServiceColors")));
            this.fastColoredTextBoxView.Size = new System.Drawing.Size(497, 622);
            this.fastColoredTextBoxView.TabIndex = 0;
            this.fastColoredTextBoxView.Zoom = 100;
            // 
            // tableLayoutPanel
            // 
            tableLayoutPanel.AutoSize = true;
            tableLayoutPanel.ColumnCount = 1;
            tableLayoutPanel.ColumnStyles.Add(new System.Windows.Forms.ColumnStyle(System.Windows.Forms.SizeType.Percent, 100F));
            tableLayoutPanel.Controls.Add(this.textBoxLabel, 0, 0);
            tableLayoutPanel.Controls.Add(this.textBoxData, 0, 1);
            tableLayoutPanel.Controls.Add(this.textBoxComment, 0, 2);
            tableLayoutPanel.Dock = System.Windows.Forms.DockStyle.Fill;
            tableLayoutPanel.Location = new System.Drawing.Point(0, 29);
            tableLayoutPanel.Name = "tableLayoutPanel";
            tableLayoutPanel.RowCount = 3;
            tableLayoutPanel.RowStyles.Add(new System.Windows.Forms.RowStyle(System.Windows.Forms.SizeType.Percent, 33F));
            tableLayoutPanel.RowStyles.Add(new System.Windows.Forms.RowStyle(System.Windows.Forms.SizeType.Percent, 33F));
            tableLayoutPanel.RowStyles.Add(new System.Windows.Forms.RowStyle(System.Windows.Forms.SizeType.Percent, 34F));
            tableLayoutPanel.Size = new System.Drawing.Size(223, 593);
            tableLayoutPanel.TabIndex = 5;
            // 
            // textBoxLabel
            // 
            this.textBoxLabel.Dock = System.Windows.Forms.DockStyle.Fill;
            this.textBoxLabel.Location = new System.Drawing.Point(3, 3);
            this.textBoxLabel.Multiline = true;
            this.textBoxLabel.Name = "textBoxLabel";
            this.textBoxLabel.ScrollBars = System.Windows.Forms.ScrollBars.Both;
            this.textBoxLabel.Size = new System.Drawing.Size(217, 189);
            this.textBoxLabel.TabIndex = 0;
            this.toolTip.SetToolTip(this.textBoxLabel, "Именование меток\r\nФормат\r\n<Адрес в HEX формате>:<Наименование метки>\r\nПример:\r\n0B" +
        "FFDH:Run_0BFFDH\r\n");
            this.textBoxLabel.WordWrap = false;
            // 
            // textBoxData
            // 
            this.textBoxData.Dock = System.Windows.Forms.DockStyle.Fill;
            this.textBoxData.Location = new System.Drawing.Point(3, 198);
            this.textBoxData.Multiline = true;
            this.textBoxData.Name = "textBoxData";
            this.textBoxData.ScrollBars = System.Windows.Forms.ScrollBars.Both;
            this.textBoxData.Size = new System.Drawing.Size(217, 189);
            this.textBoxData.TabIndex = 1;
            this.toolTip.SetToolTip(this.textBoxData, resources.GetString("textBoxData.ToolTip"));
            this.textBoxData.WordWrap = false;
            // 
            // textBoxComment
            // 
            this.textBoxComment.Dock = System.Windows.Forms.DockStyle.Fill;
            this.textBoxComment.Location = new System.Drawing.Point(3, 393);
            this.textBoxComment.Multiline = true;
            this.textBoxComment.Name = "textBoxComment";
            this.textBoxComment.ScrollBars = System.Windows.Forms.ScrollBars.Both;
            this.textBoxComment.Size = new System.Drawing.Size(217, 197);
            this.textBoxComment.TabIndex = 2;
            this.textBoxComment.WordWrap = false;
            // 
            // btnDasm
            // 
            btnDasm.Dock = System.Windows.Forms.DockStyle.Top;
            btnDasm.Location = new System.Drawing.Point(0, 0);
            btnDasm.Name = "btnDasm";
            btnDasm.Size = new System.Drawing.Size(223, 29);
            btnDasm.TabIndex = 6;
            btnDasm.Text = "Дизассемблировать";
            btnDasm.UseVisualStyleBackColor = true;
            btnDasm.Click += new System.EventHandler(this.ButtonDasm_Click);
            // 
            // DisAssemblerViewComponent
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(8F, 20F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.Controls.Add(this.splitContainerView);
            this.Name = "DisAssemblerViewComponent";
            this.Size = new System.Drawing.Size(724, 622);
            this.splitContainerView.Panel1.ResumeLayout(false);
            this.splitContainerView.Panel2.ResumeLayout(false);
            this.splitContainerView.Panel2.PerformLayout();
            ((System.ComponentModel.ISupportInitialize)(this.splitContainerView)).EndInit();
            this.splitContainerView.ResumeLayout(false);
            ((System.ComponentModel.ISupportInitialize)(this.fastColoredTextBoxView)).EndInit();
            tableLayoutPanel.ResumeLayout(false);
            tableLayoutPanel.PerformLayout();
            this.ResumeLayout(false);

        }

        #endregion

        private FastColoredTextBoxNS.FastColoredTextBox fastColoredTextBoxView;
        private ToolTip toolTip;
        private TextBox textBoxLabel;
        private TextBox textBoxData;
        private TextBox textBoxComment;
        private SplitContainer splitContainerView;
    }
}

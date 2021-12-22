namespace fileinfo.Views
{
    partial class DisAsmDumpViewComponent
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
            System.Windows.Forms.Label labelCount;
            System.ComponentModel.ComponentResourceManager resources = new System.ComponentModel.ComponentResourceManager(typeof(DisAsmDumpViewComponent));
            this.panelTool = new System.Windows.Forms.Panel();
            this.comboBoxCount = new System.Windows.Forms.ComboBox();
            this.fastColoredTextBoxView = new FastColoredTextBoxNS.FastColoredTextBox();
            labelCount = new System.Windows.Forms.Label();
            this.panelTool.SuspendLayout();
            ((System.ComponentModel.ISupportInitialize)(this.fastColoredTextBoxView)).BeginInit();
            this.SuspendLayout();
            // 
            // labelCount
            // 
            labelCount.AutoSize = true;
            labelCount.Location = new System.Drawing.Point(3, 5);
            labelCount.Name = "labelCount";
            labelCount.Size = new System.Drawing.Size(69, 20);
            labelCount.TabIndex = 0;
            labelCount.Text = "В ряд по";
            // 
            // panelTool
            // 
            this.panelTool.Controls.Add(this.comboBoxCount);
            this.panelTool.Controls.Add(labelCount);
            this.panelTool.Dock = System.Windows.Forms.DockStyle.Top;
            this.panelTool.Location = new System.Drawing.Point(0, 0);
            this.panelTool.Name = "panelTool";
            this.panelTool.Size = new System.Drawing.Size(555, 33);
            this.panelTool.TabIndex = 0;
            // 
            // comboBoxCount
            // 
            this.comboBoxCount.DropDownStyle = System.Windows.Forms.ComboBoxStyle.DropDownList;
            this.comboBoxCount.FormattingEnabled = true;
            this.comboBoxCount.Items.AddRange(new object[] {
            "16",
            "8",
            "4",
            "3",
            "2",
            "1"});
            this.comboBoxCount.Location = new System.Drawing.Point(78, 2);
            this.comboBoxCount.Name = "comboBoxCount";
            this.comboBoxCount.Size = new System.Drawing.Size(151, 28);
            this.comboBoxCount.TabIndex = 1;
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
            this.fastColoredTextBoxView.IsReplaceMode = false;
            this.fastColoredTextBoxView.Location = new System.Drawing.Point(0, 33);
            this.fastColoredTextBoxView.Name = "fastColoredTextBoxView";
            this.fastColoredTextBoxView.Paddings = new System.Windows.Forms.Padding(0);
            this.fastColoredTextBoxView.SelectionColor = System.Drawing.Color.FromArgb(((int)(((byte)(60)))), ((int)(((byte)(0)))), ((int)(((byte)(0)))), ((int)(((byte)(255)))));
            this.fastColoredTextBoxView.ServiceColors = ((FastColoredTextBoxNS.ServiceColors)(resources.GetObject("fastColoredTextBoxView.ServiceColors")));
            this.fastColoredTextBoxView.Size = new System.Drawing.Size(555, 512);
            this.fastColoredTextBoxView.TabIndex = 1;
            this.fastColoredTextBoxView.Zoom = 100;
            // 
            // DisAsmDumpViewComponent
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(8F, 20F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.Controls.Add(this.fastColoredTextBoxView);
            this.Controls.Add(this.panelTool);
            this.Name = "DisAsmDumpViewComponent";
            this.Size = new System.Drawing.Size(555, 545);
            this.panelTool.ResumeLayout(false);
            this.panelTool.PerformLayout();
            ((System.ComponentModel.ISupportInitialize)(this.fastColoredTextBoxView)).EndInit();
            this.ResumeLayout(false);

        }

        #endregion

        private Panel panelTool;
        private FastColoredTextBoxNS.FastColoredTextBox fastColoredTextBoxView;
        private ComboBox comboBoxCount;
    }
}

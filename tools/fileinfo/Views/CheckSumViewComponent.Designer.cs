namespace fileinfo.Views
{
    partial class CheckSumViewComponent
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
            System.ComponentModel.ComponentResourceManager resources = new System.ComponentModel.ComponentResourceManager(typeof(CheckSumViewComponent));
            this.fastColoredTextBoxView = new FastColoredTextBoxNS.FastColoredTextBox();
            this.panelTool = new System.Windows.Forms.Panel();
            this.checkBoxHeader = new System.Windows.Forms.CheckBox();
            ((System.ComponentModel.ISupportInitialize)(this.fastColoredTextBoxView)).BeginInit();
            this.panelTool.SuspendLayout();
            this.SuspendLayout();
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
            this.fastColoredTextBoxView.AutoIndentCharsPatterns = "^\\s*[\\w\\.]+(\\s\\w+)?\\s*(?<range>=)\\s*(?<range>[^;=]+);\r\n^\\s*(case|default)\\s*[^:]*" +
    "(?<range>:)\\s*(?<range>[^;]+);";
            this.fastColoredTextBoxView.AutoScrollMinSize = new System.Drawing.Size(31, 18);
            this.fastColoredTextBoxView.BackBrush = null;
            this.fastColoredTextBoxView.CharHeight = 18;
            this.fastColoredTextBoxView.CharWidth = 10;
            this.fastColoredTextBoxView.Cursor = System.Windows.Forms.Cursors.IBeam;
            this.fastColoredTextBoxView.DefaultMarkerSize = 8;
            this.fastColoredTextBoxView.DisabledColor = System.Drawing.Color.FromArgb(((int)(((byte)(100)))), ((int)(((byte)(180)))), ((int)(((byte)(180)))), ((int)(((byte)(180)))));
            this.fastColoredTextBoxView.Dock = System.Windows.Forms.DockStyle.Fill;
            this.fastColoredTextBoxView.Font = new System.Drawing.Font("Courier New", 9.75F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point);
            this.fastColoredTextBoxView.IsReplaceMode = false;
            this.fastColoredTextBoxView.Location = new System.Drawing.Point(0, 39);
            this.fastColoredTextBoxView.Name = "fastColoredTextBoxView";
            this.fastColoredTextBoxView.Paddings = new System.Windows.Forms.Padding(0);
            this.fastColoredTextBoxView.SelectionColor = System.Drawing.Color.FromArgb(((int)(((byte)(60)))), ((int)(((byte)(0)))), ((int)(((byte)(0)))), ((int)(((byte)(255)))));
            this.fastColoredTextBoxView.ServiceColors = ((FastColoredTextBoxNS.ServiceColors)(resources.GetObject("fastColoredTextBoxView.ServiceColors")));
            this.fastColoredTextBoxView.Size = new System.Drawing.Size(390, 295);
            this.fastColoredTextBoxView.TabIndex = 0;
            this.fastColoredTextBoxView.Zoom = 100;
            // 
            // panelTool
            // 
            this.panelTool.Controls.Add(this.checkBoxHeader);
            this.panelTool.Dock = System.Windows.Forms.DockStyle.Top;
            this.panelTool.Location = new System.Drawing.Point(0, 0);
            this.panelTool.Name = "panelTool";
            this.panelTool.Size = new System.Drawing.Size(390, 39);
            this.panelTool.TabIndex = 1;
            // 
            // checkBoxHeader
            // 
            this.checkBoxHeader.AutoSize = true;
            this.checkBoxHeader.Location = new System.Drawing.Point(9, 9);
            this.checkBoxHeader.Name = "checkBoxHeader";
            this.checkBoxHeader.Size = new System.Drawing.Size(246, 24);
            this.checkBoxHeader.TabIndex = 0;
            this.checkBoxHeader.Text = "Включая заголовок (BRU, ORD)";
            this.checkBoxHeader.UseVisualStyleBackColor = true;
            this.checkBoxHeader.CheckedChanged += new System.EventHandler(this.checkBoxHeader_CheckedChanged);
            // 
            // CheckSumViewComponent
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(8F, 20F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.Controls.Add(this.fastColoredTextBoxView);
            this.Controls.Add(this.panelTool);
            this.Name = "CheckSumViewComponent";
            this.Size = new System.Drawing.Size(390, 334);
            ((System.ComponentModel.ISupportInitialize)(this.fastColoredTextBoxView)).EndInit();
            this.panelTool.ResumeLayout(false);
            this.panelTool.PerformLayout();
            this.ResumeLayout(false);

        }

        #endregion

        private FastColoredTextBoxNS.FastColoredTextBox fastColoredTextBoxView;
        private Panel panelTool;
        private CheckBox checkBoxHeader;
    }
}

namespace fileinfo.Views.DisAsmDump
{
    partial class DisAsmDumpUserControl
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
            System.Windows.Forms.Label labelCount;
            this.panelInfo = new System.Windows.Forms.Panel();
            this.comboBoxCount = new System.Windows.Forms.ComboBox();
            this.textBoxView = new System.Windows.Forms.TextBox();
            labelCount = new System.Windows.Forms.Label();
            this.panelInfo.SuspendLayout();
            this.SuspendLayout();
            // 
            // panelInfo
            // 
            this.panelInfo.Controls.Add(labelCount);
            this.panelInfo.Controls.Add(this.comboBoxCount);
            this.panelInfo.Dock = System.Windows.Forms.DockStyle.Top;
            this.panelInfo.Location = new System.Drawing.Point(0, 0);
            this.panelInfo.Name = "panelInfo";
            this.panelInfo.Size = new System.Drawing.Size(414, 35);
            this.panelInfo.TabIndex = 0;
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
            this.comboBoxCount.Location = new System.Drawing.Point(78, 3);
            this.comboBoxCount.Name = "comboBoxCount";
            this.comboBoxCount.Size = new System.Drawing.Size(151, 28);
            this.comboBoxCount.TabIndex = 0;
            // 
            // labelCount
            // 
            labelCount.AutoSize = true;
            labelCount.Location = new System.Drawing.Point(3, 8);
            labelCount.Name = "labelCount";
            labelCount.Size = new System.Drawing.Size(69, 20);
            labelCount.TabIndex = 1;
            labelCount.Text = "В ряд по";
            // 
            // textBoxView
            // 
            this.textBoxView.Dock = System.Windows.Forms.DockStyle.Fill;
            this.textBoxView.Font = new System.Drawing.Font("Cascadia Mono", 9F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point);
            this.textBoxView.Location = new System.Drawing.Point(0, 35);
            this.textBoxView.Multiline = true;
            this.textBoxView.Name = "textBoxView";
            this.textBoxView.ScrollBars = System.Windows.Forms.ScrollBars.Both;
            this.textBoxView.Size = new System.Drawing.Size(414, 292);
            this.textBoxView.TabIndex = 1;
            this.textBoxView.WordWrap = false;
            // 
            // DisAsmDumpUserControl
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(8F, 20F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.Controls.Add(this.textBoxView);
            this.Controls.Add(this.panelInfo);
            this.Name = "DisAsmDumpUserControl";
            this.Size = new System.Drawing.Size(414, 327);
            this.panelInfo.ResumeLayout(false);
            this.panelInfo.PerformLayout();
            this.ResumeLayout(false);
            this.PerformLayout();

        }

        #endregion

        private Panel panelInfo;
        public ComboBox comboBoxCount;
        public TextBox textBoxView;
    }
}

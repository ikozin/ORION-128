namespace fileinfo.Views.Picture
{
    partial class PictureViewUserControl
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
            System.Windows.Forms.Label labelAddress;
            System.Windows.Forms.Label labelWidth;
            System.Windows.Forms.Label labelHeight;
            System.Windows.Forms.Button btnSaveAs;
            this.panelInfo = new System.Windows.Forms.Panel();
            this.textBoxHeight = new System.Windows.Forms.TextBox();
            this.textBoxWidth = new System.Windows.Forms.TextBox();
            this.textBoxAddress = new System.Windows.Forms.TextBox();
            this.saveFileDialog = new System.Windows.Forms.SaveFileDialog();
            this.pictureBox = new System.Windows.Forms.PictureBox();
            labelAddress = new System.Windows.Forms.Label();
            labelWidth = new System.Windows.Forms.Label();
            labelHeight = new System.Windows.Forms.Label();
            btnSaveAs = new System.Windows.Forms.Button();
            this.panelInfo.SuspendLayout();
            ((System.ComponentModel.ISupportInitialize)(this.pictureBox)).BeginInit();
            this.SuspendLayout();
            // 
            // labelAddress
            // 
            labelAddress.AutoSize = true;
            labelAddress.Location = new System.Drawing.Point(12, 12);
            labelAddress.Name = "labelAddress";
            labelAddress.Size = new System.Drawing.Size(51, 20);
            labelAddress.TabIndex = 0;
            labelAddress.Text = "Адрес";
            // 
            // labelWidth
            // 
            labelWidth.AutoSize = true;
            labelWidth.Location = new System.Drawing.Point(141, 12);
            labelWidth.Name = "labelWidth";
            labelWidth.Size = new System.Drawing.Size(67, 20);
            labelWidth.TabIndex = 2;
            labelWidth.Text = "Ширина";
            // 
            // labelHeight
            // 
            labelHeight.AutoSize = true;
            labelHeight.Location = new System.Drawing.Point(269, 12);
            labelHeight.Name = "labelHeight";
            labelHeight.Size = new System.Drawing.Size(59, 20);
            labelHeight.TabIndex = 4;
            labelHeight.Text = "Высота";
            // 
            // btnSaveAs
            // 
            btnSaveAs.Location = new System.Drawing.Point(388, 8);
            btnSaveAs.Name = "btnSaveAs";
            btnSaveAs.Size = new System.Drawing.Size(137, 29);
            btnSaveAs.TabIndex = 6;
            btnSaveAs.Text = "Сохранить как ...";
            btnSaveAs.UseVisualStyleBackColor = true;
            btnSaveAs.Click += new System.EventHandler(this.btnSaveAs_Click);
            // 
            // panelInfo
            // 
            this.panelInfo.Controls.Add(this.textBoxHeight);
            this.panelInfo.Controls.Add(this.textBoxWidth);
            this.panelInfo.Controls.Add(labelHeight);
            this.panelInfo.Controls.Add(labelWidth);
            this.panelInfo.Controls.Add(this.textBoxAddress);
            this.panelInfo.Controls.Add(labelAddress);
            this.panelInfo.Controls.Add(btnSaveAs);
            this.panelInfo.Dock = System.Windows.Forms.DockStyle.Top;
            this.panelInfo.Location = new System.Drawing.Point(0, 0);
            this.panelInfo.Name = "panelInfo";
            this.panelInfo.Size = new System.Drawing.Size(593, 47);
            this.panelInfo.TabIndex = 0;
            // 
            // textBoxHeight
            // 
            this.textBoxHeight.Location = new System.Drawing.Point(334, 9);
            this.textBoxHeight.Name = "textBoxHeight";
            this.textBoxHeight.ReadOnly = true;
            this.textBoxHeight.Size = new System.Drawing.Size(48, 27);
            this.textBoxHeight.TabIndex = 5;
            // 
            // textBoxWidth
            // 
            this.textBoxWidth.Location = new System.Drawing.Point(214, 10);
            this.textBoxWidth.Name = "textBoxWidth";
            this.textBoxWidth.ReadOnly = true;
            this.textBoxWidth.Size = new System.Drawing.Size(49, 27);
            this.textBoxWidth.TabIndex = 3;
            // 
            // textBoxAddress
            // 
            this.textBoxAddress.Location = new System.Drawing.Point(69, 10);
            this.textBoxAddress.Name = "textBoxAddress";
            this.textBoxAddress.ReadOnly = true;
            this.textBoxAddress.Size = new System.Drawing.Size(66, 27);
            this.textBoxAddress.TabIndex = 1;
            // 
            // saveFileDialog
            // 
            this.saveFileDialog.DefaultExt = "bmp";
            this.saveFileDialog.Filter = "Bitmap files|*.bmp";
            this.saveFileDialog.Title = "Сохранить как ...";
            // 
            // pictureBox
            // 
            this.pictureBox.BorderStyle = System.Windows.Forms.BorderStyle.FixedSingle;
            this.pictureBox.Dock = System.Windows.Forms.DockStyle.Fill;
            this.pictureBox.Location = new System.Drawing.Point(0, 47);
            this.pictureBox.Name = "pictureBox";
            this.pictureBox.Size = new System.Drawing.Size(593, 412);
            this.pictureBox.SizeMode = System.Windows.Forms.PictureBoxSizeMode.AutoSize;
            this.pictureBox.TabIndex = 1;
            this.pictureBox.TabStop = false;
            // 
            // PictureViewUserControl
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(8F, 20F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.Controls.Add(this.pictureBox);
            this.Controls.Add(this.panelInfo);
            this.Name = "PictureViewUserControl";
            this.Size = new System.Drawing.Size(593, 459);
            this.panelInfo.ResumeLayout(false);
            this.panelInfo.PerformLayout();
            ((System.ComponentModel.ISupportInitialize)(this.pictureBox)).EndInit();
            this.ResumeLayout(false);
            this.PerformLayout();

        }

        #endregion

        private SaveFileDialog saveFileDialog;
        public TextBox textBoxAddress;
        public TextBox textBoxHeight;
        public TextBox textBoxWidth;
        public PictureBox pictureBox;
        public Button btnSaveAs;
        public Panel panelInfo;
    }
}

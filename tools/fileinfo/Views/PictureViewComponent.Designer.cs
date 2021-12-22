namespace fileinfo.Views
{
    partial class PictureViewComponent
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
            this.panelTool = new System.Windows.Forms.Panel();
            this.btnSave = new System.Windows.Forms.Button();
            this.textBoxHeight = new System.Windows.Forms.TextBox();
            this.textBoxWidth = new System.Windows.Forms.TextBox();
            this.textBoxAddress = new System.Windows.Forms.TextBox();
            this.pictureBoxView = new System.Windows.Forms.PictureBox();
            this.saveFileDialog = new System.Windows.Forms.SaveFileDialog();
            labelAddress = new System.Windows.Forms.Label();
            labelWidth = new System.Windows.Forms.Label();
            labelHeight = new System.Windows.Forms.Label();
            this.panelTool.SuspendLayout();
            ((System.ComponentModel.ISupportInitialize)(this.pictureBoxView)).BeginInit();
            this.SuspendLayout();
            // 
            // labelAddress
            // 
            labelAddress.AutoSize = true;
            labelAddress.Location = new System.Drawing.Point(3, 3);
            labelAddress.Name = "labelAddress";
            labelAddress.Size = new System.Drawing.Size(51, 20);
            labelAddress.TabIndex = 0;
            labelAddress.Text = "Адрес";
            // 
            // labelWidth
            // 
            labelWidth.AutoSize = true;
            labelWidth.Location = new System.Drawing.Point(143, 3);
            labelWidth.Name = "labelWidth";
            labelWidth.Size = new System.Drawing.Size(67, 20);
            labelWidth.TabIndex = 2;
            labelWidth.Text = "Ширина";
            // 
            // labelHeight
            // 
            labelHeight.AutoSize = true;
            labelHeight.Location = new System.Drawing.Point(300, 3);
            labelHeight.Name = "labelHeight";
            labelHeight.Size = new System.Drawing.Size(59, 20);
            labelHeight.TabIndex = 4;
            labelHeight.Text = "Высота";
            // 
            // panelTool
            // 
            this.panelTool.Controls.Add(this.btnSave);
            this.panelTool.Controls.Add(this.textBoxHeight);
            this.panelTool.Controls.Add(labelHeight);
            this.panelTool.Controls.Add(this.textBoxWidth);
            this.panelTool.Controls.Add(labelWidth);
            this.panelTool.Controls.Add(this.textBoxAddress);
            this.panelTool.Controls.Add(labelAddress);
            this.panelTool.Dock = System.Windows.Forms.DockStyle.Top;
            this.panelTool.Location = new System.Drawing.Point(0, 0);
            this.panelTool.Name = "panelTool";
            this.panelTool.Size = new System.Drawing.Size(612, 33);
            this.panelTool.TabIndex = 0;
            // 
            // btnSave
            // 
            this.btnSave.Location = new System.Drawing.Point(449, 2);
            this.btnSave.Name = "btnSave";
            this.btnSave.Size = new System.Drawing.Size(109, 29);
            this.btnSave.TabIndex = 6;
            this.btnSave.Text = "Сохранить ...";
            this.btnSave.UseVisualStyleBackColor = true;
            this.btnSave.Click += new System.EventHandler(this.ButtonSave_Click);
            // 
            // textBoxHeight
            // 
            this.textBoxHeight.Location = new System.Drawing.Point(365, 3);
            this.textBoxHeight.Name = "textBoxHeight";
            this.textBoxHeight.ReadOnly = true;
            this.textBoxHeight.Size = new System.Drawing.Size(78, 27);
            this.textBoxHeight.TabIndex = 5;
            // 
            // textBoxWidth
            // 
            this.textBoxWidth.Location = new System.Drawing.Point(216, 3);
            this.textBoxWidth.Name = "textBoxWidth";
            this.textBoxWidth.ReadOnly = true;
            this.textBoxWidth.Size = new System.Drawing.Size(78, 27);
            this.textBoxWidth.TabIndex = 3;
            // 
            // textBoxAddress
            // 
            this.textBoxAddress.Location = new System.Drawing.Point(60, 3);
            this.textBoxAddress.Name = "textBoxAddress";
            this.textBoxAddress.ReadOnly = true;
            this.textBoxAddress.Size = new System.Drawing.Size(77, 27);
            this.textBoxAddress.TabIndex = 1;
            // 
            // pictureBoxView
            // 
            this.pictureBoxView.Dock = System.Windows.Forms.DockStyle.Fill;
            this.pictureBoxView.Location = new System.Drawing.Point(0, 33);
            this.pictureBoxView.Name = "pictureBoxView";
            this.pictureBoxView.Size = new System.Drawing.Size(612, 534);
            this.pictureBoxView.SizeMode = System.Windows.Forms.PictureBoxSizeMode.CenterImage;
            this.pictureBoxView.TabIndex = 1;
            this.pictureBoxView.TabStop = false;
            // 
            // saveFileDialog
            // 
            this.saveFileDialog.DefaultExt = "bmp";
            this.saveFileDialog.Filter = "Bitmap files|*.bmp";
            this.saveFileDialog.Title = "Сохранить как ...";
            // 
            // PictureViewComponent
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(8F, 20F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.Controls.Add(this.pictureBoxView);
            this.Controls.Add(this.panelTool);
            this.Name = "PictureViewComponent";
            this.Size = new System.Drawing.Size(612, 567);
            this.panelTool.ResumeLayout(false);
            this.panelTool.PerformLayout();
            ((System.ComponentModel.ISupportInitialize)(this.pictureBoxView)).EndInit();
            this.ResumeLayout(false);

        }

        #endregion

        private Panel panelTool;
        private PictureBox pictureBoxView;
        private TextBox textBoxAddress;
        private Button btnSave;
        private TextBox textBoxHeight;
        private TextBox textBoxWidth;
        private SaveFileDialog saveFileDialog;
    }
}

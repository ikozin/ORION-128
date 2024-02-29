namespace fileinfo.Views
{
    partial class Picture4CViewComponent
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
            Label labelWidth;
            Label labelHeight;
            panelTool = new Panel();
            checkBoxCompressed = new CheckBox();
            checkBoxColor = new CheckBox();
            textBoxHeight = new TextBox();
            textBoxWidth = new TextBox();
            pictureBoxView = new PictureBox();
            labelWidth = new Label();
            labelHeight = new Label();
            panelTool.SuspendLayout();
            ((System.ComponentModel.ISupportInitialize)pictureBoxView).BeginInit();
            SuspendLayout();
            // 
            // labelWidth
            // 
            labelWidth.AutoSize = true;
            labelWidth.Location = new Point(191, 3);
            labelWidth.Name = "labelWidth";
            labelWidth.Size = new Size(67, 20);
            labelWidth.TabIndex = 2;
            labelWidth.Text = "Ширина";
            // 
            // labelHeight
            // 
            labelHeight.AutoSize = true;
            labelHeight.Location = new Point(348, 3);
            labelHeight.Name = "labelHeight";
            labelHeight.Size = new Size(59, 20);
            labelHeight.TabIndex = 4;
            labelHeight.Text = "Высота";
            // 
            // panelTool
            // 
            panelTool.Controls.Add(checkBoxCompressed);
            panelTool.Controls.Add(checkBoxColor);
            panelTool.Controls.Add(textBoxHeight);
            panelTool.Controls.Add(labelHeight);
            panelTool.Controls.Add(textBoxWidth);
            panelTool.Controls.Add(labelWidth);
            panelTool.Dock = DockStyle.Top;
            panelTool.Location = new Point(0, 0);
            panelTool.Name = "panelTool";
            panelTool.Size = new Size(612, 33);
            panelTool.TabIndex = 0;
            // 
            // checkBoxCompressed
            // 
            checkBoxCompressed.AutoSize = true;
            checkBoxCompressed.CheckAlign = ContentAlignment.MiddleRight;
            checkBoxCompressed.Checked = true;
            checkBoxCompressed.CheckState = CheckState.Indeterminate;
            checkBoxCompressed.Enabled = false;
            checkBoxCompressed.ImageAlign = ContentAlignment.MiddleRight;
            checkBoxCompressed.Location = new Point(98, 3);
            checkBoxCompressed.Name = "checkBoxCompressed";
            checkBoxCompressed.Size = new Size(82, 24);
            checkBoxCompressed.TabIndex = 7;
            checkBoxCompressed.Text = "Сжатие";
            checkBoxCompressed.ThreeState = true;
            checkBoxCompressed.UseVisualStyleBackColor = true;
            // 
            // checkBoxColor
            // 
            checkBoxColor.AutoSize = true;
            checkBoxColor.CheckAlign = ContentAlignment.MiddleRight;
            checkBoxColor.Checked = true;
            checkBoxColor.CheckState = CheckState.Indeterminate;
            checkBoxColor.Enabled = false;
            checkBoxColor.Location = new Point(3, 3);
            checkBoxColor.Name = "checkBoxColor";
            checkBoxColor.Size = new Size(89, 24);
            checkBoxColor.TabIndex = 6;
            checkBoxColor.Text = "Цветная";
            checkBoxColor.ThreeState = true;
            checkBoxColor.UseVisualStyleBackColor = true;
            // 
            // textBoxHeight
            // 
            textBoxHeight.Location = new Point(413, 3);
            textBoxHeight.Name = "textBoxHeight";
            textBoxHeight.ReadOnly = true;
            textBoxHeight.Size = new Size(78, 27);
            textBoxHeight.TabIndex = 5;
            // 
            // textBoxWidth
            // 
            textBoxWidth.Location = new Point(264, 3);
            textBoxWidth.Name = "textBoxWidth";
            textBoxWidth.ReadOnly = true;
            textBoxWidth.Size = new Size(78, 27);
            textBoxWidth.TabIndex = 3;
            // 
            // pictureBoxView
            // 
            pictureBoxView.Dock = DockStyle.Fill;
            pictureBoxView.Location = new Point(0, 33);
            pictureBoxView.Name = "pictureBoxView";
            pictureBoxView.Size = new Size(612, 534);
            pictureBoxView.SizeMode = PictureBoxSizeMode.CenterImage;
            pictureBoxView.TabIndex = 1;
            pictureBoxView.TabStop = false;
            // 
            // Picture4CViewComponent
            // 
            AutoScaleDimensions = new SizeF(8F, 20F);
            AutoScaleMode = AutoScaleMode.Font;
            Controls.Add(pictureBoxView);
            Controls.Add(panelTool);
            Name = "Picture4CViewComponent";
            Size = new Size(612, 567);
            panelTool.ResumeLayout(false);
            panelTool.PerformLayout();
            ((System.ComponentModel.ISupportInitialize)pictureBoxView).EndInit();
            ResumeLayout(false);
        }

        #endregion

        private Panel panelTool;
        private PictureBox pictureBoxView;
        private TextBox textBoxHeight;
        private TextBox textBoxWidth;
        private CheckBox checkBoxColor;
        private CheckBox checkBoxCompressed;
    }
}

namespace fileinfo.Views
{
    partial class TextViewComponent
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
            this.textBoxView = new System.Windows.Forms.TextBox();
            this.SuspendLayout();
            // 
            // textBoxView
            // 
            this.textBoxView.Dock = System.Windows.Forms.DockStyle.Fill;
            this.textBoxView.Font = new System.Drawing.Font("Cascadia Mono", 9F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point);
            this.textBoxView.Location = new System.Drawing.Point(0, 0);
            this.textBoxView.Multiline = true;
            this.textBoxView.Name = "textBoxView";
            this.textBoxView.ScrollBars = System.Windows.Forms.ScrollBars.Both;
            this.textBoxView.Size = new System.Drawing.Size(525, 556);
            this.textBoxView.TabIndex = 0;
            this.textBoxView.WordWrap = false;
            // 
            // TextViewComponent
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(8F, 20F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.Controls.Add(this.textBoxView);
            this.Name = "TextViewComponent";
            this.Size = new System.Drawing.Size(525, 556);
            this.ResumeLayout(false);
            this.PerformLayout();

        }

        #endregion

        protected TextBox textBoxView;
    }
}

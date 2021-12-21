namespace fileinfo.Views.Picture
{
    public partial class PictureViewUserControl : UserControl
    {
        public PictureViewUserControl()
        {
            InitializeComponent();
        }

        private void btnSaveAs_Click(object sender, EventArgs e)
        {
            if (pictureBox.Image == null) return;
            if (saveFileDialog.ShowDialog(this) != DialogResult.OK) return;
            pictureBox.Image.Save(saveFileDialog.FileName);
        }
    }
}

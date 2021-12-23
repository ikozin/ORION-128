using fileinfo.Models;

namespace fileinfo.Views
{
    public interface IViewComponent
    {
        void SetEncoding(Func<byte, bool, char> encoding);

        IFileDetail? Current { get; set; }

        UserControl Control { get; }

        void SaveDetailToFile();
    }
}

using fileinfo.Models;

namespace fileinfo.Views
{
    internal interface IViewComponent
    {
        Control GetViewControl();

        void ReloadView(FileDetails detail, Func<byte, bool, char> encoding);

        void ClearView();
    }
}

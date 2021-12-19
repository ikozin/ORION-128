using fileinfo.Models;

namespace fileinfo.Views
{
    internal abstract class ViewComponent<T>: IViewComponent
        where T : Control, new()
    {
        protected readonly T _control = new T();

        public ViewComponent()
        {
            _control.Name = GetType().Name;
            _control.Dock = DockStyle.Fill;
        }

        public virtual Control GetViewControl()
        {
            return _control;
        }

        public abstract void ReloadView(FileDetails detail, Func<byte, bool, char> encoding);
        public abstract void ClearView();
    }
}

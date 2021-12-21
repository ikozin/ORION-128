using fileinfo.Models;

namespace fileinfo.Views
{
    internal abstract class ViewComponent<T> : IViewComponent
        where T : Control, new()
    {
        protected readonly T _control = new T();

        protected FileDetails? _detail;
        protected Func<byte, bool, char>? _encoding;

        public ViewComponent()
        {
            _control.Name = GetType().Name;
            _control.Dock = DockStyle.Fill;
        }

        public virtual Control GetViewControl()
        {
            return _control;
        }

        public virtual void ReloadView(FileDetails detail, Func<byte, bool, char> encoding)
        {
            _detail = detail;
            _encoding = encoding;
            LoadData(_detail, _encoding);
        }

        public abstract void ClearView();

        protected abstract void LoadData(FileDetails? detail, Func<byte, bool, char>? encoding);
    }
}

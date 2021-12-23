using fileinfo.Models;

namespace fileinfo.Views
{
    public class ViewComponent : UserControl, IViewComponent
    {
        protected Func<byte, bool, char> _encoding;
        protected IFileDetail? _detail;

        public ViewComponent()
        {
            _encoding = (_, _) => { return ' '; };
        }

        public ViewComponent(Func<byte, bool, char> encoding)
        {
            _encoding = encoding;
        }

        public UserControl Control => this;

        public void SetEncoding(Func<byte, bool, char> encoding)
        {
            _encoding = encoding;
            LoadView();
        }

        public IFileDetail? Current
        {
            get => _detail;
            set
            {
                if (value == null)
                {
                    _detail = value;
                    ClearView();
                }
                else
                {
                    if (_detail != value)
                    {
                        _detail = value;
                        LoadView();
                    }
                }
            }
        }

        protected virtual void ClearView()
        {
            throw new NotImplementedException();
        }

        protected virtual void LoadView()
        {
            throw new NotImplementedException();
        }

        public virtual void SaveDetailToFile()
        {
            throw new NotImplementedException();
        }
    }
}

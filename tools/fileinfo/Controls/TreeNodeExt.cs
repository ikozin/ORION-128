using fileinfo.Helpers;
using fileinfo.Models;

namespace fileinfo.Controls
{
    public class TreeNodeExt : TreeNode, IDetail, IComparable<TreeNodeExt>
    {
        public TreeNodeExt(IFileDetail detail) : base()
        {
            Detail = detail;
            Text = Path.GetFileName(Detail.Name);
            ToolTipText = Detail.Message;
        }
        public IFileDetail Detail { get; private set; }

        public int CompareTo(TreeNodeExt? other)
        {
            return Detail.CompareTo(other!.Detail);
        }

    }
}

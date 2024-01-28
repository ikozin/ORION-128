using fileinfo.Controls;
using fileinfo.Models;
using System.Linq;

namespace fileinfo.Helpers
{
    internal static class GroupByExtension
    {
        public static TreeNode GetGroup(this TreeView control, string key, string text)
        {
            int index = control.Nodes.IndexOfKey(key);
            if (index != -1)
            {
                return control.Nodes[index];
            }
            var group = control.Nodes.Add(key, text);
            return group;
        }
        public static void GetGroupByCommonStart(List<TreeNodeExt> list)
        {
        }

        public static void GetGroupByPathStart(List<TreeNodeExt> list)
        {
            list.Sort((TreeNodeExt x, TreeNodeExt y) =>
            {
                return String.Compare(x.Detail.FileName, y.Detail.FileName, StringComparison.OrdinalIgnoreCase);
            });
        }

        public static void GetGroupByExecStart(List<TreeNodeExt> list)
        {
            list.Sort((TreeNodeExt x, TreeNodeExt y) =>
            {
                bool xV = x.Detail.Name.EndsWith("$");
                bool yV = y.Detail.Name.EndsWith("$");
                if (!(xV ^ yV))
                {
                    var result = String.Compare(x.Detail.Name, y.Detail.Name, StringComparison.OrdinalIgnoreCase);
                    if (result == 0)
                    {
                        result = String.CompareOrdinal(x.Detail.FileName, y.Detail.FileName);
                    }
                    return result;
                }
                if (xV) return 1;
                return -1;
            });
        }

        public static void GetGroupByCustomStart(List<TreeNodeExt> list)
        {
            list.Sort((TreeNodeExt x, TreeNodeExt y) =>
            {
                bool xV = x.Detail.Name.EndsWith("$");
                bool yV = y.Detail.Name.EndsWith("$");
                var result = xV.CompareTo(yV);
                if (result == 0)
                {
                    result = String.CompareOrdinal(Path.GetExtension(x.Detail.Name), Path.GetExtension(y.Detail.Name));
                    if (result == 0)
                    {
                        result = String.CompareOrdinal(x.Detail.Name, y.Detail.Name);
                        if (result == 0)
                        {
                            result = String.CompareOrdinal(x.Detail.FileName, y.Detail.FileName);
                        }
                    }
                }
                return result;
            });
        }

        public static TreeNode GetGroupByExec(TreeView control, IDetail item)
        {
            if (item.Detail.Name.EndsWith("$"))
            {
                return control.GetGroup("EXE", "Исполняемые");
            }
            return control.GetGroup("LIST", "Остальные");
        }

        public static TreeNode GetGroupByPath(TreeView control, IDetail item)
        {
            string path = item.Detail.FileName;
            if (path.Contains("$"))
                path = path.Substring(0, path.IndexOf("$"));
            string key = Path.GetDirectoryName(path)!;
            return control.GetGroup(key, key);
        }

        public static TreeNode GetGroupByCustom(TreeView control, IDetail item)
        {
            if (item.Detail.IsError)
            {
                return control.GetGroup("ERROR", "ERROR");
            }
            else if (item.Detail.Name.EndsWith("$"))
            {
                return control.GetGroup("EXE", "Исполняемые");
            }
            else if (item.Detail.Name.Contains('.'))
            {
                string key = Path.GetExtension(item.Detail.Name);
                if (key.Length > 0)
                {
                    return control.GetGroup(key, key);
                }
            }
            return control.GetGroup("*", "*");
        }

        public static TreeNode GetGroupByHash(TreeView control, IDetail item)
        {
            string key = item.Detail.Hash.ToHex();
            return control.GetGroup(key, key);
        }

        public static void GetGroupByCommonFinish(TreeView control)
        {
            foreach (TreeNode item in control.Nodes)
            {
                if (item.Level > 0) continue;
                item.Text += $" ({item.Nodes.Count})";
            }
        }

        public static void GetGroupByHashFinish(TreeView control)
        {
            foreach (TreeNode item in control.Nodes)
            {
                if (item.Level > 0) continue;
                item.Text = $"{item.Nodes[0].Text}";// + item.Text;
            }

            //List<ListViewItem> list = new List<ListViewItem>();
            //for (int i = control.Groups.Count - 1; i >= 0; i--)
            //{
            //    var group = control.Groups[i];
            //    if (group.Items.Count > 1)
            //    {
            //        group.Subtitle = String.Format("{0} шт.", group.Items.Count);
            //        continue;
            //    }
            //    list.Add(group.Items[0]);
            //    group.Items.RemoveAt(0);
            //    control.Groups.Remove(group);

            //}
            //var mainGroup = control.GetGroup("UNIQ", "Без дублей");
            //mainGroup.Items.AddRange(list.ToArray());
            //mainGroup.Subtitle = String.Format("{0} шт.", mainGroup.Items.Count);
        }
    }
}

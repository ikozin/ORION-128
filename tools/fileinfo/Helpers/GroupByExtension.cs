using fileinfo.Controls;
using fileinfo.Models;

namespace fileinfo.Helpers
{
    internal static class GroupByExtension
    {
        public static ListViewGroup GetGroup(this ListView control, string key, string text)
        {
            ListViewGroup group = control.Groups[key];
            if (group == null)
            {
                group = new ListViewGroup(key, text);
                group.CollapsedState = ListViewGroupCollapsedState.Collapsed;
                control.Groups.Add(group);
            }
            return group;
        }
        public static void GetGroupByCommonStart(ListView control, List<ListViewItemExt> list)
        {
        }

        public static void GetGroupByPathStart(ListView control, List<ListViewItemExt> list)
        {
            list.Sort((ListViewItemExt x, ListViewItemExt y) =>
            {
                return String.Compare(x.Detail.FileName, y.Detail.FileName, StringComparison.OrdinalIgnoreCase);
            });
        }

        public static void GetGroupByExecStart(ListView control, List<ListViewItemExt> list)
        {
            list.Sort((ListViewItemExt x, ListViewItemExt y) =>
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

        public static void GetGroupByCustomStart(ListView control, List<ListViewItemExt> list)
        {
            list.Sort((ListViewItemExt x, ListViewItemExt y) =>
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

        public static ListViewGroup GetGroupByExec(ListView control, ListViewItemExt item)
        {
            if (item.Detail.Name.EndsWith("$"))
            {
                return control.GetGroup("EXE", "Исполняемые");
            }
            return control.GetGroup("LIST", "Остальные");
        }

        public static ListViewGroup GetGroupByPath(ListView control, ListViewItemExt item)
        {
            string path = item.Detail.FileName;
            if (path.Contains("$"))
                path = path.Substring(0, path.IndexOf("$"));
            string key = Path.GetDirectoryName(path)!;
            return control.GetGroup(key, key);
        }

        public static ListViewGroup GetGroupByCustom(ListView control, ListViewItemExt item)
        {
            if (item.Detail.Name.EndsWith("$"))
            {
                return control.GetGroup("EXE", "Исполняемые");
            }
            else if (item.Detail.Name.Contains('.'))
            {
                string key = Path.GetExtension(item.Detail.Name);
                return control.GetGroup(key, key);
            }
            return control.GetGroup("*", "*");
        }

        public static ListViewGroup GetGroupByHash(ListView control, ListViewItemExt item)
        {
            string key = item.Detail.Hash.ToHex();
            return control.GetGroup(key, key);
        }

        public static void GetGroupByCommonFinish(ListView control)
        {
            foreach (ListViewGroup group in control.Groups)
            {
                group.Subtitle = String.Format("{0} шт.", group.Items.Count);
            }
        }

        public static void GetGroupByHashFinish(ListView control)
        {
            List<ListViewItem> list = new List<ListViewItem>();
            for (int i = control.Groups.Count - 1; i >= 0; i--)
            {
                var group = control.Groups[i];
                if (group.Items.Count > 1)
                {
                    group.Subtitle = String.Format("{0} шт.", group.Items.Count);
                    continue;
                }
                list.Add(group.Items[0]);
                group.Items.RemoveAt(0);
                control.Groups.Remove(group);

            }
            var mainGroup = control.GetGroup("UNIQ", "Без дублей");
            mainGroup.Items.AddRange(list.ToArray());
            mainGroup.Subtitle = String.Format("{0} шт.", mainGroup.Items.Count);
        }
    }
}

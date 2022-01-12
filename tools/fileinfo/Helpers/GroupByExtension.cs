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
        public static void GetGroupByCommonStart(ListView control, List<IFileDetail> list)
        {
        }

        public static void GetGroupByPathStart(ListView control, List<IFileDetail> list)
        {
            list.Sort((IFileDetail x, IFileDetail y) =>
            {
                return String.Compare(x.FileName, y.FileName, StringComparison.OrdinalIgnoreCase);
            });
        }

        public static void GetGroupByExecStart(ListView control, List<IFileDetail> list)
        {
            list.Sort((IFileDetail x, IFileDetail y) =>
            {
                bool xV = x.Name.EndsWith("$");
                bool yV = y.Name.EndsWith("$");
                if (!(xV ^ yV))
                {
                    var result = String.Compare(x.Name, y.Name, StringComparison.OrdinalIgnoreCase);
                    if (result == 0)
                    {
                        result = String.CompareOrdinal(x.FileName, y.FileName);
                    }
                    return result;
                }
                if (xV) return 1;
                return -1;
            });
        }

        public static void GetGroupByCustomStart(ListView control, List<IFileDetail> list)
        {
            list.Sort((IFileDetail x, IFileDetail y) =>
            {
                bool xV = x.Name.EndsWith("$");
                bool yV = y.Name.EndsWith("$");
                var result = xV.CompareTo(yV);
                if (result == 0)
                {
                    result = String.CompareOrdinal(Path.GetExtension(x.Name), Path.GetExtension(y.Name));
                    if (result == 0)
                    {
                        result = String.CompareOrdinal(x.Name, y.Name);
                        if (result == 0)
                        {
                            result = String.CompareOrdinal(x.FileName, y.FileName);
                        }
                    }
                }
                return result;
            });
        }

        public static ListViewGroup GetGroupByExec(ListView control, IFileDetail detail)
        {
            if (detail.Name.EndsWith("$"))
            {
                return control.GetGroup("EXE", "Исполняемые");
            }
            return control.GetGroup("LIST", "Остальные");
        }

        public static ListViewGroup GetGroupByPath(ListView control, IFileDetail detail)
        {
            string path = detail.FileName;
            if (path.Contains("$"))
                path = path.Substring(0, path.IndexOf("$"));
            string key = Path.GetDirectoryName(path)!;
            return control.GetGroup(key, key);
        }

        public static ListViewGroup GetGroupByCustom(ListView control, IFileDetail detail)
        {
            if (detail.Name.EndsWith("$"))
            {
                return control.GetGroup("EXE", "Исполняемые");
            }
            else if (detail.Name.Contains('.'))
            {
                string key = Path.GetExtension(detail.Name);
                return control.GetGroup(key, key);
            }
            return control.GetGroup("*", "*");
        }

        public static ListViewGroup GetGroupByHash(ListView control, IFileDetail detail)
        {
            string key = detail.Hash.ToHex();
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

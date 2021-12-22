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
            string key = Path.GetDirectoryName(detail.FileName)!;
            return control.GetGroup(key, key);
        }

        public static ListViewGroup GetGroupByCustom(ListView control, IFileDetail detail)
        {
            if (detail.Name.EndsWith("$"))
            {
                return control.GetGroup("EXE", "$");
            }
            else if (detail.Name.Contains('.'))
            {
                var start = detail.Name.IndexOf('.');
                var name = detail.Name.Substring(start);
                return control.GetGroup(name, name);
            }
            return control.GetGroup("*", "*");


            //if (detail.Name.EndsWith(".AS"))
            //{
            //    return control.GetGroup("ASM", "Assembler");
            //}
            //else if (detail.Name.EndsWith(".BS"))
            //{
            //    return control.GetGroup("BAS", "Basic");
            //}
            //else if (detail.Name.EndsWith(".C"))
            //{
            //    return control.GetGroup("C", "C");
            //}
            //else if (detail.Name.EndsWith("$"))
            //{
            //    return control.GetGroup("EXE", "Исполняемые");
            //}
            //else if (detail.Name.EndsWith(".TX"))
            //{
            //    return control.GetGroup("TXT", "Текст");
            //}
            //else if (detail.Name.EndsWith(".PC"))
            //{
            //    return control.GetGroup("PIC", "Графика");
            //}
            //return control.GetGroup("OTHER", "Остальные");
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

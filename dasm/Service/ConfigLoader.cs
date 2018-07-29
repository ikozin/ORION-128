using System;
using System.Collections.Generic;
using System.IO;

namespace disasm8080.Service
{
    public static class ConfigLoader
    {
        internal static Dictionary<string, string> LoadDictionary(string path, string defValue = null)
        {
            var lines = File.ReadAllLines(path);
            Dictionary<string, string> list = new Dictionary<string, string>();
            foreach (var line in lines)
            {
                var items = line.Split(new[] { ':' }, StringSplitOptions.RemoveEmptyEntries);
                if (String.IsNullOrEmpty(defValue))
                {
                    if (items.Length != 2) continue;
                    if (items[0].Contains("-"))
                    {
                        (ushort lo, ushort hi) = items[0].ParseBoundary();
                        for (; lo <= hi; lo++)
                        {
                            string addr = lo.ToHex();
                            list.Add(addr, items[1]);
                        }
                    }
                    else
                        list.Add(items[0], items[1]);
                }
                else
                {
                    if (items.Length == 0) continue;
                    if (items[0].Contains("-"))
                    {
                        (ushort lo, ushort hi) = items[0].ParseBoundary();
                        int len = hi - lo;
                        for (int i = 0; i <= len; lo++, i++) // ushort переполнении станет 0, поэтому с ним сравнивать бесполезно
                        {
                            string addr = lo.ToHex();
                            list.Add(addr, items.Length > 1 ? items[1] : defValue);
                        }
                    }
                    else
                        list.Add(items[0], items.Length > 1 ? items[1] : defValue);
                }
            }
            return list;
        }

        private static (ushort, ushort) ParseBoundary(this string value)
        {
            var bounds = value.Split(new[] { '-', ' ' }, StringSplitOptions.RemoveEmptyEntries);
            if (bounds.Length != 2) throw new ApplicationException("Format error");
            ushort lo = bounds[0].ParseHex();
            ushort hi = bounds[1].ParseHex();
            if (lo >= hi) throw new ApplicationException("Format error");
            return (lo, hi);
        }
    }
}

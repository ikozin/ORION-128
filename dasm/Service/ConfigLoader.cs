using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;

namespace Dasm.Service
{
    public static class ConfigLoader
    {
        internal static Dictionary<string, string> LoadDictionary(string path, string defValue = null)
        {
            var lines = File.ReadAllLines(path);
            Dictionary<string, string> list = new Dictionary<string, string>();
            foreach (var line in lines)
            {
                var items = line.Split(new[] { ':' });
                if (String.IsNullOrEmpty(defValue))
                {
                    if (items.Length < 2) continue;
                    string key = items[0];
                    string value = String.Join(":", items.Skip(1).ToArray());
                    if (key.Contains("-"))
                    {
                        (ushort lo, ushort hi) = key.ParseBoundary();
                        for (; lo <= hi; lo++)
                        {
                            string addr = lo.ToHex();
                            list.Add(addr, value);
                        }
                    }
                    else
                        list.Add(key, value);
                }
                else
                {
                    if (items.Length == 0) continue;
                    string key = items[0];
                    string value = String.Join(":", items.Skip(1).ToArray());
                    if (key.Contains("-"))
                    {
                        (ushort lo, ushort hi) = key.ParseBoundary();
                        int len = hi - lo;
                        for (int i = 0; i <= len; lo++, i++) // ushort переполнении станет 0, поэтому с ним сравнивать бесполезно
                        {
                            string addr = lo.ToHex();
                            list.Add(addr, items.Length > 1 ? value : defValue);
                        }
                    }
                    else
                        list.Add(key, items.Length > 1 ? value : defValue);
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

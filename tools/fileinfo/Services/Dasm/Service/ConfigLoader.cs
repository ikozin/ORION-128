using fileinfo.Helpers;

namespace fileinfo.Services.Dasm.Service
{
    public static class ConfigLoader
    {
        internal static Dictionary<string, string> LoadDictionary(string text)
        {
            Dictionary<string, string> list = new();
            foreach (var line in text.Split(Environment.NewLine))
            {
                var items = line.Split(':');
                if (items.Length < 2) continue;
                string key = items[0];
                string value = string.Join(":", items.Skip(1).ToArray());

                if (!HandleBoundary(key, value, list))
                    list.Add(key, value);
            }
            return list;
        }

        // Обрабатываем диапазон адресов
        private static bool HandleBoundary(string key, string value, Dictionary<string, string> list)
        {
            if (!key.Contains('-')) return false;
            (ushort lo, ushort hi) = key.ParseBoundary();
            int len = hi - lo;
            for (int i = 0; i <= len; lo++, i++) // ushort при переполнении станет 0, поэтому с ним сравнивать бесполезно
            {
                string addr = lo.ToHex();
                list.Add(addr, value);
            }
            return true;
        }

        // Получаем диапазон адресов
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

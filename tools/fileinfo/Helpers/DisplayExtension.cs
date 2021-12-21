using System.Text;

namespace fileinfo.Helpers
{
    internal static class DisplayExtension
    {
        private static StringBuilder _text = new StringBuilder(256);

        public static string ToHex(this byte? value)
        {
            if (!value.HasValue) return String.Empty;
            return value.Value.ToHex();
        }

        public static string ToHex(this byte value)
        {
            return value.ToString("X2");
        }

        public static string ToHex(this ushort? value)
        {
            if (!value.HasValue) return String.Empty;
            return value.Value.ToHex();
        }

        public static string ToHex(this ushort value)
        {
            return value.ToString("X4");
        }

        public static string ToHexAsm(this byte value)
        {
            string data = String.Format("{0:X2}H", value);
            if (data[0] >= 'A') data = '0' + data;
            return data;
        }

        public static string ToHexAsm(this ushort value)
        {
            string data = String.Format("{0:X4}H", value);
            if (data[0] >= 'A') data = '0' + data;
            return data;
        }

        public static string ToHexWithNumber(this ushort? value)
        {
            if (!value.HasValue) return String.Empty;
            return String.Format("{0:X4} ({0})", value.Value);
        }

        public static string ToHex(this byte[] value)
        {
            _text.Clear();
            foreach (var item in value)
            {
                _text.AppendFormat("{0:X2}", item);
            }
            return _text.ToString();
        }

    }
}

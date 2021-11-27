using System;
using System.Globalization;

namespace bin2bru.Service
{
    public static class HexHelper
    {
        public static ushort ParseHex(this string value)
        {
            value = value.Trim();
            while (value[0] == '0') value = value.Substring(1);
            value = value.Substring(0, value.Length - 1);
            return ushort.Parse(value, NumberStyles.HexNumber);
        }

        public static string ToHex(this byte value)
        {
            string data = String.Format("{0:X2}H", value);
            if (data[0] >= 'A') data = '0' + data;
            return data;
        }

        public static string ToHex(this ushort value)
        {
            string data = String.Format("{0:X4}H", value);
            if (data[0] >= 'A') data = '0' + data;
            return data;
        }
    }
}

using System.Globalization;

namespace fileinfo.Services.Dasm.Service
{
    public static class HexHelper
    {
        public static ushort ParseHex(this string value)
        {
            value = value.Trim();
            while (value[0] == '0') value = value[1..];
            value = value[0..^1];
            return ushort.Parse(value, NumberStyles.HexNumber);
        }
    }
}

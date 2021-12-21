using fileinfo.Helpers;
using fileinfo.Models;
using System.Text;

namespace fileinfo.Views
{
    internal static class ContentToCheckSum
    {
        public static string Process(FileDetails detail, Func<byte, bool, char> encoding)
        {
            if (detail.Content.Length == 0) return String.Empty;

            var text = new StringBuilder();
            var sum = detail.Content.CalculateCheckSum();
            text.Append(sum.ToHex());
            return text.ToString();
        }

        private static ushort CalculateCheckSum(this byte[] data)
        {
            ushort totalSum = 0;
            ushort cyclicSum = 0;
            foreach (var b in data)
            {
                totalSum += b;
                cyclicSum += b;
                if ((cyclicSum & 0xFF) > 0) cyclicSum += 1;
                totalSum &= 0xFF;
                cyclicSum &= 0xFF;
            }
            return (ushort)((cyclicSum << 8) | totalSum);
        }
    }
}

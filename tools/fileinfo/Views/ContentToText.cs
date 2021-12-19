using fileinfo.Models;
using System.Text;

namespace fileinfo.Views
{
    internal static class ContentToText
    {
        public static string Process(FileDetails detail, Func<byte, bool, char> encoding)
        {
            if (detail.Content.Length == 0) return String.Empty;

            var text = new StringBuilder();
            foreach (var item in detail.Content)
            {
                text.Append(encoding(item, true));
            }
            text.Replace("\r", Environment.NewLine);
            return text.ToString();
        }
    }
}

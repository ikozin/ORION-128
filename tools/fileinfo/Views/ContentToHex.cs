using fileinfo.Models;

namespace fileinfo.Views
{
    internal static class ContentToHex
    {
        public static string Process(FileDetails detail, Func<byte, bool, char> encoding)
        {
            return ContentToHexWithAddr.ByteArrayToHex(detail.Content, 0, encoding);
        }
    }
}

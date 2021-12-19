using fileinfo.Helpers;
using fileinfo.Models;
using System.Text;

namespace fileinfo.Views
{
    internal static class ContentToDisAsmDump
    {
        public static string Process(FileDetails detail, Func<byte, bool, char> encoding)
        {
            if (detail.Content == null || detail.Content.Length == 0) return String.Empty;

            var text = new StringBuilder();

            text.Append("ORG ");
            text.AppendLine(detail.Address!.Value.ToHexAsm());
            text.AppendLine();

            try
            {
                ushort addr = detail.Address!.Value;
                foreach (var data in detail.Content)
                {
                    var line = String.Format("DB   {0}", data.ToHexAsm());
                    text.AppendFormat("{0, -32};{1} '{2}'", line, addr.ToHexAsm(), encoding(data, false));
                    text.AppendLine();
                }
            }
            catch (Exception ex)
            {
                text.AppendLine(ex.Message);
            }

            return text.ToString();
        }
    }
}

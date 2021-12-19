using fileinfo.Helpers;
using fileinfo.Models;
using fileinfo.Services;
using System.Text;

namespace fileinfo.Views
{
    internal static class ContentToDisAssembler
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
                HashSet<ushort> codeAddress = DisAssemblerAlalyzer.Alalyze(detail.Content, detail.Address!.Value);
                DisAssemblerAlalyzer.DisAssembleCode(text, detail.Content, detail.Address!.Value, codeAddress, encoding);
            }
            catch (Exception ex)
            {
                text.AppendLine(ex.Message);
            }

            return text.ToString();
        }
    }
}

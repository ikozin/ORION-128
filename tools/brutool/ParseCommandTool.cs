using System.CommandLine.Parsing;

namespace brutool
{
    public class Parsing
    {
        public static FileInfo? ParseFileInfoExistsOption(ArgumentResult result)
        {
            if (result.Tokens.Count == 0)
            {
                result.AddError("Неуказано имя файла");
                return null;
            }
            string? path = result.Tokens.Single().Value;
            if (!File.Exists(path))
            {
                result.AddError(string.Format("Файл \"{0}\" не найден", path));
                return null;
            }
            return new FileInfo(path);
        }
        public static FileInfo[] ParseFileInfoListOption(ArgumentResult result)
        {
            List<FileInfo> list = [];
            if (result.Tokens.Count == 0)
            {
                result.AddError("Неуказаны файлы");
                return [];
            }
            foreach (var token in result.Tokens)
            {
                string path = token.Value;
                if (path.Contains('*') || path.Contains('?'))
                {
                    var dir = Path.GetDirectoryName(path) ?? ".";
                    var pattern = Path.GetFileName(path);
                    var files = Directory.EnumerateFiles(dir, pattern);
                    foreach (var file in files)
                    {
                        list.Add(new FileInfo(file));
                    }
                }
                else
                {
                    if (!File.Exists(path))
                    {
                        result.AddError(string.Format("Файл \"{0}\" не найден", path));
                        return [];
                    }
                    list.Add(new FileInfo(path));
                }
            }
            return [.. list];
        }
        public static string ParseDirectoryOption(ArgumentResult result)
        {
            if (result.Tokens.Count == 0)
            {
                return Path.GetFullPath(".");
            }
            return Path.GetFullPath(result.Tokens.Single().Value);
        } 
    }
}
namespace fileinfo.Services.Dasm.Model
{
    public abstract class OpData
    {
        public string Format { get; private set; }

        private readonly string _formattingBlank;

        public OpData(string fmt, string fmtBlank)
        {
            Format = fmt;
            _formattingBlank = fmtBlank;
        }

        public abstract string GetString(Stream stream, Func<byte, bool, char> encoding);

        public string ToString(Stream stream, Func<byte, bool, char> encoding)
        {
            string value = GetString(stream, encoding);
            return string.Format("{0}{1}{2}", Format, _formattingBlank, value);
        }
    }
}

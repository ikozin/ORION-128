namespace fileinfo.Services.Dasm.Model
{
    public class OpDataChar : OpData
    {
        private readonly int _byteCount;
        public OpDataChar(string fmt, int count, string fmtBlank) : base(fmt, fmtBlank)
        {
            _byteCount = count;
        }

        public override string GetString(Stream stream, Func<byte, bool, char> encoding)
        {
            string result = String.Empty;
            for (int i = 0; i < _byteCount; i++)
            {
                if (stream.Position == stream.Length) throw new IndexOutOfRangeException();
                byte data = (byte)stream.ReadByte();
                result = String.Format("{0}{1}", result, encoding(data, false));
            }
            return String.Format("'{0}'", result);
        }
    }
}

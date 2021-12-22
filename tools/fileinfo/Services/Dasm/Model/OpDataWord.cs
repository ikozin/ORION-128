namespace fileinfo.Services.Dasm.Model
{
    public class OpDataWord : OpData
    {
        public OpDataWord(string fmtBlank) : base("DW", fmtBlank)
        {
        }

        public override string GetString(Stream stream, Func<byte, bool, char> encoding)
        {
            if (stream.Position == stream.Length) throw new IndexOutOfRangeException();
            byte lo = (byte)stream.ReadByte();
            if (stream.Position == stream.Length) throw new IndexOutOfRangeException();
            byte hi = (byte)stream.ReadByte();
            ushort data = (ushort)((hi << 8) | lo);

            return data.ToString();
        }
    }
}

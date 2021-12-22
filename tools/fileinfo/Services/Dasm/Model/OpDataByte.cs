namespace fileinfo.Services.Dasm.Model
{
    public class OpDataByte : OpData
    {
        public OpDataByte(string fmtBlank) : base("DB", fmtBlank)
        {
        }

        public override string GetString(Stream stream, Func<byte, bool, char> encoding)
        {
            if (stream.Position == stream.Length) throw new IndexOutOfRangeException();
            byte data = (byte)stream.ReadByte();

            return data.ToString();
        }
    }
}

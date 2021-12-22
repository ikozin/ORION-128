namespace fileinfo.Services.Dasm.Model
{
    public class OpDataString : OpData
    {
        public OpDataString(string fmtBlank) : base("DB", fmtBlank)
        {
        }

        public override string GetString(Stream stream, Func<byte, bool, char> encoding)
        {
            string result = "";
            while (true)
            {
                if (stream.Position == stream.Length) throw new IndexOutOfRangeException();
                byte data = (byte)stream.ReadByte();
                if (data == 0) break;

                if (IsChar(data))
                    result = String.Format("{0},'{1}'", result, encoding(data, false));
                else
                    result = String.Format("{0},{1}", result, data);
            }
            result = result.Replace("','", "")[1..];
            return String.Format("{0}, 0", result);
        }

        private static bool IsChar(byte data)
        {
            return (data >= 0x20) && (data < 0x7F);
        }
    }
}

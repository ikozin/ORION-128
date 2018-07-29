using System;
using System.IO;

namespace disasm8080.Model
{
    public class OpDataByte : OpData
    {
        public OpDataByte(string fmtBlank) : base("DB", fmtBlank)
        {
        }

        public override string GetString(Stream stream)
        {
            if (stream.Position == stream.Length) throw new IndexOutOfRangeException();
            byte data = (byte)stream.ReadByte();

            return data.ToString();
        }
    }
}

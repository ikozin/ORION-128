using System;
using System.IO;

namespace Dasm.Model
{
    public class OpDataBinary : OpData
    {
        private readonly int _byteCount;
        public OpDataBinary(string fmt, int count, string fmtBlank) : base(fmt, fmtBlank)
        {
            _byteCount = count;
        }

        public override string GetString(Stream stream)
        {
            string result = String.Empty;
            for (int i = 0; i < _byteCount; i++)
            {
                if (stream.Position == stream.Length) throw new IndexOutOfRangeException();
                byte data = (byte)stream.ReadByte();
                string text = Convert.ToString(data, 2);
                while (text.Length < 8) text = "0" + text;
                result = text + result;
            }
            return result + "B";
        }
    }
}

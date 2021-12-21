using fileinfo.Services.Dasm.Model;
using System;
using System.IO;

namespace fileinfo.Services.Dasm.Model
{
    public class OpDataHex : OpData
    {
        private readonly int _byteCount;
        public OpDataHex(string fmt, int count, string fmtBlank) : base(fmt, fmtBlank)
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
                result = String.Format("{1:X2}{0}", result, data);
            }
            if (result[0] >= 'A') result = '0' + result;
            return String.Format("{0}H", result);
        }
    }
}

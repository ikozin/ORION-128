using fileinfo.Services.Dasm.Model;
using System;
using System.Collections.Generic;

namespace fileinfo.Services.Dasm.Model
{
    public static class OpDataArray
    {
        private const string Blanks = "    ";
        private static readonly Dictionary<string, OpData> _list = new();

        static OpDataArray()
        {
            _list.Add("B", new OpDataByteBinary(Blanks));
            _list.Add("C", new OpDataByteChar(Blanks));
            _list.Add("H", new OpDataByteHex(Blanks));
            _list.Add("D", new OpDataByte(Blanks));
            _list.Add("WB", new OpDataWordBinary(Blanks));
            _list.Add("WC", new OpDataWordChar(Blanks));
            _list.Add("WH", new OpDataWordHex(Blanks));
            _list.Add("WD", new OpDataWord(Blanks));
            _list.Add("DC", new OpDataDWordChar(Blanks));
            _list.Add("QC", new OpDataQWordChar(Blanks));
            _list.Add("S", new OpDataString(Blanks));
            _list.Add("C2", new OpDataCharSize(Blanks, 2));
            _list.Add("C3", new OpDataCharSize(Blanks, 3));
            _list.Add("C4", new OpDataCharSize(Blanks, 4));
            _list.Add("C5", new OpDataCharSize(Blanks, 5));
            _list.Add("C6", new OpDataCharSize(Blanks, 6));
            _list.Add("C7", new OpDataCharSize(Blanks, 7));
            _list.Add("C8", new OpDataCharSize(Blanks, 8));
        }

        public static OpData Get(string key)
        {
            if (!_list.ContainsKey(key)) throw new IndexOutOfRangeException();
            return _list[key];
        }
    }
}

﻿using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace disasm8080.Model
{
    public class OpDataString : OpData
    {
        public OpDataString(string fmtBlank) : base("DB", fmtBlank)
        {
        }

        public override string GetString(Stream stream)
        {
            string result = "";
            while (true)
            {
                if (stream.Position == stream.Length) throw new IndexOutOfRangeException();
                byte data = (byte)stream.ReadByte();
                if (data == 0) break;
                if ((char)data >= ' ')
                    result = String.Format("{0},'{1}'", result, (char)data);
                else
                    result = String.Format("{0},{1}", result, data);
            }
            result = result.Replace("','", "").Substring(1);
            return String.Format("{0}, 0", result);
        }
    }
}

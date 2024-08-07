﻿using Dasm.Service;

namespace Dasm.Model
{
    public class OpCode
    {
        public string Command { get; set; }
        public bool HasByte { get; set; }
        public bool HasWord { get; set; }

        private readonly Dictionary<string, string> _constList;


        public OpCode(string cmd, bool b, bool w, Dictionary<string, string> list)
        {
            Command = cmd;
            HasByte = b;
            HasWord = w;
            _constList = list;
        }

        public OpCode(string cmd, Dictionary<string, string> list) : this(cmd, false, false, list)
        {
        }

        public string ToString(Stream stream)
        {
            string? param = null;
            if (HasByte)
            {
                if (stream.Position == stream.Length) throw new IndexOutOfRangeException();
                byte data = (byte)stream.ReadByte();
                param = data.ToHex();
            }
            else if (HasWord)
            {
                if (stream.Position == stream.Length) throw new IndexOutOfRangeException();
                byte lo = (byte)stream.ReadByte();
                if (stream.Position == stream.Length) throw new IndexOutOfRangeException();
                byte hi = (byte)stream.ReadByte();
                ushort word = (ushort)((hi << 8) | lo);
                param = word.ToHex();
            }
            if (param != null && _constList.ContainsKey(param))
            {
                param = _constList[param];
                if (param.StartsWith(";")) param = param.Substring(1);
            }
            return String.Format(Command, param);
        }
    }
}

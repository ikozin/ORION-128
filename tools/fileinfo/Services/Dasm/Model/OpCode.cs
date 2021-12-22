using fileinfo.Helpers;

namespace fileinfo.Services.Dasm.Model
{
    public class OpCode
    {
        public string Command { get; set; }
        public bool HasByte { get; set; }
        public bool HasWord { get; set; }
        public byte? ParamByte { get; private set; }
        public ushort? ParamWord { get; private set; }

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


        public override string ToString()
        {
            if (HasByte) return String.Format(Command, ParamByte.ToHex());
            if (HasWord) return String.Format(Command, ParamWord.ToHex());
            return Command;
        }

        public string Parse(Stream stream, bool includeComent = false)
        {
            string? param = null;
            if (HasByte)
            {
                if (stream.Position == stream.Length) throw new IndexOutOfRangeException();
                ParamByte = (byte)stream.ReadByte();
                param = ParamByte.ToHexAsm();
            }
            else if (HasWord)
            {
                if (stream.Position == stream.Length) throw new IndexOutOfRangeException();
                byte lo = (byte)stream.ReadByte();
                if (stream.Position == stream.Length) throw new IndexOutOfRangeException();
                byte hi = (byte)stream.ReadByte();
                ParamWord = (ushort)(hi << 8 | lo);
                param = ParamWord.ToHexAsm();
            }
            if (includeComent && param != null && _constList.ContainsKey(param))
            {
                param = _constList[param];
                if (param.StartsWith(";")) param = param[1..];
            }
            return string.Format(Command, param);
        }
    }
}

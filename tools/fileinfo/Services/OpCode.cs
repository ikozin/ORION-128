namespace fileinfo.Services
{
    public class OpCode
    {
        public string Command { get; private set; }
        public bool HasByte { get; private set; }
        public bool HasWord { get; private set; }
        public byte? ParamByte { get; private set; }
        public ushort? ParamWord { get; private set; }


        public OpCode(string cmd, bool b, bool w)
        {
            Command = cmd;
            HasByte = b;
            HasWord = w;
            ParamByte = null;
            ParamWord = null;
        }

        public OpCode(string cmd) : this(cmd, false, false)
        {
        }

        public void Parse(Stream stream)
        {
            if (HasByte)
            {
                if (stream.Position == stream.Length) throw new IndexOutOfRangeException();
                ParamByte = (byte)stream.ReadByte();
            }
            else if (HasWord)
            {
                if (stream.Position == stream.Length) throw new IndexOutOfRangeException();
                byte lo = (byte)stream.ReadByte();
                if (stream.Position == stream.Length) throw new IndexOutOfRangeException();
                byte hi = (byte)stream.ReadByte();
                ParamWord = (ushort)((hi << 8) | lo);
            }
        }

        public override string ToString()
        {
            if (HasByte) return String.Format(Command, ToHex(ParamByte!.Value));
            if (HasWord) return String.Format(Command, ToHex(ParamWord!.Value));
            return Command;
        }

        private static string ToHex(byte value)
        {
            string data = String.Format("{0:X2}H", value);
            if (data[0] >= 'A') data = '0' + data;
            return data;
        }

        private static string ToHex(ushort value)
        {
            string data = String.Format("{0:X4}H", value);
            if (data[0] >= 'A') data = '0' + data;
            return data;
        }
    }
}

using System.Text;

namespace fileinfo.Models
{
    public class OdiFileEntry
    {
        public byte User { get; private set; }
        public byte[] Name { get; private set; }
        public byte[] Ext { get; private set; }
        public byte RecNo { get; private set; }
        public byte Rezerv1 { get; private set; }
        public byte Rezerv2 { get; private set; }
        public byte ExtSize { get; private set; }
        public ushort[] Extent;     //16 байт, 8 слов
        public string FileName { get; private set; }    // 8 байт - имя, 3 байта - расширение

        public OdiFileEntry(BinaryReader reader)
        {
            User = reader.ReadByte();
            Name = reader.ReadBytes(8);
            Ext = reader.ReadBytes(3);
            FileName = String.Format("{0}.{1}", Encoding.ASCII.GetString(Name).Trim(), Encoding.ASCII.GetString(Ext).Trim());

            RecNo = reader.ReadByte();
            Rezerv1 = reader.ReadByte();
            Rezerv2 = reader.ReadByte();
            ExtSize = reader.ReadByte();
            Extent = new ushort[8];
            for (int i = 0; i < Extent.Length; i++)
            {
                Extent[i] = reader.ReadUInt16();
            }
        }
    }
}

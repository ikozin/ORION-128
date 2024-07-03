using fileinfo.Controls;
using System.Text;

namespace fileinfo.Models
{
    public class RkoFileDetail : FileDetail
    {
        private const int Sync_Offset = 0x48;
        private const int BRU_Offset = 0x4d;

        public override bool ParseData(string fileName, BinaryReader reader, ICollection<TreeNodeExt>? list)
        {
            FileName = fileName;
            long size = reader.BaseStream.Length;
            reader.BaseStream.Seek(Sync_Offset, SeekOrigin.Begin);
            byte sync = reader.ReadByte();
            if (sync != 0xE6)
            {
                return false;
            }
            
            Address = reader.ReadByte();                    // Lo
            Address += (ushort)(reader.ReadByte() << 8);    // Hi
            Size = reader.ReadUInt16();

            //reader.BaseStream.Seek(BRU_Offset, SeekOrigin.Begin);
            //size -= BRU_Offset;
            Name = Encoding.ASCII.GetString(reader.ReadBytes(8)).Trim();
            Address = reader.ReadUInt16();
            Size = reader.ReadUInt16();
            var attribute = reader.ReadByte();
            var reserv = reader.ReadBytes(3);
            Content = reader.ReadBytes(Size);
            return true;
        }
    }
}

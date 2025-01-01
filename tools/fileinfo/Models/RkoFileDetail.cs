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
            //  Преамбула записи на ленту
            Name = Encoding.ASCII.GetString(reader.ReadBytes(8)).Trim();
            byte sync;
            do
            {
                sync = reader.ReadByte();
            } while (sync != 0xE6);
            
            Address = reader.ReadByte();                    // Lo
            Address += (ushort)(reader.ReadByte() << 8);    // Hi
            Size = reader.ReadUInt16();

            // Заголовок файла
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

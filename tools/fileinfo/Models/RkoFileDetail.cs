using System.Text;

namespace fileinfo.Models
{
    public class RkoFileDetail : FileDetail
    {
        private const int BRU_Offset = 0x4d;
        public override IFileDetail LoadData(string fileName)
        {
            try
            {
                FileName = fileName;
                using (var stream = File.Open(fileName, FileMode.Open))
                using (BinaryReader reader = new BinaryReader(stream))
                {
                    long size = stream.Length;
                    stream.Seek(BRU_Offset, SeekOrigin.Begin);
                    size -= BRU_Offset;
                    Name = Encoding.ASCII.GetString(reader.ReadBytes(8)).Trim();
                    Address = reader.ReadUInt16();
                    Size = reader.ReadUInt16();
                    var attribute = reader.ReadByte();
                    var reserv = reader.ReadBytes(3);
                    Content = reader.ReadBytes(Size);
                    ComputeHash();
                }
            }
            catch (Exception ex)
            {
                Name = "";
                Size = 0;
                Address = 0;
                Message = ex.Message;
                IsError = true;
            }
            return this;
        }

        private ushort swapByte(ushort value)
        {
            return (ushort)((ushort)(value << 8) & 0xFF00 | (ushort)(value >> 8) & 0xFF);
        }
    }
}

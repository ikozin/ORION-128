using System.Text;

namespace fileinfo.Models
{
    internal class RkoFileDetails : FileDetails
    {
        private const int BRU_Offset = 0x4d;
        public override void LoadData(string fileName)
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
                    Content = reader.ReadBytes((int)Size);
                    ComputeHash();
                }
            }
            catch (Exception ex)
            {
                Name = "";
                Size = null;
                Address = null;
                Message = ex.Message;
                IsError = true;
            }
        }

        private ushort swapByte(ushort value)
        {
            return (ushort)((ushort)(value << 8) & 0xFF00 | (ushort)(value >> 8) & 0xFF);
        }
    }
}

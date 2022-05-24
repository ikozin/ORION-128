using System.Text;

namespace fileinfo.Models
{
    public class RkoFileDetail : FileDetail
    {
        private const int BRU_Offset = 0x4d;

        public override void LoadData(string fileName, BinaryReader reader, ICollection<IFileDetail> list)
        {
            FileName = fileName;
            long size = reader.BaseStream.Length;
            reader.BaseStream.Seek(BRU_Offset, SeekOrigin.Begin);
            size -= BRU_Offset;
            Name = Encoding.ASCII.GetString(reader.ReadBytes(8)).Trim();
            Address = reader.ReadUInt16();
            Size = reader.ReadUInt16();
            var attribute = reader.ReadByte();
            var reserv = reader.ReadBytes(3);
            Content = reader.ReadBytes(Size);
            ComputeHash();
            lock (list) list.Add(this);
        }

        public override void LoadData(string fileName, ICollection<IFileDetail> list)
        {
            try
            {
                using (var stream = File.Open(fileName, FileMode.Open))
                using (BinaryReader reader = new BinaryReader(stream))
                {
                    LoadData(fileName, reader, list);
                }
            }
            catch (Exception ex)
            {
                Name = "";
                Size = 0;
                Address = 0;
                Message = ex.Message;
                IsError = true;
                lock (list) list.Add(this);
            }
        }
    }
}

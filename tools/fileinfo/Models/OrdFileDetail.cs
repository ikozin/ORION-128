using System.Text;

namespace fileinfo.Models
{
    public class OrdFileDetail : FileDetail
    {
        public override void LoadData(string fileName, BinaryReader reader, ICollection<IFileDetail> list)
        {
            FileName = fileName;
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
                Message = ex.Message;
                IsError = true;
                lock (list) list.Add(this);
            }
        }
    }
}

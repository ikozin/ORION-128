using System.Text;

namespace fileinfo.Models
{
    internal class BruFileDetails : FileDetails
    {
        public override void LoadData(string fileName)
        {
            try
            {
                FileName = fileName;
                using (var stream = File.Open(fileName, FileMode.Open))
                using (BinaryReader reader = new BinaryReader(stream))
                {
                    Name = Encoding.ASCII.GetString(reader.ReadBytes(8)).Trim();
                    Address = reader.ReadUInt16();
                    Size = reader.ReadUInt16();
                    var attribute = reader.ReadByte();
                    var reserv = reader.ReadBytes(3);
                    Content = reader.ReadBytes(Size.Value);
                    ComputeHash();
                }
            }
            catch (Exception ex)
            {
                Message = ex.Message;
                IsError = true;
            }
        }

    }
}

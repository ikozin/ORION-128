using fileinfo.Controls;
using fileinfo.Helpers;
using System.Security.Cryptography;

namespace fileinfo.Models
{
    public abstract class FileDetail : IFileDetail
    {
        public bool IsError { get; protected set; }
        public string FileName { get; protected set; }
        public string Name { get; protected set; }
        public ushort Size { get; protected set; }
        public ushort Address { get; protected set; }
        public byte[] Hash { get; protected set; }
        public byte[] Content { get; protected set; }
        public string Message { get; protected set; }

        public FileDetail()
        {
            FileName = String.Empty;
            Name = String.Empty;
            Size = 0;
            Address = 0;
            Hash = Array.Empty<byte>();
            Content = Array.Empty<byte>();
            IsError = false;
            Message = String.Empty;
        }

        public void LoadData(string fileName, ICollection<TreeNodeExt> list)
        {
            try
            {
                using (var stream = File.OpenRead(fileName))
                using (BinaryReader reader = new BinaryReader(stream))
                {
                    LoadData(fileName, reader, list);
                }
            }
            catch (Exception ex)
            {
                Name = fileName;
                Size = 0;
                Address = 0;
                Message = ex.Message;
                IsError = true;
                lock (list) list.Add(new TreeNodeExt(this));
            }
        }


        public void LoadData(string fileName, BinaryReader reader, ICollection<TreeNodeExt> list)
        {
            if (!ParseData(fileName, reader, list)) return;
            ComputeHash();
            Message = $"{FileName}\rName:{Name.Convert()}, Size:{Size}, Address:{Address.ToHexAsm()}\rHash:{Hash.ToHex()}";
            lock (list) list.Add(new TreeNodeExt(this));
        }


        public abstract bool ParseData(string fileName, BinaryReader reader, ICollection<TreeNodeExt> list);

        public int CompareTo(IFileDetail? other)
        {
            return FileName.CompareTo(other!.FileName);
        }

        protected void ComputeHash()
        {
            if (Content.Length == 0) return;

            using (SHA256 hash = SHA256.Create())
            {
                Hash = hash.ComputeHash(Content);
            }
        }
    }
}

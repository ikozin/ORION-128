using System.Security.Cryptography;

namespace fileinfo.Models
{
    internal abstract class FileDetails: IComparable<FileDetails>
    {
        public bool IsError { get; protected set; }
        public string FileName { get; protected set; }
        public string Name { get; protected set; }
        public ushort? Size { get; protected set; }
        public ushort? Address { get; protected set; }
        public byte[] Hash { get; protected set; }
        public byte[] Content { get; protected set; }
        public string Message { get; protected set; }

        public FileDetails()
        {
            FileName = String.Empty;
            Name = String.Empty;
            Size = null;
            Address = null;
            Hash = Array.Empty<byte>();
            Content = Array.Empty<byte>();
            IsError = false;
            Message = String.Empty;
        }

        public abstract void LoadData(string fileName);

        public int CompareTo(FileDetails? other)
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

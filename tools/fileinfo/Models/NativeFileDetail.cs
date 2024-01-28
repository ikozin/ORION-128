using fileinfo.Controls;

namespace fileinfo.Models
{
    public class NativeFileDetail : FileDetail
    {

        public override bool ParseData(string fileName, BinaryReader reader, ICollection<TreeNodeExt>? list)
        {
            FileName = fileName;
            Name = Path.GetFileName(fileName);
            Address = 0;
            Size = (ushort)reader.BaseStream.Length;
            Content = reader.ReadBytes(Size);
            return true;
        }

    }
}

using fileinfo.Controls;
using fileinfo.Helpers;

namespace fileinfo.Models
{
    public class OdiFileDetail : FileDetail
    {
        public override bool ParseData(string fileName, BinaryReader reader, ICollection<TreeNodeExt>? list)
        {
            if (reader.BaseStream.Length != 819200)
            {
                return false;
            }

            FileName = fileName;

            List<OdiFileEntry> entryList = reader.GetOdiFileEntries();
            var odiList = entryList.Where(d => d.User != 0xE5 && d.RecNo == 0);
            foreach (OdiFileEntry entry in odiList)
            {
                IFileDetail? detail = null;
                string ext = Path.GetExtension(entry.FileName).ToUpper();
                switch (ext)
                {
                    case ".BRU":
                        {
                            detail = new BruFileDetail();
                            break;
                        }
                    case ".ORD":
                        {
                            detail = new OrdFileDetail();
                            break;
                        }
                }
                if (detail != null)
                {
                    using (MemoryStream streamFile = entry.ExtractFile(reader, entryList))
                    using (BinaryReader readerFile = new BinaryReader(streamFile))
                    {
                        detail!.LoadData(fileName + "$" + entry.FileName, readerFile, list);
                    }
                }
            }
            return false;
        }
    }
}

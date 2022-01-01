using fileinfo.Helpers;

namespace fileinfo.Models
{
    public class OdiFileDetail : FileDetail
    {
        public override void LoadData(string fileName, BinaryReader reader, List<IFileDetail> list)
        {
            if (reader.BaseStream.Length != 819200)
            {
                return;
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
        }

        public override void LoadData(string fileName, List<IFileDetail> list)
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
                list.Add(this);
            }
        }
    }
}

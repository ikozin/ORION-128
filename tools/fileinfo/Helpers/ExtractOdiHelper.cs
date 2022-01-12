using fileinfo.Models;

namespace fileinfo.Helpers
{
    public static class ExtractOdiHelper
    {
        private const int DIR_ENTRY = 128;
        private const int BASE = 0x5000;
        private const int EXTSIZEINBYTES = 0x800;
        private const int EXT_SIZE = 128;

        private static long ext_offset(int extent)
        {
            return (long)BASE + (long)extent * (long)EXTSIZEINBYTES;
        }

        public static List<OdiFileEntry> GetOdiFileEntries(this BinaryReader reader)
        {
            var entries = new List<OdiFileEntry>();
            reader.BaseStream.Position = ext_offset(0);
            entries.LoadFileInfo(reader);
            reader.BaseStream.Position = ext_offset(1);
            entries.LoadFileInfo(reader);
            return entries;
        }

        public static void LoadFileInfo(this List<OdiFileEntry> list, BinaryReader reader)
        {
            for (int i = 0; i < DIR_ENTRY; i++)
            {
                var item = new OdiFileEntry(reader);
                if (item.User == 0xE5) break;
                list.Add(item);
            }
        }

        public static MemoryStream ExtractFile(this OdiFileEntry entry, BinaryReader reader, List<OdiFileEntry> entryList)
        {
            var records = entryList
                .Where(e => e.FileName == entry.FileName)
                .OrderBy(e => e.RecNo)
                .ToArray();
            List<byte> data = new();
            foreach (OdiFileEntry record in records)
            {
                for (int i = 0; i < record.Extent.Length; i++)
                {
                    if (record.Extent[i] == 0) break;

                    long offset = ext_offset(record.Extent[i]);
                    reader.BaseStream.Position = offset;
                    var size = entry.ExtSize;
                    for (int n = 0; n < 16; n++)
                    {
                        reader.BaseStream.Position = offset + n * EXT_SIZE;
                        data.AddRange(reader.ReadBytes(EXT_SIZE));
                        if (--size == 0) break;
                    }
                }
            }
            return new MemoryStream(data.ToArray());
        }

        public static void ExtractFile(this OdiFileEntry entry, BinaryReader reader, List<OdiFileEntry> entryList, string path, bool tranc)
        {
            var fileName = Path.Combine(path, entry.FileName);
            using (var fileMemory = entry.ExtractFile(reader, entryList))
                File.WriteAllBytes(fileName, fileMemory.ToArray());
            string ext = Path.GetExtension(entry.FileName).ToUpper();
            if (tranc && (ext == ".BRU" || ext == ".ORD"))
            {
                ushort size;
                using (var fileStream = File.Open(fileName, FileMode.Open, FileAccess.ReadWrite))
                using (var fileReader = new BinaryReader(fileStream))
                {
                    fileStream.Seek(10, SeekOrigin.Begin);
                    size = (ushort)(fileReader.ReadUInt16() + 16);
                    fileStream.SetLength(size);
                }
            }
        }

        public static void ExtractFiles(string fileName, bool tranc)
        {
            var path = Path.GetDirectoryName(fileName)!;
            var data = File.ReadAllBytes(fileName);
            using MemoryStream memory = new(data);
            using BinaryReader reader = new(memory);

            List<OdiFileEntry> entryList = reader.GetOdiFileEntries();
            var list = entryList.Where(d => d.User != 0xE5 && d.RecNo == 0);
            foreach (OdiFileEntry entry in list)
            {
                entry.ExtractFile(reader, entryList, path, tranc);
            }
        }
    }
}

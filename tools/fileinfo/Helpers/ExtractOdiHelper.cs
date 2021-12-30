using fileinfo.Models;

namespace fileinfo.Helpers
{
	public static class ExtractOdiHelper
	{
		private const int DIR_ENTRY = 128;
		private const int BASE = 0x5000;
		private const int EXTSIZEINBYTES = 0x800;
		private const int EXT_SIZE = 128;

		public static long ext_offset(int extent)
		{
			return (long)BASE + (long)extent * (long)EXTSIZEINBYTES;
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
			var records = entryList
				.Where(e => e.FileName == entry.FileName)
				.OrderBy(e => e.RecNo)
				.ToArray();
			List<byte[]> chunkList = new();
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
						chunkList.Add(reader.ReadBytes(EXT_SIZE));
						if (--size == 0) break;
					}
				}
			}
			var fileName = Path.Combine(path, entry.FileName);
			using (var fileStream = File.Create(fileName))
			{
				foreach (var chunk in chunkList)
				{
					fileStream.Write(chunk);
				}
				fileStream.Close();
			}
			if (tranc && Path.GetExtension(entry.FileName).ToUpper() == ".BRU")
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
			var path = Path.GetDirectoryName(fileName);
			var data = File.ReadAllBytes(fileName);
			using MemoryStream memory = new(data);
			using BinaryReader reader = new(memory);

			List<OdiFileEntry> entryList = new List<OdiFileEntry>();

			memory.Position = ext_offset(0);
			entryList.LoadFileInfo(reader);

			memory.Position = ext_offset(1);
			entryList.LoadFileInfo(reader);

			var list = entryList.Where(d => d.User != 0xE5 && d.RecNo == 0);
			foreach (OdiFileEntry entry in list)
			{
				entry.ExtractFile(reader, entryList, path, tranc);
			}
		}
	}
}

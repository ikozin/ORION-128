﻿using fileinfo.Controls;
using System.Text;

namespace fileinfo.Models
{
    public class BruFileDetail : FileDetail
    {
        public override bool ParseData(string fileName, BinaryReader reader, ICollection<TreeNodeExt>? list)
        {
            FileName = fileName;
            Name = Encoding.ASCII.GetString(reader.ReadBytes(8)).Trim();
            Address = reader.ReadUInt16();
            Size = reader.ReadUInt16();
            var attribute = reader.ReadByte();
            var reserv = reader.ReadBytes(3);
            Content = reader.ReadBytes(Size);
            return true;
        }
    }
}

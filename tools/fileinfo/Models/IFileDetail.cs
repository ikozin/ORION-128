﻿using fileinfo.Controls;

namespace fileinfo.Models
{
    public interface IFileDetail : IComparable<IFileDetail>
    {
        bool IsError { get; }
        string FileName { get; }
        string Name { get; }
        ushort Size { get; }
        ushort Address { get; }
        byte[] Hash { get; }
        byte[] Content { get; }
        string Message { get; }
        void LoadData(string fileName, ICollection<TreeNodeExt>? list);
        void LoadData(string fileName, BinaryReader reader, ICollection<TreeNodeExt>? list);
    }
}

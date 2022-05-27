﻿using fileinfo.Helpers;
using fileinfo.Models;

namespace fileinfo.Controls
{
    internal class ListViewItemExt : ListViewItem
    {
        public ListViewItemExt(IFileDetail detail) : base()
        {
            Detail = detail;
            Text = Path.GetFileName(Detail.FileName);
            ToolTipText = Detail.Message;

            SubItems.Add(Detail.Name);
            SubItems.Add(Detail.Size.ToHexWithNumber());
            SubItems.Add(Detail.Address.ToHex());
            SubItems.Add(Detail.Hash.ToHex());
            SubItems.Add(Detail.FileName);
        }
        public IFileDetail Detail { get; private set; }
    }
}
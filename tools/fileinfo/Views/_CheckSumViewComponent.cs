using fileinfo.Helpers;
using System;
using System.Text;

namespace fileinfo.Views
{
    public partial class _CheckSumViewComponent //: ViewComponent
    {

        private const int ChunkSize = 256;
        //public CheckSumViewComponent() : base()
        //{
        //    //InitializeComponent();
        //}

        //public CheckSumViewComponent(Func<byte, bool, char> encoding) : base(encoding)
        //{
        //    //InitializeComponent();
        //    ClearView();
        //    //_extension = "";
        //    //_filter = "All files|*.*";
        //}

        //protected override void ClearView()
        //{
        //    //fastColoredTextBoxView.Text = String.Empty;
        //    //fastColoredTextBoxView.Enabled = false;
        //}

        //protected override void LoadView()
        //{
        //    var text = new StringBuilder();

        //    int start = 0;
        //    while (start < _detail!.Content.Length)
        //    {
        //        var chunk = _detail!.Content.Skip(start).Take(ChunkSize);
        //        CheckSumToString(text, start, chunk.Count(), CalculateCheckSum(chunk));
        //        start += ChunkSize;
        //    }

        //    text.AppendLine();
        //    var sum = CalculateCheckSum(_detail!.Content);
        //    CheckSumToString(text, _detail!.Address, _detail!.Content.Length, sum);

        //    //fastColoredTextBoxView.Text = text.ToString();
        //    //fastColoredTextBoxView.Enabled = true;
        //}

        private static ushort CalculateCheckSum(IEnumerable<byte> data)
        {
            ushort totalSum = 0;
            ushort cyclicSum = 0;
            foreach (var b in data)
            {
                totalSum += b;
                cyclicSum += b;
                if ((cyclicSum & 0xFF) > 0) cyclicSum += 1;
                totalSum &= 0xFF;
                cyclicSum &= 0xFF;
            }
            return (ushort)((cyclicSum << 8) | totalSum);
        }

        private static void CheckSumToString(StringBuilder text, int address, int length, ushort sum)
        {
            text.Append(((ushort)address).ToHex());
            text.Append("-");
            text.Append(((ushort)(address + length - 1)).ToHex());
            text.Append(" ");
            text.AppendLine(sum.ToHex());
        }
    }
}

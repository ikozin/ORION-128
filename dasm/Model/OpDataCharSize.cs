namespace Dasm.Model
{
    public class OpDataCharSize : OpDataChar
    {
        public OpDataCharSize(string fmtBlank, int size) : base("DB", size, fmtBlank)
        {
        }
    }
}

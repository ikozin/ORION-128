using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Dasm.Model
{
    public class OpDataQWordChar : OpDataChar
    {
        public OpDataQWordChar(string fmtBlank) : base("DQ", 8, fmtBlank)
        {
        }
    }
}

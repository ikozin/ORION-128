using System;
using System.IO;

namespace Dasm.Model
{
    public abstract class OpData
    {
        public string Format { get; private set; }

        private string _formaTtingBlank;

        public OpData(string fmt, string fmtBlank)
        {
            Format = fmt;
            _formaTtingBlank = fmtBlank;
        }

        public abstract string GetString(Stream stream);

        public string ToString(Stream stream)
        {
            string value = GetString(stream);
            return String.Format("{0}{1}{2}", Format, _formaTtingBlank, value);
        }
    }
}

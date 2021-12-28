using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace fileinfo.Views
{
    internal class BasicViewComponent : TextViewComponent
    {
        private readonly Dictionary<byte, string> _vacabular = new Dictionary<byte, string>()
        {
            { 0x80, "CLS" },
            { 0x81, "FOR" },
            { 0x82, "NEXT" },
            { 0x83, "DATA" },
            { 0x84, "INPUT" },
            { 0x85, "DIM" },
            { 0x86, "READ" },
            { 0x87, "CUR" },
            { 0x88, "GOTO" },
            { 0x89, "RUN" },
            { 0x8A, "IF" },
            { 0x8B, "RESTORE" },
            { 0x8C, "GOSUB" },
            { 0x8D, "RETURN" },
            { 0x8E, "REM" },
            { 0x8F, "STOP" },
            { 0x90, "DPL" },
            { 0x91, "ON" },
            { 0x92, "PSET" },
            { 0x93, "LINE" },
            { 0x94, "POKE" },
            { 0x95, "PRINT" },
            { 0x96, "DEF" },
            { 0x97, "CONT" },
            { 0x98, "LIST" },
            { 0x99, "CLEAR" },
            { 0x9A, "LLIST" },
            { 0x9B, "LPRINT" },
            { 0x9C, "NEW" },
            { 0x9D, "EDIT" },
            { 0x9E, "COLOR" },
            { 0x9F, "BOX" },
            { 0xA0, "SCREEN" },
            { 0xA1, "PAINT" },
            { 0xA2, "SYSTEM" },
            { 0xA3, "SAVE" },
            { 0xA4, "LOAD" },
            { 0xA5, "FILES" },
            { 0xA6, "KILL" },
            { 0xA7, "TAB(" },
            { 0xA8, "TO" },
            { 0xA9, "SPC(" },
            { 0xAA, "FN" },
            { 0xAB, "THEN" },
            { 0xAC, "NOT" },
            { 0xAD, "STEP" },
            { 0xAE, "+" },
            { 0xAF, "-" },
            { 0xB0, "*" },
            { 0xB1, "/" },
            { 0xB2, "^" },
            { 0xB3, "AND" },
            { 0xB4, "OR" },
            { 0xB5, ">" },
            { 0xB6, "=" },
            { 0xB7, "<" },
            { 0xB8, "SGN" },
            { 0xB9, "INT" },
            { 0xBA, "ABS" },
            { 0xBB, "USR" },
            { 0xBC, "FRE" },
            { 0xBD, "INP" },
            { 0xBE, "POS" },
            { 0xBF, "SQR" },
            { 0xC0, "RND" },
            { 0xC1, "LOG" },
            { 0xC2, "EXP" },
            { 0xC3, "COS" },
            { 0xC4, "SIN" },
            { 0xC5, "TAN" },
            { 0xC6, "ATN" },
            { 0xC7, "PEEK" },
            { 0xC8, "LEN" },
            { 0xC9, "STR¤" },
            { 0xCA, "VAL" },
            { 0xCB, "ASC" },
            { 0xCC, "CHR¤" },
            { 0xCD, "LEFT¤" },
            { 0xCE, "RIGHT¤" },
            { 0xCF, "MID¤" },
            { 0xD0, "GET" },
            { 0xD1, "PUT" },
            { 0xD2, "SOUND" },
            { 0xD3, "DELETE" },
            { 0xD4, "AUTO" },
            { 0xD5, "RENUM" },
    };


    public BasicViewComponent(Func<byte, bool, char> encoding) : base(encoding)
        {
            _extension = "bas";
            _filter = "Basics files|*.bas|All files|*.*";
        }
        protected override void LoadView()
        {
            var line = new StringBuilder();
            var text = new StringBuilder();
            using MemoryStream stream = new(_detail!.Content);
            using BinaryReader reader = new(stream);
            try
            {
                while (true)
                {
                    var value = reader.Read();
                    if (value == -1) break;
                    if (value == 0)
                    {
                        line.Clear();
                        var offset = reader.ReadUInt16() - _detail!.Address - 1;
                        var rowNumber = reader.ReadUInt16();
                        var cmd = reader.ReadByte();
                        line.AppendFormat("{0} ", rowNumber);
                        if (_vacabular.ContainsKey(cmd))
                            line.AppendFormat("{0}", _vacabular[cmd]);
                        else
                            line.AppendFormat("{0}", _encoding.Invoke(cmd, false));
                        
                        while (offset > stream.Position)
                        {
                            cmd = reader.ReadByte();
                            if (_vacabular.ContainsKey(cmd))
                                line.AppendFormat("{0}", _vacabular[cmd]);
                            else
                                line.AppendFormat("{0}", _encoding.Invoke(cmd, false));
                        }
                        text.AppendLine(line.ToString());
                    }
                }
            }
            catch (Exception ex)
            {
            }

            fastColoredTextBoxView.Text = text.ToString();
            fastColoredTextBoxView.Enabled = true;
        }
    }
}
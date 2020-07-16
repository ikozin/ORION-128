using System.Collections.Generic;
using System.IO;

namespace Dasm.Model
{
    public class OpCodeArray
    {
        private static readonly List<OpCode> _list = new List<OpCode>();

        public OpCodeArray(Dictionary<string, string> constList)
        {
            _list.Clear();
            _list.Add(new OpCode("nop", constList));
            _list.Add(new OpCode("lxi  B, {0}", false, true, constList));
            _list.Add(new OpCode("stax B", constList));
            _list.Add(new OpCode("inx  B", constList));
            _list.Add(new OpCode("inr  B", constList));
            _list.Add(new OpCode("dcr  B", constList));
            _list.Add(new OpCode("mvi  B, {0}", true, false, constList));
            _list.Add(new OpCode("rlc", constList));
            _list.Add(null);
            _list.Add(new OpCode("dad  B", constList));
            _list.Add(new OpCode("ldax B", constList));
            _list.Add(new OpCode("dcx  B", constList));
            _list.Add(new OpCode("inr  C", constList));
            _list.Add(new OpCode("dcr  C", constList));
            _list.Add(new OpCode("mvi  C, {0}", true, false, constList));
            _list.Add(new OpCode("rrc", constList));

            _list.Add(null);
            _list.Add(new OpCode("lxi  D, {0}", false, true, constList));
            _list.Add(new OpCode("stax D", constList));
            _list.Add(new OpCode("inx  D", constList));
            _list.Add(new OpCode("inr  D", constList));
            _list.Add(new OpCode("dcr  D", constList));
            _list.Add(new OpCode("mvi  D, {0}", true, false, constList));
            _list.Add(new OpCode("ral", constList));
            _list.Add(null);
            _list.Add(new OpCode("dad  D", constList));
            _list.Add(new OpCode("ldax D", constList));
            _list.Add(new OpCode("dcx  D", constList));
            _list.Add(new OpCode("inr  E", constList));
            _list.Add(new OpCode("dcr  E", constList));
            _list.Add(new OpCode("mvi  E, {0}", true, false, constList));
            _list.Add(new OpCode("rar", constList));

            _list.Add(null);
            _list.Add(new OpCode("lxi  H, {0}", false, true, constList));
            _list.Add(new OpCode("shld {0}", false, true, constList));
            _list.Add(new OpCode("inx  H", constList));
            _list.Add(new OpCode("inr  H", constList));
            _list.Add(new OpCode("dcr  H", constList));
            _list.Add(new OpCode("mvi  H, {0}", true, false, constList));
            _list.Add(new OpCode("daa", constList));
            _list.Add(null);
            _list.Add(new OpCode("dad  H", constList));
            _list.Add(new OpCode("lhld {0}", false, true, constList));
            _list.Add(new OpCode("dcx  H", constList));
            _list.Add(new OpCode("inr  L", constList));
            _list.Add(new OpCode("dcr  L", constList));
            _list.Add(new OpCode("mvi  L, {0}", true, false, constList));
            _list.Add(new OpCode("cma", constList));

            _list.Add(null);
            _list.Add(new OpCode("lxi  SP, {0}", false, true, constList));
            _list.Add(new OpCode("sta  {0}", false, true, constList));
            _list.Add(new OpCode("inx  SP", constList));
            _list.Add(new OpCode("inr  {0}", false, true, constList));
            _list.Add(new OpCode("dcr  {0}", false, true, constList));
            _list.Add(new OpCode("mvi  M, {0}", true, false, constList));
            _list.Add(new OpCode("stc", constList));
            _list.Add(null);
            _list.Add(new OpCode("dad  SP", constList));
            _list.Add(new OpCode("lda  {0}", false, true, constList));
            _list.Add(new OpCode("dcx  SP", constList));
            _list.Add(new OpCode("inr  A", constList));
            _list.Add(new OpCode("dcr  A", constList));
            _list.Add(new OpCode("mvi  A, {0}", true, false, constList));
            _list.Add(new OpCode("cmc", constList));

            _list.Add(new OpCode("mov  B, B", constList));
            _list.Add(new OpCode("mov  B, C", constList));
            _list.Add(new OpCode("mov  B, D", constList));
            _list.Add(new OpCode("mov  B, E", constList));
            _list.Add(new OpCode("mov  B, H", constList));
            _list.Add(new OpCode("mov  B, L", constList));
            _list.Add(new OpCode("mov  B, M", constList));
            _list.Add(new OpCode("mov  B, A", constList));
            _list.Add(new OpCode("mov  C, B", constList));
            _list.Add(new OpCode("mov  C, C", constList));
            _list.Add(new OpCode("mov  C, D", constList));
            _list.Add(new OpCode("mov  C, E", constList));
            _list.Add(new OpCode("mov  C, H", constList));
            _list.Add(new OpCode("mov  C, L", constList));
            _list.Add(new OpCode("mov  C, M", constList));
            _list.Add(new OpCode("mov  C, A", constList));

            _list.Add(new OpCode("mov  D, B", constList));
            _list.Add(new OpCode("mov  D, C", constList));
            _list.Add(new OpCode("mov  D, D", constList));
            _list.Add(new OpCode("mov  D, E", constList));
            _list.Add(new OpCode("mov  D, H", constList));
            _list.Add(new OpCode("mov  D, L", constList));
            _list.Add(new OpCode("mov  D, M", constList));
            _list.Add(new OpCode("mov  D, A", constList));
            _list.Add(new OpCode("mov  E, B", constList));
            _list.Add(new OpCode("mov  E, C", constList));
            _list.Add(new OpCode("mov  E, D", constList));
            _list.Add(new OpCode("mov  E, E", constList));
            _list.Add(new OpCode("mov  E, H", constList));
            _list.Add(new OpCode("mov  E, L", constList));
            _list.Add(new OpCode("mov  E, M", constList));
            _list.Add(new OpCode("mov  E, A", constList));

            _list.Add(new OpCode("mov  H, B", constList));
            _list.Add(new OpCode("mov  H, C", constList));
            _list.Add(new OpCode("mov  H, D", constList));
            _list.Add(new OpCode("mov  H, E", constList));
            _list.Add(new OpCode("mov  H, H", constList));
            _list.Add(new OpCode("mov  H, L", constList));
            _list.Add(new OpCode("mov  H, M", constList));
            _list.Add(new OpCode("mov  H, A", constList));
            _list.Add(new OpCode("mov  L, B", constList));
            _list.Add(new OpCode("mov  L, C", constList));
            _list.Add(new OpCode("mov  L, D", constList));
            _list.Add(new OpCode("mov  L, E", constList));
            _list.Add(new OpCode("mov  L, H", constList));
            _list.Add(new OpCode("mov  L, L", constList));
            _list.Add(new OpCode("mov  L, M", constList));
            _list.Add(new OpCode("mov  L, A", constList));

            _list.Add(new OpCode("mov  M, B", constList));
            _list.Add(new OpCode("mov  M, C", constList));
            _list.Add(new OpCode("mov  M, D", constList));
            _list.Add(new OpCode("mov  M, E", constList));
            _list.Add(new OpCode("mov  M, H", constList));
            _list.Add(new OpCode("mov  M, L", constList));
            _list.Add(new OpCode("hlt", constList));
            _list.Add(new OpCode("mov  M, A", constList));
            _list.Add(new OpCode("mov  A, B", constList));
            _list.Add(new OpCode("mov  A, C", constList));
            _list.Add(new OpCode("mov  A, D", constList));
            _list.Add(new OpCode("mov  A, E", constList));
            _list.Add(new OpCode("mov  A, H", constList));
            _list.Add(new OpCode("mov  A, L", constList));
            _list.Add(new OpCode("mov  A, M", constList));
            _list.Add(new OpCode("mov  A, A", constList));

            _list.Add(new OpCode("add  B", constList));
            _list.Add(new OpCode("add  C", constList));
            _list.Add(new OpCode("add  D", constList));
            _list.Add(new OpCode("add  E", constList));
            _list.Add(new OpCode("add  H", constList));
            _list.Add(new OpCode("add  L", constList));
            _list.Add(new OpCode("add  M", constList));
            _list.Add(new OpCode("add  A", constList));
            _list.Add(new OpCode("adc  B", constList));
            _list.Add(new OpCode("adc  C", constList));
            _list.Add(new OpCode("adc  D", constList));
            _list.Add(new OpCode("adc  E", constList));
            _list.Add(new OpCode("adc  H", constList));
            _list.Add(new OpCode("adc  L", constList));
            _list.Add(new OpCode("adc  M", constList));
            _list.Add(new OpCode("adc  A", constList));

            _list.Add(new OpCode("sub  B", constList));
            _list.Add(new OpCode("sub  C", constList));
            _list.Add(new OpCode("sub  D", constList));
            _list.Add(new OpCode("sub  E", constList));
            _list.Add(new OpCode("sub  H", constList));
            _list.Add(new OpCode("sub  L", constList));
            _list.Add(new OpCode("sub  M", constList));
            _list.Add(new OpCode("sub  A", constList));
            _list.Add(new OpCode("sbb  B", constList));
            _list.Add(new OpCode("sbb  C", constList));
            _list.Add(new OpCode("sbb  D", constList));
            _list.Add(new OpCode("sbb  E", constList));
            _list.Add(new OpCode("sbb  H", constList));
            _list.Add(new OpCode("sbb  L", constList));
            _list.Add(new OpCode("sbb  M", constList));
            _list.Add(new OpCode("sbb  A", constList));

            _list.Add(new OpCode("ana  B", constList));
            _list.Add(new OpCode("ana  C", constList));
            _list.Add(new OpCode("ana  D", constList));
            _list.Add(new OpCode("ana  E", constList));
            _list.Add(new OpCode("ana  H", constList));
            _list.Add(new OpCode("ana  L", constList));
            _list.Add(new OpCode("ana  M", constList));
            _list.Add(new OpCode("ana  A", constList));
            _list.Add(new OpCode("xra  B", constList));
            _list.Add(new OpCode("xra  C", constList));
            _list.Add(new OpCode("xra  D", constList));
            _list.Add(new OpCode("xra  E", constList));
            _list.Add(new OpCode("xra  H", constList));
            _list.Add(new OpCode("xra  L", constList));
            _list.Add(new OpCode("xra  M", constList));
            _list.Add(new OpCode("xra  A", constList));

            _list.Add(new OpCode("ora  B", constList));
            _list.Add(new OpCode("ora  C", constList));
            _list.Add(new OpCode("ora  D", constList));
            _list.Add(new OpCode("ora  E", constList));
            _list.Add(new OpCode("ora  H", constList));
            _list.Add(new OpCode("ora  L", constList));
            _list.Add(new OpCode("ora  M", constList));
            _list.Add(new OpCode("ora  A", constList));
            _list.Add(new OpCode("cmp  B", constList));
            _list.Add(new OpCode("cmp  C", constList));
            _list.Add(new OpCode("cmp  D", constList));
            _list.Add(new OpCode("cmp  E", constList));
            _list.Add(new OpCode("cmp  H", constList));
            _list.Add(new OpCode("cmp  L", constList));
            _list.Add(new OpCode("cmp  M", constList));
            _list.Add(new OpCode("cmp  A", constList));

            _list.Add(new OpCode("rnz", constList));
            _list.Add(new OpCode("pop  B", constList));
            _list.Add(new OpCode("jnz  {0}", false, true, constList));
            _list.Add(new OpCode("jmp  {0}", false, true, constList));
            _list.Add(new OpCode("cnz  {0}", false, true, constList));
            _list.Add(new OpCode("push B", constList));
            _list.Add(new OpCode("adi  {0}", true, false, constList));
            _list.Add(new OpCode("rst  0", constList));
            _list.Add(new OpCode("rz", constList));
            _list.Add(new OpCode("ret", constList));
            _list.Add(new OpCode("jz   {0}", false, true, constList));
            _list.Add(null);
            _list.Add(new OpCode("cz   {0}", false, true, constList));
            _list.Add(new OpCode("call {0}", false, true, constList));
            _list.Add(new OpCode("aci  {0}", true, false, constList));
            _list.Add(new OpCode("rst  1", constList));

            _list.Add(new OpCode("rnc", constList));
            _list.Add(new OpCode("pop D", constList));
            _list.Add(new OpCode("jnc  {0}", false, true, constList));
            _list.Add(new OpCode("out  {0}", true, false, constList));
            _list.Add(new OpCode("cnc  {0}", false, true, constList));
            _list.Add(new OpCode("push D", constList));
            _list.Add(new OpCode("sui  {0}", true, false, constList));
            _list.Add(new OpCode("rst  2", constList));
            _list.Add(new OpCode("rc", constList));
            _list.Add(null);
            _list.Add(new OpCode("jc   {0}", false, true, constList));
            _list.Add(new OpCode("in   {0}", true, false, constList));
            _list.Add(new OpCode("cc   {0}", false, true, constList));
            _list.Add(null);
            _list.Add(new OpCode("sbi  {0}", true, false, constList));
            _list.Add(new OpCode("rst  3", constList));

            _list.Add(new OpCode("rpo", constList));
            _list.Add(new OpCode("pop  H", constList));
            _list.Add(new OpCode("jpo  {0}", false, true, constList));
            _list.Add(new OpCode("xthl", constList));
            _list.Add(new OpCode("cpo  {0}", false, true, constList));
            _list.Add(new OpCode("push H", constList));
            _list.Add(new OpCode("ani  {0}", true, false, constList));
            _list.Add(new OpCode("rst  4", constList));
            _list.Add(new OpCode("rpe", constList));
            _list.Add(new OpCode("pchl", constList));
            _list.Add(new OpCode("jpe  {0}", false, true, constList));
            _list.Add(new OpCode("xchg", constList));
            _list.Add(new OpCode("cpe  {0}", false, true, constList));
            _list.Add(null);
            _list.Add(new OpCode("xri {0}", true, false, constList));
            _list.Add(new OpCode("rst 5", constList));

            _list.Add(new OpCode("rp", constList));
            _list.Add(new OpCode("pop  psw", constList));
            _list.Add(new OpCode("jp   {0}", false, true, constList));
            _list.Add(new OpCode("di", constList));
            _list.Add(new OpCode("cp   {0}", false, true, constList));
            _list.Add(new OpCode("push PSW", constList));
            _list.Add(new OpCode("ori  {0}", true, false, constList));
            _list.Add(new OpCode("rst  6", constList));
            _list.Add(new OpCode("rm", constList));
            _list.Add(new OpCode("sphl", constList));
            _list.Add(new OpCode("jm   {0}", false, true, constList));
            _list.Add(new OpCode("ei", constList));
            _list.Add(new OpCode("cm   {0}", false, true, constList));
            _list.Add(null);
            _list.Add(new OpCode("cpi  {0}", true, false, constList));
            _list.Add(new OpCode("rst  7", constList));

        }

        public List<OpCode> List { get { return _list; } }

        public string Handle(byte code, Stream stream)
        {
            var item = _list[code];
            return item.ToString(stream);
        }
    }
}

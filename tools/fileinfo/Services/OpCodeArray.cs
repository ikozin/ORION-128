namespace fileinfo.Services
{
    internal class OpCodeArray
    {
        private static readonly List<OpCode?> _list = new List<OpCode?>();

        public OpCodeArray()
        {
            _list.Clear();
            _list.Add(new OpCode("nop"));
            _list.Add(new OpCode("lxi  B, {0}", false, true));
            _list.Add(new OpCode("stax B"));
            _list.Add(new OpCode("inx  B"));
            _list.Add(new OpCode("inr  B"));
            _list.Add(new OpCode("dcr  B"));
            _list.Add(new OpCode("mvi  B, {0}", true, false));
            _list.Add(new OpCode("rlc"));
            _list.Add(null);
            _list.Add(new OpCode("dad  B"));
            _list.Add(new OpCode("ldax B"));
            _list.Add(new OpCode("dcx  B"));
            _list.Add(new OpCode("inr  C"));
            _list.Add(new OpCode("dcr  C"));
            _list.Add(new OpCode("mvi  C, {0}", true, false));
            _list.Add(new OpCode("rrc"));

            _list.Add(null);
            _list.Add(new OpCode("lxi  D, {0}", false, true));
            _list.Add(new OpCode("stax D"));
            _list.Add(new OpCode("inx  D"));
            _list.Add(new OpCode("inr  D"));
            _list.Add(new OpCode("dcr  D"));
            _list.Add(new OpCode("mvi  D, {0}", true, false));
            _list.Add(new OpCode("ral"));
            _list.Add(null);
            _list.Add(new OpCode("dad  D"));
            _list.Add(new OpCode("ldax D"));
            _list.Add(new OpCode("dcx  D"));
            _list.Add(new OpCode("inr  E"));
            _list.Add(new OpCode("dcr  E"));
            _list.Add(new OpCode("mvi  E, {0}", true, false));
            _list.Add(new OpCode("rar"));

            _list.Add(null);
            _list.Add(new OpCode("lxi  H, {0}", false, true));
            _list.Add(new OpCode("shld {0}", false, true));
            _list.Add(new OpCode("inx  H"));
            _list.Add(new OpCode("inr  H"));
            _list.Add(new OpCode("dcr  H"));
            _list.Add(new OpCode("mvi  H, {0}", true, false));
            _list.Add(new OpCode("daa"));
            _list.Add(null);
            _list.Add(new OpCode("dad  H"));
            _list.Add(new OpCode("lhld {0}", false, true));
            _list.Add(new OpCode("dcx  H"));
            _list.Add(new OpCode("inr  L"));
            _list.Add(new OpCode("dcr  L"));
            _list.Add(new OpCode("mvi  L, {0}", true, false));
            _list.Add(new OpCode("cma"));

            _list.Add(null);
            _list.Add(new OpCode("lxi  SP, {0}", false, true));
            _list.Add(new OpCode("sta  {0}", false, true));
            _list.Add(new OpCode("inx  SP"));
            _list.Add(new OpCode("inr  {0}", false, true));
            _list.Add(new OpCode("dcr  {0}", false, true));
            _list.Add(new OpCode("mvi  M, {0}", true, false));
            _list.Add(new OpCode("stc"));
            _list.Add(null);
            _list.Add(new OpCode("dad  SP"));
            _list.Add(new OpCode("lda  {0}", false, true));
            _list.Add(new OpCode("dcx  SP"));
            _list.Add(new OpCode("inr  A"));
            _list.Add(new OpCode("dcr  A"));
            _list.Add(new OpCode("mvi  A, {0}", true, false));
            _list.Add(new OpCode("cmc"));

            _list.Add(new OpCode("mov  B, B"));
            _list.Add(new OpCode("mov  B, C"));
            _list.Add(new OpCode("mov  B, D"));
            _list.Add(new OpCode("mov  B, E"));
            _list.Add(new OpCode("mov  B, H"));
            _list.Add(new OpCode("mov  B, L"));
            _list.Add(new OpCode("mov  B, M"));
            _list.Add(new OpCode("mov  B, A"));
            _list.Add(new OpCode("mov  C, B"));
            _list.Add(new OpCode("mov  C, C"));
            _list.Add(new OpCode("mov  C, D"));
            _list.Add(new OpCode("mov  C, E"));
            _list.Add(new OpCode("mov  C, H"));
            _list.Add(new OpCode("mov  C, L"));
            _list.Add(new OpCode("mov  C, M"));
            _list.Add(new OpCode("mov  C, A"));

            _list.Add(new OpCode("mov  D, B"));
            _list.Add(new OpCode("mov  D, C"));
            _list.Add(new OpCode("mov  D, D"));
            _list.Add(new OpCode("mov  D, E"));
            _list.Add(new OpCode("mov  D, H"));
            _list.Add(new OpCode("mov  D, L"));
            _list.Add(new OpCode("mov  D, M"));
            _list.Add(new OpCode("mov  D, A"));
            _list.Add(new OpCode("mov  E, B"));
            _list.Add(new OpCode("mov  E, C"));
            _list.Add(new OpCode("mov  E, D"));
            _list.Add(new OpCode("mov  E, E"));
            _list.Add(new OpCode("mov  E, H"));
            _list.Add(new OpCode("mov  E, L"));
            _list.Add(new OpCode("mov  E, M"));
            _list.Add(new OpCode("mov  E, A"));

            _list.Add(new OpCode("mov  H, B"));
            _list.Add(new OpCode("mov  H, C"));
            _list.Add(new OpCode("mov  H, D"));
            _list.Add(new OpCode("mov  H, E"));
            _list.Add(new OpCode("mov  H, H"));
            _list.Add(new OpCode("mov  H, L"));
            _list.Add(new OpCode("mov  H, M"));
            _list.Add(new OpCode("mov  H, A"));
            _list.Add(new OpCode("mov  L, B"));
            _list.Add(new OpCode("mov  L, C"));
            _list.Add(new OpCode("mov  L, D"));
            _list.Add(new OpCode("mov  L, E"));
            _list.Add(new OpCode("mov  L, H"));
            _list.Add(new OpCode("mov  L, L"));
            _list.Add(new OpCode("mov  L, M"));
            _list.Add(new OpCode("mov  L, A"));

            _list.Add(new OpCode("mov  M, B"));
            _list.Add(new OpCode("mov  M, C"));
            _list.Add(new OpCode("mov  M, D"));
            _list.Add(new OpCode("mov  M, E"));
            _list.Add(new OpCode("mov  M, H"));
            _list.Add(new OpCode("mov  M, L"));
            _list.Add(new OpCode("hlt"));
            _list.Add(new OpCode("mov  M, A"));
            _list.Add(new OpCode("mov  A, B"));
            _list.Add(new OpCode("mov  A, C"));
            _list.Add(new OpCode("mov  A, D"));
            _list.Add(new OpCode("mov  A, E"));
            _list.Add(new OpCode("mov  A, H"));
            _list.Add(new OpCode("mov  A, L"));
            _list.Add(new OpCode("mov  A, M"));
            _list.Add(new OpCode("mov  A, A"));

            _list.Add(new OpCode("add  B"));
            _list.Add(new OpCode("add  C"));
            _list.Add(new OpCode("add  D"));
            _list.Add(new OpCode("add  E"));
            _list.Add(new OpCode("add  H"));
            _list.Add(new OpCode("add  L"));
            _list.Add(new OpCode("add  M"));
            _list.Add(new OpCode("add  A"));
            _list.Add(new OpCode("adc  B"));
            _list.Add(new OpCode("adc  C"));
            _list.Add(new OpCode("adc  D"));
            _list.Add(new OpCode("adc  E"));
            _list.Add(new OpCode("adc  H"));
            _list.Add(new OpCode("adc  L"));
            _list.Add(new OpCode("adc  M"));
            _list.Add(new OpCode("adc  A"));

            _list.Add(new OpCode("sub  B"));
            _list.Add(new OpCode("sub  C"));
            _list.Add(new OpCode("sub  D"));
            _list.Add(new OpCode("sub  E"));
            _list.Add(new OpCode("sub  H"));
            _list.Add(new OpCode("sub  L"));
            _list.Add(new OpCode("sub  M"));
            _list.Add(new OpCode("sub  A"));
            _list.Add(new OpCode("sbb  B"));
            _list.Add(new OpCode("sbb  C"));
            _list.Add(new OpCode("sbb  D"));
            _list.Add(new OpCode("sbb  E"));
            _list.Add(new OpCode("sbb  H"));
            _list.Add(new OpCode("sbb  L"));
            _list.Add(new OpCode("sbb  M"));
            _list.Add(new OpCode("sbb  A"));

            _list.Add(new OpCode("ana  B"));
            _list.Add(new OpCode("ana  C"));
            _list.Add(new OpCode("ana  D"));
            _list.Add(new OpCode("ana  E"));
            _list.Add(new OpCode("ana  H"));
            _list.Add(new OpCode("ana  L"));
            _list.Add(new OpCode("ana  M"));
            _list.Add(new OpCode("ana  A"));
            _list.Add(new OpCode("xra  B"));
            _list.Add(new OpCode("xra  C"));
            _list.Add(new OpCode("xra  D"));
            _list.Add(new OpCode("xra  E"));
            _list.Add(new OpCode("xra  H"));
            _list.Add(new OpCode("xra  L"));
            _list.Add(new OpCode("xra  M"));
            _list.Add(new OpCode("xra  A"));

            _list.Add(new OpCode("ora  B"));
            _list.Add(new OpCode("ora  C"));
            _list.Add(new OpCode("ora  D"));
            _list.Add(new OpCode("ora  E"));
            _list.Add(new OpCode("ora  H"));
            _list.Add(new OpCode("ora  L"));
            _list.Add(new OpCode("ora  M"));
            _list.Add(new OpCode("ora  A"));
            _list.Add(new OpCode("cmp  B"));
            _list.Add(new OpCode("cmp  C"));
            _list.Add(new OpCode("cmp  D"));
            _list.Add(new OpCode("cmp  E"));
            _list.Add(new OpCode("cmp  H"));
            _list.Add(new OpCode("cmp  L"));
            _list.Add(new OpCode("cmp  M"));
            _list.Add(new OpCode("cmp  A"));

            _list.Add(new OpCode("rnz"));
            _list.Add(new OpCode("pop  B"));
            _list.Add(new OpCode("jnz  {0}", false, true));
            _list.Add(new OpCode("jmp  {0}", false, true));
            _list.Add(new OpCode("cnz  {0}", false, true));
            _list.Add(new OpCode("push B"));
            _list.Add(new OpCode("adi  {0}", true, false));
            _list.Add(new OpCode("rst  0"));
            _list.Add(new OpCode("rz"));
            _list.Add(new OpCode("ret"));
            _list.Add(new OpCode("jz   {0}", false, true));
            _list.Add(null);
            _list.Add(new OpCode("cz   {0}", false, true));
            _list.Add(new OpCode("call {0}", false, true));
            _list.Add(new OpCode("aci  {0}", true, false));
            _list.Add(new OpCode("rst  1"));

            _list.Add(new OpCode("rnc"));
            _list.Add(new OpCode("pop D"));
            _list.Add(new OpCode("jnc  {0}", false, true));
            _list.Add(new OpCode("out  {0}", true, false));
            _list.Add(new OpCode("cnc  {0}", false, true));
            _list.Add(new OpCode("push D"));
            _list.Add(new OpCode("sui  {0}", true, false));
            _list.Add(new OpCode("rst  2"));
            _list.Add(new OpCode("rc"));
            _list.Add(null);
            _list.Add(new OpCode("jc   {0}", false, true));
            _list.Add(new OpCode("in   {0}", true, false));
            _list.Add(new OpCode("cc   {0}", false, true));
            _list.Add(null);
            _list.Add(new OpCode("sbi  {0}", true, false));
            _list.Add(new OpCode("rst  3"));

            _list.Add(new OpCode("rpo"));
            _list.Add(new OpCode("pop  H"));
            _list.Add(new OpCode("jpo  {0}", false, true));
            _list.Add(new OpCode("xthl"));
            _list.Add(new OpCode("cpo  {0}", false, true));
            _list.Add(new OpCode("push H"));
            _list.Add(new OpCode("ani  {0}", true, false));
            _list.Add(new OpCode("rst  4"));
            _list.Add(new OpCode("rpe"));
            _list.Add(new OpCode("pchl"));
            _list.Add(new OpCode("jpe  {0}", false, true));
            _list.Add(new OpCode("xchg"));
            _list.Add(new OpCode("cpe  {0}", false, true));
            _list.Add(null);
            _list.Add(new OpCode("xri {0}", true, false));
            _list.Add(new OpCode("rst 5"));

            _list.Add(new OpCode("rp"));
            _list.Add(new OpCode("pop  psw"));
            _list.Add(new OpCode("jp   {0}", false, true));
            _list.Add(new OpCode("di"));
            _list.Add(new OpCode("cp   {0}", false, true));
            _list.Add(new OpCode("push PSW"));
            _list.Add(new OpCode("ori  {0}", true, false));
            _list.Add(new OpCode("rst  6"));
            _list.Add(new OpCode("rm"));
            _list.Add(new OpCode("sphl"));
            _list.Add(new OpCode("jm   {0}", false, true));
            _list.Add(new OpCode("ei"));
            _list.Add(new OpCode("cm   {0}", false, true));
            _list.Add(null);
            _list.Add(new OpCode("cpi  {0}", true, false));
            _list.Add(new OpCode("rst  7"));

        }

        public List<OpCode?> List { get { return _list; } }

    }
}

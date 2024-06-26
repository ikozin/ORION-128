using intellhex;

namespace test;

[TestClass]
public class UnitTestLib
{
    [TestMethod]
    public void TestMethod_GetDump()
    {
        IntellHex value = new();

        byte[] data = { 0x55, 0xAA, 0x55, 0xAA };
        value.Add(0,  data);
        var buffer = value.GetDump(0, 4);
        for (int i = 0; i < data.Length; i++)
        {
            Assert.IsFalse(data[i] != buffer[i]);
        } 
    } 


    [TestMethod]
    public void TestMethod_Add()
    {
        IntellHex value = new();

        value.Add(":100000003FC02DC205C257C056C055C054C053C0D2");
        value.Add(":1000100052C0B4C150C04FC04EC04DC04CC04BC008");
        value.Add(":100020004AC049C048C0000000003600330030001C");
        value.Add(":1000300000000000370034003100000000003800EC");
        value.Add(":100040003500320004040404040404040202020221");
        value.Add(":10005000020203030303030301020408102040808B");
        value.Add(":100060000102040810200102040810200000000012");
        value.Add(":100070000000000000030406000000000000000073");
        value.Add(":1000800011241FBECFE5D4E0DEBFCDBF10E0A0E657");
        value.Add(":10009000B0E0E8E0F7E002C005900D92A63EB1079F");
        value.Add(":1000A000D9F721E0A6EEB0E001C01D92A930B20759");
        value.Add(":1000B000E1F7FCD127C3A4CF843041F0863049F06A");
        value.Add(":1000C000833051F48FB58F778FBD08958FB58F7DB5");
        value.Add(":1000D000FBCF85B58F7D85BD08951F93CF93DF93AB");
        value.Add(":1000E000282F30E0F901E459FF4F8491F901E85AD3");
        value.Add(":1000F000FF4FD491F901EC5BFF4FC491CC23A1F0E9");
        value.Add(":10010000162F8111D9DFEC2FF0E0EE0FFF1FE65C18");
        value.Add(":10011000FF4FA591B4918FB7F894EC91111108C0DD");
        value.Add(":10012000D095DE23DC938FBFDF91CF911F9108958F");
        value.Add(":10013000DE2BF8CFCF93DF9390E0FC01E85AFF4F1E");
        value.Add(":1001400024918C5B9F4FFC0184918823D1F090E037");
        value.Add(":10015000880F991FFC01E05DFF4FA591B491FC0150");
        value.Add(":10016000E65CFF4FC591D491623071F49FB7F8946B");
        value.Add(":100170003C91822F809583238C93E8812E2B2883BA");
        value.Add(":100180009FBFDF91CF9108958FB7F894EC912E2BFC");
        value.Add(":100190002C938FBFF6CF0895CF92DF92EF92FF920C");
        value.Add(":1001A0000F931F93CF93DF932091F60030E0F90176");
        value.Add(":1001B000E459FF4F8491F901E85AFF4FD491F901B6");
        value.Add(":1001C000EC5BFF4FC491CC2371F0811175DFEC2FF4");
        value.Add(":1001D000F0E0EE0FFF1FEA5DFF4FA591B491EC91A7");
        value.Add(":1001E000ED2391E009F490E08FB7F8944091F2008C");
        value.Add(":1001F0005091F3006091F4007091F5008FBF009171");
        value.Add(":10020000E9001091EA002091EB003091EC006A01C6");
        value.Add(":100210007B01C01AD10AE20AF30A970186010B3F5B");
        value.Add(":1002200011052105310510F01092E8004093E90016");
        value.Add(":100230005093EA006093EB007093EC008091E8002B");
        value.Add(":100240008F5F8093E8008A3038F4823070F5813017");
        value.Add(":10025000F9F01092E80020C08A30C1F18B30C9F764");
        value.Add(":100260008091E6008D3FA8F7809107018F5F803174");
        value.Add(":1002700008F080E090910801981759F3E82FF0E01A");
        value.Add(":100280009091E700E950FF4F908380930701E1CF01");
        value.Add(":100290001092E7001092E600DF91CF911F910F912D");
        value.Add(":1002A000FF90EF90DF90CF9008958091E600890F46");
        value.Add(":1002B0008093E6002091E70030E03595279580E0B7");
        value.Add(":1002C000911180E8282B2093E700E6CF8091E6008B");
        value.Add(":1002D0008170891719F08093E600DECF8DEFFBCF98");
        value.Add(":1002E000CF93C82F61E08FE0F8DE61E081E1F5DEB9");
        value.Add(":1002F0006C2F80E1F2DE60E081E1EFDE60E08FE014");
        value.Add(":10030000CF91EBCECF93DF93C82F682F617084E03D");
        value.Add(":10031000E4DED0E0BE0175956795617085E0DDDEB5");
        value.Add(":10032000BE017595679575956795617086E0D5DE18");
        value.Add(":10033000BE0123E0759567952A95E1F7617087E026");
        value.Add(":10034000CCDEBE0134E0759567953A95E1F76170B2");
        value.Add(":1003500088E0C3DEBE0145E0759567954A95E1F7F3");
        value.Add(":10036000617089E0BADE56E0D595C7955A95E1F7F8");
        value.Add(":100370006C2F61708AE0DF91CF91AFCE1F920F9208");
        value.Add(":100380000FB60F9211242F933F938F939F93AF93A8");
        value.Add(":10039000BF938091F2009091F300A091F400B0918E");
        value.Add(":1003A000F5003091F10023E0230F2D3758F5019629");
        value.Add(":1003B000A11DB11D2093F1008093F2009093F300F2");
        value.Add(":1003C000A093F400B093F5008091ED009091EE00C1");
        value.Add(":1003D000A091EF00B091F0000196A11DB11D809396");
        value.Add(":1003E000ED009093EE00A093EF00B093F000BF916A");
        value.Add(":1003F000AF919F918F913F912F910F900FBE0F90D2");
        value.Add(":100400001F90189526E8230F0296A11DB11DD2CF8B");
        value.Add(":100410001F920F920FB60F9211242F933F934F9379");
        value.Add(":100420005F936F937F938F939F93AF93BF93EF935C");
        value.Add(":10043000FF93E0916200F09163000995FF91EF91C5");
        value.Add(":10044000BF91AF919F918F917F916F915F914F91EC");
        value.Add(":100450003F912F910F900FBE0F901F9018951F92F4");
        value.Add(":100460000F920FB60F9211242F933F934F935F93E8");
        value.Add(":100470006F937F938F939F93AF93BF93EF93FF936C");
        value.Add(":10048000E0916000F09161000995FF91EF91BF91BB");
        value.Add(":10049000AF919F918F917F916F915F914F913F911C");
        value.Add(":1004A0002F910F900FBE0F901F901895789483B7DF");
        value.Add(":1004B000826083BF83B7816083BF89B7816089BF52");
        value.Add(":1004C0001EBC8EB582608EBD8EB581608EBD8FB52F");
        value.Add(":1004D00081608FBD85B5846085BD85B5806485BD2F");
        value.Add(":1004E000329A319A309A379A1AB861E084E022DE63");
        value.Add(":1004F00061E085E01FDE61E086E01CDE61E087E010");
        value.Add(":1005000019DE61E088E016DE61E089E013DE61E07B");
        value.Add(":100510008AE010DE61E08EE00DDE61E08FE00ADE51");
        value.Add(":1005200061E080E107DE61E081E104DE82E080934A");
        value.Add(":10053000F60062E083E0FEDD62E082E0FBDD109227");
        value.Add(":100540000701109208018CEC90E090936300809377");
        value.Add(":10055000620085B7837F886085BF8BB780688BBF5B");
        value.Add(":1005600080E0D0DE60E08EE0B8DD60E08FE0B5DDF9");
        value.Add(":1005700060E080E1B2DD60E081E1AFDD61E08FE06D");
        value.Add(":10058000ACDD61E08EE0A9DD60E08EE0A6DD60E03C");
        value.Add(":100590008FE0A3DD80E0B6DE80E0A2DE00E010E0C8");
        value.Add(":1005A000C1E08091070190910801891B87FD805F60");
        value.Add(":1005B000882309F463C08091070190910801891B89");
        value.Add(":1005C00087FD805F882391F0E09108018091070109");
        value.Add(":1005D000E81761F0EF5FE03108F0E0E0E093080138");
        value.Add(":1005E000F0E0E950FF4FE081E11106C0EFEFF0E0ED");
        value.Add(":1005F000EB59FF4F80814EC0E63609F445C0F8F450");
        value.Add(":10060000E93409F471C060F4ED3009F466C0E134F6");
        value.Add(":1006100071F781E777DE8091640062DE83E73AC09C");
        value.Add(":10062000E23509F468C0E83509F450C0EC34F9F655");
        value.Add(":1006300081E768DE8091640053DE81E52BC0E537F9");
        value.Add(":10064000B9F168F4E23769F1E437C9F1EB3679F6CC");
        value.Add(":1006500080E058DE8091640043DE84E31BC0E03E0E");
        value.Add(":1006600069F0E03F49F0E63711F680E04BDE80911B");
        value.Add(":10067000640036DE80E30EC010926400011511059F");
        value.Add(":1006800009F48FCFBDDC8DCF80E03CDE809164002B");
        value.Add(":1006900027DE80E437DE8091640022DEC0936400B0");
        value.Add(":1006A000EDCF80E02FDE809164001ADE84E4F2CF8B");
        value.Add(":1006B00080E028DE8091640013DE83E4EBCF80E0ED");
        value.Add(":1006C00021DE809164000CDE82E4E4CF80E01ADE5B");
        value.Add(":1006D0008091640005DE81E3DDCF80E013DE809150");
        value.Add(":1006E0006400FEDD81E7D6CF81E70CDE80916400F7");
        value.Add(":1006F000F7DD82E7CFCF81E705DE80916400F0DD92");
        value.Add(":0807000080E5C8CFF894FFCF9B");
        value.Add(":10070800CB00CB00017F7F7F7F7F7F7F7F7F7F7FD5");
        value.Add(":100718007F7F7F7F7F7F7F007F7F20307F7F7F018C");
        value.Add(":10072800111021317F7F0302122233327F7F700440");
        value.Add(":10073800132423347F7F7374641454447F7F7F723F");
        value.Add(":10074800635343427F7F7F62525140417F7F7F7F67");
        value.Add(":10075800617F507F7F7F7F7F7F7F7F7F7F7F71601B");
        value.Add(":100768007F7F7F7F7F7F7F7F7F7F7F407F7F7F7FD0");
        value.Add(":10077800347F7F7F7F7F7F7F7F7F7F7F7F7F7F7FCC");
        value.Add(":060788007F7F7F7F7F00F0");
        value.Add(":101C000012C02BC02AC029C028C027C026C025C0AA");
        value.Add(":101C100024C023C022C021C020C01FC01EC01DC0C0");
        value.Add(":101C20001CC01BC01AC011241FBECFE5D4E0DEBF0C");
        value.Add(":101C3000CDBF10E0A0E6B0E0E8EEFFE102C0059005");
        value.Add(":101C40000D92A236B107D9F711E0A2E6B0E001C0CB");
        value.Add(":101C50001D92AA36B107E1F74FC0D2CFEF92FF92A3");
        value.Add(":101C60000F931F93EE24FF24870113C00894E11CF7");
        value.Add(":101C7000F11C011D111D81E0E81682E1F8068AE7DA");
        value.Add(":101C8000080780E0180728F0E0916200F0916300F7");
        value.Add(":101C900009955F9BEBCF8CB1992787FD90951F919C");
        value.Add(":101CA0000F91FF90EF9008955D9BFECF8CB9089542");
        value.Add(":101CB000D5DF803221F484E1F7DF80E1F5DF08959C");
        value.Add(":101CC0001F93182FCBDF803231F484E1EDDF812FB9");
        value.Add(":101CD000EBDF80E1E9DF1F9108951F93CF93DF933E");
        value.Add(":101CE000182FC0E0D0E002C0B9DF2196C117E0F3A1");
        value.Add(":101CF000DF91CF911F910895CFE5D4E0DEBFCDBF36");
        value.Add(":101D0000000010BC83E389B988E18AB986E880BD08");
        value.Add(":101D1000BD9A1092680130E2E0E0F0E02FE088B375");
        value.Add(":101D2000832788BBCF010197F1F7215027FFF7CF19");
        value.Add(":101D300020E12093680192DF803381F1813399F4AF");
        value.Add(":101D40008DDF8032C1F784E1AFDF81E4ADDF86E56E");
        value.Add(":101D5000ABDF82E5A9DF80E2A7DF89E4A5DF83E5C9");
        value.Add(":101D6000A3DF80E5C7C0803429F478DF8638B0F07F");
        value.Add(":101D700075DF14C0813471F471DF803811F482E0B2");
        value.Add(":101D80001DC1813811F481E019C1823809F015C1F3");
        value.Add(":101D900082E114C1823421F484E19FDF89DFCBCF5B");
        value.Add(":101DA000853411F485E0F9CF8035C1F38135B1F385");
        value.Add(":101DB0008235A1F3853539F451DF809364004EDF1D");
        value.Add(":101DC00080936500EBCF863519F484E086DFF5C09B");
        value.Add(":101DD000843609F093C042DF809367013FDF809330");
        value.Add(":101DE0006601809169018E7F8093690137DF8534B8");
        value.Add(":101DF00029F480916901816080936901C0E0D0E09D");
        value.Add(":101E000006E610E005C02ADFF80181938F012196D4");
        value.Add(":101E10008091660190916701C817D907A0F31EDF72");
        value.Add(":101E2000803209F088CF8091690180FF1FC020E0D7");
        value.Add(":101E300030E0E6E6F0E012C0A0916400B0916500E9");
        value.Add(":101E40008191082EC5D08091640090916500019623");
        value.Add(":101E500090936500809364002F5F3F4F80916601EF");
        value.Add(":101E6000909167012817390738F343C0F894E19936");
        value.Add(":101E7000FECF1127E0916400F0916500EE0FFF1F87");
        value.Add(":101E8000C6E6D0E0809166019091670180FF01C0B5");
        value.Add(":101E90000196103051F422D003E000935700E895EA");
        value.Add(":101EA0001DD001E100935700E8950990199016D0D4");
        value.Add(":101EB00001E000935700E8951395103258F0112770");
        value.Add(":101EC0000DD005E000935700E89508D001E100939C");
        value.Add(":101ED0005700E8953296029739F0DBCF0091570012");
        value.Add(":101EE00001700130D9F30895103011F00296E7CF58");
        value.Add(":101EF000112484E1D9DE80E1D7DE1DCF843709F0DB");
        value.Add(":101F00004BC0ACDE80936701A9DE80936601A6DE3C");
        value.Add(":101F100090916901853421F49160909369010DC01D");
        value.Add(":101F20009E7F909369018091640090916500880F75");
        value.Add(":101F3000991F909365008093640090DE803209F0D1");
        value.Add(":101F4000FACE84E1B1DEC0E0D0E01EC0809169012C");
        value.Add(":101F500080FF07C0A0916400B091650031D0802D52");
        value.Add(":101F600008C081FD07C0E0916400F0916500E49134");
        value.Add(":101F70008E2F9ADE80916400909165000196909377");
        value.Add(":101F800065008093640021968091660190916701BD");
        value.Add(":101F9000C817D907D8F2AFCF853761F45FDE80323A");
        value.Add(":101FA00009F0C9CE84E180DE8EE17EDE83E97CDE4D");
        value.Add(":101FB00087E0A0CF863709F0BECE80E081DEBBCEC1");
        value.Add(":101FC000E199FECFBFBBAEBBE09A11960DB208956A");
        value.Add(":101FD000E199FECFBFBBAEBB0DBA11960FB6F89418");
        value.Add(":081FE000E29AE19A0FBE089598");
        value.Add(":021FE800800077");
        value.Add(":0400000300001C00DD");

        string text = value.GetText();

        value.Clear();
        
        value.Add(text);

    }
}
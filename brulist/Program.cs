using System;
using System.IO;

namespace brulist
{
    class Program
    {
        static void Main(string[] args)
        {
            if (args.Length == 0) return;
            try
            {
                Console.Write(String.Format("{0,-16:S}", "FileName"));
                Console.Write('|');
                Console.Write(String.Format("{0,-8:S}", "FileSize"));
                Console.Write('|');
                Console.Write(String.Format("{0,-8:S}", "Name"));
                Console.Write('|');
                Console.Write(String.Format("{0,-4:S}", "Addr"));
                Console.Write('|');
                Console.Write(String.Format("{0,-4:S}", "Size"));
                Console.Write('|');
                Console.Write(String.Format("{0,-4:S}", "Flag"));
                Console.Write('|');
                Console.Write(String.Format("{0,6:S}", "      "));
                Console.Write('|');
                Console.WriteLine();


                var list = Directory.GetFiles(args[0], "*.bru", SearchOption.AllDirectories);
                foreach (var fileName in list)
                { 
                    PrintFileInfo(fileName);
//                    break;
                }
            }
            catch (Exception ex)
            {
                Console.WriteLine(ex.ToString());
            }
            Console.ReadLine();
        }

        static void PrintFileInfo(string fileName)
        {
            using (FileStream stream = File.OpenRead(fileName))
            using (BinaryReader reader = new BinaryReader(stream))
            {
                byte[] name = reader.ReadBytes(8);
                uint StartPos = reader.ReadUInt16();
                uint Length = reader.ReadUInt16();
                byte flag = reader.ReadByte();
                byte empty1 = reader.ReadByte();
                byte empty2 = reader.ReadByte();
                byte empty3 = reader.ReadByte();

                Console.Write(String.Format("{0,-16:S}|{1,-8:X4}|", Path.GetFileName(fileName), stream.Length));

                foreach (var b in name)
                    Console.Write((char)b);
                Console.Write("|{0,-4:X4}|{1,-4:X4}|{2,4:X2}|", StartPos, Length, flag);
                Console.Write("{0:X2}{1:X2}{2:X2}|", empty1, empty2, empty3);
                Console.Write(Path.GetDirectoryName(fileName));
                Console.WriteLine();
            }
        }
    }
}

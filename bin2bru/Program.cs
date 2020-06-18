using bin2bru.Service;
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace bin2bru
{
    class Program
    {
        static void Main(string[] args)
        {
            if (args.Length == 0)
            {
                ShowHelp();
                return;
            }
            string path2bin = args[0];
            string path2bru = Path.ChangeExtension(path2bin, "bru");
            ushort org = 0x0000;
            string name = String.Empty;
            for (int i = 1; i < args.Length; i++)
            {
                string arg = args[i];
                if (arg.ToLower().StartsWith("n:"))
                {
                    name = arg.Substring(2);
                    name = String.Format("{0,-8:S}", name);
                    name = name.Substring(0, 8);
                }
                if (arg.ToLower().StartsWith("s:"))
                {
                    org = arg.Substring(2).ParseHex();
                }
            }
            if (String.IsNullOrEmpty(name))
            {
                ShowHelp();
                return;
            }

            ushort size = 0;
            byte[] data;
            using (var reader = File.OpenRead(path2bin))
            {
                size = (ushort)reader.Length;
                data = new byte[size];
                reader.Read(data, 0, data.Length);
            }
            using (var stream = File.Create(path2bru))
            using (BinaryWriter writer = new BinaryWriter(stream))
            {
                if (size % 0xFF != 0)
                {
                    size = (ushort)((size & 0xFFF0) + 0x10);
                }
                var text = Encoding.ASCII.GetBytes(name);
                writer.Write(text, 0, text.Length);
                writer.Write(org);
                writer.Write(size);
                writer.Write((byte)0x80);

                writer.Write((byte)0);
                writer.Write((byte)0);
                writer.Write((byte)0);

                writer.Write(data);

                for (int i = data.Length; i < size; i++)
                    writer.Write((byte)0);
            }
        }
        static void ShowHelp()
        {
            Console.WriteLine("bin2bru <path> n:<name> [s:<start>] ");
            Console.WriteLine("<path> bin input file name");
            Console.WriteLine("<name> name");
            Console.WriteLine("<start> load address hex format optional");
            Console.WriteLine(@"program.bin n:DEMO s:0000H");
            Console.ReadLine();
            return;
        }

    }
}

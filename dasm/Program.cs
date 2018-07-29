using Dasm.Model;
using Dasm.Service;
using System;
using System.Collections.Generic;
using System.Globalization;
using System.IO;

namespace Dasm
{
    class Program
    {
        static void Main(string[] args)
        {
            uint width = 32;
            ushort org = 0x0000;

            string text;

            string includePath = null;
            string fileName = null;

            Dictionary<string, string> comments = null;
            Dictionary<string, string> labels = null;
            Dictionary<string, string> datas = null;
            for (int i = 1; i < args.Length; i++)
            {
                string arg = args[i];
                if (arg.ToLower().StartsWith("c:"))
                {
                    string path = arg.Substring(2);
                    comments = ConfigLoader.LoadDictionary(path);
                }
                if (arg.ToLower().StartsWith("l:"))
                {
                    string path = arg.Substring(2);
                    labels = ConfigLoader.LoadDictionary(path);
                }
                if (arg.ToLower().StartsWith("d:"))
                {
                    string path = arg.Substring(2);
                    datas = ConfigLoader.LoadDictionary(path, "D");
                }
                if (arg.ToLower().StartsWith("o:"))
                {
                    fileName = arg.Substring(2);
                }
                if (arg.ToLower().StartsWith("i:"))
                {
                    includePath = arg.Substring(2);
                }
                if (arg.ToLower().StartsWith("s:"))
                {
                    org = arg.Substring(2).ParseHex();
                }
            }
            try
            {
                if (comments == null) throw new ArgumentNullException();
                if (labels == null) throw new ArgumentNullException();
                if (datas == null) throw new ArgumentNullException();
                if (fileName == null) throw new ArgumentNullException();
            }
            catch (Exception)
            {
                Console.WriteLine("dasm <path> l:<label> c:<comment> d:<data> [i:<include>] [s:<start>] o:<file>");
                Console.WriteLine("<path> input file name");
                Console.WriteLine("<label> label file name");
                Console.WriteLine("<comment> comment file name");
                Console.WriteLine("<data> data file name");
                Console.WriteLine("<start> ORG instraction hex format optional");
                Console.WriteLine("<include> include file name optional");
                Console.WriteLine("<file> out file name");
                Console.ReadLine();
                return;
            }

            OpCodeArray codeArray = new OpCodeArray(labels);
            OpDataArray dataArray = new OpDataArray();

            using (var stream = File.OpenRead(args[0]))
            using (var writer = File.CreateText(fileName))
            {
                if (!String.IsNullOrEmpty(includePath))
                    writer.WriteLine(File.ReadAllText(includePath));

                writer.WriteLine(String.Format("ORG {0}", org.ToHex()));
                writer.WriteLine();

                while (true)
                {
                    try
                    {
                        ushort current = (ushort)(org + stream.Position);
                        string addr = current.ToHex();

                        if (datas.ContainsKey(addr))
                        {
                            text = dataArray.Get(datas[addr]).ToString(stream);
                        }
                        else
                        {
                            if (stream.Position == stream.Length) break;
                            byte data = (byte)stream.ReadByte();
                            text = codeArray.Handle((byte)data, stream);
                        }

                        while (text.Length < width) text += ' ';
                        string note = comments.ContainsKey(addr) ? comments[addr] : "";
                        if (labels.ContainsKey(addr))
                            writer.WriteLine(String.Format("{0}:", labels[addr]));
                        writer.WriteLine(String.Format("    {0};{1} {2}", text, addr, note));

                        //if (data == 0xC3 || data == 0xC9)
                        //    writer.WriteLine();
                    }
                    catch (Exception)
                    {
                        Console.WriteLine("ERROR");
                        break;
                    }
                }
            }
            //Console.ReadLine();
        }
    }
}

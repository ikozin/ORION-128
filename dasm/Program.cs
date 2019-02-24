using Dasm.Model;
using Dasm.Service;
using System;
using System.Collections.Generic;
using System.IO;

namespace Dasm
{
    class Program
    {
        static void Main(string[] args)
        {
            ushort org = 0x0000;

            string text;
            #region Разбор параметров командной строки
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
                    datas = ConfigLoader.LoadDictionary(path);
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
            #endregion

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
                            text = codeArray.Handle(data, stream);
                        }

                        text = String.Format("{0, -32}", text); // Форматируем строку
                        string note = comments.ContainsKey(addr) ? comments[addr] : "";
                        if (labels.ContainsKey(addr))
                        {
                            var label = labels[addr];
                            if (label.StartsWith(";"))
                            {
                                label = label.Substring(1);
                                writer.WriteLine();
                            }
                            writer.WriteLine(String.Format("{0}:", label));
                        }
                        if (note.StartsWith(";"))
                        {
                            foreach (var commentLine in note.Split(new[] { ';' }, StringSplitOptions.RemoveEmptyEntries))
                                writer.WriteLine(String.Format(";{0}", commentLine));
                            writer.WriteLine(String.Format("    {0};{1}", text, addr));
                        }
                        else
                            writer.WriteLine(String.Format("    {0};{1} {2}", text, addr, note));
                    }
                    catch (Exception)
                    {
                        Console.WriteLine("ERROR");
                        break;
                    }
                }
            }
#if DEBUG            
            Console.ReadLine();
#endif
        }
    }
}

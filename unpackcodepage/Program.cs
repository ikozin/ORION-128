﻿using System;
using System.Globalization;
using System.IO;

namespace UnpackCodepage
{
    class Program
    {
        static void Main(string[] args)
        {
            if (args.Length != 2)
            {
                Console.WriteLine(@"UnpackCodepage file start
  file  - путь к образу ROM
  start - начало codepage, указывать в адресном пространстве ROM, т.е. начиная с 0F800H, для M1 = 0FE48H, M2 и M31 = 0FE4AH
");
                return;
            }
            try
            {
                byte[] symbolData = new byte[8] { 0, 0, 0, 0, 0, 0, 0, 0 };
                using (FileStream reader = File.OpenRead(args[0]))
                {
                    reader.Position = ParseHex(args[1]) - 0xF800;
                    while (reader.Position < reader.Length)
                    {
                        // Распаковываем очередонй символ
                        //symbolData[0] = 0;
                        int index = 7;
                        int pos = 1;
                        while (index > 0)
                        {
                            byte data = (byte)reader.ReadByte();
                            int count = (data >> 5); // декодируем кол-во повтора шаблона, считаем с 0, т.е. 0 = 1 раз, значение неможет быть более 6
                            data &= 0x1F;
                            do
                            {
                                symbolData[pos++] = data;
                                index--;
                                count--;
                            }
                            while (count >= 0);
                        }
                        // Отображаем распакованный символ
                        for (int i = 0; i < symbolData.Length; i++)
                        {
                            for (int bitPos = 0x80; bitPos > 0; bitPos >>= 1)
                            {
                                Console.Write("{0}", (symbolData[i] & bitPos) > 0 ? "X" : " ");
                            }
                            Console.WriteLine();
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                Console.WriteLine(ex.Message);
            }
            Console.ReadLine();
        }

        static ushort ParseHex(string value)
        {
            value = value.Trim();
            while (value[0] == '0') value = value.Substring(1);
            value = value.Substring(0, value.Length - 1);
            return ushort.Parse(value, NumberStyles.HexNumber);
        }
    }
}

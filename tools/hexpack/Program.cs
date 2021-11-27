namespace HexPack
{
    class Program
    {
        static void Main(string[] args)
        {
            try
            {
                if (args.Length != 2)
                {
                    DisplayInfo();
                    return;
                }
                var fileName = args[0].Trim('\"');
                using (var file = File.OpenText(fileName))
                {
                    fileName = args[1].Trim('\"');
                    using (var target = File.OpenWrite(fileName))
                    {
                        while (true)
                        {
                            var line = file.ReadLine()?.Trim();
                            if (string.IsNullOrEmpty(line))
                                break;
                            Console.WriteLine(line);
                            var addres = line.Substring(0, 4);
                            int value = 0;
                            if (!int.TryParse(addres, System.Globalization.NumberStyles.HexNumber, null, out value))
                            {
                                Console.WriteLine("Address Error");
                                break;
                            }
                            line = line.Remove(0, 5).Trim();
                            for (int i = 0; i < 16; i++)
                            {
                                var item = line.Substring(0, 2);
                                if (!int.TryParse(item, System.Globalization.NumberStyles.HexNumber, null, out value))
                                {
                                    throw new ApplicationException(String.Format("Error: {0}", item));
                                }
                                line = line.Remove(0, 2).Trim();
                                target.WriteByte((byte)value);
                            }
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                Console.WriteLine(ex.ToString());
            }
        }

        private static void DisplayInfo()
        {
            Console.WriteLine(
@"hexpack <filein> <fileout>
<filein>    - путь к текстовому файлу c HEX кодами
<fileout>   - путь к транслированому файлу");
        }
    }
}

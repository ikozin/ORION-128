using System.Globalization;
using System.Text;

namespace intellhex;

public class IntellHex
{
    private readonly Dictionary<int, byte[]> list = [];

    public IntellHex()
    {
    }

    public void Add(int address, byte[] data)
    {
        list.Add(address, data);
    }
    
    public void Add(string data)
    {
        string item;
        string[] lines = data.Trim().Split(Environment.NewLine, StringSplitOptions.RemoveEmptyEntries);
        foreach(var line in lines)
        {
            int sum = 0;
            if (!line.StartsWith(':'))
            {
                throw new ArgumentException(string.Format("Error string: start: {0}", line));
            }
            item = line.Substring(1, 2);
            if (!int.TryParse(item, NumberStyles.HexNumber, null,  out int length))
            {
                throw new ArgumentException(string.Format("Error string: length: {0}", line));
            }
            sum += length; 
            item = line.Substring(3, 4);
            if (!int.TryParse(item, NumberStyles.HexNumber, null,  out int address))
            {
                throw new ArgumentException(string.Format("Error string: address: {0}", line));
            }
            sum += address & 0xFF;
            sum += address >> 8;

            item = line.Substring(7, 2);
            if (!int.TryParse(item, NumberStyles.HexNumber, null,  out int type))
            {
                throw new ArgumentException(string.Format("Error string: type: {0}", line));
            }
            if (type < 0 || type > 4)
            {
                throw new ArgumentException(string.Format("Error string: type: {0}", line));
            }
            sum += type; 
           
            byte[] dump = new byte[length];
            for (int i = 0; i < length; i++)
            {
                item = line.Substring(9 + (i << 1), 2);
                if (!int.TryParse(item, NumberStyles.HexNumber, null,  out int value))
                {
                    throw new ArgumentException(string.Format("Error string: value: {0}", line));
                }
                dump[i] = (byte)value;
            }
            sum += dump.Sum(d => d);
            byte controlsum = (byte)(256 - (sum & 0xFF));
            item = line.Substring(9 + (length << 1), 2);
            if (!int.TryParse(item, NumberStyles.HexNumber, null,  out int hexsum))
            {
                throw new ArgumentException(string.Format("Error string: sum: {0}", line));
            }
            if (controlsum != hexsum)
            {
                throw new ArgumentException(string.Format("Error string: sum: {0}", line));
            }
            if (type == 0)
            {
                Add(address, dump);
            }
        }
    }

    public void Clear()
    {
        list.Clear();
    }

    public int GetAddress()
    {
        return list.Min(d => d.Key);
    }
    
    public int GetSize()
    {
        int address = list.Max(d => d.Key);
        return address + list[address].Length - GetAddress();
    }
    
    public byte[] GetDump(int start, int size, byte fillFactor = 255)
    {
        using MemoryStream dump = new(size);
        using BinaryWriter writer = new(dump);
        for (int i = 0; i < dump.Length; i++)
        {
            writer.Write(fillFactor);
        }
        foreach(var item in list)
        {
            int address = item.Key - start;
            writer.Seek(address, SeekOrigin.Begin);
            for (int i = 0; i < item.Value.Length; i++)
            {
                writer.Write(item.Value[i]);
            }
        }
        return dump.GetBuffer();
    }

    public string GetText()
    {
        StringBuilder dump = new();
        foreach(var item in list)
        {
            int type = 0;
            int controlsum = 0;
            int address = item.Key;
            dump.Append(':');
            dump.AppendFormat("{0:X2}", item.Value.Length);
            dump.AppendFormat("{0:X4}", address);
            dump.AppendFormat("{0:X2}", type);
            
            controlsum += item.Value.Length;
            controlsum += address & 0xFF;
            controlsum += address >> 8;
            controlsum += type;
            for (int i = 0; i < item.Value.Length; i++)
            {
                byte value = item.Value[i];
                dump.AppendFormat("{0:X2}", value);
                controlsum += value;
            }
            controlsum = 256 - (controlsum & 0xFF);
            dump.AppendFormat("{0:X2}", controlsum);
            dump.AppendLine();
        }
        dump.AppendLine(":00000001FF");
        return dump.ToString();
    }
}

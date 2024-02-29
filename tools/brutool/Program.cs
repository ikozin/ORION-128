using System.CommandLine;
using System.CommandLine.Parsing;

namespace brutool;

internal class Program
{

    private static void Main(string[] args)
    {
        var rootCommand = new RootCommand
        {
            BruFile.GetCommand(),
            RomFile.GetCommand(),
            OdiFile.GetCommand(),
            BinFile.GetCommand(),
        };
        rootCommand.Invoke(args);
    }
}
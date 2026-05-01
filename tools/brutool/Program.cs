using brutool.tool;
using System.CommandLine;
using System.CommandLine.Parsing;

namespace brutool;

internal class Program
{

    private static void Main(string[] args)
    {
        var rootCommand = new RootCommand
        {
            Subcommands = { BruFile.GetCommand(), RomFile.GetCommand(), OdiFile.GetCommand(), BinFile.GetCommand() },
        };
        rootCommand.Parse(args).Invoke();
    }
}
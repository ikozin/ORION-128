using System.CommandLine;
using System.CommandLine.Parsing;

internal class Program
{

    private static void Main(string[] args)
    {
        var rootCommand = new RootCommand
        {
            BruFile.GetCommand(),
            RomFile.GetCommand()
        };
        rootCommand.Invoke(args);
    }
}
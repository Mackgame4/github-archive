namespace Orbis.Seeder;

internal sealed record SeederOptions(
    long Count,
    int BatchSize,
    string DatabasePath,
    bool Reset)
{
    public static SeederOptions Parse(string[] args)
    {
        if (args.Contains("--help", StringComparer.OrdinalIgnoreCase)
            || args.Contains("-h", StringComparer.OrdinalIgnoreCase))
        {
            PrintHelp();
            Environment.Exit(0);
        }

        long count = 1_000_000;
        var batchSize = 50_000;
        string? databasePath = null;
        var reset = false;

        for (var index = 0; index < args.Length; index++)
        {
            switch (args[index])
            {
                case "--count":
                    count = ParsePositiveLong(ReadValue(args, ref index, "--count"), "--count");
                    break;
                case "--batch-size":
                    batchSize = checked((int)ParsePositiveLong(
                        ReadValue(args, ref index, "--batch-size"),
                        "--batch-size"));
                    break;
                case "--database":
                    databasePath = ReadValue(args, ref index, "--database");
                    break;
                case "--reset":
                    reset = true;
                    break;
                default:
                    throw new ArgumentException($"Unknown option '{args[index]}'. Use --help for usage.");
            }
        }

        databasePath ??= GetDefaultDatabasePath();
        return new SeederOptions(count, batchSize, Path.GetFullPath(databasePath), reset);
    }

    public static void PrintHelp()
    {
        Console.WriteLine("""
            Orbis bulk product seeder

            Usage:
              dotnet run --project tools/Orbis.Seeder -- [options]

            Options:
              --count <number>       Target generated row count (default: 1000000)
              --batch-size <number>  Rows per transaction (default: 50000)
              --database <path>      SQLite file path
              --reset                Delete existing LOAD-* products before seeding
              --help, -h             Show this help
            """);
    }

    private static string ReadValue(string[] args, ref int index, string option)
    {
        if (++index >= args.Length)
        {
            throw new ArgumentException($"{option} requires a value.");
        }

        return args[index];
    }

    private static long ParsePositiveLong(string value, string option)
    {
        if (!long.TryParse(value, out var parsed) || parsed <= 0)
        {
            throw new ArgumentException($"{option} must be a positive whole number.");
        }

        return parsed;
    }

    private static string GetDefaultDatabasePath()
    {
        var configuredDirectory = Environment.GetEnvironmentVariable("ORBIS_DATA_DIR");
        return configuredDirectory is null
            ? Path.Combine("src", "Orbis.Server", ".orbis", "orbis.db")
            : Path.Combine(configuredDirectory, "orbis.db");
    }
}

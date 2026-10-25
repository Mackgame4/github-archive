using Microsoft.EntityFrameworkCore;
using Orbis.Infrastructure.Persistence;
using Orbis.Seeder;

try
{
    var options = SeederOptions.Parse(args);
    var databaseDirectory = Path.GetDirectoryName(options.DatabasePath)
        ?? throw new InvalidOperationException("The database path has no parent directory.");
    Directory.CreateDirectory(databaseDirectory);

    Console.WriteLine($"Database: {options.DatabasePath}");
    Console.WriteLine($"Target generated products: {options.Count:N0}");
    Console.WriteLine($"Transaction batch size: {options.BatchSize:N0}");
    if (options.Reset)
    {
        Console.WriteLine("Reset enabled: existing LOAD-* products will be deleted.");
    }

    var dbOptions = new DbContextOptionsBuilder<OrbisDbContext>()
        .UseSqlite($"Data Source={options.DatabasePath};Foreign Keys=True")
        .Options;

    await using var dbContext = new OrbisDbContext(dbOptions);
    await new DatabaseInitializer(dbContext).InitializeAsync();

    using var cancellation = new CancellationTokenSource();
    Console.CancelKeyPress += (_, eventArgs) =>
    {
        eventArgs.Cancel = true;
        cancellation.Cancel();
        Console.WriteLine("Cancellation requested; the current transaction will be rolled back.");
    };

    var progress = new ConsoleSeedProgress();

    var result = await new BulkProductSeeder(dbContext).SeedAsync(
        options.Count,
        options.BatchSize,
        options.Reset,
        progress,
        cancellation.Token);

    Console.WriteLine(
        $"Complete. Added {result.Inserted:N0} rows; "
        + $"generated total is {result.FinalCount:N0}; elapsed {result.Elapsed}.");
    return 0;
}
catch (OperationCanceledException)
{
    Console.Error.WriteLine("Seeding was cancelled safely.");
    return 2;
}
catch (Exception exception) when (exception is ArgumentException or InvalidOperationException)
{
    Console.Error.WriteLine(exception.Message);
    SeederOptions.PrintHelp();
    return 1;
}

internal sealed class ConsoleSeedProgress : IProgress<BulkSeedProgress>
{
    public void Report(BulkSeedProgress value)
    {
        var rate = value.Elapsed.TotalSeconds > 0
            ? value.Inserted / value.Elapsed.TotalSeconds
            : 0;
        Console.WriteLine(
            $"{value.Current:N0}/{value.Target:N0} rows "
            + $"({(double)value.Current / value.Target:P1}) — {rate:N0} rows/s");
    }
}

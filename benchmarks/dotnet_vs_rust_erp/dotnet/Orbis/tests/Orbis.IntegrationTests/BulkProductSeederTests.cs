using Microsoft.EntityFrameworkCore;
using Orbis.Infrastructure.Persistence;

namespace Orbis.IntegrationTests;

public sealed class BulkProductSeederTests : IAsyncLifetime
{
    private readonly string directory = Path.Combine(
        Path.GetTempPath(),
        "orbis-seeder-tests",
        Guid.NewGuid().ToString("N"));

    public Task InitializeAsync() => Task.CompletedTask;

    [Fact]
    public async Task SeedAsync_ReachesTargetAndCanResumeWithoutDuplicates()
    {
        Directory.CreateDirectory(directory);
        var databasePath = Path.Combine(directory, "orbis.db");
        var options = new DbContextOptionsBuilder<OrbisDbContext>()
            .UseSqlite($"Data Source={databasePath}")
            .Options;

        await using var dbContext = new OrbisDbContext(options);
        await new DatabaseInitializer(dbContext).InitializeAsync();
        var seeder = new BulkProductSeeder(dbContext);

        var first = await seeder.SeedAsync(1_200, batchSize: 257);
        var second = await seeder.SeedAsync(1_200, batchSize: 257);
        var generatedCount = await dbContext.Products.CountAsync(product =>
            product.Reference.StartsWith(BulkProductSeeder.ReferencePrefix));

        Assert.Equal(1_200, first.Inserted);
        Assert.Equal(0, second.Inserted);
        Assert.Equal(1_200, generatedCount);
        Assert.Equal(1_203, await dbContext.Products.CountAsync());
    }

    public Task DisposeAsync()
    {
        Microsoft.Data.Sqlite.SqliteConnection.ClearAllPools();
        if (Directory.Exists(directory))
        {
            Directory.Delete(directory, recursive: true);
        }

        return Task.CompletedTask;
    }
}

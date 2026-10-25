using System.Diagnostics;
using Microsoft.Data.Sqlite;
using Microsoft.EntityFrameworkCore;

namespace Orbis.Infrastructure.Persistence;

public sealed class BulkProductSeeder(OrbisDbContext dbContext)
{
    public const string ReferencePrefix = "LOAD-";

    public async Task<BulkSeedResult> SeedAsync(
        long targetCount,
        int batchSize = 50_000,
        bool reset = false,
        IProgress<BulkSeedProgress>? progress = null,
        CancellationToken cancellationToken = default)
    {
        ArgumentOutOfRangeException.ThrowIfNegativeOrZero(targetCount);
        ArgumentOutOfRangeException.ThrowIfNegativeOrZero(batchSize);

        await dbContext.Database.OpenConnectionAsync(cancellationToken);
        try
        {
            var connection = (SqliteConnection)dbContext.Database.GetDbConnection();
            await ConfigureForBulkWritesAsync(connection, cancellationToken);

            if (reset)
            {
                await DeleteGeneratedProductsAsync(connection, cancellationToken);
            }

            var initialCount = await CountGeneratedProductsAsync(connection, cancellationToken);
            var highestSequence = await GetHighestSequenceAsync(connection, cancellationToken);
            if (highestSequence >= targetCount)
            {
                return new BulkSeedResult(initialCount, 0, initialCount, TimeSpan.Zero);
            }

            var stopwatch = Stopwatch.StartNew();
            long inserted = 0;

            while (highestSequence < targetCount)
            {
                cancellationToken.ThrowIfCancellationRequested();
                var batchEnd = Math.Min(highestSequence + batchSize, targetCount);

                await using var transaction = await connection.BeginTransactionAsync(cancellationToken);
                await using var command = connection.CreateCommand();
                command.Transaction = (SqliteTransaction)transaction;
                command.CommandText = """
                    INSERT INTO Products (Reference, Name, Stock)
                    VALUES ($reference, $name, $stock);
                    """;

                var reference = command.Parameters.Add("$reference", SqliteType.Text);
                var name = command.Parameters.Add("$name", SqliteType.Text);
                var stock = command.Parameters.Add("$stock", SqliteType.Integer);
                command.Prepare();

                for (var sequence = highestSequence + 1; sequence <= batchEnd; sequence++)
                {
                    reference.Value = $"{ReferencePrefix}{sequence:D12}";
                    name.Value = $"Load Test Product {sequence:N0}";
                    stock.Value = sequence % 501;
                    await command.ExecuteNonQueryAsync(cancellationToken);
                    inserted++;
                }

                await transaction.CommitAsync(cancellationToken);
                highestSequence = batchEnd;
                progress?.Report(new BulkSeedProgress(
                    highestSequence,
                    targetCount,
                    inserted,
                    stopwatch.Elapsed));
            }

            stopwatch.Stop();
            return new BulkSeedResult(initialCount, inserted, initialCount + inserted, stopwatch.Elapsed);
        }
        finally
        {
            await dbContext.Database.CloseConnectionAsync();
        }
    }

    private static async Task ConfigureForBulkWritesAsync(
        SqliteConnection connection,
        CancellationToken cancellationToken)
    {
        await using var command = connection.CreateCommand();
        command.CommandText = "PRAGMA journal_mode=WAL; PRAGMA synchronous=NORMAL; PRAGMA temp_store=MEMORY;";
        await command.ExecuteNonQueryAsync(cancellationToken);
    }

    private static async Task DeleteGeneratedProductsAsync(
        SqliteConnection connection,
        CancellationToken cancellationToken)
    {
        await using var command = connection.CreateCommand();
        command.CommandText = "DELETE FROM Products WHERE Reference LIKE $prefix;";
        command.Parameters.AddWithValue("$prefix", $"{ReferencePrefix}%");
        await command.ExecuteNonQueryAsync(cancellationToken);
    }

    private static async Task<long> CountGeneratedProductsAsync(
        SqliteConnection connection,
        CancellationToken cancellationToken)
    {
        await using var command = connection.CreateCommand();
        command.CommandText = "SELECT COUNT(*) FROM Products WHERE Reference LIKE $prefix;";
        command.Parameters.AddWithValue("$prefix", $"{ReferencePrefix}%");
        return (long)(await command.ExecuteScalarAsync(cancellationToken) ?? 0L);
    }

    private static async Task<long> GetHighestSequenceAsync(
        SqliteConnection connection,
        CancellationToken cancellationToken)
    {
        await using var command = connection.CreateCommand();
        command.CommandText = """
            SELECT COALESCE(MAX(CAST(SUBSTR(Reference, 6) AS INTEGER)), 0)
            FROM Products
            WHERE Reference LIKE $prefix;
            """;
        command.Parameters.AddWithValue("$prefix", $"{ReferencePrefix}%");
        return (long)(await command.ExecuteScalarAsync(cancellationToken) ?? 0L);
    }
}

public sealed record BulkSeedProgress(
    long Current,
    long Target,
    long Inserted,
    TimeSpan Elapsed);

public sealed record BulkSeedResult(
    long InitialCount,
    long Inserted,
    long FinalCount,
    TimeSpan Elapsed);

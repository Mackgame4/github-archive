using Microsoft.EntityFrameworkCore;
using Orbis.Core.Entities;

namespace Orbis.Infrastructure.Persistence;

public sealed class DatabaseInitializer(OrbisDbContext dbContext)
{
    public async Task InitializeAsync(CancellationToken cancellationToken = default)
    {
        await dbContext.Database.EnsureCreatedAsync(cancellationToken);

        if (await dbContext.Products.AnyAsync(cancellationToken))
        {
            return;
        }

        dbContext.Products.AddRange(
            Product.Create("PROD-001", "Mechanical Keyboard", 25),
            Product.Create("PROD-002", "Ergonomic Mouse", 42),
            Product.Create("PROD-003", "USB-C Dock", 12));

        await dbContext.SaveChangesAsync(cancellationToken);
    }
}

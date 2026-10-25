using Microsoft.EntityFrameworkCore;
using Orbis.Core.Entities;

namespace Orbis.Infrastructure.Persistence;

public sealed class OrbisDbContext(DbContextOptions<OrbisDbContext> options) : DbContext(options)
{
    public DbSet<Product> Products => Set<Product>();

    protected override void OnModelCreating(ModelBuilder modelBuilder)
    {
        modelBuilder.ApplyConfigurationsFromAssembly(typeof(OrbisDbContext).Assembly);
    }
}

using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.DependencyInjection;
using Orbis.Application.Abstractions;
using Orbis.Infrastructure.Persistence;
using Orbis.Infrastructure.Persistence.Repositories;

namespace Orbis.Infrastructure.DependencyInjection;

public static class ServiceCollectionExtensions
{
    public static IServiceCollection AddOrbisInfrastructure(
        this IServiceCollection services,
        string connectionString)
    {
        services.AddDbContextPool<OrbisDbContext>(options => options.UseSqlite(connectionString));
        services.AddScoped<IProductRepository, ProductRepository>();
        services.AddScoped<DatabaseInitializer>();
        return services;
    }
}

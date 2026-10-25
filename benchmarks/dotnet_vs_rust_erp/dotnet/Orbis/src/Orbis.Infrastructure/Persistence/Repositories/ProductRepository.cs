using Microsoft.EntityFrameworkCore;
using Orbis.Application.Abstractions;
using Orbis.Contracts.Products;

namespace Orbis.Infrastructure.Persistence.Repositories;

public sealed class ProductRepository(OrbisDbContext dbContext) : IProductRepository
{
    // Keep both query shapes compiled and pass pagination values as parameters.
    // Project on the read path so no domain entities or second DTO array are built.
    private static readonly Func<OrbisDbContext, int, int, IAsyncEnumerable<ProductResponse>> LimitedQuery =
        EF.CompileAsyncQuery((OrbisDbContext context, int limit, int offset) =>
            context.Products
                .AsNoTracking()
                .OrderBy(product => product.Reference)
                .Skip(offset)
                .Take(limit)
                .Select(product => new ProductResponse(
                    product.Id, product.Reference, product.Name, product.Stock)));

    private static readonly Func<OrbisDbContext, int, IAsyncEnumerable<ProductResponse>> UnlimitedQuery =
        EF.CompileAsyncQuery((OrbisDbContext context, int offset) =>
            context.Products
                .AsNoTracking()
                .OrderBy(product => product.Reference)
                .Skip(offset)
                .Select(product => new ProductResponse(
                    product.Id, product.Reference, product.Name, product.Stock)));

    public async Task<IReadOnlyList<ProductResponse>> ListAsync(
        int? limit,
        int offset,
        CancellationToken cancellationToken = default)
    {
        var query = limit.HasValue
            ? LimitedQuery(dbContext, limit.Value, offset)
            : UnlimitedQuery(dbContext, offset);
        var products = new List<ProductResponse>(Math.Min(limit ?? 0, 4096));
        await foreach (var product in query.WithCancellation(cancellationToken))
        {
            products.Add(product);
        }
        return products;
    }
}

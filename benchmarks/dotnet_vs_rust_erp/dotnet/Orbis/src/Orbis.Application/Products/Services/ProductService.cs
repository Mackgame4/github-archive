using Orbis.Application.Abstractions;
using Orbis.Contracts.Products;

namespace Orbis.Application.Products.Services;

public sealed class ProductService(IProductRepository repository)
{
    public Task<IReadOnlyList<ProductResponse>> ListAsync(
        int? limit,
        int offset,
        CancellationToken cancellationToken = default)
    {
        return repository.ListAsync(limit, offset, cancellationToken);
    }
}

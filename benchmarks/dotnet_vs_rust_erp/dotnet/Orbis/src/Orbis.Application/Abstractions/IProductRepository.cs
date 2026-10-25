using Orbis.Contracts.Products;

namespace Orbis.Application.Abstractions;

public interface IProductRepository
{
    Task<IReadOnlyList<ProductResponse>> ListAsync(
        int? limit,
        int offset,
        CancellationToken cancellationToken = default);
}

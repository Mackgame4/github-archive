using Orbis.Application.Products.Services;
using Orbis.Contracts.Products;

namespace Orbis.Server.Api.Products;

public static class ProductEndpoints
{
    private const int DefaultLimit = 100;
    private const int MaximumLimit = 500_000;

    public static IEndpointRouteBuilder MapProductEndpoints(this IEndpointRouteBuilder endpoints)
    {
        endpoints.MapGet("/api/products", async (
                string? limit,
                int? offset,
                ProductService service,
                CancellationToken cancellationToken) =>
            {
                int? parsedLimit;
                if (limit is null)
                {
                    parsedLimit = DefaultLimit;
                }
                else if (limit.Equals("none", StringComparison.OrdinalIgnoreCase))
                {
                    parsedLimit = null;
                }
                else if (!int.TryParse(limit, out var numericLimit)
                    || numericLimit is <= 0 or > MaximumLimit)
                {
                    return Results.BadRequest(new
                    {
                        error = $"The limit must be 'none' or a number between 1 and {MaximumLimit}."
                    });
                }
                else
                {
                    parsedLimit = numericLimit;
                }

                if (offset is < 0)
                {
                    return Results.BadRequest(new
                    {
                        error = "The offset must be zero or greater."
                    });
                }

                return Results.Ok(await service.ListAsync(
                    parsedLimit,
                    offset ?? 0,
                    cancellationToken));
            })
            .WithName("GetProducts")
            .WithSummary(
                $"Lists products in batches (default {DefaultLimit}, maximum {MaximumLimit}, or limit=none)")
            .Produces<IReadOnlyList<ProductResponse>>()
            .Produces(StatusCodes.Status400BadRequest);

        return endpoints;
    }
}

using System.Net;
using System.Net.Http.Json;
using Microsoft.AspNetCore.Hosting;
using Microsoft.AspNetCore.Mvc.Testing;
using Microsoft.Data.Sqlite;
using Orbis.Contracts.Products;

namespace Orbis.IntegrationTests;

public sealed class ProductEndpointTests : IClassFixture<OrbisWebApplicationFactory>
{
    private readonly HttpClient client;

    public ProductEndpointTests(OrbisWebApplicationFactory factory)
    {
        client = factory.CreateClient(new WebApplicationFactoryClientOptions
        {
            AllowAutoRedirect = false
        });
    }

    [Fact]
    public async Task GetProducts_ReturnsSeededProducts()
    {
        var response = await client.GetAsync("/api/products");
        var products = await response.Content.ReadFromJsonAsync<ProductResponse[]>();

        Assert.Equal(HttpStatusCode.OK, response.StatusCode);
        Assert.NotNull(products);
        Assert.Equal(3, products.Length);
        Assert.Contains(products, product => product.Reference == "PROD-001" && product.Stock == 25);
    }

    [Fact]
    public async Task GetProducts_WithLimit_ReturnsOnlyRequestedNumberOfProducts()
    {
        var response = await client.GetAsync("/api/products?limit=2");
        var products = await response.Content.ReadFromJsonAsync<ProductResponse[]>();

        Assert.Equal(HttpStatusCode.OK, response.StatusCode);
        Assert.NotNull(products);
        Assert.Equal(2, products.Length);
    }

    [Fact]
    public async Task GetProducts_WithOffset_ReturnsTheRequestedBatch()
    {
        var response = await client.GetAsync("/api/products?limit=1&offset=1");
        var products = await response.Content.ReadFromJsonAsync<ProductResponse[]>();

        Assert.Equal(HttpStatusCode.OK, response.StatusCode);
        Assert.NotNull(products);
        var product = Assert.Single(products);
        Assert.Equal("PROD-002", product.Reference);
    }

    [Fact]
    public async Task GetProducts_WithNoLimit_ReturnsAllProducts()
    {
        var response = await client.GetAsync("/api/products?limit=none");
        var products = await response.Content.ReadFromJsonAsync<ProductResponse[]>();

        Assert.Equal(HttpStatusCode.OK, response.StatusCode);
        Assert.NotNull(products);
        Assert.Equal(3, products.Length);
    }

    [Fact]
    public async Task GetProducts_UsesEachRequestsPaginationValues()
    {
        var first = await client.GetFromJsonAsync<ProductResponse[]>("/api/products?limit=2&offset=0");
        var second = await client.GetFromJsonAsync<ProductResponse[]>("/api/products?limit=1&offset=1");
        var remaining = await client.GetFromJsonAsync<ProductResponse[]>("/api/products?limit=none&offset=2");

        Assert.NotNull(first);
        Assert.Equal(2, first.Length);
        Assert.NotNull(second);
        Assert.Equal("PROD-002", Assert.Single(second).Reference);
        Assert.NotNull(remaining);
        Assert.Equal("PROD-003", Assert.Single(remaining).Reference);
    }

    [Theory]
    [InlineData("0")]
    [InlineData("-1")]
    [InlineData("invalid")]
    [InlineData("500001")]
    public async Task GetProducts_WithInvalidLimit_ReturnsBadRequest(string limit)
    {
        var response = await client.GetAsync($"/api/products?limit={limit}");

        Assert.Equal(HttpStatusCode.BadRequest, response.StatusCode);
    }

    [Fact]
    public async Task GetProducts_WithNegativeOffset_ReturnsBadRequest()
    {
        var response = await client.GetAsync("/api/products?offset=-1");

        Assert.Equal(HttpStatusCode.BadRequest, response.StatusCode);
    }
}

public sealed class OrbisWebApplicationFactory : WebApplicationFactory<Program>
{
    private readonly string databaseDirectory = Path.Combine(
        Path.GetTempPath(),
        "orbis-tests",
        Guid.NewGuid().ToString("N"));

    protected override void ConfigureWebHost(IWebHostBuilder builder)
    {
        builder.UseEnvironment("Testing");
        builder.UseSetting("Orbis:DataDirectory", databaseDirectory);
    }

    protected override void Dispose(bool disposing)
    {
        base.Dispose(disposing);
        if (disposing && Directory.Exists(databaseDirectory))
        {
            SqliteConnection.ClearAllPools();
            Directory.Delete(databaseDirectory, recursive: true);
        }
    }
}

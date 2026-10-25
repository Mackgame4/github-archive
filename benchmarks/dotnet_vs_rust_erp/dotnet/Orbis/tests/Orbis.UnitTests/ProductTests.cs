using Orbis.Core.Entities;

namespace Orbis.UnitTests;

public sealed class ProductTests
{
    [Fact]
    public void Create_WithValidValues_CreatesProduct()
    {
        var product = Product.Create(" PROD-001 ", " Keyboard ", 25);

        Assert.Equal("PROD-001", product.Reference);
        Assert.Equal("Keyboard", product.Name);
        Assert.Equal(25, product.Stock);
    }

    [Fact]
    public void Create_WithNegativeStock_Throws()
    {
        Assert.Throws<ArgumentOutOfRangeException>(() =>
            Product.Create("PROD-001", "Keyboard", -1));
    }
}

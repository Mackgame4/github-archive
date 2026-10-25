namespace Orbis.Core.Entities;

public sealed class Product
{
    private Product() { }

    private Product(string reference, string name, int stock)
    {
        Reference = reference;
        Name = name;
        Stock = stock;
    }

    public long Id { get; private set; }
    public string Reference { get; private set; } = string.Empty;
    public string Name { get; private set; } = string.Empty;
    public int Stock { get; private set; }

    public static Product Create(string reference, string name, int stock)
    {
        ArgumentException.ThrowIfNullOrWhiteSpace(reference);
        ArgumentException.ThrowIfNullOrWhiteSpace(name);
        ArgumentOutOfRangeException.ThrowIfNegative(stock);

        return new Product(reference.Trim(), name.Trim(), stock);
    }
}

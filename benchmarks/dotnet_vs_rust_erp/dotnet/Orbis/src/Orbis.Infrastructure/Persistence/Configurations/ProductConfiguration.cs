using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;
using Orbis.Core.Entities;

namespace Orbis.Infrastructure.Persistence.Configurations;

public sealed class ProductConfiguration : IEntityTypeConfiguration<Product>
{
    public void Configure(EntityTypeBuilder<Product> builder)
    {
        builder.ToTable("Products", table => table.HasCheckConstraint("CK_Products_Stock", "Stock >= 0"));
        builder.HasKey(product => product.Id);
        builder.Property(product => product.Reference).HasMaxLength(64).IsRequired();
        builder.HasIndex(product => product.Reference).IsUnique();
        builder.Property(product => product.Name).HasMaxLength(200).IsRequired();
        builder.Property(product => product.Stock).IsRequired();
    }
}

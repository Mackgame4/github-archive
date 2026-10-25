using Orbis.Application.Products.Services;
using Orbis.Infrastructure.DependencyInjection;
using Orbis.Infrastructure.Persistence;
using Orbis.Server.Api.Products;
using Orbis.Server.Configuration;

var builder = WebApplication.CreateBuilder(args);

builder.Services.AddProblemDetails();
builder.Services.AddOpenApi();
builder.Services.AddScoped<ProductService>();

var databasePath = DatabasePath.Resolve(builder.Configuration, builder.Environment.ContentRootPath);
builder.Services.AddOrbisInfrastructure($"Data Source={databasePath};Foreign Keys=True");

var app = builder.Build();

app.UseExceptionHandler();
app.UseBlazorFrameworkFiles();
app.UseStaticFiles();

app.MapOpenApi();
app.MapProductEndpoints();
app.MapFallbackToFile("index.html");

await using (var scope = app.Services.CreateAsyncScope())
{
    var initializer = scope.ServiceProvider.GetRequiredService<DatabaseInitializer>();
    await initializer.InitializeAsync();
}

await app.RunAsync();

public partial class Program;

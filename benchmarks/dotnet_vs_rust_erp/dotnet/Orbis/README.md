# Orbis

Orbis is a runnable .NET 10 ERP starter built as a modular monolith. One ASP.NET Core process serves the product API and the compiled Blazor WebAssembly UI. The browser retrieves inventory through `GET /api/products`; it never accesses SQLite directly.

The UI uses the official Bootstrap `6.0.0-alpha.1` release, pinned to an exact CDN URL and integrity hash. Bootstrap 6 is prerelease software and may contain breaking changes in future alpha releases.

## Prerequisites

- .NET SDK 10.0.302 or a later .NET 10 patch SDK
- A browser with WebAssembly support

No Node.js installation, separate database server, or frontend build command is required.

## Architecture

| Project | Responsibility |
| --- | --- |
| `Orbis.Core` | Product domain entity and invariants |
| `Orbis.Contracts` | API response contracts shared with the browser |
| `Orbis.Application` | Product use case and repository boundary |
| `Orbis.Infrastructure` | EF Core, SQLite mapping, repository, schema initialization, and seed data |
| `Orbis.UI` | Reusable generic `OrbisTable<T>` and `OrbisButton` Razor components |
| `Orbis.Web` | Browser-side Blazor WebAssembly inventory page |
| `Orbis.Server` | ASP.NET Core host, API endpoints, OpenAPI, configuration, and static UI hosting |
| `Orbis.UnitTests` | Domain tests |
| `Orbis.IntegrationTests` | Hosted API and SQLite integration test |

Dependencies flow inward from Server and Infrastructure toward Application, Contracts, and Core. `Orbis.Web` depends only on Contracts and UI. `Orbis.Web` is the one addition to the proposed structure required to ensure the browser itself calls the API while retaining one deployed server process.

Future Inventory, Sales, Invoicing, and Reporting module directories contain `.gitkeep` files until they have real implementations.

## Restore, build, test, and run

From this directory:

```powershell
dotnet restore Orbis.sln
dotnet build Orbis.sln --no-restore
dotnet test Orbis.sln --no-build
dotnet run --project src/Orbis.Server
```

Open:

- Web UI: <http://127.0.0.1:5000>
- Products API: <http://127.0.0.1:5000/api/products>
- OpenAPI document: <http://127.0.0.1:5000/openapi/v1.json>

The launch profile binds the application to `127.0.0.1:5000`. Override it with `ASPNETCORE_URLS`. See `.env.example` for common environment settings; `.env` files are not loaded automatically by ASP.NET Core.

## API

`GET /api/products` returns HTTP 200 with a JSON array. Results are ordered by
reference and limited to 100 products by default. Use `limit` (maximum 500,000)
and `offset` to retrieve larger datasets in batches. Pass `limit=none` to
explicitly return every row:

```text
GET /api/products?limit=1000&offset=0
GET /api/products?limit=1000&offset=1000
GET /api/products?limit=none
```

`limit=none` can produce a very large JSON response and should only be used by
clients that are prepared to hold the complete result in memory.

```json
[
  {
    "id": 1,
    "reference": "PROD-001",
    "name": "Mechanical Keyboard",
    "stock": 25
  }
]
```

The endpoint returns DTOs rather than EF Core entities. Product references have a unique database index. Nonnegative stock is enforced by both the domain factory and a SQLite check constraint.

## Database

By default, SQLite is stored at `src/Orbis.Server/.orbis/orbis.db`. Set `ORBIS_DATA_DIR` to an absolute path or a path relative to the server content root to change it.

On startup, `DatabaseInitializer` uses EF Core's idempotent `EnsureCreatedAsync` schema initialization and inserts three products only when the table is empty. This makes a clean checkout runnable without installing `dotnet-ef`.

To reset local data, stop Orbis and delete `src/Orbis.Server/.orbis`. The next launch recreates and seeds it. Before evolving the schema in a production system, replace `EnsureCreatedAsync` with versioned EF Core migrations; the migrations directories are reserved for that transition.

## Load-test seeder

`Orbis.Seeder` inserts generated products in bounded SQLite transactions without holding millions of objects in memory. Its default target is one million generated rows:

```powershell
dotnet run --project tools/Orbis.Seeder -- --count 1000000
```

The count is a target for `LOAD-*` products, so rerunning the command resumes from the highest committed sequence and does not add another million rows. The three normal sample products remain separate.

Useful options:

```powershell
# Seed five million generated products using 100,000-row transactions
dotnet run --project tools/Orbis.Seeder -- --count 5000000 --batch-size 100000

# Delete only prior LOAD-* products, then create a fresh million
dotnet run --project tools/Orbis.Seeder -- --count 1000000 --reset

# Target another SQLite file
dotnet run --project tools/Orbis.Seeder -- --count 1000000 --database C:\data\orbis-load.db
```

Press Ctrl+C to cancel safely. The current transaction rolls back while previously committed batches remain resumable. Stop the Orbis server before using `--reset`; normal seeding can coexist with readers, but SQLite permits only one writer at a time. Large datasets increase the database and WAL files substantially, so ensure the target drive has enough free space.

## Production build

```powershell
dotnet publish src/Orbis.Server -c Release -o artifacts/orbis
```

The published directory contains the server and browser bundle. The browser currently loads Bootstrap from jsDelivr, so vendor the pinned CSS for fully offline deployments. Add authentication, authorization, TLS termination, and database backup procedures before exposing an ERP system publicly.

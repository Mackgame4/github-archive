# Orbis

Orbis is a runnable ERP starter built as a Rust modular monolith. One Axum
process owns persistence and the JSON API, while Topcoat renders the inventory
page on the server. SQLite is created and migrated automatically on startup.

The UI uses [Topcoat 0.10](https://github.com/tokio-rs/topcoat) with Bootstrap
`6.0.0-alpha.1`. Topcoat is early-stage software and may introduce breaking
changes between releases.

## Workspace

| Crate | Responsibility |
| --- | --- |
| `orbis-core` | Product domain model and invariants |
| `orbis-contracts` | Serialized API contracts |
| `orbis-application` | Product use case and repository boundary |
| `orbis-infrastructure` | SQLx SQLite repository, migrations, and seed data |
| `orbis-api` | Axum JSON handlers and OpenAPI document |
| `orbis-ui` | Reusable Topcoat server-rendered components |
| `orbis-web` | Topcoat inventory page and router |
| `orbis-server` | Configuration, composition, and HTTP hosting |
| `orbis-seeder` | Batched, resumable load-test data generator |

## Run locally

From the repository root:

```powershell
cargo run -p orbis-server
```

Open <http://127.0.0.1:3000>. No WASM target, JavaScript package manager, or
frontend build step is required.

Configuration can be supplied through environment variables:

- `ORBIS_BIND_ADDR`, default `127.0.0.1:3000`
- `ORBIS_DATA_DIR`, default `.orbis`
- `RUST_LOG`, default `orbis=info,tower_http=info`

## API

`GET /api/products` returns products ordered by reference. It returns 100 rows
by default and accepts `limit` (maximum 10,000) and `offset`. Pass
`limit=none` to explicitly return every row:

```text
GET /api/products?limit=1000&offset=0
GET /api/products?limit=1000&offset=1000
GET /api/products?limit=none
```

`limit=none` can produce a very large JSON response and should only be used by
clients that are prepared to hold the complete result in memory.

OpenAPI JSON is available at
<http://127.0.0.1:3000/api/openapi.json>.

## Database

The SQLite database is stored at `.orbis/orbis.db` by default. Startup runs
embedded migrations and inserts three sample products only when the table is
empty. To reset local data, stop the server and remove `.orbis`.

Generate one million load-test products in that database with:

```powershell
cargo run -p orbis-seeder --release -- --reset
```

The seeder commits in 50,000-row batches and resumes an existing `LOAD-*`
dataset. Use `--count`, `--batch-size`, and `--database` to override its
defaults.

## Build and test

```powershell
cargo fmt --check
cargo clippy --workspace --all-targets -- -D warnings
cargo test --workspace
cargo build --workspace --release
```

The UI loads Bootstrap from jsDelivr, so the browser needs network access for
the stylesheet unless it is vendored locally. Add authentication,
authorization, backups, and TLS before exposing an ERP deployment publicly.

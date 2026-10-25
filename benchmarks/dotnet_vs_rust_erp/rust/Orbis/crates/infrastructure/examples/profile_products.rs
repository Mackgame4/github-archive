//! Opt-in phase timings of the real repository and application service.
//! Set ORBIS_PROFILE_DB to an isolated copy of the seeded SQLite database.
use async_trait::async_trait;
use orbis_application::{ApplicationError, ProductRepository, ProductService};
use orbis_core::Product;
use orbis_infrastructure::SqliteProductRepository;
use std::{
    path::Path,
    sync::{
        Arc,
        atomic::{AtomicU64, Ordering},
    },
    time::Instant,
};

struct TimedRepository {
    inner: SqliteProductRepository,
    elapsed_ns: Arc<AtomicU64>,
}

#[async_trait]
impl ProductRepository for TimedRepository {
    async fn list(
        &self,
        limit: Option<u32>,
        offset: u32,
    ) -> Result<Vec<Product>, ApplicationError> {
        let start = Instant::now();
        let result = self.inner.list(limit, offset).await;
        self.elapsed_ns
            .store(start.elapsed().as_nanos() as u64, Ordering::Relaxed);
        result
    }
}

async fn measure(repository: SqliteProductRepository, limit: Option<u32>) -> serde_json::Value {
    let elapsed_ns = Arc::new(AtomicU64::new(0));
    let service = ProductService::new(Arc::new(TimedRepository {
        inner: repository,
        elapsed_ns: elapsed_ns.clone(),
    }));
    let start = Instant::now();
    let products = service.list_products(limit, 0).await.unwrap();
    let service_ms = start.elapsed().as_secs_f64() * 1000.0;
    let repository_ms = elapsed_ns.load(Ordering::Relaxed) as f64 / 1_000_000.0;
    let serialize_start = Instant::now();
    let bytes = serde_json::to_vec(&products).unwrap();
    let serialize_ms = serialize_start.elapsed().as_secs_f64() * 1000.0;
    serde_json::json!({
        "limit": limit, "rows": products.len(), "bytes": bytes.len(),
        "repository_ms_including_fetch_decode_and_domain_validation": repository_ms,
        "dto_conversion_ms": service_ms - repository_ms,
        "serialization_ms": serialize_ms,
        "total_before_http_ms": start.elapsed().as_secs_f64() * 1000.0,
    })
}

#[tokio::main]
async fn main() {
    let path =
        std::env::var("ORBIS_PROFILE_DB").expect("set ORBIS_PROFILE_DB to an isolated DB copy");
    let repository = SqliteProductRepository::connect(Path::new(&path))
        .await
        .unwrap();
    let _ = measure(repository.clone(), None).await;
    let mut single = Vec::new();
    for _ in 0..3 {
        single.push(measure(repository.clone(), None).await);
    }
    let mut tasks = tokio::task::JoinSet::new();
    for _ in 0..8 {
        let repository = repository.clone();
        tasks.spawn(async move { measure(repository, Some(10_000)).await });
    }
    let mut concurrent = Vec::new();
    while let Some(result) = tasks.join_next().await {
        concurrent.push(result.unwrap());
    }
    println!(
        "{}",
        serde_json::to_string_pretty(&serde_json::json!({
            "single_million_rows": single, "eight_concurrent_10000_rows": concurrent
        }))
        .unwrap()
    );
}

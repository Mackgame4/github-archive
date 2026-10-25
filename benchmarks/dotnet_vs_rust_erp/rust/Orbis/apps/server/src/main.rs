mod config;
mod routes;

use axum::Router;
use config::Config;
use orbis_api::ApiState;
use orbis_application::ProductService;
use orbis_infrastructure::SqliteProductRepository;
use std::sync::Arc;
use topcoat::router::tower::TowerService;
use tracing_subscriber::EnvFilter;

type MainError = Box<dyn std::error::Error + Send + Sync>;

#[tokio::main]
async fn main() -> Result<(), MainError> {
    tracing_subscriber::fmt()
        .with_env_filter(
            EnvFilter::try_from_default_env()
                .unwrap_or_else(|_| EnvFilter::new("orbis=info,tower_http=info")),
        )
        .init();

    let config = Config::from_env()?;
    tokio::fs::create_dir_all(&config.data_dir).await?;
    let database_path = config.data_dir.join("orbis.db");
    let repository = SqliteProductRepository::connect(&database_path).await?;
    let products = ProductService::new(Arc::new(repository));
    let state = ApiState {
        products: products.clone(),
    };

    let app = Router::new()
        .merge(routes::products::router(state))
        .fallback_service(TowerService::new(orbis_web::router(products)));
    let listener = tokio::net::TcpListener::bind(config.bind_addr).await?;
    tracing::info!(address = %config.bind_addr, database = %database_path.display(), "Orbis is running");
    axum::serve(listener, app)
        .with_graceful_shutdown(shutdown_signal())
        .await?;
    Ok(())
}

async fn shutdown_signal() {
    if let Err(error) = tokio::signal::ctrl_c().await {
        tracing::error!(%error, "failed to install shutdown handler");
    }
}

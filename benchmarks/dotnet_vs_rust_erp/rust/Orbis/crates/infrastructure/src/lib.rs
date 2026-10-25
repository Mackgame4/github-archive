use async_trait::async_trait;
use orbis_application::{ApplicationError, ProductRepository};
use orbis_core::Product;
use sqlx::{
    FromRow, SqlitePool,
    sqlite::{SqliteConnectOptions, SqlitePoolOptions},
};
use std::{
    path::Path,
    time::{Duration, Instant},
};

pub const LOAD_TEST_REFERENCE_PREFIX: &str = "LOAD-";

#[derive(Debug, thiserror::Error)]
pub enum InfrastructureError {
    #[error("database operation failed: {0}")]
    Database(#[from] sqlx::Error),
    #[error("database migration failed: {0}")]
    Migration(#[from] sqlx::migrate::MigrateError),
    #[error("invalid seed option: {0}")]
    InvalidSeedOption(String),
}

#[derive(Clone)]
pub struct SqliteProductRepository {
    pool: SqlitePool,
}

#[derive(FromRow)]
struct ProductRow {
    id: i64,
    reference: String,
    name: String,
    stock: i64,
}

impl SqliteProductRepository {
    pub async fn connect(database_path: &Path) -> Result<Self, InfrastructureError> {
        let pool = SqlitePoolOptions::new()
            .max_connections(5)
            .connect_with(
                SqliteConnectOptions::new()
                    .filename(database_path)
                    .create_if_missing(true),
            )
            .await?;
        sqlx::migrate!("./migrations").run(&pool).await?;
        seed_if_empty(&pool).await?;
        Ok(Self { pool })
    }

    pub async fn seed_bulk_products<F>(
        &self,
        target_count: u64,
        batch_size: u32,
        reset: bool,
        mut report_progress: F,
    ) -> Result<BulkSeedResult, InfrastructureError>
    where
        F: FnMut(BulkSeedProgress),
    {
        if target_count == 0 {
            return Err(InfrastructureError::InvalidSeedOption(
                "target count must be greater than zero".to_owned(),
            ));
        }
        if batch_size == 0 {
            return Err(InfrastructureError::InvalidSeedOption(
                "batch size must be greater than zero".to_owned(),
            ));
        }

        for statement in [
            "PRAGMA journal_mode=WAL",
            "PRAGMA synchronous=NORMAL",
            "PRAGMA temp_store=MEMORY",
        ] {
            sqlx::query(statement).execute(&self.pool).await?;
        }

        let prefix_pattern = format!("{LOAD_TEST_REFERENCE_PREFIX}%");
        if reset {
            sqlx::query("DELETE FROM products WHERE reference LIKE ?")
                .bind(&prefix_pattern)
                .execute(&self.pool)
                .await?;
        }

        let initial_count =
            sqlx::query_scalar::<_, i64>("SELECT COUNT(*) FROM products WHERE reference LIKE ?")
                .bind(&prefix_pattern)
                .fetch_one(&self.pool)
                .await? as u64;
        let mut highest_sequence = sqlx::query_scalar::<_, i64>(
            "SELECT COALESCE(MAX(CAST(SUBSTR(reference, 6) AS INTEGER)), 0) \
             FROM products WHERE reference LIKE ?",
        )
        .bind(&prefix_pattern)
        .fetch_one(&self.pool)
        .await? as u64;

        if highest_sequence >= target_count {
            return Ok(BulkSeedResult {
                initial_count,
                inserted: 0,
                final_count: initial_count,
                elapsed: Duration::ZERO,
            });
        }

        let started = Instant::now();
        let mut inserted = 0_u64;
        while highest_sequence < target_count {
            let batch_end = highest_sequence
                .saturating_add(u64::from(batch_size))
                .min(target_count);
            let mut transaction = self.pool.begin().await?;

            for sequence in (highest_sequence + 1)..=batch_end {
                sqlx::query("INSERT INTO products (reference, name, stock) VALUES (?, ?, ?)")
                    .bind(format!("{LOAD_TEST_REFERENCE_PREFIX}{sequence:012}"))
                    .bind(format!("Load Test Product {sequence}"))
                    .bind((sequence % 501) as i64)
                    .execute(&mut *transaction)
                    .await?;
                inserted += 1;
            }

            transaction.commit().await?;
            highest_sequence = batch_end;
            report_progress(BulkSeedProgress {
                current: highest_sequence,
                target: target_count,
                inserted,
                elapsed: started.elapsed(),
            });
        }

        Ok(BulkSeedResult {
            initial_count,
            inserted,
            final_count: initial_count + inserted,
            elapsed: started.elapsed(),
        })
    }
}

#[derive(Debug, Clone, Copy)]
pub struct BulkSeedProgress {
    pub current: u64,
    pub target: u64,
    pub inserted: u64,
    pub elapsed: Duration,
}

#[derive(Debug, Clone, Copy)]
pub struct BulkSeedResult {
    pub initial_count: u64,
    pub inserted: u64,
    pub final_count: u64,
    pub elapsed: Duration,
}

async fn seed_if_empty(pool: &SqlitePool) -> Result<(), sqlx::Error> {
    let mut tx = pool.begin().await?;
    let count: i64 = sqlx::query_scalar("SELECT COUNT(*) FROM products")
        .fetch_one(&mut *tx)
        .await?;
    if count == 0 {
        for (reference, name, stock) in [
            ("PROD-001", "Mechanical Keyboard", 25_i64),
            ("PROD-002", "Ergonomic Mouse", 42_i64),
            ("PROD-003", "USB-C Dock", 12_i64),
        ] {
            sqlx::query("INSERT INTO products (reference, name, stock) VALUES (?, ?, ?)")
                .bind(reference)
                .bind(name)
                .bind(stock)
                .execute(&mut *tx)
                .await?;
        }
    }
    tx.commit().await?;
    Ok(())
}

#[async_trait]
impl ProductRepository for SqliteProductRepository {
    async fn list(
        &self,
        limit: Option<u32>,
        offset: u32,
    ) -> Result<Vec<Product>, ApplicationError> {
        let rows = sqlx::query_as::<_, ProductRow>(
            "SELECT id, reference, name, stock FROM products \
             ORDER BY reference LIMIT COALESCE(?, -1) OFFSET ?",
        )
        .bind(limit.map(i64::from))
        .bind(i64::from(offset))
        .fetch_all(&self.pool)
        .await
        .map_err(|error| ApplicationError::Repository(error.to_string()))?;

        rows.into_iter()
            .map(|row| {
                Product::new(row.id, row.reference, row.name, row.stock)
                    .map_err(|error| ApplicationError::Repository(error.to_string()))
            })
            .collect()
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    #[tokio::test]
    async fn bulk_seeder_is_batched_and_idempotent() {
        let directory = tempfile::tempdir().unwrap();
        let repository = SqliteProductRepository::connect(&directory.path().join("orbis.db"))
            .await
            .unwrap();
        let mut progress_updates = 0;

        let first = repository
            .seed_bulk_products(1_200, 250, true, |_| progress_updates += 1)
            .await
            .unwrap();
        let second = repository
            .seed_bulk_products(1_200, 250, false, |_| {})
            .await
            .unwrap();
        let total: i64 = sqlx::query_scalar("SELECT COUNT(*) FROM products")
            .fetch_one(&repository.pool)
            .await
            .unwrap();

        assert_eq!(first.inserted, 1_200);
        assert_eq!(first.final_count, 1_200);
        assert_eq!(progress_updates, 5);
        assert_eq!(second.inserted, 0);
        assert_eq!(second.final_count, 1_200);
        assert_eq!(total, 1_203);
    }
}

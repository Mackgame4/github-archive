use std::sync::Arc;

use async_trait::async_trait;
use orbis_contracts::ProductResponse;
use orbis_core::Product;

#[derive(Debug, thiserror::Error)]
pub enum ApplicationError {
    #[error("product storage failed: {0}")]
    Repository(String),
}

#[async_trait]
pub trait ProductRepository: Send + Sync {
    async fn list(&self, limit: Option<u32>, offset: u32)
    -> Result<Vec<Product>, ApplicationError>;
}

#[derive(Clone)]
pub struct ProductService {
    repository: Arc<dyn ProductRepository>,
}

impl ProductService {
    pub fn new(repository: Arc<dyn ProductRepository>) -> Self {
        Self { repository }
    }

    pub async fn list_products(
        &self,
        limit: Option<u32>,
        offset: u32,
    ) -> Result<Vec<ProductResponse>, ApplicationError> {
        Ok(self
            .repository
            .list(limit, offset)
            .await?
            .into_iter()
            .map(|product| ProductResponse {
                id: product.id(),
                reference: product.reference().to_owned(),
                name: product.name().to_owned(),
                stock: product.stock(),
            })
            .collect())
    }
}

//! Domain objects and invariants for Orbis.

#[derive(Debug, Clone, PartialEq, Eq)]
pub struct Product {
    id: i64,
    reference: String,
    name: String,
    stock: i64,
}

#[derive(Debug, thiserror::Error, PartialEq, Eq)]
pub enum ProductError {
    #[error("product reference cannot be empty")]
    EmptyReference,
    #[error("product name cannot be empty")]
    EmptyName,
    #[error("product stock cannot be negative")]
    NegativeStock,
}

impl Product {
    pub fn new(
        id: i64,
        reference: impl Into<String>,
        name: impl Into<String>,
        stock: i64,
    ) -> Result<Self, ProductError> {
        let reference = reference.into();
        let name = name.into();
        if reference.trim().is_empty() {
            return Err(ProductError::EmptyReference);
        }
        if name.trim().is_empty() {
            return Err(ProductError::EmptyName);
        }
        if stock < 0 {
            return Err(ProductError::NegativeStock);
        }
        Ok(Self {
            id,
            reference,
            name,
            stock,
        })
    }

    pub fn id(&self) -> i64 {
        self.id
    }
    pub fn reference(&self) -> &str {
        &self.reference
    }
    pub fn name(&self) -> &str {
        &self.name
    }
    pub fn stock(&self) -> i64 {
        self.stock
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn rejects_negative_stock() {
        assert_eq!(
            Product::new(1, "PROD-001", "Keyboard", -1),
            Err(ProductError::NegativeStock)
        );
    }

    #[test]
    fn creates_valid_product() {
        let product = Product::new(1, "PROD-001", "Keyboard", 25).unwrap();
        assert_eq!(product.reference(), "PROD-001");
        assert_eq!(product.stock(), 25);
    }
}

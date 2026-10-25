use serde::{Deserialize, Serialize};
use utoipa::ToSchema;

#[derive(Debug, Clone, PartialEq, Eq, Serialize, Deserialize, ToSchema)]
pub struct ProductResponse {
    pub id: i64,
    pub reference: String,
    pub name: String,
    pub stock: i64,
}

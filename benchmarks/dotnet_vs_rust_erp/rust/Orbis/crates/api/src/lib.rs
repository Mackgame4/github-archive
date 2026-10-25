use axum::{
    Json, Router,
    extract::{Query, State},
    http::StatusCode,
    response::IntoResponse,
    routing::get,
};
use orbis_application::{ApplicationError, ProductService};
use orbis_contracts::ProductResponse;
use serde::Deserialize;
use tower_http::trace::TraceLayer;
use utoipa::{IntoParams, OpenApi};

const DEFAULT_LIMIT: u32 = 100;
const MAXIMUM_LIMIT: u32 = 500_000;

#[derive(Clone)]
pub struct ApiState {
    pub products: ProductService,
}

#[derive(OpenApi)]
#[openapi(paths(list_products), components(schemas(ProductResponse)))]
pub struct ApiDoc;

#[derive(Debug, Deserialize, IntoParams)]
#[into_params(parameter_in = Query)]
struct ListProductsQuery {
    limit: Option<String>,
    offset: Option<u32>,
}

pub fn router(state: ApiState) -> Router {
    Router::new()
        .route("/api/products", get(list_products))
        .route("/api/openapi.json", get(openapi))
        .with_state(state)
        .layer(TraceLayer::new_for_http())
}

#[utoipa::path(
    get,
    path = "/api/products",
    params(ListProductsQuery),
    responses(
        (status = 200, description = "A product batch", body = [ProductResponse]),
        (status = 400, description = "Invalid pagination parameters"),
        (status = 500, description = "Storage error")
    )
)]
async fn list_products(
    State(state): State<ApiState>,
    Query(query): Query<ListProductsQuery>,
) -> Result<Json<Vec<ProductResponse>>, ApiError> {
    let limit = match query.limit.as_deref() {
        None => Some(DEFAULT_LIMIT),
        Some(value) if value.eq_ignore_ascii_case("none") => None,
        Some(value) => match value.parse::<u32>() {
            Ok(value) if (1..=MAXIMUM_LIMIT).contains(&value) => Some(value),
            _ => {
                return Err(ApiError::BadRequest(format!(
                    "The limit must be 'none' or a number between 1 and {MAXIMUM_LIMIT}."
                )));
            }
        },
    };

    Ok(Json(
        state
            .products
            .list_products(limit, query.offset.unwrap_or(0))
            .await?,
    ))
}

async fn openapi() -> Json<utoipa::openapi::OpenApi> {
    Json(ApiDoc::openapi())
}

enum ApiError {
    Application(ApplicationError),
    BadRequest(String),
}

impl From<ApplicationError> for ApiError {
    fn from(value: ApplicationError) -> Self {
        Self::Application(value)
    }
}
impl IntoResponse for ApiError {
    fn into_response(self) -> axum::response::Response {
        match self {
            Self::Application(error) => {
                tracing::error!(%error, "request failed");
                (
                    StatusCode::INTERNAL_SERVER_ERROR,
                    Json(serde_json::json!({ "error": "Unable to load products" })),
                )
                    .into_response()
            }
            Self::BadRequest(error) => (
                StatusCode::BAD_REQUEST,
                Json(serde_json::json!({ "error": error })),
            )
                .into_response(),
        }
    }
}

#[cfg(test)]
mod tests {
    use async_trait::async_trait;
    use axum::body::{Body, to_bytes};
    use http::{Request, StatusCode};
    use orbis_application::ProductRepository;
    use orbis_core::Product;
    use std::sync::Arc;
    use tower::ServiceExt;

    use super::*;

    struct MemoryRepository;
    #[async_trait]
    impl ProductRepository for MemoryRepository {
        async fn list(
            &self,
            limit: Option<u32>,
            offset: u32,
        ) -> Result<Vec<Product>, ApplicationError> {
            let products = vec![
                Product::new(1, "PROD-001", "Keyboard", 25).unwrap(),
                Product::new(2, "PROD-002", "Mouse", 42).unwrap(),
                Product::new(3, "PROD-003", "Dock", 12).unwrap(),
            ];
            let products = products.into_iter().skip(offset as usize);
            Ok(match limit {
                Some(limit) => products.take(limit as usize).collect(),
                None => products.collect(),
            })
        }
    }

    #[tokio::test]
    async fn products_endpoint_returns_json() {
        let app = router(ApiState {
            products: ProductService::new(Arc::new(MemoryRepository)),
        });
        let response = app
            .oneshot(Request::get("/api/products").body(Body::empty()).unwrap())
            .await
            .unwrap();
        assert_eq!(response.status(), StatusCode::OK);
        let bytes = to_bytes(response.into_body(), 1024).await.unwrap();
        let products: Vec<ProductResponse> = serde_json::from_slice(&bytes).unwrap();
        assert_eq!(products[0].reference, "PROD-001");
    }

    #[tokio::test]
    async fn products_endpoint_applies_limit_and_offset() {
        let app = router(ApiState {
            products: ProductService::new(Arc::new(MemoryRepository)),
        });
        let response = app
            .oneshot(
                Request::get("/api/products?limit=1&offset=1")
                    .body(Body::empty())
                    .unwrap(),
            )
            .await
            .unwrap();
        assert_eq!(response.status(), StatusCode::OK);
        let bytes = to_bytes(response.into_body(), 1024).await.unwrap();
        let products: Vec<ProductResponse> = serde_json::from_slice(&bytes).unwrap();
        assert_eq!(products.len(), 1);
        assert_eq!(products[0].reference, "PROD-002");
    }

    #[tokio::test]
    async fn products_endpoint_accepts_no_limit() {
        let app = router(ApiState {
            products: ProductService::new(Arc::new(MemoryRepository)),
        });
        let response = app
            .oneshot(
                Request::get("/api/products?limit=none")
                    .body(Body::empty())
                    .unwrap(),
            )
            .await
            .unwrap();
        assert_eq!(response.status(), StatusCode::OK);
        let bytes = to_bytes(response.into_body(), 1024).await.unwrap();
        let products: Vec<ProductResponse> = serde_json::from_slice(&bytes).unwrap();
        assert_eq!(products.len(), 3);
    }
}

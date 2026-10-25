use axum::Router;
use orbis_api::ApiState;

pub fn router(state: ApiState) -> Router {
    orbis_api::router(state)
}

use orbis_application::ProductService;
use orbis_ui::product_table;
use topcoat::{
    Result,
    context::{Cx, app_context},
    router::{Router, page},
    view::{View, view},
};

const PAGE_SIZE: u32 = 100;

pub fn router(products: ProductService) -> Router {
    Router::builder()
        .app_context(products)
        .page(inventory)
        .build()
}

#[page("/")]
pub async fn inventory(cx: &Cx) -> Result<impl View> {
    let products = app_context::<ProductService>(cx)
        .list_products(Some(PAGE_SIZE), 0)
        .await?;

    Ok(view! {
        <!DOCTYPE html>
        <html lang="en">
            <head>
                <meta charset="utf-8">
                <meta name="viewport" content="width=device-width, initial-scale=1">
                <meta name="description" content="Orbis ERP product inventory">
                <link
                    href="https://cdn.jsdelivr.net/npm/bootstrap@6.0.0-alpha.1/dist/css/bootstrap.min.css"
                    rel="stylesheet"
                    integrity="sha384-B/GM4XqrwHnWXNOWMbloTmrYXZg10cakYGmpfsR/bbzQ6JAJI4ihuyADKLnBgrCe"
                    crossorigin="anonymous"
                >
                <title>"Orbis - Product Inventory"</title>
            </head>
            <body class="bg-body-tertiary">
                <main class="container py-4 py-md-5">
                    <div class="d-flex flex-column flex-sm-row justify-content-between align-items-sm-center gap-3 mb-4">
                        <div>
                            <h1 class="display-6 mb-1">"Product Inventory"</h1>
                            <p class="text-body-secondary mb-0">
                                "Current stock across the Orbis catalogue"
                            </p>
                        </div>
                        <a class="btn btn-outline-primary" href="/">"Refresh"</a>
                    </div>
                    product_table(products: products)
                    <p class="small text-body-secondary mt-3 mb-0">
                        "Showing the first " (PAGE_SIZE) " products. Use the paginated API for larger result sets."
                    </p>
                </main>
            </body>
        </html>
    })
}

use orbis_contracts::ProductResponse;
use topcoat::{
    Result,
    view::{View, component, view},
};

#[component]
pub async fn product_table(products: Vec<ProductResponse>) -> Result<impl View> {
    Ok(view! {
        if products.is_empty() {
            <div class="alert alert-light border text-center py-4" role="status">
                "No products have been added yet."
            </div>
        } else {
            <div class="table-responsive border rounded shadow-sm">
                <table class="table table-hover align-middle mb-0">
                    <thead class="table-light">
                        <tr>
                            <th scope="col">"Reference"</th>
                            <th scope="col">"Name"</th>
                            <th scope="col">"Stock"</th>
                        </tr>
                    </thead>
                    <tbody>
                        for product in products {
                            <tr>
                                <td><code>(product.reference)</code></td>
                                <td>(product.name)</td>
                                <td>(product.stock)</td>
                            </tr>
                        }
                    </tbody>
                </table>
            </div>
        }
    })
}

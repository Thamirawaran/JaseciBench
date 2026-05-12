"""Catalog page: list categories + products."""

sv import from ..services.catalog { list_categories, list_products }
import from ..components.ProductCard { ProductCard }


def:pub CatalogPage() -> JsxElement {
    has categories: list = [];
    has products: list = [];
    has loading: bool = True;
    has selected_cat: str = "";

    async def select_category(cat_id: str) -> None {
        selected_cat = cat_id;
        loading = True;
        prods_result = await list_products(cat_id);
        products = prods_result if prods_result else [];
        loading = False;
    }

    async can with entry {
        cats_result = await list_categories();
        categories = cats_result if cats_result else [];
        await select_category("");
    }

    def all_click(e: MouseEvent) -> None {
        select_category("");
    }

    def cat_click(cat_id: str) -> Any {
        def handler(e: MouseEvent) -> None {
            select_category(cat_id);
        }
        return handler;
    }

    btn_base: str = "px-3 py-1.5 rounded-full text-sm border ";
    btn_active: str = "bg-gray-900 text-white border-gray-900";
    btn_inactive: str = "bg-white text-gray-700 border-gray-300 hover:bg-gray-50";

    return <div className="max-w-6xl mx-auto px-6 py-8">
        <div className="mb-8">
            <h1 className="text-3xl font-bold text-gray-900 tracking-tight">Catalog</h1>
            <p className="text-gray-600 mt-1">Browse our products by category.</p>
        </div>

        <div className="flex flex-wrap gap-2 mb-6">
            <button
                className={btn_base + (btn_active if selected_cat == "" else btn_inactive)}
                onClick={all_click}
                type="button"
            >All</button>
            {[<button
                key={c["id"]}
                className={btn_base + (btn_active if selected_cat == c["id"] else btn_inactive)}
                onClick={cat_click(c["id"])}
                type="button"
            >{c["name"] + " (" + str(c["product_count"]) + ")"}</button> for c in categories]}
        </div>

        {(<p className="text-gray-500">Loading...</p>) if loading else None}
        {(<div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-4">
            {[<ProductCard key={p["id"]} product={p} /> for p in products]}
        </div>) if not loading else None}
        {(<p className="text-gray-500 text-center py-12">No products in this category.</p>) if not loading and len(products) == 0 else None}
    </div>;
}

"""Search page: search products by query."""

sv import from ..services.catalog { list_categories, search_products }
import from ..components.ProductCard { ProductCard }


def:pub SearchPage() -> JsxElement {
    has query: str = "";
    has results: list = [];
    has searching: bool = False;
    has searched: bool = False;

    has categories: list = [];
    has category_id: str = "";

    has min_price_text: str = "";
    has max_price_text: str = "";

    use_effect(lambda {
        async def load() -> None {
            cats = await list_categories();
            categories = cats if cats else [];
        }
        load();
    }, []);

    async def do_search(e: FormEvent) -> None {
        e.preventDefault();

        min_p = float(min_price_text) if min_price_text.strip() else 0.0;
        max_p = float(max_price_text) if max_price_text.strip() else 0.0;

        searching = True;
        result = await search_products(query, category_id, min_p, max_p);
        results = result if result else [];
        searching = False;
        searched = True;
    }

    return <div className="max-w-6xl mx-auto px-6 py-8">
        <h1 className="text-3xl font-bold text-gray-900 mb-6">Search Products</h1>

        <form onSubmit={do_search} className="flex flex-col gap-3 mb-8">
            <div className="flex gap-2">
                <input
                    type="text"
                    value={query}
                    onChange={lambda e: ChangeEvent { query = e.target.value; }}
                    placeholder="Try 'shirt', 'coffee', 'wireless'..."
                    className="flex-1 px-4 py-2.5 border border-gray-300 rounded-lg focus:outline-none focus:border-indigo-600 focus:ring-2 focus:ring-indigo-100"
                />
                <button
                    type="submit"
                    className="px-6 py-2.5 bg-indigo-600 hover:bg-indigo-700 text-white font-semibold rounded-lg"
                >
                    Search
                </button>
            </div>

            <div className="grid grid-cols-1 sm:grid-cols-3 gap-2">
                <select
                    value={category_id}
                    onChange={lambda e: ChangeEvent { category_id = e.target.value; }}
                    className="px-4 py-2.5 border border-gray-300 rounded-lg bg-white focus:outline-none focus:border-indigo-600 focus:ring-2 focus:ring-indigo-100"
                >
                    <option value="">All categories</option>
                    {[
                        <option key={c["id"]} value={c["id"]}>{c["name"]}</option>
                        for c in categories
                    ]}
                </select>

                <input
                    type="text"
                    value={min_price_text}
                    onChange={lambda e: ChangeEvent { min_price_text = e.target.value; }}
                    placeholder="Min price"
                    className="px-4 py-2.5 border border-gray-300 rounded-lg focus:outline-none focus:border-indigo-600 focus:ring-2 focus:ring-indigo-100"
                />

                <input
                    type="text"
                    value={max_price_text}
                    onChange={lambda e: ChangeEvent { max_price_text = e.target.value; }}
                    placeholder="Max price"
                    className="px-4 py-2.5 border border-gray-300 rounded-lg focus:outline-none focus:border-indigo-600 focus:ring-2 focus:ring-indigo-100"
                />
            </div>
        </form>

        {(<p className="text-gray-500">Searching...</p>) if searching else None}

        {(
            <p className="text-gray-600">
                No products match "{query}".
            </p>
        ) if searched and (not searching) and (len(results) == 0) else None}

        {(
            <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-4">
                {[<ProductCard key={p["id"]} product={p} /> for p in results]}
            </div>
        ) if len(results) > 0 else None}
    </div>;
}

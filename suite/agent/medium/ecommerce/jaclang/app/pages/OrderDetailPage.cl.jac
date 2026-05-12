"""Order detail page: view one order, items, payments, cancel."""

import from "@jac/runtime" { Link, useParams }
sv import from ..services.orders { get_order, cancel_order }


def money(v: Any) -> str {
    if v is None {
        return "$0.00";
    }
    return "$" + str(v);
}


def:pub OrderDetailPage() -> JsxElement {
    params = useParams();
    oid = params["id"];

    has order: Any = None;
    has loading: bool = True;

    async def refresh() -> None {
        result = await get_order(oid);
        order = result;
        loading = False;
    }

    async can with entry {
        await refresh();
    }

    async def do_cancel(e: MouseEvent) -> None {
        await cancel_order(oid);
        await refresh();
    }

    if loading {
        return <div className="max-w-4xl mx-auto px-6 py-12 text-gray-500">Loading...</div>;
    }

    if not order {
        return <div className="max-w-4xl mx-auto px-6 py-8">
            <div className="mb-6">
                <Link to="/orders" className="text-sm text-gray-700 hover:underline">← Back to orders</Link>
            </div>
            <h1 className="text-2xl font-bold text-gray-900">Order not found</h1>
        </div>;
    }

    items = order["items"] if "items" in order else [];
    payments = order["payments"] if "payments" in order else [];
    grand_total = order["total"] if "total" in order else 0.0;

    return <div className="max-w-4xl mx-auto px-6 py-8">
        <div className="mb-6 flex items-center justify-between gap-4">
            <Link to="/orders" className="text-sm text-gray-700 hover:underline">← Back to orders</Link>
            {(<button
                onClick={do_cancel}
                className="text-xs rounded-lg bg-red-600 px-3 py-2 text-white hover:bg-red-700"
            >Cancel</button>) if order["status"] == "pending" else None}
        </div>

        <h1 className="text-3xl font-bold text-gray-900">{"Order " + order["id"]}</h1>
        <div className="mt-2 text-sm text-gray-600">{"Status: " + order["status"]}</div>

        <div className="mt-6 rounded-xl border border-gray-200 bg-white p-4">
            <div className="text-sm font-semibold text-gray-900">Shipping</div>
            <div className="mt-2 text-sm text-gray-700">
                {order["shipping_address1"]}
                {(", " + order["shipping_address2"]) if order["shipping_address2"] else ""}
            </div>
            <div className="text-sm text-gray-700">
                {order["shipping_city"] + ", " + order["shipping_state"] + " " + order["shipping_zip"]}
            </div>
        </div>

        <div className="mt-6">
            <div className="text-sm font-semibold text-gray-900 mb-2">Items</div>
            <div className="space-y-2">
                {[<div key={it["id"]} className="rounded-xl border border-gray-200 bg-white p-4">
                    <div className="flex items-start justify-between gap-4">
                        <div className="min-w-0">
                            <div className="text-sm font-medium text-gray-900">{it["variant_id"]}</div>
                            <div className="text-xs text-gray-500 mt-1">{"Qty: " + str(it["quantity"])}</div>
                            <div className="text-xs text-gray-500">{"Price: " + money(it["price_snapshot"])}</div>
                        </div>
                        <div className="text-sm font-semibold text-gray-900">{money(it["subtotal"])}</div>
                    </div>
                </div> for it in items]}
            </div>

            <div className="mt-4 flex items-center justify-end">
                <div className="text-base font-bold text-gray-900">{"Grand total: " + money(grand_total)}</div>
            </div>
        </div>

        <div className="mt-8">
            <div className="text-sm font-semibold text-gray-900 mb-2">Payments</div>
            {(<div className="text-sm text-gray-500">No payments recorded.</div>) if len(payments) == 0 else None}
            <div className="space-y-2">
                {[<div key={p["id"]} className="rounded-xl border border-gray-200 bg-white p-4">
                    <div className="flex items-start justify-between gap-4">
                        <div className="min-w-0">
                            <div className="text-sm font-medium text-gray-900">{p["transaction_type"]}</div>
                            <div className="text-xs text-gray-500 mt-1">{p["created_at"]}</div>
                        </div>
                        <div className="text-sm font-semibold text-gray-900">{money(p["amount"])}</div>
                    </div>
                </div> for p in payments]}
            </div>
        </div>
    </div>;
}
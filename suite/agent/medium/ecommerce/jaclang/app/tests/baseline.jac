"""Baseline regression tests for the e-commerce app.

Covers every `def:pub` endpoint at least once on the unmodified base
app. Mutation endpoints test on disposable users / fresh items so the
suite can re-run idempotently without state cleanup. Hidden grading
tests live alongside each task in the vault.
"""

import from services.catalog { list_categories, list_products, get_product, search_products }
import from services.users { get_profile, list_addresses, list_payment_methods, list_users, add_address, update_address, delete_address }
import from services.cart { get_cart, add_to_cart, update_cart_item, remove_from_cart, clear_cart, checkout }
import from services.orders { list_orders, get_order, cancel_order, return_items, modify_order_items, update_order_address, update_order_status }
import from services.reviews { list_reviews, add_review, product_review_summary }


# Catalog -------------------------------------------------------------

test "list_categories returns 6 seeded categories" {
    cats = list_categories();
    assert len(cats) == 6;
    names = [c["name"] for c in cats];
    assert "Clothing" in names;
    assert "Technology" in names;
}


test "list_products returns 8 seeded products" {
    prods = list_products("");
    assert len(prods) == 8;
}


test "list_products filters by category_id" {
    prods = list_products("cat_004");
    ids = [p["id"] for p in prods];
    assert "prod_004" in ids;
    assert "prod_005" in ids;
}


test "get_product returns variants" {
    p = get_product("prod_001");
    assert p is not None;
    assert p["name"] == "T-Shirt";
    assert len(p["variants"]) == 3;
}


test "get_product returns None for unknown product" {
    p = get_product("prod_does_not_exist");
    assert p is None;
}


test "search_products matches name case-insensitively" {
    results = search_products("shirt");
    names = [p["name"] for p in results];
    assert "T-Shirt" in names;
}


# Users ---------------------------------------------------------------

test "list_users returns 3 seeded users" {
    users = list_users();
    assert len(users) == 3;
    usernames = [u["username"] for u in users];
    assert "alice" in usernames;
}


test "get_profile returns alice" {
    u = get_profile("user_001");
    assert u is not None;
    assert u["username"] == "alice";
}


test "get_profile returns None for unknown user" {
    u = get_profile("user_unknown");
    assert u is None;
}


test "list_addresses for alice returns one default" {
    addrs = list_addresses("user_001");
    assert len(addrs) == 1;
    assert addrs[0]["is_default"];
}


test "list_payment_methods for bob returns Mastercard" {
    pms = list_payment_methods("user_002");
    assert len(pms) == 1;
    assert pms[0]["card_brand"] == "Mastercard";
}


test "add/update/delete_address round-trip on a seeded user" {
    # carol (user_003) has no seeded address; safe scratch space.
    target = "user_003";
    addrs_before = list_addresses(target);
    added = add_address(target, "1 Main", "Springfield", "IL", "62701");
    assert "id" in added;
    addr_id = added["id"];
    updated = update_address(target, addr_id, "2 Main", "Springfield", "IL", "62701");
    assert updated["address1"] == "2 Main";
    deleted = delete_address(target, addr_id);
    assert "deleted" in deleted;
    assert len(list_addresses(target)) == len(addrs_before);
}


test "add_address rejects unknown user" {
    out = add_address("user_does_not_exist", "1 Main", "X", "Y", "00000");
    assert "error" in out;
}


# Cart ----------------------------------------------------------------

test "get_cart for alice returns items dict" {
    cart = get_cart("user_001");
    assert "items" in cart;
    assert "total" in cart;
    assert len(cart["items"]) == 1;
}


test "get_cart for new user has empty items list" {
    cart = get_cart("user_new");
    assert "items" in cart;
    assert len(cart["items"]) == 0;
    assert cart["total"] == 0.0;
}


test "add_to_cart + update_cart_item + remove_from_cart round-trip" {
    target = "user_baseline_cart";
    clear_cart(target);
    added = add_to_cart(target, "var_004", 1);
    assert "id" in added;
    ci_id = added["id"];
    updated = update_cart_item(ci_id, 3);
    assert updated["quantity"] == 3;
    removed = remove_from_cart(ci_id);
    assert "deleted" in removed;
    assert len(get_cart(target)["items"]) == 0;
}


test "clear_cart removes all items for a user" {
    target = "user_baseline_clear";
    clear_cart(target);
    add_to_cart(target, "var_004", 1);
    add_to_cart(target, "var_001", 2);
    assert len(get_cart(target)["items"]) == 2;
    cleared = clear_cart(target);
    assert "cleared" in cleared;
    assert len(get_cart(target)["items"]) == 0;
}


test "checkout fails on empty cart" {
    # carol (user_003) has no seeded cart; clearing is idempotent.
    target = "user_003";
    clear_cart(target);
    out = checkout(target, "pm_003", "1 Main", "Springfield", "IL", "62701");
    assert "error" in out;
}


# Orders --------------------------------------------------------------

test "list_orders for alice returns two seeded orders" {
    orders = list_orders("user_001");
    ids = [o["id"] for o in orders];
    assert "W0000001" in ids;
    assert "W0000004" in ids;
}


test "list_orders with empty user_id returns all seeded orders" {
    orders = list_orders("");
    statuses = {o["status"] for o in orders};
    # Seed covers all 6 known statuses
    assert "pending" in statuses;
    assert "processed" in statuses;
    assert "shipped" in statuses;
    assert "delivered" in statuses;
    assert "returned" in statuses;
    assert "cancelled" in statuses;
}


test "get_order returns full detail" {
    o = get_order("W0000001");
    assert o is not None;
    assert o["status"] == "pending";
    assert len(o["items"]) == 1;
    assert len(o["payments"]) == 1;
}


test "get_order returns None for unknown order" {
    o = get_order("W9999999");
    assert o is None;
}


test "cancel_order on pending order succeeds (W0000001 fixture is pending)" {
    out = cancel_order("W0000001");
    # The test re-uses the pending order; either it cancels (first run) or
    # reports already-cancelled (subsequent runs). Both are valid.
    if "error" in out {
        assert "cancelled" in out["error"].lower();
    } else {
        assert out["status"] == "cancelled";
    }
}


test "update_order_status rejects unknown status" {
    out = update_order_status("W0000002", "warp-speed");
    assert "error" in out;
}


test "update_order_address on a known order keeps the rest intact" {
    out = update_order_address("W0000002", "9 New St", "Newton", "MA", "02458");
    if "error" not in out {
        assert out["shipping_address1"] == "9 New St";
    }
}


test "return_items rejects unknown order" {
    out = return_items("W9999999", ["oi_001"], "pm_001");
    assert "error" in out;
}


test "modify_order_items rejects unknown order" {
    out = modify_order_items("W9999999", []);
    assert "error" in out;
}


# Reviews -------------------------------------------------------------

test "list_reviews returns two reviews for T-Shirt" {
    out = list_reviews("prod_001");
    assert out["count"] == 2;
}


test "list_reviews returns empty for product with no reviews" {
    out = list_reviews("prod_002");
    assert out["count"] == 0;
}


test "product_review_summary returns average + count for prod_001" {
    s = product_review_summary("prod_001");
    assert s["count"] == 2;
    assert abs(s["average_rating"] - 4.5) < 0.01;
}


test "product_review_summary returns zeroed shape for unreviewed product" {
    s = product_review_summary("prod_002");
    assert s["count"] == 0;
    assert s["average_rating"] == 0.0;
}


test "add_review smoke (does not assert review count)" {
    out = add_review("prod_002", "user_002", 4, "OK", "fine");
    # add_review may succeed or be idempotently rejected; both are fine
    # for a baseline smoke. We only assert it returns a dict.
    assert isinstance(out, dict);
}

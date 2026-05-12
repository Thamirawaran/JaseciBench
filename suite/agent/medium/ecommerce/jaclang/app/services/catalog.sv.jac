"""Catalog service: categories, products, variants, search."""

import from models { Category, Product, Variant, Review }
import from seed { seed_catalog }


def ensure_seeded() -> None {
    if not [root() -->][?:Category] {
        seed_catalog();
    }
}


def category_dict(c: Category) -> dict {
    return {
        "id": c.id,
        "name": c.name,
        "description": c.description,
    };
}


def variant_dict(v: Variant) -> dict {
    return {
        "id": v.id,
        "price": v.price,
        "color": v.color,
        "size": v.size,
        "material": v.material,
        "stock_qty": v.stock_qty,
    };
}


def product_dict(p: Product, include_variants: bool = True) -> dict {
    if not include_variants {
        return {
            "id": p.id,
            "name": p.name,
            "description": p.description,
            "category_id": p.category_id,
            "active": p.active,
        };
    }
    variants = [variant_dict(v) for v in [p -->][?:Variant]];
    return {
        "id": p.id,
        "name": p.name,
        "description": p.description,
        "category_id": p.category_id,
        "active": p.active,
        "variants": variants,
    };
}


def find_variant(variant_id: str) -> Variant | None {
    for p in [root() -->][?:Product] {
        for v in [p -->][?:Variant] {
            if v.id == variant_id {
                return v;
            }
        }
    }
    return None;
}


def find_product(product_id: str) -> Product | None {
    for p in [root() -->][?:Product] {
        if p.id == product_id {
            return p;
        }
    }
    return None;
}


def:pub list_categories() -> list[dict] {
    ensure_seeded();
    return [category_dict(c) for c in [root() -->][?:Category]];
}


def:pub list_products(category_id: str = "") -> list[dict] {
    ensure_seeded();
    products = [root() -->][?:Product];
    return [product_dict(p) for p in products if p.active];
}


def:pub get_product(product_id: str) -> dict | None {
    ensure_seeded();
    p = find_product(product_id);
    if p is None {
        return None;
    }
    if not p.active {
        return None;
    }
    return product_dict(p);
}


def:pub search_products(q: str) -> list[dict] {
    ensure_seeded();
    if not q {
        return [];
    }
    q_lower = q.lower();
    matches = [];
    for p in [root() -->][?:Product] {
        if not p.active {
            continue;
        }
        if q_lower in p.name.lower() or q_lower in p.description.lower() {
            matches.append(product_dict(p));
        }
    }
    return matches;
}


def:pub update_variant_price(variant_id: str, new_price: float) -> dict {
    ensure_seeded();

    if new_price < 0 {
        return {"error": "new_price must be >= 0", "status": 400};
    }

    v = find_variant(variant_id);
    if v is None {
        return {"error": "variant not found", "status": 404};
    }

    v.price = new_price;
    return variant_dict(v);
}


def:pub deactivate_product(product_id: str) -> dict {
    ensure_seeded();

    p = find_product(product_id);
    if p is None {
        return {"error": "product not found", "status": 404};
    }

    p.active = False;
    return product_dict(p);
}


def:pub low_stock_products(threshold: int) -> list[dict] {
    ensure_seeded();

    if threshold < 0 {
        return [];
    }

    low_stock = [];
    for p in [root() -->][?:Product] {
        if not p.active {
            continue;
        }
        for v in [p -->][?:Variant] {
            if v.stock_qty < threshold {
                low_stock.append(product_dict(p));
                break;
            }
        }
    }

    return low_stock;
}


def:pub product_count() -> int {
    ensure_seeded();
    total = 0;
    for p in [root() -->][?:Product] {
        if p.active {
            total += 1;
        }
    }
    return total;
}


def:pub average_product_price() -> float {
    ensure_seeded();

    total = 0.0;
    count = 0;

    for p in [root() -->][?:Product] {
        if not p.active {
            continue;
        }
        for v in [p -->][?:Variant] {
            total += v.price;
            count += 1;
        }
    }

    if count == 0 {
        return 0.0;
    }
    return total / count;
}


def:pub products_without_reviews() -> list[dict] {
    ensure_seeded();

    no_review_products = [];
    for p in [root() -->][?:Product] {
        if not p.active {
            continue;
        }

        has_review = False;
        for r in [root() -->][?:Review] {
            if r.product_id == p.id {
                has_review = True;
                break;
            }
        }

        if not has_review {
            no_review_products.append(product_dict(p));
        }
    }

    return no_review_products;
}

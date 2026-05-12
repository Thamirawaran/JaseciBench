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
    variants_nodes = [p -->][?:Variant];
    total_stock = sum([v.stock_qty for v in variants_nodes]);

    if not include_variants {
        return {
            "id": p.id,
            "name": p.name,
            "description": p.description,
            "category_id": p.category_id,
            "active": p.active,
            "total_stock": total_stock,
        };
    }

    variants = [variant_dict(v) for v in variants_nodes];
    return {
        "id": p.id,
        "name": p.name,
        "description": p.description,
        "category_id": p.category_id,
        "active": p.active,
        "total_stock": total_stock,
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


def:pub top_rated_products(limit: int = 10) -> list[dict] {
    ensure_seeded();

    scored = [];
    for p in [root() -->][?:Product] {
        if not p.active {
            continue;
        }
        reviews = [r for r in [p -->][?:Review]];
        avg = 0.0;
        if reviews {
            avg = sum([r.rating for r in reviews]) / len(reviews);
        }
        scored.append({"avg": avg, "product": product_dict(p)});
    }

    scored.sort(key=lambda(x: dict) -> float { return x["avg"]; }, reverse=True);
    return [x["product"] for x in scored][:limit];
}

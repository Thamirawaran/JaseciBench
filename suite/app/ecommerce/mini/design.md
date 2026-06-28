---
id: ecommerce-mini
title: Mini E-Commerce
version: 0.1
archetype: multi-entity-workflow
holdout: false
---

# Mini E-Commerce

## 2. Summary
Build a small e-commerce web application. A visitor can browse a fixed product
catalogue, register an account, log in, add product variants to a personal cart,
and check out. Checkout must create a persisted order that the user can see later
in their order history. The single core workflow that must work end to end is:
**register -> log in -> add to cart -> checkout -> the order is persisted and
appears in order history.** Each user sees only their own cart and orders.

The deliverable is **full-stack**: a working browser UI for the core flows
(catalogue, product, cart, checkout, order history, plus register/login screens)
backed by the API and persistent storage. The UI is exercised by the interaction
journeys, so it must actually function, not merely render.

## 3. Domain Model
Stack-neutral records. Types: `id`, `string`, `int`, `float`, `bool`, `datetime`.

- **User**: `id`, `email` (unique), `password` (stored hashed, never returned),
  `created_at`. A user has many CartItems and many Orders.
- **Product**: `id`, `name`, `description`, `active` (bool). A product has many
  Variants.
- **Variant**: `id`, `product_id`, `price` (float), `color` (string),
  `size` (string), `stock_qty` (int). Belongs to one Product.
- **CartItem**: `id`, `user_id`, `variant_id`, `quantity` (int >= 1). Belongs to
  one User and references one Variant.
- **Order**: `id`, `user_id`, `total` (float), `status` (string; `placed` on
  creation), `created_at`. Belongs to one User and has many OrderItems.
- **OrderItem**: `id`, `order_id`, `variant_id`, `quantity` (int),
  `unit_price` (float, copied from the variant at checkout time).

## 4. Roles and Auth
- Roles: `guest` (unauthenticated) and `user` (authenticated).
- Auth uses your **stack's native mechanism** (see your stack guide): a user can
  register and log in, and after logging in is recognised on subsequent requests.
  You do not have to invent a cross-stack token scheme; implement auth the
  idiomatic way for your stack. The harness authenticates through that mechanism
  via the adapter, so register and log in are **not** domain contract operations.
- Credentials must be handled securely by that mechanism: never stored in
  plaintext, never returned in any response.
- Data isolation: a `user` can read and modify **only their own** cart and orders.
  A `guest` may browse the catalogue but cannot touch a cart, checkout, or orders.

## 5. Functional Requirements
1. A guest can list all active products in the catalogue. *(no deps)*
2. A guest can view a single product, including its variants. *(requires 1)*
3. A guest can register with email and password and receive an account, using the
   stack's native auth mechanism. *(no deps)*
4. A registered user can log in and is then recognised on protected requests. *(requires 3)*
5. A logged-in user can view their cart (empty on a new account). *(requires 4)*
6. A logged-in user can add a product variant to their cart with a quantity. *(requires 4, and a seeded catalogue)*
7. A logged-in user can remove a variant from their cart. *(requires 6)*
8. The cart is per-user: user A never sees user B's cart contents. *(requires 6)*
9. A logged-in user can check out a non-empty cart, which creates a persisted
   order whose `total` equals the sum of variant price times quantity, sets
   status `placed`, snapshots each line's `unit_price`, and empties the cart. *(requires 6)*
10. A logged-in user can list their own orders and view one order with its items. *(requires 9)*
11. Protected operations (cart, checkout, orders) reject requests with no/invalid
    token using HTTP 401. *(requires 4)*
12. *(preference)* Input validation: adding a variant with quantity < 1, or an
    unknown variant id, is rejected with HTTP 400, not a 500.
13. *(preference)* Checkout of an empty cart is rejected with HTTP 400.
14. *(preference)* The product list supports `limit` and `offset` query params.
15. *(preference)* The server publishes its OpenAPI document and a health route.

## 6. API Contract
Implement every **domain** operation in [`contract/openapi.yaml`](contract/openapi.yaml).
The per-stack adapter (`adapters/<your-stack>.json`) tells you and the harness the
exact route for each. Registration and login are **not** in this list: they use
your stack's native auth (section 4) and are handled by the adapter, not by a
shared contract endpoint. Operations marked *(auth)* require a logged-in user.

| operationId | Purpose |
|---|---|
| `list_products` | List active products (supports `limit`/`offset`). |
| `get_product` | Get one product with its variants. |
| `get_cart` *(auth)* | Return the current user's cart and total. |
| `add_to_cart` *(auth)* | Add a variant + quantity to the current user's cart. |
| `remove_from_cart` *(auth)* | Remove a variant from the current user's cart. |
| `checkout` *(auth)* | Create a persisted order from the cart; empty the cart. |
| `list_orders` *(auth)* | List the current user's orders. |
| `get_order` *(auth)* | Get one of the current user's orders with items. |
| `health` | Liveness check (returns 200 when the app is up). |

## 7. Seed Data
Every build must start from exactly this catalogue (so all stacks and runs are
identical). Seeding must be idempotent.

```yaml
products:
  - id: p1
    name: "Classic Tee"
    description: "Cotton t-shirt"
    active: true
    variants:
      - { id: v1, price: 19.99, color: black, size: M, stock_qty: 50 }
      - { id: v2, price: 19.99, color: white, size: L, stock_qty: 30 }
  - id: p2
    name: "Canvas Cap"
    description: "Adjustable cap"
    active: true
    variants:
      - { id: v3, price: 14.50, color: navy, size: OS, stock_qty: 100 }
  - id: p3
    name: "Retired Hoodie"
    description: "Discontinued line"
    active: false
    variants:
      - { id: v4, price: 39.00, color: grey, size: M, stock_qty: 0 }
```
Note: `list_products` returns only **active** products (p1, p2), but `get_product`
can return an inactive product by id.

## 8. Non-Functional Requirements
- **Latency**: `list_products` and `get_cart` respond within 300 ms p95 under a
  light load (a handful of concurrent users) on the reference sandbox.
- **Security**: credentials handled securely by the stack's auth mechanism (never
  plaintext, never returned); protected operations enforce authentication (FR 11);
  no secrets committed in source.
- **Accessibility**: the catalogue page targets a Lighthouse accessibility score
  of at least 80.

## 8b. UI Contract (data-testid)

The delivered app must include a browsable UI for the core flow, and that UI must
expose these stable `data-testid` attributes so automated user-journeys can drive
it (the UI counterpart of the API contract):

- **Auth screen**: a logged-out visitor must land on (or be able to reach in one
  obvious step) a single auth view that exposes `email`, `password`, `signup`, and
  `login` together. The journey signs up and then logs in from this one screen, so
  these four controls must coexist on the logged-out auth view, not be split across
  separate, separately-navigated pages. If the auth view is not the initial page,
  the entry point to it must itself carry a `data-testid` of `nav-login`.
- `email`, `password`: the credential inputs.
- `signup`, `login`: the auth buttons. `auth-msg`: a status line that reads
  `registered` after a successful sign up.
- `nav-catalogue`, `nav-cart`, `nav-orders`: navigation to each view (shown once
  logged in).
- `add-<variant_id>` (for example `add-v3`): the add-to-cart button on each
  variant in the catalogue.
- `cart-total`: an element whose text contains the cart total (for example
  `Total: $29`). `checkout`: the checkout button.
- `order-count`: text containing the number of orders (for example `Orders: 1`).
  `order-total`: an element per order whose text contains that order's total.

## 9. Out of Scope
No real payment gateway (checkout just records the order), no email, no admin
panel, no product search, no reviews, no shipping/address management. Building
these is neither required nor rewarded.

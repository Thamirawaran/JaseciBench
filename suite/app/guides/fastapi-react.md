# Stack Design Guide: FastAPI + React (full-stack) (v0.1)

Idioms only. Examples use a neutral toy `Widget` domain, never a task's entities.
Fill order and depth match `GUIDE_TEMPLATE.md`. This is a **full-stack** column:
a FastAPI/SQLAlchemy backend plus a React frontend, so it is comparable to Jac's
full-stack delivery (UI + API + persistence). The interaction layer drives the
React UI; the contract tests hit the FastAPI API.

## 1. Project layout
```
backend/
  app/
    main.py             # FastAPI() instance + route handlers (the API surface)
    models.py           # ORM models (the data model)
    schemas.py          # request/response shapes (pydantic)
    database.py         # engine, session, connection
    seed.py             # idempotent seeding of initial rows
  requirements.txt
frontend/
  src/
    main.tsx            # React entry / router mount
    pages/              # routed pages (catalogue, cart, orders, login)
    components/         # UI units
    api.ts              # typed client calling the FastAPI endpoints
  package.json
```

## 2. Data model and persistence
Entities are ORM models; relationships are foreign keys; persistence is a
relational database (SQLite is fine for a small app).
```python
class Widget(Base):
    __tablename__ = "widgets"
    id = Column(String, primary_key=True)
    name = Column(String, nullable=False)
    price = Column(Float, default=0.0)
```
Query: `db.query(Widget).all()`. Commit within a request-scoped session.

## 3. Defining an API operation
A server operation is a FastAPI route. Bind each contract `operationId` with
`operation_id=` so the harness can resolve it (see section 8). The React frontend
calls these over HTTP.
```python
@app.get("/widgets", operation_id="list_widgets")
def list_widgets(db: Session = Depends(get_db)):
    return {"items": [{"id": w.id, "name": w.name, "price": w.price}
                      for w in db.query(Widget).all()]}
```
On the React side, a typed fetch consumes it:
```ts
export const listWidgets = () => api.get("/widgets").then(r => r.data);
```
Signal non-200 with `raise HTTPException(status_code=400, ...)` per the contract.

## 4. Auth pattern
Auth is implemented by **your app** (this is the difference from Jac, where auth
is a runtime primitive). Issue a token on login, require it via a dependency, and
store credentials hashed.
```python
@app.post("/auth/login", operation_id="login")
def login(body: LoginIn, db: Session = Depends(get_db)):
    user = db.query(User).filter_by(email=body.email).first()
    if not user or not verify_pw(body.password, user.pw_hash):
        raise HTTPException(401, "invalid credentials")
    return {"token": issue_token(user.id)}
```
Scope data by resolving the token to a `user_id` in a dependency and filtering
queries by it. On the React side, store the token after login and send it as
`Authorization: Bearer <token>`; guard protected pages (redirect to `/login` when
no token). The harness performs login through the adapter's `auth` block, so
register/login are NOT domain contract operations.

## 5. Running and serving locally
```bash
# backend
pip install -r backend/requirements.txt
uvicorn app.main:app --host 127.0.0.1 --port 8000
# frontend (separate process / port)
cd frontend && npm install && npm run dev   # serves the UI, e.g. on port 5173
```
Backend health at `/health`; the harness polls it. The UI base URL (the React dev
or built server) is what the Playwright journeys drive.

## 6. Testing entry point
Backend tests run with `pytest`; UI builds with `npm run build`. The AppAgentEval
harness does not score on your unit tests: it hits the FastAPI API over HTTP for
the contract tests, and drives the React UI for the interaction journeys.

## 7. Build and deploy command
The sandbox builds and boots both tiers:
```bash
pip install -r backend/requirements.txt && uvicorn app.main:app --host 127.0.0.1 --port 8000 &
cd frontend && npm install && npm run build && npm run preview -- --host 127.0.0.1 --port 5173
```
Base image provides Python 3.12 and Node; no external volume mounts.

## 8. Adapter note
See `adapters/fastapi-react.json`. Two base URLs: `api_base_url` (FastAPI, for the
contract tests) and `app_base_url` (the React UI, for the journeys). Each
`operationId` maps to a REST `method`+`path`; set `operation_id=` on each route to
match. The `auth` block tells the harness to register and log in via your
`/auth/signup` and `/auth/login` and send the bearer token.

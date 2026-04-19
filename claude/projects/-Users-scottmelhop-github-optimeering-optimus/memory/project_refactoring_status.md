---
name: src/api refactoring status
description: Tracks what refactoring has been done and what remains in src/api
type: project
---

Refactoring of src/api is in progress on branch `convert-bazel`.

**Completed (committed):**
- Added `generate_api_app()` to `src/utilities/api/fastapi_entrypoint.py` — wraps `generate_app()` with the two standard API middlewares (`RaiseHttpErrorOnPostgresError`, `RaiseCursorErrorMiddleware`) applied automatically
- Added `run_api_service(file)` to `src/utilities/api/uvicorn_runner.py` — encapsulates the dirname(__file__) → uvicorn start logic
- All 10 api service `app.py` files updated to use `generate_api_app()`
- All 10 api service `__main__.py` files simplified to 3 lines using `run_api_service`

**Remaining suggestions (not yet implemented):**
1. `update_metrics.py` factory for markets/operations/operation_forecasts — these 3 files are nearly identical, can be replaced by a `create_update_metrics_router()` factory in `api/utilities/`. Weather's update_metrics stays separate (2 series tables, different column names).
2. Series GET query helper — `run_series_query(request, query_str, api_filter, db_username, metadata_fn)` to consolidate the 5-line repeated query execution pattern across ~6 series.py files.
3. `dest_area` formatting helper — small, only worth doing when touching markets/operations series files anyway.

**Why:** User asked to finish for now after completing the app.py/main.py consolidation.
**How to apply:** Pick up from suggestion #1 (update_metrics factory) next time the user wants to continue refactoring src/api.

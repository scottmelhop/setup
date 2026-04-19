---
name: improvement_opportunities
description: Code review findings from optimus migration — API, library, and testing improvements to address
type: project
---

Code review conducted 2026-03-30 after migrating all 13 API services + db_migration from optimus.

**Why:** These are real issues found in the migrated code, ranging from security (JWT bypass, breakpoint in prod) to performance (no connection pooling, migration overhead in tests).

**How to apply:** Prioritize P0 items first. Reference this list when planning sprints or during code cleanup passes.

## A) API Services

### P0
- **Debugger breakpoint in prod code** — bids/restoration_reserve/query_builder.py:162-164 has `breakpoint()` in except handler
- **Async/sync mismatch in UMM** — umm_util.py:246 `filter_umm_records` is sync but awaited from umm_route.py:98
- **No-op exception handler** — umm_util.py:230-231 catches Exception and re-raises without adding context

### P1
- **Direct psycopg usage in UMM** — umm_util.py:219 bypasses query_runners, manages own connections
- **Pydantic v1 `class Config:` pattern** — 5+ files (predictions schemas, weather schemas) should use `model_config = ConfigDict(...)`
- **update_metrics.py duplication** — 4 nearly identical files (markets, operations, operation_forecasts, weather) could be a factory function

### P2
- **Deprecated typing imports** — 27+ files use `typing.Optional/List/Dict` instead of Python 3.12+ builtins

## B) Libraries

### P0
- **No DB connection pooling** — optimeering_pg/query_runners.py creates new AsyncConnection per query; should use AsyncConnectionPool
- **JWT expiry verification disabled** — optimeering_auth/jwt_utils.py:36 has `"verify_exp": False`
- **Hardcoded Azure tenant ID** — azure_authentication.py:17 and jwt_utils.py:8; should read from env var
- **Token file race condition** — azure_authentication.py:49-51; concurrent processes can corrupt cache

### P1
- **No Redis connection pooling** — redis_client.py:24 creates new client per get_key() call
- **Timezone-naive datetime** — fastapi_dependencies.py:113-115 uses `datetime.now()` without tz
- **No proactive token refresh** — azure_authentication.py:57; should refresh within 5 min of expiry
- **Hardcoded OTEL endpoint** — otel/instrumentation.py:17; should use OTEL_EXPORTER_OTLP_ENDPOINT env var
- **Deprecated Pydantic json_encoders** — optimeering_base/pydantic_objects.py:18; migrate to field_serializer

### P2
- **Enums not using StrEnum** — documented_enum.py inherits from Enum; Python 3.12 has StrEnum
- **Incomplete enum descriptions** — some area enum values have None descriptions
- **Middleware ordering** — fastapi_entrypoint.py error middlewares added after telemetry; errors may not be traced

## C) Testing

### P0
- **Migration overhead** — 51 migrations run per test class (~20 classes = 1000+ runs); cache initialized DB template
- **No per-test DB cleanup** — tests within a class share state; should truncate tables in tearDown or use tx rollback
- **Missing `timeout = "long"`** — all requires-docker py_test targets need timeout attribute in BUILD.bazel

### P1
- **Missing error path tests:** limit > MAX_LIMIT_API, offset < 0, invalid series_id, expired cursor, partition CheckViolation, request disconnect
- **Hardcoded series_id assumptions** — tests assume id=1; breaks with ordering changes
- **Weak assertions** — many tests only check status_code without validating response shape

### P2
- **No conftest.py** — each test reimplements setup; shared fixtures would reduce boilerplate
- **Tests not parameterized** — e.g. markets triple-nested loop should be @pytest.mark.parametrize
- **LRU cache clearing via gc.get_objects()** — fragile and slow; use explicit registry
- **unittest.TestCase vs pytest** — migration would enable fixtures/parameterize/markers

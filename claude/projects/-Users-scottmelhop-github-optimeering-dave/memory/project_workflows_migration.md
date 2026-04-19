---
name: Workflows migration from optimus
description: Status and lessons from migrating optimus workflows to dave src/python/workflows/
type: project
---

All workflows from optimus are now migrated to `src/python/workflows/` in dave (merged 2026-04-03).

Completed workflows: fingrid (pilot), energinet, entsoe, met, nordpool, nve, statnett, svk, umm.

**Why:** Consolidating optimus monorepo into dave; each workflow becomes an independent OCI image.

**How to apply:** No more workflow migration work needed. Future workflow additions go directly into `src/python/workflows/<name>/`.

## Patterns established during migration

- One `py_test` per test file with `main=` set explicitly (required by aspect_rules_py when multiple srcs)
- Fake data sub-packages must be in test `srcs` via `glob(["tests/fake_data/**/*.py"])` in the `TEST_HELPERS` list
- Binary entrypoints (`__main_foo__.py`) excluded from `py_library` glob; added to test srcs directly when tests import from them
- `rioxarray` must be explicitly imported to register the `.rio` xarray accessor (even if listed as a dep)
- Module-level `os.environ["VAR"]` calls break test imports — use `os.environ.get("VAR", "")` with lazy client init
- `optipyclient` is third-party (due to `imports = [".."]`); needs blank line separating it from first-party imports in ruff isort

---
name: project_stack
description: Tech stack and monorepo structure for the dave repo
type: project
---

Bazel monorepo called "dave" at /Users/scottmelhop/github/optimeering/dave.

**Stack:** Bazel 7.4.1 + BzlMod (MODULE.bazel), rules_python 0.40.0, gazelle 0.40.0, rules_oci 2.0.0, aspect_bazel_lib 2.9.4, rules_uv 0.47.0.

**Layout:**
- `library/python/<name>/` — shared Python libraries
- `src/python/<app>/` — Python application binaries + OCI images

**Dependency management:** `requirements.in` → `bazel run //:requirements_lock.update` (uses uv_pip_compile) → `requirements_lock.txt` consumed by `pip.parse`.

**Python imports:** `--incompatible_default_to_explicit_init_py=false` so full workspace-relative paths work (e.g. `from library.python.greeting import greeting`).

**OCI:** distroless/python3-debian12 base; py_image_layer splits packages vs app for layer caching; oci_tarball target loads into Docker.

**Why:** User set up this monorepo structure from scratch in this conversation.

**How to apply:** When adding new libraries put them under library/python/, new apps under src/python/. Follow existing BUILD.bazel patterns.

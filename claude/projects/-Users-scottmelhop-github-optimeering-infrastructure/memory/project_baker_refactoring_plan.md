---
name: Baker & Jsonnet refactoring plan
description: Prioritized list of improvements to the Baker workflow, Jsonnet structure, and CI/CD pipeline for the infrastructure repo
type: project
---

Comprehensive improvement plan for Baker workflow and Jsonnet structure, analyzed 2026-03-24. Full documentation written to docs/kubernetes-setup.md.

**Why:** The current setup has ~50% code duplication across staging/production bake files, no CI validation, dual deployment paths (root/ vs bakerRoot/), and inconsistent patterns.

**How to apply:** Use this as a prioritized backlog when refactoring infrastructure. Items are ordered by impact.

## Priority 1 — Routing abstraction (unblocks everything else)

Create `kubernetes/lib/routing.libsonnet` that abstracts over Gateway API (staging) vs Ingress (production). Every app currently duplicates entire definition blocks because the networking backends have incompatible parameter shapes. A unified interface eliminates this.

## Priority 2 — Deduplicate bake files

Once routing is abstracted, merge each pair of staging/production `.bake.jsonnet` files into a single parameterized file. Affects: apis/, ui/, datascience/, infra-services/, system/. Eliminates ~450-500 lines of duplication.

## Priority 3 — CI pipeline

No `.github/workflows/` exists. Minimum viable: on PR run `./bake && make kubeconform` + `jsonnet-lint`. ~47% of commits are automated image tag bumps that could silently break manifests.

## Priority 4 — Migrate remaining root/ apps to Baker

`kubernetes/root/` still deploys docs, workflows, and orphaned apps via the old app-of-apps pattern. Move these to Baker to eliminate the dual-path confusion:
- docs/ — needs a `docs.bake.jsonnet`
- workflows/ — needs individual `.bake.jsonnet` entries per workflow (only Redis currently uses Baker)
- orphaned/ — can likely be deleted

## Priority 5 — Improve Makefile + developer experience

Add targets: `lint` (jsonnet-lint), `fmt` (jsonnetfmt), `diff` (preview bake changes), `validate` (full local check), `help`. Add `set -euo pipefail` and binary existence checks to the `bake` script.

## Priority 6 — Consolidate base/ templates and constants

5+ deployment.jsonnet variants exist across apis/base/, ui/base/, datascience/base/, infra-services/base/. Extend the root `kubernetes/base/deployment.jsonnet` to accept optional params instead of forking per domain. Merge 3 copies of `constants.libsonnet` into one.

## Smaller wins

- DRY up `kubernetes/bakerRoot/` — all 8 files are nearly identical, replace with data-driven generation
- Fix quote style inconsistency (standardize on single quotes, enforce with jsonnetfmt)
- Fix naming inconsistency (`mcp_server` vs `infra-services` vs `ghaScaleSet`) — standardize on kebab-case
- Remove duplicate Helm chart entry (`ingressNginx` and `ingress-nginx` in `helm_charts.libsonnet`)
- Add basic Jsonnet template rendering tests
- Move baker binaries (36.6MB + 29.9MB) out of git to GitHub releases

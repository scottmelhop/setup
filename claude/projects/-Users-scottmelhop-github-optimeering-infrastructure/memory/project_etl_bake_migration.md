---
name: ETL workflow bake migration
description: Progress on migrating ETL workflows from ArgoCD Jsonnet rendering to baked YAML pattern
type: project
---

Migrating all ETL workflows to baked pattern (kubernetes/base/argoWorkflows/ primitives, no lib/argo.libsonnet).

**Why:** ArgoCD Jsonnet rendering caused pain during Argo Workflows v4 upgrade (schedule→schedules, mutex→mutexes, numeric values). Baked YAML avoids runtime rendering issues.

**How to apply:** Follow energinet pattern — each workflow gets `kubernetes/workflows/<name>/` dir with `app.libsonnet` + `<name>WorkflowTemplate.jsonnet`. Add to bake files and ignoreImages.

## Completed (2026-03-27)
1. umm — PR #930
2. fingrid — PR #933
3. svk — PR #934
4. nordpool — PR #936

## Remaining (simplest → most complex)
5. entsoe — many configs, mixed short/long crons
6. met — custom tolerations/memory, sync_mutex
7. nve — multi-step with prometheus metrics
8. statnett-prod-cons — multi-step with parallelism
9. statnett-reserves — multi-step with parallelism
10. test — can be dropped or migrated last

## Key patterns established
- Production image tags in kubernetes/images/production.json often stale — check live with `kubectl get workflowtemplate -o jsonpath` and update
- CronWorkflow `labels: { team: 'engineering' }` passed via app.libsonnet tlas
- workflows/base/workflowTemplate.jsonnet now has: spec-level metrics, podGC, team label, parameters passthrough, tolerations/nodeSelector overrides
- base/argoWorkflows/container.jsonnet has stringifyResources for CRD compat
- base/argoWorkflows/cronWorkflow.jsonnet has argoWorkflowsV4 flag for schedule/schedules + mutex/mutexes
- Live vs baked diffs are cosmetic: label ordering, empty resources, nodeSelector key format

## Cleanup after full migration
- Delete old top-level `*.jsonnet` files (entsoe.jsonnet, met.jsonnet, etc.)
- Delete `kubernetes/workflows/images/` directory
- Delete `kubernetes/workflows/staging.jsonnet` and `production.jsonnet`
- Delete `kubernetes/workflows/workflow.libsonnet`

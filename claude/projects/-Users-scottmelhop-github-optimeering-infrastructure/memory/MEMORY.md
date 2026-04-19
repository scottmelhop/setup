# Memory Index

- [feedback_bake_before_push.md](feedback_bake_before_push.md) — Must run ./bake after Jsonnet changes before committing; ArgoCD deploys from .baker/ YAML
- [feedback_pr_sync_verify_workflow.md](feedback_pr_sync_verify_workflow.md) — Preferred workflow: create PR → user merges → sync ArgoCD apps → verify rollout
- [feedback_istio_distroless.md](feedback_istio_distroless.md) — Istio images need both base tag and -distroless variant in ACR (pilot, install-cni, proxyv2)
- [feedback_bitnami_insecure_images.md](feedback_bitnami_insecure_images.md) — Bitnami 25+ rejects non-Bitnami images; set global.security.allowInsecureImages=true for ACR
- [feedback_alpine_redis_no_bash.md](feedback_alpine_redis_no_bash.md) — Alpine Redis + Bitnami 25.x: disable probes and metrics (uses /bin/bash, Alpine only has /bin/sh)
- [project_baker_refactoring_plan.md](project_baker_refactoring_plan.md) — Prioritized plan for improving Baker workflow, Jsonnet structure, and CI/CD (analyzed 2026-03-24)
- [project_etl_bake_migration.md](project_etl_bake_migration.md) — ETL workflow bake migration: 4/10 done (umm, fingrid, svk, nordpool), 6 remaining
- [feedback_atlantis_apply_before_merge.md](feedback_atlantis_apply_before_merge.md) — Atlantis applies Terraform changes before PR merge, not after
- [project_buildbarn_upgrade_status.md](project_buildbarn_upgrade_status.md) — BuildBarn HA upgrade status (2026-03-28): images, config changes, JWT auth pending
- [feedback_pr_links.md](feedback_pr_links.md) — Always output full PR URL after gh pr create, not just owner/repo#number

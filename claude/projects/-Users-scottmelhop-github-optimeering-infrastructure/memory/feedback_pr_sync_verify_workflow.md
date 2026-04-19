---
name: PR → merge → ArgoCD sync → verify workflow
description: Preferred workflow for infrastructure changes — create PR, user reviews/merges, then sync ArgoCD apps and verify rollout
type: feedback
---

After making infrastructure changes, follow this workflow:
1. Create PR with changes (including baked output)
2. Wait for user to review and merge
3. Sync the relevant ArgoCD parent apps (`staging-system-bake`, `infra-system-bake`) then child apps
4. Verify the rollout: check pods are healthy, configs are applied, and changes are working as expected (e.g. query Loki, check labels in Grafana)

**Why:** User wants to review changes before they hit clusters. The verify step catches issues early (schema errors, missing images, etc.) rather than discovering them later.

**How to apply:** Always create a PR rather than pushing to main. After merge, proactively sync ArgoCD and verify — don't just say "it's merged" and stop.

---
name: Run ./bake after Jsonnet changes
description: Must run ./bake to compile Jsonnet into .baker/ YAML before committing — ArgoCD deploys from .baker/ not raw Jsonnet
type: feedback
---

Always run `./bake` after modifying any Jsonnet files (`.libsonnet`, `.jsonnet`) and before committing/pushing.

**Why:** ArgoCD deploys from the compiled YAML in `.baker/`, not from raw Jsonnet. Without baking, merged changes won't actually roll out to clusters.

**How to apply:** After editing Jsonnet, run `./bake`, then commit both the Jsonnet source and the generated `.baker/` output together.

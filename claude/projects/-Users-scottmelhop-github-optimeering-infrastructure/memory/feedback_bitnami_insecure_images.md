---
name: Bitnami 25.x requires allowInsecureImages for custom registries
description: Bitnami charts 25+ reject non-Bitnami images by default — must set global.security.allowInsecureImages=true when using ACR
type: feedback
---

Bitnami Helm charts v25+ enforce image verification and reject non-Bitnami container images by default. When using custom registries (like ACR), set `global.security.allowInsecureImages: true`.

**Why:** Redis chart 25.3.9 failed with "Original containers have been substituted for unrecognized ones" when using ACR-hosted images.

**How to apply:** Add `global: { security: { allowInsecureImages: true } }` to values for any Bitnami chart v25+ that uses custom image registries. Also note Bitnami moved to OCI-only hosting — use `registry-1.docker.io/bitnamicharts` as repoURL (same pattern as `ghcr.io` repos in baker).

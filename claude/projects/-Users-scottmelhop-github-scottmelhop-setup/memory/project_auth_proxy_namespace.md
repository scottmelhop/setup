---
name: auth-proxy namespace
description: The auth-proxy runs in the oauth2-proxy Kubernetes namespace
type: project
originSessionId: b4d0ef79-051c-4cb3-a4db-2730f2458f5f
---
The auth-proxy is deployed in the `oauth2-proxy` namespace.

**Why:** Namespace was changed/moved to `oauth2-proxy` (as of 2026-04-19).
**How to apply:** When referencing or configuring the auth-proxy in Kubernetes manifests, Helm values, or kubectl commands, target the `oauth2-proxy` namespace.

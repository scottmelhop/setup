---
name: Istio images need -distroless variant
description: Istio charts auto-append -distroless to image tags — ACR must have both the base tag and the -distroless variant
type: feedback
---

When adding Istio images to ACR, always include both the base tag AND the `-distroless` variant. Istio charts (istiod, istio-cni, proxyv2) automatically append `-distroless` to the configured tag at runtime.

**Why:** Pods failed with ImagePullBackOff because ACR only had `1.29.1` but Istio requested `1.29.1-distroless`.

**How to apply:** For each Istio image version, add two entries to `images.libsonnet` — one for `<version>` and one for `<version>-distroless`. The ztunnel image does NOT use distroless. Images affected: `istio/pilot`, `istio/install-cni`, `istio/proxyv2`.

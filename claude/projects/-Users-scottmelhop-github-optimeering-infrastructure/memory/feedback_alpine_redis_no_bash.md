---
name: Alpine Redis images need probes disabled with Bitnami chart 25.x
description: Bitnami Redis chart 25.x uses /bin/bash in probes and metrics — Alpine images only have /bin/sh, so disable probes and metrics
type: feedback
---

When using official Alpine Redis images (e.g. `redis:8.6.2-alpine`) with Bitnami Redis chart 25.x, you must disable liveness/readiness probes and metrics. The chart uses `/bin/bash` in probe commands and metric sidecar scripts, but Alpine only has `/bin/sh`.

**Why:** Pods crash with `exec: "/bin/bash": stat /bin/bash: no such file or directory` in both the Redis container probes and the redis_exporter metrics sidecar.

**How to apply:** Set `master.readinessProbe.enabled: false`, `master.livenessProbe.enabled: false` (same for replica), and `metrics.enabled: false` in the Redis values.

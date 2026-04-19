---
name: BuildBarn upgrade status
description: Status of BuildBarn HA improvements and image upgrade to March 2026 versions
type: project
---

BuildBarn was upgraded on 2026-03-28 with new images, HA, and observability improvements.

**Completed:**
- Storage sharded across 2 replicas (Rendezvous hashing)
- Scheduler and frontend scaled to 2 replicas
- Workers: HPA 4-16, spotcpu8v2 node pool, resource requests, concurrency 4/pod
- PDBs on storage, scheduler, workers
- All images updated to March 2026 (bb-storage, bb-scheduler, bb-worker, bb-browser)
- bb-runner-installer: new version uses /app/bb_runner_installer with /bb arg (no tini)
- bb-runner image needs entrypoint ["/bb/bb_runner"] (no tini) — updated to 329bff7
- Config breaking changes: shards now map<string,Shard>, grpc address wrapped in client{}, JMESPath fields use {expression: "..."}, scheduler needs synchronizeAuthorizer, worker needs inputDownloadConcurrency, platformKeyExtractor uses action not actionAndCommand
- ACR copy tool: all BB images added, jobs.jsonnet uses std.asciiLower for RFC 1123 names
- Grafana dashboard with metrics + traces sections
- VMServiceScrape fixed (empty matchLabels, owned by victoria-metrics app)
- Tempo metrics generator: fixed remote_write path, added service.namespace dimension

**Pending:**
- Frontend JWT auth may still have issues — was working with allow:{} but UNAUTHENTICATED with JWT enabled. Claims validation expression updated to use payload.* prefix but needs verification with actual builds
- PR #939 (buildbarn-improvements branch) is stale — all changes were pushed directly to main

**Why:** BuildBarn is critical build infrastructure for dave repo CI. HA prevents single-point-of-failure outages during builds.

**How to apply:** When touching BuildBarn config, be aware of the proto schema changes between old (2023) and new (2026) versions. Always test config changes by checking pod logs after deployment.

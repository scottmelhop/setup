---
name: MCP server migration complete
description: Go MCP server (optimeering_mcp) merged to master; replaces Python version
type: project
---

The MCP server was rewritten from Python to Go and merged via PR OptimeeringAS/prime#60.

**Why:** Go version adds proper OAuth 2.1 (PKCE S256, RFC 9728 protected-resource, RFC 7591 registration), auto-pagination, real CSV export to Azure Blob Storage, and composite tools.

**How to apply:** Future MCP server work lives at `src/go/optimeering_mcp/`. The Python version at `src/python/optimeering_mcp/` is still present but superseded.

Key details:
- Base image: `distroless/base-debian12` (not `debian:12-slim`) — needed for CA certs to call Azure AD
- Image published to: `optimeeringexperiments.azurecr.io/prime/optimeering-mcp`
- Deployment config: `kubernetes/mcp_server/base/deployment.jsonnet` in the infra repo
- Redis used for session/token/export status storage
- Azure Blob Storage used for CSV export files (SAS URLs valid 24h)

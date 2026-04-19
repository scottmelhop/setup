---
name: MCP server improvement plan
description: Three-phase plan to improve the MCP server - scaling, optipyclient migration, and logging
type: project
---

MCP server improvement plan agreed on 2026-03-26, three phases:

**Phase 1: Horizontal scaling**
- Replace 7 in-memory dicts in AzureOAuthProvider with Redis (async redis-py)
- Key prefixes: mcp:client:{id}, mcp:authcode:{code}, mcp:access:{token}, etc.
- TTLs: auth codes 300s, access tokens 3600s, pending authz 600s, refresh tokens 86400s
- Enable stateless=True on StreamableHTTPSessionManager (no server-initiated notifications needed)
- Project has existing Redis client in src/utilities/redis/

**Phase 2: Switch to optipyclient + async**
- Migrate ~20-25 tools from raw _get()/httpx to optipyclient API classes
- Keep raw _get() for: get_valid_parameters, intraday trades, API keys, UMM timestamp
- Gains: automatic pagination, retry logic, type safety, less code
- Convert to async with anyio.to_thread.run_sync() (optipyclient is sync)
- Use shared httpx.AsyncClient with connection pooling for remaining raw calls
- Fix refresh token flow to actually refresh Azure AD tokens

**Phase 3: Interaction logging**
- Instrument _get() and optipyclient calls with structured logging
- Log: tool_name, parameters, user_id (from Azure AD token), duration_ms, response_size, errors
- Use project's existing structlog setup (JSON output)
- Avoid logging: bearer tokens, full response bodies

**Why:** User wants horizontal scaling for production, usage analytics to improve the MCP, and code quality improvements.
**How to apply:** Work through phases in order; each phase is a separate PR.

---
name: Always provide full PR URLs
description: User wants clickable full URLs for every PR created, not just the shorthand reference
type: feedback
---

Always provide the full GitHub URL (e.g. https://github.com/OptimeeringAS/infrastructure/pull/952) when creating a pull request, not just the owner/repo#number shorthand. The shorthand does not render as a clickable link in the terminal output.

**Why:** User explicitly asked for links after I only gave the shorthand reference.
**How to apply:** After every `gh pr create` call, output the full URL on its own line.

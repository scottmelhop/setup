---
name: Always run pants checks before pushing
description: Run pants fmt, lint, and check before every git push to avoid CI failures
type: feedback
---

Always run `pants fmt`, `pants lint`, and `pants check` on changed files before pushing to the remote.

**Why:** CI runs these checks and will fail if formatting, linting, or type errors are present. Pushing without checking wastes time on CI round-trips.

**How to apply:** Before every `git push`, run:
```
pants fmt src/path:: && pants lint src/path:: && pants check src/path::
```
Only push after all three pass with no changes/errors. If fmt makes changes, stage and amend the commit before pushing.

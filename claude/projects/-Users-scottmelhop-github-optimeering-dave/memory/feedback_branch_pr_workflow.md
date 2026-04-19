---
name: Use branch and PR workflow
description: Always create a branch and open a PR instead of pushing directly to master
type: feedback
---

Always work on a feature branch and open a PR — never push directly to master.

**Why:** Pushing directly to master was only acceptable during the optipyclient publish debugging session to iterate quickly. Once that was resolved, the user expected the normal branch+PR workflow to resume.

**How to apply:** Before making any commits, create a branch (`git checkout -b <branch-name>`). When done, push the branch and open a PR with `gh pr create`. Do not push to master directly unless the user explicitly asks for it in the current session.

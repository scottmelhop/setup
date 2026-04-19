---
name: Atlantis apply before merge
description: Terraform changes via Atlantis are applied before PR merge, not after
type: feedback
---

Atlantis applies Terraform changes before the PR is merged, not after.

**Why:** This is the configured workflow — Terraform state updates happen on the PR, then the PR is merged to record the change in git history.

**How to apply:** When mentioning Terraform changes in PRs, don't say "will need an apply after merge." The apply happens on the PR before merge.

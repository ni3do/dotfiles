---
description: Review current git changes for correctness and safety
argument-hint: "[focus]"
---
Review the current git changes. Focus: ${ARGUMENTS:-correctness, regressions, security, maintainability}

Use git status and diffs. Prioritize:
- bugs and broken assumptions
- data loss or destructive operations
- security/privacy issues
- missing validation or error handling
- repo-specific instruction violations
- tests or validation commands that should be run

Do not edit files unless I ask for fixes.

---
description: Lint the second-brain wiki for schema and semantic health
argument-hint: "[scope]"
---
Lint my second-brain wiki. Scope: ${ARGUMENTS:-all}

Follow `.claude/skills/lint/SKILL.md` if present. Check:
- broken wikilinks
- orphan wiki pages
- stale `index.md` entries
- frontmatter schema drift
- citation gaps
- uncited claims
- `raw/` modification risks
- card formatting issues, especially `<!-- card-id: ... -->` blank-line requirements
- obvious contradictions or duplicated concepts

Report findings first. Ask before making broad semantic edits.

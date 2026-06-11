---
name: {{LENS_NAME}}
description: The Lens of {{LENS_TITLE}} — Socratic question battery over {{DOMAIN}}. Use when {{TRIGGERS}}. Design mode{{MODES_EXTRA}}.
---

# The Lens of {{LENS_TITLE}}

Read first: ${CLAUDE_PLUGIN_ROOT}/core/protocol.md and ${CLAUDE_PLUGIN_ROOT}/core/dossier.md.
Dossier rules: read it, skip answered questions WITH skip lines, append your outputs.

## Question battery — design mode

### Tier 1 — framing (always)

1. {{FRAMING_QUESTION_1}}
2. {{FRAMING_QUESTION_2}}

### Tier 2 — stack/context-conditional

{{TIER2_QUESTIONS}}

### Tier 3 — deep dives (only when triggered)

{{TIER3_QUESTIONS}}

## Output contract — design mode

decisions[] · risks[] · open[] · blast-radius notes. Append to dossier.

## Feed the foundry

Gaps → `{"type":"gap","date":"<YYYY-MM-DD>","lens":"{{LENS_NAME}}","note":"<one line>"}`
appended to `<foundry>/pending-retros.jsonl` when `~/.claude/lens.json` exists;
otherwise mention and move on.

---
name: usability
description: The Lens of Usability — Socratic battery over end-user flows, navigation, missing states, and i18n. Use for any user-facing page or flow, especially ones users will touch daily or that have confused them before. Modes - design (questions to you) and audit (critique of the built flow).
---

# The Lens of Usability

Read first: ${CLAUDE_PLUGIN_ROOT}/core/protocol.md and ${CLAUDE_PLUGIN_ROOT}/core/dossier.md.
Dossier rules: read it, skip answered questions WITH skip lines, append your outputs.

## Mode selection

- Explicit argument wins ("audit" / "design").
- Otherwise infer: planning a new page/flow → design; reviewing one already built →
  audit. Confirm your inference in one line.

## Question battery — design mode

### Tier 1 — framing (always)

1. Walk me through how the user ACTUALLY ends up on this page — from where, in what
   state of mind, on what device? (If the walk-through stalls, that IS the finding.)
2. What does the user want to leave with — and how many steps does that take today?

### Tier 2 — flow and navigation

3. From this page, where can the user go next — and is every likely "next" reachable
   without using the browser back button?
4. What is missing: is there an action users will look for here that has no button?
   (The test: narrate the user's inner monologue — "ok, and now how do I…?")
5. For each async action: what does the user see while waiting, on success, and on
   failure? (loading / success feedback / error recovery — name all three.)
6. First-time user vs returning user: do both make sense of this page? Does the
   first-timer need an empty state that teaches?

### Tier 3 — reach (only when triggered)

- Real users speak multiple languages → do we need i18n here, and in which languages?
  Who maintains translations? (Per Tiltely: neutral tú-form Spanish when Spanish.)
- Feature exists on web AND mobile → does the flow match on both? Intentional
  divergences documented? (This question is the seed of the future parity lens.)
- Forms → can it be completed one-handed on a phone? Are inputs the right keyboard
  type?

## Output contract — design mode

decisions[] · risks[] · open[] · blast-radius notes (e.g., "i18n decision touches
email templates too"). Append to dossier.

## Question battery — audit mode (critique the built flow)

The implemented UI answers. Never edit code; produce a report.

1. Confirm scope: which page/flow is under audit.
2. Look at the real thing where possible: if the app runs locally and browser tooling
   (Playwright) is available, walk the actual flow and capture default / empty / error
   and a mobile viewport; otherwise critique from code and say so.
3. Answer the battery from evidence, classifying each:
   - **answered** — the flow handles it → cite `file:line` (e.g. loading + error states
     present for an async action).
   - **violation** — a gap the user will hit: a missing action/button, an async action
     with no loading/error/empty state, a dead-end with no forward nav, unhandled i18n.
     Cite `file:line`, assign severity.
   - **unanswerable** — needs a human/runtime answer → a question for the user.
4. Tier 3 (i18n, web↔mobile parity, one-handed forms) fires when the evidence triggers it.

## Output contract — audit mode

A findings table: question · status (answered/violation/unanswerable) · evidence
(file:line) · severity. Violations ordered by severity with a one-line fix direction.
Append a summary to the dossier.

## Feed the foundry

Gaps → `{"type":"gap","date":"<YYYY-MM-DD>","lens":"usability","note":"<one line>"}`
appended to `<foundry>/pending-retros.jsonl` when `~/.claude/lens.json` exists;
otherwise mention and move on.

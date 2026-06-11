---
name: shadcn-design
description: The Lens of Interface Design — Socratic battery over UI composition with Tailwind + shadcn/ui. Use when building or changing screens, components, navigation, or anything users see. Generates ranked implementation candidates and self-challenges the result. Design mode only.
---

# The Lens of Interface Design (shadcn)

Read first: ${CLAUDE_PLUGIN_ROOT}/core/protocol.md and ${CLAUDE_PLUGIN_ROOT}/core/dossier.md.
Dossier rules: read it, skip answered questions WITH skip lines, append your outputs.

## Question battery — design mode

### Tier 1 — framing (always)

1. What is the ONE primary action on this screen? (If the answer lists three, dig:
   which one does the business need most?)
2. Who lands here and from where? (entry point shapes layout: deep link ≠ nav click)

### Tier 2 — composition

3. Component candidates: for the core interaction, name 2–3 shadcn/ui compositions
   that could serve it (e.g., Dialog vs Sheet vs dedicated route; Tabs vs Accordion
   vs stepper). RANK them against: mobile ergonomics, state preserved on navigation,
   implementation cost. Recommend one, with the ranking visible.
4. Where does this screen's navigation live — and is that consistent with the rest of
   the app? (navbar items, tabs placement, back behavior on mobile web)
5. Which states exist beyond happy path — loading, empty, error, partial? Show what
   each looks like (skeleton? empty-state CTA? toast vs inline error?).
6. Does this app ship as a PWA? If yes: does this screen behave offline / on slow
   networks, and is it reachable from the installed-app entry point?

### Tier 3 — deep dives (only when triggered)

- Forms involved → field-level validation timing (on blur? on submit?), error
  placement, and what happens to user input on failure.
- Data tables/lists → empty, 1 item, 10k items: same component?
- Dark mode shipped → are the chosen components token-driven or hardcoded colors?

## The self-challenge (mandatory closing question)

After decisions are made — and again in any session where the implementation gets
built — ask explicitly:

> **Is what we decided/built actually the best we could do for the user, or just the
> first thing that worked?**

If the honest answer is "first thing that worked", produce one concrete alternative
and compare before closing.

## Output contract — design mode

decisions[] (incl. the ranked candidates table) · risks[] · open[] · blast-radius
notes (e.g., "new nav item touches mobile tab bar too"). Append to dossier.

## Feed the foundry

Gaps → `{"type":"gap","date":"<YYYY-MM-DD>","lens":"shadcn-design","note":"<one line>"}`
appended to `<foundry>/pending-retros.jsonl` when `~/.claude/lens.json` exists;
otherwise mention and move on.

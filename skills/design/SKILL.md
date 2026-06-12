---
name: design
description: The Lens of Interface Design — Socratic battery over UI composition, layout, navigation, states, and platform behavior. Library-agnostic - adapts to the project's design system (shadcn/ui, MUI, Chakra, custom, or none). Use when building or changing anything users see, or to professionally critique an implemented UI. Modes - design (questions to the user) and audit (critique of the built screens).
---

# The Lens of Interface Design

Read first: ${CLAUDE_PLUGIN_ROOT}/core/protocol.md and ${CLAUDE_PLUGIN_ROOT}/core/dossier.md.
Dossier rules: read it, skip answered questions WITH skip lines, append your outputs.

This lens is technology-agnostic (protocol.md, "Lens agnosticism"). Component
vocabulary adapts to whatever the project uses — the questions do not change.

## Detect the design system (before Tier 2)

Inspect the project once and record `design-system:` in the dossier:
- `components.json` + a `ui/` components dir → shadcn/ui
- `@mui/material` → MUI · `@chakra-ui/*` → Chakra · `antd` → Ant Design
- Tailwind only, no component library → utility-first custom
- none of the above → no design system (candidates come from platform primitives;
  Tier 3 asks whether adopting one pays off)

## Question battery — design mode

### Tier 1 — framing (always)

1. What is the ONE primary action on this screen? (If the answer lists three, dig:
   which one does the business need most?)
2. Who lands here and from where? (entry point shapes layout: deep link ≠ nav click)

### Tier 2 — composition

3. Component candidates: for the core interaction, name 2–3 compositions **in the
   project's design system** (or platform primitives if none) that could serve it —
   e.g., modal vs slide-over panel vs dedicated route; tabs vs accordion vs stepper.
   RANK them against: mobile ergonomics, state preserved on navigation,
   implementation cost. Recommend one, with the ranking visible.
4. Where does this screen's navigation live — and is that consistent with the rest of
   the app? (nav items, tabs placement, back behavior on mobile web)
5. Which states exist beyond happy path — loading, empty, error, partial? Show what
   each looks like (skeleton? empty-state CTA? toast vs inline error?).
6. Does this app ship as a PWA, or will it? → load the depth pack
   `${CLAUDE_PLUGIN_ROOT}/skills/design/topics/pwa.md` and run its battery.

### Tier 3 — deep dives (only when triggered)

- Forms involved → field-level validation timing (on blur? on submit?), error
  placement, and what happens to user input on failure.
- Data tables/lists → empty, 1 item, 10k items: same component?
- Dark mode shipped → are the chosen components token-driven or hardcoded colors?
- No design system detected → is it time to adopt one? What does consistency cost
  today vs the migration cost?

## Depth packs (topics/)

When an answer touches a topic with a depth pack, load `topics/<topic>.md` and run
its battery before moving on. Current packs: `pwa`. Missing pack for a deep topic
that needed one → feed the foundry (that is how new packs get born).

## Question battery — audit mode (professional design critique)

The built UI answers. Never edit code; produce a report.

1. Confirm scope with the user: which screens/flows are under critique.
2. Detect the design system (above) and read the implementing code.
3. **Look at the real thing**: if the app runs locally and browser tooling
   (Playwright) is available, navigate the actual screens and capture the key
   states — default, empty, error, and a mobile viewport. Critique what the user
   sees, not just the JSX. If you cannot run it, say so and critique from code with
   that caveat stated.
4. For each key interaction, generate 2–3 alternatives (other components in the
   project's design system, or a different approach entirely) and RANK them with
   visible criteria: mobile ergonomics, state handling, accessibility,
   migration cost.
5. Verdict per screen — one of:
   - **keep** — what is implemented ranks first; say why (a valid, common outcome;
     never invent change for its own sake)
   - **refine** — same approach, concrete small improvements listed
   - **rework** — a better approach exists; show the ranking that proves it and the
     migration cost
6. Run the platform-matrix excavation (protocol.md) on anything platform-sensitive
   you saw (install flows, storage, media, gestures).

## The self-challenge (mandatory closing question, both modes)

> **Is what we decided/built actually the best we could do for the user, or just the
> first thing that worked?**

If the honest answer is "first thing that worked", produce one concrete alternative
and compare before closing.

## Output contract

- design mode → decisions[] (incl. the ranked candidates table) · risks[] · open[] ·
  blast-radius notes (e.g., "new nav item touches mobile tab bar too"). Append to
  dossier.
- audit mode → per-screen verdict table (keep/refine/rework + ranked evidence) ·
  alternatives considered · platform-matrix findings. Append a summary to dossier.

## Feed the foundry

Gaps → `{"type":"gap","date":"<YYYY-MM-DD>","lens":"design","note":"<one line>"}`
appended to `<foundry>/pending-retros.jsonl` when `~/.claude/lens.json` exists;
otherwise mention and move on.

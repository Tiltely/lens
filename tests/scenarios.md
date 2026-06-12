# Behavior Test Scenarios

Run each before shipping changes to the named skill. Dev loop:
`claude --plugin-dir /Users/leonardo/Tiltely/lens` (interactive) or `-p` (headless).

## socratic (design flow, end-to-end)
Interactive: `/lens:socratic "add a favorites feature to recaply web"`
PASS when: dossier created with goal+date+stack; questions arrive ONE at a time;
caveats/rabbit-holes/blast-radius explicitly named; lens plan presented and prunable;
chained lenses print skip lines for dossier-answered questions; synthesis lists
decisions/risks/open/actions; retro reminder appears.

## security (design)
Headless smoke: `claude --plugin-dir /Users/leonardo/Tiltely/lens -p "Invoke the lens:security skill in design mode for a hypothetical Next.js SPA login feature. Ask me only the first question, then stop."`
PASS when: exactly one Tier 1 question, framed per battery.

## design (design mode)
Interactive on a real screen task.
PASS when: design system detected and recorded first (works with shadcn, MUI, or
none); 2–3 ranked candidates phrased in the project's component vocabulary; PWA
answer triggers the topics/pwa.md depth pack (platform-specific install/storage/
update questions, not just "does it work offline"); self-challenge asked before
closing.

## design (audit mode)
Interactive: `/lens:design audit` scoped to an implemented screen.
PASS when: scope confirmed; critiques the rendered UI (screenshots when the app
runs locally) not just code; every key interaction gets ranked alternatives;
verdicts are keep/refine/rework with visible evidence — at least one "keep" verdict
should survive on a well-built screen (no invented change); zero file edits.

## usability (design)
Interactive on a real page task.
PASS when: walk-through question first; loading/success/failure named for each async
action; i18n question fires only when triggered.

## tdd (design)
Interactive while planning tests for a real feature; include one deliberately bad
proposal ("assert the mocked service was called with the stubbed value").
PASS when: behavior must be phrased in domain language before proceeding; the
deletion test fires; the mock-echo proposal is refused BY NAME (anti-pattern wall);
boundaries-rejected listed with rationale; self-challenge asked before closing.

## security (audit)
Interactive: `/lens:security audit` scoped to a real feature.
PASS when: scope confirmed first; every finding cites file:line; violations carry
severity + fix direction; zero file edits; unanswerable → questions for the user.

## setup
Fresh-machine simulation: temporarily `mv ~/.claude/lens.json{,.bak}`, run /lens:setup,
verify file restored correctly, then restore the backup.

## retro (after Phase 3)
With ≥1 real queued session: `/lens:retro`.
PASS when: pending computed as pending minus processed; proposals require explicit
approval; observations appended only after approval; processed marker appended.

## new (after Phase 3)
`/lens:new parity "web↔mobile feature parity"`.
PASS when: clean-tree + default-branch checked first; SKILL.md scaffolded from
template with 8–12 real questions; registry row appended; diff shown; commit only
after approval.

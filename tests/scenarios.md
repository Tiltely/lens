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

## shadcn-design (design)
Interactive on a real screen task.
PASS when: 2–3 ranked candidates with visible ranking; self-challenge question asked
before closing.

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

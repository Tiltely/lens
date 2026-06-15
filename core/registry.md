# Registry

The BUNDLED lens set. `/lens:socratic` plans from rows tagged `lens`, merged
**nearest-wins on name** with your global registry (`<foundry>/registry.md`) and a
project registry (`<repo>/.lens/registry.md`) when they exist
(project > global > bundled). All lenses are used through `/lens:socratic`; only
bundled lenses also have a `/lens:<name>` shortcut. `/lens:new` MUST append a row when
scaffolding a new lens — to whichever registry matches the chosen scope (project, your
global foundry, or here on the maintainer path).

| skill | type | modes | purpose | trigger signals |
|---|---|---|---|---|
| socratic | utility | design, audit, partition | Discovery orchestrator: rounds → the four excavations → lens plan → chained lenses → mandatory adversary red-team. Audit: re-runs the session's lens plan against the built code + contract check vs dossier decisions. Partition: splits a finished multi-feature dossier into parallel git worktrees (one per independent feature, by blast-radius) + reconciliation order | starting any non-trivial feature or issue; auditing what got built afterwards; splitting a multi-feature request into parallel worktrees |
| adversary | meta | plan-critique | Red-teams the synthesized plan: refute it, weakest decision, what discovery missed (four excavations vs the plan), reversibility, "first thing that worked". Suggests plan mode (waits for user). MANDATORY final step of /lens:socratic; also standalone on any plan/diff. (type `meta` → not trigger-matched into the lens chain; socratic always runs it last) | end of any planning; "is this plan sound?"; critiquing a diff or design |
| security | lens | design, audit | Sessions, auth, tokens, secrets, authorization layers | login, tokens, payments, user data, webhooks, anything an attacker would love |
| design | lens | design, audit | Interface design, library-agnostic: ranked component candidates in the project's design system, layout, navigation, states, platform matrix; audit = professional critique of implemented UI (keep/refine/rework) | new screens/components, redesigns, "where should X go", "is this the best UI for this?" |
| usability | lens | design, audit | End-user flows, navigation, missing states, i18n; audit = critique of the built flow | new user-facing pages, flows users complained about |
| tdd | lens | design, audit | Test quality and judgment: tests that earn their existence; audit = judge an existing test suite (keep/strengthen/delete + coverage gaps) | writing or planning tests, bugfixes needing regression tests, reviewing or auditing a test suite |
| observability | lens | design, audit | Operational recovery + visibility for money flows, state machines, webhooks, jobs: orphan detection, reconciliation, durable idempotent dedupe, stuck-state sweeps, alerting, traceability; audit = find flows where a lost event or stalled step strands a user with no detection/recovery | payments, webhooks, multi-step/onboarding flows, background jobs/crons, anything where a lost external event or a mid-step failure can strand a user |
| retro | utility | — | Memory loop: mine queued sessions, propose lenses/updates/CLAUDE.md diffs, write ledger | closing significant work; weekly |
| new | utility | — | Scaffold a new lens from template + register it | retro proposed a lens; a recurring theme has no lens |
| setup | utility | — | Dev-machine setup: write ~/.claude/lens.json, permission rule | once per dev machine |

Planned (post-video, via /lens:new): parity, scalability, data-privacy, cost.

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
| socratic | utility | design, audit | Discovery orchestrator: rounds → the four excavations → lens plan → chained lenses. Audit: re-runs the session's lens plan against the built code + contract check vs dossier decisions | starting any non-trivial feature or issue; auditing what got built afterwards |
| security | lens | design, audit | Sessions, auth, tokens, secrets, authorization layers | login, tokens, payments, user data, webhooks, anything an attacker would love |
| design | lens | design, audit | Interface design, library-agnostic: ranked component candidates in the project's design system, layout, navigation, states, platform matrix; audit = professional critique of implemented UI (keep/refine/rework) | new screens/components, redesigns, "where should X go", "is this the best UI for this?" |
| usability | lens | design, audit | End-user flows, navigation, missing states, i18n; audit = critique of the built flow | new user-facing pages, flows users complained about |
| tdd | lens | design, audit | Test quality and judgment: tests that earn their existence; audit = judge an existing test suite (keep/strengthen/delete + coverage gaps) | writing or planning tests, bugfixes needing regression tests, reviewing or auditing a test suite |
| retro | utility | — | Memory loop: mine queued sessions, propose lenses/updates/CLAUDE.md diffs, write ledger | closing significant work; weekly |
| new | utility | — | Scaffold a new lens from template + register it | retro proposed a lens; a recurring theme has no lens |
| setup | utility | — | Dev-machine setup: write ~/.claude/lens.json, permission rule | once per dev machine |

Planned (post-video, via /lens:new): parity, scalability, observability,
data-privacy, cost.

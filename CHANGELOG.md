# Changelog

All notable changes to the `lens` plugin. Versioned with [semver](https://semver.org):
the `version` field in `.claude-plugin/plugin.json` is the source of truth and is
bumped on every meaningful change (it's the cache key Claude Code and Cowork use to
detect updates). This file is informational and does not affect update detection.

## [0.8.0] — 2026-06-15

### Added
- **Partition mode for `/lens:socratic` — split a finished multi-feature dossier into
  parallel git worktrees.** A request bundling several INDEPENDENT features can now be
  decomposed for concurrent implementation. Discovery is unchanged: you run the full
  socratic design flow to ONE complete dossier. Then partition (opt-in post-adversary, or
  standalone via `/lens:socratic partition`) reads the dossier's already-mapped
  blast-radius and proposes a split — independent features (disjoint files/contracts) →
  their own worktree; coupled features → merged or sequenced (parallelism only where it's
  safe, so reconciliation stays clean). On approval it creates one `git worktree` +
  `lens/<feature-slug>` branch per feature, copies the COMPLETE dossier in with a feature
  manifest (shared global context, never a trimmed sub-dossier), and records each worktree
  path in a new `## partition` section. Reconciliation reuses audit mode: audit each
  worktree against its dossier, then merge in the recorded order.
- A single-feature request is unaffected — partition is a SUPERSET that activates only when
  the blast-radius shows independent features, and always with explicit consent.

### Notes
- **Materializing worktrees is Claude-Code-only** (like the memory loop). On Cowork the
  partition PLAN (`## partition`) is still produced — pure reasoning — but worktrees are
  not created; apply the plan with Cowork's own parallelism.

## [0.7.0] — 2026-06-15

### Changed
- **The dossier is now branch-scoped — one per request, not one fixed file.** Previously
  every project shared a single `<root>/.lens-dossier.md` that design step 1 CREATE/RESET
  in place. Running two `/lens:socratic` sessions concurrently in the same checkout meant
  the second reset truncated the first's discovery, appends interleaved two goals into one
  incoherent file, and the goal+7-day validity check could feed a standalone lens the
  WRONG request's answers (and the audit the wrong contract). The single-writer rule never
  covered this — it only governs intra-session writes. Now the dossier lives at
  `<toplevel>/.lens/dossiers/<branch-slug>--<hash>.md`, a deterministic function of the git
  branch, so concurrent sessions on different branches/worktrees write different files and
  never clobber each other. The audit re-finds its dossier by recomputing the branch path
  (no shared pointer or index); if the branch was renamed/squash-merged it falls back to a
  goal/date/branch pick from `.lens/dossiers/`. Reset is now per-branch, never global.

### Added
- **Defensive branch gate** in design step 1: if you start `/lens:socratic` on a base
  branch (`main`/`master`/`develop`/`trunk`), it STOPS and offers to create
  `lens/<goal-slug>`, stay on base, or spin a worktree — never switching branches
  silently. On a feature
  branch it stays silent. Keeps the dossier from being born orphaned on trunk.
- **Per-branch dossier header** (`branch:`), opportunistic GC of dossiers for deleted
  branches (consented, never automatic), and a one-time OFFER to migrate a legacy
  `.lens-dossier.md` into the new layout.

### Notes
- Git exclusion collapses to the single `.lens/` pattern (the directory `/lens:new`
  already excludes), replacing the literal `.lens-dossier.md` excludes.
- Accepted residual: two sessions on the SAME branch AND worktree still share a file
  (last-writer-wins) — use separate worktrees for genuine parallelism.

## [0.6.0] — 2026-06-14

### Added
- **The Lens of Observability** (`/lens:observability`) — the operational angle the
  other lenses miss: not "is the happy path correct" but "when it breaks silently at
  3am, how do we KNOW, and how does the stranded user/record recover". Its obsession is
  the **orphan** — a user or record stuck mid-flow because an external event was lost or
  a step failed with nothing watching. Design + audit modes; a surface-conditional
  battery over webhooks (lost / late / out-of-order events, durable idempotent dedupe),
  multi-step state machines (server-derived resume, stuck-state sweeps), money audit
  trails, and background jobs (ran-and-succeeded vs silently failed) — closing with the
  self-challenge "if the riskiest external dependency went silent for an hour, how many
  users would be stranded, and which would we ever find out about?". Scaffolded via
  `/lens:new` from a real gap mined by `/lens:retro` — no existing lens covered
  anti-orphan detection and recovery.

## [0.5.1] — 2026-06-13

### Changed
- **The memory loop is now Claude Code only.** Cowork runs the CLI with
  `--setting-sources user` (plugin hooks never fire) and its VM home is ephemeral, so
  the SessionEnd queue / `/lens:retro` / `/lens:new` loop can't work there. `/lens:setup`
  now detects Cowork and declines cleanly (use the lenses + `/lens:socratic` directly;
  run setup on Code for the loop). Dropped the cross-surface/granted-folder foundry
  gymnastics. The lenses and orchestrator still work fully on Cowork. README + setup
  simplified to match.

## [0.5.0] — 2026-06-13

### Added
- **The Lens of the Adversary** (`/lens:adversary`) — red-teams a plan before you
  commit: refutation, weakest decision, what discovery missed (the four excavations
  re-run against the plan), reversibility, the "first thing that worked" test. Each
  finding is dispositioned revise/reopen/accept. It first suggests plan mode and waits
  for the user (never toggles it). Runs as the **mandatory final step of
  `/lens:socratic`** (the adversarial pass reliably surfaces what planning missed), and
  works standalone on any plan or diff. A meta-lens — critiques the plan, not a domain.

### Docs
- Per-environment foundries are by design: Claude Code and Cowork each keep their own
  foundry and grown lenses (environment-scoping, not fragmentation).

## [0.4.2] — 2026-06-13

### Changed
- `/lens:setup` no longer asks "do you maintain a lens plugin?" — that question was
  noise for the vast majority of users. Setup now writes only `{ "foundry": ... }`.
- The maintainer path in `/lens:new` (scaffold into the bundled set) is now
  **auto-detected** — it appears only when the cwd is inside the lens plugin repo
  (repo root has `.claude-plugin/plugin.json` with `name: lens`), never via a config
  field or a setup prompt. `pluginRepo` config is no longer used.

## [0.4.1] — 2026-06-13

### Fixed
- `/lens:setup` now states the foundry holds PERSONAL session data and **must not be
  committed to git** (default to a non-tracked folder; gitignore the queues + dossier
  if a synced repo is unavoidable).
- Corrected the Cowork foundry guidance: Cowork's VM home (`~`) is EPHEMERAL, so
  `~/lens/` would vanish between sessions — the foundry must be a REAL, persistent
  folder the user grants Cowork access to. README updated to match.

## [0.4.0] — 2026-06-13

### Changed
- **One kind of lens, one interface.** Removed the personal-vs-plugin distinction and
  the `/lens:x` vs `/lens-x` syntax split (an artifact of materializing user lenses as
  `~/.claude/skills/` skills). All lenses are now used through `/lens:socratic`; only
  bundled lenses keep a `/lens:<name>` shortcut.
- User-created lenses live in `<foundry>/lenses/` (global) or `<repo>/.lens/lenses/`
  (project), registered in the matching `registry.md` and **read-inline** by socratic —
  no skill materialization, no reload. They live outside the plugin, so auto-updates
  never touch them.
- `/lens:socratic` now spells out global-registry discovery (resolve the foundry via
  `$LENS_CONFIG` → `~/.claude/lens.json` → `~/lens/lens.json`, then read its registry
  and `lenses/`) — fixing a gap where it referenced the foundry without resolving it.
- Authoring your own lenses now works on Cowork too (read-inline needs no skill loading).

## [0.3.0] — 2026-06-13

### Added
- Audit mode for `tdd` (judge an existing suite: keep/strengthen/delete vs the
  anti-pattern wall + coverage gaps) and `usability` (critique a built flow: missing
  states / nav / i18n as `file:line` violations). All four lenses now have the modes
  their registry row declares.

## [0.2.0] — 2026-06-13

### Added
- **Project-scoped lenses.** A repo carries lenses in `<repo>/.lens/`; `/lens:socratic`
  discovers them from the repo root and merges into the plan **nearest-wins**
  (project > global > bundled). `/lens:new` gains a project scope. The memory loop
  stays a single global foundry — unchanged.

## [0.1.0] — 2026-06-13

First versioned release. Public plugin at `github.com/Tiltely/lens`, MIT.

### Added
- `/lens:socratic` orchestrator: the four excavations (caveats, rabbit holes, blast
  radius, platform matrix), the frontier mind-map with stakes-gated termination,
  evidence-before-questions (fact vs intent), decision ripple-checks, and an audit
  mode (dossier-as-contract).
- Lenses: `security` (design + audit), `design` (library-agnostic, design + audit,
  PWA depth pack), `usability`, `tdd`.
- The memory loop: a per-user foundry, a SessionEnd hook that queues lens-using
  sessions, `/lens:retro` to mine them, `/lens:new` to grow lenses, `/lens:setup`.
- Cowork-safe relocatable config + foundry (discovery `$LENS_CONFIG` →
  `~/.claude/lens.json` → `~/lens/lens.json`).
- Adopted explicit semver (Cowork detects updates by the `version` field, not the SHA).

[0.8.0]: https://github.com/Tiltely/lens/releases/tag/v0.8.0
[0.7.0]: https://github.com/Tiltely/lens/releases/tag/v0.7.0
[0.6.0]: https://github.com/Tiltely/lens/releases/tag/v0.6.0
[0.5.1]: https://github.com/Tiltely/lens/releases/tag/v0.5.1
[0.5.0]: https://github.com/Tiltely/lens/releases/tag/v0.5.0
[0.4.0]: https://github.com/Tiltely/lens/releases/tag/v0.4.0
[0.3.0]: https://github.com/Tiltely/lens/releases/tag/v0.3.0
[0.2.0]: https://github.com/Tiltely/lens/releases/tag/v0.2.0
[0.1.0]: https://github.com/Tiltely/lens/releases/tag/v0.1.0

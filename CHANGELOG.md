# Changelog

All notable changes to the `lens` plugin. Versioned with [semver](https://semver.org):
the `version` field in `.claude-plugin/plugin.json` is the source of truth and is
bumped on every meaningful change (it's the cache key Claude Code and Cowork use to
detect updates). This file is informational and does not affect update detection.

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

[0.4.0]: https://github.com/Tiltely/lens/releases/tag/v0.4.0
[0.3.0]: https://github.com/Tiltely/lens/releases/tag/v0.3.0
[0.2.0]: https://github.com/Tiltely/lens/releases/tag/v0.2.0
[0.1.0]: https://github.com/Tiltely/lens/releases/tag/v0.1.0

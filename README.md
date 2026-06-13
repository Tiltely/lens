# lens — Socratic lenses for software engineering

A Claude Code plugin born from two ideas: the **lenses** of Jesse Schell's
*The Art of Game Design* — and the **Socratic method**. Every lens is a battery of
questions that examines your work from one perspective; an orchestrator runs the
discovery dialogue that surfaces caveats, rabbit holes, and blast radius BEFORE you
build; and a memory loop grows new lenses from your real sessions.

## Install

    /plugin marketplace add Tiltely/lens
    /plugin install lens@tiltely

Then `/reload-plugins` (or restart Claude Code).

### Optional: auto-update

Releases are versioned (semver, the `version` field in `plugin.json`) and bumped on
each meaningful change — that's what Claude Code and Cowork compare to detect an
update. To receive them automatically on startup, enable auto-update for the
`tiltely` marketplace in `~/.claude/settings.json`:

    {
      "extraKnownMarketplaces": {
        "tiltely": {
          "source": { "source": "github", "repo": "Tiltely/lens" },
          "autoUpdate": true
        }
      }
    }

(The `tiltely` entry already exists after the marketplace add — just add
`"autoUpdate": true` to it.) Without this, update manually whenever you want:
`/plugin marketplace update tiltely` followed by `/plugin update lens@tiltely`.

## Claude Cowork (Experimental)

Plugins are cross-compatible: the same plugin works in Claude Cowork, where Claude
runs knowledge work — planning a project, prep, reports — on your machine with local
files and a shell. The Socratic discovery and the design and usability lenses apply
just as well to non-code work as to code.

Cowork installs via its GUI, not the `/plugin` CLI commands (those are Claude Code
only), and keeps its own plugin state separate from Claude Code. In Cowork:
**Personal plugins → `+` → Create Plugin → Add Marketplace → Add from a repository**,
then enter `https://github.com/Tiltely/lens` and install `lens` from the catalog.

**Why Experimental:** the engine is built and tested on Claude Code; on Cowork it is
verified at the skill level, with the memory loop working under one extra setup step
(below). What to expect:

- **Works out of the box:** the lenses and `/lens:socratic` (skills are
  cross-platform) — no setup, no config.
- **Memory loop — needs a Cowork-safe foundry:** Cowork's sandbox blocks read/write
  to `~/.claude/`, so the default Code foundry is invisible there. Put your config
  and foundry under `~/lens/` instead (the hook discovers config in order:
  `$LENS_CONFIG` → `~/.claude/lens.json` → `~/lens/lens.json`), and grant Cowork
  filesystem access to `~/lens/`. Then the SessionEnd hook + `/lens:retro` work on
  Cowork's local VM. Run `/lens:setup` and choose the cross-surface (`~/lens/`)
  location.
- **Code-flavored, degrades gracefully:** `/lens:tdd` and stack detection assume a
  codebase; on a non-code project, detection finds no stack and falls back to the
  generic battery — nothing breaks, some lenses are just less relevant.
- **Personal lens authoring** (`/lens:new`) is Code-only for now (it writes to
  `~/.claude/skills/`, which Cowork's sandbox blocks); on Cowork use the built-in
  Customize flow to author skills. The loop (queue + retro) works on both.

To verify on your machine: `/lens:setup` (cross-surface location), grant Cowork access
to `~/lens/`, run `/lens:socratic` on a real task, end the session, and confirm a line
landed in `~/lens/foundry/pending-retros.jsonl`.

First-class, non-code lenses and depth packs for Cowork are on the roadmap. Feedback
and PRs from Cowork use are especially welcome.

## Commands

| Command | What it does |
|---|---|
| `/lens:socratic "<goal>"` | Socratic discovery → caveats, rabbit holes, blast radius, platform matrix → chains the right lenses, keeping a live mind-map of branches and knowing when to stop. `audit` re-runs the session's lens plan against the built code and verifies every recorded decision |
| `/lens:security` | Sessions, tokens, authz — design dialogue or code audit with file:line findings |
| `/lens:design` | Interface design, library-agnostic: ranked component candidates in YOUR design system, deep platform questions (PWA pack), and a professional critique of implemented UI (keep/refine/rework) |
| `/lens:usability` | End-user flows, missing states, navigation, i18n |
| `/lens:tdd` | Tests that earn their existence — kills mock-echo, implementation mirrors, and testing-for-testing's-sake |
| `/lens:retro` | Mine your queued sessions; propose new lenses and CLAUDE.md updates |
| `/lens:new` | Scaffold a new lens — personal (into `~/.claude/skills/`), or into the plugin repo if you maintain it |
| `/lens:setup` | Create YOUR personal memory loop, once per machine (optional) |

## Your own memory loop

Every user runs their OWN foundry — a private folder where the session-end hook
queues your lens sessions, `/lens:retro` mines them, and `/lens:new` grows lenses
that fit YOUR work. Personal lenses scaffold into `~/.claude/skills/` and load next
session — no fork, no plugin rebuild — and `/lens:socratic` plans with them alongside
the bundled set. Run `/lens:setup` once per machine to enable it: it picks the
location — `~/.claude/lens-foundry/` on Claude Code, or `~/lens/` for a cross-surface
setup that also works in Cowork (no git required). The hook finds the config in order:
`$LENS_CONFIG` → `~/.claude/lens.json` → `~/lens/lens.json`.

The lenses bundled with this plugin are the curated set published from the
maintainers' foundry. If one of your personal lenses earns its keep, PRs are
welcome. Without setup, all lenses and the orchestrator work out of the box; the
session-end hook silently does nothing.

### Project-scoped lenses

A repo can carry its own lenses. `/lens:new` (project scope) writes them to
`<repo>/.lens/lenses/<name>/SKILL.md` and `/lens:socratic` discovers them from the
repo root, merging into the plan **nearest-wins** (a project lens named `design`
overrides the bundled one for that repo) — the same way a nearer CLAUDE.md layers
over a farther one. `.lens/` is git-excluded by default; to share a lens with your
team, commit its `SKILL.md` to `<repo>/.claude/skills/lens-<name>/` instead (Claude
Code loads it natively). The memory loop stays global — project lenses are mined into
your one foundry like any other session.

## How it works

Lenses are three-tier question batteries (framing → stack-conditional → deep dives)
that share a session dossier, so no lens re-asks what another already learned —
you'll see `skipping: …` lines instead. The orchestrator keeps a live mind-map of the
branches each answer opens (the frontier) and knows when to stop — it digs into
high-stakes branches and defaults the trivial ones instead of interrogating forever.
Full anatomy in `core/`.

© 2026 Tiltely LLC · MIT

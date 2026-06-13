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

Releases are pinned to commit SHAs — every push to `main` is a new version. To
receive them automatically on startup, enable auto-update for the `tiltely`
marketplace in `~/.claude/settings.json`:

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
files and a shell. The Socratic discovery and the design / usability / cost lenses
apply just as well to non-code work as to code.

Cowork installs via its GUI, not the `/plugin` CLI commands (those are Claude Code
only), and keeps its own plugin state separate from Claude Code. In Cowork:
**Personal plugins → `+` → Create Plugin → Add Marketplace → Add from a repository**,
then enter `https://github.com/Tiltely/lens` and install `lens` from the catalog.

**Why Experimental:** the engine is built and tested on Claude Code; on Cowork it is
not yet fully verified end-to-end. What to expect:

- **Works:** the lenses and `/lens:socratic` (skills are cross-platform); the
  session-end hook and the personal memory loop run on Cowork's local VM — personal
  lenses scaffold to `~/.claude/skills/` (filesystem, no git needed).
- **Code-flavored, degrades gracefully:** `/lens:tdd` and stack detection assume a
  codebase; on a non-code project, detection finds no stack and falls back to the
  generic battery — nothing breaks, some lenses are just less relevant.
- **Verify once on your machine** before relying on the memory loop here: run
  `/lens:setup`, then `/lens:socratic` on a real task, end the session, and confirm a
  line landed in your foundry's `pending-retros.jsonl`. If your Cowork folder
  permissions allow that write, the loop is good.

First-class, non-code lenses and depth packs for Cowork are on the roadmap. Feedback
and PRs from Cowork use are especially welcome.

## Commands

| Command | What it does |
|---|---|
| `/lens:socratic "<goal>"` | Socratic discovery → caveats, rabbit holes, blast radius → chains the right lenses. `audit` re-runs the session's lens plan against the built code and verifies every recorded decision |
| `/lens:security` | Sessions, tokens, authz — design dialogue or code audit with file:line findings |
| `/lens:design` | Interface design, library-agnostic: ranked component candidates in YOUR design system, deep platform questions (PWA pack), and a professional critique of implemented UI (keep/refine/rework) |
| `/lens:usability` | End-user flows, missing states, navigation, i18n |
| `/lens:tdd` | Tests that earn their existence — kills mock-echo, implementation mirrors, and testing-for-testing's-sake |
| `/lens:retro` | Mine your queued sessions; propose new lenses and CLAUDE.md updates |
| `/lens:new` | Scaffold a proposed lens into the plugin |
| `/lens:setup` | Create YOUR personal memory loop, once per machine (optional) |

## Your own memory loop

Every user runs their OWN foundry — a private folder (default
`~/.claude/lens-foundry/`, no git required) where the session-end hook queues your
lens sessions, `/lens:retro` mines them, and `/lens:new` grows lenses that fit YOUR
work. Personal lenses scaffold into `~/.claude/skills/` and load next session — no
fork, no plugin rebuild — and `/lens:socratic` plans with them alongside the bundled
set. Run `/lens:setup` once per machine to enable it.

The lenses bundled with this plugin are the curated set published from the
maintainers' foundry. If one of your personal lenses earns its keep, PRs are
welcome. Without setup, all lenses and the orchestrator work out of the box; the
session-end hook silently does nothing.

## How it works

Lenses are three-tier question batteries (framing → stack-conditional → deep dives)
that share a session dossier, so no lens re-asks what another already learned —
you'll see `skipping: …` lines instead. Full anatomy in `core/`.

© 2026 Tiltely LLC · MIT

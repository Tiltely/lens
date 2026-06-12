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

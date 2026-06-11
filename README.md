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
| `/lens:socratic "<goal>"` | Socratic discovery → caveats, rabbit holes, blast radius → chains the right lenses |
| `/lens:security` | Sessions, tokens, authz — design dialogue or code audit with file:line findings |
| `/lens:shadcn-design` | UI composition: ranked shadcn/Tailwind candidates + the self-challenge |
| `/lens:usability` | End-user flows, missing states, navigation, i18n |
| `/lens:tdd` | Tests that earn their existence — kills mock-echo, implementation mirrors, and testing-for-testing's-sake |
| `/lens:retro` | Mine your queued sessions; propose new lenses and CLAUDE.md updates |
| `/lens:new` | Scaffold a proposed lens into the plugin |
| `/lens:setup` | Dev-machine setup for the private memory loop (optional) |

The memory loop (retro/foundry) is optional and lives OUTSIDE the plugin — your
session observations stay in your own private repo.

## How it works

Lenses are three-tier question batteries (framing → stack-conditional → deep dives)
that share a session dossier, so no lens re-asks what another already learned —
you'll see `skipping: …` lines instead. Full anatomy in `core/`.

© 2026 Tiltely LLC · MIT

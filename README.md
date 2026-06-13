<p align="center">
  <img src="assets/banner.gif" alt="lens — Socratic lenses for software engineering" width="640">
</p>

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

## Claude Cowork

The lenses and `/lens:socratic` work in Claude Cowork — skills are cross-platform, so
Socratic discovery and the design / usability lenses apply to knowledge work (planning,
prep, reports) just as they do to code. No setup, no config.

Install via Cowork's GUI (not the `/plugin` CLI, which is Claude Code only): **Personal
plugins → `+` → Create Plugin → Add Marketplace → Add from a repository**, then enter
`https://github.com/Tiltely/lens` and install `lens`.

**The memory loop is Claude Code only.** `/lens:setup`, the SessionEnd hook, `/lens:retro`
and `/lens:new` need a foundry and a firing hook — but Cowork runs the CLI with
`--setting-sources user`, so plugin-provided hooks never fire there, and its VM home is
ephemeral. So on Cowork you get the lenses; the learning loop (foundry, retro, growing
your own lenses) lives on Claude Code. Run `/lens:setup` on Code to enable it there.
Code-flavored lenses like `/lens:tdd` still load on Cowork; on non-code work they just
fall back to a generic battery.

## Commands

| Command | What it does |
|---|---|
| `/lens:socratic "<goal>"` | Socratic discovery → caveats, rabbit holes, blast radius, platform matrix → chains the right lenses, keeping a live mind-map of branches and knowing when to stop. `audit` re-runs the session's lens plan against the built code and verifies every recorded decision |
| `/lens:security` | Sessions, tokens, authz — design dialogue or code audit with file:line findings |
| `/lens:design` | Interface design, library-agnostic: ranked component candidates in YOUR design system, deep platform questions (PWA pack), and a professional critique of implemented UI (keep/refine/rework) |
| `/lens:usability` | End-user flows, missing states, navigation, i18n |
| `/lens:tdd` | Tests that earn their existence — kills mock-echo, implementation mirrors, and testing-for-testing's-sake |
| `/lens:adversary` | Red-teams a plan before you commit — refutes it, finds the weakest decision and what discovery missed. Runs automatically as `/lens:socratic`'s final step; also standalone on any plan/diff |
| `/lens:retro` | Mine your queued sessions; propose new lenses and CLAUDE.md updates |
| `/lens:new` | Scaffold a new lens — global (your foundry) or project (`<repo>/.lens/`); used via `/lens:socratic`, read-inline. (Inside the plugin repo it also offers the bundled set — auto-detected, never asked.) |
| `/lens:setup` | Create YOUR personal memory loop, once per machine (optional) |

## One kind of lens, one interface

Every lens — bundled or one you create — is used the same way: through
`/lens:socratic`, which discovers and applies all of them. There is no "personal vs
plugin" lens; there are just lenses, and where each is registered decides only its
reach (nearest-wins, like a nearer CLAUDE.md). The bundled lenses additionally get a
`/lens:<name>` shortcut — that's a Claude Code namespace convenience, not a different
class of lens.

You grow your own collection with `/lens:new`, choosing a scope:

- **Global** → `<foundry>/lenses/<name>/` — applies everywhere on this machine.
- **Project** → `<repo>/.lens/lenses/<name>/` — applies only in that repo, and
  overrides a bundled lens of the same name there.

Both are registered in their `registry.md` and **read-inline by `/lens:socratic`** —
no `~/.claude/skills` copy, no second slash syntax, no reload. They live outside the
plugin, so auto-updates never touch your collection. To give a project lens its own
slash command or share it with a team, commit its `SKILL.md` to
`<repo>/.claude/skills/lens-<name>/` (Claude Code loads that one natively).

## Your own memory loop (Claude Code)

The session-end hook queues your lens sessions into your foundry, `/lens:retro` mines
them, and `/lens:new` grows your collection. Run `/lens:setup` once per machine: it
creates the foundry (default `~/.claude/lens-foundry/`; any non-git folder works) and
writes `~/.claude/lens.json`. The foundry holds personal session data — **keep it out
of git**. The loop is single per machine: project lenses are mined into your one
foundry like any other session. Without setup, all lenses and `/lens:socratic` still
work; only the hook silently does nothing.

The loop is a **Claude Code feature** — see the Cowork section above for why it does
not run on Cowork (the lenses do).

## How it works

Lenses are three-tier question batteries (framing → stack-conditional → deep dives)
that share a session dossier, so no lens re-asks what another already learned —
you'll see `skipping: …` lines instead. The orchestrator keeps a live mind-map of the
branches each answer opens (the frontier) and knows when to stop — it digs into
high-stakes branches and defaults the trivial ones instead of interrogating forever.
Full anatomy in `core/`.

© 2026 Tiltely LLC · MIT

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
- **Memory loop — needs a Cowork-safe foundry:** Cowork blocks `~/.claude/` AND its VM
  home (`~`) is EPHEMERAL, so the foundry must be a REAL, persistent folder you GRANT
  Cowork access to (e.g. `/Users/<you>/lens-foundry/`) — never under `~`. Point
  `$LENS_CONFIG` (or the config there) at it; for one shared loop, point Code at the
  same real folder. Then the SessionEnd hook + `/lens:retro` work on Cowork's VM. Run
  `/lens:setup` — it detects Cowork and walks you through granting a folder. **Never
  put the foundry in a git working tree** (personal session data).
- **Code-flavored, degrades gracefully:** `/lens:tdd` and stack detection assume a
  codebase; on a non-code project, detection finds no stack and falls back to the
  generic battery — nothing breaks, some lenses are just less relevant.
- **Authoring your own lenses** (`/lens:new`) works on Cowork too: lenses you create
  go into your foundry (`<foundry>/lenses/`) or a project's `.lens/` and are
  read-inline by `/lens:socratic` — no `~/.claude/skills/` write, so the sandbox block
  doesn't apply. The loop (queue + retro) and authoring both work on Code and Cowork.

To verify on your machine: `/lens:setup`, grant Cowork your chosen real folder, run
`/lens:socratic` on a real task, end the session, and confirm a line landed in
`<that folder>/pending-retros.jsonl`.

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

## Your own memory loop

The session-end hook queues your lens sessions into your foundry, `/lens:retro` mines
them, and `/lens:new` grows your collection. Run `/lens:setup` once per machine: it
picks the foundry location — `~/.claude/lens-foundry/` on Claude Code, or a real
granted folder (e.g. `/Users/<you>/lens-foundry/`) on Cowork, whose VM home is
ephemeral. The hook finds the config in order: `$LENS_CONFIG` → `~/.claude/lens.json`
→ `~/lens/lens.json`. The foundry holds personal session data — **keep it out of git**
(gitignore it if it must live in a repo). The loop stays global — project lenses are
mined into your one foundry like any other session. Without setup, all lenses and
`/lens:socratic` still work; only the hook
silently does nothing.

## How it works

Lenses are three-tier question batteries (framing → stack-conditional → deep dives)
that share a session dossier, so no lens re-asks what another already learned —
you'll see `skipping: …` lines instead. The orchestrator keeps a live mind-map of the
branches each answer opens (the frontier) and knows when to stop — it digs into
high-stakes branches and defaults the trivial ones instead of interrogating forever.
Full anatomy in `core/`.

© 2026 Tiltely LLC · MIT

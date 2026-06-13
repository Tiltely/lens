---
name: setup
description: One-time setup of YOUR lens memory loop on Claude Code — your foundry where the SessionEnd hook queues lens sessions, /lens:retro mines them, and /lens:new grows your collection. Use when the user runs /lens:setup, or when a foundry-dependent skill (retro, new) finds no config. Claude Code only — the loop is not supported on Cowork.
---

# Lens Setup (Claude Code)

The memory loop — a SessionEnd hook that queues lens sessions, `/lens:retro` to mine
them, `/lens:new` to grow your collection — is a **Claude Code feature**. Setup
creates your foundry and wires it up. Without setup, all bundled lenses and
`/lens:socratic` still work; setup only adds the loop.

## On Claude Cowork: not supported — stop here

If you detect Cowork, do NOT set up a foundry. The memory loop does not run on Cowork:
its sandbox spawns the CLI with `--setting-sources user`, so plugin-provided hooks (the
SessionEnd queue) never fire, and the VM home is ephemeral. Tell the user plainly: on
Cowork, just use the lenses and `/lens:socratic` directly — they work fully. Run
`/lens:setup` on Claude Code to enable the loop there. Then stop — no foundry, no
config, no folder grant.

## On Claude Code: set up the loop

The foundry holds PERSONAL session data (session IDs, project/transcript paths, mined
observations) — **never commit it to git**. Use a private, persistent, non-tracked
folder.

1. **Choose the foundry location** — default `~/.claude/lens-foundry/`; any non-git
   folder is fine, but NEVER inside a git working tree. Create it with empty
   `pending-retros.jsonl` and `processed-retros.jsonl`, an `observations.md` with a
   one-line header ("Cross-project learnings mined by /lens:retro; append-only"), a
   `registry.md` (your lenses — same columns as `${CLAUDE_PLUGIN_ROOT}/core/registry.md`,
   starting empty), and an empty `lenses/` dir (where `/lens:new` writes your global
   lenses; `/lens:socratic` reads them inline).
2. **Write the config** at `~/.claude/lens.json` (show the user first):

       { "foundry": "<foundry path>" }

3. **Hand the user the cross-cwd permission rule** so retro/hook writes never prompt
   from other projects' sessions. Do NOT edit `~/.claude/settings.json` yourself —
   permission-widening by an agent is blocked by the auto-mode classifier by design.
   Print a paste-ready `node -e` one-liner the USER runs, merging into their settings
   and preserving everything else:

       permissions.additionalDirectories += "<foundry path>"
       permissions.allow += [ "Edit(//<foundry path>/**)", "Write(//<foundry path>/**)" ]

   Optional — without it the user just gets a one-time prompt on the first cross-project
   foundry write.
4. **Verify**: run `${CLAUDE_PLUGIN_ROOT}/scripts/queue-retro.sh` with no stdin — it
   must exit 0 silently. Confirm the config parses (cat it back).
5. Tell the user: the SessionEnd hook now queues lens-using sessions; run /lens:retro
   to process them, /lens:new to grow your collection (used via /lens:socratic — not
   as separate slash commands).

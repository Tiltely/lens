---
name: setup
description: One-time per-machine setup of YOUR lens memory loop - a personal foundry where the session hook queues lens sessions, /lens:retro mines them, and /lens:new grows your personal lens collection. Use when the user runs /lens:setup, or when a foundry-dependent skill (retro, new) finds ~/.claude/lens.json missing and the user wants to fix that.
---

# Lens Setup (any machine)

Every user runs their OWN foundry. The lenses bundled with this plugin are the
curated set published from the maintainers' foundry — yours grows the lenses that
fit YOUR work. Machines without setup still get all bundled lenses and
/lens:socratic; setup only enables the memory loop.

## Steps

1. **Choose the foundry location.**
   - Default: `~/.claude/lens-foundry/` — a plain directory, no git required.
   - Power option: a directory inside a private git repo of the user's, if they
     want the ledger versioned and synced across machines.
   Create it with empty `pending-retros.jsonl` and `processed-retros.jsonl`, an
   `observations.md` with a one-line header ("Cross-project learnings mined by
   /lens:retro; append-only"), and a `registry.md` — the PERSONAL lens registry:
   same table columns as `${CLAUDE_PLUGIN_ROOT}/core/registry.md`, starting empty.
2. **(Maintainers only) plugin repo.** If the user has a writable clone of a lens
   plugin repo and wants /lens:new to commit lenses INTO the plugin, note its path.
   Everyone else skips this — personal lenses go to `~/.claude/skills/` instead.
3. **Write `~/.claude/lens.json`** (show the user before writing; `pluginRepo`
   only if step 2 applied):

       {
         "foundry": "<foundry path>",
         "pluginRepo": "<plugin repo path — optional, maintainers only>"
       }

4. **Hand the user the cross-cwd permission rule** so retro/hook writes never prompt
   from other projects' sessions. Do NOT edit `~/.claude/settings.json` yourself —
   permission-widening by an agent is blocked by Claude Code's auto-mode classifier
   by design, even when a skill instructs it. Instead, print a single paste-ready
   command (e.g. a `node -e` one-liner prefixed with `!`) that the USER runs to merge
   into their settings, preserving everything else:

       permissions.additionalDirectories += "<foundry path>"
       permissions.allow += [
         "Edit(//<foundry path>/**)",
         "Write(//<foundry path>/**)"
       ]

   (Maintainers also add: `"Bash(git -C <plugin repo path> *)"`.) This step is
   optional: without it everything still works — the user just gets a one-time
   permission prompt on the first cross-project foundry write.
5. **Verify**: run the plugin's `scripts/queue-retro.sh` with no stdin — it must
   exit 0 silently. Confirm `~/.claude/lens.json` parses (cat it back).
6. Tell the user: config written; the SessionEnd hook will now queue lens-using
   sessions; run /lens:retro to process them, and /lens:new to grow personal lenses.

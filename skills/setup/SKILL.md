---
name: setup
description: One-time per-machine setup of YOUR lens memory loop - your own foundry where the session hook queues lens sessions, /lens:retro mines them, and /lens:new grows your lens collection. Use when the user runs /lens:setup, or when a foundry-dependent skill (retro, new) finds ~/.claude/lens.json missing and the user wants to fix that.
---

# Lens Setup (any machine)

Every user runs their OWN foundry. The lenses bundled with this plugin are the
curated set published from the maintainers' foundry — yours grows the lenses that
fit YOUR work. Machines without setup still get all bundled lenses and
/lens:socratic; setup only enables the memory loop.

The foundry holds PERSONAL session data (queues with session IDs, project and
transcript paths; mined observations). **It must never be committed to git.** Pick a
private, persistent, NON-tracked folder.

First, detect the surface, because it changes WHERE config and foundry can live:
- **Claude Code** → `~/.claude/` is fully writable; use the Code-native default.
- **Claude Cowork** → the sandbox BLOCKS `~/.claude/` AND the VM home (`~`) is
  EPHEMERAL — anything under `~` (including `~/lens/`) vanishes between sessions. The
  foundry MUST be a REAL, persistent folder on the user's machine that they GRANT
  Cowork access to (e.g. `/Users/<you>/lens-foundry`). If you cannot tell the surface,
  ask the user.

## Steps

1. **Choose the foundry + config location.** Never inside a git working tree (or if
   unavoidable, gitignore the whole `foundry/` directory).
   - **Code default:** foundry `~/.claude/lens-foundry/`, config `~/.claude/lens.json`.
   - **Cowork / cross-surface:** a real granted folder OUTSIDE `~/.claude/` and NOT
     under the ephemeral `~` — e.g. `/Users/<you>/lens-foundry/`, with config at
     `<that folder>/lens.json` and `$LENS_CONFIG` pointing to it. For ONE shared loop
     across Code and Cowork, point both at the same real folder. The hook discovers
     config: `$LENS_CONFIG` → `~/.claude/lens.json` → `~/lens/lens.json`.
   - **Cross-machine sync:** if you want the foundry synced (e.g. via a private repo),
     you MUST gitignore the transient files — `pending-retros.jsonl`,
     `processed-retros.jsonl`, `.lens-dossier.md` — they are personal session data and
     never belong in version control. Only consider committing curated
     `observations.md` / `registry.md` / `lenses/` deliberately.
   Create the foundry dir with empty `pending-retros.jsonl` and
   `processed-retros.jsonl`, an `observations.md` with a one-line header
   ("Cross-project learnings mined by /lens:retro; append-only"), a `registry.md` —
   the registry of YOUR lenses, same columns as `${CLAUDE_PLUGIN_ROOT}/core/registry.md`,
   starting empty — and an empty `lenses/` dir (where `/lens:new` writes your global
   lenses; `/lens:socratic` reads them inline).
2. **(Maintainers only) plugin repo.** If the user has a writable clone of a lens
   plugin repo and wants /lens:new to commit lenses INTO the bundled set, note its
   path. Everyone else skips this — lenses you create live in your foundry
   (`<foundry>/lenses/`) or a project's `.lens/`, read-inline by /lens:socratic, never
   as separate skills. This works identically on Code and Cowork (read-inline needs no
   skill loading).
3. **Write the config** at the location chosen in step 1 (`~/.claude/lens.json` for
   Code, `~/lens/lens.json` for cross-surface). Show the user before writing;
   `pluginRepo` only if step 2 applied:

       {
         "foundry": "<foundry path>",
         "pluginRepo": "<plugin repo path — optional, maintainers only>"
       }

   **Cowork only:** tell the user to grant Cowork filesystem access to the foundry
   folder (and `~/lens/`) so the SessionEnd hook can read the config and write the
   queue from inside Cowork's VM. Without that grant the loop silently no-ops there.

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
   exit 0 silently. Confirm the config you wrote parses (cat it back).
6. Tell the user: config written; the SessionEnd hook will now queue lens-using
   sessions; run /lens:retro to process them, and /lens:new to grow your lens
   collection (used via /lens:socratic — not as separate slash commands).

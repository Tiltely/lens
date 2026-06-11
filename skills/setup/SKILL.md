---
name: setup
description: One-time dev-machine setup for the lens plugin's memory loop. Use when the user runs /lens:setup, or when a foundry-dependent skill (retro, new) finds ~/.claude/lens.json missing and the user wants to fix that.
---

# Lens Setup (dev machines only)

Configures the machine so the memory loop (hook → queue → retro → ledger) works.
Machines without this config still get all lenses and /lens:socratic — setup is only
for machines that hold the private foundry.

## Steps

1. **Locate the plugin repo.** Check `/Users/leonardo/Tiltely/lens`, else ask the
   user, else offer: `git clone git@github.com:Tiltely/lens.git`.
2. **Locate the foundry.** Check `/Users/leonardo/Tiltely/claude/foundry`, else ask.
   If the directory does not exist inside an existing `Tiltely/claude` clone, create
   it with empty `observations.md`, `pending-retros.jsonl`, `processed-retros.jsonl`.
3. **Write `~/.claude/lens.json`** (show the user before writing):

       {
         "pluginRepo": "<plugin repo path>",
         "foundry": "<foundry path>"
       }

4. **Install the cross-cwd permission rule** so retro/hook writes never prompt from
   other projects' sessions. Merge into `~/.claude/settings.json` (create keys if
   absent, preserve everything else):

       {
         "permissions": {
           "additionalDirectories": ["<foundry path>"],
           "allow": [
             "Edit(//<foundry path>/**)",
             "Write(//<foundry path>/**)",
             "Bash(git -C <plugin repo path> *)"
           ]
         }
       }

5. **Verify**: run `sh "<plugin repo path>/scripts/queue-retro.sh"` with no stdin —
   it must exit 0 silently. Confirm `~/.claude/lens.json` parses (cat it back).
6. Tell the user: config written; the SessionEnd hook will now queue lens-using
   sessions; run /lens:retro to process them.

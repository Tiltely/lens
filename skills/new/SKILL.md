---
name: new
description: Scaffold a new lens for this plugin. Use when /lens:retro proposed a lens, or a recurring theme has no lens. Takes a lens name (kebab-case) and a one-line purpose.
---

# New Lens Scaffolder

Requires `pluginRepo` in `~/.claude/lens.json`. If absent: write the drafted lens to
`./lens-proposal-<name>.md` in the cwd with a note on how to add it later, and stop.

## Steps

1. **Preconditions** (in `<pluginRepo>`): checkout on the default branch, clean tree.
   If not, stop and tell the user exactly what is off.
2. **Name check**: kebab-case; dir `skills/<name>/` must not exist; name must not
   collide with a registry row.
3. **Draft the battery socratically** — interview the user briefly (protocol.md
   rules, one question at a time): what does this lens examine? what are its 2
   framing questions? which contexts condition Tier 2? Target 8–12 questions total.
   If retro provided sample questions, start from those.
4. **Scaffold**: copy `${CLAUDE_PLUGIN_ROOT}/templates/lens-template/SKILL.md` to
   `<pluginRepo>/skills/<name>/SKILL.md`, replacing every `{{PLACEHOLDER}}` with the
   drafted content. No placeholder may survive — grep for `{{` to verify.
5. **Register**: append the row to `<pluginRepo>/core/registry.md` (type `lens`,
   modes `design`, purpose, trigger signals). Remove the lens from the "Planned"
   list if it was there.
6. **Show the full diff** (`git -C <pluginRepo> diff`). On explicit approval only:

       git -C <pluginRepo> add skills/<name> core/registry.md
       git -C <pluginRepo> commit -m "feat(skill): lens:<name> (scaffolded via /lens:new)"

   Offer to push. Never push unasked.
7. Remind: new skills load on next session (or /reload-plugins with --plugin-dir).

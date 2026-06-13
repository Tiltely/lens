---
name: new
description: Scaffold a new lens for this plugin. Use when /lens:retro proposed a lens, or a recurring theme has no lens. Takes a lens name (kebab-case) and a one-line purpose.
---

# New Lens Scaffolder

First ask the user which SCOPE the new lens should have (offer the ones that apply):

- **Project** — applies only in THIS repo. Available whenever cwd is inside a git
  repo. Draft the battery (step 3 below), then write it to
  `<repo>/.lens/lenses/<name>/SKILL.md` from the template (no surviving placeholders),
  append the row to `<repo>/.lens/registry.md` (create it if absent), and exclude
  `.lens/` from git: append to the repo's exclude file resolved via
  `git rev-parse --git-path info/exclude` (handles worktrees/submodules); if that
  fails, PROPOSE a `.gitignore` entry — never silently edit `.gitignore`. No commit,
  no plugin rebuild — `/lens:socratic` reads it inline next run. To share it with the
  team instead, commit its SKILL.md to `<repo>/.claude/skills/lens-<name>/`.
- **Personal** (global) — `foundry` in the lens config (discover first-readable-wins:
  `$LENS_CONFIG` → `~/.claude/lens.json` → `~/lens/lens.json`). Draft the battery,
  write it to `~/.claude/skills/lens-<name>/SKILL.md` from the template, append the
  row to `<foundry>/registry.md`. It becomes **directly invocable as `/lens-<name>`**
  after `/reload-plugins` (or a new session) — AND it lives outside the plugin, so
  plugin auto-updates never touch it. `/lens:socratic` also plans with it. A personal
  lens that earns its keep can be PR'd to the public plugin repo.
- **Into the plugin (maintainer)** — `pluginRepo` set in the config: full steps below.
- **No config and not in a repo:** write the drafted lens to `./lens-proposal-<name>.md`
  in the cwd with a note on how to add it later, and point the user at /lens:setup.

## Steps (maintainer path)

1. **Preconditions** (in `<pluginRepo>`): checkout on the default branch, clean tree.
   If not, stop and tell the user exactly what is off.
2. **Name check**: kebab-case; dir `skills/<name>/` must not exist; name must not
   collide with a registry row. Enforce lens agnosticism (core/protocol.md): reject
   names coupled to a library or framework unless the lens's SUBJECT is that
   technology — "design", not "shadcn-design"; "data-privacy", not "prisma-privacy".
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

---
name: new
description: Scaffold a new lens for this plugin. Use when /lens:retro proposed a lens, or a recurring theme has no lens. Takes a lens name (kebab-case) and a one-line purpose.
---

# New Lens Scaffolder

Every lens — bundled or one you create — is used the same way: through
`/lens:socratic`, which discovers and applies it. Lenses you create are NOT separate
slash commands; only the bundled set has `/lens:<name>` shortcuts (a Claude Code
namespace limit, not a choice). So a new lens just needs a HOME + a registry row that
socratic reads. Draft the battery socratically first (step 3), then write it to the
chosen scope — no commit, no plugin rebuild, no reload; socratic reads it fresh.

Offer the SCOPE — but only the options that apply to the current context (never ask
about "maintaining the plugin"; that option appears on its own, below, only when you
detect you're inside the lens plugin repo):

- **Project** — applies only in THIS repo (when cwd is in a git repo). Write to
  `<repo>/.lens/lenses/<name>/SKILL.md` from the template (no surviving placeholders),
  append the row to `<repo>/.lens/registry.md` (create if absent), and git-exclude
  `.lens/` via `git rev-parse --git-path info/exclude` (handles worktrees/submodules;
  on failure PROPOSE a `.gitignore` entry — never silently edit it). To SHARE it with
  the team, commit its SKILL.md to `<repo>/.claude/skills/lens-<name>/` (Claude Code
  loads that one natively as a slash command).
- **Global** — applies everywhere on this machine. Write to
  `<foundry>/lenses/<name>/SKILL.md` and append the row to `<foundry>/registry.md`
  (foundry from the config: `$LENS_CONFIG` → `~/.claude/lens.json` → `~/lens/lens.json`).
  Lives in the foundry, outside the plugin — auto-updates never touch it. A global
  lens that earns its keep can be PR'd into the bundled set.
- **No foundry config and not in a repo:** write the drafted lens to
  `./lens-proposal-<name>.md` with a note on how to add it later, and point at /lens:setup.

**Maintainer path — auto-detected, never asked.** Offer "into the bundled set" ONLY
when the current git repo IS the lens plugin itself — detect it: the repo root
(`git rev-parse --show-toplevel`) contains `.claude-plugin/plugin.json` whose `name`
is `lens`. That is the only signal; there is no `pluginRepo` config and no setup
question. If detected, the steps below apply (the plugin repo is the cwd's repo root).

## Steps (maintainer path — only when inside the lens plugin repo)

1. **Preconditions** (in the plugin repo root): checkout on the default branch, clean
   tree. If not, stop and tell the user exactly what is off.
2. **Name check**: kebab-case; dir `skills/<name>/` must not exist; name must not
   collide with a registry row. Enforce lens agnosticism (core/protocol.md): reject
   names coupled to a library or framework unless the lens's SUBJECT is that
   technology — "design", not "shadcn-design"; "data-privacy", not "prisma-privacy".
3. **Draft the battery socratically** — interview the user briefly (protocol.md
   rules, one question at a time): what does this lens examine? what are its 2
   framing questions? which contexts condition Tier 2? Target 8–12 questions total.
   If retro provided sample questions, start from those.
4. **Scaffold**: copy `${CLAUDE_PLUGIN_ROOT}/templates/lens-template/SKILL.md` to
   `<plugin-root>/skills/<name>/SKILL.md`, replacing every `{{PLACEHOLDER}}` with the
   drafted content. No placeholder may survive — grep for `{{` to verify.
5. **Register**: append the row to `<plugin-root>/core/registry.md` (type `lens`,
   modes `design`, purpose, trigger signals). Remove the lens from the "Planned"
   list if it was there.
6. **Show the full diff** (`git -C <plugin-root> diff`). On explicit approval only:

       git -C <plugin-root> add skills/<name> core/registry.md
       git -C <plugin-root> commit -m "feat(skill): lens:<name> (scaffolded via /lens:new)"

   Offer to push. Never push unasked.
7. Remind: new skills load on next session (or /reload-plugins with --plugin-dir).

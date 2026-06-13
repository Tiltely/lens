---
name: retro
description: The memory loop. Use when closing significant work or weekly — processes queued lens sessions, mines them for patterns, proposes new lenses / lens updates / CLAUDE.md diffs, and writes approved observations to the foundry ledger. Also accepts an explicit transcript path or session_id as argument.
---

# Lens Retro

Requires a lens config with `foundry` set. Discover it first-readable-wins:
`$LENS_CONFIG` → `~/.claude/lens.json` → `~/lens/lens.json` (the last is the
Cowork-safe location, outside the sandbox-blocked `~/.claude/`). If none is found:
explain in one line, point to /lens:setup, stop. Never error.

## Compute the pending set

1. Read `<foundry>/pending-retros.jsonl` and `<foundry>/processed-retros.jsonl`.
2. Pending = entries whose `session_id` is NOT in the processed file. (Both files are
   append-only. NEVER rewrite or truncate them — a SessionEnd hook may append
   concurrently.)
3. Gap entries (`"type":"gap"`) are pending until a processed marker with their
   date+lens+note hash appears; treat each as a one-line observation candidate.
4. If the user passed an explicit transcript/session argument, process only that.

## Process each entry (serially, v1)

For session entries, read the transcript (it is JSONL; grep/skim for the lens
questions, user answers, friction moments — do not load the whole file blindly if
it is huge). Ask of each:
- What questions arose that NO current lens covers? (check core/registry.md)
- Did a lens perform poorly — wrong tier order, dumb question, missed follow-up?
- Did durable PROJECT facts surface that are missing from that project's CLAUDE.md?
If the transcript file no longer exists: mark processed, note "transcript gone", skip.

## Cross-entry synthesis

After individual passes, look across entries for repetition. A pattern seen ≥2 times
is a proposal candidate:
- **New lens** → name it, one-line purpose, 3 sample questions → on approval, hand to
  /lens:new (which routes to the plugin repo for maintainers, or to a personal lens
  in ~/.claude/skills for everyone else).
- **Lens update** → for a PERSONAL lens (~/.claude/skills/lens-*): concrete diff,
  apply on approval. For a bundled lens: requires `pluginRepo` in config; if absent,
  emit the diff as a local file and suggest a PR to the public plugin repo.
- **CLAUDE.md update** → concrete diff, addressed to the specific project's CLAUDE.md.

## The approval gate

EVERY proposal — observation, lens, update, CLAUDE.md diff — is shown to the user and
applied only on explicit approval. Nothing auto-applies. Rejected proposals are
recorded as processed (so they don't reappear) with `"rejected":true`.

## Close the loop

- Append approved observations to `<foundry>/observations.md` (date + one paragraph
  each; link the sessions they came from).
- Append `{"session_id":"<id>","processed_date":"<YYYY-MM-DD>"}` per handled entry to
  `<foundry>/processed-retros.jsonl`.
- Knowledge routing: cross-project insight → ledger; project-specific fact → that
  project's CLAUDE.md. Never both.

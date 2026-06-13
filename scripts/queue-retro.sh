#!/bin/sh
# SessionEnd hook for the lens plugin: queue lens-using sessions for /lens:retro.
# Every exit path is 0 — this script must never block or fail a session.

INPUT=$(cat 2>/dev/null) || exit 0

transcript=$(printf '%s' "$INPUT" | sed -n 's/.*"transcript_path"[[:space:]]*:[[:space:]]*"\([^"]*\)".*/\1/p')
session=$(printf '%s' "$INPUT" | sed -n 's/.*"session_id"[[:space:]]*:[[:space:]]*"\([^"]*\)".*/\1/p')
cwd=$(printf '%s' "$INPUT" | sed -n 's/.*"cwd"[[:space:]]*:[[:space:]]*"\([^"]*\)".*/\1/p')

[ -n "$transcript" ] && [ -f "$transcript" ] || exit 0

# Only queue sessions that actually used a lens skill — plugin lenses
# ("lens:security") or personal ones from ~/.claude/skills ("lens-parity").
lenses=$(grep -o '"skill":"lens[:-][^"]*"' "$transcript" 2>/dev/null \
  | sed 's/.*"lens[:-]\([^"]*\)"/\1/' | sort -u | paste -sd, -)
[ -n "$lenses" ] || exit 0

# Config discovery, first READABLE wins: env override → Code-native (~/.claude) →
# cross-surface (~/lens, outside the dir Cowork's sandbox blocks). Use -r not -f:
# on Cowork ~/.claude/lens.json may exist-but-be-unreadable, so fall through.
CONFIG=""
for c in "$LENS_CONFIG" "$HOME/.claude/lens.json" "$HOME/lens/lens.json"; do
  [ -n "$c" ] && [ -r "$c" ] && { CONFIG="$c"; break; }
done
[ -n "$CONFIG" ] || exit 0
foundry=$(sed -n 's/.*"foundry"[[:space:]]*:[[:space:]]*"\([^"]*\)".*/\1/p' "$CONFIG")
[ -n "$foundry" ] && [ -d "$foundry" ] || exit 0

pending="$foundry/pending-retros.jsonl"
processed="$foundry/processed-retros.jsonl"

# Dedupe across resume/clear refirings and already-processed sessions.
if [ -n "$session" ]; then
  grep -qs "\"session_id\":\"$session\"" "$pending" "$processed" 2>/dev/null && exit 0
fi

printf '{"date":"%s","session_id":"%s","project":"%s","transcript_path":"%s","lenses_used":"%s"}\n' \
  "$(date +%Y-%m-%dT%H:%M:%S)" "$session" "$cwd" "$transcript" "$lenses" \
  >> "$pending" 2>/dev/null
exit 0

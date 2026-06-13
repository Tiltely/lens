#!/bin/sh
# Tests for scripts/queue-retro.sh. Run from repo root: sh tests/test-queue-retro.sh
PASS=0; FAIL=0
SCRIPT="$(pwd)/scripts/queue-retro.sh"
TMP=$(mktemp -d)
export HOME="$TMP/home"
mkdir -p "$HOME/.claude" "$TMP/foundry" "$TMP/transcripts"
PENDING="$TMP/foundry/pending-retros.jsonl"
PROCESSED="$TMP/foundry/processed-retros.jsonl"
touch "$PENDING" "$PROCESSED"

assert() { # $1 desc, $2 expected, $3 actual
  if [ "$2" = "$3" ]; then PASS=$((PASS+1)); echo "  ok: $1"
  else FAIL=$((FAIL+1)); echo "  FAIL: $1 (expected [$2] got [$3])"; fi
}

mk_input() { # $1 transcript path, $2 session id
  printf '{"session_id":"%s","transcript_path":"%s","cwd":"/proj","reason":"exit"}' "$2" "$1"
}

# Transcript WITH a lens skill invocation
LENS_T="$TMP/transcripts/lens.jsonl"
printf '%s\n' '{"role":"assistant","content":"x","skill":"lens:security"}' > "$LENS_T"
# Transcript WITHOUT any lens usage
PLAIN_T="$TMP/transcripts/plain.jsonl"
printf '%s\n' '{"role":"user","content":"hello"}' > "$PLAIN_T"

echo "1) no config -> silent no-op, exit 0"
rm -f "$HOME/.claude/lens.json"
out=$(mk_input "$LENS_T" s1 | sh "$SCRIPT" 2>&1); rc=$?
assert "exit 0" "0" "$rc"; assert "no output" "" "$out"
assert "queue untouched" "0" "$(wc -l < "$PENDING" | tr -d ' ')"

printf '{\n  "pluginRepo": "%s",\n  "foundry": "%s"\n}\n' "$TMP/plugin" "$TMP/foundry" > "$HOME/.claude/lens.json"

echo "2) no lens usage -> silent no-op"
mk_input "$PLAIN_T" s2 | sh "$SCRIPT"; rc=$?
assert "exit 0" "0" "$rc"
assert "queue untouched" "0" "$(wc -l < "$PENDING" | tr -d ' ')"

echo "3) lens session -> queued with fields"
mk_input "$LENS_T" s3 | sh "$SCRIPT"; rc=$?
assert "exit 0" "0" "$rc"
assert "one entry" "1" "$(wc -l < "$PENDING" | tr -d ' ')"
line=$(cat "$PENDING")
case "$line" in *'"session_id":"s3"'*) assert "has session_id" y y;; *) assert "has session_id" y n;; esac
case "$line" in *'"lenses_used":"security"'*) assert "lenses extracted" y y;; *) assert "lenses extracted" y n;; esac

echo "4) duplicate session_id -> deduped"
mk_input "$LENS_T" s3 | sh "$SCRIPT"
assert "still one entry" "1" "$(wc -l < "$PENDING" | tr -d ' ')"

echo "5) session already processed -> not re-queued"
printf '{"session_id":"s4","processed_date":"2026-06-12"}\n' >> "$PROCESSED"
mk_input "$LENS_T" s4 | sh "$SCRIPT"
assert "not queued" "1" "$(wc -l < "$PENDING" | tr -d ' ')"

echo "6) missing transcript file -> silent no-op"
mk_input "$TMP/transcripts/gone.jsonl" s5 | sh "$SCRIPT"; rc=$?
assert "exit 0" "0" "$rc"
assert "queue untouched" "1" "$(wc -l < "$PENDING" | tr -d ' ')"

echo "7) personal lens (lens-<name> skill in ~/.claude/skills) -> queued too"
PERSONAL_T="$TMP/transcripts/personal.jsonl"
printf '%s\n' '{"role":"assistant","content":"x","skill":"lens-parity"}' > "$PERSONAL_T"
mk_input "$PERSONAL_T" s6 | sh "$SCRIPT"; rc=$?
assert "exit 0" "0" "$rc"
assert "two entries" "2" "$(wc -l < "$PENDING" | tr -d ' ')"
last=$(tail -1 "$PENDING")
case "$last" in *'"lenses_used":"parity"'*) assert "personal lens extracted" y y;; *) assert "personal lens extracted" y n;; esac

echo "8) config at ~/lens/lens.json (Cowork-safe, ~/.claude unreadable) -> discovered"
rm -f "$HOME/.claude/lens.json"           # ~/.claude config gone (sandbox-blocked)
mkdir -p "$HOME/lens" "$TMP/foundry2"
P2="$TMP/foundry2/pending-retros.jsonl"; touch "$P2" "$TMP/foundry2/processed-retros.jsonl"
printf '{\n  "foundry": "%s"\n}\n' "$TMP/foundry2" > "$HOME/lens/lens.json"
mk_input "$LENS_T" s7 | sh "$SCRIPT"; rc=$?
assert "exit 0" "0" "$rc"
assert "queued to ~/lens foundry" "1" "$(wc -l < "$P2" | tr -d ' ')"

echo "9) LENS_CONFIG env override wins"
mkdir -p "$TMP/foundry3"; P3="$TMP/foundry3/pending-retros.jsonl"
touch "$P3" "$TMP/foundry3/processed-retros.jsonl"
printf '{ "foundry": "%s" }\n' "$TMP/foundry3" > "$TMP/custom-lens.json"
LENS_CONFIG="$TMP/custom-lens.json" mk_input "$LENS_T" s8 | LENS_CONFIG="$TMP/custom-lens.json" sh "$SCRIPT"; rc=$?
assert "exit 0" "0" "$rc"
assert "queued to env-pointed foundry" "1" "$(wc -l < "$P3" | tr -d ' ')"

rm -rf "$TMP"
echo ""; echo "pass=$PASS fail=$FAIL"
[ "$FAIL" = "0" ] || exit 1

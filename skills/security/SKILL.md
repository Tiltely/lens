---
name: security
description: The Lens of Security — Socratic question battery over sessions, auth, tokens, secrets, and authorization. Use for any feature touching login, tokens, payments, user data, webhooks, file uploads, or anything an attacker would love. Modes - design (questions to the user) and audit (questions to the code).
---

# The Lens of Security

Read first: ${CLAUDE_PLUGIN_ROOT}/core/protocol.md and ${CLAUDE_PLUGIN_ROOT}/core/dossier.md.

## Mode selection

- Explicit argument wins ("audit" / "design").
- Otherwise infer: planning new work → design; reviewing existing code → audit.
  Confirm your inference in one line before starting.
- Audit mode: below.

## Before asking anything

1. Read `.lens-dossier.md` if valid (dossier.md rules). For every battery question
   already answered there, SKIP it and print the skip line.
2. Ensure `stack:` is known (core/stack-detection.md) — it selects Tier 2.

## Question battery — design mode

Ask one at a time; follow answers per protocol.md. Append answers to the dossier.

### Tier 1 — framing (always)

1. What is at stake here — what data or capability would an attacker want from this
   feature? (money, PII, account takeover, reputation)
2. Who are the actors? (anonymous users, authenticated users, admins, third-party
   services, internal jobs)

### Tier 2 — stack-conditional

If `nextjs-web` (any flavor):
3. Where does the session/token live — httpOnly cookie, memory, or localStorage?
   Why there? (localStorage → follow up: XSS steals it; what mitigates that?)
4. How does a session end — expiry, refresh rotation, explicit logout? What happens
   to in-flight requests when it does?
5. If cookies: what is the CSRF story? (SameSite value, CSRF tokens, or "we accept
   the risk because…")

If `nestjs-api`:
6. Which layer decides AUTHORIZATION (not authentication)? Guard, service, query
   filter? Can a controller be added tomorrow that forgets it?
7. Are inbound webhooks signature-verified before any side effect? Replay protection?
8. Where do secrets live at runtime, and what would leak them? (env injection at
   deploy per Tiltely practice — confirm nothing persists in repo or droplet .env)

If `expo-mobile`:
9. Are tokens in SecureStore/Keychain (not AsyncStorage)? What is the story when the
   device is lost?
10. Do deep links / universal links accept parameters that reach privileged screens?

### Tier 3 — deep dives (only when triggered)

- Payments involved → who is PCI-responsible? Are amounts computed server-side only?
- File uploads → type/size validation where? Are files served from the app origin?
- Multi-tenant → what enforces tenant isolation on EVERY query?

## Output contract — design mode

Produce, and append to the dossier:
- decisions[] (with one-line rationale)
- risks[] (accepted, with owner)
- open[] (unresolved, with what resolves them)
- blast-radius notes specific to security (e.g., "token change touches web + mobile")

## Feed the foundry

If a gap surfaced (missing-stack fallback fired, or a question kept recurring that
this battery lacks): read `~/.claude/lens.json`; if `foundry` is set, append one line
to `<foundry>/pending-retros.jsonl`:

    {"type":"gap","date":"<YYYY-MM-DD>","lens":"security","note":"<one line>"}

If the config is absent, mention the gap in your output and move on (no error).

## Question battery — audit mode

Same battery, but the CODE answers. Never edit code in audit mode; you produce a
report. Procedure:

1. Confirm scope with the user: which feature/paths are under audit.
2. Detect stack (or read from dossier) to select Tier 2.
3. For each battery question, gather evidence by reading the relevant code. On large
   repos you MAY fan out read-only Explore subagents (one per question group), giving
   each the dossier content as context. Subagents RETURN evidence; only you write
   the dossier (single-writer rule, core/dossier.md).
4. Classify every question:
   - **answered** — code answers it acceptably → cite `file:line`
   - **violation** — code answers it badly → cite `file:line`, assign severity
     (critical / high / medium / low), one-line why
   - **unanswerable** — code cannot answer it → becomes a question for the user
5. Tier 3 fires when Tier 2 evidence triggers it (e.g., found a webhook handler →
   replay-protection question activates).

## Output contract — audit mode

A findings table: question · status (answered/violation/unanswerable) · evidence
(file:line, required for answered/violation) · severity (violations only).
Then: violations ordered by severity with a one-line fix direction each (direction,
not implementation); unanswerable items as questions for the user. Append a summary
to the dossier.

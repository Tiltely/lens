---
name: observability
description: The Lens of Observability — Socratic battery over operational recovery and visibility for money flows, state machines, webhooks, and background jobs. Use for anything where a lost external event or a stalled multi-step flow can strand a user (payments, webhooks, onboarding funnels, queues, crons). Modes - design (questions to you) and audit (questions to the code).
---

# The Lens of Observability

Read first: ${CLAUDE_PLUGIN_ROOT}/core/protocol.md and ${CLAUDE_PLUGIN_ROOT}/core/dossier.md.
Dossier rules: read it, skip answered questions WITH skip lines, append your outputs.

This lens examines the OPERATIONAL angle the other lenses miss: not "is the happy path
correct" (that's design/tdd) but "when it silently breaks at 3am, how do we KNOW, and
how does the stuck user/record get recovered". Its obsession is the **orphan** — a
user or record stranded mid-flow because an external event was lost or a step failed
with nothing watching.

## Mode selection

- Explicit argument wins ("audit" / "design").
- Otherwise infer: planning new work → design; reviewing existing code → audit.
  Confirm your inference in one line before starting.

## Before asking anything

1. Read the dossier if valid — resolve it per dossier.md (the branch-scoped path). Skip
   answered questions WITH skip lines.
2. Note which surfaces exist (payments, webhooks, multi-step flow, background jobs) —
   they select Tier 2.

## Question battery — design mode

Ask one at a time; follow answers per protocol.md. Append answers to the dossier.

### Tier 1 — framing (always)

1. Name the worst SILENT failure here: a user or record stuck mid-flow that NOTHING
   surfaces (paid-but-no-access, charged-twice, half-migrated, webhook-lost,
   stuck-PROCESSING). If you cannot name one, say so — maybe this flow does not need
   the lens.
2. When that breaks at 3am, how do you find out, and from what? An alert, a user
   complaint, a dashboard, or nothing until someone notices? Who is on the hook?

### Tier 2 — surface-conditional

If external events / webhooks (Stripe, SendGrid, queues, partner callbacks):
3. What happens when an inbound event is LOST, or arrives LATE / out-of-order? Is
   there a reconciliation job that re-derives truth from the SOURCE (the provider's
   API), or is the event the only signal you trust?
4. Is event processing idempotent and deduped DURABLY (a table, not an in-memory
   Set)? Can a redelivery double-apply an effect (double charge, double grant)?

If a multi-step flow / state machine (onboarding, checkout, wizards):
5. Can a user get STUCK between steps — abandoned, failed mid-step, returned from a
   redirect that got lost? Is the resumable state SERVER-derived (re-entry routes to
   the right step) or client-held (lost on refresh / new device)?
6. Is there a sweep that finds records stuck in a transient state past a deadline
   (e.g. PROCESSING > N minutes) and repairs or escalates them — or do they sit
   forever?

If money / irreversible side effects:
7. Can you reconstruct, after the fact, the full sequence of attempts and outcomes
   for ONE user's charge/grant? What is the audit trail, and would it survive a
   dispute or a "you charged me twice" complaint?

If background jobs / crons:
8. How do you know a cron actually RAN and SUCCEEDED — not silently skipped, crashed,
   or no-op'd? Is "did nothing because nothing to do" distinguishable from "failed"?

### Tier 3 — deep dives (only when triggered)

- Alerting fatigue → which signals PAGE a human vs log-only? Is the bar "a user is
  harmed / money is wrong" or "a metric wiggled"? Noise trains people to ignore.
- Correlation → can you trace ONE user's journey across services and logs with a
  shared correlation id, or is each hop an island?
- Silent caps → does any limit (top-N, retry-once, sampling, truncation) drop data
  WITHOUT logging what it dropped? Silent truncation reads as "all good".

## Question battery — audit mode

The CODE answers. Never edit code; produce a report.

1. Confirm scope with the user: which flow/paths are under audit.
2. Detect the surfaces (webhooks, state machine, money, crons) — they select Tier 2.
3. For each battery question gather evidence by reading the code. On large repos you
   MAY fan out read-only Explore subagents (one per surface), giving each the dossier
   content; they RETURN evidence, you write the dossier once (single-writer rule).
4. Classify each question:
   - **answered** — code handles it acceptably → cite `file:line` (e.g. a
     reconciliation cron exists; dedupe is a durable unique index; resume state is
     server-derived).
   - **violation** — a real orphan/blind-spot the operator will hit: a webhook with
     no reconciliation, in-memory-only dedupe, a transient state with no stuck-sweep,
     a cron whose failure is invisible, a money effect with no audit trail. Cite
     `file:line`, assign severity (critical / high / medium / low).
   - **unanswerable** — needs a human/runtime answer → a question for the user.
5. The headline finding is the ORPHAN: any flow where a lost event or a mid-step
   failure strands a user with NO detection and NO recovery is at least high.

## The self-challenge (mandatory closing question)

> **If the riskiest external dependency went silent for an hour right now, how many
> users would be stranded, and which of them would we ever find out about?**

If the honest answer is "we wouldn't know", that is the top finding.

## Output contract

- design → decisions[] · risks[] (accepted, with owner) · open[] · blast-radius notes
  (e.g. "reconciliation job touches the billing module + a new cron + alerting").
  Append to dossier.
- audit → findings table (question · status · evidence `file:line` · severity) +
  the orphan/recovery gaps ranked by user-harm + a one-line recovery direction each.
  Append a summary to dossier.

## Feed the foundry

Gaps → `{"type":"gap","date":"<YYYY-MM-DD>","lens":"observability","note":"<one line>"}`
appended to `<foundry>/pending-retros.jsonl` when the lens config exists; otherwise
mention the gap in your output and move on.

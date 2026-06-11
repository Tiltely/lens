# The Socratic Protocol

Shared rules for every lens and for the /lens:socratic orchestrator. Skills reference
this file as ${CLAUDE_PLUGIN_ROOT}/core/protocol.md.

## How rounds work

- Ask ONE question at a time. Never batch questions.
- Every answer may spawn follow-ups. Follow the answer, not the script: if the user
  says "tokens live in localStorage", the next question is "what happens when one is
  stolen?" — not the next item on the list.
- Prefer concrete over abstract: "what does the user click first?" beats "describe
  the UX vision".
- Multiple-choice when the option space is known; open-ended when it is not.

## Question quality bar

A good Socratic question:
1. Cannot be answered with information already in the dossier (check first; if it is
   answered, SKIP it and print the skip line — see dossier.md).
2. Has consequences: either answer changes what gets built.
3. Digs one level deeper than the previous answer (the "five whys" instinct).
4. Is honest — not a leading question dressed up as discovery.

## The three excavations

Every discovery dialogue must surface, explicitly and by name:

- **Caveats** — constraints and conditions that bound the solution ("only works if
  Stripe webhooks are idempotent").
- **Rabbit holes** — sub-problems that look small and are not ("'just add i18n' is a
  rabbit hole: locale routing, date formats, translated emails…"). Name them so they
  can be consciously deferred or descended into.
- **Blast radius** — every system, repo, platform, and person a change touches:
  API, web, mobile, DB migrations, infra, third parties, documentation, the team.

## When to stop digging

Stop a line of questioning when:
- Two consecutive answers produce no new caveats, rabbit holes, or blast-radius
  entries; or
- the user says "enough" / prunes the topic; or
- the answer is "we don't know yet" AND finding out is itself a named action item.

Record the stop reason in the dossier. Unresolved lines become open questions in the
final synthesis, never silent omissions.

## Missing-stack fallback

When stack detection (stack-detection.md) yields a stack a lens has no specific
questions for: run Tier 1 + the lens's generic battery, tell the user the lens has no
specific coverage for that stack, and append a gap entry to the foundry queue
(see "Feeding the foundry" in any lens skill).

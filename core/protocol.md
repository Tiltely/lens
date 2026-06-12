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
   answered, SKIP it and print the skip line — see dossier.md) — nor with evidence
   you can gather yourself (see "Evidence before questions").
2. Has consequences: either answer changes what gets built.
3. Digs one level deeper than the previous answer (the "five whys" instinct).
4. Is honest — not a leading question dressed up as discovery.

## Evidence before questions (fact vs intent)

Before asking ANY question, classify it:

- **Intent questions** — goals, preferences, acceptable risk, trade-offs, scope.
  Only the user can answer these. Ask directly; never burn time searching.
- **Fact questions** — which pattern/library/convention is used, where something
  lives, how an existing system behaves. The environment can often answer. Gather
  evidence FIRST, time-boxed to one quick targeted look per level:
  1. the dossier;
  2. the current repo (targeted grep/glob for the thing in question);
  3. org prior art: sibling project directories next to this repo, the project's
     CLAUDE.md, and — when `gh` is authenticated — the org's other repos (how did
     the org's LAST project solve this?).

  Evidence found → do NOT ask; present a CONFIRMATION instead: "I found <evidence>
  at <location> — do we follow the same pattern here?" Confirmations are cheap and
  keep the user in control without making them the lookup tool.
  Not found quickly → ask, and say where you already looked, so the miss is visible
  and the user's answer can correct your search.

A question that makes the user recall what the codebase already records is a wasted
question. The Socratic method interrogates THINKING, not memory.

## The four excavations

Every discovery dialogue must surface, explicitly and by name:

- **Caveats** — constraints and conditions that bound the solution ("only works if
  Stripe webhooks are idempotent").
- **Rabbit holes** — sub-problems that look small and are not ("'just add i18n' is a
  rabbit hole: locale routing, date formats, translated emails…"). Name them so they
  can be consciously deferred or descended into.
- **Blast radius** — every system, repo, platform, and person a change touches:
  API, web, mobile, DB migrations, infra, third parties, documentation, the team.
- **Platform matrix** — for any feature that touches platform capabilities (install
  flows, storage, push, media, sensors, gestures): on which platforms/browsers does
  the behavior differ, what is the fallback where it is unsupported, and on which
  REAL devices will it be tested. A feature that "works" only on the developer's
  browser is not done. When unsure whether a constraint still holds, verify against
  current sources before asking — platform limits change every release.

## Lens agnosticism

Lenses examine perspectives, not technologies. Every lens must work on any stack:
technology-specific knowledge lives in Tier 2 conditionals, `rules/` files, or
`topics/` depth packs that load AFTER detection — never in the lens's name, framing
questions, or core battery. The only exception is a lens whose SUBJECT is a specific
technology, and then its name and registry row must say so explicitly.

## When to stop digging

Stop a line of questioning when:
- Two consecutive answers produce no new entries for any of the four excavations; or
- the user says "enough" / prunes the topic; or
- the answer is "we don't know yet" AND finding out is itself a named action item.

Record the stop reason in the dossier. Unresolved lines become open questions in the
final synthesis, never silent omissions.

## Missing-stack fallback

When stack detection (stack-detection.md) yields a stack a lens has no specific
questions for: run Tier 1 + the lens's generic battery, tell the user the lens has no
specific coverage for that stack, and append a gap entry to the foundry queue
(see "Feeding the foundry" in any lens skill).

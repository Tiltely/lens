# The Socratic Protocol

Shared rules for every lens and for the /lens:socratic orchestrator. Skills reference
this file as ${CLAUDE_PLUGIN_ROOT}/core/protocol.md.

## How rounds work

- Ask ONE question at a time. Never batch questions.
- Every answer can move the dialogue two ways. Follow the answer, not the script:
  - **DEEPER** (vertical, the five whys): drill the same thread. "tokens live in
    localStorage" → "what happens when one is stolen?" → "what mitigates that?"
  - **WIDER** (lateral, branching): an answer can open whole new lines that were not
    planned. "users upload their own avatars" forks into upload validation
    (security), image processing, moderation, CDN, storage cost — one answer, several
    new branches. Capture every new branch (see "The frontier") the instant it
    appears.
- Prefer concrete over abstract: "what does the user click first?" beats "describe
  the UX vision".
- Multiple-choice when the option space is known; open-ended when it is not.

## The frontier

The four rounds below are SEEDS, not a script. Maintain a live agenda — the
**frontier** — of open question-branches in the dossier (`## frontier`, see
dossier.md). Work it down:

1. Each answer does one of three things to the CURRENT branch — close it (record the
   decision/caveat), deepen it (a vertical follow-up), or leave it open — AND it may
   SPAWN new branches. Add every spawned branch to the frontier the moment it
   appears, before the next question. A branch you do not write down is a branch that
   dies.
2. The frontier is a MIND-MAP, not a flat list: record it as a tree (dossier.md
   `## frontier`) — spawned branches nested under the answer that opened them, each
   node tagged `[status][stakes]`. Stakes = consequence × irreversibility × blast
   radius (HIGH / MED / LOW). Pick the next question from the highest-stakes open
   branch, never the round order. The rounds only guarantee you SEED
   scope/caveat/blast-radius/platform concerns; the frontier guarantees you do not
   lose the ones an answer opens.
3. Discovery is not done until the frontier is empty OR every remaining branch is
   consciously DEFERRED — named, with a reason, moved to `## open`. Never let a branch
   evaporate silently; that silent loss is exactly what the frontier prevents.
4. A spawned branch can change the plan. The lens plan (orchestrator step 3) is
   PROVISIONAL until the frontier is empty: if a branch reveals a concern a lens
   covers (e.g. an upload-validation branch → the security lens), add that lens even
   if the rounds never surfaced it.

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

## Interrogate decisions, not just answers

The Socratic principle applies to DECISIONS too. A decision is never free — before
recording one in `## decisions`, ask what choosing it touches:

- **Consumers** — who imports, calls, or depends on what this changes? Does any of
  them break or need updating?
- **Contracts** — API shape, DB schema, events, env/config: does this change
  something others rely on?
- **Styles / UX** — visual or interaction knock-on: a shared component, theming, an
  established layout or pattern?
- **Dependencies** — a new package, a version bump, a lockfile change, a transitive
  risk?
- **Platforms** — must the same decision hold on web AND mobile? Where does it
  intentionally diverge?

Each non-trivial ripple is itself a new branch — add it to the frontier (or, if it is
purely "what else does this touch", to the blast-radius excavation). A decision that
silently breaks a consumer is the failure this prevents: it felt local, but was not.

## When to stop digging

This governs a SINGLE branch (when to stop drilling one thread). Overall discovery
ends only when the frontier is empty or every remaining branch is deferred
(see "The frontier").

Stop a line of questioning when:
- Two consecutive answers produce no new entries for any of the four excavations AND
  spawn no new branches; or
- the user says "enough" / prunes the topic; or
- the answer is "we don't know yet" AND finding out is itself a named action item.

Record the stop reason in the dossier. Unresolved lines become open questions in the
final synthesis, never silent omissions.

## When discovery is done

You can always ask another question — so "no questions left" is the WRONG stop
signal; it never comes, and chasing it is the infinite-doubt trap. The right signal
is CONSEQUENCE running out, judged by the user. A branch earns a question only while
its answer would still change what gets built at its stakes.

Drain the frontier by stakes, do not ask everything:
- **No consequence** (the answer would not change the build) → drop the branch.
- **LOW stakes** (cheap, reversible, narrow blast radius) → do NOT ask; record a
  sensible default in the dossier and move on. The user can override later.
- **Real but not now** → defer to `## open` with an owner (a later phase, the
  implementer, a spike). Deferring is not dropping.
- **HIGH/MED stakes, still open** → these are what the user's attention is for.

Propose synthesis as soon as EITHER holds:
- every remaining open branch is LOW or deferred — the load-bearing questions are
  answered; or
- two consecutive answers spawn no new branches — the territory is mapped.

When you propose it, SHOW the mind-map and ask: "the high-stakes branches are
settled — synthesize now, or dig into <named open branch>?" The user is the
throttle: offer "enough, synthesize" at every step and honor it immediately.

Hard backstop: never declare discovery done while a HIGH-stakes branch is open and
neither answered nor deferred. That backstop is the floor (do not stop while real
doubts remain); the drop/default/defer rules are the ceiling (infinite doubts do not
help). Between them is where a good dialogue ends.

## Missing-stack fallback

When stack detection (stack-detection.md) yields a stack a lens has no specific
questions for: run Tier 1 + the lens's generic battery, tell the user the lens has no
specific coverage for that stack, and append a gap entry to the foundry queue
(see "Feeding the foundry" in any lens skill).

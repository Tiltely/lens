---
name: tdd
description: The Lens of Test-Driven Development — Socratic battery that ensures tests EARN their existence. Use when writing or planning tests, fixing bugs (regression tests), or reviewing/auditing a test suite. Kills tautological tests, mock-echo tests, implementation mirrors, and testing-for-testing's-sake. Modes - design (tests you're planning) and audit (judges the tests already written).
---

# The Lens of TDD

Read first: ${CLAUDE_PLUGIN_ROOT}/core/protocol.md and ${CLAUDE_PLUGIN_ROOT}/core/dossier.md.
Dossier rules: read it, skip answered questions WITH skip lines, append your outputs.

Division of labor: if a TDD *process* skill is available in the session (e.g.
superpowers:test-driven-development), it governs the red-green-refactor loop. This
lens governs **judgment** — which tests deserve to exist and what they must pin down.
They compose; this lens never overrides process discipline.

## Mode selection

- Explicit argument wins ("audit" / "design").
- Otherwise infer: planning/writing tests → design; reviewing tests that already exist
  → audit. Confirm your inference in one line.

## Question battery — design mode

### Tier 1 — framing (always)

1. State the behavior under test as one sentence in DOMAIN language — "rejects
   expired tokens", "splits the bill evenly among present members". If you cannot
   phrase it without naming functions, mocks, or internals, you are about to test
   implementation, not behavior. Rephrase before continuing.
2. The deletion test: if this test never existed, what bug would reach production
   undetected? If the honest answer is "none", the test is theater — do not write it.

### Tier 2 — per proposed test

3. What is the ONE reason this test can fail? (Many reasons → bad alarm, split it.
   Zero reasons → decoration, delete it. Exactly one → a test.)
4. Red-phase honesty: will you SEE it fail first, and fail for the RIGHT reason?
   A test that passes on first run has verified nothing — including itself.
5. What does the assertion actually pin? Distinguish:
   - outcome assertions (returned value, persisted state, emitted event) — strong
   - interaction assertions (mock called with X) — weak; justified ONLY when the
     interaction IS the contract (e.g., "charges Stripe exactly once")
6. Boundaries, with criterio: list the edges (empty, one, many, duplicate, malformed,
   concurrent, unauthorized) — then say which you will NOT test and WHY. Knowing what
   not to test is the skill; "all of them" is not an answer.
7. Stack-conditional:
   - `nestjs-api` → what is the unit/e2e split here? What deserves the real database
     and what tolerates a mock — and does any mock re-implement query logic (red flag)?
   - `nextjs-web` / `expo-mobile` → does the test exercise what the USER does (render,
     interact, observe) rather than component internals/state shape?

### Tier 3 — deep dives (only when triggered)

- Bugfix in progress → write the regression test FIRST and confirm it fails on the
  unfixed code. A bugfix without a failing-first test is a guess.
- Flakiness ingredients present (time, randomness, network, ordering) → how is each
  controlled (fake clock, seeded RNG, test double, order-independence)? "Retry it"
  is not control.
- Test data getting verbose → builder/factory with meaningful defaults, or is fixture
  sprawl hiding what each test actually varies?

## The anti-pattern wall (refuse to write these)

Never produce, and call out when proposed:
- **Mock-echo**: asserting a mock returned what you stubbed it to return.
- **Implementation mirror**: a test that restates the code line-by-line; it fails on
  every refactor and catches no bugs (a change detector, not a behavior pin).
- **Framework test**: verifying that the library/framework works (that class-validator
  validates, that Prisma saves). Test YOUR contract, not theirs.
- **Assertion-free**: "doesn't throw" as the only claim, or snapshot tests nobody reads.
- **Twin**: duplicates another test's reason-to-fail without adding a boundary.

## The self-challenge (mandatory closing question)

> **If a teammate deleted half of these tests, would CI still catch the bugs that
> matter? Which half would you keep — and why isn't that the whole suite?**

## Output contract — design mode

A test plan table: behavior sentence · the one failure reason · boundaries chosen ·
boundaries rejected (with the why) · assertion kind (outcome/interaction+justification).
Plus decisions[] · risks[] · open[]. Append to dossier.

## Question battery — audit mode (judge the tests already written)

The TESTS answer. Never edit them; produce a report.

1. Confirm scope: which test files / suites are under audit.
2. For each test, classify against the anti-pattern wall and the design-mode bar:
   - **delete** — mock-echo, framework test, assertion-free, implementation mirror, or
     a twin: cite `file:line` and which anti-pattern; it earns no keep.
   - **strengthen** — real behavior but weak: asserts an interaction where an outcome
     is available, has more than one reason to fail, or could never have failed for the
     right reason. Cite `file:line` and the one concrete fix.
   - **keep** — pins one real behavior with an outcome assertion; say so briefly.
3. Coverage gaps: behaviors/boundaries with NO test that SHOULD have one — apply the
   deletion test in reverse ("what bug reaches prod undetected today?"), and keep it
   honest by also naming boundaries deliberately not worth testing.
4. Stack-conditional (as design mode): unit/e2e split sanity; mocks re-implementing
   query logic; UI tests asserting internals instead of user-observable behavior.

## Output contract — audit mode

A per-test verdict table: test (file:line) · verdict (keep/strengthen/delete) ·
anti-pattern or fix · the one reason it can fail. Then a coverage-gap list ranked by
the severity of the bug each missing test would catch. Append a summary to the dossier.

## Feed the foundry

Gaps → `{"type":"gap","date":"<YYYY-MM-DD>","lens":"tdd","note":"<one line>"}`
appended to `<foundry>/pending-retros.jsonl` when `~/.claude/lens.json` exists;
otherwise mention and move on.

# Behavior Test Scenarios

Run each before shipping changes to the named skill. Dev loop:
`claude --plugin-dir /Users/leonardo/Tiltely/lens` (interactive) or `-p` (headless).

## socratic (design flow, end-to-end)
Interactive (on a feature branch): `/lens:socratic "add a favorites feature to recaply web"`
PASS when: dossier created at `.lens/dossiers/<branch-slug>--<hash>.md` with
goal+date+branch+stack (NOT the legacy root `.lens-dossier.md`); the branch gate stays
silent because you are already on a feature branch; questions arrive ONE at a time;
caveats/rabbit-holes/blast-radius explicitly named; lens plan presented and prunable;
chained lenses print skip lines for dossier-answered questions; synthesis lists
decisions/risks/open/actions; retro reminder appears.

## socratic (branching / the frontier)
Interactive: `/lens:socratic "add user avatars"`; answer the first question with
something that opens new territory ("users upload their own images from their phone").
PASS when: that single answer SPAWNS multiple branches into `## frontier` (e.g. upload
validation, image processing, storage cost) — not just one vertical follow-up; the
frontier is a TREE with `[status][stakes]` tags; the next question comes from the
highest-stakes branch, not the round order; no opened branch is dropped silently (each
is closed, deepened, or deferred to ## open with a reason); a branch that warrants it
adds a lens to the otherwise-provisional plan; LOW-stakes branches get recorded
defaults, not questions; the orchestrator PROPOSES synthesis (showing the mind-map)
once only LOW/deferred branches remain, and honors "enough, synthesize" at any step.

## socratic (termination on a small task — does not interrogate forever)
Interactive: `/lens:socratic "make the footer copyright year dynamic"`.
PASS when: branches are recognized as LOW stakes; defaults are recorded instead of a
question barrage; synthesis is proposed fast (the HIGH-stakes backstop never fires on
a trivial task); total questions stay in the low single digits.

## socratic (decision interrogation — ripple check)
Interactive: state a decision with downstream reach, e.g. "switch auth from
localStorage tokens to httpOnly cookies."
PASS when: BEFORE recording it, the decision is interrogated for ripple — consumers
(every authenticated API call), contracts (CSRF posture, logout), platforms (does
mobile share this?), deps — and each non-trivial ripple becomes a frontier branch or a
blast-radius entry, not a silent assumption.

## socratic (audit mode)
Interactive: `/lens:socratic audit` on the SAME branch as a prior design session whose
implementation has landed.
PASS when: the branch's dossier is re-found by recomputing the branch path (no shared
pointer); recognized as the contract (no re-scoping questions the dossier answers);
audit does NOT move branches; audit plan = design-time lens plan, audit-capable lenses only, skipped
ones named; contract check covers every recorded decision (file:line or drift flag),
open question, and accepted risk; zero file edits; retro reminder at close.

## socratic (branch gate + per-branch isolation)
Interactive: from a base branch (`main`), `/lens:socratic "some task"`.
PASS when: design step 1 STOPS at the branch gate and offers create-`lens/<goal-slug>` /
stay-on-base / worktree — it does NOT switch branches silently; choosing "create" lands
you on `lens/<goal-slug>` and the dossier is written under that branch's path. Then run a
second `/lens:socratic` concurrently on a DIFFERENT branch (or worktree): each writes
its own `.lens/dossiers/<branch>--<hash>.md` and neither resets the other (no lost
discovery). Already on a feature branch → the gate is silent. A legacy root
`.lens-dossier.md`, if present, triggers a one-time migration OFFER (never silent).

## socratic (partition — multi-feature → parallel worktrees)
Interactive on a feature branch: run `/lens:socratic` on a request bundling several
independent features (e.g. "add CSV export AND dark mode AND a rate limiter") to synthesis,
OR run `/lens:socratic partition` over an existing FINAL dossier.
PASS when: partition is OFFERED only after the dossier is final (post-adversary), and only
when blast-radius shows INDEPENDENT features; a single-feature request is NOT offered a
split (degrades to plain design mode); the proposed `## partition` lists each feature, what
it touches, and a reconciliation order, with coupled features merged/sequenced (NOT
parallelized); no worktree is created without explicit OK; on approval each
`git worktree add … -b lens/<feature-slug>` gets a COPY of the complete dossier + a feature
manifest header; worktree paths are recorded back in `## partition`. On Cowork: materialize
DECLINES and the user gets the `## partition` plan instead (no worktrees).

## socratic (project-scoped lenses)
Setup: in a git repo, create `.lens/registry.md` with one `lens` row (e.g. `compliance`)
and `.lens/lenses/compliance/SKILL.md` with a short battery. Run `/lens:socratic` on a
task in that repo whose trigger matches.
PASS when: the plan lists the project lens marked "(project)"; it is read INLINE (not
invoked as a slash command); a project lens whose NAME duplicates a bundled one
overrides the bundled battery for that repo (nearest-wins); a repo WITHOUT `.lens/`
behaves exactly as before. The foundry/hook/retro are unchanged — the session still
queues because it ran lens:socratic.

## adversary (mandatory red-team in socratic)
Run a full `/lens:socratic` design session to the synthesis.
PASS when: after synthesis, the adversary step runs WITHOUT being asked (mandatory);
it first SUGGESTS plan mode and waits for the user (does not toggle it); it produces a
critique table with concrete findings (not generic), each dispositioned
revise/reopen/accept; a "reopen" sends control back to discovery; the plan is declared
final only after surviving. Standalone `/lens:adversary` on a plan/diff also works.

## security (design)
Headless smoke: `claude --plugin-dir /Users/leonardo/Tiltely/lens -p "Invoke the lens:security skill in design mode for a hypothetical Next.js SPA login feature. Ask me only the first question, then stop."`
PASS when: exactly one Tier 1 question, framed per battery.

## design (design mode)
Interactive on a real screen task.
PASS when: design system detected and recorded first (works with shadcn, MUI, or
none); 2–3 ranked candidates phrased in the project's component vocabulary; PWA
answer triggers the topics/pwa.md depth pack (platform-specific install/storage/
update questions, not just "does it work offline"); self-challenge asked before
closing.

## design (audit mode)
Interactive: `/lens:design audit` scoped to an implemented screen.
PASS when: scope confirmed; critiques the rendered UI (screenshots when the app
runs locally) not just code; every key interaction gets ranked alternatives;
verdicts are keep/refine/rework with visible evidence — at least one "keep" verdict
should survive on a well-built screen (no invented change); zero file edits.

## usability (design)
Interactive on a real page task.
PASS when: walk-through question first; loading/success/failure named for each async
action; i18n question fires only when triggered.

## tdd (design)
Interactive while planning tests for a real feature; include one deliberately bad
proposal ("assert the mocked service was called with the stubbed value").
PASS when: behavior must be phrased in domain language before proceeding; the
deletion test fires; the mock-echo proposal is refused BY NAME (anti-pattern wall);
boundaries-rejected listed with rationale; self-challenge asked before closing.

## security (audit)
Interactive: `/lens:security audit` scoped to a real feature.
PASS when: scope confirmed first; every finding cites file:line; violations carry
severity + fix direction; zero file edits; unanswerable → questions for the user.

## tdd (audit mode)
Interactive: `/lens:tdd audit` scoped to a real test file containing at least one
mock-echo or assertion-free test.
PASS when: scope confirmed; per-test verdict table (keep/strengthen/delete) with
`file:line`; the mock-echo/assertion-free test is flagged **delete** by name; a
coverage-gap list appears; zero file edits.

## usability (audit mode)
Interactive: `/lens:usability audit` scoped to an implemented page/flow.
PASS when: scope confirmed; critiques the rendered flow (screenshots when the app
runs) not just code; async actions missing loading/error/empty states are flagged as
violations with `file:line` + severity; zero file edits.

## setup
Fresh-machine simulation: temporarily `mv ~/.claude/lens.json{,.bak}`, run /lens:setup,
verify file restored correctly, then restore the backup.

## retro (after Phase 3)
With ≥1 real queued session: `/lens:retro`.
PASS when: pending computed as pending minus processed; proposals require explicit
approval; observations appended only after approval; processed marker appended.

## new — maintainer path (auto-detected inside the plugin repo)
`/lens:new parity "web↔mobile feature parity"` run with cwd INSIDE the lens plugin
repo (root has `.claude-plugin/plugin.json` name=lens).
PASS when: the "bundled set" option is offered WITHOUT any maintainer question (it
appears because the repo is detected, not asked); clean-tree + default-branch checked;
SKILL.md scaffolded with 8–12 real questions; registry row appended; diff shown;
commit only after approval. Run OUTSIDE the plugin repo → the bundled option is NEVER
offered and no maintainer question is asked.

## new — global path (read-inline, NOT a separate skill)
Same command with lens.json containing ONLY `foundry`.
PASS when: lens lands in `<foundry>/lenses/<name>/SKILL.md` (NOT `~/.claude/skills/`)
with no surviving placeholders; row appended to `<foundry>/registry.md`; NO
`~/.claude/skills/lens-*` skill is created and NO `/lens-<name>` command is implied;
`/lens:socratic` discovers it read-inline next run; PR-to-bundled suggestion mentioned.

## new — project path
Same command run inside a git repo, project scope chosen.
PASS when: lens lands in `<repo>/.lens/lenses/<name>/SKILL.md`; row appended to
`<repo>/.lens/registry.md`; `.lens/` git-excluded via `git rev-parse --git-path
info/exclude` (fallback: proposed .gitignore, never silent); read-inline by socratic.

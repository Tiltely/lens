# The Session Dossier

A scratch file holding what is already known, so no lens re-asks an answered
question. There is ONE dossier per request, keyed on the git branch the work lives on
— so concurrent socratic sessions on different branches/worktrees never clobber each
other.

## Where it lives (branch-scoped path)

The dossier path is a deterministic FUNCTION of git state, so a later session (e.g.
the audit) recomputes the same path with no shared pointer or index:

    <git-toplevel>/.lens/dossiers/<branch-slug>--<hash>.md

- `<git-toplevel>` = `git rev-parse --show-toplevel` (in a linked worktree this is the
  WORKTREE's own toplevel — a separate directory, so worktrees isolate for free).
- `<branch-slug>` = the current branch (`git symbolic-ref --quiet --short HEAD`)
  sanitized: lowercase; replace every char not in `[a-z0-9._-]` with `-`; collapse
  repeats; trim leading/trailing `-`. So `feature/foo` → `feature-foo`,
  `Leo/Fix Bug #3` → `leo-fix-bug-3`.
- `<hash>` = first 7 hex of `sha1(<raw branch name>)` — the collision guard, so two
  different branches that sanitize to the same slug (`feat/x` vs `feat-x`) never share
  a file. Example: `.lens/dossiers/feature-foo--a1b2c3d.md`.

**No-branch fallbacks** (the path stays deterministic and re-findable):
- Detached HEAD (`symbolic-ref` returns nothing) → `detached-<short-sha>` of `HEAD`.
- Not a git repo → the single fixed file `.lens/dossiers/_no-branch.md` (this
  preserves the legacy one-file behavior for non-git dirs).

`.lens/` is already the project's local scratch home (project-scoped lenses live in
`.lens/registry.md` / `.lens/lenses/`, git-excluded; the SHARED copy of a project lens
goes to `.claude/skills/`, never `.lens/`). Dossiers nest under it as a sibling
`dossiers/` dir — no new top-level artifact.

## Branch gate (design-mode only, defensive — runs BEFORE the dossier is created)

The dossier must not be born orphaned on a base branch. As the first sub-step of
/lens:socratic design step 1, read the current branch and:

- **On a base branch** (`main` / `master` / `develop` / `trunk`, or a project override):
  STOP and offer the user, explicitly — (1) create a `lens/<goal-slug>` branch now and
  switch to it (recommended; `git checkout -b`), (2) stay on the base branch anyway
  (warn the dossier will hang off it and audit re-find degrades), or (3) create a
  worktree for real parallelism (delegate to the `using-git-worktrees` skill if
  present). WAIT for the choice. NEVER switch branches silently. `<goal-slug>` is the
  goal argument sanitized by the same rule as `<branch-slug>` above — approximate is
  fine (the user can rename); offer it as a default, not a mandate.
- **Already on a feature branch**: say nothing — derive the dossier path and proceed.
- **Detached HEAD or non-git**: `symbolic-ref` is empty, so the gate cannot read a
  branch name and cannot tell base from feature — it stays silent and proceeds on the
  current state (path falls to `detached-<sha>` or `_no-branch.md`). Accepted gap: a
  detached HEAD sitting on trunk's commit is NOT caught; check out a feature branch
  first if you want the gate's protection.

The gate is design-mode only; audit never moves branches (it just reads).

## Header

Created with this header (the in-file contract is unchanged except the new `branch:`):

    # Lens Dossier
    goal: <the stated objective, verbatim>
    date: <YYYY-MM-DD>
    branch: <raw branch name>            ← self-identifies the file; audit verifies it
    stack: <filled by detection>

## Lifecycle

- **Created by /lens:socratic design step 1** at the branch-derived path, AFTER the
  branch gate. There is NO global reset: a new design session writes only its OWN
  branch's file, so a concurrent session on another branch is never touched.
- **Reset is per-branch, not global.** If the branch's file already exists: when it is
  VALID for this task (goal plausibly matches + within 7 days), re-open and CONTINUE it
  (a second design pass must not wipe prior discovery). When it is STALE/unrelated
  (date > 7 days, or the goal is clearly a different task — the branch was reused),
  reset just THAT one file, with a one-line notice (`resetting stale dossier for
  <branch> from <old-date>`). Otherwise create it fresh.
- **Validity for standalone lens runs**: a dossier at the branch-derived path is USABLE
  only if its `goal` plausibly matches the current task AND `date` is within 7 days AND
  its `branch:` header matches the current branch. The branch already SELECTED the file,
  so this stays a yes/no predicate over ONE candidate (never a list). If branch matches
  but the goal looks like a different task, treat it as absent (let socratic reset it).
  If it looks reusable but you are unsure, ask the user one yes/no question. Otherwise
  treat it as absent (do not delete it; /lens:socratic owns resets).
- **Audit re-find** (the design→audit join, deterministic-first): see below.
- **Git exclusion**: on creation, ensure the single line `.lens/` is present in the
  exclude file (`git rev-parse --git-path info/exclude`) — idempotent: grep first,
  append only if absent (never per-request). This is the same pattern /lens:new uses.
  If the exclude file is absent/unwritable, propose a `.gitignore` entry for `.lens/` —
  never silently edit `.gitignore`. When NOT in a git repo (the `_no-branch.md` case),
  skip this entirely — there is no index to exclude from and a `.lens/` dir in a non-repo
  is inert.

## Audit re-find (resolution order — degrade explicitly, never silent-guess)

Design and audit are separate sessions with no shared runtime state; the branch is the
join key. Resolve in order:

1. **Branch path exists + valid** → use it. The dominant case (design and audit on the
   same feature branch): one branch → one path → one open, as unambiguous as a fixed
   file. Validity is the yes/no check above — no ranking.
2. **Branch file absent** (branch renamed / rebased / squash-merged to base): glob
   `.lens/dossiers/*.md`, read each `goal:` / `date:` / `branch:` header, present a
   SHORT list ranked by goal-match then recency, and ask the user to pick one or none.
   This is the ONLY place a SELECTION happens, and it sits behind an explicit choice.
3. **Detached HEAD whose commit moved** → same glob + ask.
4. **Nothing found** → today's behavior: confirm scope with the user, build the audit
   plan from registry triggers.

The SessionEnd retro queue records `session_id` but never the dossier path, so it is
NOT a relink bridge — branch + header are the contract.

## Single-writer rule

Per-branch scoping and the single-writer rule are ORTHOGONAL and BOTH hold:
- **Single-writer** governs INTRA-session writes: within one request, only the main
  session writes the dossier. Read-only evidence-gathering subagents (audit mode)
  receive its content in their prompt and RETURN findings; the lens merges and writes
  once. ("The dossier" it governs is the current request's branch file.)
- **Per-branch** governs INTER-session isolation: two different requests on different
  branches write different files, so they never contend — the thing single-writer
  alone never promised.

**Residual, accepted:** two socratic sessions on the SAME branch AND same worktree
(e.g. two terminals on one checkout) still write the same file; last-writer-wins.
Neither rule closes this — use separate worktrees for genuine parallelism (each
worktree's toplevel gives it its own dossier).

## Sections

    ## answered      ← question + answer, one bullet each, appended by every lens/round
    ## frontier      ← LIVE mind-map of open question-branches (protocol.md "The frontier"):
                       a TREE — spawned branches nested under the answer that opened them,
                       each node tagged [status][stakes] (open/deepening/answered/deferred/
                       dropped · HIGH/MED/LOW); drained by stakes as branches resolve
    ## decisions     ← decisions made: one-line rationale + ripple note (what it touches —
                       consumers/contracts/styles/deps/platforms; protocol.md "Interrogate
                       decisions"); non-trivial ripples become frontier branches
    ## caveats / rabbit-holes / blast-radius / platform-matrix  ← the four excavations (protocol.md)
    ## open          ← branches consciously DEFERRED at synthesis + who/what resolves them

## Cleanup (hygiene, not correctness)

Per-branch accumulates one file per branch ever worked, so prune opportunistically.
On design step 1, after creating/opening this branch's file, scan `.lens/dossiers/*.md`:
any whose `date` is > 30 days old AND whose `branch` no longer exists
(`git rev-parse --verify <branch>` fails — merged/deleted) is a GC candidate. List them
and offer ONE yes/no removal; never auto-delete (a merged branch's dossier may still be
wanted for an audit/retro). The 7-day validity rule already makes stale files inert, so
GC is disk hygiene only. `rm -rf .lens/dossiers` is always safe — socratic recreates.

## Migration from the legacy single file

Earlier versions used a single `<toplevel>/.lens-dossier.md`. On design or audit step 1,
if that legacy file exists and `.lens/dossiers/` has no current-branch file, OFFER (one
yes/no, never silent) to migrate it: derive `branch:` from the current branch, move it
to the branch-derived path, add the header line, and remove the legacy file. This keeps
an in-flight design→audit loop alive across the upgrade.

## Skip lines (mandatory)

When a lens skips a question because the dossier answers it, it MUST print:

    skipping: <question> — answered in <where>

These lines are the visible proof the dossier works. Never skip silently.

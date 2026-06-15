---
name: socratic
description: Use when starting any non-trivial feature, issue, or objective — BEFORE designing or coding — and again AFTER implementing, to audit it. Design mode runs iterative Socratic discovery (caveats, rabbit holes, blast radius), then plans and chains the right lenses. Audit mode re-runs the session's lens plan against the implemented code and verifies it against the dossier's recorded decisions. Trigger phrases - "let's build", "add feature", "how should we approach", "audit what we built", "review the implementation".
---

# Socratic Discovery Orchestrator

Read first:
- ${CLAUDE_PLUGIN_ROOT}/core/protocol.md  (how to ask; the four excavations)
- ${CLAUDE_PLUGIN_ROOT}/core/dossier.md   (dossier lifecycle — you own creation/reset)
- ${CLAUDE_PLUGIN_ROOT}/core/registry.md  (available lenses for the plan)

Mode: explicit argument wins ("audit"). Otherwise: starting new work → design;
reviewing something already built → audit (confirm your inference in one line).

## Flow — design mode

1. **Dossier**: per dossier.md. FIRST run the **branch gate** (dossier.md "Branch
   gate") — if on a base branch (`main`/`master`/`develop`/`trunk`), STOP and offer to
   create `lens/<goal-slug>`, stay, or use a worktree, and WAIT; if already on a feature
   branch, proceed silently. THEN create the branch-scoped dossier at
   `<toplevel>/.lens/dossiers/<branch-slug>--<hash>.md` (goal + date + `branch:` header;
   `.lens/` git exclusion). No global reset — only this branch's file is written, so a
   concurrent session on another branch is untouched; if the legacy `.lens-dossier.md`
   exists, offer the one-time migration (dossier.md). Run stack detection
   (core/stack-detection.md); record `stack:`.
2. **Socratic rounds** (protocol.md rules — ONE question at a time; classify each
   as fact vs intent first: fact questions get the evidence pass — current repo,
   sibling/org repos, CLAUDE.md — and arrive as confirmations when evidence exists):
   - Round A — the goal: what does success look like? for whom? what is explicitly
     out of scope?
   - Round B — caveats: what must be true for this to work? what constraints bound it?
   - Round C — rabbit holes: which sub-problems look small but are not? Name each.
   - Round D — blast radius: which systems/repos/platforms/people does this touch?
     (API, web, mobile, DB, infra, third parties, docs, team.)
   These four are SEEDS for the frontier (protocol.md "The frontier"), not a fixed
   script: each answer may spawn new branches — add them to the `## frontier`
   mind-map (a tree, tagged `[status][stakes]`) and work it DOWN by stakes, not by
   round order. Discovery ends per protocol.md "When discovery is done": drain by
   stakes (drop no-consequence, default LOW, defer real-but-later), and PROPOSE
   synthesis (showing the mind-map) once only LOW/deferred branches remain or answers
   stop spawning branches. The user can say "enough, synthesize" at any step — honor
   it. Append everything to the dossier as you go.
3. **Lens plan** (build it once the frontier is empty or deferred). Every lens —
   bundled or user-created — is a candidate; union the `lens` rows from all sources,
   **nearest-wins on lens name** (project > global > bundled — a nearer definition
   overrides a farther one, like a nearer CLAUDE.md):
   - bundled `core/registry.md`;
   - your global registry: resolve the foundry from the lens config
     (first-readable-wins: `$LENS_CONFIG` → `~/.claude/lens.json` → `~/lens/lens.json`;
     read its `foundry` key), then read `<foundry>/registry.md` and the lens bodies in
     `<foundry>/lenses/<name>/SKILL.md`. Skip silently if no config/registry exists.
   - project `<repo>/.lens/registry.md` (+ `<repo>/.lens/lenses/`) — if cwd is in a git
     repo (root via `git rev-parse --show-toplevel`) and it exists.
   A lens is the (registry row + its `SKILL.md`); nearest-wins selects BOTH from the
   level that defines the name. Pick the lenses whose triggers match what the rounds
   surfaced; for transparency tag each by origin — (bundled) / (yours) / (project).
   Present an ordered plan: lens → one-line reason. Let the user prune or reorder.
4. **Execute the chain in this session**, dispatching per lens:
   - a BUNDLED lens → invoke its skill (`/lens:<name>`);
   - a lens you created (global `<foundry>/lenses/<name>/SKILL.md` or project
     `<repo>/.lens/lenses/<name>/SKILL.md`) → READ its SKILL.md inline and run its
     battery here (same as how this orchestrator reads core/*.md).
   Single-writer rule holds: you write the dossier. Each lens reads the dossier and
   skips answered questions (printing skip lines).
5. **Synthesis**: render the final mind-map (the frontier tree — every node resolved
   or deferred); decisions made; open risks; the four excavations as a compact map;
   concrete action list. This is the DRAFT plan.
6. **Red-team the plan (MANDATORY)**: run the `adversary` lens on the draft —
   read-inline `${CLAUDE_PLUGIN_ROOT}/skills/adversary/SKILL.md` (or invoke
   `/lens:adversary`). It first SUGGESTS plan mode and waits for the user, then attacks
   the plan (refutation, weakest decision, what discovery missed, reversibility,
   "first thing that worked"). Disposition every finding: revise a decision / reopen a
   frontier branch (→ back to step 2) / accept as explicit risk. The plan is FINAL only
   after it survives. Then write the final dossier state. (This step is not pruned —
   the adversarial pass reliably finds what discovery missed.)
7. **Close**: remind the user — after the implementation lands, run
   `/lens:socratic audit` to verify it against this dossier, and /lens:retro after
   that (the SessionEnd hook has already queued this session if any lens ran).

## Flow — audit mode (`/lens:socratic audit`)

Closes the loop the design session opened. The dossier is the contract; the audit
verifies the implementation against it. Never edit code; produce a report.

1. **Read the dossier** (resolve it per dossier.md "Audit re-find": recompute the
   current branch's path first; if absent — branch renamed/squashed — glob
   `.lens/dossiers/*.md` and let the user pick by goal/date/branch). A valid one (goal
   matches what was built, has a lens plan and decisions) → it defines the audit: scope
   = its goal + blast-radius map; lens set = the design-time lens plan. No valid dossier
   → confirm scope with the user and build an audit plan from registry trigger signals
   instead. (Audit never moves branches — it only reads.)
2. **Confirm the audit plan** with the user: which lenses run (only those whose
   registry row includes `audit` mode — name the planned lenses that lack audit mode
   and skip them explicitly), over which paths. Prunable, like the design plan.
3. **Run each lens's audit battery serially in this session** (each lens's SKILL.md
   defines its audit procedure). Single-writer rule: only you write the dossier.
4. **Contract check** — the part individual lens audits cannot do:
   - every `decision` recorded in the dossier → implemented as decided? Cite
     `file:line`, or flag the drift and ask whether it was intentional.
   - every `open` question → now answerable from the code? Answer it with evidence
     or escalate it back to the user.
   - every accepted `risk` → did it materialize? Is any mitigation present?
5. **Synthesis**: merged lens findings ordered by severity + the contract-check table
   (decision → honored / drifted / intentionally changed) + updated dossier.
6. **Close**: remind the user to run /lens:retro — an audit session is prime retro
   material (the hook has already queued it).

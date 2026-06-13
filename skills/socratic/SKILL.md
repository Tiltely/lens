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

1. **Dossier**: create/reset `.lens-dossier.md` per dossier.md (goal + date header;
   git exclusion). Run stack detection (core/stack-detection.md); record `stack:`.
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
   script: each answer may spawn new branches — add them to `## frontier` and work
   the frontier DOWN (highest-leverage branch next), not just the round order.
   Discovery ends only when the frontier is empty or every branch is deferred.
   Append everything to the dossier as you go.
3. **Lens plan** (build it once the frontier is empty or deferred): from the `lens`
   rows of core/registry.md — MERGED with the user's
   personal registry (`<foundry>/registry.md`, when `~/.claude/lens.json` exists) —
   pick the lenses whose trigger signals match what the rounds surfaced. Personal
   lenses are invoked by their skill name (`lens-<name>`); mark them "(personal)" in
   the plan. Present an ordered plan: lens → one-line reason. Let the user prune or
   reorder.
4. **Execute the chain in this session**: invoke each planned lens skill in order.
   Each lens reads the dossier and skips answered questions (printing skip lines).
5. **Synthesis**: decisions made; open risks; the four excavations as a compact map;
   concrete action list. Write the final dossier state.
6. **Close**: remind the user — after the implementation lands, run
   `/lens:socratic audit` to verify it against this dossier, and /lens:retro after
   that (the SessionEnd hook has already queued this session if any lens ran).

## Flow — audit mode (`/lens:socratic audit`)

Closes the loop the design session opened. The dossier is the contract; the audit
verifies the implementation against it. Never edit code; produce a report.

1. **Read the dossier.** Valid one (goal matches what was built, has a lens plan and
   decisions) → it defines the audit: scope = its goal + blast-radius map; lens set =
   the design-time lens plan. No valid dossier → confirm scope with the user and
   build an audit plan from registry trigger signals instead.
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

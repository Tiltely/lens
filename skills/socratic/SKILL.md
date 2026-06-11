---
name: socratic
description: Use when starting any non-trivial feature, issue, or objective — BEFORE designing or coding. Runs iterative Socratic discovery (caveats, rabbit holes, blast radius), then plans and chains the right lenses. Trigger phrases - "let's build", "add feature", "I want to implement", "how should we approach".
---

# Socratic Discovery Orchestrator

Read first:
- ${CLAUDE_PLUGIN_ROOT}/core/protocol.md  (how to ask; the three excavations)
- ${CLAUDE_PLUGIN_ROOT}/core/dossier.md   (dossier lifecycle — you own creation/reset)
- ${CLAUDE_PLUGIN_ROOT}/core/registry.md  (available lenses for the plan)

v1 is DESIGN MODE ONLY: audits run as individual lens invocations, not through this
orchestrator.

## Flow

1. **Dossier**: create/reset `.lens-dossier.md` per dossier.md (goal + date header;
   git exclusion). Run stack detection (core/stack-detection.md); record `stack:`.
2. **Socratic rounds** (protocol.md rules — ONE question at a time):
   - Round A — the goal: what does success look like? for whom? what is explicitly
     out of scope?
   - Round B — caveats: what must be true for this to work? what constraints bound it?
   - Round C — rabbit holes: which sub-problems look small but are not? Name each.
   - Round D — blast radius: which systems/repos/platforms/people does this touch?
     (API, web, mobile, DB, infra, third parties, docs, team.)
   Append everything to the dossier as you go. Stop lines per protocol.md.
3. **Lens plan**: from registry.md `lens` rows, pick the lenses whose trigger signals
   match what the rounds surfaced. Present an ordered plan: lens → one-line reason.
   Let the user prune or reorder.
4. **Execute the chain in this session**: invoke each planned lens skill in order.
   Each lens reads the dossier and skips answered questions (printing skip lines).
5. **Synthesis**: decisions made; open risks; the three excavations as a compact map;
   concrete action list. Write the final dossier state.
6. **Close**: remind the user — after the implementation lands, run /lens:retro
   (the SessionEnd hook has already queued this session if any lens ran).

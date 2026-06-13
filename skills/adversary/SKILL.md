---
name: adversary
description: The Lens of the Adversary — red-teams a PLAN before you commit to it. Tries to refute it, names the weakest decision and the unexamined assumption, re-checks the four excavations against the plan. Runs as the MANDATORY final step of /lens:socratic, or standalone (/lens:adversary) on any plan, diff, or design. A meta-lens — it critiques the plan, not a domain.
---

# The Lens of the Adversary

Read first: ${CLAUDE_PLUGIN_ROOT}/core/protocol.md and ${CLAUDE_PLUGIN_ROOT}/core/dossier.md.

This is a META lens: it examines the PLAN itself for weakness, not a domain
perspective. It runs as the mandatory final step of /lens:socratic (and standalone on
any plan/diff). Adversarial critique reliably surfaces what normal planning misses —
so a plan is not "done" until it survives this pass.

## First: suggest plan mode, then WAIT

If the work is substantial enough to deserve a written plan, SUGGEST to the user that
they enter Claude Code's plan mode (or otherwise formalize the plan as a written
artifact) — and WAIT for their input. Do NOT toggle plan mode yourself. If they
decline, or the work is small, critique the plan as it stands.

## The red-team battery

Attack the plan from these angles; every finding must be CONCRETE, not generic:

1. **Refutation:** name the ONE assumption that, if wrong, breaks the plan. Is it
   verified or merely assumed? An assumed load-bearing assumption is the top risk.
2. **Weakest decision:** of the decisions recorded in the dossier/plan, which is least
   defensible, and why? What alternative was dismissed too fast?
3. **What discovery missed:** re-run the four excavations (protocol.md) AGAINST the
   plan — a caveat, rabbit hole, blast-radius entry, or platform-matrix gap the plan
   does not address. This is where socratic plans most often leak.
4. **Reversibility & blast radius:** what here is hard to undo, and is the plan
   treating it with the caution it deserves? Who/what breaks if this ships wrong?
5. **"First thing that worked" test:** is this the best plan, or the first coherent
   one? Name one genuinely different approach and say why it lost — or didn't.

On substantial work, fan out: run the angles as independent adversarial passes (or
read-only subagents) so no single line of attack dominates, then merge.

## Disposition — every surviving finding

Each finding the plan cannot already answer becomes exactly one of:
- **revise** — change a decision in the dossier (state the new decision);
- **reopen** — spawn a frontier branch (protocol.md) and hand back to discovery;
- **accept** — record as an explicit accepted risk, with an owner, in the dossier.
Never let a real finding evaporate as "noted".

## Output contract

A critique table: angle · finding · disposition (revise/reopen/accept) · the concrete
change or risk. Then the verdict: the plan SURVIVES (every finding dispositioned) or
needs another discovery round. Append the critique + verdict to the dossier.

## Feed the foundry

Gaps (an attack angle this battery lacks, or a recurring plan-weakness pattern) →
`{"type":"gap","date":"<YYYY-MM-DD>","lens":"adversary","note":"<one line>"}` appended
to `<foundry>/pending-retros.jsonl` when a lens config exists; otherwise mention it.

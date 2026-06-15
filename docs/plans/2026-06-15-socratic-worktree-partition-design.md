# Design — Socratic worktree partition (parallel features)

Date: 2026-06-15 · Target version: 0.8.0 (feature) · Status: validated, pre-implementation

## Problem

`/lens:socratic` (v0.7.0) runs one discovery session → one branch-scoped dossier → one
implementation. Real requests often bundle several features that could be built in
parallel. The user wants socratic to turn a multi-feature request into N isolated
worktrees, each with a refined dossier, ready to implement concurrently and then
reconcile — without breaking the simple single-feature case or Cowork.

## Core decision (the simplification)

Do the WHOLE dossier first, then split. Discovery is unchanged (one complete dossier of
the entire request). Partitioning is a SEPARATE, later step that reads the dossier's
already-mapped blast-radius and divides it into parallelizable features. This keeps the
discovery flow untouched (zero risk), operates on information already captured, and
mirrors the project's existing core-vs-infra split (lenses/socratic are universal; the
memory loop is Claude-Code-only). Worktrees become another Claude-Code-only layer.

## Pipeline — 4 phases

### Phase 1 — Discovery · unchanged · works on Cowork
The v0.7.0 socratic design flow verbatim: one complete branch-scoped dossier of the
whole request (rounds, frontier, the four excavations incl. **blast-radius**, lens plan,
decisions, adversary). No new complexity in the question flow.

### Phase 2 — Partition · NEW, opt-in, post-synthesis · works on Cowork
After the dossier is FINAL (post-adversary), socratic reads the **blast-radius it already
mapped** and proposes splitting the dossier into parallelizable features:
- **Independent** features (minimal file/contract overlap) → candidate worktrees.
- **Coupled** features (shared files/contracts, or one depends on another) → merged into
  one feature/worktree, or marked **sequential**. Parallelism only where it's safe;
  reconciliation stays clean.
Writes a `## partition` section into the dossier: each feature, the files/contracts it
touches, what's independent, and the suggested **reconciliation order**. This is pure
reasoning + text (no git action) → runs on Cowork unchanged.

### Phase 3 — Materialization · Claude-Code-only · degrades on Cowork
After the user's OK (consent, never silent), create N worktrees + branches. Each worktree
gets the **complete dossier** (shared context, so a feature never contradicts the others)
plus a **feature manifest** ("your feature is X; you touch these files; these decisions
are global"). On Cowork this phase is skipped: the user keeps the dossier + `## partition`
plan and applies it however Cowork allows.

### Phase 4 — Reconciliation · Claude Code · reuses `audit`
A reconciliation step audits each worktree against its dossier (the existing audit mode)
and follows the `## partition` reconciliation order (independent first), flagging the few
expected contact points. The user runs the merges with that guidance.

## Key design decisions (validated)

1. **New MODE of socratic, not a separate skill** — reuses all machinery (rounds,
   frontier, excavations, lens plan, adversary, branch-scoped dossier, audit).
2. **Auto-detect + consent + graceful degrade** — single feature ⇒ exactly v0.7.0
   behavior. Multi-feature ⇒ socratic OFFERS partition at the end; never spawns worktrees
   without an explicit OK. Also invokable standalone (`/lens:socratic partition`) over an
   existing valid dossier.
3. **Couple-aware partition** — only parallelize the independent; coupled features merge
   or sequence. Uses the blast-radius already in the dossier.
4. **Each worktree = complete dossier + feature manifest** — not a trimmed sub-dossier;
   no loss of cross-feature context.
5. **Worktrees are Claude-Code-only** (like the memory loop); the `## partition` plan is
   universal (Cowork-safe).
6. **Reconciliation = per-feature audit + merge order** (reuses audit mode).

## Files to touch (at implementation)

- `skills/socratic/SKILL.md` — add the partition step (post-synthesis/adversary), the
  worktree materialization, and the reconciliation flow; document the standalone
  `partition` invocation and the single-feature degrade.
- `core/dossier.md` — document the `## partition` section + the per-worktree feature
  manifest; note worktrees give double isolation (toplevel + branch).
- `core/protocol.md` — if partition leans on protocol concepts (blast-radius as the
  partition input), add a short pointer.
- `tests/scenarios.md` — new scenario: multi-feature request → partition proposed →
  worktrees materialized with full dossier + manifest → degrade to single-feature on a
  one-feature request → Cowork degrade (plan only, no worktrees).
- `README.md` (How it works + Cowork section), `CHANGELOG.md`, `.claude-plugin/plugin.json`
  → 0.8.0.

## Cowork

Phases 1–2 run on Cowork (discovery + partition plan are skill reasoning). Phase 3
(worktrees) is Claude-Code-only and declines cleanly on Cowork, consistent with how the
memory loop already behaves (README:40-55, setup/SKILL.md:13). On Cowork the user gets
the full dossier + `## partition` plan to apply with Cowork's own parallelism.

## Open questions for implementation

- Exact name/trigger for the partition step (`partition` arg vs auto-offer only).
- Manifest format (a small header block in the copied dossier vs a separate file).
- How Phase 4 locates the N worktrees (the `## partition` plan should record their paths).

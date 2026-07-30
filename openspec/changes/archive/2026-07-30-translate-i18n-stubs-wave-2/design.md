## Context

Propose-factory residual inventory (2026-07-27) after open translate PRs #84 / #93–#119 shows four completable ≤budget residual-PT Session Handoff stubs in active `translate-*` proposals that wave-1 did **not** own:

| Path | ~LOC | Residual |
|------|------|----------|
| `openspec/changes/translate-agents-rules-wave-1/proposal.md` | ~66 | Stub: `Ler:` / `assumir ✅ — não reinstalar` |
| `openspec/changes/translate-agents-rules-wave-1b/proposal.md` | ~67 | Same stub pattern |
| `openspec/changes/translate-agents-rules-wave-1c/proposal.md` | ~67 | Same stub pattern |
| `openspec/changes/translate-kit-wave-2c/proposal.md` | ~70 | Same stub pattern |

Combined ~270 LOC / 4 files. `doc/i18n/CURSOR-AUTOMATIONS.md` §6 already documents the English stub form. Owned-set rule: union of path lists in active `translate-*` What Changes **and** open translate PR path lists — these four proposal files are not listed as translation targets there (wave-1 owns only `WAVE-PROPOSAL-TEMPLATE.md` + `add-i18n-cursor-automations-guide/proposal.md`).

Constraints: wave budgets ≤4 files / ≤350–400 LOC; in-place only; F7 English versioned artifacts; G-PT scans whole `--files` paths; archive OUT.

## Goals / Non-Goals

**Goals:**

- Substitute the Portuguese Session Handoff stub labels in the four listed proposal files to glossary-canonical English matching `CURSOR-AUTOMATIONS.md` §6.
- Keep stub structure (phase command, Change path, Read/Gate/Infra lines), each wave's change-id, and each Gate `--files` list intact.
- Pass `bash scripts/verify-i18n-wave.sh --files` on the exact four paths.

**Non-Goals:**

- `translate-kit-wave-2d/proposal.md` stub (fits a follow-on stubs wave-3).
- Session Handoff stubs in `translate-*/tasks.md` or `design.md` (separate later stubs waves if still residual).
- Over-budget surfaces (canonical guide, `aula-05`, design/kit `001`, `explore-adversarial` research, discovery `research.md`) — need split strategy.
- Other owned translate target slices (#84 / #93–#119 What Changes paths).
- `openspec/changes/archive/`.
- Rewriting `WAVE-PROPOSAL-TEMPLATE.md` / `add-i18n-cursor-automations-guide/proposal.md` (wave-1).
- Dual-file `*.en.md` / `*-pt.md`.
- Global G-DoD (`--dod`).
- Skills/commands mirrors; kit templates / G-MANIFEST.

## Knowledge sources consulted (R8)

- `doc/i18n/GLOSSARY.md` — term bank + freeze/allowlist
- `doc/i18n/WAVES.md` — budgets; active `openspec/changes/*/proposal.md` in-scope; archive OUT
- `doc/i18n/CURSOR-AUTOMATIONS.md` — §4.1 propose factory; §6 English Session Handoff stubs
- `doc/i18n/WAVE-PROPOSAL-TEMPLATE.md` — template (owned by wave-1; not edited here)
- `openspec/specs/sdd-docs-language/spec.md` — EN default, in-place waves
- Open PRs #84 / #93–#119 — owned path union (including wave-1 targets)
- AS-IS targets: the four `translate-*/proposal.md` Session Handoff stubs
- `scripts/verify-i18n-wave.sh`
- Graphify / GitNexus — SKIP / docs-only (markdown stubs; no code symbols)
- GitHub Issues — no open issue required (**Issue:** —)

## Decisions

### D1: Scope = four W1/W2c proposal stubs (leave W2d)

| Option | Verdict |
|--------|---------|
| A — Guide / aula-05 / design `001` / adversarial / discovery research | Rejected — over ≤350–400 LOC; mid-file guide blocked by whole-file G-PT |
| B — Only `kit-wave-2d` + leftover tasks/design stubs | Viable later; not the densest same-pattern slice |
| C — All five remaining proposal stubs (W1/W1b/W1c/W2c/W2d) | Rejected — exceeds ≤4 files |
| D — W1 + W1b + W1c + W2c (~270 LOC, 4 files) | **Accepted** — fits budgets; same residual pattern; disjoint from owned set; leaves W2d for stubs-wave-3 |

### D2: Align stubs to CURSOR-AUTOMATIONS §6 wording

Apply MUST replace Portuguese stub labels with the English forms already normative in §6 (`Read:`, `assume ✅ — do not reinstall`). Do not invent a third stub dialect.

### D3: Touch only Session Handoff stub labels

Do not rewrite Why / What Changes / Impact bodies of the parent translate proposals beyond residual PT inside the Session Handoff stub fence. Keep each Gate `--files` CSV byte-stable.

### D4: No kit checksum / mirror work this wave

Targets are four active-change proposal stubs — G-MANIFEST and G-MIRROR N/A.

## Risks / Trade-offs

| Risk | Mitigation |
|------|------------|
| Parent wave apply PRs also edit the same `proposal.md` | Unlikely (apply edits translation **targets**, not usually the propose artifact); if conflict, prefer stub EN labels |
| Accidental rewrite of Gate path lists or change-ids | Freeze checklist + G-INV |
| G-PT still fails if other PT tokens exist outside the stub | Inventory shows stub-only residual on these four; verify gate before done |
| Remaining stubs (W2d proposal; some tasks/design) after this wave | Expected — next propose factory tick can take stubs-wave-3 |

## Migration Plan

1. Propose merges (this PR) — artifacts only under `openspec/changes/translate-i18n-stubs-wave-2/`.
2. Separate `/opsx:apply` run substitutes the four target files in-place (stub labels only).
3. Gate with `verify-i18n-wave.sh --files …` + openspec validate.
4. Archive in a later run after apply merges.
5. Rollback: `git checkout --` the four target paths if apply regresses meaning.

## Open Questions

- None for propose. After this wave, remaining completable stubs include at least `translate-kit-wave-2d/proposal.md` plus any `tasks.md`/`design.md` stub hits; over-budget surfaces still need a human split strategy.

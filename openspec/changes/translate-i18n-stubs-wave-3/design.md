## Context

Propose-factory residual inventory (2026-07-27) after open translate PRs #84 / #93–#120 shows two completable ≤budget residual-PT surfaces deferred by stubs-wave-2:

| Path | ~LOC | Residual |
|------|------|----------|
| `openspec/changes/translate-kit-wave-2d/proposal.md` | ~75 | Stub: `Ler:` / `assumir ✅ — não reinstalar` |
| `openspec/changes/translate-agents-rules-wave-1b/simplify-review.md` | ~15 | Review chrome/body still PT (`Escopo`, `ficheiros`, `Veredito`, `Achados`, …) |

Combined ~90 LOC / 2 files. `doc/i18n/CURSOR-AUTOMATIONS.md` §6 already documents the English stub form. Owned-set rule: union of path lists in active `translate-*` What Changes **and** open translate PR path lists — these two paths are not listed as translation targets there (wave-1 owns template + add-i18n proposal; wave-2 owns W1/W1b/W1c/W2c proposals).

Constraints: wave budgets ≤4 files / ≤350–400 LOC; in-place only; F7 English versioned artifacts; G-PT scans whole `--files` paths; archive OUT.

## Goals / Non-Goals

**Goals:**

- Substitute the Portuguese Session Handoff stub labels in `translate-kit-wave-2d/proposal.md` to glossary-canonical English matching `CURSOR-AUTOMATIONS.md` §6.
- Substitute residual Portuguese in `translate-agents-rules-wave-1b/simplify-review.md` to English while preserving LEAN / ship meaning.
- Keep W2d stub structure (including W2c prerequisite lines, Change path, Read/Gate/Infra), and the Gate `--files` list intact.
- Pass `bash scripts/verify-i18n-wave.sh --files` on the exact two paths.

**Non-Goals:**

- Paths already owned by stubs-wave-1 / stubs-wave-2.
- Over-budget surfaces (canonical guide, `aula-05`, design/kit `001`, `explore-adversarial` research, discovery `research.md`) — need split strategy.
- Other owned translate target slices (#84 / #93–#120 What Changes paths).
- `openspec/changes/archive/`.
- Dual-file `*.en.md` / `*-pt.md`.
- Global G-DoD (`--dod`).
- Skills/commands mirrors; kit templates / G-MANIFEST.
- Deny-list tokens that appear only inside English gate strings in other `translate-*/tasks.md` / `design.md` (not residual prose stubs).

## Knowledge sources consulted (R8)

- `doc/i18n/GLOSSARY.md` — term bank + freeze/allowlist
- `doc/i18n/WAVES.md` — budgets; active `openspec/changes/*/proposal.md` in-scope; archive OUT
- `doc/i18n/CURSOR-AUTOMATIONS.md` — §4.1 propose factory; §6 English Session Handoff stubs
- `doc/i18n/WAVE-PROPOSAL-TEMPLATE.md` — template (owned by wave-1; not edited here)
- `openspec/specs/sdd-docs-language/spec.md` — EN default, in-place waves
- Open PRs #84 / #93–#120 — owned path union (including stubs-wave-1/2 targets)
- AS-IS targets: W2d proposal Session Handoff stub; W1b `simplify-review.md`
- `scripts/verify-i18n-wave.sh`
- Graphify / GitNexus — SKIP / docs-only (markdown stubs; no code symbols)
- GitHub Issues — no open issue required (**Issue:** —)

## Decisions

### D1: Scope = W2d stub + W1b simplify-review

| Option | Verdict |
|--------|---------|
| A — Guide / aula-05 / design `001` / adversarial / discovery research | Rejected — over ≤350–400 LOC; mid-file guide blocked by whole-file G-PT |
| B — Only `kit-wave-2d/proposal.md` | Viable; leaves a tiny orphan review file for another tick |
| C — W2d stub + W1b `simplify-review.md` (~90 LOC, 2 files) | **Accepted** — fits budgets; both residual PT on active translate surfaces; disjoint from owned set; finishes the stub chain deferred by wave-2 |
| D — Bundle unrelated over-budget split half | Rejected — needs a dedicated split propose, not a stubs wave |

### D2: Align W2d stub to CURSOR-AUTOMATIONS §6 wording

Apply MUST replace Portuguese stub labels with the English forms already normative in §6 (`Read:`, `assume ✅ — do not reinstall`). Do not invent a third stub dialect. Keep the W2c prerequisite comment lines in the stub fence.

### D3: Touch only residual Portuguese

Do not rewrite Why / What Changes / Impact bodies of the W2d proposal beyond residual PT inside the Session Handoff stub fence. Keep the Gate `--files` CSV byte-stable. For simplify-review, translate chrome/body language only — keep change-id, LEAN verdict, and net-line conclusion semantics.

### D4: No kit checksum / mirror work this wave

Targets are active-change artifacts — G-MANIFEST and G-MIRROR N/A.

## Risks / Trade-offs

| Risk | Mitigation |
|------|------------|
| Parent W2d apply PR also edits `proposal.md` | Unlikely (apply edits translation **targets**, not usually the propose artifact); if conflict, prefer stub EN labels |
| Accidental rewrite of Gate path lists or change-ids | Freeze checklist + G-INV |
| G-PT still fails if other PT tokens exist outside the stub | Inventory shows stub-only residual on W2d proposal; whole-file EN for simplify-review |
| After this wave, remaining residual may be over-budget only | Expected — next propose factory ticks may idle or start split proposes |

## Migration Plan

1. Propose merges (this PR) — artifacts only under `openspec/changes/translate-i18n-stubs-wave-3/`.
2. Separate `/opsx:apply` run substitutes the two target files in-place.
3. Gate with `verify-i18n-wave.sh --files …` + openspec validate.
4. Archive in a later run after apply merges.
5. Rollback: `git checkout --` the two target paths if apply regresses meaning.

## Open Questions

- None for propose. After this wave, completable Session Handoff stub residuals on active `translate-*/proposal.md` should be exhausted; remaining residual PT is largely over-budget (guide / aula-05 / design `001` / adversarial / discovery research) and needs an explicit split strategy.

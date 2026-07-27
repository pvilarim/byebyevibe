# Design — translate-specs-wave-2 (sdd-install-kit residual PT→EN)

## Context

- Layer-1 policy and wave budgets live under `sdd-docs-language` / `doc/i18n/*`.
- Open DRAFT PR #104 (`translate-specs-wave-1`) owns three other residual-PT capability specs and explicitly defers `openspec/specs/sdd-install-kit/spec.md` to this wave.
- Active translate ownership on current base and open translate PRs #78 / #84 / #93–#104 do not list `sdd-install-kit/spec.md` as a primary ownership target.
- Canonical guide and aula-05 remain deferred (mid-file G-PT / over LOC).
- Chosen primary surface: `openspec/specs/sdd-install-kit/spec.md` (~292 LOC). Residual PT includes upgrade MERGE classification, HYBRID bootstrap warning, COPY label, dry-run/apply header, and approval-checkbox wording.
- Live contracts currently Portuguese in scripts: `sdd-kit/upgrade.sh` greps `[x] Actualização aprovada`; kit template `bootstrap-sdd.sh` emits HYBRID WARN with deny-list tokens. Spec G-PT cannot keep those Portuguese quotes; apply MUST realign the literals.

## Goals / Non-Goals

**Goals:**

- Substitute all Portuguese prose in `openspec/specs/sdd-install-kit/spec.md` with glossary-canonical English **in-place** (whole-file G-PT).
- Realign English approval marker + HYBRID WARN literals in companion scripts so runtime contracts match the EN spec.
- Fully English the bootstrap template (+ hub sync) so it can be included in wave `--files` (≤56 LOC) without G-PT residue.
- Preserve normative meaning of install/upgrade/bootstrap requirements.
- Pass wave gates including G-MANIFEST after template checksum refresh.

**Non-Goals:**

- Specs owned by `translate-specs-wave-1`.
- Full Portuguese→English rewrite of the entire `upgrade.sh` UPGRADE_REPORT scaffold / dry-run chrome beyond approval marker + ERROR lines required for contract parity (remaining scaffold PT is deferred; `upgrade.sh` is not in G-PT `--files`).
- Canonical guide, skills/commands, kit design templates, hub infra, evaluations, design, course.
- Dual-file `*.en.md` / `*-pt.md`; global G-DoD; path renames; semantic changes to install/upgrade/bootstrap.

## Knowledge sources consulted (R8)

- `doc/i18n/GLOSSARY.md`, `WAVES.md`, `WAVE-PROPOSAL-TEMPLATE.md`, `CURSOR-AUTOMATIONS.md`
- `openspec/specs/sdd-docs-language/spec.md`
- Open PR #104 / `translate-specs-wave-1` (deferred install-kit)
- AS-IS: `openspec/specs/sdd-install-kit/spec.md`, `sdd-kit/upgrade.sh`, `sdd-kit/templates/scripts/bootstrap-sdd.sh`, `scripts/bootstrap-sdd.sh`
- `scripts/verify-i18n-wave.sh`, `sdd-kit/gen-manifest-checksums.sh`
- Graphify / GitNexus — SKIP / docs+script string edits (no symbol refactor)
- GitHub Issues — **Issue:** —

## Decisions

### D1: Scope = install-kit spec + contract companions

| Option | Verdict |
|--------|---------|
| A — Guide W3 mid-file | Rejected — whole-file G-PT |
| B — aula-05 (~503) | Rejected — over LOC |
| C — Spec only, keep PT quotes in spec | Rejected — G-PT deny-list matches `Actualização` / WARN tokens |
| D — Spec + EN contract literals in upgrade.sh + full-EN bootstrap template/hub | **Chosen** — ≤4 files; primary ~292 LOC; bootstrap ~56; upgrade.sh mechanical strings only |
| E — Kit design template mirrors | Deferred — checksum-aware after hub design apply |

### D2: In-place substitution; no dual-file

**Chosen:** Rewrite at the same paths. Forbidden: `*.en.md` / `*-pt.md`.

### D3: English runtime markers with semantic parity

**Chosen:** Spec and scripts converge on English literals, e.g.:

- Approval: `[x] Upgrade approved` (and unchecked scaffold `- [ ] Upgrade approved by the user` where the marker line is updated)
- HYBRID WARN: English equivalent of the current Portuguese coexistence warning, same advisory non-fatal behavior

**Rationale:** G-PT cannot retain Portuguese deny-list tokens in the spec; upgrade.sh currently enforces the Portuguese marker.

### D4: G-PT `--files` excludes `upgrade.sh`

**Chosen:** Wave verify lists the spec + both bootstrap paths. Dedicated task gates assert EN approval marker strings inside `upgrade.sh` without subjecting the whole script to G-PT this wave.

**Rationale:** Remaining PT in UPGRADE_REPORT scaffold would fail G-PT if `upgrade.sh` were listed; that scaffold is deferred.

### D5: Spec delta under `sdd-docs-language`

**Chosen:** ADDED requirement that `sdd-install-kit/spec.md` MUST be English and that asserted runtime literals MUST stay aligned with scripts. No new capability id.

## Risks / Trade-offs

| Risk | Mitigation |
|------|------------|
| Approval marker drift (spec EN / script PT) | Tasks require both updated; grep gates on `upgrade.sh` |
| Hub bootstrap lags template | Explicit sync task; cmp or content gates |
| Checksum stale after template edit | `gen-manifest-checksums.sh` + G-MANIFEST |
| Accidental edit to wave-1 specs | Non-goal; own only listed paths |
| Parallel factory races | Owned-set includes PR #104; install-kit deferred there |

## Migration plan

1. Human approves this propose (R7) — DRAFT PR (artifacts only).
2. `/opsx:apply translate-specs-wave-2` after propose merge.
3. Apply substitutes spec + companions; refresh MANIFEST checksums; run gates.
4. Archive later — promote ADDED requirement into `openspec/specs/sdd-docs-language/spec.md`.
5. Follow-up: remaining `upgrade.sh` scaffold PT; aula-05 split; kit design mirrors; guide G-PT strategy.

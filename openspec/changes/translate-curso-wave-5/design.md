# Design — translate-curso-wave-5 (course scripts AGENTS.md PT→EN)

## Context

- Layer-1 policy and wave budgets live under `sdd-docs-language` / `doc/i18n/*`.
- Active translate ownership on current base includes kit W2c/W2d, hub `openspec/infra.md`, skills waves 1–6, avaliacoes-wave-1, design-waves 1–2. None own `doc/curso/scripts/AGENTS.md`.
- Open translate PRs (owned paths): #78 kit apply (templates); #84 avaliacoes-wave-2 (two evaluation files); #93–#98 commands-wave-1..4 (opsx command pairs); #99 curso-wave-1 (`doc/curso/aula-04-workshop-ia-5-2026.md`); #100 curso-wave-2 (`doc/curso/aula-03-workshop-ia-5-2026.md`); #101 curso-wave-3 (`doc/curso/aula-02-workshop-ia-5-2026.md`); #102 curso-wave-4 (`doc/curso/aula-01-workshop-ia-5-2026.md`). All four curso proposes list `doc/curso/scripts/AGENTS.md` as an explicit **non-goal**.
- Canonical guide (`doc/sistema-sdd-pedro.md`) remains deferred for mid-file G-PT; factory prefers completable whole-file slices.
- WCu inventory (deny-list residual, approx.): aulas 01–04 owned by waves 4–1 / PRs #102–#99; **`scripts/AGENTS.md` ~28 LOC (this wave)**; aula-05 ~503 (over budget alone); `aula-*-shared-files.md` mostly category chrome with few/no deny-list hits — later polish waves.

## Goals / Non-Goals

**Goals:**

- Substitute all Portuguese prose in `doc/curso/scripts/AGENTS.md` with glossary-canonical English **in-place** (whole-file G-PT).
- Preserve script CLI names, CDP prerequisite (`--remote-debugging-port=9222`), VTT preference host path, relative pointer to root `../../../AGENTS.md`, Tech Leads Club auth profile note, A–E + security inheritance, and extract→enrich flow order.
- Map common PT vocabulary via glossary / ordinary EN (`não`→not, `canónico`→canonical, `sessão`→session when prose, `antes de`→before, `requisito` / prerequisites heading → Prerequisites, Commands / Flow section chrome) without inventing synonym drift.
- Pass `bash scripts/verify-i18n-wave.sh --files doc/curso/scripts/AGENTS.md`.

**Non-Goals:**

- Workshop lessons owned by `translate-curso-wave-1`..`4` (PRs #99–#102).
- `aula-*-shared-files.md`; aula-05 (needs split).
- Root `AGENTS.md` / `CLAUDE.md` (already covered by agents-rules waves).
- Canonical guide, skills/commands, kit templates, hub infra, evaluations, design docs.
- Dual-file `*.en.md` / `*-pt.md`.
- Global G-DoD (`--dod`).
- Path renames; changing extract/enrich/CDP workflow semantics — language only.

## Knowledge sources consulted (R8)

- `doc/i18n/GLOSSARY.md` — term bank + freeze/allowlist
- `doc/i18n/WAVES.md` — budgets; `doc/curso/` in-scope by default (WCu)
- `doc/i18n/WAVE-PROPOSAL-TEMPLATE.md` — proposal shape
- `doc/i18n/CURSOR-AUTOMATIONS.md` — propose-factory phase; parallel disjoint proposes
- `openspec/specs/sdd-docs-language/spec.md` — EN default, in-place waves
- Open PRs #99–#102 (`translate-curso-wave-1`..`4`) — prior WCu propose pattern; AGENTS.md deferred non-goal
- AS-IS: `doc/curso/scripts/AGENTS.md`
- `scripts/verify-i18n-wave.sh`
- Graphify / GitNexus — SKIP / docs-only (markdown agents stub; no code symbols)
- GitHub Issues — no open issue required (**Issue:** —)

## Decisions

### D1: Scope = course scripts AGENTS.md alone (curso wave-5)

| Option | Verdict |
|--------|---------|
| A — Guide W3 mid-file section | Rejected — G-PT scans whole `--files` paths |
| B — Hub `doc/curso/scripts/AGENTS.md` alone (~28) | **Chosen** — 1 file / ~28 LOC; residual PT; whole-file G-PT; explicitly deferred by waves 1–4; disjoint from owned set |
| C — Bundle AGENTS.md + all `aula-*-shared-files.md` | Deferred — shared-files have few/no deny-list hits; keep this wave minimal and completable |
| D — aula-05 alone (~503) | Rejected — exceeds ≤350–400 LOC; needs split + G-PT strategy |
| E — Spec residual PT (`sdd-install-kit` etc.) | Deferred — WCu queue continues with the deferred AGENTS.md slice first |
| F — Kit `sdd-kit/templates/doc/design/003` | Deferred — checksum-aware; prefer after hub design apply+archive |

**Rationale:** Memory / prior curso proposes queued `scripts/AGENTS.md` as the next small WCu polish after aula-01..04 proposes; it is the smallest residual-PT whole-file slice still unowned.

### D2: In-place substitution only (no dual-file)

**Chosen:** Rewrite Portuguese prose at the same path. Forbidden: `AGENTS.en.md`, `AGENTS-pt.md`, or parallel language trees under `doc/curso/scripts/`.

**Rationale:** Normative `sdd-docs-language` / WAVES.md — dual-file EN/PT siblings are forbidden.

### D3: Freeze script identifiers and workflow tokens

Keep byte-stable: `extract-lessons-batch.py`, `enrich-transcripts.py`, `_debug-lessons345.py`, `performance.clearResourceTimings()`, `--remote-debugging-port=9222`, `techleads.club/media_transcripts/`, `../../../AGENTS.md`, output patterns `aula-XX-workshop-*.md` / `aula-XX-shared-files.md`, org **Tech Leads Club**, Python 3.10+.

Translate: title/intro (“Scripts do curso…” → course scripts agents blurb), table headers (`Comando`/`Uso` → Command/Use), usage blurbs, section headings (`Pré-requisitos` → Prerequisites, `Regras locais` → Local rules, `Fluxo` → Flow), and local-rule / flow prose.

**Rationale:** Agents must still run the same CDP extract/enrich pipeline after language substitution.

### D4: Spec delta = lasting EN requirement for this slice

**Chosen:** ADDED requirement under `sdd-docs-language` that this course-scripts AGENTS file MUST be English after substitution. Do not invent a new `sdd-curso` capability in this language wave.

**Rationale:** Same pattern as prior translate-* ADDED slice requirements (including curso-wave-1..4).

## Risks / Trade-offs

| Risk | Mitigation |
|------|------------|
| Semantic drift of extract→enrich / CDP steps | Tasks require fact parity; freeze script names, flags, host paths |
| G-PT false positives on names/paths | Freeze/allowlist Tech Leads Club and path strings |
| Collision with curso-wave-1..4 apply | Own only `doc/curso/scripts/AGENTS.md`; document aulas as non-goal / owned by waves 1–4 |
| Parallel propose factory races | Owned-set includes open PR path lists; this path is non-goal on #99–#102 and absent as primary on #78/#84/#93–#98 |

## Migration plan

1. Human approves this propose (R7) — DRAFT PR.
2. Separate `/opsx:apply translate-curso-wave-5` session after propose merge (or when artifacts are on apply base).
3. Apply substitutes the single course-scripts file in place; run wave gates.
4. Archive later (separate session): promote ADDED requirement into `openspec/specs/sdd-docs-language/spec.md`.
5. Follow-up WCu: split aula-05 (~503); optional shared-files polish; alternate later: residual specs / kit design templates.

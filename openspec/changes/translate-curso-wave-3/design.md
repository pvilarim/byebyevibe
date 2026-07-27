# Design — translate-curso-wave-3 (course lesson 02 workshop PT→EN)

## Context

- Layer-1 policy and wave budgets live under `sdd-docs-language` / `doc/i18n/*`.
- Active translate ownership on current base includes kit W2c/W2d, hub `openspec/infra.md`, skills waves 1–6, avaliacoes-wave-1, design-waves 1–2. None own `doc/curso/aula-02-*`.
- Open translate PRs (owned paths): #78 kit apply (templates); #84 avaliacoes-wave-2 (two evaluation files); #93–#98 commands-wave-1..4 (opsx command pairs); #99 curso-wave-1 (`doc/curso/aula-04-workshop-ia-5-2026.md`); #100 curso-wave-2 (`doc/curso/aula-03-workshop-ia-5-2026.md`). None own aula-02.
- Canonical guide (`doc/sistema-sdd-pedro.md`) remains deferred for mid-file G-PT; factory prefers completable whole-file slices.
- WCu inventory (deny-list residual, approx.): aula-01 ~212 LOC, **aula-02 ~203 (this wave)**, aula-03 ~147 (owned by wave-2 / PR #100), aula-04 ~126 (owned by wave-1 / PR #99), aula-05 ~503 (over budget alone); `scripts/AGENTS.md` ~28 LOC deferred; `aula-*-shared-files.md` mostly category chrome with few/no deny-list hits — later polish waves.

## Goals / Non-Goals

**Goals:**

- Substitute all Portuguese prose in `doc/curso/aula-02-workshop-ia-5-2026.md` with glossary-canonical English **in-place**, including structured enrichment chrome **and** the spoken transcript body (whole-file G-PT).
- Preserve lesson metadata (URL, section/lesson/transcript IDs, duration), relative link to `aula-02-shared-files.md`, link-table URLs, and Spec-Driven / harness / code-review talk facts (native plan limits on large features, TLC spec-driven phases, gates/evals/DoD, atomic tasks vs board tasks, ~17% context with sub-agents, harness feedforward vs feedback, OpenSpec/BMAD/Superpowers/spec-kit comparisons, multi-skill code review vs CodeRabbit/Bugbot).
- Map common PT vocabulary via glossary / ordinary EN (`não`→not, `também`→also, `seção`→section, `próxima`/`próximo`→next, `mudança`→change when prose, `qualquer`→any, `durante o`→during the, `quando o`→when the, `então`→then, `habilidade`→skill when prose, `avaliação`→evaluation when prose, `verificação`→verification) without inventing synonym drift.
- Pass `bash scripts/verify-i18n-wave.sh --files doc/curso/aula-02-workshop-ia-5-2026.md`.

**Non-Goals:**

- Other workshop lessons (`aula-01|03|04|05`), including aula-03 owned by `translate-curso-wave-2` and aula-04 owned by `translate-curso-wave-1`.
- `aula-*-shared-files.md` and `doc/curso/scripts/AGENTS.md` (later WCu slices).
- Canonical guide, skills/commands, kit templates, hub infra, evaluations, design docs.
- Dual-file `*.en.md` / `*-pt.md`.
- Global G-DoD (`--dod`).
- Path renames; changing workshop facts or tooling recommendations — language only.
- Keeping a raw Portuguese transcript after apply (would fail G-PT on the whole path).

## Knowledge sources consulted (R8)

- `doc/i18n/GLOSSARY.md` — term bank + freeze/allowlist
- `doc/i18n/WAVES.md` — budgets; `doc/curso/` in-scope by default (WCu)
- `doc/i18n/WAVE-PROPOSAL-TEMPLATE.md` — proposal shape
- `doc/i18n/CURSOR-AUTOMATIONS.md` — propose-factory phase; parallel disjoint proposes
- `openspec/specs/sdd-docs-language/spec.md` — EN default, in-place waves
- `openspec/changes/translate-curso-wave-1/` (open PR #99) — prior WCu propose pattern
- `openspec/changes/translate-curso-wave-2/` (open PR #100) — prior WCu propose pattern (whole-file lesson slice)
- AS-IS: `doc/curso/aula-02-workshop-ia-5-2026.md`
- `scripts/verify-i18n-wave.sh`
- Graphify / GitNexus — SKIP / docs-only (markdown course lesson; no code symbols)
- GitHub Issues — no open issue required (**Issue:** —)

## Decisions

### D1: Scope = aula-02 workshop lesson alone (curso wave-3)

| Option | Verdict |
|--------|---------|
| A — Guide W3 mid-file section | Rejected — G-PT scans whole `--files` paths |
| B — Hub `doc/curso/aula-02-workshop-ia-5-2026.md` alone (~203) | **Chosen** — 1 file / ~203 LOC; residual PT; whole-file G-PT; disjoint from owned set (aula-03/04 owned by waves 2/1); memory queue preferred WCu next |
| C — Bundle aula-01+02 | Rejected — ~415 LOC exceeds ≤350–400 budget |
| D — aula-05 alone (~503) | Rejected — exceeds ≤350–400 LOC; needs split |
| E — Bundle `scripts/AGENTS.md` + shared-files with aula-02 | Deferred — keep WCu waves single dense lesson; follow-up waves can take scripts + shared-files |
| F — Spec residual PT (`sdd-install-kit` etc.) | Deferred — WCu queue continues; specs remain alternate later slices |
| G — Kit `sdd-kit/templates/doc/design/003` | Deferred — checksum-aware; prefer after hub design apply+archive |

**Rationale:** Next WCu entry after aula-03 propose should stay budget-safe and path-disjoint; aula-02 is the next densest remaining lesson under budget with clear residual PT.

### D2: In-place substitution — translate transcript body to EN

**Chosen:** Edit the hub path in place. Translate Resumo / Tópicos / category labels / spoken-reference blurbs / how-to-use **and** the `## Transcrição` body into English (faithful rendering of the talk). Forbidden: `*.en.md` / `*-pt.md` siblings; leaving raw PT transcript prose.

**Rationale:** `sdd-docs-language` dual-file prohibition; G-PT deny-list scans the entire `--files` path — a PT transcript would fail the wave DoD. Glossary allowlist for “quoted historical Portuguese” does **not** exempt unquoted transcript sections from G-PT. Heading may become `## Transcript`.

### D3: Preserve metadata, links, and talk facts

**Chosen:** Keep URL, Seção/Aula/Transcript ID fields (labels → English: Section/Lesson/Transcript ID), duration, numbered link table URLs, relative link to `aula-02-shared-files.md`, and factual claims (Cursor native plan limits on large features e.g. Stripe; TLC Spec-Driven phases; gates/evals/command-verifiable DoD; atomic tasks vs Jira/Linear board tasks; ~17% context with parallel sub-agents; harness engineering feedforward vs feedback; OpenSpec / BMAD / Superpowers / GitHub spec-kit; multi-skill code review vs CodeRabbit / Cursor Bugbot). Translate category column labels (e.g. Pesquisas e Referências → Research and references; Skills e Agentes → Skills and Agents; Spec-Driven / Design Docs stays EN; Code Review e Qualidade → Code review and quality; Vídeos → Videos; Excalidraw / Diagramas → Excalidraw / Diagrams; Canais TLC → TLC channels). Speaker line: keep **Waldemar Neto (Valdemar)**.

**Rationale:** Agents and humans must still navigate the same resources and IDs after language substitution.

### D4: Spec delta = lasting EN requirement for this slice

**Chosen:** ADDED requirement under `sdd-docs-language` that this course lesson file MUST be English after substitution. Do not invent a new `sdd-curso` capability in this language wave.

**Rationale:** Same pattern as prior translate-* ADDED slice requirements (including curso-wave-1 and curso-wave-2).

## Risks / Trade-offs

| Risk | Mitigation |
|------|------------|
| Semantic drift of Spec-Driven / harness / review facts | Tasks require fact parity (~17% context, tool names, phase order); freeze proper nouns |
| G-PT false positives on names/URLs/emoji | Freeze/allowlist; keep emoji markers if present |
| Broken relative link to shared-files | G-LINK; keep `./aula-02-shared-files.md` path string |
| Collision with curso-wave-1/2 apply | Own only aula-02; document aula-03/04 as non-goal / owned by waves 2/1 |
| Parallel propose factory races | Owned-set includes open PR path lists; this path absent from #78/#84/#93–#100 |

## Migration plan

1. Human approves this propose (R7) — DRAFT PR.
2. Separate `/opsx:apply translate-curso-wave-3` session after propose merge (or when artifacts are on apply base).
3. Apply substitutes the single course file in place; run wave gates.
4. Archive later (separate session): promote ADDED requirement into `openspec/specs/sdd-docs-language/spec.md`.
5. Follow-up WCu: aula-01 (~212), then split aula-05 (~503); optional `scripts/AGENTS.md` + shared-files polish.

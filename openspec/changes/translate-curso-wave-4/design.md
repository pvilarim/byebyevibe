# Design — translate-curso-wave-4 (course lesson 01 workshop PT→EN)

## Context

- Layer-1 policy and wave budgets live under `sdd-docs-language` / `doc/i18n/*`.
- Active translate ownership on current base includes kit W2c/W2d, hub `openspec/infra.md`, skills waves 1–6, avaliacoes-wave-1, design-waves 1–2. None own `doc/curso/aula-01-*`.
- Open translate PRs (owned paths): #78 kit apply (templates); #84 avaliacoes-wave-2 (two evaluation files); #93–#98 commands-wave-1..4 (opsx command pairs); #99 curso-wave-1 (`doc/curso/aula-04-workshop-ia-5-2026.md`); #100 curso-wave-2 (`doc/curso/aula-03-workshop-ia-5-2026.md`); #101 curso-wave-3 (`doc/curso/aula-02-workshop-ia-5-2026.md`). None own aula-01.
- Canonical guide (`doc/sistema-sdd-pedro.md`) remains deferred for mid-file G-PT; factory prefers completable whole-file slices.
- WCu inventory (deny-list residual, approx.): **aula-01 ~212 (this wave)**, aula-02 ~203 (owned by wave-3 / PR #101), aula-03 ~147 (owned by wave-2 / PR #100), aula-04 ~126 (owned by wave-1 / PR #99), aula-05 ~503 (over budget alone); `scripts/AGENTS.md` ~28 LOC deferred; `aula-*-shared-files.md` mostly category chrome with few/no deny-list hits — later polish waves.

## Goals / Non-Goals

**Goals:**

- Substitute all Portuguese prose in `doc/curso/aula-01-workshop-ia-5-2026.md` with glossary-canonical English **in-place**, including structured enrichment chrome **and** the spoken transcript body (whole-file G-PT).
- Preserve lesson metadata (URL, section/lesson/transcript IDs, duration), relative link to `aula-01-shared-files.md`, link-table URLs, and adoption / Context Engineering / RPI talk facts (DORA ROI curve, user-dev vs agent-builder iceberg, vibe coding vs AI-assisted development, LLM/agent/harness, AGENTS.md + on-demand loading + context rot, MCP for external context, RPI Research→Plan→Implement, Skills vs rules lazy loading, Technical Design Doc → phased tasks, sub-agents / context-window management, Q&A on legacy/language/MCP security/CLAUDE.md vs AGENTS.md).
- Map common PT vocabulary via glossary / ordinary EN (`não`→not, `também`→also, `seção`→section, `próxima`/`próximo`→next, `mudança`→change when prose, `qualquer`→any, `durante o`→during the, `quando o`→when the, `então`→then, `habilidade`→skill when prose, `avaliação`→evaluation when prose, `verificação`→verification) without inventing synonym drift.
- Pass `bash scripts/verify-i18n-wave.sh --files doc/curso/aula-01-workshop-ia-5-2026.md`.

**Non-Goals:**

- Other workshop lessons (`aula-02|03|04|05`), including aula-02 owned by `translate-curso-wave-3`, aula-03 owned by `translate-curso-wave-2`, and aula-04 owned by `translate-curso-wave-1`.
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
- `openspec/changes/translate-curso-wave-2/` (open PR #100) — prior WCu propose pattern
- `openspec/changes/translate-curso-wave-3/` (open PR #101) — prior WCu propose pattern (whole-file lesson slice)
- AS-IS: `doc/curso/aula-01-workshop-ia-5-2026.md`
- `scripts/verify-i18n-wave.sh`
- Graphify / GitNexus — SKIP / docs-only (markdown course lesson; no code symbols)
- GitHub Issues — no open issue required (**Issue:** —)

## Decisions

### D1: Scope = aula-01 workshop lesson alone (curso wave-4)

| Option | Verdict |
|--------|---------|
| A — Guide W3 mid-file section | Rejected — G-PT scans whole `--files` paths |
| B — Hub `doc/curso/aula-01-workshop-ia-5-2026.md` alone (~212) | **Chosen** — 1 file / ~212 LOC; residual PT; whole-file G-PT; disjoint from owned set (aula-02/03/04 owned by waves 3/2/1); memory queue preferred WCu next |
| C — Bundle aula-01 + `scripts/AGENTS.md` | Deferred — keep WCu waves single dense lesson; scripts can follow in a tiny polish wave |
| D — aula-05 alone (~503) | Rejected — exceeds ≤350–400 LOC; needs split + G-PT strategy |
| E — Spec residual PT (`sdd-install-kit` etc.) | Deferred — WCu queue continues; specs remain alternate later slices |
| F — Kit `sdd-kit/templates/doc/design/003` | Deferred — checksum-aware; prefer after hub design apply+archive |

**Rationale:** Next WCu entry after aula-02 propose should stay budget-safe and path-disjoint; aula-01 is the next densest remaining lesson under budget with clear residual PT.

### D2: In-place substitution — translate transcript body to EN

**Chosen:** Edit the hub path in place. Translate Resumo / Tópicos / category labels / spoken-reference blurbs / how-to-use **and** the `## Transcrição` body into English (faithful rendering of the talk). Forbidden: `*.en.md` / `*-pt.md` siblings; leaving raw PT transcript prose.

**Rationale:** `sdd-docs-language` dual-file prohibition; G-PT deny-list scans the entire `--files` path — a PT transcript would fail the wave DoD. Glossary allowlist for “quoted historical Portuguese” does **not** exempt unquoted transcript sections from G-PT. Heading may become `## Transcript`.

### D3: Preserve metadata, links, and talk facts

**Chosen:** Keep URL, Seção/Aula/Transcript ID fields (labels → English: Section/Lesson/Transcript ID), duration, numbered link table URLs, relative link to `aula-01-shared-files.md`, and factual claims (DORA ROI / adoption friction metrics, iceberg user-dev vs agent-builder, vibe coding vs AI-assisted development, probabilistic LLM + agent + harness, AGENTS.md / on-demand loading / context rot, MCP for Linear/Confluence, RPI + Cursor plan mode, Anthropic Skills vs rules lazy loading, Technical Design Doc → phased tasks, generic sub-agents / context-window management, Q&A on legacy codebases / EN vs PT prompts / MCP security / CLAUDE.md vs AGENTS.md). Translate category column labels (e.g. Arquivo de Apresentação → Presentation file; Pesquisas e Referências Citadas → Research and cited references; Livros → Books; Skills e Agentes → Skills and Agents; MCP e Ferramentas → MCP and tools; Contexto e Padrões de Arquitetura → Context and architecture patterns; Vídeos de Referência → Reference videos; Excalidraw (Quadro Visual da Aula) → Excalidraw (live visual board); Canais da Tech Leads Club → Tech Leads Club channels). Speaker line: keep **Waldemar Neto (Valdemar)**.

**Rationale:** Agents and humans must still navigate the same resources and IDs after language substitution.

### D4: Spec delta = lasting EN requirement for this slice

**Chosen:** ADDED requirement under `sdd-docs-language` that this course lesson file MUST be English after substitution. Do not invent a new `sdd-curso` capability in this language wave.

**Rationale:** Same pattern as prior translate-* ADDED slice requirements (including curso-wave-1..3).

## Risks / Trade-offs

| Risk | Mitigation |
|------|------------|
| Semantic drift of adoption / Context Engineering / RPI facts | Tasks require fact parity (DORA/METR refs, tool names, RPI order); freeze proper nouns |
| G-PT false positives on names/URLs/emoji | Freeze/allowlist; keep emoji markers if present |
| Broken relative link to shared-files | G-LINK; keep `./aula-01-shared-files.md` path string |
| Collision with curso-wave-1/2/3 apply | Own only aula-01; document aula-02/03/04 as non-goal / owned by waves 3/2/1 |
| Parallel propose factory races | Owned-set includes open PR path lists; this path absent from #78/#84/#93–#101 |

## Migration plan

1. Human approves this propose (R7) — DRAFT PR.
2. Separate `/opsx:apply translate-curso-wave-4` session after propose merge (or when artifacts are on apply base).
3. Apply substitutes the single course file in place; run wave gates.
4. Archive later (separate session): promote ADDED requirement into `openspec/specs/sdd-docs-language/spec.md`.
5. Follow-up WCu: split aula-05 (~503); optional `scripts/AGENTS.md` + shared-files polish; alternate later: residual specs / kit design templates.

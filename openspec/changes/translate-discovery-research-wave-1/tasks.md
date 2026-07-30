# Tasks — translate-discovery-research-wave-1

> Apply after human approval (R7). **In-place PT→EN only** on `openspec/changes/add-sdd-discovery-positioning/research.md` lines **1–261**. **Issue:** —

## 1. Prep (glossary + freeze)

- [ ] 1.1 Confirm glossary covers terms needed for this wave (`evaluation`, discovery, wave, glossary, canonical guide, install kit, fail-closed); append rows to `doc/i18n/GLOSSARY.md` only if a new SDD term is introduced (same PR)
  - **Pattern:** `doc/i18n/GLOSSARY.md`
  - **Invariants:** `sdd-docs-language` — Glossary and wave inventory exist
  - **Gate:** `test -s doc/i18n/GLOSSARY.md && grep -qE 'evaluation|discovery|wave|glossary|canonical guide|install kit|fail-closed' doc/i18n/GLOSSARY.md`
  - **Forbidden:** invent synonym variants for glossary terms; dual-file `*.en.md` / `*-pt.md`; editing `openspec/changes/archive/`

## 2. Substitute discovery research slice (in-place)

- [ ] 2.1 Rewrite `openspec/changes/add-sdd-discovery-positioning/research.md` lines **1–261** only (§1–§10: AS-IS diagnosis, positioning, SEO terms, semantic network, competition, dual bias, recommended README structure, risks, pre-apply decisions, references) Portuguese prose → glossary-canonical English; keep decision ids (P0–P10 / D1–D11 where cited), change-id links, freeze-list paths, URLs, and brand/tool names intact; map §9 decision table labels without changing non-goals vs deferrals
  - **Pattern:** `openspec/changes/add-sdd-discovery-positioning/research.md`
  - **Invariants:** `sdd-docs-language` — Discovery research wave-1 slice is English; Freeze list of non-translatable tokens
  - **Gate:** `test -f openspec/changes/add-sdd-discovery-positioning/research.md && ! test -f openspec/changes/add-sdd-discovery-positioning/research.en.md && ! test -f openspec/changes/add-sdd-discovery-positioning/research-pt.md && grep -qF 'add-sdd-discovery-positioning' openspec/changes/add-sdd-discovery-positioning/research.md && grep -qE '^## 10\.|^## 11\.' openspec/changes/add-sdd-discovery-positioning/research.md && ! grep -qiE 'Diagnóstico AS-IS|Posicionamento proposto|Termos-chave|Rede semântica|Concorrência|Viés duplo|Estrutura recomendada|Decisões a confirmar|ficheiro|ficheiros|canónico|canónica|inventário|glossário|secção|secções|Objectivo' openspec/changes/add-sdd-discovery-positioning/research.md`
  - **Forbidden:** edits outside lines 1–261; dual-file siblings; changing §9 non-goals/deferrals; rewriting change-ids; drive-by edits to §11–§12 in the same apply session

## 3. Wave gates

- [ ] 3.1 Run per-wave i18n verification on the exact research file path
  - **Pattern:** `scripts/verify-i18n-wave.sh`
  - **Invariants:** `sdd-docs-language` — Per-wave and global verification script; Discovery research wave-1 slice is English
  - **Gate:** `bash scripts/verify-i18n-wave.sh --files openspec/changes/add-sdd-discovery-positioning/research.md`
  - **Forbidden:** marking tasks done if G-PT/G-INV/G-LINK/G-OPENSPEC fail; running `--dod` as a required gate for this wave

- [ ] 3.2 Validate OpenSpec change + task Pattern paths
  - **Pattern:** `scripts/verify-task-patterns.sh`
  - **Gate:** `bash scripts/verify-task-patterns.sh && OPENSPEC_TELEMETRY=0 npx --yes @fission-ai/openspec@1.3.1 validate translate-discovery-research-wave-1 --strict`

## 4. Post-register (best-effort)

- [ ] 4.1 `graphify update .` if available (docs touched); otherwise SKIP per infra
  - **Pattern:** `.cursor/rules/graphify.mdc`
  - **Gate:** `test -f graphify-out/GRAPH_REPORT.md || echo 'SKIP (graphify unavailable)'`
  - **Note:** SKIP if graphify CLI unavailable

# Tasks — translate-discovery-research-wave-2

> Apply after human approval (R7). **In-place PT→EN only** on `openspec/changes/add-sdd-discovery-positioning/research.md` lines **262–404**. **Issue:** —

## 1. Prep (glossary + freeze)

- [x] 1.1 Confirm glossary covers terms needed for this wave (`evaluation`, discovery, wave, glossary, canonical guide, install kit, fail-closed, session / Session Handoff); append rows to `doc/i18n/GLOSSARY.md` only if a new SDD term is introduced (same PR)
  - **Pattern:** `doc/i18n/GLOSSARY.md`
  - **Invariants:** `sdd-docs-language` — Glossary and wave inventory exist
  - **Gate:** `test -s doc/i18n/GLOSSARY.md && grep -qE 'evaluation|discovery|wave|glossary|canonical guide|install kit|fail-closed|session|Session Handoff' doc/i18n/GLOSSARY.md`
  - **Forbidden:** invent synonym variants for glossary terms; dual-file `*.en.md` / `*-pt.md`; editing `openspec/changes/archive/`

## 2. Substitute discovery research slice (in-place)

- [x] 2.1 Rewrite `openspec/changes/add-sdd-discovery-positioning/research.md` lines **262–404** only (§11–§12: dissemination roadmap + i18n sequence, suggested OpenSpec changes table, rationale, target language policy, apply-① non-goals, SDD Metrics G4 README hook, honest vs misleading claims, permitted README copy) Portuguese prose → glossary-canonical English; keep step ids (①–⑥), change-id links, freeze-list paths, URLs, brand/tool names, and quoted EN copy blocks in §12.4 intact; map §11 sequence and §12.5 apply-① decision without changing step order or honest-metrics semantics
  - **Pattern:** `openspec/changes/add-sdd-discovery-positioning/research.md`
  - **Invariants:** `sdd-docs-language` — Discovery research wave-2 slice is English; Freeze list of non-translatable tokens
  - **Gate:** `test -f openspec/changes/add-sdd-discovery-positioning/research.md && ! test -f openspec/changes/add-sdd-discovery-positioning/research.en.md && ! test -f openspec/changes/add-sdd-discovery-positioning/research-pt.md && grep -qF 'add-sdd-discovery-positioning' openspec/changes/add-sdd-discovery-positioning/research.md && grep -qE '^## 11\.|^## 12\.' openspec/changes/add-sdd-discovery-positioning/research.md && ! grep -qiE 'Roadmap de divulgação|Sequência canónica|Changes OpenSpec sugeridos|Razões \(porquê|Política linguística|O que este apply|gancho de README|O que a ferramenta é|O que \*\*não\*\* é|ganho prático|Como divulgar|Compatibilidade e decisão|Evolução futura|ficheiro|canónico|inventário|glossário|secção|Objectivo|sob demanda' openspec/changes/add-sdd-discovery-positioning/research.md`
  - **Forbidden:** edits outside lines 262–404; dual-file siblings; changing §11 step order or §12 honest-metrics claims; rewriting change-ids; drive-by edits to lines 1–261 in the same apply session

## 3. Wave gates

- [x] 3.1 Run per-wave i18n verification on the exact research file path
  - **Pattern:** `scripts/verify-i18n-wave.sh`
  - **Invariants:** `sdd-docs-language` — Per-wave and global verification script; Discovery research wave-2 slice is English
  - **Gate:** `bash scripts/verify-i18n-wave.sh --files openspec/changes/add-sdd-discovery-positioning/research.md`
  - **Forbidden:** marking tasks done if G-PT/G-INV/G-LINK/G-OPENSPEC fail; running `--dod` as a required gate for this wave

- [x] 3.2 Validate OpenSpec change + task Pattern paths
  - **Pattern:** `scripts/verify-task-patterns.sh`
  - **Gate:** `bash scripts/verify-task-patterns.sh && OPENSPEC_TELEMETRY=0 npx --yes @fission-ai/openspec@1.3.1 validate translate-discovery-research-wave-2 --strict`

## 4. Post-register (best-effort)

- [x] 4.1 `graphify update .` if available (docs touched); otherwise SKIP per infra
  - **Pattern:** `.cursor/rules/graphify.mdc`
  - **Gate:** `test -f graphify-out/GRAPH_REPORT.md || echo 'SKIP (graphify unavailable)'`
  - **Note:** SKIP if graphify CLI unavailable

# Tasks — translate-explore-oss-wave-1

> Apply after human approval (R7). **In-place PT→EN only** on `openspec/changes/explore-oss-coverage-gaps/research.md`. **Issue:** —

## 1. Prep (glossary + freeze)

- [x] 1.1 Confirm glossary covers terms needed for this wave (`evaluation`, Adopted/Deferred, manual fix, wave, Session Handoff); append rows to `doc/i18n/GLOSSARY.md` only if a new SDD term is introduced (same PR)
  - **Pattern:** `doc/i18n/GLOSSARY.md`
  - **Invariants:** `sdd-docs-language` — Glossary and wave inventory exist
  - **Gate:** `test -s doc/i18n/GLOSSARY.md && grep -qE 'evaluation|manual fix|Deferred|Session Handoff|wave|glossary' doc/i18n/GLOSSARY.md`
  - **Forbidden:** invent synonym variants for glossary terms; dual-file `*.en.md` / `*-pt.md`; editing `openspec/changes/archive/`

## 2. Substitute explore-oss research (in-place)

- [x] 2.1 Rewrite `openspec/changes/explore-oss-coverage-gaps/research.md` Portuguese prose (title, objective, executive decision matrix, evaluation scale, per-gap analysis/recommendation sections) → glossary-canonical English; keep gap ids G1–G8, change-id links, package pins, URLs, and tool/brand names intact; map decision vocabulary (add to kit / manual fix / do not add / hybrid / do not adopt now) without changing recommendation outcomes
  - **Pattern:** `openspec/changes/explore-oss-coverage-gaps/research.md`
  - **Invariants:** `sdd-docs-language` — Explore-oss research wave-1 surface is English; Freeze list of non-translatable tokens
  - **Gate:** `test -f openspec/changes/explore-oss-coverage-gaps/research.md && ! test -f openspec/changes/explore-oss-coverage-gaps/research.en.md && ! test -f openspec/changes/explore-oss-coverage-gaps/research-pt.md && grep -qF 'add-probity-tdd-module' openspec/changes/explore-oss-coverage-gaps/research.md && grep -qiE 'Probity|@nizos/probity' openspec/changes/explore-oss-coverage-gaps/research.md && grep -qiE 'G1|G2|G6' openspec/changes/explore-oss-coverage-gaps/research.md && ! grep -qiE 'Objectivo|Resumo executivo|Escala de avaliação|não adoptar|não adicionar|Ferramenta candidata|Decisão recomendada|Correcção manual' openspec/changes/explore-oss-coverage-gaps/research.md`
  - **Forbidden:** dual-file siblings; changing which gaps are add-to-kit vs do-not-add; rewriting change-ids or pins; drive-by edits to sibling explore research files

## 3. Wave gates

- [x] 3.1 Run per-wave i18n verification on the exact research file path
  - **Pattern:** `scripts/verify-i18n-wave.sh`
  - **Invariants:** `sdd-docs-language` — Per-wave and global verification script; Explore-oss research wave-1 surface is English
  - **Gate:** `bash scripts/verify-i18n-wave.sh --files openspec/changes/explore-oss-coverage-gaps/research.md`
  - **Forbidden:** marking tasks done if G-PT/G-INV/G-LINK/G-OPENSPEC fail; running `--dod` as a required gate for this wave

- [x] 3.2 Validate OpenSpec change + task Pattern paths
  - **Pattern:** `scripts/verify-task-patterns.sh`
  - **Gate:** `bash scripts/verify-task-patterns.sh && OPENSPEC_TELEMETRY=0 npx --yes @fission-ai/openspec@1.3.1 validate translate-explore-oss-wave-1 --strict`

## 4. Post-register (best-effort)

- [x] 4.1 `graphify update .` if available (docs touched); otherwise SKIP per infra
  - **Pattern:** `.cursor/rules/graphify.mdc`
  - **Gate:** `test -f graphify-out/GRAPH_REPORT.md || echo 'SKIP (graphify unavailable)'`
  - **Note:** SKIP if graphify CLI unavailable

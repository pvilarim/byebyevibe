# Tasks — translate-explore-public-release-wave-1

> Apply after human approval (R7). **In-place PT→EN only** on `openspec/changes/explore-public-release-surface/research.md`. **Issue:** —

## 1. Prep (glossary + freeze)

- [x] 1.1 Confirm glossary covers terms needed for this wave (`evaluation`, Adopted/Deferred/Discarded, wave, glossary, Session Handoff, fail-closed); append rows to `doc/i18n/GLOSSARY.md` only if a new SDD term is introduced (same PR)
  - **Pattern:** `doc/i18n/GLOSSARY.md`
  - **Invariants:** `sdd-docs-language` — Glossary and wave inventory exist
  - **Gate:** `test -s doc/i18n/GLOSSARY.md && grep -qE 'evaluation|Deferred|Session Handoff|wave|glossary|fail-closed' doc/i18n/GLOSSARY.md`
  - **Forbidden:** invent synonym variants for glossary terms; dual-file `*.en.md` / `*-pt.md`; editing `openspec/changes/archive/`

## 2. Substitute explore-public-release research (in-place)

- [x] 2.1 Rewrite `openspec/changes/explore-public-release-surface/research.md` Portuguese prose (title, metadata table, executive summary, decision matrix F1–F7, i18n methodology / principles / freeze list / wave budgets / gates, backlog relations) → glossary-canonical English; keep decision ids F1–F7, change-id links, freeze-list path examples, URLs, and brand/tool names intact; map decision vocabulary (ready for propose / Adopted / Deferred / Discarded / do not implement) without changing recommendation outcomes
  - **Pattern:** `openspec/changes/explore-public-release-surface/research.md`
  - **Invariants:** `sdd-docs-language` — Explore-public-release research wave-1 surface is English; Freeze list of non-translatable tokens
  - **Gate:** `test -f openspec/changes/explore-public-release-surface/research.md && ! test -f openspec/changes/explore-public-release-surface/research.en.md && ! test -f openspec/changes/explore-public-release-surface/research-pt.md && grep -qF 'add-english-docs-policy' openspec/changes/explore-public-release-surface/research.md && grep -qiE 'F2|F7|F6' openspec/changes/explore-public-release-surface/research.md && ! grep -qiE 'Objectivo|Resumo executivo|Pronto para propose|Não fazer nesta fase|actualizado|ficheiro|ficheiros|canónico|canónica|inventário|glossário|substituição|secção|secções' openspec/changes/explore-public-release-surface/research.md`
  - **Forbidden:** dual-file siblings; changing which F1–F7 items are ready-for-propose vs Deferred vs Discarded; rewriting change-ids; drive-by edits to sibling explore research files (`explore-oss-coverage-gaps`, `explore-adversarial-sdd-review`)

## 3. Wave gates

- [x] 3.1 Run per-wave i18n verification on the exact research file path
  - **Pattern:** `scripts/verify-i18n-wave.sh`
  - **Invariants:** `sdd-docs-language` — Per-wave and global verification script; Explore-public-release research wave-1 surface is English
  - **Gate:** `bash scripts/verify-i18n-wave.sh --files openspec/changes/explore-public-release-surface/research.md`
  - **Forbidden:** marking tasks done if G-PT/G-INV/G-LINK/G-OPENSPEC fail; running `--dod` as a required gate for this wave

- [x] 3.2 Validate OpenSpec change + task Pattern paths
  - **Pattern:** `scripts/verify-task-patterns.sh`
  - **Gate:** `bash scripts/verify-task-patterns.sh && OPENSPEC_TELEMETRY=0 npx --yes @fission-ai/openspec@1.3.1 validate translate-explore-public-release-wave-1 --strict`

## 4. Post-register (best-effort)

- [x] 4.1 `graphify update .` if available (docs touched); otherwise SKIP per infra
  - **Pattern:** `.cursor/rules/graphify.mdc`
  - **Gate:** `test -f graphify-out/GRAPH_REPORT.md || echo 'SKIP (graphify unavailable)'`
  - **Note:** SKIP if graphify CLI unavailable

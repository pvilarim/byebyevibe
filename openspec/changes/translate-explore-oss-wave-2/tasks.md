# Tasks — translate-explore-oss-wave-2

> Apply after human approval (R7). **In-place PT→EN only** on `openspec/changes/explore-oss-coverage-gaps/metodologia-insercao.md`. **Issue:** —

## 1. Prep (glossary + freeze)

- [x] 1.1 Confirm glossary covers terms needed for this wave (`evaluation`, Adopted/Deferred, Session Handoff, wave, glossary); append rows to `doc/i18n/GLOSSARY.md` only if a new SDD term is introduced (same PR)
  - **Pattern:** `doc/i18n/GLOSSARY.md`
  - **Invariants:** `sdd-docs-language` — Glossary and wave inventory exist
  - **Gate:** `test -s doc/i18n/GLOSSARY.md && grep -qE 'evaluation|Deferred|Session Handoff|wave|glossary' doc/i18n/GLOSSARY.md`
  - **Forbidden:** invent synonym variants for glossary terms; dual-file `*.en.md` / `*-pt.md`; editing `openspec/changes/archive/`

## 2. Substitute explore-oss methodology (in-place)

- [x] 2.1 Rewrite `openspec/changes/explore-oss-coverage-gaps/metodologia-insercao.md` Portuguese prose (title, objective, principles, Phases 0–5, verification tables, pilot exception, 6-point registry, activation modes, A–E matrix, additional approaches, Session Handoff) → glossary-canonical English; keep phase numbers, verification ids (V1–V5, F1–F5), registry R1–R6 destinations, modes A–D, gap/tool links (G1–G8), change-id links, paths, and brand/tool names intact; do not change methodology outcomes
  - **Pattern:** `openspec/changes/explore-oss-coverage-gaps/metodologia-insercao.md`
  - **Invariants:** `sdd-docs-language` — Explore-oss methodology wave-2 surface is English; Freeze list of non-translatable tokens
  - **Gate:** `test -f openspec/changes/explore-oss-coverage-gaps/metodologia-insercao.md && ! test -f openspec/changes/explore-oss-coverage-gaps/metodologia-insercao.en.md && ! test -f openspec/changes/explore-oss-coverage-gaps/metodologia-insercao-pt.md && grep -qF 'openspec/infra.md' openspec/changes/explore-oss-coverage-gaps/metodologia-insercao.md && grep -qF 'sdd-kit/' openspec/changes/explore-oss-coverage-gaps/metodologia-insercao.md && grep -qiE 'Probity|G2' openspec/changes/explore-oss-coverage-gaps/metodologia-insercao.md && grep -qiE 'Phase 0|Phase 3|R1|R6' openspec/changes/explore-oss-coverage-gaps/metodologia-insercao.md && ! grep -qiE 'Objectivo|Princípios|Pré-verificação|utilizador|Registo|Excepção aprovada|Responde à|por defeito|ferramenta não entra' openspec/changes/explore-oss-coverage-gaps/metodologia-insercao.md`
  - **Forbidden:** dual-file siblings; changing phase order or R1–R6 destinations; rewriting change-ids or paths; drive-by edits to `research.md` or sibling explore packages

## 3. Wave gates

- [x] 3.1 Run per-wave i18n verification on the exact methodology file path
  - **Pattern:** `scripts/verify-i18n-wave.sh`
  - **Invariants:** `sdd-docs-language` — Per-wave and global verification script; Explore-oss methodology wave-2 surface is English
  - **Gate:** `bash scripts/verify-i18n-wave.sh --files openspec/changes/explore-oss-coverage-gaps/metodologia-insercao.md`
  - **Forbidden:** marking tasks done if G-PT/G-INV/G-LINK/G-OPENSPEC fail; running `--dod` as a required gate for this wave

- [x] 3.2 Validate OpenSpec change + task Pattern paths
  - **Pattern:** `scripts/verify-task-patterns.sh`
  - **Gate:** `bash scripts/verify-task-patterns.sh && OPENSPEC_TELEMETRY=0 npx --yes @fission-ai/openspec@1.3.1 validate translate-explore-oss-wave-2 --strict`

## 4. Post-register (best-effort)

- [x] 4.1 `graphify update .` if available (docs touched); otherwise SKIP per infra
  - **Pattern:** `.cursor/rules/graphify.mdc`
  - **Gate:** `test -f graphify-out/GRAPH_REPORT.md || echo 'SKIP (graphify unavailable)'`
  - **Note:** SKIP if graphify CLI unavailable

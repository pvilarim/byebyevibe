# Tasks — translate-avaliacoes-wave-1

> Apply after human approval (R7). **In-place PT→EN only** on the four listed `doc/avaliacoes/` files. **Issue:** —

## 1. Prep (glossary + freeze)

- [ ] 1.1 Confirm glossary covers terms needed for this wave (`evaluation`, Adopted/Discarded/Deferred, wave, Session Handoff); append rows to `doc/i18n/GLOSSARY.md` only if a new SDD term is introduced (same PR)
  - **Pattern:** `doc/i18n/GLOSSARY.md`
  - **Invariants:** `sdd-docs-language` — Glossary and wave inventory exist
  - **Gate:** `test -s doc/i18n/GLOSSARY.md && grep -qE 'evaluation|Discarded|Deferred|Session Handoff|wave|glossary' doc/i18n/GLOSSARY.md`
  - **Forbidden:** invent synonym variants for glossary terms; dual-file `*.en.md` / `*-pt.md`; renaming `doc/avaliacoes/`

## 2. Substitute evaluation surfaces (in-place)

- [ ] 2.1 Rewrite `doc/avaliacoes/README.md` Portuguese prose (title, purpose, how-to table, decision-state labels, index prose, relation notes) → glossary-canonical English; keep relative links, change-id references, and path `doc/avaliacoes/` intact; map Adoptado/Descartado/Adiado/Em avaliação → Adopted/Discarded/Deferred/Under evaluation without changing row outcomes
  - **Pattern:** `doc/avaliacoes/README.md`
  - **Invariants:** `sdd-docs-language` — Evaluation wave-1 surfaces are English; Freeze list of non-translatable tokens
  - **Gate:** `test -f doc/avaliacoes/README.md && ! test -f doc/avaliacoes/README.en.md && ! test -f doc/avaliacoes/README-pt.md && grep -qiE 'evaluation|Evaluations' doc/avaliacoes/README.md && grep -qF 'TEMPLATE.md' doc/avaliacoes/README.md && grep -qE 'Adopted|Discarded|Deferred' doc/avaliacoes/README.md && ! grep -qiE 'Avaliações de integração|Registo histórico|não propor|Em avaliação|Descartado|Adoptado|Adiado' doc/avaliacoes/README.md`
  - **Forbidden:** dual-file siblings; renaming the directory; changing which candidates are Discarded/Adopted; drive-by edits to other avaliacoes files

- [ ] 2.2 Rewrite `doc/avaliacoes/TEMPLATE.md` Portuguese headings/labels/placeholders → glossary-canonical English; keep table structure and workflow phase rows (Explore/Propose/Apply/Archive); translate placeholder cues (`<candidate name>`, etc.) to English
  - **Pattern:** `doc/avaliacoes/TEMPLATE.md`
  - **Invariants:** `sdd-docs-language` — Evaluation wave-1 surfaces are English
  - **Gate:** `test -f doc/avaliacoes/TEMPLATE.md && ! test -f doc/avaliacoes/TEMPLATE.en.md && ! test -f doc/avaliacoes/TEMPLATE-pt.md && grep -qiE '^# Evaluation' doc/avaliacoes/TEMPLATE.md && grep -qE 'Adopted|Discarded|Deferred' doc/avaliacoes/TEMPLATE.md && grep -qF 'Explore' doc/avaliacoes/TEMPLATE.md && ! grep -qiE '^# Avaliação|Avaliador|Em avaliação|Resumo executivo|reavaliação' doc/avaliacoes/TEMPLATE.md`
  - **Forbidden:** removing required TEMPLATE sections; dual-file siblings; changing Explore/Propose/Apply/Archive phase names into non-workflow synonyms

- [ ] 2.3 Rewrite `doc/avaliacoes/2026-03-26-headroom-context-compression.md` Portuguese prose → glossary-canonical English; keep Headroom **Discarded** outcome, URLs, tool names, and phase-risk table semantics; do not soften the discard decision
  - **Pattern:** `doc/avaliacoes/2026-03-26-headroom-context-compression.md`
  - **Invariants:** `sdd-docs-language` — Evaluation wave-1 surfaces are English
  - **Gate:** `test -f doc/avaliacoes/2026-03-26-headroom-context-compression.md && ! test -f doc/avaliacoes/2026-03-26-headroom-context-compression.en.md && grep -qiE 'Discarded' doc/avaliacoes/2026-03-26-headroom-context-compression.md && grep -qiE 'Headroom' doc/avaliacoes/2026-03-26-headroom-context-compression.md && grep -qF 'https://github.com/chopratejas/headroom' doc/avaliacoes/2026-03-26-headroom-context-compression.md && ! grep -qiE 'Descartado|não integrar|Avaliação:|reabrir avaliação|compressão de contexto' doc/avaliacoes/2026-03-26-headroom-context-compression.md`
  - **Forbidden:** changing Discarded → Adopted/Deferred; removing risk rationale; dual-file siblings

- [ ] 2.4 Rewrite `doc/avaliacoes/2026-07-25-oss-coverage-gaps-tooling.md` Portuguese prose → glossary-canonical English; keep per-row Adopted/Deferred/mixed outcomes, change-id links, and package pins; translate re-evaluation conditions without changing their substance
  - **Pattern:** `doc/avaliacoes/2026-07-25-oss-coverage-gaps-tooling.md`
  - **Invariants:** `sdd-docs-language` — Evaluation wave-1 surfaces are English
  - **Gate:** `test -f doc/avaliacoes/2026-07-25-oss-coverage-gaps-tooling.md && ! test -f doc/avaliacoes/2026-07-25-oss-coverage-gaps-tooling.en.md && grep -qF 'add-probity-tdd-module' doc/avaliacoes/2026-07-25-oss-coverage-gaps-tooling.md && grep -qF '@nizos/probity@1.10.0' doc/avaliacoes/2026-07-25-oss-coverage-gaps-tooling.md && grep -qiE 'Adopted|Deferred' doc/avaliacoes/2026-07-25-oss-coverage-gaps-tooling.md && ! grep -qiE 'Avaliação:|Ferramentas OSS|reavaliação|Adiado|Adoptado' doc/avaliacoes/2026-07-25-oss-coverage-gaps-tooling.md`
  - **Forbidden:** changing row decisions; rewriting change-ids or pins; dual-file siblings; editing deferred sibling evaluation files

## 3. Wave gates

- [ ] 3.1 Run per-wave i18n verification on the exact evaluation file list
  - **Pattern:** `scripts/verify-i18n-wave.sh`
  - **Invariants:** `sdd-docs-language` — Per-wave and global verification script; Evaluation wave-1 surfaces are English
  - **Gate:** `bash scripts/verify-i18n-wave.sh --files doc/avaliacoes/README.md,doc/avaliacoes/TEMPLATE.md,doc/avaliacoes/2026-03-26-headroom-context-compression.md,doc/avaliacoes/2026-07-25-oss-coverage-gaps-tooling.md`
  - **Forbidden:** marking tasks done if G-PT/G-INV/G-LINK/G-OPENSPEC fail; running `--dod` as a required gate for this wave

- [ ] 3.2 Validate OpenSpec change + task Pattern paths
  - **Pattern:** `scripts/verify-task-patterns.sh`
  - **Gate:** `bash scripts/verify-task-patterns.sh && OPENSPEC_TELEMETRY=0 npx --yes @fission-ai/openspec@1.3.1 validate translate-avaliacoes-wave-1 --strict`

## 4. Post-register (best-effort)

- [ ] 4.1 `graphify update .` if available (docs touched); otherwise SKIP per infra
  - **Pattern:** `.cursor/rules/graphify.mdc`
  - **Gate:** `test -f graphify-out/GRAPH_REPORT.md || echo 'SKIP (graphify unavailable)'`
  - **Note:** SKIP if graphify CLI unavailable

# Tasks — translate-avaliacoes-wave-2

> Apply after human approval (R7). **In-place PT→EN only** on the two listed `doc/avaliacoes/` files. **Issue:** —

## 1. Prep (glossary + freeze)

- [ ] 1.1 Confirm glossary covers terms needed for this wave (`evaluation`, Adopted/Discarded/Deferred, wave, Session Handoff); append rows to `doc/i18n/GLOSSARY.md` only if a new SDD term is introduced (same PR)
  - **Pattern:** `doc/i18n/GLOSSARY.md`
  - **Invariants:** `sdd-docs-language` — Glossary and wave inventory exist
  - **Gate:** `test -s doc/i18n/GLOSSARY.md && grep -qE 'evaluation|Discarded|Deferred|Session Handoff|wave|glossary' doc/i18n/GLOSSARY.md`
  - **Forbidden:** invent synonym variants for glossary terms; dual-file `*.en.md` / `*-pt.md`; renaming `doc/avaliacoes/`; editing wave-1 evaluation files

## 2. Substitute evaluation surfaces (in-place)

- [ ] 2.1 Rewrite `doc/avaliacoes/2026-07-26-sdd-discovery-positioning.md` Portuguese prose (title, executive summary, tables, decision backlog, re-evaluation conditions) → glossary-canonical English; keep relative links, change-ids, URLs, brand ByeByeVibe, and path `doc/avaliacoes/` intact; map Adoptado/Adiado/Não implementar/Em avaliação → Adopted/Deferred/Do not implement/Under evaluation without changing row outcomes; normalize `[AÇÃO MANUAL]` → `[MANUAL ACTION]`
  - **Pattern:** `doc/avaliacoes/2026-07-26-sdd-discovery-positioning.md`
  - **Invariants:** `sdd-docs-language` — Evaluation wave-2 surfaces are English; Freeze list of non-translatable tokens
  - **Gate:** `test -f doc/avaliacoes/2026-07-26-sdd-discovery-positioning.md && ! test -f doc/avaliacoes/2026-07-26-sdd-discovery-positioning.en.md && ! test -f doc/avaliacoes/2026-07-26-sdd-discovery-positioning-pt.md && grep -qiE 'ByeByeVibe|discovery' doc/avaliacoes/2026-07-26-sdd-discovery-positioning.md && grep -qiE 'Adopted' doc/avaliacoes/2026-07-26-sdd-discovery-positioning.md && grep -qF 'add-sdd-discovery-positioning' doc/avaliacoes/2026-07-26-sdd-discovery-positioning.md && ! grep -qiE '^# Avaliação|Adoptado|Adiado|Não implementar|reavaliação|AÇÃO MANUAL|não alterar Settings' doc/avaliacoes/2026-07-26-sdd-discovery-positioning.md`
  - **Forbidden:** dual-file siblings; renaming the directory; changing which P-rows are Adopted/Deferred/Do-not-implement; drive-by edits to wave-1 files or `doc/design/`

- [ ] 2.2 Rewrite `doc/avaliacoes/2026-06-27-sdd-ui-development-module.md` Portuguese prose → glossary-canonical English; keep UI-module **Adopted** outcome, pointers to §2.11 / design docs, Impeccable `--yes` confirmation semantics, and phase-risk table meaning; do not soften Adopted into Deferred
  - **Pattern:** `doc/avaliacoes/2026-06-27-sdd-ui-development-module.md`
  - **Invariants:** `sdd-docs-language` — Evaluation wave-2 surfaces are English
  - **Gate:** `test -f doc/avaliacoes/2026-06-27-sdd-ui-development-module.md && ! test -f doc/avaliacoes/2026-06-27-sdd-ui-development-module.en.md && ! test -f doc/avaliacoes/2026-06-27-sdd-ui-development-module-pt.md && grep -qiE 'Adopted' doc/avaliacoes/2026-06-27-sdd-ui-development-module.md && grep -qiE 'Impeccable|Open Design|Pencil' doc/avaliacoes/2026-06-27-sdd-ui-development-module.md && grep -qF 'doc/design/002-ui-module-install.md' doc/avaliacoes/2026-06-27-sdd-ui-development-module.md && ! grep -qiE '^# Avaliação|Adoptado|reavaliação|não sabiam|guia canónico' doc/avaliacoes/2026-06-27-sdd-ui-development-module.md`
  - **Forbidden:** changing Adopted → Deferred/Discarded; removing risk rationale; dual-file siblings; editing design install docs in this wave

## 3. Wave gates

- [ ] 3.1 Run per-wave i18n verification on the exact evaluation file list
  - **Pattern:** `scripts/verify-i18n-wave.sh`
  - **Invariants:** `sdd-docs-language` — Per-wave and global verification script; Evaluation wave-2 surfaces are English
  - **Gate:** `bash scripts/verify-i18n-wave.sh --files doc/avaliacoes/2026-07-26-sdd-discovery-positioning.md,doc/avaliacoes/2026-06-27-sdd-ui-development-module.md`
  - **Forbidden:** marking tasks done if G-PT/G-INV/G-LINK/G-OPENSPEC fail; running `--dod` as a required gate for this wave

- [ ] 3.2 Validate OpenSpec change + task Pattern paths
  - **Pattern:** `scripts/verify-task-patterns.sh`
  - **Gate:** `bash scripts/verify-task-patterns.sh && OPENSPEC_TELEMETRY=0 npx --yes @fission-ai/openspec@1.3.1 validate translate-avaliacoes-wave-2 --strict`

## 4. Post-register (best-effort)

- [ ] 4.1 `graphify update .` if available (docs touched); otherwise SKIP per infra
  - **Pattern:** `.cursor/rules/graphify.mdc`
  - **Gate:** `test -f graphify-out/GRAPH_REPORT.md || echo 'SKIP (graphify unavailable)'`
  - **Note:** SKIP if graphify CLI unavailable

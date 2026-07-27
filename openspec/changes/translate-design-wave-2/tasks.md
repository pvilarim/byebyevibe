# Tasks — translate-design-wave-2

> Apply after human approval (R7). **In-place PT→EN only** on the listed `doc/design/` file. **Issue:** —

## 1. Prep (glossary + freeze)

- [ ] 1.1 Confirm glossary covers terms needed for this wave (`install kit`, gate, Session Handoff, wave, evaluation, canonical, design system); append rows to `doc/i18n/GLOSSARY.md` only if a new SDD term is introduced (same PR)
  - **Pattern:** `doc/i18n/GLOSSARY.md`
  - **Invariants:** `sdd-docs-language` — Glossary and wave inventory exist
  - **Gate:** `test -s doc/i18n/GLOSSARY.md && grep -qE 'install kit|Session Handoff|wave|glossary|evaluation|canonical' doc/i18n/GLOSSARY.md`
  - **Forbidden:** invent synonym variants for glossary terms; dual-file `*.en.md` / `*-pt.md`; editing `sdd-kit/templates/doc/design/`

## 2. Substitute design surface (in-place)

- [ ] 2.1 Rewrite `doc/design/000-impeccable-design-system-guia.md` Portuguese prose (title, import/adaptation blurb, what Impeccable is/is-not, shadcn fit, advantages, monorepo scope tables, adoption checklist including prerequisites/install/CI, limitations) → glossary-canonical English; keep `DOCS_SPECS`, relative links to `001`/`002`/`003`/`doc/sistema-sdd-pedro.md`, brand/tool names, fenced shell, and reference/adaptation + applicability semantics intact (status marker may become `[REFERENCE — NEEDS ADAPTATION]`; `[se aplicável]` → `[if applicable]`)
  - **Pattern:** `doc/design/000-impeccable-design-system-guia.md`
  - **Invariants:** `sdd-docs-language` — Design wave-2 Impeccable reference guide is English; Freeze list of non-translatable tokens
  - **Gate:** `test -f doc/design/000-impeccable-design-system-guia.md && ! test -f doc/design/000-impeccable-design-system-guia.en.md && ! test -f doc/design/000-impeccable-design-system-guia-pt.md && grep -qF 'DOCS_SPECS' doc/design/000-impeccable-design-system-guia.md && grep -qF '002-ui-module-install.md' doc/design/000-impeccable-design-system-guia.md && grep -qF '003-ui-stack-adapters.md' doc/design/000-impeccable-design-system-guia.md && grep -qiE 'Prerequisite|Prerequisites|REFERENCE|NEEDS ADAPTATION|if applicable' doc/design/000-impeccable-design-system-guia.md && ! grep -qiE 'Secções marcadas|guia de referência|O que é o Impeccable|Pré-requisitos|Fluxo de trabalho recomendado|Vocabulário compartilhado|não contém app Next' doc/design/000-impeccable-design-system-guia.md`
  - **Forbidden:** dual-file siblings; installing Impeccable on this DOCS_SPECS hub via doc text; drive-by edits to `001`/`002`/`003`/`004` or kit design templates; changing shadcn-default / adoption recommendations beyond language

## 3. Wave gates

- [ ] 3.1 Run per-wave i18n verification on the exact design file
  - **Pattern:** `scripts/verify-i18n-wave.sh`
  - **Invariants:** `sdd-docs-language` — Per-wave and global verification script; Design wave-2 Impeccable reference guide is English
  - **Gate:** `bash scripts/verify-i18n-wave.sh --files doc/design/000-impeccable-design-system-guia.md`
  - **Forbidden:** marking tasks done if G-PT/G-INV/G-LINK/G-OPENSPEC fail; running `--dod` as a required gate for this wave; touching `sdd-kit/templates/` in this apply

- [ ] 3.2 Validate OpenSpec change + task Pattern paths
  - **Pattern:** `scripts/verify-task-patterns.sh`
  - **Gate:** `bash scripts/verify-task-patterns.sh && OPENSPEC_TELEMETRY=0 npx --yes @fission-ai/openspec@1.3.1 validate translate-design-wave-2 --strict`

## 4. Post-register (best-effort)

- [ ] 4.1 `graphify update .` if available (docs touched); otherwise SKIP per infra
  - **Pattern:** `.cursor/rules/graphify.mdc`
  - **Gate:** `test -f graphify-out/GRAPH_REPORT.md || echo 'SKIP (graphify unavailable)'`
  - **Note:** SKIP if graphify CLI unavailable

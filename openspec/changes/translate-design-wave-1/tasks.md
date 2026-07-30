# Tasks — translate-design-wave-1

> Apply after human approval (R7). **In-place PT→EN only** on the three listed `doc/design/` files. **Issue:** —

## 1. Prep (glossary + freeze)

- [x] 1.1 Confirm glossary covers terms needed for this wave (`install kit`, gate, Session Handoff, wave, evaluation, canonical); append rows to `doc/i18n/GLOSSARY.md` only if a new SDD term is introduced (same PR)
  - **Pattern:** `doc/i18n/GLOSSARY.md`
  - **Invariants:** `sdd-docs-language` — Glossary and wave inventory exist
  - **Gate:** `test -s doc/i18n/GLOSSARY.md && grep -qE 'install kit|Session Handoff|wave|glossary|evaluation|canonical' doc/i18n/GLOSSARY.md`
  - **Forbidden:** invent synonym variants for glossary terms; dual-file `*.en.md` / `*-pt.md`; editing `sdd-kit/templates/doc/design/`

## 2. Substitute design surfaces (in-place)

- [x] 2.1 Rewrite `doc/design/002-ui-module-install.md` Portuguese prose (title, scenario blurb, prerequisites, detect/apply steps, “does not” list, design-file disambiguation table, golden rule, checklist) → glossary-canonical English; keep `C1-UI`, `install-ui-module.sh`, `--detect`/`--apply`/`--yes`, relative links, and procedure semantics intact
  - **Pattern:** `doc/design/002-ui-module-install.md`
  - **Invariants:** `sdd-docs-language` — Design wave-1 module-install surfaces are English; Freeze list of non-translatable tokens
  - **Gate:** `test -f doc/design/002-ui-module-install.md && ! test -f doc/design/002-ui-module-install.en.md && ! test -f doc/design/002-ui-module-install-pt.md && grep -qF 'install-ui-module.sh' doc/design/002-ui-module-install.md && grep -qF 'C1-UI' doc/design/002-ui-module-install.md && grep -qiE 'Prerequisite|Prerequisites' doc/design/002-ui-module-install.md && ! grep -qiE 'Pré-requisitos|Disambiguação de ficheiros|Regra de ouro|Guia canónico|Não substitui|Actualiza .openspec/infra.md' doc/design/002-ui-module-install.md`
  - **Forbidden:** dual-file siblings; changing what `--apply` installs or skips; drive-by edits to `000`/`001` or kit design templates

- [x] 2.2 Rewrite `doc/design/003-ui-stack-adapters.md` Portuguese prose (title, opt-out guidance, adapter paths, checklist) → glossary-canonical English; keep default-shadcn stance, relative links to `001-pipeline-*`, and “do not run `npx shadcn@latest init`” semantics for opt-out paths
  - **Pattern:** `doc/design/003-ui-stack-adapters.md`
  - **Invariants:** `sdd-docs-language` — Design wave-1 module-install surfaces are English
  - **Gate:** `test -f doc/design/003-ui-stack-adapters.md && ! test -f doc/design/003-ui-stack-adapters.en.md && ! test -f doc/design/003-ui-stack-adapters-pt.md && grep -qF '001-pipeline-open-design-shadcn-impeccable.md' doc/design/003-ui-stack-adapters.md && grep -qF 'npx shadcn@latest init' doc/design/003-ui-stack-adapters.md && ! grep -qiE 'Caminhos B e C|projectos Next|Actualizar .openspec|Não correr|ficheiros React' doc/design/003-ui-stack-adapters.md`
  - **Forbidden:** flipping default stack away from shadcn; dual-file siblings; rewriting pipeline doc `001`

- [x] 2.3 Rewrite `doc/design/004-probity-module-install.md` Portuguese prose (title, scenario blurb, profile matrix, prerequisites, detect/apply steps, “does not” list, pilot section) → glossary-canonical English; keep `G2`, `install-probity-module.sh`, `@nizos/probity@1.10.0` pin if present, R6/`enforceTdd`, and “do not re-propose TDD Guard” outcome
  - **Pattern:** `doc/design/004-probity-module-install.md`
  - **Invariants:** `sdd-docs-language` — Design wave-1 module-install surfaces are English
  - **Gate:** `test -f doc/design/004-probity-module-install.md && ! test -f doc/design/004-probity-module-install.en.md && ! test -f doc/design/004-probity-module-install-pt.md && grep -qF 'install-probity-module.sh' doc/design/004-probity-module-install.md && grep -qF 'G2' doc/design/004-probity-module-install.md && grep -qF 'enforceTdd' doc/design/004-probity-module-install.md && grep -qiE 'Prerequisite|Prerequisites|Pilot' doc/design/004-probity-module-install.md && ! grep -qiE 'Pré-requisitos|Não re-propor|não activar|Actualiza .openspec/infra.md|Piloto .obrigatório' doc/design/004-probity-module-install.md`
  - **Forbidden:** re-opening TDD Guard; changing Probity pin; dual-file siblings; enabling Probity on DOCS_SPECS hub via doc text

## 3. Wave gates

- [x] 3.1 Run per-wave i18n verification on the exact design file list
  - **Pattern:** `scripts/verify-i18n-wave.sh`
  - **Invariants:** `sdd-docs-language` — Per-wave and global verification script; Design wave-1 module-install surfaces are English
  - **Gate:** `bash scripts/verify-i18n-wave.sh --files doc/design/002-ui-module-install.md,doc/design/003-ui-stack-adapters.md,doc/design/004-probity-module-install.md`
  - **Forbidden:** marking tasks done if G-PT/G-INV/G-LINK/G-OPENSPEC fail; running `--dod` as a required gate for this wave; touching `sdd-kit/templates/` in this apply

- [x] 3.2 Validate OpenSpec change + task Pattern paths
  - **Pattern:** `scripts/verify-task-patterns.sh`
  - **Gate:** `bash scripts/verify-task-patterns.sh && OPENSPEC_TELEMETRY=0 npx --yes @fission-ai/openspec@1.3.1 validate translate-design-wave-1 --strict`

## 4. Post-register (best-effort)

- [x] 4.1 `graphify update .` if available (docs touched); otherwise SKIP per infra
  - **Pattern:** `.cursor/rules/graphify.mdc`
  - **Gate:** `test -f graphify-out/GRAPH_REPORT.md || echo 'SKIP (graphify unavailable)'`
  - **Note:** SKIP if graphify CLI unavailable

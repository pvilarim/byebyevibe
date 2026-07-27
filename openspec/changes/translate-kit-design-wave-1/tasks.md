# Tasks — translate-kit-design-wave-1

> Apply after human approval (R7). **In-place PT→EN only** on the three listed `sdd-kit/templates/doc/design/` files, then refresh MANIFEST checksums. **Issue:** —

## 1. Prep (glossary + freeze)

- [ ] 1.1 Confirm glossary covers terms needed for this wave (`install kit`, gate, Session Handoff, wave, evaluation, canonical); append rows to `doc/i18n/GLOSSARY.md` only if a new SDD term is introduced (same PR)
  - **Pattern:** `doc/i18n/GLOSSARY.md`
  - **Invariants:** `sdd-docs-language` — Glossary and wave inventory exist
  - **Gate:** `test -s doc/i18n/GLOSSARY.md && grep -qE 'install kit|Session Handoff|wave|glossary|evaluation|canonical' doc/i18n/GLOSSARY.md`
  - **Forbidden:** invent synonym variants for glossary terms; dual-file `*.en.md` / `*-pt.md`; editing hub `doc/design/`

## 2. Substitute kit design mirrors (in-place)

- [ ] 2.1 Rewrite `sdd-kit/templates/doc/design/002-ui-module-install.md` Portuguese prose (title, scenario blurb, prerequisites, detect/apply steps, “does not” list, design-file disambiguation table, golden rule, checklist) → glossary-canonical English; keep `C1-UI`, `install-ui-module.sh`, `--detect`/`--apply`/`--yes`, relative links, and procedure semantics intact
  - **Pattern:** `sdd-kit/templates/doc/design/002-ui-module-install.md`
  - **Invariants:** `sdd-docs-language` — Kit design wave-1 module-install mirrors are English; Freeze list of non-translatable tokens
  - **Gate:** `test -f sdd-kit/templates/doc/design/002-ui-module-install.md && ! test -f sdd-kit/templates/doc/design/002-ui-module-install.en.md && ! test -f sdd-kit/templates/doc/design/002-ui-module-install-pt.md && grep -qF 'install-ui-module.sh' sdd-kit/templates/doc/design/002-ui-module-install.md && grep -qF 'C1-UI' sdd-kit/templates/doc/design/002-ui-module-install.md && grep -qiE 'Prerequisite|Prerequisites' sdd-kit/templates/doc/design/002-ui-module-install.md && ! grep -qiE 'Pré-requisitos|Disambiguação de ficheiros|Regra de ouro|Guia canónico|Não substitui|Actualiza .openspec/infra.md' sdd-kit/templates/doc/design/002-ui-module-install.md`
  - **Forbidden:** dual-file siblings; changing what `--apply` installs or skips; drive-by edits to hub `doc/design/` or kit `000`/`001`

- [ ] 2.2 Rewrite `sdd-kit/templates/doc/design/003-ui-stack-adapters.md` Portuguese prose (title, opt-out guidance, adapter paths, checklist) → glossary-canonical English; keep default-shadcn stance, relative links to `001-pipeline-*`, and “do not run `npx shadcn@latest init`” semantics for opt-out paths
  - **Pattern:** `sdd-kit/templates/doc/design/003-ui-stack-adapters.md`
  - **Invariants:** `sdd-docs-language` — Kit design wave-1 module-install mirrors are English
  - **Gate:** `test -f sdd-kit/templates/doc/design/003-ui-stack-adapters.md && ! test -f sdd-kit/templates/doc/design/003-ui-stack-adapters.en.md && ! test -f sdd-kit/templates/doc/design/003-ui-stack-adapters-pt.md && grep -qF '001-pipeline-open-design-shadcn-impeccable.md' sdd-kit/templates/doc/design/003-ui-stack-adapters.md && grep -qF 'npx shadcn@latest init' sdd-kit/templates/doc/design/003-ui-stack-adapters.md && ! grep -qiE 'Caminhos B e C|projectos Next|Actualizar .openspec|Não correr|ficheiros React' sdd-kit/templates/doc/design/003-ui-stack-adapters.md`
  - **Forbidden:** flipping default stack away from shadcn; dual-file siblings; rewriting pipeline doc `001`

- [ ] 2.3 Rewrite `sdd-kit/templates/doc/design/004-probity-module-install.md` Portuguese prose (title, scenario blurb, profile matrix, prerequisites, detect/apply steps, “does not” list, pilot section) → glossary-canonical English; keep `G2`, `install-probity-module.sh`, `@nizos/probity@1.10.0` pin if present, R6/`enforceTdd`, and “do not re-propose TDD Guard” outcome
  - **Pattern:** `sdd-kit/templates/doc/design/004-probity-module-install.md`
  - **Invariants:** `sdd-docs-language` — Kit design wave-1 module-install mirrors are English
  - **Gate:** `test -f sdd-kit/templates/doc/design/004-probity-module-install.md && ! test -f sdd-kit/templates/doc/design/004-probity-module-install.en.md && ! test -f sdd-kit/templates/doc/design/004-probity-module-install-pt.md && grep -qF 'install-probity-module.sh' sdd-kit/templates/doc/design/004-probity-module-install.md && grep -qF 'G2' sdd-kit/templates/doc/design/004-probity-module-install.md && grep -qF 'enforceTdd' sdd-kit/templates/doc/design/004-probity-module-install.md && grep -qiE 'Prerequisite|Prerequisites|Pilot' sdd-kit/templates/doc/design/004-probity-module-install.md && ! grep -qiE 'Pré-requisitos|Não re-propor|não activar|Actualiza .openspec/infra.md|Piloto .obrigatório' sdd-kit/templates/doc/design/004-probity-module-install.md`
  - **Forbidden:** re-opening TDD Guard; changing Probity pin; dual-file siblings; enabling Probity on DOCS_SPECS hub via doc text

## 3. Kit checksums + wave gates

- [ ] 3.1 Regenerate MANIFEST checksums after template edits
  - **Pattern:** `sdd-kit/gen-manifest-checksums.sh`
  - **Invariants:** `sdd-docs-language` — Kit design wave-1 module-install mirrors are English
  - **Gate:** `bash sdd-kit/gen-manifest-checksums.sh && bash sdd-kit/verify.sh`
  - **Forbidden:** committing template edits without checksum refresh; evaluating MANIFEST `gate:` fields

- [ ] 3.2 Run per-wave i18n verification on the exact kit design template list
  - **Pattern:** `scripts/verify-i18n-wave.sh`
  - **Invariants:** `sdd-docs-language` — Per-wave and global verification script; Kit design wave-1 module-install mirrors are English
  - **Gate:** `bash scripts/verify-i18n-wave.sh --files sdd-kit/templates/doc/design/002-ui-module-install.md,sdd-kit/templates/doc/design/003-ui-stack-adapters.md,sdd-kit/templates/doc/design/004-probity-module-install.md`
  - **Forbidden:** marking tasks done if G-PT/G-INV/G-LINK/G-MANIFEST/G-OPENSPEC fail; running `--dod` as a required gate for this wave; editing hub `doc/design/` in this apply

- [ ] 3.3 Validate OpenSpec change + task Pattern paths
  - **Pattern:** `scripts/verify-task-patterns.sh`
  - **Gate:** `bash scripts/verify-task-patterns.sh && OPENSPEC_TELEMETRY=0 npx --yes @fission-ai/openspec@1.3.1 validate translate-kit-design-wave-1 --strict`

## 4. Post-register (best-effort)

- [ ] 4.1 `graphify update .` if available (docs touched); otherwise SKIP per infra
  - **Pattern:** `.cursor/rules/graphify.mdc`
  - **Gate:** `test -f graphify-out/GRAPH_REPORT.md || echo 'SKIP (graphify unavailable)'`
  - **Note:** SKIP if graphify CLI unavailable

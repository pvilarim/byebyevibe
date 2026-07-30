# Tasks — translate-kit-design-wave-1

> Apply after human approval (R7). **In-place PT→EN only** on the three listed `sdd-kit/templates/doc/design/` files + MANIFEST checksum regen. **Issue:** —

## 1. Prep (glossary + freeze + soft prerequisites)

- [x] 1.1 Confirm glossary covers terms needed for this wave (`install kit`, gate, Session Handoff, wave, evaluation, canonical); append rows to `doc/i18n/GLOSSARY.md` only if a new SDD term is introduced (same PR)
  - **Pattern:** `doc/i18n/GLOSSARY.md`
  - **Invariants:** `sdd-docs-language` — Glossary and wave inventory exist
  - **Gate:** `test -s doc/i18n/GLOSSARY.md && grep -qE 'install kit|Session Handoff|wave|glossary|evaluation|canonical' doc/i18n/GLOSSARY.md`
  - **Forbidden:** invent synonym variants for glossary terms; dual-file `*.en.md` / `*-pt.md`; editing hub `doc/design/` in this change

- [x] 1.2 Soft-check hub design-wave-1 apply status and avoid concurrent kit-template applies
  - **Pattern:** `openspec/changes/translate-design-wave-1/tasks.md`
  - **Invariants:** `sdd-docs-language` — Kit design wave-1 module-install surfaces are English
  - **Gate:** `test -f openspec/changes/translate-design-wave-1/proposal.md || test -d openspec/changes/archive/*translate-design-wave-1* 2>/dev/null; echo 'NOTE: prefer hub design-wave-1 apply-complete; serialize vs other sdd-kit/templates applies (e.g. W2c/W2d PR #78)'`
  - **Forbidden:** blocking propose (already done); starting apply while another kit-templates+MANIFEST apply is in-flight on the same base without coordination

## 2. Substitute kit design surfaces (in-place)

- [x] 2.1 Rewrite `sdd-kit/templates/doc/design/002-ui-module-install.md` Portuguese prose (title, scenario blurb, prerequisites, detect/apply steps, “does not” list, design-file disambiguation table, golden rule, checklist) → glossary-canonical English; prefer hub EN copy when available; keep `C1-UI`, `install-ui-module.sh`, `--detect`/`--apply`/`--yes`, relative links, and procedure semantics intact
  - **Pattern:** `sdd-kit/templates/doc/design/002-ui-module-install.md`
  - **Invariants:** `sdd-docs-language` — Kit design wave-1 module-install surfaces are English; Freeze list of non-translatable tokens
  - **Gate:** `test -f sdd-kit/templates/doc/design/002-ui-module-install.md && ! test -f sdd-kit/templates/doc/design/002-ui-module-install.en.md && ! test -f sdd-kit/templates/doc/design/002-ui-module-install-pt.md && grep -qF 'install-ui-module.sh' sdd-kit/templates/doc/design/002-ui-module-install.md && grep -qF 'C1-UI' sdd-kit/templates/doc/design/002-ui-module-install.md && grep -qiE 'Prerequisite|Prerequisites' sdd-kit/templates/doc/design/002-ui-module-install.md && ! grep -qiE 'Pré-requisitos|Disambiguação de ficheiros|Regra de ouro|Guia canónico|Não substitui|Actualiza .openspec/infra.md' sdd-kit/templates/doc/design/002-ui-module-install.md`
  - **Forbidden:** dual-file siblings; changing what `--apply` installs or skips; drive-by edits to kit `000`/`001` or hub `doc/design/`

- [x] 2.2 Rewrite `sdd-kit/templates/doc/design/003-ui-stack-adapters.md` Portuguese prose (title, opt-out guidance, adapter paths, checklist) → glossary-canonical English; prefer hub EN copy when available; keep default-shadcn stance, relative links to `001-pipeline-*`, and “do not run `npx shadcn@latest init`” semantics for opt-out paths
  - **Pattern:** `sdd-kit/templates/doc/design/003-ui-stack-adapters.md`
  - **Invariants:** `sdd-docs-language` — Kit design wave-1 module-install surfaces are English
  - **Gate:** `test -f sdd-kit/templates/doc/design/003-ui-stack-adapters.md && ! test -f sdd-kit/templates/doc/design/003-ui-stack-adapters.en.md && ! test -f sdd-kit/templates/doc/design/003-ui-stack-adapters-pt.md && grep -qF '001-pipeline-open-design-shadcn-impeccable.md' sdd-kit/templates/doc/design/003-ui-stack-adapters.md && grep -qF 'npx shadcn@latest init' sdd-kit/templates/doc/design/003-ui-stack-adapters.md && ! grep -qiE 'Caminhos B e C|projectos Next|Actualizar .openspec|Não correr|ficheiros React' sdd-kit/templates/doc/design/003-ui-stack-adapters.md`
  - **Forbidden:** flipping default stack away from shadcn; dual-file siblings; rewriting pipeline doc `001`

- [x] 2.3 Rewrite `sdd-kit/templates/doc/design/004-probity-module-install.md` Portuguese prose (title, scenario blurb, profile matrix, prerequisites, detect/apply steps, “does not” list, pilot section) → glossary-canonical English; prefer hub EN copy when available; keep `G2`, `install-probity-module.sh`, `@nizos/probity@1.10.0` pin if present, R6/`enforceTdd`, and “do not re-propose TDD Guard” outcome
  - **Pattern:** `sdd-kit/templates/doc/design/004-probity-module-install.md`
  - **Invariants:** `sdd-docs-language` — Kit design wave-1 module-install surfaces are English
  - **Gate:** `test -f sdd-kit/templates/doc/design/004-probity-module-install.md && ! test -f sdd-kit/templates/doc/design/004-probity-module-install.en.md && ! test -f sdd-kit/templates/doc/design/004-probity-module-install-pt.md && grep -qF 'install-probity-module.sh' sdd-kit/templates/doc/design/004-probity-module-install.md && grep -qF 'G2' sdd-kit/templates/doc/design/004-probity-module-install.md && grep -qF 'enforceTdd' sdd-kit/templates/doc/design/004-probity-module-install.md && grep -qiE 'Prerequisite|Prerequisites|Pilot' sdd-kit/templates/doc/design/004-probity-module-install.md && ! grep -qiE 'Pré-requisitos|Não re-propor|não activar|Actualiza .openspec/infra.md|Piloto .obrigatório' sdd-kit/templates/doc/design/004-probity-module-install.md`
  - **Forbidden:** re-opening TDD Guard; changing Probity pin; dual-file siblings; enabling Probity on DOCS_SPECS hub via doc text

## 3. Checksums + wave gates

- [x] 3.1 Regenerate kit MANIFEST checksums after template edits and verify kit integrity
  - **Pattern:** `sdd-kit/gen-manifest-checksums.sh`
  - **Invariants:** `sdd-docs-language` — Kit design wave-1 module-install surfaces are English
  - **Gate:** `bash sdd-kit/gen-manifest-checksums.sh && bash sdd-kit/verify.sh`
  - **Forbidden:** hand-editing `sha256:` fields; skipping verify after template edits

- [x] 3.2 Run per-wave i18n verification on the exact kit design file list
  - **Pattern:** `scripts/verify-i18n-wave.sh`
  - **Invariants:** `sdd-docs-language` — Per-wave and global verification script; Kit design wave-1 module-install surfaces are English
  - **Gate:** `bash scripts/verify-i18n-wave.sh --files sdd-kit/templates/doc/design/002-ui-module-install.md,sdd-kit/templates/doc/design/003-ui-stack-adapters.md,sdd-kit/templates/doc/design/004-probity-module-install.md`
  - **Forbidden:** marking tasks done if G-PT/G-INV/G-LINK/G-MANIFEST/G-OPENSPEC fail; running `--dod` as a required gate for this wave; editing hub `doc/design/` in this apply

- [x] 3.3 Validate OpenSpec change + task Pattern paths
  - **Pattern:** `scripts/verify-task-patterns.sh`
  - **Gate:** `bash scripts/verify-task-patterns.sh && OPENSPEC_TELEMETRY=0 npx --yes @fission-ai/openspec@1.3.1 validate translate-kit-design-wave-1 --strict`

## 4. Post-register (best-effort)

- [x] 4.1 `graphify update .` if available (docs touched); otherwise SKIP per infra
  - **Pattern:** `.cursor/rules/graphify.mdc`
  - **Gate:** `test -f graphify-out/GRAPH_REPORT.md || echo 'SKIP (graphify unavailable)'`
  - **Note:** SKIP if graphify CLI unavailable

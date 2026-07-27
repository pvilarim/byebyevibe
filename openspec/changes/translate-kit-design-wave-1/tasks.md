# Tasks — translate-kit-design-wave-1

> Apply after human approval (R7). Soft: prefer `translate-design-wave-1` apply-complete first. Serialize `MANIFEST.yaml` writes vs other kit-template applies. **In-place PT→EN only** on the three listed kit design templates (+ checksums). **Issue:** —

## 0. Soft prerequisite (hub design-wave-1)

- [ ] 0.1 Prefer hub `doc/design/002|003|004` already English before rewriting kit mirrors; if hub still Portuguese, proceed with glossary PT→EN on kit paths only (do not apply hub files in this session)
  - **Pattern:** `doc/design/002-ui-module-install.md`
  - **Invariants:** `sdd-docs-language` — Kit design wave-1 module-install mirrors are English; Wave size limits
  - **Gate:** `test -f sdd-kit/templates/doc/design/002-ui-module-install.md && test -f doc/design/002-ui-module-install.md && (grep -qiE 'Prerequisite|Prerequisites' doc/design/002-ui-module-install.md && echo 'HUB_EN_PREFERRED' || echo 'HUB_STILL_PT_PROCEED_KIT_ONLY')`
  - **Forbidden:** applying hub `doc/design/` in this change; mixing `/opsx:apply translate-design-wave-1` into this session

## 1. Prep (glossary + freeze)

- [ ] 1.1 Confirm glossary covers terms needed for this wave (`install kit`, gate, Session Handoff, wave, evaluation, canonical); append rows to `doc/i18n/GLOSSARY.md` only if a new SDD term is introduced (same PR)
  - **Pattern:** `doc/i18n/GLOSSARY.md`
  - **Invariants:** `sdd-docs-language` — Glossary and wave inventory exist
  - **Gate:** `test -s doc/i18n/GLOSSARY.md && grep -qE 'install kit|Session Handoff|wave|glossary|evaluation|canonical' doc/i18n/GLOSSARY.md`
  - **Forbidden:** invent synonym variants for glossary terms; dual-file `*.en.md` / `*-pt.md`; editing hub `doc/design/`

## 2. Substitute kit design mirrors (in-place)

- [ ] 2.1 Rewrite `sdd-kit/templates/doc/design/002-ui-module-install.md` Portuguese prose (title, scenario blurb, prerequisites, detect/apply steps, “does not” list, design-file disambiguation table, golden rule, checklist) → glossary-canonical English aligned with hub `doc/design/002-ui-module-install.md` when hub is EN; keep `C1-UI`, `install-ui-module.sh`, `--detect`/`--apply`/`--yes`, relative links, and procedure semantics intact
  - **Pattern:** `sdd-kit/templates/doc/design/002-ui-module-install.md`
  - **Invariants:** `sdd-docs-language` — Kit design wave-1 module-install mirrors are English; Freeze list of non-translatable tokens
  - **Gate:** `test -f sdd-kit/templates/doc/design/002-ui-module-install.md && ! test -f sdd-kit/templates/doc/design/002-ui-module-install.en.md && ! test -f sdd-kit/templates/doc/design/002-ui-module-install-pt.md && grep -qF 'install-ui-module.sh' sdd-kit/templates/doc/design/002-ui-module-install.md && grep -qF 'C1-UI' sdd-kit/templates/doc/design/002-ui-module-install.md && grep -qiE 'Prerequisite|Prerequisites' sdd-kit/templates/doc/design/002-ui-module-install.md && ! grep -qiE 'Pré-requisitos|Disambiguação de ficheiros|Regra de ouro|Guia canónico|Não substitui|Actualiza .openspec/infra.md' sdd-kit/templates/doc/design/002-ui-module-install.md`
  - **Forbidden:** dual-file siblings; changing what `--apply` installs or skips; drive-by edits to kit `000`/`001` or hub `doc/design/`

- [ ] 2.2 Rewrite `sdd-kit/templates/doc/design/003-ui-stack-adapters.md` Portuguese prose (title, opt-out guidance, adapter paths, checklist) → glossary-canonical English aligned with hub when EN; keep default-shadcn stance, relative links to `001-pipeline-*`, and “do not run `npx shadcn@latest init`” semantics for opt-out paths
  - **Pattern:** `sdd-kit/templates/doc/design/003-ui-stack-adapters.md`
  - **Invariants:** `sdd-docs-language` — Kit design wave-1 module-install mirrors are English
  - **Gate:** `test -f sdd-kit/templates/doc/design/003-ui-stack-adapters.md && ! test -f sdd-kit/templates/doc/design/003-ui-stack-adapters.en.md && ! test -f sdd-kit/templates/doc/design/003-ui-stack-adapters-pt.md && grep -qF '001-pipeline-open-design-shadcn-impeccable.md' sdd-kit/templates/doc/design/003-ui-stack-adapters.md && grep -qF 'npx shadcn@latest init' sdd-kit/templates/doc/design/003-ui-stack-adapters.md && ! grep -qiE 'Caminhos B e C|projectos Next|Actualizar .openspec|Não correr|ficheiros React' sdd-kit/templates/doc/design/003-ui-stack-adapters.md`
  - **Forbidden:** flipping default stack away from shadcn; dual-file siblings; rewriting kit `001` or hub design docs

- [ ] 2.3 Rewrite `sdd-kit/templates/doc/design/004-probity-module-install.md` Portuguese prose (title, scenario blurb, profile matrix, prerequisites, detect/apply steps, “does not” list, pilot section) → glossary-canonical English aligned with hub when EN; keep `G2`, `install-probity-module.sh`, `@nizos/probity@1.10.0` pin if present, R6/`enforceTdd`, and “do not re-propose TDD Guard” outcome
  - **Pattern:** `sdd-kit/templates/doc/design/004-probity-module-install.md`
  - **Invariants:** `sdd-docs-language` — Kit design wave-1 module-install mirrors are English
  - **Gate:** `test -f sdd-kit/templates/doc/design/004-probity-module-install.md && ! test -f sdd-kit/templates/doc/design/004-probity-module-install.en.md && ! test -f sdd-kit/templates/doc/design/004-probity-module-install-pt.md && grep -qF 'install-probity-module.sh' sdd-kit/templates/doc/design/004-probity-module-install.md && grep -qF 'G2' sdd-kit/templates/doc/design/004-probity-module-install.md && grep -qF 'enforceTdd' sdd-kit/templates/doc/design/004-probity-module-install.md && grep -qiE 'Prerequisite|Prerequisites|Pilot' sdd-kit/templates/doc/design/004-probity-module-install.md && ! grep -qiE 'Pré-requisitos|Não re-propor|não activar|Actualiza .openspec/infra.md|Piloto .obrigatório' sdd-kit/templates/doc/design/004-probity-module-install.md`
  - **Forbidden:** re-opening TDD Guard; changing Probity pin; dual-file siblings; enabling Probity on DOCS_SPECS hub via doc text

## 3. Checksums (G-MANIFEST)

- [ ] 3.1 Regenerate `sdd-kit/MANIFEST.yaml` sha256 fields after template edits; serialize vs other in-flight kit applies touching MANIFEST
  - **Pattern:** `sdd-kit/gen-manifest-checksums.sh`
  - **Invariants:** `sdd-docs-language` — Kit design wave-1 module-install mirrors are English (G-MANIFEST)
  - **Gate:** `bash sdd-kit/gen-manifest-checksums.sh && bash sdd-kit/verify.sh`
  - **Forbidden:** hand-editing sha256 without regenerator; evaluating MANIFEST `gate:` via eval; skipping verify after checksum update; concurrent MANIFEST edits with other kit apply PRs

## 4. Wave gates

- [ ] 4.1 Run per-wave i18n verification on the exact kit design file list
  - **Pattern:** `scripts/verify-i18n-wave.sh`
  - **Invariants:** `sdd-docs-language` — Per-wave and global verification script; Kit design wave-1 module-install mirrors are English
  - **Gate:** `bash scripts/verify-i18n-wave.sh --files sdd-kit/templates/doc/design/002-ui-module-install.md,sdd-kit/templates/doc/design/003-ui-stack-adapters.md,sdd-kit/templates/doc/design/004-probity-module-install.md`
  - **Forbidden:** marking tasks done if G-PT/G-INV/G-LINK/G-MANIFEST/G-OPENSPEC fail; running `--dod` as a required gate for this wave; editing hub `doc/design/` in this apply

- [ ] 4.2 Validate OpenSpec change + task Pattern paths
  - **Pattern:** `scripts/verify-task-patterns.sh`
  - **Gate:** `bash scripts/verify-task-patterns.sh && OPENSPEC_TELEMETRY=0 npx --yes @fission-ai/openspec@1.3.1 validate translate-kit-design-wave-1 --strict`

## 5. Post-register (best-effort)

- [ ] 5.1 `graphify update .` if available (docs/templates touched); otherwise SKIP per infra
  - **Pattern:** `.cursor/rules/graphify.mdc`
  - **Gate:** `test -f graphify-out/GRAPH_REPORT.md || echo 'SKIP (graphify unavailable)'`
  - **Note:** SKIP if graphify CLI unavailable

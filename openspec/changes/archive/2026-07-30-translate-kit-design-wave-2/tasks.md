# Tasks — translate-kit-design-wave-2

> Apply after human approval (R7). **In-place PT→EN only** on the listed `sdd-kit/templates/doc/design/` file + MANIFEST checksum regen. **Issue:** —

## 1. Prep (glossary + freeze + soft prerequisites)

- [x] 1.1 Confirm glossary covers terms needed for this wave (`install kit`, gate, Session Handoff, wave, evaluation, canonical, design system); append rows to `doc/i18n/GLOSSARY.md` only if a new SDD term is introduced (same PR)
  - **Pattern:** `doc/i18n/GLOSSARY.md`
  - **Invariants:** `sdd-docs-language` — Glossary and wave inventory exist
  - **Gate:** `test -s doc/i18n/GLOSSARY.md && grep -qE 'install kit|Session Handoff|wave|glossary|evaluation|canonical' doc/i18n/GLOSSARY.md`
  - **Forbidden:** invent synonym variants for glossary terms; dual-file `*.en.md` / `*-pt.md`; editing hub `doc/design/` in this change

- [x] 1.2 Soft-check hub design-wave-2 apply status and avoid concurrent kit-template applies
  - **Pattern:** `openspec/changes/translate-design-wave-2/tasks.md`
  - **Invariants:** `sdd-docs-language` — Kit design wave-2 Impeccable reference template is English
  - **Gate:** `test -f openspec/changes/translate-design-wave-2/proposal.md || test -d openspec/changes/archive/*translate-design-wave-2* 2>/dev/null; echo 'NOTE: prefer hub design-wave-2 apply-complete; serialize vs other sdd-kit/templates applies (e.g. kit-design-wave-1 PR #106, W2c/W2d PR #78)'`
  - **Forbidden:** blocking propose (already done); starting apply while another kit-templates+MANIFEST apply is in-flight on the same base without coordination

## 2. Substitute kit design surface (in-place)

- [x] 2.1 Rewrite `sdd-kit/templates/doc/design/000-impeccable-design-system-guia.md` Portuguese prose (title, import/adaptation blurb, what Impeccable is/is-not, shadcn fit, advantages, monorepo scope tables, adoption checklist including prerequisites/install/CI, limitations) → glossary-canonical English; prefer hub EN copy when available; keep `DOCS_SPECS`, relative links to kit `001`/`002`/`003`/canonical guide, brand/tool names, fenced shell, and reference/adaptation + applicability semantics intact (status marker may become `[REFERENCE — NEEDS ADAPTATION]`; `[se aplicável]` → `[if applicable]`)
  - **Pattern:** `sdd-kit/templates/doc/design/000-impeccable-design-system-guia.md`
  - **Invariants:** `sdd-docs-language` — Kit design wave-2 Impeccable reference template is English; Freeze list of non-translatable tokens
  - **Gate:** `test -f sdd-kit/templates/doc/design/000-impeccable-design-system-guia.md && ! test -f sdd-kit/templates/doc/design/000-impeccable-design-system-guia.en.md && ! test -f sdd-kit/templates/doc/design/000-impeccable-design-system-guia-pt.md && grep -qF 'DOCS_SPECS' sdd-kit/templates/doc/design/000-impeccable-design-system-guia.md && grep -qF '002-ui-module-install.md' sdd-kit/templates/doc/design/000-impeccable-design-system-guia.md && grep -qF '003-ui-stack-adapters.md' sdd-kit/templates/doc/design/000-impeccable-design-system-guia.md && grep -qiE 'Prerequisite|Prerequisites|REFERENCE|NEEDS ADAPTATION|if applicable' sdd-kit/templates/doc/design/000-impeccable-design-system-guia.md && ! grep -qiE 'Secções marcadas|guia de referência|O que é o Impeccable|Pré-requisitos|Fluxo de trabalho recomendado|Vocabulário compartilhado|não contém app Next' sdd-kit/templates/doc/design/000-impeccable-design-system-guia.md`
  - **Forbidden:** dual-file siblings; installing Impeccable on this DOCS_SPECS hub via doc text; drive-by edits to kit `001`/`002`/`003`/`004` or hub `doc/design/`; changing shadcn-default / adoption recommendations beyond language

## 3. Checksums + wave gates

- [x] 3.1 Regenerate kit MANIFEST checksums after template edits and verify kit integrity
  - **Pattern:** `sdd-kit/gen-manifest-checksums.sh`
  - **Invariants:** `sdd-docs-language` — Kit design wave-2 Impeccable reference template is English
  - **Gate:** `bash sdd-kit/gen-manifest-checksums.sh && bash sdd-kit/verify.sh`
  - **Forbidden:** hand-editing `sha256:` fields; skipping verify after template edits

- [x] 3.2 Run per-wave i18n verification on the exact kit design file
  - **Pattern:** `scripts/verify-i18n-wave.sh`
  - **Invariants:** `sdd-docs-language` — Per-wave and global verification script; Kit design wave-2 Impeccable reference template is English
  - **Gate:** `bash scripts/verify-i18n-wave.sh --files sdd-kit/templates/doc/design/000-impeccable-design-system-guia.md`
  - **Forbidden:** marking tasks done if G-PT/G-INV/G-LINK/G-MANIFEST/G-OPENSPEC fail; running `--dod` as a required gate for this wave; editing hub `doc/design/` in this apply

- [x] 3.3 Validate OpenSpec change + task Pattern paths
  - **Pattern:** `scripts/verify-task-patterns.sh`
  - **Gate:** `bash scripts/verify-task-patterns.sh && OPENSPEC_TELEMETRY=0 npx --yes @fission-ai/openspec@1.3.1 validate translate-kit-design-wave-2 --strict`

## 4. Post-register (best-effort)

- [x] 4.1 `graphify update .` if available (docs touched); otherwise SKIP per infra
  - **Pattern:** `.cursor/rules/graphify.mdc`
  - **Gate:** `test -f graphify-out/GRAPH_REPORT.md || echo 'SKIP (graphify unavailable)'`
  - **Note:** SKIP if graphify CLI unavailable

# Tasks — translate-specs-wave-2

> Apply after human approval (R7). **In-place PT→EN only** on `openspec/specs/sdd-install-kit/spec.md`. **Issue:** —

## 1. Prep (glossary + freeze)

- [ ] 1.1 Confirm glossary covers terms needed for this wave (`install kit` / sdd-kit, `gate`, `fail-closed`, wave, canonical); append rows to `doc/i18n/GLOSSARY.md` only if a new SDD term is introduced (same PR)
  - **Pattern:** `doc/i18n/GLOSSARY.md`
  - **Invariants:** `sdd-docs-language` — Glossary and wave inventory exist
  - **Gate:** `test -s doc/i18n/GLOSSARY.md && grep -qE 'install kit|fail-closed|Session Handoff|wave|glossary|canonical|gate' doc/i18n/GLOSSARY.md`
  - **Forbidden:** invent synonym variants for glossary terms; dual-file `*.en.md` / `*-pt.md`; editing `sdd-kit/upgrade.sh` or other capability specs in this prep task

## 2. Substitute capability spec (in-place)

- [ ] 2.1 Rewrite `openspec/specs/sdd-install-kit/spec.md` residual Portuguese prose (HYBRID bootstrap warning requirement/scenarios; COPY dry-run label requirement/scenarios; mixed Portuguese fragments in Deterministic SDD upgrade and related WHEN/THEN lines; Portuguese requirement titles) → glossary-canonical English; keep paths/flags/MANIFEST keys/`COPY`/`APPLY_TEMPLATE`/OpenSpec keywords intact; for the UPGRADE_REPORT approval gate and any Portuguese stderr still defined only in kit scripts, reference `sdd-kit/upgrade.sh` / bootstrap script implementation **without** pasting G-PT deny-list tokens into the EN spec
  - **Pattern:** `openspec/specs/sdd-install-kit/spec.md`
  - **Invariants:** `sdd-docs-language` — Specs wave-2 sdd-install-kit capability spec is English; Freeze list of non-translatable tokens
  - **Gate:** `test -f openspec/specs/sdd-install-kit/spec.md && ! test -f openspec/specs/sdd-install-kit/spec.en.md && ! test -f openspec/specs/sdd-install-kit/spec-pt.md && grep -qF 'sdd-kit/upgrade.sh' openspec/specs/sdd-install-kit/spec.md && grep -qF 'merge: COPY' openspec/specs/sdd-install-kit/spec.md && grep -qF 'bootstrap-sdd.sh' openspec/specs/sdd-install-kit/spec.md && grep -qiE 'HYBRID|dry-run|UPGRADE_REPORT' openspec/specs/sdd-install-kit/spec.md && ! grep -qiE 'emite aviso|Quando \`package|para ficheiros|rótulo COPY|o operador executa|o operador corre|num repo que|não recebe aviso|classificar ficheiros|Actualização aprovada|por defeito \(APP\)' openspec/specs/sdd-install-kit/spec.md`
  - **Forbidden:** dual-file siblings; changing install/upgrade semantics; editing `sdd-kit/upgrade.sh` to rename the approval checkbox in this wave; drive-by edits to other specs; leaving residual Portuguese prose; pasting deny-list tokens (`actualização`, `ficheiros`, `não`, …) into the migrated EN doc

## 3. Wave gates

- [ ] 3.1 Run per-wave i18n verification on the exact capability-spec file
  - **Pattern:** `scripts/verify-i18n-wave.sh`
  - **Invariants:** `sdd-docs-language` — Per-wave and global verification script; Specs wave-2 sdd-install-kit capability spec is English
  - **Gate:** `bash scripts/verify-i18n-wave.sh --files openspec/specs/sdd-install-kit/spec.md`
  - **Forbidden:** marking tasks done if G-PT/G-INV/G-LINK/G-OPENSPEC fail; running `--dod` as a required gate for this wave; touching `sdd-kit/templates/` or renaming upgrade approval literals in this apply

- [ ] 3.2 Validate OpenSpec change + task Pattern paths
  - **Pattern:** `scripts/verify-task-patterns.sh`
  - **Gate:** `bash scripts/verify-task-patterns.sh && OPENSPEC_TELEMETRY=0 npx --yes @fission-ai/openspec@1.3.1 validate translate-specs-wave-2 --strict`

## 4. Post-register (best-effort)

- [ ] 4.1 `graphify update .` if available (docs touched); otherwise SKIP per infra
  - **Pattern:** `.cursor/rules/graphify.mdc`
  - **Gate:** `test -f graphify-out/GRAPH_REPORT.md || echo 'SKIP (graphify unavailable)'`
  - **Note:** SKIP if graphify CLI unavailable

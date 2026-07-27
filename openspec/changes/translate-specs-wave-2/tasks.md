# Tasks — translate-specs-wave-2

> Apply after human approval (R7). **In-place PT→EN only** on `openspec/specs/sdd-install-kit/spec.md`. **Issue:** —

## 1. Prep (glossary + freeze)

- [ ] 1.1 Confirm glossary covers terms needed for this wave (`install kit`, `gate`, `fail-closed`, wave, canonical); append rows to `doc/i18n/GLOSSARY.md` only if a new SDD term is introduced (same PR)
  - **Pattern:** `doc/i18n/GLOSSARY.md`
  - **Invariants:** `sdd-docs-language` — Glossary and wave inventory exist
  - **Gate:** `test -s doc/i18n/GLOSSARY.md && grep -qE 'install kit|fail-closed|gate|wave|glossary|canonical' doc/i18n/GLOSSARY.md`
  - **Forbidden:** invent synonym variants for glossary terms; dual-file `*.en.md` / `*-pt.md`; editing `sdd-kit/upgrade.sh` or specs owned by `translate-specs-wave-1` in this prep task

## 2. Substitute sdd-install-kit spec (in-place)

- [ ] 2.1 Rewrite `openspec/specs/sdd-install-kit/spec.md` residual Portuguese prose (HYBRID bootstrap warning requirement/scenarios; dry-run `COPY` label requirement/scenarios; MANIFEST upgrade-tool classification prose; `--apply` approval-guard requirement/scenarios) → glossary-canonical English; keep paths `sdd-kit/upgrade.sh` / `scripts/bootstrap-sdd.sh` / `UPGRADE_REPORT.md`, MANIFEST `merge: COPY` / `merge: MERGE`, profile names APP/DOCS_SPECS/HYBRID, and OpenSpec `MUST`/`WHEN`/`THEN` intact; for the approval guard, describe the check by reference to the exact checkbox substring hardcoded in `sdd-kit/upgrade.sh` — do **not** paste deny-listed Portuguese tokens into the migrated prose; do **not** edit `sdd-kit/upgrade.sh` in this wave
  - **Pattern:** `openspec/specs/sdd-install-kit/spec.md`
  - **Invariants:** `sdd-docs-language` — Specs wave-2 sdd-install-kit capability spec is English; Freeze list of non-translatable tokens
  - **Gate:** `test -f openspec/specs/sdd-install-kit/spec.md && ! test -f openspec/specs/sdd-install-kit/spec.en.md && ! test -f openspec/specs/sdd-install-kit/spec-pt.md && grep -qF 'sdd-kit/upgrade.sh' openspec/specs/sdd-install-kit/spec.md && grep -qF 'scripts/bootstrap-sdd.sh' openspec/specs/sdd-install-kit/spec.md && grep -qF 'merge: COPY' openspec/specs/sdd-install-kit/spec.md && grep -qiE 'HYBRID|bootstrap|UPGRADE_REPORT' openspec/specs/sdd-install-kit/spec.md && ! grep -qiE 'Actualização aprovada|emitir um aviso|por defeito|o operador|ficheiro|ficheiros|não tem|rótulo|Antes de|classificar ficheiros' openspec/specs/sdd-install-kit/spec.md`
  - **Forbidden:** dual-file siblings; editing `sdd-kit/upgrade.sh` or guide checklist strings; changing bootstrap/COPY/approval-guard semantics; drive-by edits to other specs; pasting deny-listed Portuguese approval-marker tokens into the EN spec; leaving residual Portuguese prose

## 3. Wave gates

- [ ] 3.1 Run per-wave i18n verification on the exact capability-spec file list
  - **Pattern:** `scripts/verify-i18n-wave.sh`
  - **Invariants:** `sdd-docs-language` — Per-wave and global verification script; Specs wave-2 sdd-install-kit capability spec is English
  - **Gate:** `bash scripts/verify-i18n-wave.sh --files openspec/specs/sdd-install-kit/spec.md`
  - **Forbidden:** marking tasks done if G-PT/G-INV/G-LINK/G-OPENSPEC fail; running `--dod` as a required gate for this wave; touching `sdd-kit/templates/` or `sdd-kit/upgrade.sh` in this apply

- [ ] 3.2 Validate OpenSpec change + task Pattern paths
  - **Pattern:** `scripts/verify-task-patterns.sh`
  - **Gate:** `bash scripts/verify-task-patterns.sh && OPENSPEC_TELEMETRY=0 npx --yes @fission-ai/openspec@1.3.1 validate translate-specs-wave-2 --strict`

## 4. Post-register (best-effort)

- [ ] 4.1 `graphify update .` if available (docs touched); otherwise SKIP per infra
  - **Pattern:** `.cursor/rules/graphify.mdc`
  - **Gate:** `test -f graphify-out/GRAPH_REPORT.md || echo 'SKIP (graphify unavailable)'`
  - **Note:** SKIP if graphify CLI unavailable

# Tasks — translate-guide-wave-10

> Apply after human approval (R7). In-place PT→EN only on lines **1620–1973** of `doc/sistema-sdd-pedro.md`.

## 1. Prep

- [ ] 1.1 Confirm `doc/i18n/GLOSSARY.md` covers terms for this slice; append only if new SDD terms appear
  - **Pattern:** `doc/i18n/GLOSSARY.md`
  - **Gate:** `test -s doc/i18n/GLOSSARY.md`

## 2. Substitute

- [ ] 2.1 Rewrite lines **1620–1973** (§9–§10 Cursor + VS Code / Claude Code setup) Portuguese prose → glossary-canonical English; do not edit lines outside the slice
  - **Pattern:** `doc/sistema-sdd-pedro.md`
  - **Gate:** `bash scripts/verify-i18n-wave.sh --files doc/sistema-sdd-pedro.md --slice 1620-1973`
  - **Forbidden:** dual-file siblings; edits outside lines 1620–1973

## 3. Validate

- [ ] 3.1 OpenSpec + task patterns
  - **Pattern:** `scripts/verify-task-patterns.sh`
  - **Gate:** `bash scripts/verify-task-patterns.sh && OPENSPEC_TELEMETRY=0 npx --yes @fission-ai/openspec@1.3.1 validate translate-guide-wave-10 --strict`
  - **Note:** Per-wave gate must pass before marking done

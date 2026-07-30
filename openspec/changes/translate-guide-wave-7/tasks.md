# Tasks — translate-guide-wave-7

> Apply after human approval (R7). In-place PT→EN only on lines **1047–1278** of `doc/sistema-sdd-pedro.md`.

## 1. Prep

- [ ] 1.1 Confirm `doc/i18n/GLOSSARY.md` covers terms for this slice; append only if new SDD terms appear
  - **Pattern:** `doc/i18n/GLOSSARY.md`
  - **Gate:** `test -s doc/i18n/GLOSSARY.md`

## 2. Substitute

- [ ] 2.1 Rewrite lines **1047–1278** (§3–§4 task classification + master tool table) Portuguese prose → glossary-canonical English; do not edit lines outside the slice
  - **Pattern:** `doc/sistema-sdd-pedro.md`
  - **Gate:** `bash scripts/verify-i18n-wave.sh --files doc/sistema-sdd-pedro.md`
  - **Forbidden:** dual-file siblings; edits outside lines 1047–1278

## 3. Validate

- [ ] 3.1 OpenSpec + task patterns
  - **Pattern:** `scripts/verify-task-patterns.sh`
  - **Gate:** `bash scripts/verify-task-patterns.sh && OPENSPEC_TELEMETRY=0 npx --yes @fission-ai/openspec@1.3.1 validate translate-guide-wave-7 --strict`
  - **Note:** Per-wave gate must pass before marking done

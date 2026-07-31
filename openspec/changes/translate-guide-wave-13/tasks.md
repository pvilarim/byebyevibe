# Tasks — translate-guide-wave-13

> Apply after human approval (R7). In-place PT→EN only on lines **2504–2729** of `doc/sistema-sdd-pedro.md`.

## 1. Prep

- [x] 1.1 Confirm `doc/i18n/GLOSSARY.md` covers terms for this slice; append only if new SDD terms appear
  - **Pattern:** `doc/i18n/GLOSSARY.md`
  - **Gate:** `test -s doc/i18n/GLOSSARY.md`

## 2. Substitute

- [x] 2.1 Rewrite lines **2504–2729** (§12.6–12.10 annex templates (upgrade, tasks patterns)) Portuguese prose → glossary-canonical English; do not edit lines outside the slice
  - **Pattern:** `doc/sistema-sdd-pedro.md`
  - **Gate:** `bash scripts/verify-i18n-wave.sh --files doc/sistema-sdd-pedro.md --slice 2504-2729`
  - **Forbidden:** dual-file siblings; edits outside lines 2504–2729

## 3. Validate

- [x] 3.1 OpenSpec + task patterns
  - **Pattern:** `scripts/verify-task-patterns.sh`
  - **Gate:** `bash scripts/verify-task-patterns.sh && OPENSPEC_TELEMETRY=0 npx --yes @fission-ai/openspec@1.3.1 validate translate-guide-wave-13 --strict`
  - **Note:** Per-wave gate must pass before marking done

# Tasks — translate-design-wave-4

> Apply after human approval (R7). In-place PT→EN only on lines **326–592** of `doc/design/001-pipeline-open-design-shadcn-impeccable.md`.

## 1. Prep

- [x] 1.1 Confirm `doc/i18n/GLOSSARY.md` covers terms for this slice; append only if new SDD terms appear
  - **Pattern:** `doc/i18n/GLOSSARY.md`
  - **Gate:** `test -s doc/i18n/GLOSSARY.md`

## 2. Substitute

- [x] 2.1 Rewrite lines **326–592** (§4–§13 shadcn phase through history) Portuguese prose → glossary-canonical English; do not edit lines outside the slice
  - **Pattern:** `doc/design/001-pipeline-open-design-shadcn-impeccable.md`
  - **Gate:** `bash scripts/verify-i18n-wave.sh --files doc/design/001-pipeline-open-design-shadcn-impeccable.md`
  - **Forbidden:** dual-file siblings; edits outside lines 326–592

## 3. Validate

- [x] 3.1 OpenSpec + task patterns
  - **Pattern:** `scripts/verify-task-patterns.sh`
  - **Gate:** `bash scripts/verify-task-patterns.sh && OPENSPEC_TELEMETRY=0 npx --yes @fission-ai/openspec@1.3.1 validate translate-design-wave-4 --strict`
  - **Note:** Per-wave gate must pass before marking done

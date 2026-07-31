# Tasks — translate-guide-wave-4

> Apply after human approval (R7). In-place PT→EN only on lines **425–621** of `doc/sistema-sdd-pedro.md`.

## 1. Prep

- [x] 1.1 Confirm `doc/i18n/GLOSSARY.md` covers terms for this slice; append only if new SDD terms appear
  - **Pattern:** `doc/i18n/GLOSSARY.md`
  - **Gate:** `test -s doc/i18n/GLOSSARY.md`

## 2. Substitute

- [x] 2.1 Rewrite lines **425–621** (§2.11–2.14 UI module, CI gates, supply chain, reviews) Portuguese prose → glossary-canonical English; do not edit lines outside the slice
  - **Pattern:** `doc/sistema-sdd-pedro.md`
  - **Gate:** `bash scripts/verify-i18n-wave.sh --files doc/sistema-sdd-pedro.md --slice 425-621`
  - **Forbidden:** dual-file siblings; edits outside lines 425–621

## 3. Validate

- [x] 3.1 OpenSpec + task patterns
  - **Pattern:** `scripts/verify-task-patterns.sh`
  - **Gate:** `bash scripts/verify-task-patterns.sh && OPENSPEC_TELEMETRY=0 npx --yes @fission-ai/openspec@1.3.1 validate translate-guide-wave-4 --strict`
  - **Note:** Per-wave gate must pass before marking done

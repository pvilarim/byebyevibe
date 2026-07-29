# Tasks — translate-kit-design-wave-4

> Apply after human approval (R7). In-place PT→EN only on lines **326–592** of `sdd-kit/templates/doc/design/001-pipeline-open-design-shadcn-impeccable.md`.

## 1. Prep

- [ ] 1.1 Confirm `doc/i18n/GLOSSARY.md` covers terms for this slice; append only if new SDD terms appear
  - **Pattern:** `doc/i18n/GLOSSARY.md`
  - **Gate:** `test -s doc/i18n/GLOSSARY.md`

## 2. Substitute

- [ ] 2.1 Rewrite lines **326–592** (kit mirror §4–§13) Portuguese prose → glossary-canonical English; do not edit lines outside the slice
  - **Pattern:** `sdd-kit/templates/doc/design/001-pipeline-open-design-shadcn-impeccable.md`
  - **Gate:** `bash scripts/verify-i18n-wave.sh --files sdd-kit/templates/doc/design/001-pipeline-open-design-shadcn-impeccable.md`
  - **Forbidden:** dual-file siblings; edits outside lines 326–592

- [ ] 2.2 Run `bash sdd-kit/gen-manifest-checksums.sh` after template edit
  - **Pattern:** `sdd-kit/gen-manifest-checksums.sh`
  - **Gate:** `bash sdd-kit/verify.sh`

## 3. Validate

- [ ] 3.1 OpenSpec + task patterns
  - **Pattern:** `scripts/verify-task-patterns.sh`
  - **Gate:** `bash scripts/verify-task-patterns.sh && OPENSPEC_TELEMETRY=0 npx --yes @fission-ai/openspec@1.3.1 validate translate-kit-design-wave-4 --strict`
  - **Note:** Per-wave gate must pass G-MANIFEST before marking done

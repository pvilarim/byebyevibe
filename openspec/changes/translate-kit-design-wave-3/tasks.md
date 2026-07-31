# Tasks — translate-kit-design-wave-3

> Apply after human approval (R7). In-place PT→EN only on lines **1–325** of `sdd-kit/templates/doc/design/001-pipeline-open-design-shadcn-impeccable.md`.

## 1. Prep

- [x] 1.1 Confirm `doc/i18n/GLOSSARY.md` covers terms for this slice; append only if new SDD terms appear
  - **Pattern:** `doc/i18n/GLOSSARY.md`
  - **Gate:** `test -s doc/i18n/GLOSSARY.md`

## 2. Substitute

- [x] 2.1 Rewrite lines **1–325** (kit mirror §1–§3.4) Portuguese prose → glossary-canonical English; do not edit lines outside the slice
  - **Pattern:** `sdd-kit/templates/doc/design/001-pipeline-open-design-shadcn-impeccable.md`
  - **Gate:** `bash scripts/verify-i18n-wave.sh --files sdd-kit/templates/doc/design/001-pipeline-open-design-shadcn-impeccable.md --slice 1-325`
  - **Forbidden:** dual-file siblings; edits outside lines 1–325

- [x] 2.2 Run `bash sdd-kit/gen-manifest-checksums.sh` after template edit
  - **Pattern:** `sdd-kit/gen-manifest-checksums.sh`
  - **Gate:** `bash sdd-kit/verify.sh`

## 3. Validate

- [x] 3.1 OpenSpec + task patterns
  - **Pattern:** `scripts/verify-task-patterns.sh`
  - **Gate:** `bash scripts/verify-task-patterns.sh && OPENSPEC_TELEMETRY=0 npx --yes @fission-ai/openspec@1.3.1 validate translate-kit-design-wave-3 --strict`
  - **Note:** Per-wave gate must pass G-MANIFEST before marking done

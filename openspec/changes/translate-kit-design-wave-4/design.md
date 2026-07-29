# Design — translate-kit-design-wave-4

## Context

- Layer-1 policy: `sdd-docs-language` / `doc/i18n/*`.
- Target: `sdd-kit/templates/doc/design/001-pipeline-open-design-shadcn-impeccable.md` lines **326–592** (kit mirror §4–§13, ~267 LOC).
- Hub `translate-design-wave-*` apply should land before kit apply when possible.
- Canonical guide (`doc/sistema-sdd-pedro.md`) is covered by `translate-guide-wave-*` (separate track).

## Goals / Non-Goals

**Goals:**

- Substitute Portuguese prose in the listed slice with glossary-canonical English in-place.
- Pass `bash scripts/verify-i18n-wave.sh --files sdd-kit/templates/doc/design/001-pipeline-open-design-shadcn-impeccable.md`.
- After template edits: `bash sdd-kit/gen-manifest-checksums.sh` (G-MANIFEST)

**Non-goals:** dual-file siblings; global G-DoD; semantic changes beyond language.

## Decisions

### D1: Mid-file slice on `sdd-kit/templates/doc/design/001-pipeline-open-design-shadcn-impeccable.md`

**Chosen:** Lines 326–592 only; whole-file path in gate (G-PT scans entire file — prior slices must be apply-complete).

## Risks

| Risk | Mitigation |
|------|------------|
| G-PT fails on untouched PT outside slice | Sequential apply per wave number |
| Broken relative links | G-LINK; careful heading translation |

## Migration Plan

1. Apply EN substitution for lines 326–592.
2. Gate: `bash scripts/verify-i18n-wave.sh --files sdd-kit/templates/doc/design/001-pipeline-open-design-shadcn-impeccable.md`.
3. Validate: `OPENSPEC_TELEMETRY=0 npx --yes @fission-ai/openspec@1.3.1 validate translate-kit-design-wave-4 --strict`.

**Rollback:** `git checkout -- sdd-kit/templates/doc/design/001-pipeline-open-design-shadcn-impeccable.md`.

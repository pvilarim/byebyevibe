# Design — translate-guide-wave-4

## Context

- Layer-1 policy: `sdd-docs-language` / `doc/i18n/*`.
- Target: `doc/sistema-sdd-pedro.md` lines **425–621** (§2.11–2.14 UI module, CI gates, supply chain, reviews, ~197 LOC).
- Deferred from `translate-design-wave-2` non-goals (`001` ~592 LOC — split into two waves).
- Canonical guide (`doc/sistema-sdd-pedro.md`) is covered by `translate-guide-wave-*` (separate track).

## Goals / Non-Goals

**Goals:**

- Substitute Portuguese prose in the listed slice with glossary-canonical English in-place.
- Pass `bash scripts/verify-i18n-wave.sh --files doc/sistema-sdd-pedro.md`.

**Non-goals:** dual-file siblings; global G-DoD; semantic changes beyond language.

## Decisions

### D1: Mid-file slice on `doc/sistema-sdd-pedro.md`

**Chosen:** Lines 425–621 only; whole-file path in gate (G-PT scans entire file — prior slices must be apply-complete).

## Risks

| Risk | Mitigation |
|------|------------|
| G-PT fails on untouched PT outside slice | Sequential apply per wave number |
| Broken relative links | G-LINK; careful heading translation |

## Migration Plan

1. Apply EN substitution for lines 425–621.
2. Gate: `bash scripts/verify-i18n-wave.sh --files doc/sistema-sdd-pedro.md`.
3. Validate: `OPENSPEC_TELEMETRY=0 npx --yes @fission-ai/openspec@1.3.1 validate translate-guide-wave-4 --strict`.

**Rollback:** `git checkout -- doc/sistema-sdd-pedro.md`.

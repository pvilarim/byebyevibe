# Proposal: update-readme-discovery-v2

**Issue:** —

## Why

The root README already converts well (hero, CTA, compare, anti-boilerplate) but discovery v2 exploration showed friction: value bullets and anti-boilerplate sit below the fold; core tools lack the guide's didactic What/Without it pattern; `/opsx:help` (day-1 operator map from `add-sdd-operator-onboarding`) is absent from first contact; optional modules (C1-UI, G2 Probity) are buried in tables; and G4 metrics are under-connected to "calibrate as you go" process retrospectives. Recent install-narrative improvements (`improve-install-narrative`) should be folded into a single hybrid layout: conversion above the fold + pedagogical clarity below.

## What Changes

- **Reorder** root `README.md` to the mandatory 17-section structure (above-fold value → proof → differentiation).
- **Elevate** "Why install this" (4–5 value bullets) and anti-boilerplate line immediately after the hero.
- **Add** explicit "AI-assisted development toolkit" phrasing and the approved market terms (tagline, agentic engineering reframe).
- **Retable** core tools with What / Without it columns (OpenSpec, GitNexus, Graphify, `sdd-kit/`, CI `sdd-gates`, session locks).
- **Document** `/opsx:help` in a User-friendly OpenSpec section (complements `/opsx:onboard`; links `doc/sdd-operator-day1.md`).
- **Add** dedicated Optional modules block (C1-UI, G2 Probity, post-apply review skills, G4 pointer).
- **Strengthen** Calibrate as you go (G4 `sdd-metrics.sh`) — process retrospectives framing; **no** ML/self-learning claims.
- **Minimal update** to `doc/avaliacoes/2026-07-26-sdd-discovery-positioning.md` — record v2 decision and section order; keep P5/P11 backlog intact.
- **Cross-link** in `doc/sistema-sdd-pedro.md` §2.0b if `/opsx:help` is not already mentioned (verify only; 1-line delta max).
- **Spec delta** for `sdd-discovery-positioning` — normative requirements for above-fold value, `/opsx:help`, didactic table, optional modules block.

**Non-goals (D9):** GIF/asciinema (P5), landing/Discord/npx fame, app scaffold, i18n waves / root CHANGELOG (P11/P12), GitHub slug rename (manual), ML claims on G4.

## Capabilities

### New Capabilities

_None — extends existing discovery capability._

### Modified Capabilities

- `sdd-discovery-positioning`: Add requirements for README v2 section order, above-fold value bullets, `/opsx:help` documentation, didactic What/Without it core-tools table, optional modules block, and G4 calibrate-as-you-go framing without ML claims.

## Impact

| Surface | Change |
|---------|--------|
| `README.md` | Primary — full restructure per target outline |
| `doc/avaliacoes/2026-07-26-sdd-discovery-positioning.md` | Append v2 decision note; roadmap item ④ |
| `doc/sistema-sdd-pedro.md` | §2.0b — verify `/opsx:help` cross-link (likely already present) |
| `openspec/specs/sdd-discovery-positioning/spec.md` | Promoted via delta on archive |
| `sdd-kit/` | **No** MANIFEST bump (docs-only) |

No application code, CI workflow, or kit template changes.

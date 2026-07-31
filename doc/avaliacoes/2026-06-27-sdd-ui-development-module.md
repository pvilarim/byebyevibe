# Evaluation: SDD UI development module (Impeccable + Open Design + Pencil)

| Field | Value |
|-------|--------|
| **Date** | 2026-06-27 |
| **Evaluator** | OpenSpec session `add-sdd-ui-development-module` |
| **Candidate** | Aggregated module: [Impeccable](https://github.com/pbakaus/impeccable), [Open Design](https://github.com/nexu-io/open-design), [Pencil](https://www.pencil.dev) + shadcn/ui pipeline |
| **Decision** | **Adopted** — integrate as C1-UI add-on via `sdd-kit/install-ui-module.sh` (conditional on mitigations M1–M7) |
| **Scope** | C1-UI post core install; OD/Pencil runtime on demand |

## Executive summary

The UI module distributes pipeline documentation (Open Design → Pencil/Figma → shadcn → Impeccable) and a separate add-on script from C1 core. **Adopted** because it complements the SDD stack without structural conflict (see change `research.md`). Impeccable enters `--apply` only with confirmation (`--yes`); Open Design and Pencil are documented for manual installation.

## Problem it tried to solve

- Pipeline imported in `doc/design/000-*` and `001-*` without integration in the canonical guide or `sdd-kit/`
- Agents did not know when to install UI tools or how to adapt repos without shadcn
- Risk of installing Impeccable in DOCS_SPECS hubs without frontend

## What was analyzed

- `doc/design/000-impeccable-design-system-guia.md` and `001-pipeline-open-design-shadcn-impeccable.md`
- `openspec/changes/add-sdd-ui-development-module/research.md` — SDD compatibility matrix
- Supabase rule `030-supabase.mdc` precedent (SKIP gate by detection)
- `doc/avaliacoes/2026-03-26-headroom-context-compression.md` — phase-based evaluation model

## Fit in the SDD stack

| Tool | Relationship |
|------|--------------|
| **OpenSpec** | Orthogonal — governs features; UI module governs visual craft. Disambiguate `openspec/.../design.md` vs `DESIGN.md` (M1) |
| **GitNexus** | Complementary — `impact` before editing `components/ui/`; reindex after C1-UI (M5) |
| **Graphify** | Complementary — indexes `doc/design/*` after apply |
| **AGENTS.md / sdd-kit** | Short pointers in §2.11; Impeccable does not alter GitNexus blocks (M2) |

## Risks by workflow phase

| Phase | Risk | Notes |
|-------|------|-------|
| **Explore** | OD/Pencil outside the repo | Commit Phase 2 contract in the repo |
| **Propose** | Confusion `design.md` vs `DESIGN.md` | M1 table in `doc/design/002-ui-module-install.md` |
| **Apply** | Impeccable hook blocks mass writes | M4 — temporary `ignoreFiles` documented |
| **Archive** | None | `sdd-ui-module` spec promoted on archive |

## Expected vs observed gains

| Announced gain | Evaluation |
|----------------|------------|
| POC → production pipeline with guardrails | Validated in `topocnc-art`; requires per-repo adaptation |
| Impeccable anti “AI slop” | 44 deterministic rules; requires Node 24+ (M3) |
| Open Design rapid exploration | Optional; not in automatic `--apply` |
| Pencil in-repo prototyping | Optional; MCP on demand |

## Alternatives already in the stack

- shadcn/ui already listed in `openspec/project.md` for APP — no install procedure until this module
- SDD skills (`openspec-*`, `gitnexus`) — separate from Impeccable (M7)
- Guide §5.3 — point, do not duplicate pipeline in the canonical guide

## Decision and re-evaluation conditions

**Decision:** **Adopted** — C1-UI module in `sdd-kit/` with `install-ui-module.sh` and `doc/design/002-*`, `003-*`.

**Conditions to re-evaluate:**

- Bump repo minimum Node to 24+ LTS (separate change)
- Dedicated npm package for UI module (phase 2 — out of current scope)
- Proven conflict between Impeccable hook and session coordination

## References

- Change: `openspec/changes/add-sdd-ui-development-module/`
- Pipeline: `doc/design/001-pipeline-open-design-shadcn-impeccable.md`
- Compatibility: `openspec/changes/add-sdd-ui-development-module/research.md`
- [Impeccable](https://github.com/pbakaus/impeccable) · [Open Design](https://github.com/nexu-io/open-design) · [Pencil](https://www.pencil.dev)

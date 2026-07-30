**Issue:** —

## Why

The SDD hub (`gitnexus-graphify-openspec`) **has no root `README.md`**, and `sdd-kit/README.md` is operational only — the kit is invisible to people searching for *vibe coding* / *spec-driven* on GitHub, despite real differentiators (OpenSpec + GitNexus + Graphify, gates, profiles, session locks). The 2026-07-26 exploration mapped positioning, SEO, and competition: we need (1) to document that analysis as a persistent starting point and (2) to materialize discovery surfaces plus a product bias that improves first contact **without** turning the kit into an app boilerplate.

## What Changes

- **Canonical evaluation document** under `doc/avaliacoes/` (promoted from this change's `research.md`) + index row in the evaluations index — foundation for outreach and improvement backlog.
- **Root `README.md` (EN-first):** hero “From vibe coding to agentic engineering”, anti-boilerplate, demo `/opsx`, table of what's included (incl. **SDD metrics / calibrate-as-you-go** — `research.md` §12; no ML claim), short compare, CTA `install.sh --dry-run`, links to the pt-BR guide.
- **`sdd-kit/README.md`:** positioning intro + friendly C1/C2/G* map → human-readable names; keep operational sections.
- **Quickstart short-path** in the guide (`doc/sistema-sdd-pedro.md`): short “vibe coder in ~5 min” section pointing to README/kit (without duplicating the guide).
- **Cross-refs:** `AGENTS.md`, `openspec/project.md`, `doc/avaliacoes/README.md`.
- **Checklist `[MANUAL ACTION REQUIRED]`** for GitHub About + topics (not automatable in this repo).
- **Specs:** new capability `sdd-discovery-positioning`; delta in `sdd-install-kit` if the kit README must require discovery framing.
- **Product backlog (2026-07-26 decision):** Landing/Discord/one-liner/BMAD/GitHub brand/scaffold — **do not implement**. **P5 (GIF)** — pending `/opsx:explore` after README (ideally after name). **P10 (name) + EN translation** — roadmap post-README (`research.md` §11, `design.md` D10); **not** in this change.

## Capabilities

### New Capabilities

- `sdd-discovery-positioning`: Public discovery surfaces and SDD Kit positioning (root README, market evaluation, first-contact quickstart, topics/About checklist); “from vibe coding to agentic engineering” bias; forbids pretending to be an app scaffold.

### Modified Capabilities

- `sdd-install-kit`: `sdd-kit/README.md` MUST include positioning/discovery framing for newcomers (in addition to operational C1–C3/G* content).

## Impact

- New: `README.md` (root), `doc/avaliacoes/2026-07-26-sdd-discovery-positioning.md`
- Modified: `sdd-kit/README.md`, `doc/avaliacoes/README.md`, `doc/sistema-sdd-pedro.md` (quickstart section + changelog), `AGENTS.md` / template if needed, `openspec/project.md` (cross-ref)
- Specs: `openspec/specs/sdd-discovery-positioning/` (after archive); delta `sdd-install-kit`
- New dependencies: none
- **Non-goals:** app starter/boilerplate; Discord; landing/Pages; one-liner fame; GIF/asciinema in this change (pending explore post-README); rename/rebrand in this change (roadmap §11); full EN translation in this change (roadmap §11); adopt BMAD multi-persona; pursue “GitHub brand”; alter `/opsx` flow or MANIFEST payloads (except documentary mentions)
- **Post-apply roadmap (out of scope):** see `research.md` §11 — README → name → policy/waves EN → explore GIF; human chat remains pt-BR.
- **Issue:** — (issues API unavailable this session; no obvious duplicate in change history)
- Sources: `openspec/changes/add-sdd-discovery-positioning/research.md`

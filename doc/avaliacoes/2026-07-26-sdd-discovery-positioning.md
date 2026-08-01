# Evaluation: SDD Kit positioning and discovery (vibe coding → agentic engineering)

| Field | Value |
|-------|--------|
| **Date** | 2026-07-26 |
| **Evaluator** | Explore→propose session `add-sdd-discovery-positioning` |
| **Candidate** | SDD hub discovery surfaces (root README, About/topics, first-contact) — market/SEO/competition analysis |
| **Decision** | **Mixed** — P1–P4 + **P10 (ByeByeVibe)** **Adopted** (docs); GitHub slug rename = `[MANUAL ACTION]`; P5 / fame gaps **Deferred** or **Do not implement**; app scaffold **Non-goal** |
| **Scope** | Discovery documentation + specs (DOCS_SPECS profile); no application code |
| **Change** | [`add-sdd-discovery-positioning`](../../openspec/changes/archive/2026-07-30-add-sdd-discovery-positioning/proposal.md) |
| **Source research** | [`openspec/changes/archive/2026-07-30-add-sdd-discovery-positioning/research.md`](../../openspec/changes/archive/2026-07-30-add-sdd-discovery-positioning/research.md) |

## Executive summary

The SDD hub was invisible on GitHub discovery (no root `README.md`; kit README was operational only). The 2026-07-26 analysis mapped positioning “from vibe coding to agentic engineering”, SEO (topics/About), competition (Spec Kit / OpenSpec / BMAD / GSD vs vibe boilerplates), and product backlog. **We adopted** P1–P4 surfaces (EN README, evaluation, quickstart, friendly map) and, in follow-up (`rename-byebyevibe-public-name`), the **public name ByeByeVibe** (P10 docs; path `sdd-kit/` unchanged). **We did not** implement Landing, Discord, one-liner fame, app scaffold, BMAD multi-persona, or GitHub brand. GIF/i18n remain on the roadmap (`research.md` §11). GitHub slug rename → `byebyevibe` remains `[MANUAL ACTION]`.

## Problem it tried to solve

Discovery invisibility + first-contact friction for people arriving from *vibe coding*, without diluting the differentiator (control plane / install kit — not an app boilerplate).

## What was analyzed

- Explore 2026-07-26; GitHub API (stars/topics)
- Public READMEs: Spec Kit, OpenSpec, BMAD-METHOD, GSD
- AS-IS: `sdd-kit/README.md`, `doc/sistema-sdd-pedro.md`, `openspec/project.md`
- Complementary: `openspec/changes/explore-oss-coverage-gaps/research.md`

## Fit in the SDD stack

| Tool | Relationship |
|------|--------------|
| OpenSpec | `/opsx:*` flow is the README narrative demo; we **consume** the CLI |
| GitNexus | “Code graph” differentiator vs Spec Kit / BMAD / GSD |
| Graphify | “Knowledge graph” differentiator in discovery positioning |
| AGENTS.md / sdd-kit | Anti-overwrite + versioned C1/C2 payload = defensible pitch |

## AS-IS diagnosis (pre-apply)

| Surface | Pre-apply state | Effect |
|---------|-----------------|--------|
| Root `README.md` | **Missing** | Repo invisible in GitHub search |
| `sdd-kit/README.md` | Operational only | Does not serve vibe-coding newcomers |
| Canonical guide | Deep (v1.6.1) | High friction as first contact |
| About / topics | Not aligned to `vibe-coding` / SDD | Misses hot-topic traffic |

**Market hook (without pretending to be a boilerplate):**

> Vibe coding until the first PR. After that, agentic engineering.

## Adopted positioning

| Element | Copy |
|---------|------|
| Tagline | From vibe coding to shippable AI engineering. |
| Canonical phrase | The missing operating system between your coding agent and a maintainable repo. |
| Anti-positioning | Not another Next.js starter — the SDD control plane (OpenSpec + graphs + gates) your repo is missing. |
| Public name (P10) | **ByeByeVibe** (Adopted — docs); path/payload remains `sdd-kit/` |
| Legacy working title | “SDD Install Kit” / “SDD Kit” (replaced in discovery; `sdd-kit/` commands intact) |

## Key terms and GitHub SEO

High-traffic topics: `vibe-coding`, `spec-driven-development`, `context-engineering`, `agentic-coding`, `claude-code`, `cursor`, `agent-skills`, `agents-md`, `mcp`, `prd`.

### [MANUAL ACTION REQUIRED] — Rename repo + About + topics on GitHub

The agent **does not** change repository Settings. A human operator must apply:

1. **Repository rename:** Settings → General → Repository name: `gitnexus-graphify-openspec` → **`byebyevibe`**
2. **Local remote:** `git remote set-url origin git@github.com:pvilarim/byebyevibe.git` (or HTTPS equivalent)
3. **About** and **Topics** (below)
4. **Homepage** (optional): `https://pedrocodeart.netlify.app/`

**Suggested About (≤160 chars):**

> ByeByeVibe — Spec-Driven Development (SDD) install kit from vibe coding to shippable AI engineering. Control plane (OpenSpec + graphs + gates) for Cursor & Claude Code. Not a Next.js starter.

**Topics (minimum):**

- `vibe-coding`
- `spec-driven-development`
- `context-engineering`
- `claude-code`
- `cursor`

Optional: `agentic-coding`, `agent-skills`, `openspec`, `mcp`, `agents-md`.

**Where:** GitHub → repo Settings → General → Description / Topics / Rename.

## Semantic network (features ↔ projects)

```
VIBE CODING (pain/entry)
        │ "from vibe →"
        ▼
┌───────────────────────────────────────┐
│  THIS KIT (OS / control plane)        │
│  install + AGENTS.md + gates          │
└───────────────┬───────────────────────┘
     ┌──────────┼──────────┬────────────┐
     ▼          ▼          ▼            ▼
 OpenSpec   GitNexus   Graphify     Probity
 /opsx:*    code graph knowledge    enforceTdd
     │          │          │            │
     └──────────┴────┬─────┴────────────┘
                     ▼
              CI sdd-gates · session locks · metrics G4
```

## Competition — compare table (stars ≈ 2026-07-26, order of magnitude)

### Layer A — SDD frameworks (neighbors)

| Project | ★ (order) | They offer; we don't | We offer; they don't |
|---------|-----------|----------------------|----------------------|
| [github/spec-kit](https://github.com/github/spec-kit) | ~124k | Distribution, polish, site, GitHub brand | Triple OpenSpec+GitNexus+Graphify; C1/C2 kit; Probity; metrics; session locks |
| [Fission-AI/OpenSpec](https://github.com/Fission-AI/OpenSpec) | ~63k | The specs CLI (we consume it) | Graphs+CI+install kit+guide orchestration |
| [bmad-code-org/BMAD-METHOD](https://github.com/bmad-code-org/BMAD-METHOD) | ~51k | Multi-persona theatre | Less ceremony; brownfield; CI/TDD; dual-graph |
| [gsd-build/get-shit-done](https://github.com/gsd-build/get-shit-done) | ~65k | Long autonomy | Multi-IDE; Graphify+GitNexus; supply-chain |

### Layer B — vibe templates (same search, different product)

App scaffolds / boilerplates (Next, Bun, FastAPI, etc.) — **permanent non-goal** of this kit. The README appears in both searches with explicit disambiguation.

### Compact matrix

```
                 Spec    Multi-agent  Code graph  Knowledge  Install kit  CI/TDD
Spec Kit         ●●●●    ●●           ○           ○          ●●●          ●●
OpenSpec         ●●●●    ●●           ○           ○          ●●           ●
BMAD             ●●●     ●●●●         ○           ○          ●●●          ●●
GSD              ●●●     ●●●          ○           ○          ●●           ●
Vibe boilerplates ○      ○            ○           ○          ●●●● (app)   ●
THIS KIT         ●●●●    ●●           ●●●●        ●●●●       ●●●●         ●●●●
```

**Defensible differentiators:** (1) composite stack + anti-overwrite AGENTS.md; (2) `MANIFEST.yaml` payload + C2 upgrade; (3) APP/DOCS_SPECS/HYBRID profiles; (4) real gates; (5) session coordination; (6) SDD metrics G4 as retrospectives / calibrate-as-you-go (**no** ML claim).

## G4 Metrics in the discovery pitch

`sdd-metrics.sh` + cadence + playbook §2.17 = process retrospectives (volume, lead time, rework). Allowed framing: “calibrate as you go”. **Forbidden:** ML, self-learning agent, automatic kit adaptation. Detail: research §12 / design D11.

## Decisions by item (product backlog)

| ID | Improvement | Decision | Notes |
|----|-------------|----------|-------|
| P1 | README + topics + evaluation | **Adopted** | Root EN README + this evaluation + About/topics checklist |
| P2 | Vibe-coder quickstart in guide | **Adopted** | §2.0b in `doc/sistema-sdd-pedro.md` |
| P3 | Friendly C1/C2/G* map | **Adopted** | Intro in `sdd-kit/README.md` |
| P4 | Updatable compare table | **Adopted** | This section (dated stars) |
| P5 | Demo GIF / asciinema | **Deferred — pending explore** | After README (ideally after name); E1–E6 in research §6.3 |
| P6 | One-liner `npx` fame | **Do not implement** | `install.sh --dry-run` CTA is enough |
| P7 | Landing / GitHub Pages | **Do not implement** | D9 |
| P8 | Discord | **Do not implement** | D9 |
| P9 | App starter (auth/DB/deploy) | **Permanent non-goal** | Layer B |
| P10 | Rename / public name | **Adopted (ByeByeVibe)** | Display name + hero/Maintainer in docs; path `sdd-kit/` intact; GitHub slug `byebyevibe` |
| P11 | EN policy + i18n waves (public surface) | **Deferred — public launch** | Explore `explore-public-release-surface` (F2); **do not** hide folders via gitignore (F1/F6) |
| P12 | Root EN `CHANGELOG.md` (+ optional Releases) | **Deferred — public launch** | Explore `explore-public-release-surface` (F3/F4); canonical remains guide §14 until then |
| — | BMAD multi-persona | **Do not implement** | D9 |
| — | GitHub brand | **Do not implement** | D9 |
| — | Private ops repo split | **Deferred — only if real pain** | F5 in research; after P11 |

### README discovery v2 layout (`update-readme-discovery-v2`)

**Decision:** Hybrid **conversion + pedagogy** — value bullets and anti-boilerplate above the fold (before Get started); didactic Core tools table (What / Without it); dedicated User-friendly OpenSpec section for `/opsx:help`; Optional modules block; Calibrate as you go (G4) with explicit anti-ML framing.

**What changed vs v1:** Section order locked to 17-section outline; elevated Why install + anti-boilerplate; `/opsx:help` first-class in README; optional modules no longer buried in compare table only.

**Unchanged deferred backlog:** P5 (GIF/asciinema), P11/P12 (i18n waves / root CHANGELOG) remain deferred per D9/D10.

### Post-apply roadmap (research §11 / design D10)

```
① README + evaluation + quickstart   ← done (`add-sdd-discovery-positioning`)
② Explore→propose public name (P10) ← done
③ Apply rename/rebrand (ByeByeVibe) ← done; slug `byebyevibe` (manual)
④ README discovery v2 (hybrid layout) ← done (`update-readme-discovery-v2`): value bullets, core tools What/Without it, `/opsx:help`, optional modules block
⑤ EN policy + waves (+ root CHANGELOG.md) ← Deferred until public launch
   (research: openspec/changes/explore-public-release-surface/research.md · P11/P12)
⑥ Explore GIF/asciinema (P5)
⑦ Landing/Discord/one-liner — out of scope (D9)
```

## Risks by workflow phase

| Phase | Risk | Notes |
|-------|------|-------|
| Explore | Reopening fame gaps already closed (D9) | Non-goals checklist |
| Propose | Mixing rename/i18n/GIF in this change | D10 — separate changes |
| Apply | ML claim in metrics; omitting anti-boilerplate | Gate grep + D11 |
| Archive | Forgetting About/topics checklist | `[MANUAL ACTION REQUIRED]` below |

## Expected vs observed gains

| Announced gain | Evaluation |
|----------------|------------|
| Repo findable in ≤30s | **Expected** after README + manual About/topics |
| Newcomers understand “not a starter” | **Expected** via anti-positioning in hero |
| Operators keep ops docs | **Expected** — kit README prepend, ops intact |
| Immediate stars / SEO | **Partial** — depends on manual topics + time |

## Alternatives already in the stack

Without README/evaluation, the guide + operational `sdd-kit/README.md` already existed — insufficient for GitHub discovery. OpenSpec upstream covers the specs CLI; this hub orchestrates graphs + kit + gates.

## Decision and re-evaluation conditions

**Decision:** **Mixed** — P1–P4 surfaces **Adopted**; **P10 (ByeByeVibe)** **Adopted**; P5 (GIF) **Deferred**; **P11/P12** (i18n + root CHANGELOG) **Deferred until public launch** (`explore-public-release-surface`); P6–P9 / BMAD / brand / Landing / Discord **Do not implement** / **Non-goal**.

**Conditions to reopen:**

- **P5:** explore closes E1–E6 (format, asset path, recording script, drift)
- **P11/P12:** trigger = launch / treating the repo as public for third parties — `openspec/changes/explore-public-release-surface/research.md`
- **Fame gaps (P6–P8):** only with a new OpenSpec proposal and explicit human confirmation (today D9)

## References

- Full research: `openspec/changes/archive/2026-07-30-add-sdd-discovery-positioning/research.md`
- Design (D9–D11): `openspec/changes/archive/2026-07-30-add-sdd-discovery-positioning/design.md`
- Public surface (deferred): `openspec/changes/explore-public-release-surface/research.md`
- Root README: [`README.md`](../../README.md)
- Guide: `doc/sistema-sdd-pedro.md` §2.0b
- agents.md: https://agents.md/
- PR: [#54](https://github.com/pvilarim/gitnexus-graphify-openspec/pull/54)

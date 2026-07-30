# Design — SDD Kit discovery and positioning

## Context

- Explore 2026-07-26: root README missing; *vibe coding* audience does not find the kit; competitors (Spec Kit ~124k★, OpenSpec ~63k★, BMAD ~51k★, GSD ~65k★) dominate discovery with hero + demo + topics.
- Hub profile: **DOCS_SPECS** — this change is documentation/specs/kit README; no application code.
- Dual bias requested by Pedro: (A) improve outreach; (B) use the analysis as a starting point to improve the product — P0/P1 in this change; P2+ as explicit backlog.
- Persistent research: `openspec/changes/add-sdd-discovery-positioning/research.md` (promote to `doc/avaliacoes/` on apply).

## Goals / Non-Goals

**Goals:**

- Make the hub findable and understandable in ≤30s for people arriving from *vibe coding*.
- Anchor the “from vibe coding to agentic engineering” narrative in versioned artifacts (evaluation + README + kit README + quickstart).
- Expose real differentiators (triple stack, versioned kit, gates, session locks) without promising app scaffold.
- Record product backlog P5–P10 for future changes.
- Normative spec so we do not regress (root README MUST exist).

**Non-Goals:**

- App boilerplate (Layer B) — permanent non-goal this cycle.
- GIF, GitHub Pages, Discord, repo rename — follow-up / human decision.
- Alter `install.sh` / MANIFEST payloads / `/opsx` flow (except documentary mentions).
- Translate the entire guide to EN or the entire README to pt-BR.
- Update stars in CI — dated values in the evaluation are enough.

## Knowledge sources consulted (R8)

- `openspec/changes/add-sdd-discovery-positioning/research.md`
- `sdd-kit/README.md`, `doc/sistema-sdd-pedro.md`, `openspec/project.md`
- `doc/avaliacoes/README.md` + evaluation TEMPLATE
- Public READMEs: Spec Kit, OpenSpec (demo `/opsx` pattern)
- GitHub API 2026-07-26 (stars/topics) — see research §5
- `openspec/changes/explore-oss-coverage-gaps/research.md` — complementary (tooling gaps)

## Decisions

### D1: EN on root README; pt-BR in evaluation and guide

- **Choice:** GitHub discovery = English; operational depth = pt-BR (already dominant in the guide).
- **Alternative:** fully bilingual README → rejected (duplication and drift).
- **Mitigation:** explicit “Full guide (pt-BR)” link in the README.

### D2: Tone “from vibe → agentic”, not “stop vibe coding”

- **Choice:** empathetic upgrade path.
- **Alternative:** adversarial tone (“end of vibe coding”) → alienates the target search audience.

### D3: Evaluation in `doc/avaliacoes/` as starting document

- **Choice:** `2026-07-26-sdd-discovery-positioning.md` mirrors `research.md` (may be editorial copy + **Adopted** status for P0/P1 surfaces and **Deferred** for P5–P10).
- **Alternative:** only `research.md` in the change → lost after archive for human navigation; evaluations are already source 6.

### D4: Short README; guide gains only a quickstart

- **Choice:** README ≤ ~200 lines; new short subsection in the guide (e.g. §2.0b or block under §2.0) “First contact / vibe coder”.
- **Alternative:** rewrite guide §1–2 → out of R4 scope.

### D5: Kit README gains intro, does not lose ops

- **Choice:** prepend one section “What this is / who it's for” + friendly scenario table; rest intact.
- **Alternative:** separate marketing README in `sdd-kit/DISCOVERY.md` → one more file; prefer a single entry point.

### D6: Topics/About = manual action

- **Choice:** checklist in README or evaluation with `[MANUAL ACTION REQUIRED]`; agent does not change GitHub settings.
- **Alternative:** GitHub CLI write → unavailable / out of policy (gh read-only).

### D7: Product backlog in design + evaluation, not in this change's tasks

- This change's tasks cover P1–P4 only.
- P5 (GIF), P10 (name), EN translation and fame gaps: see D9 + **D10** (roadmap §11 in research) — **do not** mix into apply.

### D8: No mandatory MANIFEST bump

- Only kit README changes (not a checksumed install payload template, unless `sdd-kit/README.md` is in MANIFEST).
- Verify on apply: if kit `README.md` is in MANIFEST, run `gen-manifest-checksums.sh`; otherwise no version bump for copy alone.

### D9: Competition gaps — closed scope except visual demo (2026-07-26)

Human decision after explore trade-offs:

| Item | Decision |
|------|----------|
| Landing / GitHub Pages | **Do not implement** |
| Discord | **Do not implement** |
| One-liner fame (`npx` viral) | **Do not implement** (keep CTA `install.sh --dry-run`) |
| App scaffold (auth/DB/deploy) | **Do not implement** |
| BMAD multi-persona | **Do not implement** |
| GitHub brand (Spec Kit) | **Not implementable / do not pursue** as strategy |
| Rename / new public name (P10) | **Not in this change** — **yes on roadmap** after README (research §11); own explore→propose |
| Full EN translation | **Not in this change** — **yes on roadmap** after stable name (research §11) |
| GIF / asciinema (P5) | **Not in this change** — integration explore (E1–E6) **after** README and, ideally, stable name |

On apply of `add-sdd-discovery-positioning`: flow demo stays **text-only** in README (like OpenSpec); no binary asset; in canonical evaluation register P5 as **Deferred — pending explore**; P10/i18n as **Deferred — roadmap §11**.

### D10: Sequence roadmap — README → name → EN → GIF (2026-07-26)

Pre-apply record (human request). Detailed canonical source: `research.md` §11.

**Mandatory administration order (OpenSpec backlog, not mega-PR):**

1. **Apply** `add-sdd-discovery-positioning` (P1–P4) — working title ok  
2. **Explore→propose→apply** public name / rebrand (P10)  
3. **Propose** policy “new artifacts = EN; chat = pt-BR” + translation **waves**  
4. **Explore** GIF/asciinema (P5) → propose only if integration is clear  
5. Landing/Discord/one-liner/scaffold/BMAD/brand — out (D9)

**Condensed rationale:** immediate discovery without blocking on rename/i18n; name before translation avoids double work; GIF after stable narrative/brand; pt-BR chat permanent for Pedro's velocity.

### D11: README mentions SDD Metrics as process calibration (2026-07-26)

Pre-apply explore: `sdd-metrics.sh` + cadence + playbook §2.17.

- **Include** in README (What's included / short blurb) the G4 differentiator.
- **Framing:** retrospectives / “calibrate as you go” / signal grows as you archive — **human** applies 1 insight → 1 adjustment.
- **Do not** claim ML, self-learning agent, or automatic kit adaptation.
- Detail and allowed/forbidden copy: `research.md` §12.
- Does not require new code tasks — copy only on apply of existing tasks 1.x/2.x.

## Risks / Trade-offs

| Risk | Mitigation |
|------|------------|
| Attract wrong users (want Next.js starter only) | Anti-positioning in hero (D2 + research §2) |
| Outdated stars | Only in evaluation with date; README uses “order of magnitude” or omits numbers |
| Drift research ↔ evaluation | Apply task: diff or conscious copy; Gate grep of key phrases |
| C1/G4 jargon remains in kit | Friendly table (P3) at top of kit README |
| Expectation of Discord/GIF/landing/rename/i18n in this apply | D9 + D10: out of scope; roadmap §11 |
| Translate everything before rename | D10: forbidden — stable name first |

## Migration Plan

1. Apply creates/updates docs files listed in proposal.
2. Human applies About + topics on GitHub (checklist).
3. Rollback: revert change commits; remove root `README.md` if needed (previous state = absent).

## Open Questions

| # | Question | Status |
|---|----------|--------|
| Q1 | Final public name / repo rename? | **Deferred** — explore `explore-sdd-kit-public-name` after README apply (D10 / research §11); working title “SDD Kit” in this change |
| Q2 | Discord/site badge in README? | **Closed — no** (D9) |
| Q3 | How many competitors in README compare? | Spec Kit, OpenSpec, BMAD + “vibe templates” line |
| Q4 | How to integrate GIF/asciinema? | **Open — `/opsx:explore`** after README (and ideally after name); research §6.3 E1–E6 |
| Q5 | Exact pt-BR→EN inventory? | **Deferred** — change `add-english-docs-policy` + waves (D10) |

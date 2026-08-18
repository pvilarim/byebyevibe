## Context

Explore 2026-08-17: the operator wants GitNexus-style README chrome (shields.io + Actions badges) and a **free MIT** license on ByeByeVibe, plus a durable warning that the kit **points at** other tools whose licenses are not MIT.

Current state (verified 2026-08-17):

- Hub `README.md` has no badge row; GitHub `license` metadata is `null`; no `LICENSE` / `NOTICE.md`.
- Latest Release is `v1.15.1`; workflow `.github/workflows/sdd-gates.yml` is active — those two badges are honest.
- There is no npm package (no root `package.json`) and no OpenSSF Scorecard publishing — those GitNexus badges MUST NOT be copied.
- Discord / site badges remain **Do not implement** (discovery D9).
- `sdd-kit/README.md` is **not** a MANIFEST path; `doc/byebyevibe-guide.md` **is**. Touching the guide would force checksums + kit version bump.

This is docs-only. `install.sh` already does not copy a license file; the design records that as a **forbidden** future behavior, not as a script change.

## Goals / Non-Goals

**Goals:**

- SPDX-detectable MIT on the hub (`LICENSE` at repo root).
- Honest hero badges: Release, SDD Gates, License: MIT.
- Visitors and kit-only fetchers can see that composed tools keep **their** licenses, with GitNexus called out as PolyForm Noncommercial (commercial use of *GitNexus* is not covered).
- Spec pins the disclosure so a later README edit cannot imply “the stack is MIT”.

**Non-Goals:**

- Relicensing or vendoring GitNexus / Graphify / OpenSpec / Probity / Impeccable / OSV / Renovate.
- Copying `LICENSE` or `NOTICE.md` into consumer repos via `install.sh` / `upgrade.sh`.
- Guide (`doc/byebyevibe-guide.md`) or MANIFEST/checksum work.
- OpenSSF Scorecard GitHub Action, npm badge, Discord badge, GIF (P5).
- Reordering or centering the whole README (v2/v3 section order stays).
- Legal advice; NOTICE is disclosure of recorded SPDX ids, not counsel.

## Decisions

### D1. Two-layer licensing (MIT vs NOTICE)

| File | Covers | Must not contain |
|------|--------|------------------|
| `LICENSE` | Original ByeByeVibe work (hub docs, `sdd-kit/` payload, skills authored here) | Third-party table (breaks GitHub SPDX) |
| `NOTICE.md` | Composed / optional / supply-chain tools **not relicensed** | MIT legal text (that lives only in `LICENSE`) |

Alternative considered: one README table only → rejected: GitHub would still show `license: null` and kit-only fetch would have no named NOTICE target on the hub clone. Alternative: put third-party text inside `LICENSE` → rejected: SPDX detection and “MIT free” badge would mix GitNexus PolyForm into the same file.

### D2. MIT text and copyright

Use the canonical MIT License body (OSI / GitHub choosealicense template). Copyright line:

```
Copyright (c) 2026 Pedro Vilarim
```

Filename: `LICENSE` (no extension) so GitHub’s license API detects `MIT`.

### D3. NOTICE table (recorded 2026-08-17)

| Tool | Role | License | Link |
|------|------|---------|------|
| OpenSpec | Core CLI / `/opsx:*` | MIT | https://github.com/Fission-AI/OpenSpec |
| GitNexus | Core CLI / code graph | PolyForm Noncommercial 1.0.0 | https://github.com/abhigyanpatwari/GitNexus |
| Graphify | Core CLI / knowledge graph | Apache-2.0 | https://github.com/Graphify-Labs/graphify |
| Probity | Optional G2 | MIT | https://github.com/nizos/probity |
| Impeccable | Optional C1-UI | Apache-2.0 | https://github.com/pbakaus/impeccable |
| OSV-Scanner | CI G8 | Apache-2.0 | https://github.com/google/osv-scanner |
| Renovate | APP supply chain | AGPL-3.0 | https://github.com/renovatebot/renovate |

GitNexus caveat (normative wording, one sentence, not just “see their LICENSE”):

> GitNexus is licensed under PolyForm Noncommercial 1.0.0 — **not MIT**. Installing or using GitNexus is accepting *their* terms; that license does not cover commercial use of the GitNexus software (they offer a separate Enterprise product). ByeByeVibe’s MIT license does not change that.

Renovate caveat (already in G8 design F2): use as the GitHub App is OK; do not redistribute a modified fork.

GitNexus skills under `.claude/skills/gitnexus/` are **not** in `sdd-kit/` (they arrive with the GitNexus install). NOTICE MUST NOT claim the kit vendors those files.

### D4. Honest badge row (hero chrome only)

Insert after the tagline (`**From vibe coding to shippable AI engineering.**`) and before the dual-naming paragraph. GitHub HTML `<p>` + `<a>` + `<img>` (shields.io / Actions SVG). No `target="_blank"` (spec already: GitHub sanitizer strips it).

Allowed badges (all three required):

1. GitHub Release → `https://img.shields.io/github/v/release/pvilarim/byebyevibe` linking to `/releases/latest`
2. SDD Gates → `https://github.com/pvilarim/byebyevibe/actions/workflows/sdd-gates.yml/badge.svg` linking to that workflow
3. License: MIT → `https://img.shields.io/badge/License-MIT-yellow.svg` linking to `LICENSE`

Forbidden badges in the root README: npm version, OpenSSF Scorecard, Discord, PolyForm, any license that is not this repo’s MIT.

Do **not** add Cursor/Claude decorative shields in this change (R4). Optional later.

Do **not** wrap the rest of the README in `<div align="center">`. Optional `align="center"` on the badge `<p>` only is allowed.

### D5. Disclosure placement without a new README section

v2/v3 section order stays. No `## Licenses` heading.

- **Stack & companions:** one sentence after “We compose OpenSpec…” pointing at `NOTICE.md` and naming GitNexus PolyForm Noncommercial.
- **Docs table:** two rows — `LICENSE` (MIT — this repository), `NOTICE.md` (licenses of composed tools).

### D6. Kit README is self-contained; install does not copy licenses

Lightweight fetch / kit-only trees may not include hub `NOTICE.md`. `sdd-kit/README.md` MUST include a short license paragraph that names MIT for payload files **and** the GitNexus PolyForm caveat inline (plus the other core/optional SPDX ids). A link to hub `NOTICE.md` is extra, not a substitute.

`sdd-kit/install.sh` / `upgrade.sh` / MANIFEST MUST NOT gain `LICENSE` or `NOTICE.md` entries. Consumer repos keep their own license. Apply MUST NOT add those files under `sdd-kit/templates/`.

Guide left untouched (checksummed MANIFEST path) — kit README is the operator-facing copy for C1.

### D7. Spec delta shape

**ADDED** requirements only on `sdd-discovery-positioning` (LICENSE, NOTICE, honest badges, composed-stack disclosure on README + kit README). Do **not** MODIFY the section-order requirement.

## Risks / Trade-offs

| Risk | Mitigation |
|------|------------|
| Visitor reads MIT badge and assumes GitNexus is MIT | NOTICE + Stack sentence + kit README all name PolyForm Noncommercial and “not relicensed” |
| LICENSE file with extra NOTICE text breaks GitHub SPDX | D1: MIT-only `LICENSE` |
| Kit-only fetch misses hub NOTICE | D6: inline paragraph in `sdd-kit/README.md` |
| `install.sh` later copies LICENSE over a consumer’s Apache/proprietary file | Spec + tasks **Forbidden**; no MANIFEST entry |
| Upstream licenses change | NOTICE dated 2026-08-17; Type A/B doc fix when noticed — do not pin “forever” |
| Badge URLs 404 if repo slug changes | Current slug `pvilarim/byebyevibe`; rename remains a manual GitHub action |
| Centering the whole README fights the didactic section order | Badge `<p>` only; body stays left-aligned |

## Migration Plan

1. Apply writes `LICENSE`, `NOTICE.md`, README hero/Docs/Stack edits, kit README paragraph, spec delta (at archive).
2. GitHub license API updates on next crawl after `LICENSE` is on `master` — no extra operator step.
3. Rollback: revert the change commits (four files + spec).

## Open Questions

None — operator locked 2026-08-17: MIT; NOTICE.md separate; GitNexus commercial caveat explicit; hub + kit README; no consumer copy; no guide bump.

## Context

`sdd-kit/README.md` declares its own version in the H1 (`# ByeByeVibe — sdd-kit v1.6.1`), duplicating `MANIFEST.yaml` `version:` with nothing enforcing agreement. The duplication has already drifted twice:

```
 release   MANIFEST   guide §14   sdd-kit/README.md H1
 ───────────────────────────────────────────────────────
 1.6.1      1.6.1       1.6.1       v1.6.1     ← in sync
 1.7.0      1.7.0       1.6.1 ✗     v1.6.1  ✗  ← both headers drift
 1.8.0      1.8.0       1.8.0 ✓     v1.6.1  ✗  ← guide header fixed, kit README missed
 1.8.1      1.8.1       1.8.1 ✓     v1.6.1  ✗
 1.8.2      1.8.2       1.8.2 ✓     v1.6.1  ✗
 1.9.0      1.9.0       1.9.0 ✓     v1.6.1  ✗  ← current state
```

The 1.8.0 changelog explicitly claims it "fixes the pre-existing guide header 1.6.1 vs MANIFEST 1.7.0 mismatch" — it fixed one of the two headers and left the other. That is the signature of an unenforced invariant, not of carelessness: the release ritual touches `MANIFEST.yaml` and the guide changelog, and the kit README is not on the path.

The guide is on the same path and has the same defect. It carries **two** version claims, and 1.9.0 updated only one:

```
 doc/byebyevibe-guide.md:5    "Canonical install guide (v1.8.2)"   ✗ one release behind
 doc/byebyevibe-guide.md:22   "**Guide version:** 1.9.0"           ✓
 sdd-kit/MANIFEST.yaml        guide_version: "1.9.0"               ← authority
```

Three declared version strings across two files, one authority each in `MANIFEST.yaml`, and zero enforcement. All three have drifted at least once.

`sdd-kit/README.md:124` already states the rule in prose — *"`MANIFEST.yaml` `version` MUST match changelog §14 of `doc/byebyevibe-guide.md` and `openspec/project.md` Cross-references"* — and does not include itself in that rule.

Constraint that shapes the whole design: `sdd-kit/verify.sh` is **not** a MANIFEST-tracked template. It lives at the kit root and travels to consumers as part of the `sdd-kit/` copy. Editing it changes no `sha256:` field, so `gen-manifest-checksums.sh` does not need to run and the kit-integrity check stays green.

## Goals / Non-Goals

**Goals:**

- Make a mismatch between any **declared** version string and its MANIFEST authority a hard failure of `bash sdd-kit/verify.sh` on the hub — the kit README H1 against `version:`, the two guide header claims against `guide_version:`.
- Correct every stale claim in `sdd-kit/README.md` against kit 1.9.0 reality, and every root-README statement that contradicts it.
- Keep the failure mode legible: an operator who sees the FAIL should know which two files disagree and what to type.
- Leave consumer repos untouched — no template diff, no new CI failure mode for anyone who installed the kit.

**Non-Goals:**

- Enforcing that guide **§14's latest changelog entry** matches MANIFEST. The changelog is prose with dated entries; "the latest version in §14" is a heuristic parse that would fire falsely on a release-in-progress commit. The guide's two *header* claims are gated instead — fixed position, single value each. The prose rule at kit README:124 continues to cover §14.
- Enforcing `openspec/infra.md`'s `kit-version` marker. That marker is owned by `verify-infra.sh` and is intentionally a *last observed* value, not a *declared* value — gating it would fail every repo between a bump and the next `verify-infra --write`. This change refreshes it once by hand.
- Opening the root README's tool links in a new tab. See Decision 6.
- Renaming the `sdd-kit/` directory or introducing a root `CHANGELOG.md`.

## Decisions

### D1 — Gate the visible strings, not hidden markers

**Chosen:** parse the semver token out of each declared claim by position — the kit README's first `# ` heading, the guide's `Canonical install guide (vX.Y.Z)` blockquote, and the guide's `**Guide version:**` line — with `grep -oE 'v?[0-9]+\.[0-9]+\.[0-9]+'` on the matched line.

**Alternative rejected:** add HTML comment markers (`<!-- kit-version -->1.10.0<!-- /kit-version -->`) as `openspec/infra.md` does.

Rationale: the visible string is what a reader believes. A marker-based gate would let the visible string rot while the hidden one passes — reintroducing the exact class of defect being fixed, with extra machinery. The marker pattern earns its keep in `infra.md` because a script *writes* that file; nothing writes the kit README or the guide header.

### D1b — Each claim is checked against its own MANIFEST authority

```
 sdd-kit/README.md  H1                         ──▶ MANIFEST version:
 doc/…-guide.md     "Canonical install guide"  ──▶ MANIFEST guide_version:
 doc/…-guide.md     "**Guide version:**"       ──▶ MANIFEST guide_version:
```

`MANIFEST.yaml` already carries both `version:` and `guide_version:` as separate fields, and they are allowed to diverge (a docs-only guide revision need not bump the payload). Collapsing them into one comparison would forbid a divergence the manifest explicitly models. Three independent comparisons, three independent FAIL lines.

### D2 — FAIL, not WARN

A WARN would have been ignored for three releases, which is empirically what happened to the prose rule at kit README:124. The invariant is cheap to satisfy (edit one string in the same commit as the bump) and the check is a string comparison between files that always travel together, so a false positive is close to impossible.

**Reach of that FAIL, stated precisely.** `sdd-gates.yml` runs `bash sdd-kit/verify.sh` in a step marked `continue-on-error: true` ("sdd-kit verify (report-only)"), because `verify-infra.sh` FAILs on knowledge CLIs that are absent from any runner. So the gate's actual enforcement is:

```
 surface                          effect of a version mismatch
 ────────────────────────────────────────────────────────────────
 local `bash sdd-kit/verify.sh`   exit 1  ← fail-closed
 CI sdd-gates                     FAIL line in log, step green, merge unblocked
 branch protection                unaffected (verify.sh is not a required check)
```

That is strictly better than the status quo (nothing at all) and it catches the release ritual at the moment the operator runs `verify.sh`, which §2.8 requires. It is *not* server-side enforcement. Promoting it to blocking is a live option — see Open Questions.

### D3 — Degrade, don't fail, when a claim is absent or unparseable

Per claim, four outcomes:

```
 file present?   claim line found?   token parses?   matches authority?   outcome
 ─────────────────────────────────────────────────────────────────────────────────
 no              —                   —               —                    INFO  skip
 yes             no                  —               —                    WARN  no claim to check
 yes             yes                 no              —                    WARN  unparseable
 yes             yes                 yes             no                   FAIL  ← the gate
 yes             yes                 yes             yes                  OK
```

The WARN rows matter: a consumer that vendored `sdd-kit/` and rewrote the README header for its own project — or a repo that received expanded files without the guide — must not be blocked by the hub's release hygiene. The gate polices a claim that exists; it does not mandate that the claim exist. This also means the guide checks are naturally inert in consumer repos, which never receive `doc/byebyevibe-guide.md` (it is not a MANIFEST-tracked template).

### D4 — Place the gate in the hub-only band of `verify.sh`

`verify.sh` already has a hub-only band (kit-integrity, then `scripts/`↔`templates/scripts/` parity), both guarded on `-d sdd-kit/templates`. The version gate is guarded per file instead, because a consumer may hold the kit README without holding `templates/`. It goes immediately before kit-integrity so version identity is checked before file identity: if the files disagree about *which release this is*, checksum results are the less interesting news.

`verify.sh` already extracts MANIFEST `version:` at the top for its `Kit version:` banner line. Reuse that value and add one `sed` for `guide_version:` rather than re-parsing twice.

### D5 — Minor bump to 1.10.0, not patch to 1.9.1

A new fail-closed gate changes what `verify.sh` does. The kit's own history sets the precedent: 1.8.1 was docs-only (patch, checksums unchanged), 1.8.0 added script behavior (minor).

**Verified 1.10.0 sorting risk:** `scripts/bootstrap-sdd.sh:version_ge` splits on `.` and compares fields with integer arithmetic (`(( a2 > b2 ))`), so `1.10.0 > 1.9.0` evaluates correctly — no lexicographic comparison anywhere in the kit. `upgrade.sh` compares `--to` against MANIFEST with string equality only. First two-digit minor in the kit's history, and it is safe.

### D6 — `target="_blank"` on the root README tool links is not implementable

GitHub's markdown pipeline sanitizes rendered HTML against an attribute allowlist; for `<a>` it keeps `href` (and injects its own `rel`) and **strips `target`**. Markdown itself has no new-tab syntax. Writing `<a href="…" target="_blank">` would therefore ship uglier source that renders identically to the current links — cost with no benefit.

What actually reaches the goal, if it resurfaces: readers can cmd/ctrl-click or middle-click any link; and if the README is ever republished outside github.com (a docs site, the maintainer's portfolio), that renderer's own sanitizer settings decide, so the decision belongs to that surface, not to this file. Recorded in the proposal's Not-in-scope so it is not re-attempted per-release.

### D7 — Root README drops HYBRID rather than annotating it

The kit README keeps its deprecation line (operators running `--profile HYBRID` need to find it). The root README is a discovery surface: `Profiles: APP · DOCS_SPECS` with the existing link to the kit README is the whole story a first-contact visitor needs, and a deprecated alias in the CTA is noise that invites the exact question the 1.9.0 §1.6 rewrite was meant to eliminate.

### D8 — Fix the Docs-table language cell to `EN`, don't translate anything

`sdd-kit/README.md` is already fully English and `sdd-docs-language` spec makes English canonical for that path and forbids PT residue. The `pt-BR (+ EN intro)` label is stale metadata describing a file that no longer exists in that form. One-cell edit; no content is translated by this change.

## Risks / Trade-offs

| Risk | Mitigation |
|------|------------|
| A future release bumps MANIFEST and the gate reddens `verify.sh` mid-release, before the README edit lands | That is the gate working. Both edits belong in one commit; the FAIL message names the file and the expected string so the fix is mechanical |
| A consumer holds `sdd-kit/README.md` with a custom H1 and gets blocked | D3's WARN row: unparseable header → WARN, exit unchanged |
| Two-digit minor (`1.10.0`) breaks a comparison somewhere | Audited: only `bootstrap-sdd.sh:version_ge` compares versions and it is field-wise integer arithmetic; `upgrade.sh` uses equality. No `sort -V`, no string `<`/`>` on versions in the kit |
| README-currency requirements in `sdd-install-kit` become a maintenance burden (every kit feature must be documented in the kit README) | Deliberate. That obligation is what was missing — the skills shipped in 1.8.0 were never announced in the kit README because nothing required it. The spec names the categories, not an exhaustive file list |
| The `verify.sh` edit drifts from consumer copies of `verify.sh` | Pre-existing property of `verify.sh` (unversioned, not checksum-tracked) and unchanged by this work; C2 upgrade copies the kit root wholesale |

## Migration Plan

Single commit on `claude/sdd-kit-docs-update-yj6yhc`, docs + one script. No data, no deploy, no consumer action. Rollback is `git revert` — reverting restores the prior README and removes the gate together, so no intermediate state can fail.

Order matters within the commit: bump `MANIFEST.yaml`, the kit README H1, and both guide header claims **before** running `bash sdd-kit/verify.sh`, or the new gate fails on its own introduction. The guide's `v1.8.2` blockquote is already wrong today, so the gate would fail on arrival if the header fixes were deferred to a follow-up.

## Open Questions

**Q1 — Should the version-sync check also be a blocking CI step?** — **RESOLVED: no. Keep it advisory in CI** (operator decision, 2026-08-05). The gate stays fail-closed locally and report-only in CI; this change ships zero file diff to consumers and regenerates no checksums. Revisit only if header drift recurs *after* the local gate exists — that would be evidence the local gate is insufficient rather than merely unenforced. Rationale for the alternative is kept below for that revisit.

As designed, the check is fail-closed locally and advisory in CI, because its only CI carrier is the `continue-on-error: true` verify.sh step (see D2). Since the defect being fixed is *"the release ritual forgot to update a string"*, and the release ritual ends in a PR, server-side enforcement is where it would actually bite.

Making it blocking means a new dedicated step in `sdd-gates.yml` that runs only the version comparison — not the whole of `verify.sh`, whose report-only status is load-bearing for `verify-infra.sh`. Consequences:

- `sdd-kit/templates/.github/workflows/sdd-gates.yml` changes → it **is** a MANIFEST-tracked template → `gen-manifest-checksums.sh` must run, and the C2 upgrade delivers a real file diff to consumers (this change would otherwise deliver none).
- Consumer risk is low: consumers receive neither `sdd-kit/README.md` nor the guide, so per D3 the check degrades to INFO skip and cannot redden their CI. Hub-style DOCS_SPECS distributors that *do* carry the kit README get the enforcement they presumably want.
- Cost: the shell logic would live in two places (verify.sh and the workflow) unless extracted into a small `scripts/verify-version-sync.sh` that both call — which is a third template and a wider change.

Deferred to the operator because it converts a docs-hygiene change into a consumer-facing CI change, and because it is cleanly addable later without rework.

**Q2 — Deferred, non-blocking.** Whether guide §14's latest changelog entry should be gated (rejected here as heuristic — see Non-Goals). If drift recurs in §14 specifically, that is the change to write.

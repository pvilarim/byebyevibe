## Why

The repository has no git tags (`git tag -l` is empty) and no GitHub Releases. Versioning lives entirely in `sdd-kit/MANIFEST.yaml` (`version:` for the `sdd-kit/` payload, `guide_version:` for `doc/byebyevibe-guide.md`), with the prose changelog under `doc/byebyevibe-guide.md` → `## Guide changelog`. Nobody can point at "which commit is 1.11.0" without opening the MANIFEST at that point in history, and nobody can download the kit without the `git clone --filter=blob:none --sparse` dance documented as the "Lightweight fetch recipe" (guide §1.6) — a workaround that exists precisely because there is no simpler downloadable artifact.

This was recorded as **F4** in `openspec/changes/explore-public-release-surface/research.md` and deferred to "Launch / public repo". That point has been reached; the deferral was reopened as issue #350.

The prerequisite with real substance is already built: `scripts/verify-release-readiness.sh` (change `add-release-readiness-gate`, issue #348) turns version-sync, kit-integrity, and hub↔templates parity into a single repo-state check with its own exit code. A release can therefore be gated on a check that means "this commit is internally consistent", rather than on a green CI run that mixes in environment noise.

## What Changes

- New `scripts/release-notes.sh <version>` — prints the `### <version> (YYYY-MM-DD)` block from `doc/byebyevibe-guide.md` `## Guide changelog`, verbatim, exiting non-zero when the section is absent or empty. The single source of release-note text; nothing is rewritten or duplicated.
- New `scripts/cut-release.sh <version>` — the operator-run entry point. Refuses to tag unless every precondition holds (clean tree, on the default branch, synced with `origin`, `version:` equals `guide_version:`, both equal the requested version, changelog section resolvable, `verify-release-readiness.sh` green, tag not already present), then creates the annotated tag `v<version>` and pushes it.
- New `.github/workflows/release.yml` — triggered by pushing a `v*` tag. Re-runs `verify-release-readiness.sh` on the tagged commit, builds the kit tarball plus its `.sha256` sidecar with `git archive`, and publishes a GitHub Release via the preinstalled `gh` CLI, body taken from `scripts/release-notes.sh`. Runs with `permissions: contents: write`, isolated in its own workflow file so `sdd-gates.yml` keeps `contents: read`.
- **Single tag axis.** `v<version>` only, tracking `version:`. `cut-release.sh` refuses to tag when `version: != guide_version:`, which converts the currently-unwritten "the two axes move in lockstep" assumption into an enforced invariant with a loud failure the day it stops holding. The `kit-v*` / `guide-v*` split floated in issue #350 is **not** adopted — see design D1.
- **Trigger model: push of a matching tag.** Recorded decision required by the issue's acceptance criteria; see design D2.
- `doc/byebyevibe-guide.md` — new §2.18 documenting the release procedure, and a pointer in §1.6 offering the release tarball as the simpler alternative to the lightweight fetch recipe (the recipe stays, as the only option for unreleased `master`).
- `sdd-kit/MANIFEST.yaml` — `version:` and `guide_version:` bumped 1.11.0 → 1.12.0 in lockstep; `sdd-kit/README.md` H1 synced; changelog entry added.

Hub-only: nothing new is added under `sdd-kit/templates/` and no MANIFEST template entry is created, because consumer repositories install the kit — they do not release it. No template bytes change, so no checksums change (same shape as the 1.10.0 release).

## Capabilities

### New Capabilities

- `sdd-release-flow`: how a release is cut — tag naming and the single-axis invariant, the preconditions that must hold before tagging, where release-note text comes from, what the published artifact contains, and what "reproducible from the tagged commit" means for it.

### Modified Capabilities

None. `sdd-ci-gates` is untouched: its requirements scope `.github/workflows/sdd-gates.yml`, which this change does not edit, and its "sole authorized external Action" exception is respected because the release workflow uses the preinstalled `gh` CLI instead of a third-party release Action (design D6).

## Impact

- New `scripts/release-notes.sh`, `scripts/cut-release.sh` — hub-only, no `sdd-kit/templates/` mirror. The hub↔templates parity check iterates over existing templates, so live scripts without a template counterpart do not trip it.
- New `.github/workflows/release.yml` — second workflow in the repository; the first one that requests write permissions, scoped to `contents: write` and to `push` on `v*` tags only.
- `doc/byebyevibe-guide.md` — §1.6 (tarball pointer), new §2.18, `## Guide changelog` entry.
- `sdd-kit/MANIFEST.yaml`, `sdd-kit/README.md` — version strings only. A C2 upgrade delivers no file diff to consumers.
- **Blocked on a repository setting, not on code:** issue #348 is closed but its task 6.1 (`add `Release readiness (blocking)` as a required status check under Settings → Branches`) is still open. Until it is done, `master` can carry a commit the gate would reject, and `cut-release.sh`'s local re-run of the same script is the only thing standing between that commit and a tag. Cutting the first release before task 6.1 is closed is possible but weakens the guarantee — tracked as a blocking task here.
- Merge ordering with issue #349: no technical dependency in either direction (`research.md` § F3/F4 pickup, D-REL-1), but both changes append to `## Guide changelog` and touch `sdd-kit/MANIFEST.yaml`. Serialize the merges in whichever order lands first.

**Issue:** https://github.com/pvilarim/byebyevibe/issues/350

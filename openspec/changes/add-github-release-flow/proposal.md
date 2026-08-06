## Why

The repository has no git tags (`git tag -l` is empty) and no GitHub Releases. Versioning lives entirely in `sdd-kit/MANIFEST.yaml` (`version:` for the `sdd-kit/` payload, `guide_version:` for `doc/byebyevibe-guide.md`), with the prose changelog under `doc/byebyevibe-guide.md` → `## Guide changelog`. Nobody can point at "which commit is 1.11.0" without opening the MANIFEST at that point in history, and nobody can download the kit without the `git clone --filter=blob:none --sparse` dance documented as the "Lightweight fetch recipe" (guide §1.6) — a workaround that exists precisely because there is no simpler downloadable artifact.

This was recorded as **F4** in `openspec/changes/explore-public-release-surface/research.md` and deferred to "Launch / public repo". That point has been reached; the deferral was reopened as issue #350.

The prerequisite with real substance is already built: `scripts/verify-release-readiness.sh` (change `add-release-readiness-gate`, issue #348) turns version-sync, kit-integrity, and hub↔templates parity into a single repo-state check with its own exit code. A release can therefore be gated on a check that means "this commit is internally consistent", rather than on a green CI run that mixes in environment noise.

## What Changes

- New `scripts/release-notes.sh <version> [source-file]` — prints the `### <version> (` block from `doc/byebyevibe-guide.md` `## Guide changelog`, verbatim, exiting non-zero when the section is absent or has no body. The single source of release-note text; nothing is rewritten or duplicated. The optional source-file argument exists so absence/empty behavior is testable against fixtures.
- New `scripts/cut-release.sh <version> [--dry-run]` — the operator-run entry point. Fetches `origin/master` and tags first (unreachable remote = named abort), then refuses to tag unless every precondition holds: clean tree, on the default branch at exactly the fetched remote head (behind, ahead, and diverged all fail), `version:` equals `guide_version:`, both equal the requested version, changelog section resolvable and non-empty, `verify-release-readiness.sh` green, tag absent locally and remotely. Then creates the annotated tag `v<version>` (message = title only; notes live in the Release body alone) and pushes it. `--dry-run` runs every precondition and never tags or pushes.
- New `.github/workflows/release.yml` — triggered by pushing a `v*` tag. Trusts nothing about the tag's provenance: server-side it validates the tag shape (`v<MAJOR>.<MINOR>.<PATCH>` exactly), resolves the tag to its commit (`^{commit}`) and asserts ancestry of `master`, asserts the tag's version equals `version:` in the MANIFEST **at the tagged commit** (a mislabeled hand-pushed tag cannot publish), re-runs `verify-release-readiness.sh`, and runs notes extraction as its own blocking step. Then it builds the kit tarball plus `.sha256` sidecar with `git archive`, records the runner's git version in the Release body, and publishes draft-first via the preinstalled `gh` CLI (token passed explicitly as `GH_TOKEN` — it is not ambient), flipping to published only after all assets attach. Runs with `permissions: contents: write` in its own workflow file, every `uses:` SHA-pinned.
- **Single tag axis.** `v<version>` only, tracking `version:`. `cut-release.sh` refuses to tag when `version: != guide_version:`, which converts the currently-unwritten "the two axes move in lockstep" assumption into an enforced invariant with a loud failure the day it stops holding. The `kit-v*` / `guide-v*` split floated in issue #350 is **not** adopted — see design D1.
- **Trigger model: push of a matching tag.** Recorded decision required by the issue's acceptance criteria; see design D2.
- **Published versions are immutable.** Yanking a bad release means publishing a new patch version, never deleting and re-tagging the same number (which would invalidate already-downloaded checksums). Publication is draft-first, so a partially failed publish is invisible to consumers and retryable — see design D10.
- `doc/byebyevibe-guide.md` — new §2.18 documenting the release procedure and yank policy; a pointer in §1.6 offering the release tarball as the simpler alternative to the lightweight fetch recipe (the recipe stays, as the only option for unreleased `master`, and remains the spec-mandated default in the §2.0 install prompt, which gains a mention of the tarball without a default change); the dead `#changelog-do-guia` anchor in the header fixed.
- `sdd-kit/MANIFEST.yaml` — `version:` and `guide_version:` bumped 1.11.0 → 1.12.0 in lockstep; `sdd-kit/README.md` H1 synced; changelog entry added.

Hub-only: nothing new is added under `sdd-kit/templates/` and no MANIFEST template entry is created, because consumer repositories install the kit — they do not release it. No template bytes change, so no checksums change (same shape as the 1.10.0 release).

## Capabilities

### New Capabilities

- `sdd-release-flow`: how a release is cut — tag naming and the single-axis invariant, the preconditions that must hold before tagging, the server-side guards a tag push must clear, where release-note text comes from, publication atomicity and the yank policy, what the published artifact contains, and what "reproducible from the tagged commit" means for it.

### Modified Capabilities

None. `sdd-ci-gates` is untouched: its requirements scope `.github/workflows/sdd-gates.yml`, which this change does not edit, and its "sole authorized external Action" exception is respected because the release workflow uses the preinstalled `gh` CLI instead of a third-party release Action (design D6). The new spec deliberately constrains only the release workflow itself (its permissions, pinning, and guards) — it does not legislate `sdd-gates.yml`'s permissions or other workflows' scopes, which belong to `sdd-ci-gates`.

## Impact

- New `scripts/release-notes.sh`, `scripts/cut-release.sh` — hub-only, no `sdd-kit/templates/` mirror. The hub↔templates parity check iterates over existing templates, so live scripts without a template counterpart do not trip it.
- New `.github/workflows/release.yml` — second workflow in the repository; the first one that requests write permissions, scoped to `contents: write` and to `push` on `v*` tags only.
- `doc/byebyevibe-guide.md` — §1.6 (tarball pointer), §2.0 (tarball mentioned, default unchanged), new §2.18, `## Guide changelog` entry, one dead-anchor fix.
- `AGENTS.md` — one row in the hub Commands table. The guide's §12.2a/b consumer `AGENTS.md` templates do NOT gain it — consumers do not release the kit.
- `sdd-kit/MANIFEST.yaml`, `sdd-kit/README.md` — version strings only. A C2 upgrade delivers no file diff to consumers.
- **Blocked on repository settings, not on code:** issue #348 is closed but its task 6.1 (`add `Release readiness (blocking)` as a required status check under Settings → Branches`) is still open — verified before the first cut via this change's task 7.1 (a pointer to that authoritative tracker, not a second one). A `v*` tag ruleset (who may create release tags) is the tag-side counterpart, recommended as task 7.2. The workflow's server-side guards bound what a stray tag can publish either way.
- Merge ordering with issue #349: no technical dependency in either direction (`research.md` § F3/F4 pickup, D-REL-1), but both changes append to `## Guide changelog` and touch `sdd-kit/MANIFEST.yaml`. Serialize the merges in whichever order lands first.

**Issue:** https://github.com/pvilarim/byebyevibe/issues/350

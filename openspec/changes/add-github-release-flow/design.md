## Context

Issue #350 was authored as the third of a chain — #348 (fail-closed CI gate) → #349 (automated PR review pipeline) → #350 — and proposed a two-axis tagging convention mirroring `sdd-kit/MANIFEST.yaml`'s `version:` / `guide_version:` split. Both of those framings were examined in `openspec/changes/explore-public-release-surface/research.md` § "F3/F4 pickup — dependency analysis (2026-08-05)" and neither survived unchanged:

- **D-REL-1** — #349 produces no input that #350 consumes. The chain order was proposed, not derived. #349 is fully parallelizable.
- **D-REL-2** — the one prerequisite with technical substance is #348's still-open task 6.1 (branch protection), a repository setting rather than code.
- **D-REL-3** — only the most automated trigger (release fires on a MANIFEST bump landing on `master`) couples to #349. Manual and tag-triggered do not.
- **D-REL-5** — the two-axis premise is unsupported: `version:` and `guide_version:` have been identical in every recorded commit (1.6.1 → 1.11.0) and `## Guide changelog` carries one entry per release covering kit and guide together.

Everything the release flow needs to read already exists: version numbers in the MANIFEST, note text in the guide changelog, a repo-state guard in `scripts/verify-release-readiness.sh`.

## Goals / Non-Goals

**Goals:**

- A repeatable, documented procedure to cut a release, guarded so it cannot tag an internally inconsistent commit.
- Release notes sourced by extraction from the existing prose changelog — no second changelog, no hand-copied text.
- A downloadable kit artifact that makes guide §1.6's sparse-checkout recipe optional for anyone on a released version.
- A recorded automation decision, as the issue's acceptance criteria require.

**Non-Goals:**

- Root `CHANGELOG.md` (F3). Still its own future change, `add-root-changelog`; this change deliberately keeps the guide changelog as the single list so the extractor has exactly one source.
- Retiring the lightweight fetch recipe. It remains the only way to install from unreleased `master`.
- Backfilling tags for 1.0.0 – 1.11.0. Historical commits were never gated by `verify-release-readiness.sh`; tagging them would assert a guarantee that was not in force. First release is 1.12.0, this change's own version.
- Configuring branch protection. Repository setting, inherited as a precondition from `add-release-readiness-gate` task 6.1.
- Any change to `sdd-kit/templates/` or the consumer-facing kit. Consumers install the kit; they do not release it.
- Publishing to npm or any package registry.

## Decisions

### D1 — Single tag axis `v<version>`, with a lockstep invariant enforced at cut time

**Chosen:** one tag per release, `v<version>`, taken from `version:`. `cut-release.sh` aborts when `version: != guide_version:`.

The issue proposed `kit-vX.Y.Z` + `guide-vX.Y.Z`. Since the two fields have never diverged and the changelog is a single list, that convention produces two tags on the same commit carrying the same extracted body — duplicated releases with no information difference. Per **R4** (smallest reasonable change, no speculative abstractions), one axis.

The risk of the single axis is the opposite failure: the day the two fields *do* diverge, one tag silently under-describes the release. The invariant check converts that from a silent inconsistency into a hard stop with an explicit message pointing at this decision. Splitting the axis then becomes a deliberate follow-up change, made with a real divergence in hand rather than a hypothetical one — and it will need to answer the question this change does not have to: how a single changelog list gets split into two release bodies.

**Alternative rejected:** adopt the two-axis convention now and emit both tags. Rejected — it buys nothing today and commits the changelog to a split that has no author yet.

### D2 — Trigger: pushing a matching tag

| Model | Coupled to #349? | Verdict |
|-------|------------------|---------|
| Fully manual (`gh release create` by hand) | no | Rejected — the acceptance criterion "notes sourced from, not duplicated" degrades to a copy-paste convention nobody can enforce |
| **Push of a `v*` tag fires the workflow** | **no** | **Chosen** |
| MANIFEST bump landing on the default branch fires the release | yes (D-REL-3) | Rejected — the only option that puts #349 on the critical path, and it makes every version-bump merge irreversibly a release |

Tag-push keeps the decision to release explicit and human, while the assembly (notes, tarball, checksum, Release object) is mechanical and auditable in a job log. It also gives a natural undo before publication: the tag can be deleted locally and re-pushed if `cut-release.sh` was run against the wrong commit.

### D3 — Two scripts, not one

`release-notes.sh` is separated from `cut-release.sh` because both the operator's machine (pre-flight preview) and the runner (populating the Release body) need note extraction, while only the operator's machine may tag. The runner must never re-tag; giving it the whole script would put that capability one flag away. This is a real second consumer, not speculative factoring.

### D4 — What the tarball contains

`sdd-kit/` + `scripts/bootstrap-sdd.sh` + `scripts/preflight-sdd.sh`, under prefix `byebyevibe-kit-<version>/`.

That set is copied from guide §1.6's own sparse-checkout list — the artifact is only a real replacement for the recipe if it carries the same footprint. `sdd-kit/` alone would leave a downloader unable to run the documented next command, `bash scripts/bootstrap-sdd.sh --profile <PROFILE>`.

### D5 — What "reproducible from the tagged commit" means

Build command, run on the runner and documented verbatim in guide §2.18:

```bash
git archive --format=tar --prefix="byebyevibe-kit-${VERSION}/" "v${VERSION}" \
    sdd-kit scripts/bootstrap-sdd.sh scripts/preflight-sdd.sh \
  | gzip -n > "byebyevibe-kit-${VERSION}.tar.gz"
```

`git archive` sets uid/gid to 0 and every entry's mtime to the commit timestamp, and emits entries in tree order, so the tar stream is a pure function of the tag. `gzip -n` suppresses the filename and timestamp in the gzip header, which is the one place wall-clock time would otherwise leak in. Piping to `gzip -n` explicitly rather than using `--format=tar.gz` avoids depending on git's built-in `tar.tgz.command` default, which is configurable per-repo and per-user.

Measured on this repository (git 2.x, two consecutive runs against `HEAD`): the `gzip -n` pipeline produced identical SHA256 digests, and the archive contains `t/scripts/bootstrap-sdd.sh`, `t/scripts/preflight-sdd.sh`, and the full `t/sdd-kit/` tree — the §1.6 footprint. `--format=tar.gz` also came out identical across runs on this git version, so the explicit pipe is a robustness choice against configuration, not a fix for observed nondeterminism.

The claim published is therefore: **byte-identical when regenerated from the same tag with the same git version**, verifiable in one command against the `.sha256` sidecar asset. Across git major versions the file contents are identical but the tar envelope may differ (pax header emission rules have changed historically) — stated as a caveat in §2.18 rather than papered over. The strong guarantee that always holds is content-level: every byte in the archive comes from the tagged tree.

**Alternative rejected:** `--format=tar.gz` and a claim of unqualified reproducibility. Rejected — it would be an overclaim, and the acceptance criterion is better served by a precise, testable statement.

### D6 — Publish with the `gh` CLI, not a third-party release Action

The `sdd-ci-gates` spec records `google/osv-scanner-action` as "the sole authorized external Action dependency … this exception does not permit other third-party Actions without a dedicated OpenSpec change." `softprops/action-gh-release` and its peers would need that dedicated change and would widen the supply-chain surface for a task `gh release create` already does. `gh` is preinstalled on `ubuntu-latest` and authenticates from `GITHUB_TOKEN`.

Consequence: `sdd-ci-gates` needs no delta, and the repository's third-party Action inventory is unchanged.

### D7 — A separate workflow file, not a job inside `sdd-gates.yml`

`sdd-gates.yml` declares `permissions: contents: read` at the workflow level and runs on every push and pull request. Creating a Release requires `contents: write`. Merging the two would either widen the token on every PR run or introduce job-level permission overrides in a workflow whose least-privilege posture is a recorded design decision (D11 of `add-sdd-ci-gates-workflow`). `.github/workflows/release.yml` runs only on `push` of `v*` tags and is the only workflow holding a write scope.

### D8 — The runner re-runs `verify-release-readiness.sh`

`cut-release.sh` already ran it locally, but a local run proves nothing about the pushed commit if the operator's tree differed. The runner's re-run is against exactly the tagged commit, costs seconds, and is the check that actually gates publication. The workflow also asserts the tagged commit is an ancestor of `origin/master`, so a tag pushed from a side branch cannot produce a Release.

### D9 — Version bump: minor, both fields, no template diff

1.11.0 → 1.12.0 on `version:` and `guide_version:`. New documented operator capability, so minor rather than patch. No file under `sdd-kit/templates/` changes, so `gen-manifest-checksums.sh` produces no diff and a C2 upgrade delivers nothing to consumers — the same shape as the 1.10.0 release, which is the precedent for bumping both fields on a change whose payload effect is zero.

## Risks / Trade-offs

| Risk | Mitigation |
|------|------------|
| Task 6.1 (branch protection) is never closed, so `master` may hold a commit the gate would reject | `cut-release.sh` and the release workflow both run `verify-release-readiness.sh` independently of CI, so a bad commit cannot be *released* even while it can be merged. Task 6.1 is carried here as a blocking task before the first cut |
| `version:` and `guide_version:` diverge and the single axis under-describes a release | `cut-release.sh` aborts on divergence with a message naming this decision — the failure is loud and happens before any tag exists (D1) |
| The changelog section for a version is missing, misspelled, or has a non-conforming heading (`### 1.0.0 (2026-05)` is one such legacy entry) | `release-notes.sh` exits non-zero on an unresolvable or empty section, and `cut-release.sh` calls it as a precondition — the failure lands before tagging, not as an empty Release body |
| A `v*` tag pushed by hand, bypassing `cut-release.sh` | The workflow re-runs the readiness check and the ancestry check; it will refuse to publish rather than trust the tag's provenance |
| Adding the repository's first write-scoped workflow | Scoped to `contents: write`, a single trigger (`push` on `v*` tags), no `pull_request` trigger, no secrets beyond `GITHUB_TOKEN` |
| D6 assumes `gh` is preinstalled on `ubuntu-latest`; that could not be verified from the authoring environment, only from GitHub's published runner-image inventory | The workflow checks `command -v gh` before the build steps and fails with an explicit message, so an absent CLI surfaces as a named precondition rather than a confusing `gh: not found` at the publish step. If it ever stops being preinstalled, the fallback is a `curl` against the Releases REST API with `GITHUB_TOKEN` — still no third-party Action |
| Merge collision with #349 on `## Guide changelog` and `sdd-kit/MANIFEST.yaml` | Mechanical, expected on every kit change; serialize the two merges (D-REL-4) |
| Tarball drifts from what §1.6 tells people to fetch | Both lists are named in §2.18 next to each other; a task gate diffs the extracted archive against the recipe's footprint |

## Migration Plan

1. Write `scripts/release-notes.sh`; verify it extracts 1.11.0 and 1.10.0 correctly and fails on a nonexistent version.
2. Write `scripts/cut-release.sh` with every precondition from D1/D8; verify each guard fires by construction (dirty tree, wrong branch, mismatched versions, missing changelog section, existing tag).
3. Add `.github/workflows/release.yml`.
4. Guide: new §2.18, §1.6 tarball pointer, changelog entry for 1.12.0.
5. Bump `sdd-kit/MANIFEST.yaml` `version:` and `guide_version:` to 1.12.0; sync `sdd-kit/README.md` H1 and both guide header claims in the same commit, so `verify-release-readiness.sh` stays green throughout.
6. `bash scripts/verify-release-readiness.sh` and `bash sdd-kit/verify.sh` — both must exit 0.
7. Merge. **Then** close `add-release-readiness-gate` task 6.1 (branch protection) before cutting anything.
8. First real cut: `bash scripts/cut-release.sh 1.12.0`.

Rollback: delete the tag (`git push origin :refs/tags/v1.12.0`) and the Release; revert the commit. The workflow holds no state between runs, and nothing in the repository depends on a Release existing.

## Open Questions

None blocking.

Deliberately left for later, each needing evidence this change does not have: splitting the tag axis (only once `version:` and `guide_version:` actually diverge — D1); a root `CHANGELOG.md` (F3, its own change); backfilling historical tags (Non-Goals); and whether releases should ever be cut from a branch other than the default one (currently forbidden by D8's ancestry check, with no use case arguing otherwise).

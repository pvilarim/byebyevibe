# sdd-release-flow Specification

## Purpose
TBD - created by archiving change add-github-release-flow. Update Purpose after archive.
## Requirements
### Requirement: Releases use a single tag axis

A release MUST be identified by exactly one annotated git tag of the form `v<MAJOR>.<MINOR>.<PATCH>`, whose version equals `sdd-kit/MANIFEST.yaml` `version:` at the tagged commit. The `kit-v*` / `guide-v*` two-axis convention MUST NOT be used. Because a single tag can only name one version, the release procedure MUST refuse to tag any commit where `version:` and `guide_version:` differ; adopting a second tag axis requires its own OpenSpec change that also specifies how the single `## Guide changelog` list is split into two release bodies.

#### Scenario: Lockstep versions produce one tag

- **WHEN** an operator cuts a release at a commit where `sdd-kit/MANIFEST.yaml` declares `version: "1.12.0"` and `guide_version: "1.12.0"`
- **THEN** exactly one annotated tag `v1.12.0` is created, and no `kit-v1.12.0` or `guide-v1.12.0` tag is created

#### Scenario: Diverged versions abort the cut

- **WHEN** an operator cuts a release at a commit where `version:` and `guide_version:` hold different values
- **THEN** the procedure exits non-zero with a message naming both fields and their values, and no tag is created

#### Scenario: Requested version must match the MANIFEST

- **WHEN** an operator requests a release for a version that does not equal `sdd-kit/MANIFEST.yaml` `version:` at the current commit
- **THEN** the procedure exits non-zero and no tag is created

### Requirement: Release notes are extracted from the guide changelog

Release-note text MUST be extracted verbatim from the `### <version> (<date>)` section of `doc/byebyevibe-guide.md` `## Guide changelog`, which remains the single authored changelog. No second changelog file may be introduced for this purpose, and note text MUST NOT be rewritten or hand-copied when a release is published. Extraction MUST anchor on the exact version string followed by ` (` — so a shorter version can never be satisfied by a longer one that contains it as a prefix — and MUST end the section at the next line starting with `### ` or `## `, or at end of file. Legacy entries whose date is not full `YYYY-MM-DD` form (the repository has one, `### 1.0.0 (2026-05)`) MUST still be extractable: the anchor is the version, not the date shape. Extraction MUST exit non-zero when the section is absent or contains no non-blank body line. The extractor MUST accept an alternate source-file path so absence and empty-body behavior can be tested against fixtures without editing the live changelog.

#### Scenario: Section extracted verbatim

- **WHEN** notes are extracted for a version whose section exists in `## Guide changelog` with body content
- **THEN** the section's body is printed unmodified and the exit code is zero

#### Scenario: Similar version numbers do not collide

- **WHEN** notes are extracted for version `1.1.0`, which exists in the changelog alongside `### 1.11.0 (…)`
- **THEN** the output is the body of the `1.1.0` section only, containing no line from the `1.11.0` section

#### Scenario: Missing section fails loudly

- **WHEN** notes are extracted for a version that has no matching section
- **THEN** extraction exits non-zero with a message naming the version and the file

#### Scenario: Empty section fails loudly

- **WHEN** notes are extracted for a version whose heading exists but is followed by no non-blank body line before the next heading
- **THEN** extraction exits non-zero, so no empty release body can be produced from it

### Requirement: Cutting a release is guarded by preconditions

The documented procedure to cut a release MUST, before creating any tag, fetch the remote default branch and remote tags, and then verify that: the working tree is clean; the checkout is on the repository's default branch and points at the same commit as the freshly fetched remote default branch (neither behind nor ahead); `version:` equals `guide_version:` and both equal the requested version; the changelog section for that version resolves to non-empty text; `scripts/verify-release-readiness.sh` exits zero; and no tag of the same name exists locally or on the remote. Any failed precondition — including an unreachable remote — MUST abort with a non-zero exit and a message naming the failed check, leaving the repository unmodified. The procedure MUST offer a dry-run mode that runs every precondition and reports the outcome without creating or pushing anything. The annotated tag's message MUST be only the release title (`v<version>`) — release-note text lives in the GitHub Release body alone, so the tag message can never diverge from it.

#### Scenario: All preconditions hold

- **WHEN** every precondition is satisfied for the requested version
- **THEN** an annotated tag is created and pushed to the remote, and the operator is told which tag was pushed

#### Scenario: Dry-run never mutates

- **WHEN** the procedure runs in dry-run mode, regardless of whether the preconditions pass or fail
- **THEN** no tag is created locally or remotely and no push occurs

#### Scenario: Repo-state check fails

- **WHEN** `scripts/verify-release-readiness.sh` exits non-zero at the commit being released — for example a version-sync mismatch or a stale template checksum
- **THEN** the procedure aborts, no tag is created, and the underlying failure output is shown

#### Scenario: Tag already exists

- **WHEN** a tag with the target name already exists locally or on the remote
- **THEN** the procedure aborts without moving, deleting, or overwriting the existing tag

#### Scenario: Local branch ahead of or behind the remote

- **WHEN** the fetched remote default branch and the local checkout point at different commits — the local branch is behind, ahead, or diverged
- **THEN** the procedure aborts before tagging, so a tag can never point at a commit the remote does not have or skip commits the remote already has

#### Scenario: Remote unreachable

- **WHEN** the initial fetch or the remote tag check cannot reach the remote
- **THEN** the procedure aborts with a message naming the network failure, rather than proceeding on stale local refs

### Requirement: A tag push publishes the GitHub Release only after server-side guards pass

The repository MUST include a GitHub Actions workflow, in a file separate from `.github/workflows/sdd-gates.yml`, triggered by `push` of tags matching `v*`. Because any collaborator with write access can push a tag, every guard below runs server-side on the tagged commit and none of them trusts `cut-release.sh` to have run. The workflow MUST, in order, and failing the run without creating a Release if any check fails:

1. Verify the tag name matches `v<MAJOR>.<MINOR>.<PATCH>` exactly; other `v*` tags fail the run explicitly.
2. Resolve the tag to its commit (annotated tags dereference via `^{commit}`) and verify that commit is an ancestor of the default branch.
3. Verify the tag's version equals `sdd-kit/MANIFEST.yaml` `version:` at the tagged commit, so a mislabeled tag can never publish a Release whose name and contents disagree.
4. Run `scripts/verify-release-readiness.sh` against the tagged commit.
5. Extract the changelog section for the tag's version as its own blocking step, writing the notes to a file whose non-emptiness is asserted — extraction failure MUST fail the run before any Release exists, and the publish step MUST consume that file rather than invoke the extractor inline.

The workflow MUST declare `permissions: contents: write`, MUST pin every `uses:` reference to a full commit SHA, and MUST NOT introduce a third-party GitHub Action — the Release is created with the runner's preinstalled `gh` CLI, whose presence is asserted before the build steps and which MUST be given the workflow token explicitly via the `GH_TOKEN` environment variable (the token is not ambient in the runner environment).

#### Scenario: Valid tag publishes a Release

- **WHEN** a `v<version>` tag is pushed for a commit that passes all five guards
- **THEN** a GitHub Release is created for that tag with a body equal to the extracted changelog section

#### Scenario: Mislabeled tag does not publish

- **WHEN** a `v*` tag is pushed whose version differs from `sdd-kit/MANIFEST.yaml` `version:` at the tagged commit — for example `v1.11.0` pushed at a commit whose MANIFEST declares `1.12.0`
- **THEN** the workflow fails at the tag-version guard and no Release is created

#### Scenario: Non-release tag shape does not publish

- **WHEN** a tag matching the trigger glob but not the release shape is pushed — for example `v2-wip` or `v1.2`
- **THEN** the workflow fails at the shape guard and no Release is created

#### Scenario: Hand-pushed tag on a bad commit does not publish

- **WHEN** a `v*` tag is pushed for a commit that fails `scripts/verify-release-readiness.sh`, or that is not an ancestor of the default branch
- **THEN** the workflow fails and no Release is created

#### Scenario: Missing changelog section does not publish an empty Release

- **WHEN** a `v<version>` tag passes guards 1–4 but no changelog section exists for that version
- **THEN** the extraction step fails the run and no Release — empty-bodied or otherwise — is created

#### Scenario: No new third-party Action

- **WHEN** the release workflow is reviewed
- **THEN** every `uses:` reference is `actions/checkout` pinned to a full commit SHA, and Release creation is performed by the preinstalled `gh` CLI

### Requirement: Publication is atomic and published versions are immutable

The Release MUST NOT become publicly visible before all its assets are attached: the workflow creates it as a draft, uploads the assets, and only then flips it to published. A re-run after a partial failure MUST either complete the pending draft or replace it, and MUST NOT be wedged by the draft's existence. A version that has been published is immutable: re-tagging a previously published version with different content is forbidden — withdrawing a bad release (yank) is done by publishing a new patch version whose changelog entry says what was wrong, optionally marking the bad Release as such in its description, and never by deleting and re-cutting the same version, which would silently invalidate checksums already downloaded. Deleting a tag and Release is permitted only for a version that never finished publishing.

#### Scenario: Asset upload fails midway

- **WHEN** the workflow fails after creating the draft Release but before all assets are uploaded
- **THEN** no published Release is visible to consumers, and re-running the workflow completes or replaces the draft rather than failing because a Release already exists

#### Scenario: Yank is a new version

- **WHEN** a published release is discovered to be bad
- **THEN** the remedy is a new patch release documenting the problem; the bad version's tag and assets remain, so existing downloads and checksums stay verifiable

### Requirement: The release carries a reproducible kit tarball

Each Release MUST attach a `.tar.gz` archive of the install footprint plus a `.sha256` sidecar asset. The archive MUST be produced from the tagged commit with `git archive`, MUST contain `sdd-kit/`, `scripts/bootstrap-sdd.sh`, and `scripts/preflight-sdd.sh` — the same footprint `doc/byebyevibe-guide.md` §1.6 names as the minimal install-fetch footprint — under a single top-level prefix directory carrying the version, and MUST be gzipped with the timestamp and filename fields suppressed so the output does not depend on wall-clock time. The exact build command MUST be documented in the guide so anyone can regenerate the artifact from the tag and compare it against the published checksum. The guide MUST state that byte-identity is guaranteed for the same tag under the same git version, while content identity holds unconditionally — and because that guarantee is parameterized by the builder's git version, the Release body MUST record the `git --version` that produced the published archive, so a mismatched regeneration can be distinguished from tampering.

Because a version-stamped asset filename cannot be constructed by a downloader that does not yet know the version, each Release MUST **additionally** attach the same archive under a **version-less, stable filename**, together with its own `.sha256` sidecar computed against that stable filename — so that verification succeeds against a file downloaded under it. The stable-named assets MUST be byte-identical to the version-stamped ones. The version-stamped assets MUST be retained: they are the citable, archival artifact the documented regeneration command reproduces by name.

The stable filename MUST NOT claim recency in its own text (for example a `-latest` suffix), because the same asset is also reachable pinned to a specific tag, where such a claim would be false.

#### Scenario: Archive footprint matches the documented fetch recipe

- **WHEN** the published archive is extracted
- **THEN** it contains `sdd-kit/`, `scripts/bootstrap-sdd.sh`, and `scripts/preflight-sdd.sh` under one prefix directory, and `bash scripts/bootstrap-sdd.sh --profile <PROFILE>` can be run after copying them into a target repository

#### Scenario: Regeneration reproduces the published checksum

- **WHEN** the documented build command is run twice against the same tag with the same git version
- **THEN** both runs produce identical bytes, matching the version-stamped `.sha256` asset published with the Release

#### Scenario: Checksum is published alongside the archive

- **WHEN** a Release is published
- **THEN** each attached `.tar.gz` has a corresponding `.sha256` sidecar, and the Release body names the git version that built them

#### Scenario: Stable-named asset is fetchable without knowing the version

- **WHEN** a downloader requests the stable-named asset through the host's latest-release download path, knowing only the repository
- **THEN** the current release's archive is served, and its sidecar verifies against the file as downloaded

#### Scenario: Stable and version-stamped assets agree

- **WHEN** both assets from the same Release are downloaded and hashed
- **THEN** their bytes are identical, and each verifies against its own sidecar

#### Scenario: Extracted directory still identifies the version

- **WHEN** the stable-named archive is extracted
- **THEN** its single top-level directory carries the release version, and `sdd-kit/MANIFEST.yaml` inside declares the same version


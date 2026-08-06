## ADDED Requirements

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

Release-note text MUST be extracted verbatim from the `### <version> (YYYY-MM-DD)` section of `doc/byebyevibe-guide.md` `## Guide changelog`, which remains the single authored changelog. No second changelog file may be introduced for this purpose, and note text MUST NOT be rewritten or hand-copied when a release is published. Extraction MUST match the requested version exactly — a prefix of another version's heading MUST NOT match — and MUST end the section at the next `###` or `##` heading. Extraction MUST exit non-zero when the section is absent or contains no body.

#### Scenario: Section extracted verbatim

- **WHEN** notes are extracted for a version whose section exists in `## Guide changelog` with body content
- **THEN** the section's body is printed unmodified and the exit code is zero

#### Scenario: Similar version numbers do not collide

- **WHEN** notes are extracted for version `1.1.0` while a `### 1.11.0 (…)` section also exists
- **THEN** only the `1.1.0` section is considered, and a missing `1.1.0` section is reported as missing rather than satisfied by `1.11.0`

#### Scenario: Missing section fails loudly

- **WHEN** notes are extracted for a version that has no matching section, or whose section has an empty body
- **THEN** extraction exits non-zero with a message naming the version and the file, and no empty release body is produced

### Requirement: Cutting a release is guarded by preconditions

The documented procedure to cut a release MUST verify, before creating any tag, that: the working tree is clean; the checkout is on the repository's default branch and not behind its remote counterpart; `version:` equals `guide_version:` and both equal the requested version; the changelog section for that version resolves to non-empty text; `scripts/verify-release-readiness.sh` exits zero; and no tag of the same name already exists locally or on the remote. Any failed precondition MUST abort with a non-zero exit and leave the repository unmodified.

#### Scenario: All preconditions hold

- **WHEN** every precondition is satisfied for the requested version
- **THEN** an annotated tag is created and pushed to the remote, and the operator is told which tag was pushed

#### Scenario: Repo-state check fails

- **WHEN** `scripts/verify-release-readiness.sh` exits non-zero at the commit being released — for example a version-sync mismatch or a stale template checksum
- **THEN** the procedure aborts, no tag is created, and the underlying failure output is shown

#### Scenario: Tag already exists

- **WHEN** a tag with the target name already exists locally or on the remote
- **THEN** the procedure aborts without moving, deleting, or overwriting the existing tag

#### Scenario: Dirty or unsynced working tree

- **WHEN** the working tree has uncommitted changes, or the checkout is not on the default branch, or it is behind the remote default branch
- **THEN** the procedure aborts before running any other check

### Requirement: A tag push publishes the GitHub Release

The repository MUST include a GitHub Actions workflow, in a file separate from `.github/workflows/sdd-gates.yml`, triggered by `push` of tags matching `v*`. The workflow MUST re-run `scripts/verify-release-readiness.sh` against the tagged commit and MUST verify that the tagged commit is an ancestor of the default branch, refusing to publish if either check fails. It MUST populate the Release body by extracting the changelog section for the tag's version. It MUST declare `permissions: contents: write` and MUST NOT introduce a third-party GitHub Action beyond those already authorized — the Release is created with the runner's preinstalled `gh` CLI. `.github/workflows/sdd-gates.yml` MUST keep `permissions: contents: read`.

#### Scenario: Valid tag publishes a Release

- **WHEN** a `v<version>` tag is pushed for a commit that is an ancestor of the default branch and passes the readiness check
- **THEN** a GitHub Release is created for that tag with a body equal to the extracted changelog section

#### Scenario: Hand-pushed tag on a bad commit does not publish

- **WHEN** a `v*` tag is pushed for a commit that fails `scripts/verify-release-readiness.sh`, or that is not an ancestor of the default branch
- **THEN** the workflow fails and no Release is created

#### Scenario: Permission scopes stay separated

- **WHEN** the repository's workflows are reviewed
- **THEN** the release workflow is the only one declaring `contents: write`, it triggers only on `push` of `v*` tags, and `sdd-gates.yml` still declares `contents: read`

#### Scenario: No new third-party Action

- **WHEN** the release workflow is reviewed
- **THEN** its only non-checkout/setup Action dependencies are none, and Release creation is performed by the preinstalled `gh` CLI

### Requirement: The release carries a reproducible kit tarball

Each Release MUST attach a `.tar.gz` archive of the install footprint plus a `.sha256` sidecar asset. The archive MUST be produced from the tagged commit with `git archive`, MUST contain `sdd-kit/`, `scripts/bootstrap-sdd.sh`, and `scripts/preflight-sdd.sh` — the same footprint the "Lightweight fetch recipe" in `doc/byebyevibe-guide.md` §1.6 tells operators to sparse-checkout — under a single top-level prefix directory, and MUST be gzipped with the timestamp and filename fields suppressed so the output does not depend on wall-clock time. The exact build command MUST be documented in the guide so anyone can regenerate the artifact from the tag and compare it against the published checksum. The guide MUST state that byte-identity is guaranteed for the same tag under the same git version, while content identity holds unconditionally.

#### Scenario: Archive footprint matches the documented fetch recipe

- **WHEN** the published archive is extracted
- **THEN** it contains `sdd-kit/`, `scripts/bootstrap-sdd.sh`, and `scripts/preflight-sdd.sh` under one prefix directory, and `bash scripts/bootstrap-sdd.sh --profile <PROFILE>` can be run after copying them into a target repository

#### Scenario: Regeneration reproduces the published checksum

- **WHEN** the documented build command is run twice against the same tag with the same git version
- **THEN** both runs produce identical bytes, matching the `.sha256` asset published with the Release

#### Scenario: Checksum is published alongside the archive

- **WHEN** a Release is published
- **THEN** both the `.tar.gz` and its `.sha256` sidecar are attached as assets

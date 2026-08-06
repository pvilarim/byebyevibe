## MODIFIED Requirements

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

## ADDED Requirements

### Requirement: Guide documents a release-download acquisition recipe

`doc/byebyevibe-guide.md` MUST include a concrete, copy-pasteable command sequence that acquires the install footprint from the **latest published GitHub Release** without cloning the repository, and that results in the fetched paths landing at their real relative locations so the existing documented command `bash scripts/bootstrap-sdd.sh --profile <PROFILE>` runs unmodified afterward.

The recipe MUST resolve the current release without the downloader knowing its version number in advance, MUST verify the downloaded archive against its published `.sha256` sidecar **before** extracting it, and MUST fail loudly rather than silently produce a corrupt or partial result when an asset is missing. It MUST rely only on tooling already required by guide §1.1 and MUST NOT introduce a new mandatory dependency — in particular it MUST NOT require an authenticated CLI.

#### Scenario: Version is not needed in advance

- **WHEN** an operator follows the release-download recipe without knowing which version is current
- **THEN** the recipe resolves the latest release on its own, and the operator is never asked to substitute a version number into a URL

#### Scenario: Checksum verification precedes extraction

- **WHEN** the release-download recipe is followed
- **THEN** the archive's checksum is verified against the published sidecar before the archive is extracted, and a mismatch stops the procedure

#### Scenario: Missing asset fails loudly

- **WHEN** the recipe is followed against a release that does not carry the expected asset
- **THEN** the download step exits non-zero and no error page or partial file is left in place of the archive, so the failure is not misreported later as a corrupt archive

#### Scenario: Recipe lands the documented footprint

- **WHEN** the release-download recipe completes against a target repository that has no `sdd-kit/` yet
- **THEN** the target repository ends up with `sdd-kit/`, `scripts/bootstrap-sdd.sh`, and `scripts/preflight-sdd.sh` populated at their real relative locations, and no hub-only `doc/`, `openspec/`, `.cursor/`, or `.claude/` content is written

## MODIFIED Requirements

### Requirement: Guide documents a lightweight no-full-clone fetch recipe

`doc/byebyevibe-guide.md` MUST include at least one concrete, copy-pasteable command sequence that fetches only the minimal install-fetch footprint (per the minimal-footprint requirement) into a target repository without cloning the full hub repository, and that results in the fetched paths landing at their real relative locations so the existing documented command `bash scripts/bootstrap-sdd.sh --profile <PROFILE>` runs unmodified afterward. The recipe MUST rely only on tooling already required by guide §1.1 (git) and MUST NOT introduce a new mandatory dependency.

This recipe is no longer the default acquisition path. The guide MUST present it **after** the release-download recipe and MUST scope it explicitly to acquiring **unreleased `master`** — development against the hub, or a repository state predating the first published Release. It MUST NOT be removed: it remains the only way to install a state that no Release covers.

#### Scenario: Recipe fetches only the required paths

- **WHEN** the documented lightweight-fetch recipe is followed against a target repository that has no `sdd-kit/` yet
- **THEN** the target repository ends up with `sdd-kit/`, `scripts/bootstrap-sdd.sh`, and `scripts/preflight-sdd.sh` populated, and no hub-only `doc/`, `openspec/`, `.cursor/`, or `.claude/` content is fetched

#### Scenario: Recipe is scoped to greenfield installs only

- **WHEN** the lightweight-fetch recipe is documented
- **THEN** the guide states it applies only when `sdd-kit/` is not already present in the target repository (C1), and does not apply to C2 (upgrade, which requires the existing `sdd-kit/upgrade.sh --dry-run`/`--apply` flow) or C3 (spec propagation, which must not run `install.sh`/`upgrade.sh`)

#### Scenario: Recipe is presented as the unreleased-master path

- **WHEN** an operator reads §1.6 looking for how to acquire the kit
- **THEN** the release-download recipe appears first, and the lightweight-fetch recipe appears after it, labelled as the path for installing from unreleased `master` or from a state predating the first Release

### Requirement: AI-assisted install prompt defaults to the latest published Release

The §2.0 AI-assisted installation prompt in `doc/byebyevibe-guide.md` MUST instruct the agent to acquire the kit from the **latest published GitHub Release** by default when installing into a genuine greenfield target repository. It MUST name two non-default alternatives and state the condition that selects each: the lightweight no-full-clone fetch recipe, for installing from unreleased `master`; and a full hub clone, for cases where the operator explicitly wants the persistent multi-project hub→destination workflow (per `clarify-install-scope-ux`, guide §1.6).

The prompt MUST NOT require the agent to know a version number in advance, and MUST direct it to verify the published checksum before extracting.

#### Scenario: Agent prompt names the Release first

- **WHEN** an agent follows the §2.0 AI-assisted installation prompt for a target repository with no existing `sdd-kit/`
- **THEN** the prompt directs it to the release-download path before mentioning either the lightweight-fetch recipe or a full hub clone, and names each of those two only as the alternative for its stated condition

#### Scenario: Agent is told to verify before extracting

- **WHEN** an agent follows the §2.0 prompt's default acquisition path
- **THEN** the prompt instructs it to verify the archive against the published `.sha256` sidecar before extracting

# sdd-supply-chain Specification

## Purpose

Normative requirements for automated dependency maintenance (Renovate) and vulnerability scanning (OSV-Scanner) in SDD-managed repositories. Complements `sdd-ci-gates` with supply-chain-specific templates, profile flags, and agent/human operational guidance.

## Requirements

### Requirement: OSV-Scanner blocks merge when lockfile vulnerabilities exist

When the repository contains at least one supported lockfile at the repository root, every `pull_request` and `push` to a base branch MUST pass OSV-Scanner as part of the `SDD Gates` workflow before merge. The scan MUST be **fail-closed**: if OSV-Scanner reports a vulnerability in a committed lockfile, the workflow MUST exit non-zero.

Supported lockfiles include at minimum: `package-lock.json`, `pnpm-lock.yaml`, `yarn.lock`, `poetry.lock`, `Pipfile.lock`, `Cargo.lock`, `go.sum`, `Gemfile.lock`, and `composer.lock`.

#### Scenario: PR with vulnerable npm lockfile

- **WHEN** a pull request modifies `package-lock.json` containing a known vulnerability
- **THEN** the `SDD Gates` workflow fails on the OSV-Scanner step and the PR check is red

#### Scenario: Repository without lockfile

- **WHEN** no supported lockfile exists at the repository root
- **THEN** the OSV-Scanner step is skipped with an explicit log message and does not block the workflow

#### Scenario: Clean lockfile

- **WHEN** lockfiles are present and contain no reported vulnerabilities
- **THEN** the OSV-Scanner step succeeds and the workflow continues

### Requirement: OSV-Scanner action uses immutable SHA pinning

The OSV-Scanner step MUST reference `google/osv-scanner-action/osv-scanner-action` pinned to a full 40-character commit SHA with a trailing `# vX.Y.Z` comment. Mutable tag references (`@v2`, `@main`, etc.) MUST NOT appear in the step.

#### Scenario: Workflow security review

- **WHEN** `.github/workflows/sdd-gates.yml` is reviewed for supply-chain compliance
- **THEN** the OSV-Scanner `uses:` line contains a 40-character SHA and a version comment, with no mutable tag

### Requirement: Renovate config distributed for APP and HYBRID profiles

`sdd-kit/templates/renovate.json` MUST exist as a conservative Renovate preset (grouped non-major updates, scheduled PRs, patch automerge only when documented and CI-green, no major automerge). `sdd-kit/install.sh` MUST copy `renovate.json` to the repository root only for profiles **APP** and **HYBRID**. Profile **DOCS_SPECS** MUST NOT receive `renovate.json` by default.

#### Scenario: Kit install APP profile

- **WHEN** `bash sdd-kit/install.sh --profile APP` runs in a consumer repository
- **THEN** `renovate.json` is created from the kit template at the repository root

#### Scenario: Kit install DOCS_SPECS profile

- **WHEN** `bash sdd-kit/install.sh --profile DOCS_SPECS` runs
- **THEN** `renovate.json` is not copied and the installer logs an explicit SKIP for Renovate

### Requirement: Renovate GitHub App activation is manual

The SDD kit MUST NOT commit Renovate tokens, passwords, or GitHub App credentials. Activation of the hosted Mend Renovate GitHub App MUST be documented as `[AÇÃO MANUAL NECESSÁRIA]` in the human operations guide (`doc/sistema-sdd-pedro.md`).

#### Scenario: Repository inspection for secrets

- **WHEN** `renovate.json` and related kit templates are reviewed
- **THEN** no API keys, tokens, or passwords are present in versioned files

### Requirement: Supply chain gates are profile-aware in MANIFEST

`sdd-kit/MANIFEST.yaml` MUST register `renovate.json` with `profiles: [APP, HYBRID]` only. The updated `sdd-gates.yml` template entry MUST remain available for `[APP, DOCS_SPECS, HYBRID]`. Kit version MUST be bumped (minor) when these entries are added.

#### Scenario: MANIFEST profile filter

- **WHEN** `install.sh` processes MANIFEST entries for profile DOCS_SPECS
- **THEN** `renovate.json` is excluded and `sdd-gates.yml` is still installed

### Requirement: Agent classification of supply-chain PRs

`AGENTS.md` MUST document that Renovate pull requests are classified independently of the active SDD task: patches as type **A**, minor/major updates as type **B** or **C** requiring human review. An OSV-Scanner failure in CI MUST be treated as type **B** (fix dependency before merge or archive).

#### Scenario: Renovate patch PR during feature work

- **WHEN** a Renovate patch PR arrives while an agent is executing a type D feature change
- **THEN** the agent classifies the Renovate PR as type A and does not conflate it with the in-progress feature classification

#### Scenario: OSV failure on current PR

- **WHEN** the `SDD Gates` workflow reports OSV-Scanner failure on the active pull request
- **THEN** the agent treats the failure as a dependency fix (type B) before proceeding with merge or `/opsx:archive`

### Requirement: Rollback disables supply chain gates without residual state

Removing the OSV-Scanner step from `sdd-gates.yml` MUST immediately disable vulnerability gating. Removing `renovate.json` and uninstalling the Renovate GitHub App MUST stop automated update PRs. No local binary or hook installation is required for rollback.

#### Scenario: Emergency disable OSV

- **WHEN** an operator removes the OSV-Scanner step from `.github/workflows/sdd-gates.yml` and pushes
- **THEN** subsequent PRs no longer run OSV-Scanner and no local uninstall is required

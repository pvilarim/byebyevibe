## ADDED Requirements

### Requirement: Install kit section in infrastructure manifest

`openspec/infra.md` MUST include an **Install Kit** section listing: kit version, path (`sdd-kit/` or "expanded only"), `install.sh` / `upgrade.sh` / `verify.sh` status, and last verification timestamp.

#### Scenario: Agent reads kit version from infra

- **WHEN** an agent reads `openspec/infra.md` before proposing SDD reinstall
- **THEN** the Install Kit section shows version and ✅ when kit matches guide version in `project.md`

#### Scenario: Verify infra updates kit section

- **WHEN** `bash scripts/verify-infra.sh` completes successfully on a hub repo
- **THEN** `openspec/infra.md` Install Kit section reflects current `MANIFEST.yaml` version

## MODIFIED Requirements

### Requirement: Manifest sections

`openspec/infra.md` MUST include at minimum these sections: SDD Stack (repo), MCP Servers, Skills (repo), **Install Kit**, Session Coordination (when applicable), Env vars present (names only), and Agent rules summary. Each section MUST include a "verify with" column or command reference.

#### Scenario: Agent reads manifest structure

- **WHEN** an agent opens `openspec/infra.md`
- **THEN** it finds tabular entries for OpenSpec, GitNexus, Graphify, and Install Kit with version and status columns

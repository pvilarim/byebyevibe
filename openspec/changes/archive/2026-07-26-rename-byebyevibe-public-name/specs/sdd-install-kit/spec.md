## ADDED Requirements

### Requirement: Public display name vs install payload path

Public documentation for the install kit MUST treat **ByeByeVibe** as the human-facing project name and MUST keep the on-disk payload directory name `sdd-kit/` (including `MANIFEST.yaml`, `install.sh`, `upgrade.sh`, `verify.sh`, and documented CLI invocations). Install and upgrade commands in docs MUST continue to reference `sdd-kit/` unless a future change explicitly migrates the directory (**BREAKING**, out of scope of the ByeByeVibe rename).

#### Scenario: Kit README states dual naming

- **WHEN** an operator opens `sdd-kit/README.md`
- **THEN** the title or first-contact intro identifies ByeByeVibe as the public name and still documents commands under `sdd-kit/`

#### Scenario: Install CTA path unchanged

- **WHEN** install instructions are copied from hub or kit README
- **THEN** they invoke `sdd-kit/install.sh` (or other `sdd-kit/` scripts), not a renamed payload folder

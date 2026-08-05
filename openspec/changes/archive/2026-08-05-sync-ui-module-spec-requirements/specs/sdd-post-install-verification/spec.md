## ADDED Requirements

### Requirement: UI module verification checklist

`doc/byebyevibe-guide.md` MUST include a **§2.11.1 UI module verification checklist** for the optional C1-UI module, referenced from the §2.11 UI module procedure. The checklist MUST be an **extension** of the §2.8 post-installation checklist, never a replacement for it: a repository that applied C1-UI runs both.

The checklist MUST cover at minimum: the `install-ui-module.sh --detect` outcome, the recorded `UI stack` value in `openspec/project.md` or `openspec/infra.md`, the presence of `doc/design/002-ui-module-install.md`, and the Impeccable status in `openspec/infra.md`.

#### Scenario: Operator verifies after applying the UI module

- **WHEN** the operator completes `bash sdd-kit/install-ui-module.sh --apply`
- **THEN** guide §2.11.1 lists the checks to run, and §2.11 points to it as the verification step

#### Scenario: UI checklist does not replace the core checklist

- **WHEN** an operator applied C1-UI on top of C1
- **THEN** §2.11.1 is presented as an addition to §2.8, and §2.8 remains required for the core install

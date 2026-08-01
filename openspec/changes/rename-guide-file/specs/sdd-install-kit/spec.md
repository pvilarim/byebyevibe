# sdd-install-kit Specification (delta)

## MODIFIED Requirements

### Requirement: Versioned install kit directory

The distribution repository MUST include `sdd-kit/` at repository root with at minimum: `MANIFEST.yaml`, `README.md`, `install.sh`, `upgrade.sh`, `verify.sh`, and `templates/` mirroring target repository paths.

#### Scenario: Hub repository layout

- **WHEN** an operator clones the SDD distribution hub (e.g. spec-pedro)
- **THEN** `sdd-kit/MANIFEST.yaml` exists with `version` and `guide_version` fields matching `doc/byebyevibe-guide.md` header changelog entry

#### Scenario: Manifest lists all curated SDD files

- **WHEN** `MANIFEST.yaml` is read
- **THEN** every file required by `sdd-post-install-verification` and `sdd-session-coordination` for a complete SDD install appears with `path`, `source`, `merge` strategy, and `gate` command

### Requirement: Guide documents project organization and scenarios

`doc/byebyevibe-guide.md` MUST include section **§1.6** (or equivalent numbered section) documenting: four-layer model (procedure / payload / specs / workspace state), scenarios C1 (greenfield), C2 (SDD upgrade), C2b (CLI-only), C3 (spec propagation without SDD reinstall), and profile differences APP / DOCS_SPECS / HYBRID.

#### Scenario: Human reads installation scenarios

- **WHEN** an operator opens the canonical guide before first install
- **THEN** §1.6 lists entry commands for each scenario and states that payloads come from `sdd-kit/`, not markdown extraction

#### Scenario: Agent reads installation scenarios

- **WHEN** an agent is prompted to install SDD in a foreign repository
- **THEN** the guide directs it to `sdd-kit/install.sh` with profile flag rather than extracting §12 code blocks for scripts

### Requirement: Version alignment on release

On each kit release, `MANIFEST.yaml` `version`, guide header version, guide changelog §14 entry, and `openspec/project.md` Cross-references MUST reference the same semantic version. The canonical guide path is `doc/byebyevibe-guide.md` (renamed 2026-08 from `doc/sistema-sdd-pedro.md`; pre-rename artifacts cite the old name for the same document).

#### Scenario: Version consistency check

- **WHEN** `grep guide_version sdd-kit/MANIFEST.yaml` returns `1.7.0`
- **THEN** `doc/byebyevibe-guide.md` changelog includes `1.7.0` and `openspec/project.md` references guide **v1.7.0**

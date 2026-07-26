# sdd-install-kit Specification (delta)

## MODIFIED Requirements

### Requirement: Versioned install kit directory

The distribution repository MUST include `sdd-kit/` at repository root with at minimum: `MANIFEST.yaml`, `README.md`, `install.sh`, `upgrade.sh`, `verify.sh`, `install-ui-module.sh`, and `templates/` mirroring target repository paths. The `templates/` tree MUST include `.github/workflows/sdd-gates.yml` so the SDD CI gate is distributable.

#### Scenario: Manifest lists CI gate workflow

- **WHEN** `MANIFEST.yaml` is read after the CI gates release
- **THEN** an entry exists for `.github/workflows/sdd-gates.yml` with `source: templates/.github/workflows/sdd-gates.yml`, `merge: COPY`, profiles `[APP, DOCS_SPECS, HYBRID]`, and a `gate` command

#### Scenario: verify.sh checks the CI gate template

- **WHEN** `bash sdd-kit/verify.sh` runs on the hub repository
- **THEN** it verifies the presence of `.github/workflows/sdd-gates.yml` (or its kit template) and reports pass/fail

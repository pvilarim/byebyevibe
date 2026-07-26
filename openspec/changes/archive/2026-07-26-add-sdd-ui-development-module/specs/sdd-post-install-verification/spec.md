# sdd-post-install-verification Specification (delta)

## MODIFIED Requirements

### Requirement: Post-install verification checklist

The canonical guide MUST include checklist **§2.11.1** for optional UI module verification, referenced from §2.8 as an extension (not replacement) for repositories that applied C1-UI.

#### Scenario: UI module checklist after apply

- **WHEN** the operator completes `install-ui-module.sh --apply`
- **THEN** §2.11.1 items include: `--detect` output archived, `UI stack` in project.md or infra.md, `doc/design/002` present, Impeccable status in infra.md

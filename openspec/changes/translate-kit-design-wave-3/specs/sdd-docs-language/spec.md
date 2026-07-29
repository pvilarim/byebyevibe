## ADDED Requirements

### Requirement: translate-kit-design-wave-3 target surface is English

The following path MUST be written in English after substitution: `sdd-kit/templates/doc/design/001-pipeline-open-design-shadcn-impeccable.md`. Residual Portuguese prose in the substituted slice (lines 1–325) is FORBIDDEN after apply. Dual-file siblings such as `*.en.md` or `*-pt.md` MUST NOT be introduced. Freeze-list tokens (paths, change-ids, `/opsx:*`, package pins, URLs, fenced shell, profile labels, and brand/tool names) MUST remain unaltered aside from intentional non-i18n fixes. G-MANIFEST satisfied when kit templates change. Kit template checksums MUST be regenerated when templates change.

#### Scenario: Per-wave verification passes

- **WHEN** an operator runs the wave gate command after apply
- **THEN** the script exits 0 (including G-PT and G-LINK on `sdd-kit/templates/doc/design/001-pipeline-open-design-shadcn-impeccable.md`)

#### Scenario: No dual-file migration

- **WHEN** the wave apply completes
- **THEN** English content remains at `sdd-kit/templates/doc/design/001-pipeline-open-design-shadcn-impeccable.md` with no permanent `*.en.md` / `*-pt.md` sibling

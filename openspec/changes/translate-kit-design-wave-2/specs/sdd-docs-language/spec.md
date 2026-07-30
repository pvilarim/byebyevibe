## ADDED Requirements

### Requirement: Kit design wave-2 Impeccable reference template is English

The following kit design template path MUST be written in English after the kit-design substitution wave: `sdd-kit/templates/doc/design/000-impeccable-design-system-guia.md`. Residual Portuguese prose in this file is FORBIDDEN after apply. Dual-file siblings such as `*.en.md` or `*-pt.md` MUST NOT be introduced for this path. Freeze-list tokens (paths, change-ids, slash commands such as `/opsx:*`, package pins, URLs, fenced shell commands, profile label `DOCS_SPECS`, MANIFEST keys such as `sha256:` / `gate:`, and brand/tool names including Impeccable and shadcn) MUST remain unaltered aside from intentional non-i18n fixes. Reference / adaptation status meaning, DOCS_SPECS hub vs APP-target applicability notes, shadcn-default stance, and adoption checklist semantics MUST keep the same meaning after prose is normalized to glossary-canonical English. When this template changes, `sdd-kit/MANIFEST.yaml` checksums MUST be regenerated so kit integrity verification passes.

#### Scenario: Kit design wave-2 file passes per-wave verification

- **WHEN** an operator runs `bash scripts/verify-i18n-wave.sh --files sdd-kit/templates/doc/design/000-impeccable-design-system-guia.md` after the kit-design substitution is applied
- **THEN** the script exits 0 (including G-PT, G-LINK, and G-MANIFEST on that file)

#### Scenario: No dual-file migration for kit design wave-2

- **WHEN** the kit-design substitution wave apply completes
- **THEN** English content is at `sdd-kit/templates/doc/design/000-impeccable-design-system-guia.md` and no permanent `*.en.md` / `*-pt.md` sibling exists for that path

#### Scenario: Kit MANIFEST checksums match after template substitution

- **WHEN** an operator runs `bash sdd-kit/gen-manifest-checksums.sh` after editing the kit Impeccable reference template and then runs `bash sdd-kit/verify.sh`
- **THEN** kit integrity verification exits 0 for the updated `sha256:` fields

#### Scenario: Reference and applicability semantics remain stable in kit mirror

- **WHEN** an agent reads the kit Impeccable design-system reference template after substitution
- **THEN** import/adaptation status, DOCS_SPECS hub non-install stance, `[if applicable]` surface notes, shadcn-default guidance, and adoption checklist meaning remain equivalent to the pre-wave Portuguese kit template (and to hub `doc/design/000-impeccable-design-system-guia.md` when that hub wave is apply-complete) while surrounding prose and headings are English

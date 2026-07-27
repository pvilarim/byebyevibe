## ADDED Requirements

### Requirement: Design wave-2 Impeccable reference guide is English

The following design documentation path MUST be written in English after the design substitution wave: `doc/design/000-impeccable-design-system-guia.md`. Residual Portuguese prose in this file is FORBIDDEN after apply. Dual-file siblings such as `*.en.md` or `*-pt.md` MUST NOT be introduced for this path. Freeze-list tokens (paths, change-ids, slash commands such as `/opsx:*`, package pins, URLs, fenced shell commands, profile label `DOCS_SPECS`, and brand/tool names including Impeccable and shadcn) MUST remain unaltered aside from intentional non-i18n fixes. Reference / adaptation status meaning, DOCS_SPECS hub vs APP-target applicability notes, shadcn-default stance, and adoption checklist semantics MUST keep the same meaning after prose is normalized to glossary-canonical English.

#### Scenario: Design wave-2 file passes per-wave verification

- **WHEN** an operator runs `bash scripts/verify-i18n-wave.sh --files doc/design/000-impeccable-design-system-guia.md` after the design substitution is applied
- **THEN** the script exits 0 (including G-PT and G-LINK on that file)

#### Scenario: No dual-file migration for design wave-2

- **WHEN** the design substitution wave apply completes
- **THEN** English content is at `doc/design/000-impeccable-design-system-guia.md` and no permanent `*.en.md` / `*-pt.md` sibling exists for that path

#### Scenario: Reference and applicability semantics remain stable

- **WHEN** an agent reads the Impeccable design-system reference guide after substitution
- **THEN** import/adaptation status, DOCS_SPECS hub non-install stance, `[if applicable]` surface notes, shadcn-default guidance, and adoption checklist meaning remain equivalent to the pre-wave Portuguese doc while surrounding prose and headings are English

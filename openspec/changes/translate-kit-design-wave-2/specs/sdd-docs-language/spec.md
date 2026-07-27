## ADDED Requirements

### Requirement: Kit design wave-2 Impeccable guide mirror is English

The kit design template path `sdd-kit/templates/doc/design/000-impeccable-design-system-guia.md` MUST be written in English after the kit design wave-2 substitution. Residual Portuguese prose in that file is FORBIDDEN after apply, including titles, tables, callouts, checklists, and status/applicability markers that previously used Portuguese forms such as `[REFERÊNCIA — REQUER ADAPTAÇÃO]` or `[se aplicável]` (those MUST be normalized to English equivalents that preserve the same meaning, e.g. reference/adaptation-required and `[if applicable]`). Dual-file siblings such as `*.en.md` or `*-pt.md` MUST NOT be introduced for this path. Freeze-list tokens (paths including `doc/sistema-sdd-pedro.md`, `sdd-kit/`, and related design relative links; slash commands such as `/opsx:*` and Impeccable slash commands; package pins; fenced shell; profile label `DOCS_SPECS`; brand/tool names including Impeccable, shadcn, ByeByeVibe, Open Design, Pencil, and Figma) MUST remain unaltered aside from intentional non-i18n fixes.

When this template under `sdd-kit/templates/` is edited, `sdd-kit/MANIFEST.yaml` checksums MUST be regenerated with `bash sdd-kit/gen-manifest-checksums.sh` so G-MANIFEST / kit verify remain green. Normative adoption guidance (Impeccable complements rather than replaces SDD skills; DOCS_SPECS hub does not host the Next.js app paths; `[if applicable]` scopes APP-target notes) MUST keep the same meaning after prose is normalized to glossary-canonical English.

#### Scenario: Kit design wave-2 file passes per-wave verification

- **WHEN** an operator runs `bash scripts/verify-i18n-wave.sh --files sdd-kit/templates/doc/design/000-impeccable-design-system-guia.md` after the wave-2 substitution is applied
- **THEN** the script exits 0 (including G-PT, G-LINK, and G-MANIFEST for the touched kit template)

#### Scenario: No dual-file migration for kit design wave-2

- **WHEN** the kit design wave-2 substitution apply completes
- **THEN** English content is at `sdd-kit/templates/doc/design/000-impeccable-design-system-guia.md` and no permanent `*.en.md` / `*-pt.md` sibling exists for that path

#### Scenario: Impeccable adoption guidance remains stable

- **WHEN** an agent reads the kit Impeccable guide mirror after substitution
- **THEN** DOCS_SPECS hub vs APP-target applicability, “complements / does not replace” SDD skills guidance, and future pipeline integration pointers to the canonical guide / kit remain equivalent to the pre-wave Portuguese prose while surrounding text is English

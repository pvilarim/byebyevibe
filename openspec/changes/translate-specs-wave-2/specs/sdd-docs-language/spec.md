## ADDED Requirements

### Requirement: Specs wave-2 sdd-install-kit residual PT is English

The capability specification path `openspec/specs/sdd-install-kit/spec.md` MUST be written in English after the specs substitution wave-2. Residual Portuguese prose in free requirement/scenario text is FORBIDDEN after apply, including mixed Portuguese fragments in otherwise English requirements (for example MANIFEST merge classification wording, bootstrap HYBRID warning narration, upgrade dry-run `COPY` labeling narration, and upgrade header mode narration). Dual-file siblings such as `*.en.md` or `*-pt.md` MUST NOT be introduced for this path. Freeze-list tokens (paths including `sdd-kit/`, `MANIFEST.yaml`, `install.sh`, `upgrade.sh`, `verify.sh`, `bootstrap-sdd.sh`, and `UPGRADE_REPORT.md`; merge strategy identifiers `COPY` / `MERGE` / `APPLY_TEMPLATE`; profile names APP / DOCS_SPECS / HYBRID; slash commands such as `/opsx:*`; package pins; fenced shell commands; OpenSpec keywords `MUST` / `WHEN` / `THEN`; brand/tool names including **ByeByeVibe**) MUST remain unaltered aside from intentional non-i18n fixes. Runtime contract strings that live shell scripts match or emit today — including `[x] Actualização aprovada` as grepped by `sdd-kit/upgrade.sh --apply`, and the bootstrap stderr WARN/confirm lines currently emitted by `sdd-kit/templates/scripts/bootstrap-sdd.sh` — MUST remain byte-stable when cited as literals; surrounding prose that describes those contracts MUST be English. Normative semantics of install integrity, path-traversal blocking, dry-run vs apply mutual exclusion, backup-before-overwrite, and approval gating MUST keep the same meaning after prose is normalized to glossary-canonical English.

#### Scenario: Specs wave-2 file passes per-wave verification

- **WHEN** an operator runs `bash scripts/verify-i18n-wave.sh --files openspec/specs/sdd-install-kit/spec.md` after the specs substitution is applied
- **THEN** the script exits 0 for G-INV, G-GLOSS, G-LINK, and G-OPENSPEC, and G-PT either passes or only hits documented allowlisted freeze/runtime contract literals inside that file

#### Scenario: No dual-file migration for specs wave-2

- **WHEN** the specs substitution wave-2 apply completes
- **THEN** English content (aside from frozen quoted runtime contract strings) is at `openspec/specs/sdd-install-kit/spec.md` and no permanent `*.en.md` / `*-pt.md` sibling exists for that path

#### Scenario: Install-kit contracts remain stable

- **WHEN** an agent reads `openspec/specs/sdd-install-kit/spec.md` after substitution
- **THEN** sha256 integrity abort behavior, path traversal blocking, dry-run `COPY` (not `APPLY_TEMPLATE`) labeling, mutually exclusive `--dry-run`/`--apply`, backup-before-overwrite, and the requirement that `--apply` checks for `[x] Actualização aprovada` remain equivalent to the pre-wave Portuguese/mixed prose while surrounding requirement and scenario narration is English

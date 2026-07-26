## ADDED Requirements

### Requirement: Kit README and AGENTS install templates (W2 slice) are English

The files `sdd-kit/README.md`, `sdd-kit/templates/AGENTS.core.md`, `sdd-kit/templates/AGENTS.commands.DOCS_SPECS.md`, and `sdd-kit/templates/AGENTS.commands.APP.md` MUST be written in English as the canonical language of those surfaces. Residual Portuguese prose in these files is FORBIDDEN after the W2 substitution wave. Dual-file siblings such as `*.en.md` or `*-pt.md` MUST NOT be introduced for these paths. Freeze-list tokens (paths, brand/tool names, profile codes `APP`/`DOCS_SPECS`/`HYBRID`, scenario codes `C1`/`C2`/`C2b`/`C3`/`C1-UI`/`G2`/`G4`, package pins, shell/CI command fences, and HTML markers `<!-- SDD_KIT_COMMANDS_START -->` / `<!-- SDD_KIT_COMMANDS_END -->`) MUST remain unaltered aside from intentional non-i18n fixes. When any of the three template paths under `sdd-kit/templates/` change, MANIFEST checksums MUST be regenerated so `bash sdd-kit/verify.sh` passes (G-MANIFEST).

#### Scenario: W2 file list passes per-wave verification

- **WHEN** an operator runs `bash scripts/verify-i18n-wave.sh --files sdd-kit/README.md,sdd-kit/templates/AGENTS.core.md,sdd-kit/templates/AGENTS.commands.DOCS_SPECS.md,sdd-kit/templates/AGENTS.commands.APP.md` after the W2 substitution is applied
- **THEN** the script exits 0 (including G-PT and G-MANIFEST on that file list)

#### Scenario: No dual-file migration for W2 kit AGENTS/README

- **WHEN** W2 apply completes
- **THEN** English content is at the four paths listed above and no permanent `*.en.md` / `*-pt.md` sibling for those paths exists

#### Scenario: AGENTS command-injection markers preserved

- **WHEN** an agent reads `sdd-kit/templates/AGENTS.core.md` after W2
- **THEN** both `<!-- SDD_KIT_COMMANDS_START -->` and `<!-- SDD_KIT_COMMANDS_END -->` remain present and byte-identical so `install.sh` profile injection continues to work

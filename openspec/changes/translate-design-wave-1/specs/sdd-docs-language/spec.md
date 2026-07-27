## ADDED Requirements

### Requirement: Design wave-1 module-install surfaces are English

The following design documentation paths MUST be written in English after the design substitution wave: `doc/design/002-ui-module-install.md`, `doc/design/003-ui-stack-adapters.md`, and `doc/design/004-probity-module-install.md`. Residual Portuguese prose in any of these files is FORBIDDEN after apply. Dual-file siblings such as `*.en.md` or `*-pt.md` MUST NOT be introduced for these paths. Freeze-list tokens (paths, change-ids, slash commands such as `/opsx:*`, script names including `install-ui-module.sh` and `install-probity-module.sh`, package pins, URLs, fenced shell commands, scenario labels `C1-UI` and `G2`, and brand/tool names) MUST remain unaltered aside from intentional non-i18n fixes. Install / detect / apply procedure semantics (including “what `--apply` does not do” lists and adapter opt-out steps) MUST keep the same meaning after prose is normalized to glossary-canonical English.

#### Scenario: Design wave-1 files pass per-wave verification

- **WHEN** an operator runs `bash scripts/verify-i18n-wave.sh --files doc/design/002-ui-module-install.md,doc/design/003-ui-stack-adapters.md,doc/design/004-probity-module-install.md` after the design substitution is applied
- **THEN** the script exits 0 (including G-PT and G-LINK on those files)

#### Scenario: No dual-file migration for design wave-1

- **WHEN** the design substitution wave apply completes
- **THEN** English content is at the three listed `doc/design/` paths and no permanent `*.en.md` / `*-pt.md` sibling exists for any of them

#### Scenario: Install procedure semantics remain stable

- **WHEN** an agent reads the C1-UI, UI stack adapters, and Probity G2 install docs after substitution
- **THEN** detect→apply command sequences, scenario applicability, and “does not” / opt-out constraints remain equivalent to the pre-wave Portuguese docs while surrounding prose and headings are English

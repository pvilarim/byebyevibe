## ADDED Requirements

### Requirement: Kit design wave-1 module-install mirrors are English

The following install-kit design documentation template paths MUST be written in English after the kit design substitution wave: `sdd-kit/templates/doc/design/002-ui-module-install.md`, `sdd-kit/templates/doc/design/003-ui-stack-adapters.md`, and `sdd-kit/templates/doc/design/004-probity-module-install.md`. Residual Portuguese prose in any of these files is FORBIDDEN after apply. Dual-file siblings such as `*.en.md` or `*-pt.md` MUST NOT be introduced for these paths. Freeze-list tokens (paths, change-ids, slash commands such as `/opsx:*`, script names including `install-ui-module.sh` and `install-probity-module.sh`, package pins, URLs, fenced shell commands, scenario labels `C1-UI` and `G2`, and brand/tool names) MUST remain unaltered aside from intentional non-i18n fixes. Install / detect / apply procedure semantics (including “what `--apply` does not do” lists and adapter opt-out steps) MUST keep the same meaning after prose is normalized to glossary-canonical English. When these templates change, `sdd-kit/MANIFEST.yaml` `sha256:` fields MUST be regenerated so kit integrity verification passes (G-MANIFEST).

#### Scenario: Kit design wave-1 files pass per-wave verification

- **WHEN** an operator runs `bash scripts/verify-i18n-wave.sh --files sdd-kit/templates/doc/design/002-ui-module-install.md,sdd-kit/templates/doc/design/003-ui-stack-adapters.md,sdd-kit/templates/doc/design/004-probity-module-install.md` after the kit design substitution is applied
- **THEN** the script exits 0 (including G-PT, G-LINK, and G-MANIFEST for those template paths)

#### Scenario: No dual-file migration for kit design wave-1

- **WHEN** the kit design substitution wave apply completes
- **THEN** English content is at the three listed `sdd-kit/templates/doc/design/` paths and no permanent `*.en.md` / `*-pt.md` sibling exists for any of them

#### Scenario: Install procedure semantics remain stable in kit payloads

- **WHEN** an agent or consumer install reads the C1-UI, UI stack adapters, and Probity G2 kit design templates after substitution
- **THEN** detect→apply command sequences, scenario applicability, and “does not” / opt-out constraints remain equivalent to the pre-wave Portuguese templates while surrounding prose and headings are English

#### Scenario: MANIFEST checksums match after kit design template edits

- **WHEN** the three kit design templates are edited in this wave
- **THEN** `bash sdd-kit/gen-manifest-checksums.sh` has been run and `bash sdd-kit/verify.sh` exits 0

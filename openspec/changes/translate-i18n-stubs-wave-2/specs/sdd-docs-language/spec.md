## ADDED Requirements

### Requirement: Active translate proposal Session Handoff stubs (wave-2) are English

The following paths MUST be written in English after the i18n stubs substitution wave-2: `openspec/changes/translate-agents-rules-wave-1/proposal.md`, `openspec/changes/translate-agents-rules-wave-1b/proposal.md`, `openspec/changes/translate-agents-rules-wave-1c/proposal.md`, and `openspec/changes/translate-kit-wave-2c/proposal.md`. Residual Portuguese prose in any of these files is FORBIDDEN after apply. Dual-file siblings such as `*.en.md` or `*-pt.md` MUST NOT be introduced for these paths. Freeze-list tokens (paths, change-ids, slash commands such as `/opsx:*`, URLs, fenced shell commands, brand/tool names, and each stub's Gate `--files` path list) MUST remain unaltered aside from intentional non-i18n fixes. Session Handoff stub structure (phase command, Change path, Read/Gate/Infra lines) MUST keep the same meaning after Portuguese labels are normalized to glossary-canonical English matching `doc/i18n/CURSOR-AUTOMATIONS.md` §6 (`Read:`, `assume ✅ — do not reinstall`).

#### Scenario: Wave-2 stub files pass per-wave verification

- **WHEN** an operator runs `bash scripts/verify-i18n-wave.sh --files openspec/changes/translate-agents-rules-wave-1/proposal.md,openspec/changes/translate-agents-rules-wave-1b/proposal.md,openspec/changes/translate-agents-rules-wave-1c/proposal.md,openspec/changes/translate-kit-wave-2c/proposal.md` after the i18n stubs wave-2 substitution is applied
- **THEN** the script exits 0 (including G-PT and G-LINK on those files)

#### Scenario: No dual-file migration for wave-2 stubs

- **WHEN** the i18n stubs wave-2 substitution apply completes
- **THEN** English content is at the four listed paths and no permanent `*.en.md` / `*-pt.md` sibling exists for any of them

#### Scenario: Session Handoff stub labels are English on wave-2 targets

- **WHEN** an agent reads the Session Handoff stub in any of the four listed proposal files after apply
- **THEN** the stub uses English labels (`Read:`, `assume ✅ — do not reinstall`) and does not retain Portuguese stub labels (`Ler:`, `assumir`, `não reinstalar`) while preserving phase command, Change path, Gate command (including its `--files` list), and Infra pointer meaning

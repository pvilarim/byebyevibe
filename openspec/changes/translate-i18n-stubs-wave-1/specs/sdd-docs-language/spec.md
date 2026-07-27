## ADDED Requirements

### Requirement: i18n stub artifacts are English

The following paths MUST be written in English after the i18n stubs substitution wave-1: `doc/i18n/WAVE-PROPOSAL-TEMPLATE.md` and `openspec/changes/add-i18n-cursor-automations-guide/proposal.md`. Residual Portuguese prose in either file is FORBIDDEN after apply. Dual-file siblings such as `*.en.md` or `*-pt.md` MUST NOT be introduced for these paths. Freeze-list tokens (paths, change-ids, slash commands such as `/opsx:*`, URLs, fenced shell commands, brand/tool names, and template placeholders such as `translate-<surface>-wave-N`) MUST remain unaltered aside from intentional non-i18n fixes. Session Handoff stub structure (phase command, Change path, Read/Gate/Infra lines) MUST keep the same meaning after Portuguese labels are normalized to glossary-canonical English matching `doc/i18n/CURSOR-AUTOMATIONS.md` §6 (`Read:`, `assume ✅ — do not reinstall`).

#### Scenario: i18n stub files pass per-wave verification

- **WHEN** an operator runs `bash scripts/verify-i18n-wave.sh --files doc/i18n/WAVE-PROPOSAL-TEMPLATE.md,openspec/changes/add-i18n-cursor-automations-guide/proposal.md` after the i18n stubs wave-1 substitution is applied
- **THEN** the script exits 0 (including G-PT and G-LINK on those files)

#### Scenario: No dual-file migration for i18n stubs

- **WHEN** the i18n stubs wave-1 substitution apply completes
- **THEN** English content is at the two listed paths and no permanent `*.en.md` / `*-pt.md` sibling exists for either of them

#### Scenario: Session Handoff stub labels are English

- **WHEN** an agent reads the Session Handoff stub in `doc/i18n/WAVE-PROPOSAL-TEMPLATE.md` or in `openspec/changes/add-i18n-cursor-automations-guide/proposal.md` after apply
- **THEN** the stub uses English labels (`Read:`, `assume ✅ — do not reinstall`) and does not retain Portuguese stub labels (`Ler:`, `assumir`, `não reinstalar`) while preserving phase command, Change path, Gate command, and Infra pointer meaning

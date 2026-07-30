## ADDED Requirements

### Requirement: Active translate residual stubs (wave-3) are English

The following paths MUST be written in English after the i18n stubs substitution wave-3: `openspec/changes/translate-kit-wave-2d/proposal.md` and `openspec/changes/translate-agents-rules-wave-1b/simplify-review.md`. Residual Portuguese prose in any of these files is FORBIDDEN after apply. Dual-file siblings such as `*.en.md` or `*-pt.md` MUST NOT be introduced for these paths. Freeze-list tokens (paths, change-ids, slash commands such as `/opsx:*`, URLs, fenced shell commands, brand/tool names, and the W2d stub's Gate `--files` path list) MUST remain unaltered aside from intentional non-i18n fixes. The Session Handoff stub in `translate-kit-wave-2d/proposal.md` MUST keep the same meaning after Portuguese labels are normalized to glossary-canonical English matching `doc/i18n/CURSOR-AUTOMATIONS.md` §6 (`Read:`, `assume ✅ — do not reinstall`), including any prerequisite lines for `translate-kit-wave-2c`. The simplify-review note MUST preserve change-id identity and LEAN / ship semantics after language substitution.

#### Scenario: Wave-3 stub files pass per-wave verification

- **WHEN** an operator runs `bash scripts/verify-i18n-wave.sh --files openspec/changes/translate-kit-wave-2d/proposal.md,openspec/changes/translate-agents-rules-wave-1b/simplify-review.md` after the i18n stubs wave-3 substitution is applied
- **THEN** the script exits 0 (including G-PT and G-LINK on those files)

#### Scenario: No dual-file migration for wave-3 stubs

- **WHEN** the i18n stubs wave-3 substitution apply completes
- **THEN** English content is at the two listed paths and no permanent `*.en.md` / `*-pt.md` sibling exists for any of them

#### Scenario: Session Handoff stub labels are English on the W2d proposal

- **WHEN** an agent reads the Session Handoff stub in `openspec/changes/translate-kit-wave-2d/proposal.md` after apply
- **THEN** the stub uses English labels (`Read:`, `assume ✅ — do not reinstall`) and does not retain Portuguese stub labels (`Ler:`, `assumir`, `não reinstalar`) while preserving phase command(s), Change path, Gate command (including its `--files` list), and Infra pointer meaning

#### Scenario: simplify-review note is English

- **WHEN** an agent reads `openspec/changes/translate-agents-rules-wave-1b/simplify-review.md` after apply
- **THEN** the note is English, retains the `translate-agents-rules-wave-1b` change-id, and still communicates a LEAN / ship verdict without residual Portuguese review chrome

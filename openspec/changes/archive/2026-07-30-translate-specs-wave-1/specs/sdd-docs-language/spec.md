## ADDED Requirements

### Requirement: Specs wave-1 residual-PT capability specs are English

The following capability specification paths MUST be written in English after the specs substitution wave: `openspec/specs/sdd-ci-gates/spec.md`, `openspec/specs/sdd-post-install-verification/spec.md`, and `openspec/specs/sdd-session-coordination/spec.md`. Residual Portuguese prose in any of these files is FORBIDDEN after apply, including Purpose text, requirement bodies, and scenario WHEN/THEN prose that previously mixed Portuguese with English. Dual-file siblings such as `*.en.md` or `*-pt.md` MUST NOT be introduced for these paths. Freeze-list tokens (paths including `.github/workflows/sdd-gates.yml`, `sdd-kit/`, `scripts/sdd-session-*.sh`, `.sdd/runtime/`, `openspec/project.md`, `AGENTS.md`, `CLAUDE.md`, and `graphify-out/GRAPH_REPORT.md`; slash commands such as `/opsx:*`; package/Action pins; fenced shell commands; OpenSpec keywords `MUST` / `WHEN` / `THEN`; and brand/tool names) MUST remain unaltered aside from intentional non-i18n fixes. Normative semantics of CI fail-closed vs report-only `sdd-kit verify`, post-install verification MUST checks, and local apply lock / session registry behavior MUST keep the same meaning after prose is normalized to glossary-canonical English.

#### Scenario: Specs wave-1 files pass per-wave verification

- **WHEN** an operator runs `bash scripts/verify-i18n-wave.sh --files openspec/specs/sdd-ci-gates/spec.md,openspec/specs/sdd-post-install-verification/spec.md,openspec/specs/sdd-session-coordination/spec.md` after the specs substitution is applied
- **THEN** the script exits 0 (including G-PT and G-LINK on those files)

#### Scenario: No dual-file migration for specs wave-1

- **WHEN** the specs substitution wave apply completes
- **THEN** English content is at the three listed `openspec/specs/**/spec.md` paths and no permanent `*.en.md` / `*-pt.md` sibling exists for any of them

#### Scenario: CI / post-install / session-coordination contracts remain stable

- **WHEN** an agent reads the three capability specs after substitution
- **THEN** fail-closed OpenSpec/OSV/task-pattern gates vs report-only `sdd-kit verify`, post-install constitution/AGENTS/infra expectations, and per-worktree apply-lock semantics remain equivalent to the pre-wave Portuguese/mixed prose while surrounding requirement and scenario text is English

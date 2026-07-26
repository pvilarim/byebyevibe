# sdd-correctness-review Specification

## Purpose

Normative requirements for the `correctness-review` on-demand skill in the SDD system. The skill detects logic errors, unhandled edge cases, contract violations, invariant breaches, and silent failures in AI-generated code — filling the gap between `simplify-review` (complexity) and `security-reviewer` (vulnerabilities). Operates in mode C (on-demand), invoked explicitly after `/opsx:apply` on type B, C, or D tasks.

## Requirements

### Requirement: Skill file exists in canonical locations

The repository MUST contain a `correctness-review` skill file at `.claude/skills/correctness-review/SKILL.md` and an identical mirror at `.cursor/skills/correctness-review/SKILL.md`. Both files MUST be present and identical in content.

#### Scenario: Skill files are present

- **WHEN** a developer or agent checks for the correctness-review skill
- **THEN** both `.claude/skills/correctness-review/SKILL.md` and `.cursor/skills/correctness-review/SKILL.md` exist with identical content

#### Scenario: Missing mirror file

- **WHEN** only one of the two skill files exists
- **THEN** the installation is considered incomplete and the missing file MUST be created to match the existing one

---

### Requirement: Skill targets correctness exclusively

The `correctness-review` skill MUST focus exclusively on correctness defects: logic errors, unhandled edge cases, contract violations, invariant breaches, and silent failures. It MUST NOT report on code complexity, style, or security vulnerabilities (those belong to `simplify-review` and `security-reviewer` respectively).

#### Scenario: Skill finds a logic error

- **WHEN** the reviewed code contains a branch that produces an incorrect result for a valid input
- **THEN** the skill reports a `logic:` achado with the file/line location, description of the incorrect behavior, and a suggested fix or test case to expose it

#### Scenario: Skill finds an unhandled edge case

- **WHEN** the reviewed code does not handle a boundary input (null, empty, overflow, unicode, concurrent access)
- **THEN** the skill reports an `edge:` achado with the specific input that would fail and the expected behavior

#### Scenario: Simplicity issue detected during correctness review

- **WHEN** the reviewer notices over-engineering while reviewing for correctness
- **THEN** the skill MUST NOT report it — that finding belongs to `simplify-review`

#### Scenario: Security vulnerability detected during correctness review

- **WHEN** the reviewer notices a security issue while reviewing for correctness
- **THEN** the skill MUST NOT report it — that finding belongs to `security-reviewer`

---

### Requirement: Skill uses standardised output format

The `correctness-review` skill MUST produce output in the following structure:
1. Header block: change/escopo/veredito
2. Achados section: one finding per line using tags `logic:`, `edge:`, `contract:`, `race:`, `silent:`
3. Metric line: count of findings and severity summary
4. Veredito: one of `CORRECT`, `RISKY`, or `ESCOPO INSUFICIENTE`

#### Scenario: No findings

- **WHEN** the skill finds no correctness issues in the reviewed code
- **THEN** the output ends with `CORRECT` veredito and the message "No correctness issues found. Ship."

#### Scenario: Findings present

- **WHEN** the skill finds one or more correctness issues
- **THEN** the output ends with `RISKY` veredito and lists each finding with tag, location (file:line), description, and suggested fix or test vector

#### Scenario: Insufficient scope

- **WHEN** the diff is too small or contains no logic to evaluate (e.g., docs-only or config-only changes)
- **THEN** the output ends with `ESCOPO INSUFICIENTE` and the skill does not produce false findings

---

### Requirement: Skill is invoked on-demand only

The `correctness-review` skill MUST operate in mode C (on-demand) — invoked explicitly by the user or by the agent following the matrix A–E. It MUST NOT be configured as a hook, always-on rule, or automatic pre-commit check.

#### Scenario: User invokes the skill after apply

- **WHEN** the user or agent invokes `correctness-review` after `/opsx:apply` on a type B, C, or D task
- **THEN** the skill runs and produces its output without blocking any subsequent steps

#### Scenario: Trivial task (type A) or exploration (type E)

- **WHEN** a type A or type E task is completed
- **THEN** `correctness-review` is NOT invoked (matrix A–E: not applicable for those types)

---

### Requirement: Skill is registered in all 6 contract points

Per `metodologia-insercao.md` Fase 3, the skill MUST be registered in exactly 6 points: `openspec/infra.md` (R1), `AGENTS.md` (R2), skill files (R3), `doc/sistema-sdd-pedro.md` (R4), `doc/avaliacoes/` (R5), and `sdd-kit/` installation guidance (R6).

#### Scenario: Agent looks up the skill

- **WHEN** an agent reads `openspec/infra.md` (R10 compliance)
- **THEN** it finds `correctness-review` listed in the Skills section with status ✅

#### Scenario: Agent reads AGENTS.md

- **WHEN** an agent reads the "Reviews pós-implementação" section in `AGENTS.md`
- **THEN** it finds `correctness-review` listed with its pipeline position (before `simplify-review`) and the matrix A–E criteria

---

### Requirement: Pipeline position is documented and enforced by convention

The skill MUST be positioned in the pipeline immediately after tests (R6/TDD Guard) and before `simplify-review`. The order MUST be documented in `AGENTS.md` "Reviews pós-implementação" and in the skill's own `## Quando invocar` section.

#### Scenario: Full post-apply pipeline with all reviews

- **WHEN** a type D feature is complete and all reviews are applicable
- **THEN** the correct order is: testes → `correctness-review` → `simplify-review` → `security-reviewer` → commit → gates CI

#### Scenario: Bug fix (type B) pipeline

- **WHEN** a type B bug fix is complete
- **THEN** `correctness-review` MUST be applied (it is mandatory for type B — the skill helps catch regressions and verify the fix is correct)

---

### Requirement: Rollback procedure is documented

The `design.md` MUST contain a documented rollback procedure for removing the skill. The procedure MUST be executable in under 5 minutes without external dependencies.

#### Scenario: Decision to remove the skill

- **WHEN** a decision is made to remove `correctness-review`
- **THEN** the rollback steps in `design.md` can be executed to remove all 6 registration points and the skill files cleanly

## MODIFIED Requirements

### Requirement: Pipeline position is documented and enforced by convention

The skill MUST be positioned in the pipeline immediately after tests (R6/Probity `enforceTdd`) and before `simplify-review`. The order MUST be documented in `AGENTS.md` "Reviews pós-implementação" and in the skill's own `## Quando invocar` section.

#### Scenario: Full post-apply pipeline with all reviews

- **WHEN** a type D feature is complete and all reviews are applicable
- **THEN** the correct order is: testes (enforceTdd) → `correctness-review` → `simplify-review` → `security-reviewer` → commit → gates CI

#### Scenario: Bug fix (type B) pipeline

- **WHEN** a type B bug fix is complete
- **THEN** `correctness-review` MUST be applied (it is mandatory for type B — the skill helps catch regressions and verify the fix is correct)

#### Scenario: Probity not installed

- **WHEN** the repository has not installed the Probity module (DOCS_SPECS or APP without module)
- **THEN** the pipeline documents manual R6 compliance ("testes") without enforceTdd blocking, and `correctness-review` position remains unchanged

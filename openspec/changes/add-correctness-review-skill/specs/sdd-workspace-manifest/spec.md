## MODIFIED Requirements

### Requirement: Skills section lists all active review skills

The Skills section of `openspec/infra.md` MUST list all active on-demand review skills installed in the repository. After this change, it MUST include `correctness-review` alongside `simplify-review`.

#### Scenario: Agent reads infra.md to discover review skills

- **WHEN** an agent reads `openspec/infra.md` looking for available review skills (R10 compliance)
- **THEN** it finds both `simplify-review` and `correctness-review` listed with status ✅ and their respective phases

## ADDED Requirements

### Requirement: Semantic evidence supplements applicable task gates

For behavior-changing tasks, propose guidance MUST identify applicable semantic acceptance scenarios and an evidence location following `sdd-product-validation`, in addition to the existing deterministic Gate. Apply guidance MUST require both a successful Gate and recorded passing evidence for the task's required scenarios before marking it complete. Not-run, failed or stale affected evidence MUST NOT count as passed. Justified not-applicable scenarios MUST be explicit. The guide section 12.10 and hub propose/apply skill and duplicated command instructions MUST describe this rule without requiring a particular runtime or browser. Evidence MUST remain subordinate to OpenSpec tasks and SHALL NOT become a competing completion authority.

#### Scenario: Gate passes but interaction fails
- **WHEN** a task's shell Gate exits zero but its required interaction scenario fails
- **THEN** the task remains unchecked with the failure and next action recorded.

#### Scenario: All applicable checks evidenced
- **WHEN** the deterministic Gate passes and all required scenarios have passing evidence for the affected revision
- **THEN** the task can be marked complete with an evidence pointer while unrelated or unavailable scenarios are not silently counted as passed.

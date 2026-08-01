# sdd-operator-onboarding Specification (delta)

## ADDED Requirements

### Requirement: Day-1 doc narrates skill guidance

`doc/sdd-operator-day1.md` MUST include the skill-guidance section defined by `sdd-skill-guidance`, and `/opsx:help` MUST narrate it as part of the day-1 map. The section MUST follow the existing non-goals: no always-on rule and no forced pre-development skill-authoring step.

#### Scenario: Help surfaces skill guidance

- **WHEN** an operator invokes `/opsx:help` after this capability is applied
- **THEN** the day-1 walk includes where skills fit (memory over chat), when to create one, and how to ask the agent to create it

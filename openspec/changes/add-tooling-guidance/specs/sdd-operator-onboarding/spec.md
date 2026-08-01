# sdd-operator-onboarding Specification (delta)

## ADDED Requirements

### Requirement: Day-1 doc narrates tooling guidance

`doc/sdd-operator-day1.md` MUST include a plain-language tooling section covering: the resolution cascade (override → CLI → MCP → suggest → manual), the "key → CLI → MCP, unless only MCP delivers the capability" hierarchy, the permanent per-session context cost of active MCPs, and the session-scoped override. `/opsx:help` MUST narrate it as part of the day-1 map. The section MUST follow the existing non-goals: offer-only suggestions, never install unprompted, no always-on rule.

#### Scenario: Help surfaces tooling guidance

- **WHEN** an operator invokes `/opsx:help` after this capability is applied
- **THEN** the day-1 walk includes how the agent reaches external tools (cascade), why CLI is the default, when MCP is the right path, and that integrations are only ever suggested, never installed unprompted

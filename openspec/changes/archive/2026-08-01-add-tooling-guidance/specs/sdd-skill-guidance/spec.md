# sdd-skill-guidance Specification (delta)

## MODIFIED Requirements

### Requirement: Standard suggestion message with anti-noise cap

The skill suggestion message MUST have three fixed parts: what the skill WILL do (future sessions recall this automatically when the topic triggers), what it will NOT do (it does not self-update; stale data must be corrected by the user), and an explicit user decision. Suggestions MUST be offers, never impositions. The one-suggestion-per-session cap is **shared across proactive suggestion mechanisms** (skill and tooling, per `sdd-tooling-guidance`): at most one proactive suggestion per session of either kind, strongest signal wins.

#### Scenario: Suggestion carries expectations and respects the cap

- **WHEN** the agent detects a second skill-worthy signal in the same session after already suggesting once
- **THEN** no second suggestion is made in that session, and the earlier suggestion included the will/won't/decide parts

#### Scenario: Tooling suggestion spends the shared cap

- **WHEN** a tooling suggestion was already offered in the session and a domain-density signal later fires
- **THEN** no skill suggestion is made in that session

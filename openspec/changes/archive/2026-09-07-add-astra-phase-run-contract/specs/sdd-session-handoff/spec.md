## ADDED Requirements

### Requirement: Coordinated runs preserve phase-session boundaries
An Astra coordinator MUST launch each authorized OpenSpec phase as a separate run and session that consumes durable handoff and change artifacts. A coordinator conversation, demand map, receipt lineage or restart MUST NOT create a cross-phase session exemption or replace the Session Handoff. Coordinator state MAY reference artifacts but MUST NOT become phase memory or authority.

#### Scenario: Coordinator advances from propose toward apply
- **WHEN** an authorized propose run completes its artifacts and the dependency map identifies apply as ready
- **THEN** the coordinator records the propose outcome and launches apply only as a new phase session using the required handoff artifacts

#### Scenario: Coordinator restarts between phases
- **WHEN** the coordinator host or conversation is replaced after a completed phase
- **THEN** the next phase is reconstructed from durable artifacts and approval references rather than prior chat history


# Delta — sdd-language-policy

## MODIFIED Requirements

### Requirement: Hub distribution repo is grandfathered

The SDD distribution hub repository — identified exclusively by the explicit `.sdd-hub` marker file at its repository root, never by directory shape such as the presence of `sdd-kit/templates/` — MAY retain its existing language setup without re-running install prompts. The hub's effective policy remains: chat per operator preference (currently pt-BR in practice), `docs_language=en`, `code_language=en`, with `sdd-docs-language` PT→EN migration waves continuing on hub surfaces. This grandfathering MUST NOT extend to any consumer repository: `sdd-kit/verify.sh` MUST apply the language-policy verification in every repository that does not carry the marker, because the directory-shaped heuristic previously exempted every APP consumer and left the capability unverified everywhere it mattered. This change MUST NOT require modifying the hub's committed `AGENTS.md` or `openspec/project.md` as part of apply.

#### Scenario: Hub apply does not force re-prompt

- **WHEN** this change is applied and archived on the distribution hub
- **THEN** existing hub `AGENTS.md` Communication and `openspec/project.md` Conventions remain valid without mandatory regeneration from `install.sh`

#### Scenario: Consumer with full kit is not grandfathered

- **WHEN** `bash sdd-kit/verify.sh` runs in a consumer repository that has `sdd-kit/templates/` (whole-kit acquisition) but no `.sdd-hub` marker
- **THEN** the language-policy verification runs and its result affects the exit code

## ADDED Requirements

### Requirement: Language policy materializes in every install

Every completed C1 install MUST leave the language policy persisted in `openspec/project.md`: the kit ships a `project.md` template carrying the policy anchor markers (per `sdd-install-kit`), injection targets it, and both safety nets are blocking — `install.sh` FAILs if the file is absent at injection time, and `sdd-kit/verify.sh` FAILs on consumers when the policy block is missing. An install in which the three axes were resolved but never persisted MUST NOT report success (per `sdd-fail-loud`): absence of a persisted answer is a failure, not permission.

#### Scenario: Non-interactive APP install persists the policy

- **WHEN** `bash sdd-kit/install.sh --profile APP --chat-lang pt-BR --docs-lang en --code-lang en` completes in a greenfield repository
- **THEN** `openspec/project.md` exists and records the three axes between the anchor markers

#### Scenario: Unpersisted policy cannot verify green

- **WHEN** a consumer repository has no Language policy block in `openspec/project.md`
- **THEN** `bash sdd-kit/verify.sh` exits non-zero naming the missing block

## ADDED Requirements

### Requirement: Kit ships /opsx:help skill and command templates

`sdd-kit/MANIFEST.yaml` MUST register COPY-strategy entries (all profiles APP, DOCS_SPECS, HYBRID unless a future change narrows scope) for the ByeByeVibe `/opsx:help` skill and command mirrors, including at least: `.cursor/skills/openspec-help/SKILL.md`, `.claude/skills/openspec-help/SKILL.md`, `.cursor/commands/opsx-help.md`, `.claude/commands/opsx/help.md`, and `doc/sdd-operator-day1.md` (with matching `sdd-kit/templates/` sources and `sha256` fields).

#### Scenario: MANIFEST lists help skill template

- **WHEN** `sdd-kit/MANIFEST.yaml` is read after this capability is applied
- **THEN** an entry exists whose path is `.cursor/skills/openspec-help/SKILL.md` (or the documented kit path) with a `sha256` field

#### Scenario: install copies help surfaces

- **WHEN** `bash sdd-kit/install.sh --profile DOCS_SPECS` runs successfully against a greenfield target
- **THEN** the target receives the help skill, command mirrors, and `doc/sdd-operator-day1.md` from kit templates

### Requirement: install.sh emits day-1 operate tip naming help and onboard

After `sdd-kit/install.sh` prints its standard next-steps (and before or clearly alongside the optional add-ons teaser), it MUST print a short day-1 operate tip that names both `/opsx:help` and `/opsx:onboard`. The tip MUST NOT install modules, MUST NOT hide `/opsx:onboard`, and MUST follow resolved `chat_language` when available. `bootstrap-sdd.sh` manual next-steps MUST include an equivalent one-line reminder when didactic next-steps are shown.

#### Scenario: Successful install names both slash commands

- **WHEN** `bash sdd-kit/install.sh --profile APP` completes and prints next steps
- **THEN** stdout includes `/opsx:help` and `/opsx:onboard` in a day-1 operate tip

#### Scenario: Tip does not replace add-ons teaser

- **WHEN** install completes next-steps output
- **THEN** the day-1 operate tip and the optional add-ons teaser are both present as distinct reminders (tip does not remove add-ons teaser requirements)

### Requirement: AGENTS command templates include /opsx:help

Kit templates `sdd-kit/templates/AGENTS.commands.DOCS_SPECS.md` and `sdd-kit/templates/AGENTS.commands.APP.md` MUST include a Commands table row for `/opsx:help`.

#### Scenario: Both profile command templates list help

- **WHEN** either AGENTS commands template is read after apply
- **THEN** `/opsx:help` appears in the Commands table

# Delta: sdd-operator-onboarding — clarify-install-scope-ux

## ADDED Requirements

### Requirement: Day-1 doc section 0 explains install scope

Section 0 of `doc/sdd-operator-day1.md` MUST explain, in two to three sentences, the machine-once vs per-project install scope: machine-level CLIs install once and are reused by every project; each project receives its own payload copy plus its own generated state (`openspec/`, `graphify-out/`, `.gitnexus/`); and one command from the hub clone installs into any new project folder. The passage MUST link to guide §1.6 for the full scope model and MUST NOT duplicate the scope table. The addition MUST NOT create a new numbered section or renumber the existing section 0–9 spine, so the `/opsx:help` skill narration table remains valid without modification.

#### Scenario: Operator recalls scope via help

- **WHEN** an operator runs `/opsx:help` after install and reads the narrated section 0
- **THEN** they learn that CLIs installed once on the machine are reused, each project holds its own payload copy and generated state, and a single hub command installs into a new project folder

#### Scenario: Day-1 spine remains locked

- **WHEN** `doc/sdd-operator-day1.md` is read after this change
- **THEN** sections 0–9 keep their existing numbering and titles, and the `openspec-help` skill files are unchanged

#### Scenario: Scope passage links to canonical table

- **WHEN** the section 0 scope passage is read
- **THEN** it references guide §1.6 for the full install-scope table instead of reproducing it

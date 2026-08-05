# Delta: sdd-install-kit — simplify-install-profiles

## ADDED Requirements

### Requirement: Task pattern verifier distributed to all profiles

`sdd-kit/MANIFEST.yaml` MUST register `scripts/verify-task-patterns.sh` with `profiles: [APP, DOCS_SPECS, HYBRID]` so every install receives the verifier. Kit `version` MUST be bumped to at least **1.9.0** when this entry changes. The `sdd-gates.yml` template's task-patterns step message MUST NOT describe the script as DOCS_SPECS/HYBRID-only.

#### Scenario: APP install receives the verifier

- **WHEN** `bash sdd-kit/install.sh --profile APP` runs in a consumer repository
- **THEN** `scripts/verify-task-patterns.sh` is copied and executable after install

#### Scenario: Workflow message reflects universal distribution

- **WHEN** an operator reads the task-patterns step in the shipped `sdd-gates.yml`
- **THEN** the absent-script message points to reinstalling via sdd-kit without naming DOCS_SPECS/HYBRID as the only profiles

## MODIFIED Requirements

### Requirement: install.sh and upgrade.sh reject invalid profile values

`sdd-kit/install.sh` MUST validate `--profile` at argument parsing time and abort with a non-zero exit and an error naming the allowed values when the value is invalid — including when `--skip-preflight` is passed. `APP` and `DOCS_SPECS` are the active profiles. `HYBRID` MUST remain accepted as a **deprecated alias**: it is normalized to `APP` at parsing time with a one-line deprecation notice naming kit 1.9.0, and the run proceeds exactly as `--profile APP`. `sdd-kit/upgrade.sh` MUST apply the same validation and normalization whenever `--profile` is supplied. A run that would select zero MANIFEST entries due to an unrecognized profile MUST NOT report success.

#### Scenario: install.sh rejects invalid profile with preflight skipped

- **WHEN** the operator runs `bash sdd-kit/install.sh --profile FOO --skip-preflight`
- **THEN** the script exits non-zero with an error naming the allowed profiles, and copies no files

#### Scenario: upgrade.sh apply rejects invalid profile

- **WHEN** the operator runs `bash sdd-kit/upgrade.sh --from 1.0.0 --to 1.9.0 --apply --profile FOO`
- **THEN** the script exits non-zero with an error naming the allowed profiles, and applies no files

#### Scenario: HYBRID normalizes to APP with deprecation notice

- **WHEN** the operator runs `bash sdd-kit/install.sh --profile HYBRID`
- **THEN** the script prints a deprecation notice, proceeds with the APP profile, and exits as a successful APP install

### Requirement: bootstrap-sdd.sh accepts an explicit profile flag

`bootstrap-sdd.sh` MUST accept `--profile APP|DOCS_SPECS|HYBRID`. When supplied, the flag value MUST override profile auto-detection and be passed through to `sdd-kit/install.sh`, with `HYBRID` normalized to `APP` alongside a one-line deprecation notice (either in bootstrap or in `install.sh` — exactly one surface prints it). An invalid value MUST abort with a non-zero exit before any install phase runs.

#### Scenario: Explicit profile overrides detection

- **WHEN** the operator runs `bash scripts/bootstrap-sdd.sh --profile DOCS_SPECS` in a repo with `package.json`
- **THEN** `sdd-kit/install.sh` is invoked with `--profile DOCS_SPECS` and no auto-detection applies

#### Scenario: HYBRID flag still works as APP

- **WHEN** the operator runs `bash scripts/bootstrap-sdd.sh --profile HYBRID`
- **THEN** the install completes as an APP-profile install with a single deprecation notice

#### Scenario: Invalid profile aborts early

- **WHEN** the operator runs `bash scripts/bootstrap-sdd.sh --profile FOO`
- **THEN** the script exits non-zero with an error naming the allowed values, before phase 0 begins

### Requirement: Guide documents project organization and scenarios

`doc/byebyevibe-guide.md` MUST include section **§1.6** (or equivalent numbered section) documenting: four-layer model (procedure / payload / specs / workspace state), scenarios C1 (greenfield), C2 (SDD upgrade), C2b (CLI-only), C3 (spec propagation without SDD reinstall), and the profile model with **two active profiles** (APP, DOCS_SPECS) plus HYBRID as a deprecated alias of APP. The profile block MUST be written as canonical lay-language decision copy framed by the question "Will this repository hold application code?" and MUST state: (1) every profile installs the complete framework — profiles only adjust the AGENTS.md command table and a few stack-specific rule files; (2) the hub's `doc/` and `openspec/` content is ByeByeVibe's own development history — target projects never receive it, never need it, and grow their own `openspec/` state; (3) the profile question is independent of the language-axes question (`sdd-language-policy`). §1.6 MUST also include a canonical **install-scope table** distinguishing: machine scope (CLIs and MCP config, installed once per machine), repo-copied scope (payload applied by `install.sh` per project), and repo-generated scope (`openspec/`, `graphify-out/`, `.gitnexus/` — born inside each project, never shared between projects). §1.6 MUST document the **hub→destination flow** as the canonical multi-project UX: one hub clone per machine, and installation into any target project via `bash <hub>/scripts/bootstrap-sdd.sh <target-repo> --profile <PROFILE>`. §1.6 MUST state that per-project reinstallation covers only the repo-copied payload — machine-level CLIs are never reinstalled per project. Other surfaces (kit README, day-1 doc, banners) MUST NOT duplicate the scope table or the full profile copy; a short summary of at most three sentences plus a link to §1.6 is permitted.

#### Scenario: Human reads installation scenarios

- **WHEN** an operator opens the canonical guide before first install
- **THEN** §1.6 lists entry commands for each scenario and states that payloads come from `sdd-kit/`, not markdown extraction

#### Scenario: Agent reads installation scenarios

- **WHEN** an agent is prompted to install SDD in a foreign repository
- **THEN** the guide directs it to `sdd-kit/install.sh` with profile flag rather than extracting §12 code blocks for scripts

#### Scenario: Operator learns install scopes before second project

- **WHEN** an operator reads §1.6 asking whether a second project requires full reinstallation
- **THEN** the install-scope table shows machine-once vs repo-copied vs repo-generated scope, and the hub→destination command shows how to install into a new target folder with one command

#### Scenario: Scope table is single-sourced

- **WHEN** any other canonical surface (kit README, day-1 doc) mentions install scope
- **THEN** it links to guide §1.6 with at most a three-sentence summary, without duplicating the full table

#### Scenario: Lay operator answers the profile question

- **WHEN** a first-time operator with no SDD vocabulary reads the §1.6 profile block
- **THEN** the copy lets them choose by answering whether the repository will hold application code, and tells them the complete framework installs either way

#### Scenario: Hub content clarified at decision time

- **WHEN** an operator browsing the hub's specs wonders whether their project must receive them
- **THEN** the §1.6 profile copy states the hub's docs/specs are ByeByeVibe's own development history and are never copied to target projects

## REMOVED Requirements

### Requirement: bootstrap-sdd.sh emits warning in ambiguous HYBRID repo

**Reason:** HYBRID is retired as a deprecated alias of APP (kit 1.9.0). The coexistence of `package.json` and `openspec/` no longer signals a profile ambiguity — it is the normal post-install state of every APP repository — so the warning would only reintroduce the confusion this change removes.

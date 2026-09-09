## ADDED Requirements

### Requirement: Pull requests trigger review without per-PR operator action

After one-time repository enablement, every opened, reopened, synchronized, or newly ready non-draft pull request MUST trigger the automated review workflow without a comment, label, or slash command. Superseded runs for the same pull request SHOULD be cancelled. The report MUST identify the tested base and head revisions.

#### Scenario: Pull request is updated

- **WHEN** a new commit is pushed to an open non-draft pull request
- **THEN** a new review run starts for the new head SHA and any superseded run is cancelled.

### Requirement: Deterministic code checking runs independently of the model

The workflow MUST execute at least one real static or executable code check independently of generative judgment. In this shell-first hub, changed shell files MUST receive syntax checking and existing applicable repository gates MUST retain their fail-closed behavior. Commands MUST come from a trusted fixed allowlist, not pull-request text or head-modified configuration. A deterministic failure MUST block regardless of the LLM result.

#### Scenario: Changed shell file has invalid syntax

- **WHEN** a pull request changes a shell file containing a syntax error
- **THEN** the deterministic job fails and the pull request receives a blocking failed check even if model review is unavailable or reports no finding.

### Requirement: Existing review instructions are reused from the trusted base revision

The LLM stage MUST use the existing `correctness-review` and `simplify-review` skill bodies without copying or rewriting their review criteria into workflow prose. The existing `security-reviewer` instructions MUST be added only when a deterministic classifier marks the diff security-sensitive. All reviewer instruction files MUST be loaded from the pull request base revision, not trusted from the proposed head.

#### Scenario: Pull request modifies its reviewer skill

- **WHEN** a pull request changes `.claude/skills/correctness-review/SKILL.md`
- **THEN** that pull request is reviewed using the base-revision skill body and cannot weaken its own review policy.

#### Scenario: Security-sensitive path changes

- **WHEN** the deterministic classifier identifies an authentication, payment, API, secret-handling, workflow-permission, or sensitive-data change
- **THEN** the consolidated review includes the security-reviewer lens and its disposition.

### Requirement: Review output is consolidated and idempotent

The workflow MUST create or update one top-level pull-request summary identified by a stable marker. The summary MUST include deterministic status, correctness findings, simplification findings, conditional security findings, tested revisions, run evidence, and explicit skipped/degraded reasons. Reruns MUST update the existing summary instead of creating duplicate top-level summaries. Inline annotations MAY supplement but MUST NOT replace the summary.

#### Scenario: Pull request synchronizes twice

- **WHEN** the workflow completes for two successive head SHAs
- **THEN** the pull request contains one current automated-review summary showing the latest tested SHA and links to prior run evidence.

### Requirement: Credential and untrusted-content boundaries are fail-safe

The credentialed LLM stage MUST use the `pull_request` event and MUST NOT use `pull_request_target` to analyze untrusted head content. It MUST NOT execute pull-request head code with credentials, expose secret values, grant repository-content write, approve, merge, or push commits. Model tools MUST be restricted to review reads, safe diff inspection, and the minimum PR-report operation. Repository content MUST be treated as untrusted evidence rather than instructions.

#### Scenario: Pull request originates from a fork

- **WHEN** a fork pull request triggers the workflow
- **THEN** deterministic checks run, the credentialed LLM stage receives no secret and is skipped with an explicit neutral reason rather than failing open or exposing credentials.

#### Scenario: Changed source contains prompt injection

- **WHEN** a changed file instructs the reviewer to ignore policy or reveal secrets
- **THEN** the reviewer retains base policy, has no tool capable of revealing repository secrets, and reports the content only as review evidence if relevant.

### Requirement: Machine gates block and model judgment remains advisory

Deterministic failures MUST be blocking. LLM findings, provider availability, quota, timeout, and authentication readiness MUST be advisory in the initial release. An unavailable LLM stage MUST produce a visible skipped or degraded state and MUST NOT be represented as a passed review. Making model findings blocking requires a separately reviewed change supported by reliability and false-positive evidence.

#### Scenario: Provider times out

- **WHEN** deterministic checks pass but the model provider times out
- **THEN** the machine check remains green, the summary records a degraded LLM review, and no successful model-review claim is emitted.

### Requirement: Review execution is bounded and reversible

The workflow MUST set concurrency, timeout, and attempt limits sufficient to prevent unchanged retry loops and uncontrolled spend. Disabling the workflow or its authentication MUST leave `sdd-gates`, OpenSpec artifacts, manual review skills, and existing branch protection usable.

#### Scenario: New head supersedes an active review

- **WHEN** a pull request receives another commit while its prior model review is running
- **THEN** the prior run is cancelled or made non-authoritative and only the latest head summary is current.

## ADDED Requirements

### Requirement: Automated review action exception is isolated and immutable

A dedicated automated PR review workflow MAY use `anthropics/claude-code-action` only when the reference is pinned to a reviewed full commit SHA with a trailing human-readable release comment. This exception MUST NOT change the `sdd-gates` workflow's existing external-action allowlist, MUST NOT authorize mutable action tags, and MUST NOT authorize other third-party actions. The review workflow MUST preserve existing blocking SDD gate conclusions and MUST NOT convert model judgment into a substitute for them.

#### Scenario: Review workflow is inspected

- **WHEN** the automated review workflow is reviewed after implementation
- **THEN** the Anthropic action reference is immutable, no unrelated third-party action is introduced, and `sdd-gates` retains its existing authorized references and fail-closed checks.

### Requirement: Credentialed review permissions are narrower than code delivery permissions

The review workflow MUST declare explicit least-privilege permissions. Repository contents MUST remain read-only; only the reporting job MAY receive the minimum pull-request or issue-comment write permission required for the consolidated summary. The workflow MUST NOT grant actions that push code, approve reviews, merge pull requests, or modify repository configuration.

#### Scenario: Workflow permission block is inspected

- **WHEN** a maintainer reviews the workflow permissions
- **THEN** no contents-write, administration, deployment, package-write, approval, or merge capability is granted.

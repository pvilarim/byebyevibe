**Issue:** #349

## Why

ByeByeVibe has correctness, simplification, and security review instructions, but they are invoked manually and can be omitted before merge. The blocking repository-state gate delivered for #348 makes deterministic CI trustworthy, but it does not inspect behavioral mistakes, unnecessary complexity, or security-sensitive diffs through the existing review lenses. Issue #349 requires an automatic PR review path with both executable checks and one consolidated review surface.

## What Changes

- Add an automatic pull-request review workflow for non-draft PRs. It runs without a per-PR command after one-time repository configuration.
- Run a deterministic changed-file check on every eligible PR and keep deterministic failures blocking.
- Run advisory LLM review with the existing `correctness-review` and `simplify-review` skill bodies loaded from the trusted base revision. Add the existing `security-reviewer` lens only when a deterministic path classifier identifies a security-sensitive diff.
- Publish one idempotent PR summary containing each lens, deterministic-check status, findings, degraded/skipped reasons, and links to run evidence. Inline annotations may supplement the summary but do not replace it.
- Use a pinned Claude Code GitHub Action because this repository already treats Claude as the primary model host and the required review instructions are Claude-compatible repository artifacts. Restrict the action to read-only analysis plus PR-comment output.
- Protect credentials and untrusted contributions: use `pull_request`, never execute head code with secrets, load policy from the base revision, and skip the credentialed LLM stage for fork PRs while retaining deterministic checks.
- Document setup, cost/timeout limits, rollback, and the difference between blocking machine evidence and advisory model findings.

## Capabilities

### New Capabilities

- `sdd-automated-pr-review`: automatic, least-privilege PR review combining deterministic checks with trusted repository review lenses and a consolidated report.

### Modified Capabilities

- `sdd-ci-gates`: authorize one separately scoped, immutable Anthropic action reference for the review workflow while preserving the existing `sdd-gates` action allowlist and fail-closed checks.

## Impact

- Expected apply surfaces: a dedicated workflow under `.github/workflows/`, small deterministic classifier/check and report-support scripts, review documentation, and the existing review skill/agent references.
- One-time operator setup is required for the repository secret or supported Claude GitHub App authentication. After enablement, no per-PR invocation is required.
- Deterministic checks are blocking; LLM findings and provider availability are advisory. A model outage cannot turn a green machine gate red or silently report a completed review.
- No autonomous code edits, commits, approvals, merges, `pull_request_target`, arbitrary shell access, Astra orchestration, dashboard, or release cut.
- Core C1 installation and existing non-review workflows remain unchanged. Consumer packaging is not silently enabled; broader optional-module distribution requires explicit apply evidence and remains separable if it expands the reviewed scope.
- Proposal only. Implementation remains unchecked until a separately authorized apply phase.

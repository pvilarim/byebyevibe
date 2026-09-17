## Context

Issue #349 is the remaining review step in the release-readiness chain. Issue #348 is completed and the canonical `sdd-ci-gates` spec now requires blocking OpenSpec, task-pattern, release-readiness, and applicable OSV checks. The repository also has `.claude/skills/correctness-review/SKILL.md`, `.claude/skills/simplify-review/SKILL.md`, and `.claude/agents/security-reviewer.md`, mirrored where documented, but `AGENTS.md` classifies them as manual post-implementation review.

Current external product facts were checked on 2026-09-09:

- Anthropic documents an automatic Code Review service and a separate Claude Code GitHub Action that can run a supplied prompt on GitHub events. The managed Code Review service is a research preview with plan constraints, so it is not the portable implementation selected here: https://docs.anthropic.com/en/docs/claude-code/code-review and https://docs.anthropic.com/en/docs/claude-code/github-actions
- GitHub CodeQL supports JavaScript/TypeScript, Python, GitHub Actions, and other listed languages, but not shell. Shell is the hub's primary language, so CodeQL alone would not satisfy representative real-code coverage here: https://docs.github.com/code-security/code-scanning/introduction-to-code-scanning/about-code-scanning-with-codeql
- Repository rules remain authoritative: `openspec/specs/sdd-ci-gates/spec.md`, `openspec/specs/sdd-session-handoff/spec.md`, `openspec/specs/sdd-issue-traceability/spec.md`, `openspec/project.md`, and `AGENTS.md`.

The Graphify report is not tracked and was unavailable through the GitHub repository. GitNexus tools were not exposed in this connected session. No structural claim is inferred from missing graph results; current direct sources and the issue define this proposal. Apply must perform the required local graph impact checks before editing executable workflow or script surfaces.

## Goals / Non-Goals

**Goals:** automatic review after one-time enablement; real executable checking; unchanged reuse of the existing review lenses; one readable PR summary; least privilege; explicit degraded states; bounded cost and runtime.

**Non-Goals:** model-authored commits; automatic merge/approval; a generic multi-provider orchestration runtime; replacing `sdd-gates`; executing untrusted fork code with credentials; claiming model findings are deterministic proof; silently adding a paid workflow to every consumer.

## Decisions

1. **One review workflow with two trust-separated jobs.** A deterministic job runs first on every non-draft PR. A credentialed LLM job depends on its recorded result but cannot convert a deterministic failure into success. Concurrency cancels superseded runs for the same PR, and both jobs have explicit timeouts.
2. **Repository checks are the real pass.** The deterministic job validates changed shell files with `bash -n`, validates workflow YAML through an approved deterministic method available in apply, and runs existing applicable repository gates without hiding failures. It emits a compact result artifact/summary. CodeQL is not the primary pass because it does not cover shell; a later APP consumer may add CodeQL for a supported language through its own reviewed configuration.
3. **Reuse trusted lenses, do not rewrite them.** The LLM prompt resolves the PR base SHA and reads the exact base-revision contents of `correctness-review` and `simplify-review`. A deterministic classifier adds the base-revision `security-reviewer` instructions only for security-sensitive paths or patterns. Workflow prose contains orchestration instructions and output schema only; it must not copy the review criteria.
4. **Claude Code Action is the bounded host adapter.** Apply pins `anthropics/claude-code-action` to a reviewed full commit SHA and records its human-readable release. Allowed tools are limited to read/search and safe diff inspection plus the minimum GitHub operation needed to create or update the summary. No repository-content write, commit, approval, or merge permission is granted.
5. **Use `pull_request`, never `pull_request_target`.** The workflow analyzes the PR with read-only repository permissions. The credentialed job runs only for same-repository branches after authentication readiness is confirmed. Fork PRs run deterministic checks and publish an explicit `LLM review: skipped — untrusted fork/credential unavailable` status; they never receive secrets. Policy files are read from the base revision so a PR cannot weaken its own reviewer.
6. **One idempotent summary is the review surface.** A stable marker identifies the bot summary. Each rerun updates that summary rather than adding another top-level comment. Sections cover deterministic checks, correctness, simplification, conditional security, limitations/skips, tested base/head SHAs, and run URL. Inline findings are optional and must be linked from the same summary.
7. **Blocking policy separates facts from judgment.** Deterministic failures block. LLM findings are advisory in v1 and use severity plus evidence references; provider timeout, quota, or missing authentication produces a visible neutral/degraded conclusion, never a false pass. Moving model findings to blocking requires later measured false-positive/availability evidence and a new proposal.
8. **Bound cost and prompt-injection exposure.** Set maximum runtime/turns, one LLM review attempt per head SHA, no unchanged retry loop, and no raw secret access. Treat repository content as untrusted evidence, not instructions. The reviewer may quote only compact relevant excerpts and must cite paths/lines or state uncertainty.
9. **Hub-first activation, explicit consumer choice.** This change proves the workflow in the hub. Documentation may provide a reviewed template or manual copy path, but core C1/C2 must not silently enable a credentialed paid service. If apply determines that optional kit distribution materially expands installer/MANIFEST behavior, it records that as a follow-up rather than broadening this proposal.
10. **Rollback is additive and reversible.** Disable or remove the dedicated workflow and repository authentication; existing `sdd-gates`, manual skills, OpenSpec artifacts, and branch protection continue to work unchanged. Historical PR comments remain evidence and are not erased.

Alternatives rejected: managed Claude Code Review as the only mechanism because plan availability and exact skill reuse are not portable; CodeQL alone because it does not representatively cover this shell-first hub; `pull_request_target` because credential access plus untrusted PR content creates an avoidable trust-boundary risk; three independent model comments because they violate the single-surface acceptance criterion; blocking on model judgment before reliability evidence exists.

## Risks / Trade-offs

- Same-repository malicious content can still attempt prompt injection. Base-revision policy, restricted tools, read-only repository permissions, no head-code execution in the credentialed job, and advisory findings limit impact.
- Fork PRs do not receive LLM review. The explicit skip is preferable to exposing credentials; deterministic review still runs and a maintainer may reproduce the LLM review after moving trusted code to an internal branch.
- A provider/API dependency adds cost and availability risk. Timeout, concurrency, one-attempt-per-SHA, and visible degraded status bound the risk.
- A generic deterministic runner can become an accidental command-execution surface. Apply must use a fixed allowlist; it must not execute commands sourced from PR text or modified head configuration with credentials.
- Sticky-comment updates require write permission to PR discussions. Scope that permission to the reporting job and do not grant contents write.

## Migration Plan

Apply on a dedicated branch, first implementing and testing deterministic logic with fixture diffs and no provider credential. Pin and review the action source, then configure authentication as a manual repository step and test against a controlled same-repository PR. Exercise a fork-equivalent case without secrets, a sensitive-path case, a rerun on a new head SHA, provider failure, and deterministic failure. Keep model output advisory. Rollback disables the workflow and removes authentication without touching `sdd-gates` or review skill files.

## Semantic Review Plan

Before completion, record a scenario matrix covering: ordinary same-repo PR; docs-only PR; shell syntax error; workflow syntax error; security-sensitive path; fork PR; missing/invalid secret; provider timeout; prompt-injection text in a changed file; base policy changed by the PR; rerun after synchronize; duplicate-comment prevention; deterministic failure plus successful LLM review. Each row must include expected trigger, permissions, executed commands, report state, blocking effect, and observed result.

## Open Questions

No blocking product decision remains for propose. Apply must select and record the immutable action SHA and exact supported authentication mode from then-current official documentation. Optional consumer packaging is included only if it does not silently alter core install behavior; otherwise it becomes a separate change.

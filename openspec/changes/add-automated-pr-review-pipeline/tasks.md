## 1. Deterministic review foundation

- [ ] 1.1 Add a trusted changed-file classifier and deterministic PR check runner for shell syntax, workflow structure, security-sensitive scope, and applicable existing repository gates.
  - **Pattern:** `scripts/verify-release-readiness.sh`, `.github/workflows/sdd-gates.yml`
  - **Gate:** `bash -n scripts/pr-review-check.sh && bash scripts/pr-review-check.sh --self-test`
  - **Evidence:** Record fixture results for ordinary docs, invalid shell, workflow change, security-sensitive change, and malicious command text; demonstrate that only fixed trusted commands execute.
  - **Invariants:** No model call, secret read, head-supplied command, or change to existing sdd-gates conclusions.

## 2. Automatic review workflow

- [ ] 2.1 Add the dedicated `pull_request` workflow with concurrency/timeout bounds, deterministic and credentialed trust-separated jobs, same-repository eligibility, immutable action pin, and least-privilege permissions.
  - **Pattern:** `.github/workflows/sdd-gates.yml`
  - **Gate:** `grep -q 'pull_request:' .github/workflows/automated-pr-review.yml && ! grep -q 'pull_request_target' .github/workflows/automated-pr-review.yml && grep -Eq 'anthropics/claude-code-action@[0-9a-f]{40}' .github/workflows/automated-pr-review.yml`
  - **Evidence:** Review the pinned action revision and workflow permissions; exercise same-repo and fork-equivalent event fixtures, confirming no credentialed head-code execution and explicit fork skip.
  - **Forbidden:** Mutable action tags; contents write; automatic approval/merge/commit; unrestricted Bash; secrets on fork PRs.

- [ ] 2.2 Load `correctness-review` and `simplify-review` unchanged from the base revision, conditionally load `security-reviewer`, and produce a schema-bounded review result.
  - **Pattern:** `.claude/skills/correctness-review/SKILL.md`, `.claude/skills/simplify-review/SKILL.md`, `.claude/agents/security-reviewer.md`
  - **Gate:** `grep -q 'correctness-review/SKILL.md' .github/workflows/automated-pr-review.yml && grep -q 'simplify-review/SKILL.md' .github/workflows/automated-pr-review.yml && grep -q 'security-reviewer.md' .github/workflows/automated-pr-review.yml`
  - **Evidence:** In a fixture PR that modifies a review skill, capture proof that the effective instruction hash matches the base revision; record conditional security-lens inclusion.
  - **Invariants:** Review criteria remain in their existing files; workflow orchestration MUST NOT duplicate them.

- [ ] 2.3 Implement one idempotent consolidated PR summary with deterministic, correctness, simplification, conditional security, tested revision, run link, and degraded/skipped sections.
  - **Pattern:** `.github/workflows/sdd-gates.yml`
  - **Gate:** `bash -n scripts/pr-review-report.sh && bash scripts/pr-review-report.sh --self-test`
  - **Evidence:** Run create, synchronize/update, provider-timeout, and deterministic-failure fixtures; demonstrate one stable summary marker and no false model pass.

## 3. Operator guidance and scope

- [ ] 3.1 Document one-time authentication/setup, automatic trigger behavior, advisory versus blocking meaning, cost controls, fork behavior, troubleshooting, and rollback.
  - **Pattern:** `doc/byebyevibe-guide.md`, `openspec/infra.md`
  - **Gate:** `grep -qi 'automated PR review' doc/byebyevibe-guide.md && grep -qi 'automated PR review' openspec/infra.md`
  - **Evidence:** Walk the setup from a clean repository using secret names only; verify that disabling authentication leaves sdd-gates and manual review usable.
  - **Forbidden:** Secret values; claim that all plans/providers are available; silent core-install activation.

- [ ] 3.2 Decide consumer distribution from apply evidence: either add an explicitly selected optional template/module with checksum/version updates, or record a separate follow-up without changing core C1/C2.
  - **Pattern:** `sdd-kit/README.md`, `sdd-kit/MANIFEST.yaml`
  - **Gate:** `bash scripts/verify-release-readiness.sh`
  - **Evidence:** Record the selected boundary and prove core install does not silently enable a credentialed paid workflow. If any `sdd-kit/templates/` file changes, regenerate MANIFEST checksums.
  - **Invariants:** No surprise writes or provider requirement for standard users.

## 4. Validation and controlled pilot

- [ ] 4.1 Complete the semantic review matrix from `design.md`, run strict OpenSpec/task/release-readiness checks, and execute one controlled same-repository pilot PR before declaring the issue resolved.
  - **Gate:** `npx --yes @fission-ai/openspec@1.3.1 validate add-automated-pr-review-pipeline --strict --no-interactive && npx --yes @fission-ai/openspec@1.3.1 validate --all --strict --no-interactive && bash scripts/verify-task-patterns.sh && bash scripts/verify-release-readiness.sh && git diff --check`
  - **Evidence:** Create `openspec/changes/add-automated-pr-review-pipeline/semantic-review.md` with every planned scenario, actual run URLs, permissions, base/head SHAs, findings, skips, blocking effect, and reviewer disposition. Missing required evidence keeps this task unchecked.

All tasks are future apply work. Before executable edits, consult fresh Graphify and GitNexus impact data as required for type D work, register/check the local apply session, and release it on completion or pause. No archive, release, or issue closure is authorized by this checklist.

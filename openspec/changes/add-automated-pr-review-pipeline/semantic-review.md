# Semantic review matrix — add-automated-pr-review-pipeline

Fixture evidence was produced on 2026-09-17 in this apply session with:

```bash
bash -n scripts/pr-review-check.sh && bash scripts/pr-review-check.sh --self-test
bash -n scripts/pr-review-report.sh && bash scripts/pr-review-report.sh --self-test
```

Live GitHub Actions URLs for a non-draft same-repository PR are **pending**: this apply opens a **draft** PR, and the workflow skips drafts by design. Archive / a follow-up apply must attach run URLs after `ready_for_review`.

Pinned action: `anthropics/claude-code-action@3b8197d3d486006dd4af54613517f21ac6ac625e` (v1.0.227).
Authentication mode selected: repository secret `ANTHROPIC_API_KEY` **or** `CLAUDE_CODE_OAUTH_TOKEN` (names only). Bedrock/Vertex/Foundry are not enabled.

| Scenario | Expected trigger | Permissions | Executed commands | Report state | Blocking | Observed |
|----------|------------------|-------------|-------------------|--------------|----------|----------|
| Ordinary same-repo PR (docs + scripts, valid) | `pull_request` non-draft | contents:read; report job pull-requests:write | `bash -n` on changed `.sh`; classifier | Deterministic PASS; LLM advisory or skip | No | Fixture `ordinary-docs`: PASS, sensitive=false. Live run URL: pending draft PR. |
| Docs-only PR | same | same | classify only | PASS, security lens omitted | No | Fixture `ordinary-docs`. |
| Shell syntax error | same | same | `bash -n` fails | Deterministic FAIL | **Yes** | Fixture `invalid-shell`: status=fail exit=1. |
| Workflow syntax error | same | same | workflow YAML structure check | Deterministic FAIL | **Yes** | Fixture `workflow-syntax-error`: FAIL. |
| Security-sensitive path | same | same | classify; LLM should include security-reviewer when live | `security_sensitive=true` | No (unless syntax fail) | Fixture `security-sensitive-path` (auth-token.sh) and `workflow-change`. |
| Fork PR | `pull_request` from fork | no secrets on credentialed job | deterministic only | `LLM review: skipped — untrusted fork/credential unavailable` | Only if deterministic fails | Workflow `if:` requires `head.repo.full_name == github.repository`. Report `--event fork-skip`. Live fork URL: not executed (no fork in this session). |
| Missing/invalid secret | same-repo, empty secret | credentialed job skipped | deterministic + report | skipped authentication reason | No | Job `if:` checks `secrets.ANTHROPIC_API_KEY` / `CLAUDE_CODE_OAUTH_TOKEN`. |
| Provider timeout | LLM job timeout 15m / continue-on-error | same | deterministic green | degraded LLM, never a model pass | No | Fixture `--event timeout`: degraded; "successful model-review claim" sentence present; machine independent. |
| Prompt-injection text in a changed file | same | same | `bash -n` only; content classifier | sensitive=true; commands from the file are **not** executed | No | Fixture `malicious-command-text`: PASS, sentinel file absent. |
| Base policy changed by the PR | same | same | `git show $BASE_SHA:...` into `--policy-dir` | summary hashes match **base** bodies | No | Fixture `policy-hash-from-trusted-dir` matched the trusted copy while a weakened sibling existed. |
| Rerun after synchronize | `synchronize` | same | new run; concurrency cancels prior | one sticky marker; latest head SHA | per deterministic | Fixture create vs synchronize: single `<!-- sdd-automated-pr-review -->`; run URL updates. |
| Duplicate-comment prevention | report `--post` | pull-requests:write | `gh api` PATCH existing marker | one top-level summary | n/a | Script finds comment id by marker then PATCH; create vs sync fixtures share one marker. Live PATCH: pending. |
| Deterministic failure plus successful LLM review | same | same | `bash -n` fail; LLM CORRECT ignored for merge | `FAIL (blocking)` + advisory LLM | **Yes** | Fixture `deterministic-failure` with LLM `CORRECT`: summary still `FAIL (blocking)`. Workflow last step exits 1 when `needs.deterministic.result == failure`. |

## Local self-test log (abridged)

```
PASS ordinary-docs status= pass sensitive= False exit= 0
PASS invalid-shell status= fail sensitive= False exit= 1
PASS workflow-change status= pass sensitive= True exit= 0
PASS security-sensitive-path status= pass sensitive= True exit= 0
PASS malicious-command-text status= pass sensitive= True exit= 0
PASS malicious-command-text did not execute (no sentinel)
PASS policy-hash-from-trusted-dir
PASS workflow-syntax-error
pr-review-check.sh --self-test PASSED
PASS create/sync/timeout/detfail single marker
PASS timeout is degraded, not a model pass
PASS deterministic failure remains blocking despite LLM CORRECT
pr-review-report.sh --self-test PASSED
```

## Live pilot (required before checking task 4.1)

| Field | Value |
|-------|--------|
| Apply PR | draft — URL filled after open |
| Workflow run | skipped while draft; fill after `ready_for_review` |
| Base SHA | fill from PR |
| Head SHA | fill from PR |
| Permissions observed | fill from run |
| Reviewer disposition | pending |

Task 4.1 stays unchecked until the live rows above are populated.

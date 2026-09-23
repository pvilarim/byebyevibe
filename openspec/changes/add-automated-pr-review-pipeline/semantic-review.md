# Semantic review matrix — add-automated-pr-review-pipeline

Fixture evidence was produced on 2026-09-17 in this apply session with:

```bash
bash -n scripts/pr-review-check.sh && bash scripts/pr-review-check.sh --self-test
bash -n scripts/pr-review-report.sh && bash scripts/pr-review-report.sh --self-test
```

Live GitHub Actions URLs require a non-draft `pull_request` run of a **valid** workflow file. Canonical guide §2.19 insertion is an archive follow-up; the hub operator page is `doc/automated-pr-review.md`.

Pinned action: `anthropics/claude-code-action@3b8197d3d486006dd4af54613517f21ac6ac625e` (v1.0.227).
Authentication mode selected: repository secret `ANTHROPIC_API_KEY` **or** `CLAUDE_CODE_OAUTH_TOKEN` (names only). Bedrock/Vertex/Foundry are not enabled.

| Scenario | Expected trigger | Permissions | Executed commands | Report state | Blocking | Observed |
|----------|------------------|-------------|-------------------|--------------|----------|----------|
| Ordinary same-repo PR (docs + scripts, valid) | `pull_request` non-draft | contents:read; report job pull-requests:write | `bash -n` on changed `.sh`; classifier | Deterministic PASS; LLM advisory or skip | No | Fixture `ordinary-docs`: PASS. Live: https://github.com/pvilarim/byebyevibe/actions/runs/35887102940 (`event=pull_request`, conclusion=success). |
| Docs-only PR | same | same | classify only | PASS, security lens omitted | No | Fixture `ordinary-docs`. |
| Shell syntax error | same | same | `bash -n` fails | Deterministic FAIL | **Yes** | Fixture `invalid-shell`: status=fail exit=1. |
| Workflow syntax error | same | same | workflow YAML structure check | Deterministic FAIL | **Yes** | Fixture `workflow-syntax-error`: FAIL. |
| Security-sensitive path | same | same | classify; LLM should include security-reviewer when live | `security_sensitive=true` | No (unless syntax fail) | Fixture `security-sensitive-path` (auth-token.sh) and `workflow-change`. |
| Fork PR | `pull_request` from fork | no secrets on credentialed job | deterministic only | `LLM review: skipped — untrusted fork/credential unavailable` | Only if deterministic fails | Workflow `if:` requires `head.repo.full_name == github.repository`. Report `--event fork-skip`. Live fork URL: not executed (no fork in this session). |
| Missing/invalid secret | same-repo, empty secret | credentialed job runs; action skipped | deterministic + report | skipped authentication reason | No | Step `Confirm authentication is configured` reads secret env (not job `if`); `llm_state=skipped-auth`. Live: Claude action skipped on https://github.com/pvilarim/byebyevibe/actions/runs/35887102940. |
| Provider timeout | LLM job timeout 15m / continue-on-error | same | deterministic green | degraded LLM, never a model pass | No | Fixture `--event timeout`: degraded; "successful model-review claim" sentence present; machine independent. |
| Prompt-injection text in a changed file | same | same | `bash -n` only; content classifier | sensitive=true; commands from the file are **not** executed | No | Fixture `malicious-command-text`: PASS, sentinel file absent. |
| Base policy changed by the PR | same | same | `git show $BASE_SHA:...` into `--policy-dir` | summary hashes match **base** bodies | No | Fixture `policy-hash-from-trusted-dir` matched the trusted copy while a weakened sibling existed. |
| Rerun after synchronize | `synchronize` | same | new run; concurrency cancels prior | one sticky marker; latest head SHA | per deterministic | Fixture create vs synchronize: single `<!-- sdd-automated-pr-review -->`; run URL updates. |
| Duplicate-comment prevention | report `--post` | pull-requests:write | `gh api` PATCH existing marker | one top-level summary | n/a | Script finds comment id by marker then PATCH; create vs sync fixtures share one marker. Live CREATE: https://github.com/pvilarim/byebyevibe/pull/393#issuecomment-5798370959. |
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

PR https://github.com/pvilarim/byebyevibe/pull/393 was marked **ready for review** on 2026-09-23 (`draft=false`). The first `ready_for_review` did **not** start `Automated PR review` because the workflow file was invalid.

Diagnosis of the invalid file (not a successful pilot):

| Observation | Value |
|-------------|--------|
| Named workflow query (before fix) | `workflow:"Automated PR review"` → 0 `pull_request` runs |
| File-path runs | Instant `event=push` failures, 0 jobs, `name` = file path (not the workflow `name:`) |
| Example invalid run | https://github.com/pvilarim/byebyevibe/actions/runs/35237374819 (head `26b1f48`) |
| Cause | Job-level `if` used `secrets.*`. actionlint: `context "secrets" is not allowed here`. |
| Fix | Authentication readiness moved to a step. Job `if` keeps draft + same-repo only. Restored full workflow in `37574939`. |

### Captured same-repository pilot

| Field | Value |
|-------|--------|
| Apply PR | **ready** https://github.com/pvilarim/byebyevibe/pull/393 |
| Workflow run | https://github.com/pvilarim/byebyevibe/actions/runs/35887102940 (`event=pull_request`, `name=Automated PR review`, run 16, conclusion=`success`) |
| Jobs | Deterministic checks [success](https://github.com/pvilarim/byebyevibe/actions/runs/35887102940/job/107269935875); Credentialed LLM review [success](https://github.com/pvilarim/byebyevibe/actions/runs/35887102940/job/107269997662) (Claude action **skipped**); Consolidated summary [success](https://github.com/pvilarim/byebyevibe/actions/runs/35887102940/job/107270051766) |
| Permissions (declared; jobs completed under them) | workflow `contents: read`; deterministic/llm `contents: read` + `pull-requests: read`; report `contents: read` + `pull-requests: write`. No contents write / approval / merge. |
| Base SHA | `4620d66c27190b9f50f1e158b79a6c30f5e80c80` (master) |
| Head SHA | `37574939dc2137a1b58bb724f918cb20ac74b64f` |
| Sticky summary | https://github.com/pvilarim/byebyevibe/pull/393#issuecomment-5798370959 (`<!-- sdd-automated-pr-review -->`) |
| Deterministic | `PASS` (`bash -n` on both scripts; workflow YAML structure ok). Not blocking. |
| LLM | skipped — authentication not configured (`Confirm authentication is configured` ran; Claude action skipped). Correctness/simplification `SKIPPED`. No false model pass. |
| Security lens | omitted on this run (sticky: "diff not classified security-sensitive") |
| Reviewer disposition | Machine gate green; advisory LLM unavailable until `ANTHROPIC_API_KEY` or `CLAUDE_CODE_OAUTH_TOKEN` is set. Safe for Pedro to merge the apply PR. A later evidence commit may retrigger `synchronize` and update the sticky SHA. |

A subsequent evidence-only commit will produce a newer run; **do not treat that as a requirement to re-open 4.1**. The pilot above is the first valid `pull_request` graph.

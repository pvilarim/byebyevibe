# Automated PR review — operation

Hub operator page for change `add-automated-pr-review-pipeline` until archive
copies this procedure into `doc/byebyevibe-guide.md` §2.19.

Hub-first automatic review for non-draft pull requests (change `add-automated-pr-review-pipeline`, issue #349). Complements `sdd-gates` (§2.12): this workflow does **not** replace OpenSpec, task-pattern, release-readiness, or OSV conclusions. Core C1/C2 install does **not** enable it.

**When it runs:** `pull_request` events `opened`, `reopened`, `synchronize`, and `ready_for_review` on non-draft PRs. No comment, label, or slash command is required after one-time repository setup. Superseded runs for the same PR are cancelled (`concurrency`). Draft PRs are skipped until they become ready.

**Jobs:**

| Job | Trust | Policy |
|-----|--------|--------|
| Deterministic checks | No secrets; `contents: read` | **Blocking** — `bash -n` on changed shell files, workflow YAML structure, security-sensitive path/content classifier |
| Credentialed LLM review | Same-repository only; `ANTHROPIC_API_KEY` or `CLAUDE_CODE_OAUTH_TOKEN` | **Advisory** — loads `correctness-review` and `simplify-review` from the PR **base** revision; adds `security-reviewer` only when the classifier marks the diff sensitive |
| Consolidated summary | `pull-requests: write` (no contents write) | One sticky comment (`<!-- sdd-automated-pr-review -->`); reruns update it |

`[MANUAL ACTION REQUIRED]` **One-time authentication** — store **one** of these repository secret **names** (never commit values):

1. `ANTHROPIC_API_KEY` — Claude API key from the Claude Console, **or**
2. `CLAUDE_CODE_OAUTH_TOKEN` — subscription token from local `claude setup-token` (Pro/Max/Team/Enterprise).

This hub pins `anthropics/claude-code-action@3b8197d3d486006dd4af54613517f21ac6ac625e` (v1.0.227) and passes `github_token: ${{ secrets.GITHUB_TOKEN }}` so the action uses the workflow's least-privilege token rather than a contents-write GitHub App. Amazon Bedrock, Google Vertex, and Microsoft Foundry are **not** configured here; do not assume those providers are available.

After the secret exists, every eligible same-repository PR is reviewed automatically. If authentication is missing, deterministic checks still run and the summary records `LLM review: skipped — authentication not configured`. `sdd-gates` and manual `correctness-review` / `simplify-review` skills remain usable.

**Blocking versus advisory:**

| Signal | Merge check |
|--------|-------------|
| Shell syntax error, invalid workflow YAML | **Blocks** (deterministic job red) |
| LLM findings, quota, timeout, missing secret | **Advisory** — machine check stays green; summary is skipped/degraded, never a false model pass |
| Fork PR | Deterministic checks run; credentialed stage is skipped (`LLM review: skipped — untrusted fork/credential unavailable`); secrets are not passed |

**Cost controls:** job timeouts (10 / 15 / 5 minutes), `--max-turns 8`, one concurrency slot per PR (in-progress runs cancelled), no retry loop on an unchanged head SHA, no raw secret access in scripts.

**Fork behavior:** the workflow uses `pull_request` (not a privileged fork checkout). Fork PRs never receive the credentialed job. A maintainer who wants LLM review can copy trusted commits onto a same-repository branch.

**Local verification (no provider credential):**

```bash
bash -n scripts/pr-review-check.sh && bash scripts/pr-review-check.sh --self-test
bash -n scripts/pr-review-report.sh && bash scripts/pr-review-report.sh --self-test
```

**Troubleshooting:**

| Symptom | Likely cause | Action |
|---------|--------------|--------|
| No review comment | Draft PR, or workflow file not on the default branch yet | Mark ready for review; merge the workflow, then open a follow-up PR |
| `LLM review: skipped — authentication not configured` | Secret name missing | Add `ANTHROPIC_API_KEY` or `CLAUDE_CODE_OAUTH_TOKEN` (names only in docs) |
| `LLM review: skipped — untrusted fork/credential unavailable` | Fork PR | Expected; run deterministic only or recreate on a same-repo branch |
| Degraded LLM / timeout | Provider quota, `--max-turns`, or job timeout | Re-run on a new head SHA; machine gates are independent |
| Deterministic red, LLM green | Shell/workflow syntax | Fix the file; LLM cannot convert a machine failure into success |
| Duplicate top-level review comments | Marker missing from an old comment | Leave historical comments; new runs update the marked summary only |

**Rollback:** disable or delete `.github/workflows/automated-pr-review.yml` and remove the repository secret. `sdd-gates`, OpenSpec artifacts, manual review skills, and branch protection continue to work. Historical PR comments are left in place as evidence.

**Consumer repos:** not enabled by `sdd-kit/install.sh` / `upgrade.sh`. See `openspec/changes/add-automated-pr-review-pipeline/consumer-distribution.md`.

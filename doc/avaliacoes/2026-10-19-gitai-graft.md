# Evaluation: gitai (Graft) — server-centric Git for concurrent coding agents

| Field | Value |
|-------|--------|
| **Date** | 2026-10-19 |
| **Evaluator** | Explore session (Cloud Agent). Type E. No install, no pilot. |
| **Candidate** | [feder-cr/git-ai](https://github.com/feder-cr/git-ai) v0.2.0 (tag `v0.2.0`, published 2026-10-18). Product name **gitai**. In-tree name **Graft**. CLI `graft`. Server binary still `gitaly`. |
| **Decision** | **Discarded** as `sdd-kit` payload and as a replacement for GitHub + worktrees + pull requests. **Deferred** as an optional landing server for a future headless agent farm, and only behind the existing review gate. |
| **Scope** | Version-control write path. Not a graph, skill, or harness. Distinct from [NanoNets Graft](./2026-08-17-nanonets-graft.md). |

## Executive summary

gitai is a real, documented fork of GitLab's Gitaly (MIT, `ee/` omitted) that adds a gRPC write path for many short-lived agents landing on the same branch: sparse materialization, compare-and-swap `UserLand`, a 10 ms batch window, a per-repository changeset log, and optional out-of-process conflict resolution. The server does not call a language model. The operator's briefing matches v0.2.0 on the architecture and the CLI flow. It overstates three things: that this is a Scion port, that the benchmark's "27 attempts" means each successful land retried 27 times, and that approval rules actually block a land.

It does not fit the SDD control plane. ByeByeVibe coordinates agents by **separate git worktrees and branches**, a **human gate** (R7) on a **GitHub pull request**, and **fail-closed CI** (`sdd-gates`). gitai's product is the opposite write path: many agents fast-forward **one** branch, with review that is still advisory and with no pull request and no CI. Wiring it under the current tools creates two sources of truth, blinds GitNexus and `sdd-metrics` inside a sparse workspace, and can land or auto-revert code that no pull request reviewed.

Do not install it into the kit. Reopen only for a pilot that still opens a GitHub pull request before anything reaches `main`.

## Problem it tried to solve

Classic Git assumes a human who clones, works for a long time, and pushes once. Coding agents do the reverse: many short tasks, few files each, all wanting the same branch within seconds. Full clones, client-side history walks, and a merge queue become the bottleneck.

The SDD stack does not have that bottleneck on this hub. The hub is DOCS_SPECS. Parallel apply is defined as **two worktrees, two branches**, with an exclusive `flock` on `.sdd/runtime/apply.lock` per worktree (guide §3.3, R11). The danger the guide names is two agents editing the **same working tree**, not two agents racing to fast-forward `main`. Cloud agents already isolate writes as `cursor/<name>` branches plus a pull request. gitai solves a workload this repository has chosen not to run.

## What was analyzed

- Operator briefing in the explore request (checked against tag `v0.2.0`, not against `main` after the tag).
- README, `LICENSE`, GitHub repository metadata (API, 2026-10-19), release notes for `v0.2.0`.
- `doc/graft/LIMITATIONS.md`, `STORAGE.md`, `AGENT-SECURITY.md`, `QUICKSTART.md`, `RESOLVE.md`, `REVIEW.md`, `VERIFY.md`, `SUPERFAN.md`, `BENCH.md`.
- CLI: `cmd/graft/commands.go`. Changeset path and lock: `internal/graft/changelog/log.go`. Object-id check: `internal/graft/cachetier/object.go`.
- SDD side: `AGENTS.md` (R7, R10, R11), `openspec/infra.md`, `openspec/project.md` non-goals, guide §3.3, `scripts/sdd-session-*.sh`, `scripts/sdd-metrics.sh`, `openspec/changes/explore-oss-coverage-gaps/metodologia-insercao.md`, and the NanoNets Graft evaluation (name collision).
- `graphify-out/GRAPH_REPORT.md` is not in this checkout. Architecture claims below are anchored to the guide and the scripts, not to the graph.

Not done: no `make build`, no `examples/graft/quickstart.sh`, no measurement of land latency on this repo. Build requirements are Go 1.26, a C toolchain, Meson, and Ninja, because the build compiles a bundled Git.

## Fact check of the briefing

Verdicts are against tag `v0.2.0`.

| Claim | Verdict |
|-------|---------|
| Product **gitai**, in-tree name **Graft**, repo `git-ai`, version **0.2.0** | **Confirmed.** Release `gitai 0.2.0` on 2026-10-18. Server process is still `gitaly serve`. |
| Inspired by Anthropic's Scion article; Scion is not public; not affiliated | **Confirmed.** README links the engineering post and states the non-affiliation. |
| "Reimplements Scion" on normal Git, from a Gitaly fork | **Nuance.** `LIMITATIONS.md` says "Not a Scion implementation." It adopts the published ideas. It is a Gitaly fork; the non-MIT `ee/` tree is not in the repo. Local Git remains underneath. |
| Server never calls an LLM; resolution is a separate program | **Confirmed.** `RESOLVE.md`: the server speaks JSON protocol v1 to a command or an HTTP URL. `graft-resolve` may then call a model. |
| Agents want the same branch in seconds; clone and client history are the bottleneck | **Confirmed as their problem statement.** It is not the SDD hub's operating model (see below). |
| `graft clone` is sparse; `status` and `diff`; `commit -m … --land main`; temp ref `graft/<user>/<random>`; rebase by default; fast-forward if already descendant; "already landed" if the tip contains the commit; else rebase or merge; CAS retry; temp ref deleted; each of `commit_files`, `land`, `delete_refs` is a changeset line with the agent name | **Confirmed.** `QUICKSTART.md` and `commands.go`. `GRAFT_USER` is used in the branch name when it is a valid ref component; the policy decision uses the **token**, and the server overwrites `gl_id` / `gl_username` with the agent name. Committer **name and email stay whatever the client sent**. |
| Standalone mode batches concurrent lands; default window 10 ms | **Confirmed.** A land that arrives alone still waits up to that window. Batching is per process and in memory. Lanes on two nodes do not coordinate. The combined update is attributed to the synthetic actor `graft-batch`; real actors sit in members, truncated past 32 KiB. |
| Benchmark: 50 agents, 250 changes, ~27 attempts per land down to 1, more lands per minute | **Confirmed as the published ratio, misleading as a reading of "each land".** See the benchmark section. |
| Conflicts are resolved only with `--resolve` and a resolver configured for that actor and those paths. Strategies `trivial`, `union`, `rerere`, or an external process. Trailer `Graft-Resolved-By` | **Confirmed.** Also `command` and optional `llm` inside `graft-resolve`. Non-UTF-8 paths are never sent. Default limits: 20 files, 1 MiB each. A resolved land is a **merge commit** with parents `[tip, commit]`, not a rebase of the same shape. |
| Pieces: agents → `graft-cache` → `gitaly` → local Git, optional SQLite/Postgres + pack bucket | **Confirmed for the three modes.** The README architecture picture draws the database as the write path. That picture is **authoritative** mode. Default `[graft.storage] mode = "off"`: a normal bare repo, no database. The briefing's three-mode account is the accurate one. |
| `ObjectService`, `UserLand`, `ChangesetService`, `DerivedDataService`, Review | **Confirmed**, plus `SearchService` (`graft search`). Review code lives in `ReviewService`. **Landing does not consult `approved`.** Phase 5a is advisory; the land gate is phase 5b and is not in 0.2.0. |
| `graft-cache` recomputes the object id from type, size, and content before serving | **Confirmed** in `cachetier/object.go` (`verifyObject`, header `<type> <size>\0`, SHA-1 or SHA-256 by id length). |
| `graft-verify` tests the tip, bisects first-parent, reverts the culprit, with an hourly cap | **Confirmed, off by default.** `revert.enabled` defaults false. `max_per_hour` defaults **0**, which allows **no** reverts until set. It uses the shared operator token. A flaky test can still revert the wrong commit if the second run also flakes. Tests are not sandboxed. |
| `graft-superfan` follows the changeset stream, glob rules, Slack; it does not read server telemetry | **Confirmed** as documented input: `graft watch --json` / `graft log --json` only. |
| Default log is `<git dir>/graft/changesets.jsonl`, `flock` + `fsync`; per node; behind Praefect only the primary serves list/watch | **Confirmed** (`changelog.Path`, `dirName = "graft"`). Sequence is dense **only while recording succeeds**. A recording error is logged and **does not fail the Git write**, so the log can gap. Direct writes that skip Gitaly's transaction path are not recorded. |
| `shadow`: Git stays source of truth; DB mirror; pack upload; Git write proceeds if the DB fails | **Confirmed.** A CAS mismatch in shadow mode is stored as a forced changeset and counted as divergence. |
| `authoritative`: DB CAS is the commit point; packs uploaded first, key is SHA-256; nodes are caches; empty disk rehydrates from changeset 1; requires `standalone = true` and reftable; no Praefect; no orphan-pack GC and no checkpoint compaction | **Confirmed.** S3, GCS, and Azure URLs are accepted; the suite and the bench use `file://` and `mem://` unless `GRAFT_TEST_S3_URL` is set. Concurrent writes to one repo share one reftable lock and queue; a wait past 10 s fails with "reference is already locked". Switching back does not export the authoritative changelog into the files. |
| Per-agent token; `gl_id` does not change the decision; RPC allowlist; `[[graft.policy]]` includes `HEAD`; agents cannot create a repo, install hooks, or call admin RPCs; shared token is admin; policy and tokens are read at startup | **Confirmed.** One extra footgun: if agents are configured and `standalone` is **false**, `gl_id` is passed through to GitLab's `/allowed` check, so an agent can act as any GitLab user. The safe identity model requires `standalone = true`. |
| No web UI, issues, merge requests, or CI. Does not replace GitLab. `graft` does not speak `git push` / `git pull`. `git log` inside the sparse workspace cannot see history that was not materialized | **Confirmed.** Enabling `SSHService` so agents can push **bypasses** `UserLand`, its retries, and conflict resolution. |
| Layout `cmd/graft`, `sdk/`, `internal/graft`, `doc/graft/`, `examples/graft/quickstart.sh` | **Confirmed.** The only supported client library is Go. Other languages get raw stubs and no bindings. The CLI cannot create a repository. |

### Benchmark, stated precisely

Published table (README and the `v0.2.0` release notes): 50 agents, 5 changes each, one branch, 20% of changes conflict on purpose, two runs on one 16-core machine (release notes: a laptop under WSL2), seed 1, no resolver.

| 50 agents, 250 changes | classic (batching off) | gitai 0.2.0 |
|------------------------|------------------------|-------------|
| changes landed | 100–101 | 200 |
| attempts per landed change | 27 | 1.0 |
| lands per minute | 240–272 | 1,862–2,544 |
| p99 latency | 6.3–7.0 s | 1.5–1.8 s |

With `examples/graft/demo/resolve.toml`, the same notes say all 250 (and 500 of 500 at 100 agents) landed.

`attempts_per_land` is **not** "a typical successful land retried 27 times". `BENCH.md` defines it as every compare-and-swap attempt, including lands that gave up, divided by the number that landed. Failed lands that are merge conflicts count as **zero** attempts, because the server does not report them. In the phase-4 acceptance log at 50 agents with batching off: 2,766 attempts, 101 changes gave up after the cap of 20, about 101 landed, ratio about 27.9. The histogram of **landed** changes still shows many successes that took well above one attempt, up to the cap of 20. Both facts are true: classic mode thrashes, and the headline 27 is inflated by the give-ups.

Each change in that bench adds its **own file**. Contention is on the ref, not on overlapping hunks, except for the scripted conflict rate. It does not model an OpenSpec change, a lockfile, or two agents editing `tasks.md`.

An earlier phase-4a run of record **failed** the latency goal: with batching on, p99 at 50 and 100 agents was worse than batching off. v0.2.0 claims that regression is fixed (one pack per batch, one range listing, no extra `rev-parse`). Treat the 7–9× lands/minute figure as a single-machine microbench of ref updates, not as a forecast for this repository.

### Facts the briefing left out

- Repository created **2026-10-15**. Tag `v0.2.0` on **2026-10-18**. On 2026-10-19 the API reported 2,367 stars, 263 forks, 2 open issues, one public owner (`feder-cr`; `LICENSE` copyright "Federico Elia and the gitai contributors"). Default branch `main`. Language Go. Interfaces may change before 1.0.
- GitHub's license API returns `NOASSERTION` because the `LICENSE` preamble mentions an `ee/` license. The preamble also says everything outside `ee/` is MIT, and `ee/` is not shipped. SPDX metadata and the file disagree; the file is the one to follow.
- README status line says unit, end-to-end, multi-node, crash, and fuzz tests. `LIMITATIONS.md` still says end-to-end tests run on **one machine** and "multi-node behaviour is untested." `STORAGE.md` describes several servers on **one host** sharing a SQLite file. "Multi-node" in the README is not a multi-host proof.
- v0.2.0 fixed real correctness bugs: lands mis-decided when committer dates were skewed (`git rev-list base..head` is not exact in that case); object writes racing housekeeping; `UserSquash` reporting success with an empty commit when the merge failed for a reason other than a conflict.
- Documented and still open: an early batch answer is **final** and is not revised when the compare-and-swap later fails (`LIMITATIONS.md`, phase 4a item 7). A client can be told an outcome the ref update did not keep.
- Durability of object writes assumes ext4 or xfs, not NFS.
- The review classifier decides comment-only only for Go, Python, Rust, and Java. JavaScript and TypeScript are **code**. A path under `docs/` or with extension `.md` is **docs**. Default rules: code and config need one non-author approval; docs, tests, generated, and comment-only need **none**. And none of that is enforced on land.
- Policy globs cannot say "this agent may land only if the diff is under `docs/`". A rule that does not end in a catch-all also **denies tags**.
- `graft` will not materialize `.git` or `.graft` at any depth, or names that are unsafe on the client.

## Fit with the SDD stack

```
  WHERE A CHANGE IS ALLOWED TO LAND
  ═══════════════════════════════════════════════════════════

  ByeByeVibe (today)                gitai (if used as designed)
  ─────────────────                 ──────────────────────────
  worktree A  branch feat/a         agent A ─┐
  worktree B  branch feat/b         agent B ─┼─ UserLand ─ CAS ─ main
       │            │                agent C ─┘         (review advisory)
       └──── pull request ──── GitHub
                    │
                    ▼
              sdd-gates (fail-closed)
              human gate (R7)
                    │
                    ▼
                   main
```

| Tool | Relation |
|------|----------|
| OpenSpec | **Orthogonal and easy to skip.** Artifacts are files. `graft commit --land main` does not know `proposal.md`, `tasks.md`, or the explore→propose→apply split. A resolver that rewrites `tasks.md` with `union` can concatenate two checklists. Phase state would still be "whatever landed", not the reviewed artifact. |
| Session coordination (R11) | **Does not compose.** The lock is a local `flock` on `.sdd/runtime/apply.lock` inside one worktree. gitai's lock is on the server log. Neither sees the other. Two cloud agents in two machines can both pass `sdd-session-check` and both `UserLand` the same branch. That is the situation R11 exists to prevent, moved to a place R11 cannot see. CI runners are already exempt because `.sdd/runtime/` is gitignored; a graft server would make that exemption the write path. |
| GitHub pull requests, `sdd-gates`, automated PR review | **Replaced, not integrated.** gitai has no pull request and no CI. `sdd-gates` runs on `push` and `pull_request` to GitHub. A land that never reaches GitHub never runs `openspec validate --all --strict`, `verify-task-patterns.sh`, or OSV-Scanner. Branch protection, which `infra.md` still lists as a manual GitHub setting, does not apply to a Gitaly CAS. |
| GitNexus | **Broken by the sparse workspace.** Impact, detect-changes, and blame need a local object graph. `LIMITATIONS.md` says `git log` in the workspace needs a normal clone. A partial tree also makes `gitnexus analyze` describe a fiction of the repo. Server-side blame does not implement `gitnexus_impact`. |
| Graphify | Same constraint. `graphify update .` walks the working tree. Paths that were not materialized do not exist for it. The hub's graph is not a substitute for gitai's derived-data cache, and the cache is not a concept graph. |
| `sdd-metrics.sh` | Reads `git log --all` (subjects, dates, change-ids). That requires the commits to be in a **local** clone of the forge the script runs against. A changeset JSONL on the gitai node is invisible to it. Rebase-on-land changes the commit id; messages can survive, but lead time keyed by first-seen commit date will move. Auto-revert commits (`Graft-Auto-Revert`) look like extra `fix` traffic. |
| `cut-release.sh` / tags | A non-empty policy with no catch-all **denies tags**. Release tooling expects `git tag` and `git push` of an annotated tag on GitHub. gitai is the wrong place for that. |
| Probity, correctness-review, security-reviewer | Local, in the agent session, before commit. A Go SDK client landing from outside Cursor never loads those skills. Server-side hooks can run on each land attempt, but **agents cannot install hooks**; only the operator can, with the shared token. A slow hook is paid on every retry. |
| NanoNets Graft (already discarded) | **Name collision, not a technical one.** Different program, same command `graft` on `PATH`, and a directory named `graft/` in that project versus `.graft` / `<git-dir>/graft/` here. An agent that reads "Graft" in `openspec/project.md` non-goals will mix them up unless the evaluation names both. |
| Supply chain (OSV, Renovate, action SHAs) | gitai vendors Git and builds it. There is no lockfile story compatible with the hub's OSV gate. `go install …@v0.2.0` pins the module, not the bundled Git's transitive world, and not the resolver's LLM client. |

### Criteria (C1–C5) and Phase 0

| Criterion | Score | Notes |
|-----------|-------|-------|
| C1 Installation | 🔴 for the kit | Go 1.26, C toolchain, Meson, Ninja, a long-running `gitaly`, token files, a policy, and a bare repo seeded with **plain git** because `graft` cannot create one. Quickstart is a ten-minute lab, not `install.sh`. |
| C2 Compatibility | 🔴 | Write path is gRPC, not `git push`. Cursor cloud agents, GitHub Actions, and worktrees speak Git. |
| C3 Overlap | 🟡 | Does not duplicate GitNexus or Graphify. It duplicates the **forge role** of GitHub for the write. |
| C4 Flow fit | 🔴 | Lands on the shared branch skip R7 and `sdd-gates`. R11 cannot see the race. |
| C5 Community | 🟡 | MIT, active, unusually starred for a four-day-old repo, single individual copyright holder, 0.2.0, "interfaces may still change before 1.0". |

| Check | Result |
|-------|--------|
| V1 already evaluated? | No prior **gitai** row. NanoNets Graft is a different project and stays discarded. |
| V2 contact surface | New daemon, new CLI, new token files, optional resolver and verifier processes. Not a hook or an MCP slot the kit already owns. The collision is the **Git remote**. |
| V3 artifact collision | `<git-dir>/graft/` is inside the bare repo, not the work tree. CLI name `graft` collides with NanoNets. Workspace refuses to materialize `.graft`. |
| V4 profile | DOCS_SPECS hub: expected gain ≈ 0 (few concurrent writers, GitHub is the forge). An APP monorepo with dozens of headless agents on one branch is the only profile where the bench's premise holds. |
| V5 hook stacking | Not applicable in-band. Operator hooks on the server would stack with every land retry. |
| F1 security | Per-agent tokens are a real least-privilege design. The shared token is full admin. Tokens and policy need a restart to rotate. Standalone-off impersonation bug is documented. LLM resolver sends file bytes to the provider. Verifier is unsandboxed. No advisory review in this pass beyond the upstream docs. |
| F2 license | MIT for the shipped tree. GitHub SPDX `NOASSERTION` is a metadata artifact of the `ee/` paragraph. |
| F3 governance | Release this week. One identifiable author. Pre-1.0. |
| F4 reversibility | Mode `off` is the default, so not installing is the reversible state. Leaving authoritative mode **drops** the file changelog. There is no kit uninstall path because it must not enter the kit. |
| F5 operability | `graft-verify --once` and `dry_run` exist. Policy has no dry-run (on the roadmap). Logs are readable. Toggle is "run another server", not a flag in `sdd-kit`. |

## Advantages

These are real, and they are about **ref update throughput and agent identity**, not about spec discipline.

1. **Compare-and-swap on the branch tip, with a short batch window.** Fifty logical lands become one ref update instead of fifty rebase-and-retry loops. The published microbench shows attempts per landed change falling from ~27 to 1.0, and lands per minute rising from the mid-200s to roughly 1,900–2,500, on non-overlapping files.
2. **Sparse, always-online reads.** `ObjectService` returns one blob or one tree. Blame, path history, and search are memoized per commit on the server. An agent that only needs `openspec/changes/<id>/` does not need a full pack negotiation. The hub's own install recipe already uses Git's `sparse-checkout` for a different, one-shot purpose (guide §1.6); gitai is the server-side version of that idea.
3. **Identity is the token, not the string the client puts in `gl_id`.** The changeset records the agent. That is stricter than a shared GitHub bot account, where every cloud agent looks like the same committer. Policy can keep `builder` off `main` while `planner` may land there, including a ban on moving `HEAD`.
4. **Conflict resolution is outside the server and marked.** `Graft-Resolved-By` and `Graft-Resolved-Path` make an LLM merge auditable. Deterministic `trivial` / `union` / `rerere` need no model. The server rejects conflict-marker lines in the answer.
5. **`graft-verify` is a post-land bisect with a revert cap.** `sdd-gates` never runs, because the pull request is the gate. If a project ever did land unreviewed commits on `main`, a verifier that reverts the first bad first-parent commit is the safety net GitHub branch protection does not implement by itself. It must stay opt-in.
6. **The cache checks the Git object id** before serving. A bad cache entry fails closed for that object.
7. **Authoritative mode can rebuild a node from the database and the bucket.** That is a coherent scale-out story. It is also the mode with no pack GC.

None of these replace a pull request, a spec, or a session lock.

## Disadvantages

1. **Pre-1.0, four days of public history, one maintainer, heavy build.** A control-plane dependency on `gitaly serve` plus a bundled Git is a larger operational surface than any tool the kit has adopted.
2. **Go SDK only.** Cursor, Claude Code, and the cloud-agent Git setup do not speak Graft. Teaching every agent a second VCS is a new constitution, which this repo refuses for harnesses (Deer, LifeOS, Astra).
3. **No forge features.** No issues, no merge requests, no CI, no web UI. GitHub remains mandatory for `sdd-gates`, review, and releases. Two systems, or a loss of those gates.
4. **Review does not gate the land.** The feature the README calls "agent-friendly review" does not stop `UserLand`. Default rules would also auto-approve this hub: almost everything under `doc/` and `openspec/` is class `docs`.
5. **Storage core is unfinished for production growth.** No orphan-pack collection, no checkpoint compaction, hydration replays from changeset 1, cloud buckets barely tested, one lock per repository, changelog gaps that do not fail the write.
6. **Correctness nits that matter to agents.** Early batch answers are not revised after a lost CAS. Committer identity is client-supplied. Batch actor is `graft-batch`. A custom hook that rejects `graft-batch` silently disables batching. Recording failures desynchronize the audit log from the ref.
7. **The interesting benchmark avoids the hard case.** Non-overlapping files plus a scripted conflict rate. Two agents editing the same OpenSpec task file is the SDD conflict, and that path is either a hard `merge_conflict` or an LLM/union rewrite.
8. **Name collision with a tool this repo already discarded.**

## Conflicts and bugs if it is wired into the current tools

Ordered by how badly they break the pipeline, not by how likely a lab demo is to hit them.

1. **Silent skip of R7 and CI.** `graft commit --land main` publishes to the gitai `main`. GitHub never sees a pull request. `sdd-gates` does not run. Automated PR review does not run. The human gate is whatever the operator typed into `[[graft.policy]]`. Policy cannot express "allow the land only after `tasks.md` is checked".
2. **Two `main`s.** If GitHub stays canonical, gitai is a fork the moment the first land is not pushed back. If gitai is canonical, GitHub Actions is reviewing a mirror that can be behind, and a lost push reopens the race gitai was meant to close. Authoritative mode makes the database the commit point; GitHub is not a cache node of that database.
3. **R11 false sense of safety.** Session check passes. Another agent on another host lands the same files. The local worktree is clean. The next `graft update` refuses if local edits touch the updated files, or a later land conflicts. The lock file never recorded the collision.
4. **Sparse workspace lies to Git tools.** GitNexus impact, `git log`, `git blame`, `sdd-metrics.sh`, and `verify-i18n-wave.sh` see only materialized paths. An apply that sparsely checks out `openspec/changes/<id>/` and not `openspec/specs/` will edit a delta against a spec it cannot read. `git status` in that tree is not `graft status`.
5. **Resolver versus reviewed text.** `--resolve` with `union` on `CHANGELOG.md` or a checklist concatenates both sides. `--resolve` with `llm` sends both versions to the provider and lands a merge commit marked `Graft-Resolved-By`. That commit has not passed R7. Low-confidence LLM answers are rejected by default; a confident wrong merge is not. Semantic conflicts (each side builds, together they don't) are explicitly out of scope for `trivial` / `union` / `rerere`.
6. **`graft-verify` races the human.** A revert commits `Graft-Auto-Revert` onto the tip with the operator token, up to `max_per_hour`. It bisects **first-parent only**. A flaky `openspec validate` can revert a good land. The revert itself can conflict with the next batched land. Scratch refs under `refs/heads/graft-verify/scratch/` leak if the verifier is killed. This is the opposite of "do not rewrite published history without an explicit request".
7. **Early answer bug.** A client that treats the first RPC success as "it is on `main`" can start the next task on a commit the CAS did not keep. The docs say that answer is not revised.
8. **Committer spoofing and batch attribution.** Policy sees the token. `git log` on a normal clone sees the client-supplied name and email. Metrics and blame then attribute the land to a fake author, or to `graft-batch`, unless the reader uses `graft log` and expands members. Members past 32 KiB are cut; the superfan reports `batch-incomplete`.
9. **Tag and release denial.** A strict branch policy without a final catch-all denies tags. `cut-release.sh` fails in a way that looks like a Git permission error, not an SDD error.
10. **Hook and allowlist traps.** Agents cannot install the hook that would run `openspec validate`. If an operator enables `SSHReceivePack` so that existing agents can keep using `git push`, those pushes skip `UserLand`. The team then has two write semantics on one repo and will not know which one a given agent used.
11. **Standalone flag.** Copying a GitLab-shaped config (`standalone` false) plus agent tokens reintroduces `gl_id` impersonation. The quickstart sets `standalone = true`. A partial config does not.
12. **Shared-token blast radius.** Whoever has `auth.token` acts as any user, can call `CreateRepositoryFromSnapshot` (the docs warn that the archive can carry hooks and symlinks), and can forge `HookService` payloads. That token must never sit in an agent environment or in a committed `.env`. Rotation needs a restart, so a leaked token stays valid until the process is recycled.
13. **Changelog gap.** Git advanced, JSONL did not. A superfan or a future metrics importer that trusts sequence numbers will skip a land or reuse a cursor after a Praefect failover (the new primary's log is a different sequence).
14. **Classifier footgun, latent until phase 5b.** If a later release starts enforcing default review rules, this hub's markdown lands with zero approvals, and a `.go` file placed under `docs/` is class docs. TypeScript is always code, so an APP repo and this hub would not even share a rule outcome.
15. **PATH collision.** `npm i -g @nanonets/graft` and gitai's `graft` binary cannot coexist. Agents will run the wrong one. The non-goal that already says "Graft" must keep the NanoNets URL, and this evaluation must keep the gitai URL.

## Expected vs observed gains

| Advertised gain | Assessment for ByeByeVibe |
|-----------------|---------------------------|
| Hundreds of agents land on one branch without a merge queue | Real in their microbench. The SDD design avoids that queue by **not landing on one branch**. Gain on the hub is ~0. |
| Sparse fetch saves clone time | Real for a huge monorepo. This hub is documentation. Git `sparse-checkout` already covers the install fetch. A permanent sparse workspace breaks the tools that assume a full tree. |
| Server-side blame and search | Real. GitNexus and `git log` already answer those questions on a normal clone, with call-graph impact gitai does not have. |
| Automatic conflict resolution | Opt-in, bounded, and dangerous next to R7. Deterministic strategies do not understand specs. |
| Changeset audit log | Better agent attribution than a shared Git committer. Useless to `sdd-metrics.sh` until someone imports it, and it can gap. |
| Post-land test and revert | A different gate from `sdd-gates` (after publish, not before). Useful only if unreviewed lands exist. They should not. |
| Semantic review (docs need fewer approvals) | Not enforced. Default classes would rubber-stamp this repository. |

## Alternatives already in the stack

- **Isolation:** `git worktree add` on a feature branch, one apply per worktree, `sdd-session-register` / `sdd-session-check` / `sdd-session-release`.
- **Publication:** GitHub pull request. Cloud agents already use `cursor/<name>` branches. Required checks are the operator's branch-protection setting (`infra.md`).
- **Correctness before merge:** `sdd-gates` (`openspec validate --all --strict`, task-pattern verify, OSV when a lockfile exists) and the automated PR review workflow.
- **Human gate:** R7. Propose is reviewed before apply. Archive is a separate phase.
- **Partial fetch, when it is actually needed:** Git's own `sparse-checkout` in the install recipe. It is a one-shot copy, not a second VCS.
- **Identity:** GitHub accounts and PR authors. Weaker than per-agent tokens if many agents share one bot, and still the identity the CI system understands.
- **Maps of the repo:** GitNexus and Graphify. gitai does not compete with them; a sparse graft workspace sabotages them.

## Decision and re-evaluation conditions

**Decision:** Discarded as kit payload and as the hub's version-control server. Deferred as a possible out-of-band landing service for an APP repo that truly runs dozens of headless writers against one branch.

**Do not:**

- add `graft` to `sdd-kit`, `MANIFEST.yaml`, or `install.sh`;
- point cloud agents at `UserLand` on `main` or `master`;
- replace `git worktree` + pull request with a sparse graft workspace;
- enable `--resolve` with an LLM on OpenSpec artifacts;
- enable `graft-verify` reverts against a branch humans also push to;
- treat NanoNets Graft and gitai Graft as the same evaluation.

**Conditions to reopen:**

- A 1.0 (or a stated stable subset) with pack GC, changelog compaction, and the early-answer CAS bug closed in the limitations list.
- A client path that **does not** bypass `UserLand`. `git push` via `SSHReceivePack` is not that path. A non-Go client is required before Cursor or Claude Code can use it without a private wrapper.
- Multi-host tests, not only several processes on one SQLite file.
- A written pilot whose success criteria are fixed first: every land that should be reviewed appears as a **GitHub pull request**; `sdd-gates` stays fail-closed; R11 still blocks two applies in one worktree; `sdd-metrics.sh` either keeps reading Git history or gains an explicit importer; no LLM resolver on `openspec/` or `sdd-kit/`.
- The pilot runs in a scratch APP repo, not in this hub.
- The write-up names **gitai** and links this file, so it cannot be confused with NanoNets Graft.

Until those hold, the integration is possible only as a separate lab server. It is not possible as a component of the SDD toolchain without breaking the gates the toolchain is for.

## References

- https://github.com/feder-cr/git-ai (tag `v0.2.0`, 2026-10-18)
- https://github.com/feder-cr/git-ai/blob/v0.2.0/doc/graft/LIMITATIONS.md
- https://github.com/feder-cr/git-ai/blob/v0.2.0/doc/graft/STORAGE.md
- https://github.com/feder-cr/git-ai/blob/v0.2.0/doc/graft/AGENT-SECURITY.md
- https://github.com/feder-cr/git-ai/blob/v0.2.0/doc/graft/RESOLVE.md
- https://github.com/feder-cr/git-ai/blob/v0.2.0/doc/graft/REVIEW.md
- https://github.com/feder-cr/git-ai/blob/v0.2.0/doc/graft/VERIFY.md
- https://github.com/feder-cr/git-ai/blob/v0.2.0/doc/graft/BENCH.md
- https://www.anthropic.com/engineering/redesigning-source-control (Scion article, as cited by the README)
- SDD: `doc/byebyevibe-guide.md` §3.3, `AGENTS.md` R7/R11, `openspec/changes/explore-oss-coverage-gaps/metodologia-insercao.md`, `doc/avaliacoes/2026-08-17-nanonets-graft.md`

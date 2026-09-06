# Research: Astra orchestration readiness and repository review

Date: 2026-09-05. Type E research, subsequently recorded as the input to an explicitly requested proposal. Revised to cover parallel change streams, knowledge-tool triggers, observability, defect tracking, model economics and the experimental plan. No implementation, commit, push, or PR merge.

This is the consolidated local revision supporting `../add-astra-orchestration-pilot/proposal.md`, created after the operator explicitly requested proceeding to propose. It incorporates the review of `explore-astra-orchestrator` on the remote drafts without importing their already-written proposal or implementation into master. Those drafts remain unchanged and need reconciliation before merge. Proposal preparation does not authorize executing the experiment or changing the pipeline constitution.

## Verdict

Astra can serve as the principal agent using ByeByeVibe's existing protocol. The reviewed research is substantially coherent as a policy-fit analysis, but is insufficient as an engineering feasibility evaluation or an empirical comparison of models. Recommend revisions before accepting its conclusions as the definitive Astra assessment.

The existing one-session/one-phase restriction is a project policy, not a technical limitation of Astra. An external coordinator could start separate phase runs, consume durable artifacts, and preserve explicit approval boundaries. The repository already documents parallel proposal factories and merge-triggered phase runs in `doc/i18n/CURSOR-AUTOMATIONS.md` sections 1–3. Generalizing that pattern to arbitrary demands needs a reviewed proposal and a precise compatibility analysis. A process owning authoritative phase state would conflict with current project non-goals.

The strongest candidate is Astra for demand decomposition, dependency decisions, exception handling, and integration review; bounded agents for individual change phases; deterministic tooling for scheduling checks and observability; OpenSpec and Git/GitHub for authoritative evidence. A dashboard can project those sources without becoming a second specification system. These are proposed design directions, not installed capabilities.

## Repository synchronization and scope

- Initial local HEAD: `70deed9`; `git fetch origin --prune` found two commits behind and zero ahead of `origin/master`.
- Fast-forwarded to `7629aaa`; verified ahead/behind `0/0`. Three pre-existing untracked media files were preserved.
- Astra work is not on master. Draft PRs [384](https://github.com/pvilarim/byebyevibe/pull/384), [385](https://github.com/pvilarim/byebyevibe/pull/385), and [386](https://github.com/pvilarim/byebyevibe/pull/386) contain exploration, proposal, and documentation apply respectively.
- Reviewed PR 386 head: `de37d6e3ba9770c65beab45c2895b1701e1204aa`, including research, proposal, design, tasks, evaluation note, guide/template diff, and manifest diff. Its 11-file diff adds documentation and a spec delta; it does not implement an orchestrator.
- The uploaded `BYEBYEVIBE_ASTRA_ORCHESTRATION_PLAN` is referenced by the research but was not found as a tracked source artifact in the reviewed branch. Fidelity to the original upload cannot be independently verified from this checkout.

## Findings

### 1. High: update the product evidence before preserving the verdict

The drafts defer the Astra product name, API identifier, and capabilities until official documentation exists. Official [OpenAI model guidance](https://developers.openai.com/api/docs/guides/latest-model), fetched during this review, documents `gpt-6-astra`, tool use through Responses, and multi-agent orchestration. These specific unknowns can now be resolved. Account access and availability inside Cursor were not tested and remain separate questions.

The model does not itself provide installed tools, fresh indexes, a durable workflow store, or verified authorization. The research is correct to distinguish infrastructure from reasoning quality. It goes too far when asserting that missing intelligence is not a gap: no comparative pilot, error-rate measurement, or bounded acceptance benchmark supports that generalization.

### 2. High: distinguish policy fit, technical feasibility, and delivered behavior

`openspec/specs/sdd-session-handoff/spec.md` requires phase boundaries and durable artifacts; `openspec/project.md` rejects a code-first runtime owning the pipeline. These support rejecting the incompatible implementation under current policy. They do not prove that every external scheduler or executable validator must compete with OpenSpec.

Calling the role "already shipping" is defensible for a phase-local agent, but does not establish the original principal-agent loop, supervisor/executor separation, automated recovery, or cross-phase orchestration. The PR 386 implementation only names the role in documentation. Its green CI does not validate an Astra integration.

### 3. Medium: the shipped guide introduces an unresolved consumer link

PR 386 adds `avaliacoes/2026-09-05-astra-orchestrator.md` as a relative link in both the hub guide and `sdd-kit/templates/doc/byebyevibe-guide.md`. Its evaluation note exists only in the hub; the MANIFEST has no matching evaluation payload entry. A consumer receiving the guide through the kit therefore does not receive that target. Use a stable hub URL in the distributed guide or explicitly package the required document. The current gates verify checksums and file parity, not this link's target.

### 4. Medium: repository documentation and retrieval freshness drift

The actual MANIFEST and guide are 1.15.1. `openspec/project.md` still describes guide/kit 1.9.0, and `openspec/infra.md` records kit 1.10.0 and an old verification date. The project file also lists an application stack and Claude-specific defaults although it declares DOCS_SPECS and the agent entry point is cross-vendor. Clarify consumer examples versus hub requirements before writing a vendor-neutral orchestration contract.

Graphify's report is dated 2026-08-17 and names commit `5e68200a`. A Graphify query succeeded and returned handoff-related source anchors. GitNexus reports 32 commits behind, and its query returned no results with an explicit missing-FTS warning. Those probes establish degraded retrieval, not absence of relevant implementation. Conclusions here rely on direct source reads rather than a supposedly fresh graph.

### 5. Medium: missing operational evidence

The original study openly records absent Graphify and GitNexus in its cloud environment. Its model-readiness claims rely mainly on a successful documentation session and prior repository practice. Before adopting Astra as the default principal agent, run a bounded pilot on an APP consumer with explicit acceptance criteria: correct classification and source retrieval, scoped delegation where authorized, fresh impact analysis, failing test then fix, verified gates, preserved approval boundary, and restart from artifacts. Record human interventions, task success, regressions, elapsed time, and usage. Compare the same tasks against the current baseline; do not infer superiority or cost savings from the model name.

## Repository strengths and verification

The protocol has clear authoritative specs, durable change artifacts, coordination scripts, an integrity-checked kit, and CI coverage for greenfield install, consumer install, and upgrade. These are useful foundations for a principal agent.

Checks actually completed on master:

- Installed OpenSpec version 1.3.1: `openspec validate --all --strict --no-interactive`, 24 passed, zero failed.
- `bash scripts/verify-release-readiness.sh`: passed; 45 manifest entries checked without integrity errors; version and hub/template parity passed.
- `bash scripts/verify-task-patterns.sh`: passed without warnings.
- Latest master CI and PR 386 `sdd-gates`: success, verified through GitHub CLI. Full smoke workflows were not rerun locally.

The separate pinned `npx --yes @fission-ai/openspec@1.3.1` invocation initially delayed output, then also completed successfully: 24 passed, zero failed; the subsequent release-readiness and task-pattern checks passed.

Open issues consulted: #349 (automated PR review), #363 (native Windows support stance), and #364 (Python dependency in C1). These remain relevant operational backlog, not proof of a defect in Astra.

## Parallel streams: from one demand to several changes

### What can run in parallel

Yes: one demand may yield several `research.md` artifacts and corresponding proposals, with different changes in different phases at the same time. One research question does not automatically deserve one change: alternatives for the same decision belong in the same research until a choice is made. Create separate changes when they have independently reviewable outcomes, scope ownership, acceptance criteria, and meaningful integration boundaries.

Illustrative demand: add a reporting capability. These are hypothetical changes, not new repository tasks:

```text
Demand and acceptance criteria
             |
      shared contract decisions
             |
     +-------+------------------+
     |                          |
 A: report API              B: report UI
 explore -> propose         explore -> propose
             |                          |
        review gate                 review gate
             |                          |
           apply                      apply
             +----------+---------------+
                        |
              integration on compatible base
                        |
              validate / review / merge
                        |
              separate archive runs

 C: independent documentation stream may progress alongside A and B.
```

Each arrow crossing a phase boundary starts a distinct phase run under the current contract. If B requires A's accepted API contract, B can investigate early, but cannot finalize contradictory assumptions or apply against an unavailable dependency. A task being ready is determined by dependencies and evidence, not by the availability of an idle model.

### Proposed admission and scheduling rules

1. Astra produces a small demand map: change IDs, goal, owner, affected capabilities/paths, dependency edges, acceptance criteria, and unresolved decisions. It consults existing changes and issues to avoid duplicate work. This map records intent and references OpenSpec; it does not override individual specs.
2. A phase run receives a bounded assignment and immutable input references: repository/worktree, base commit, change ID, phase, relevant artifact revisions, scope, tools, and expected output. A child research agent does not silently become an apply agent.
3. Start independent research and proposal runs concurrently. Separate worktrees or clones are the recommended default even for artifact-writing phases; read-only investigations can share a snapshot. Do not permit several writers to the same research file.
4. Apply requires reviewed artifacts on its actual base, satisfied dependencies, current impact evidence, authorized scope, and a free worktree lock. Preserve existing approval; do not ask again merely because a new run starts. Approval must be invalidated or reassessed when scope or its reviewed revision materially changes.
5. Cap the initial pilot at two independent work streams and one writer per worktree. This is a proposed experimental limit, not a model/platform maximum. Queue excess work; expand only after measuring coordination overhead and integration failures.
6. Shared API contracts, database migrations, common specs, manifests, and release metadata require ordering or a designated owner. File disjointness is insufficient: two files can encode incompatible assumptions.
7. Before integration, compare the current base with each run's input revision. Rebase/reconcile as needed, repeat affected checks, and integrate in dependency order. Parallel branch tests do not establish correctness of the combined result.
8. Serialize spec promotion when archives touch the same capability. Archive, merge, and release are distinct events; a dashboard must expose them separately. Existing archive skills perform a delta-sync assessment rather than treating checked task boxes as complete integration evidence.
9. On interruption, stop admissions to the affected stream, preserve artifacts and verified evidence, release its locks, and resume with a new attempt ID. Duplicate triggers should resolve to the same logical work item rather than launch duplicate applies. Never force-release an active writer merely because a heartbeat is old.

These rules extend `sdd-session-coordination`, `sdd-session-handoff`, and the existing automation playbook. They are not implemented by today's session scripts. An Astra conversation supervising several phases itself requires an explicit clarification or amendment of the one-phase rule. Hosting the scheduling decisions in separate runs is a compatible starting point; calling a long-lived chat a supervisor does not exempt it from current policy.

### Three distinct execution contexts

- **This exploration:** only research is authorized; no pipeline or agent fleet is being launched.
- **Existing local/cloud agent host:** delegation and separate runs depend on the tools and permissions that host exposes. A slash-command string is not proof that an automation endpoint exists.
- **Future API-backed coordinator:** official [Multi-agent guidance](https://developers.openai.com/api/docs/guides/responses-multi-agent) describes hosted collaboration and application-executed custom tools. Host adapters must still connect repositories, phase runs, approvals, and evidence. The guide's beta examples and model availability must be checked for the selected deployment. Model capability alone does not establish Cursor/API parity or a turnkey ByeByeVibe integration.

## Knowledge tools: triggers and freshness

### Querying is different from rebuilding

Graphify answers conceptual/architectural relationship questions and helps locate prior decisions. GitNexus answers structural code questions, callers/callees, and change impact. Both guide direct source reading; neither proves acceptance criteria or replaces tests. Queries can run while a spec is being drafted. There is no requirement to wait until specification writing pauses.

Recommended trigger matrix, anchored to AGENTS.md R1/R2, integrations, `.cursor/rules/graphify.mdc`, and the phase skills:

| Moment or event | Graphify | GitNexus | Decision supported |
|---|---|---|---|
| Start a demand / phase against a repository revision | Check availability and freshness; read report for architecture work | Check index identity and freshness | Know what evidence can be trusted |
| Explore a type E question | Query related concepts, decisions, and sources | Query structure when technical feasibility depends on code | Avoid rediscovering existing solutions or making unsupported architecture claims |
| Frame a type D feature | Consult conceptual context | Consult current code structure/impact | Split independent changes and identify shared contracts |
| Type C refactor | Use when architectural context is relevant | Establish AS-IS and dependencies | Preserve behavior |
| Type B reproducible bug | Use when context/previous decisions are relevant | Trace affected code and impact | Select the failing test and smallest fix |
| Write/revise proposal, design, or specs | Query as soon as a conceptual uncertainty arises | Query whenever a design assumption depends on current symbols | Make decisions before committing to the design |
| Before editing a symbol | Query only if a new conceptual question arises | Run `impact` on the correct repository/snapshot | Establish blast radius before mutation |
| After a coherent batch of code edits | Update the code extraction; query only when needed | Refresh index when changed structure is needed downstream | Prevent later decisions using old symbols |
| Before commit | Refresh relevant changed graph data as required | Run `detect_changes`; correlate with diff and checks | Confirm affected flows against the actual change |
| After spec promotion / accepted documentation changes | Refresh the affected document/concept corpus through its supported workflow | Reindex if the indexed corpus/structure changed | Make accepted decisions available to the next stream |
| Rebase, merge, checkout, or new worktree | Verify snapshot identity; invalidate affected cached results | Same; do not reuse another branch's impact as current evidence | Revalidate on the integrated base |
| Trivial type A edit | No unconditional conceptual query | No unconditional impact investigation | Avoid turning a one-line edit into a research workflow |

The AGENTS.md baseline remains authoritative: D/E consult Graphify and GitNexus before code, symbols require impact, and commit requires change detection. The matrix makes timing explicit; it does not waive those obligations. No code changes or commit occur in this research revision.

Astra should select the meaningful question and explain material impact. A proposed deterministic preflight can check repository identity, freshness, tool presence, locks, and prerequisites without an LLM. Such enforcement is not already wired merely because a rule is written in Markdown. Autonomous invocation inside an authorized task is preferable to repeatedly asking the operator to run a configured tool.

### Important Graphify correction

Installed `graphify --help` identifies `update` as code re-extraction without an LLM. Inspection of the installed CLI entry point shows that `graphify update .` calls `_rebuild_code` and then explicitly directs document/paper/image changes to `/graphify --update` in the assistant. Therefore an AST-only update is **not evidence that newly written Markdown specs entered the conceptual graph**. AGENTS.md's broad "code/docs changes" wording needs clarification in a later proposal.

Source: installed `graphify/__main__.py`, update branch around lines 1798–1806, at the environment path reported in this session; this is a local runtime observation supplementing the repo's declared Graphify integration, not an assumed public-product guarantee. Document extraction configuration and its possible LLM cost remain `[NEEDS VERIFICATION]` before enabling automatic semantic refresh. Do not force-rebuild away a richer existing graph to obtain a green freshness indicator.

Proposed freshness key: repository identity + worktree/base revision + relevant dirty-file fingerprints + indexer/configuration version + corpus coverage. Commit equality alone misses uncommitted edits. Keep one index writer for a given index directory and only publish completed snapshots. Readers can continue using an old snapshot when explicitly labeled, but must not treat it as current impact evidence. Cache queries by snapshot and scope; invalidate affected results after changes.

Rebuild after coherent changes or before a dependent decision needs fresh evidence, not after every keystroke or on an arbitrary idle timer. Batch several completed documentation changes when no dependent work needs them sooner. If a required index is unavailable, show degraded status and follow the documented fallback; do not claim that an empty query proves no dependencies.

## Dashboard: visibility with source-backed state

Yes, a dashboard is technically feasible as a read-only projection first. It is a new application/module, not a feature implemented by this DOCS_SPECS hub. A separate APP or optional companion is a candidate location. The user interface should answer: what is running, why it can run now, what it waits for, what changed, and what evidence establishes completion.

Proposed views:

| View | Content | Source / current gap |
|---|---|---|
| Demand board | One row per change; explore/propose/apply/archive; status overlay | OpenSpec artifacts plus explicit run evidence; `openspec list` task status alone does not identify phase |
| Dependency graph | Prerequisites, ready work, blocked edges, integration order | Needs a reviewed dependency convention; do not infer solely from PR creation time |
| Agent tree | Root/child, assignment, model, phase, attempt, start/end, heartbeat | Host run metadata plus local sessions; current JSON lacks model/parent/usage |
| Timeline | Run starts, handoffs, review decisions, checks, retries, merges, archives | Persisted run receipts and GitHub/CI evidence; session JSON is deleted on release |
| Findings | Open/confirmed/fixed/verified/deferred defects and their repair evidence | Issues/PR findings, tests, commits and change IDs |
| Resources | Usage by demand/change/model, latency, active concurrency, freshness | Needs host/API usage ingestion; report unavailable data as unknown |

Show **phase** separately from **status**: an apply run can be queued, running, waiting for review, blocked by dependency, failed, interrupted, or completed. Show proposed, approved, applied, merged, archived, and released evidence without conflating them. `tasks.md` completion and file existence do not prove a live agent's activity or successful deployment.

Current session implementation limits found by direct reads:

- `sdd-session-status.sh` reads only the current worktree's `.sdd/runtime/sessions`; it does not aggregate every worktree or remote machine.
- `sdd-session-release.sh` deletes the local presence JSON. This is liveness metadata, not historical audit evidence.
- `sdd-session-lib.sh` has one `current-session.id` per worktree. It is not a general registry for several simultaneously registered writers in that worktree.
- `sdd-session-heartbeat.sh` records the short-lived Python helper's PID. A dashboard must not equate that PID with the agent's process. Validate lifecycle semantics before using the registry for crash recovery.

A proposed run receipt can reference run/parent IDs, phase, change, model, worktree/base, artifact revisions, timestamps, outcome, evidence links, usage when available, and retry relationship. This is operational history; it must not become an alternative authority for requirements or approval. Avoid storing full private prompts and tool payloads when references and bounded summaries suffice.

A refresh button should read facts without invoking Astra. Add state-changing dashboard controls only in a separate reviewed step, using the same authorized phase-launch path. A display failure must not cancel running work. A historical success badge must identify its tested commit. A transport retry must not create duplicate agents or merges.

## Bugs: finding ledger plus release changelog

A changelog is useful for communicating shipped fixes, but is insufficient to track open defects, investigations, failed attempts, and verification. Use linked findings/issues and a timeline for operations; derive a concise release changelog from accepted changes.

Proposed defect evidence chain:

```text
Finding -> reproduction / failing test -> confirmed cause
        -> fix task or type B change -> fix commit / PR
        -> passing regression evidence -> integrated revision -> release note
```

Record a stable finding ID, originating change/run, symptom, expected/actual behavior, severity, reproduction, affected revision, owner, status, fix reference, and verification evidence. Deduplicate repeated reports and distinguish an unconfirmed LLM concern, a failing test, an infrastructure failure, and a confirmed product defect. A fixed branch does not mean a released fix. Deferred findings need a rationale and accepted scope impact.

Within-scope implementation defects can be repaired in the current apply task with failing-test evidence under R6. Discoveries that change the reviewed contract require an artifact decision/handoff; unrelated defects become separately scoped work. This research does not create external issues or post PR messages. Existing issue traceability and [issue #349](https://github.com/pvilarim/byebyevibe/issues/349) are the integration anchors; avoid building a rival bug database.

Existing `sdd-metrics.sh` reports volume, lead time, and post-archive fix-commit proxies. It cannot currently supply complete defect lifecycle or token accounting. Label those proxies rather than presenting them as measured defect rates.

## Token use, cost, and routing

### Optimize cost per accepted outcome

Parallel agents primarily reduce elapsed time when tasks are independent; they can increase total tokens through duplicated context, communication, and review. A stronger model may reduce rework, but that benefit must be measured. Fewer tokens, lower price, shorter latency, and fewer human interventions are separate metrics.

Proposed accounting: total demand cost = coordinator + every worker and reviewer attempt + retries + integration work + tool charges. Use provider-reported usage and billing categories where available, including cache reads/writes and reasoning accounting, without double-counting tokens already included in output totals. If the host exposes only credits or incomplete usage, show that unit and coverage; do not fabricate token totals from message length.

Practical controls:

1. Decompose only when independent work justifies additional context and integration overhead. No automatic full expert panel for each task.
2. Give each agent a compact context packet: authoritative instructions, task/acceptance criteria, relevant source paths and revisions, constraints, and expected evidence. Do not copy the entire research history to every worker or remove applicable repository rules to save tokens.
3. Retrieve a small relevant source set using graphs and targeted reads. Reuse results for the same snapshot rather than asking each agent to rediscover the repository.
4. Let scripts read status, validate checksums, aggregate events, count tasks, and update dashboard views. These operations need no LLM reasoning.
5. Wake Astra for decisions, new evidence, exceptions, or integration review; do not have it poll a dashboard and narrate every heartbeat. Resume from durable artifacts after interruption.
6. Use bounded task reports with facts, decisions, evidence links, and unresolved items. Avoid repeated narrative summaries and debates between agents with no concrete deliverable.
7. Set concurrency, retry, and spend limits per demand and attempt. Repeated unchanged failures trigger diagnosis/escalation, not a loop of identical prompts. Infrastructure failures first go to infrastructure diagnosis, not automatically a more expensive model.
8. Preserve stable prompt prefixes where the host/API supports it. [OpenAI prompt caching](https://developers.openai.com/api/docs/guides/prompt-caching) reuses matching prefixes and can reduce input processing cost/latency; it does not eliminate context tokens or create durable project memory. Changing models or rewriting/compacting prefixes can affect reuse. Newer models have cache-write billing as well as discounted reads; verify real usage instead of assuming all caching saves money.
9. Scope checks to meaningful risks while honoring mandatory gates. Repeat them when new code/base changes invalidate earlier evidence; do not repeatedly re-run successful checks without cause.

### Initial routing hypothesis, subject to a pilot

The official [model catalog](https://developers.openai.com/api/docs/models) positions Astra for the hardest reasoning/coding work, Terra for intelligence/cost balance, and Luna for cost-sensitive workloads; it also lists Sol for complex professional work. This does not establish comparative results on ByeByeVibe. The mapping below is a proposed policy, not a measured ranking or a universal phase-to-model rule.

| Work characteristics | Initial candidate | Escalation / verification |
|---|---|---|
| Status aggregation, lock/freshness checks, manifest validation | Deterministic CLI/service | Fix infrastructure failures; no model required |
| Bounded extraction, routine formatting, narrow low-risk task with strong checks | Luna or another locally validated economical model | Escalate if scope cannot be met or evidence remains ambiguous |
| Ordinary implementation with clear contracts and tests | Terra; Sol for more demanding professional/coding work | Escalate when unfamiliar coupling or repeated reasoning failures appear |
| Ambiguous demand, decomposition across capabilities, shared-contract decisions, difficult bug diagnosis | Astra | Require source-backed decisions and executable evidence where applicable |
| High-impact integration or contradictory specialist findings | Astra or the strongest evaluator proven on that task | Preserve independent verification and approval; model confidence is insufficient |

Route on ambiguity, novelty, blast radius, dependency count, reversibility, available test oracle, context/tool requirements, observed model performance, deadline, and budget. A difficult bug may deserve Astra even though it is type B; a routine propose may not. Do not assign a cheaper model solely because a task is labeled apply, or force Astra onto all research. Do not resolve product ambiguity by increasing reasoning effort when operator input is necessary.

Use the least expensive eligible model that meets the measured quality target. Candidate escalation policy for a pilot: one bounded worker attempt, then a diagnosis checkpoint before another attempt; route reasoning failures upward with the diff/test evidence already collected. No fixed retry threshold or savings percentage is adopted by this research. High-impact tasks can start on Astra directly.

Other vendors remain eligible after checking host access, tool support, data constraints, and results on the same evaluation set. This study does not assert current Claude/Gemini/Grok prices or superiority. Model selection in a host UI and API model routing are different deployment controls; cross-model delegation support must be verified for the chosen adapter.

### Pilot and acceptance evidence

Compare a sequential baseline, bounded parallel execution, and mixed-model routing on the same representative tasks and comparable starting revisions. Include independent changes, a shared-contract dependency, a seeded bug, a stale-index case, an interrupted worker, and an integration conflict. Repeat enough trials to see variability rather than treating one documentation success as a benchmark.

Record completion quality, regressions, scope/approval violations, dependency-order failures, operator intervention, elapsed time, input/output/cache usage or credits, retry cost, and cost per accepted result. An acceptable pilot must preserve phase/approval boundaries, stop incompatible work, recover without duplicate writes, report unavailable telemetry honestly, and pass the consumer's actual tests. Set numeric cost and quality targets before the trial. No economic savings claim is justified yet.

## Scope to settle before propose

### Recorded experiment and maturity decision

The operator requested recording the experimental plan and proceeding to propose. The research is mature for a bounded pilot protocol, not for adoption of an autonomous platform. Hub deliverables are the protocol and evidence templates; APP execution belongs to an approved consumer change after the repository, host access, numeric budget, and acceptance criteria are recorded.

Use a three-front representative demand: A defines/implements a report-export contract, B implements a UI depending on that contract, and C fixes an unrelated reproducible bug. The example is replaceable by equivalent work in the selected consumer. Research may overlap; dependent implementation waits for a reviewed and available contract. Limit simultaneous workers to two initially, even though the demand has three changes.

| Hypothesis | Observation | Development decision |
|---|---|---|
| H1: Astra decomposes the demand correctly | Compare changes, dependency edges, and acceptance coverage with an independent pre-recorded rubric | Automate decomposition or retain human decomposition |
| H2: parallelism improves elapsed time without quality loss | Compare sequential and parallel runs with identical worker-model choices | Selective parallelism versus sequential coordination |
| H3: knowledge tools improve decisions | Record query, snapshot, cited source, and decision affected; assess usefulness independently | Required triggers versus on-demand retrieval; do not disable mandated checks for a control |
| H4: artifacts enable reliable recovery | Interrupt a worker and resume in a fresh phase session | Prioritize receipts, ownership and recovery contracts if recovery fails |
| H5: mixed models reduce cost at acceptable quality | Compare the chosen topology with and without mixed workers | Adopt measured routing or retain simpler model selection |
| H6: coordination reduces operator effort | Measure approval time separately from corrective interventions | Automate transitions or improve task artifacts first |
| H7: operational state can be reconstructed honestly | Compare projected phase/status with run, artifact, and integration evidence | Instrumentation before dashboard if reconstruction fails |

Stage 1 is a functional shakedown with a stale index, interrupted executor, and revised shared contract. A hard scope/approval violation, silent contract incompatibility, duplicate side effect, lost recovery decision, or false completion report fails the trial. Infrastructure/test-harness failures are separately classified and retained, not silently dropped.

Stage 2 compares A (operator-coordinated sequential reference), B (Astra-directed sequential), and C (Astra-directed parallel), holding worker models, tasks, base revision, tools, and acceptance rubric constant. Stage 3 changes worker-model routing only after topology selection. Three trials per configuration are an initial screening minimum, not statistical proof; vary execution order, use isolated equivalent starting states, and extend sampling when results overlap or vary materially.

Record total cost per accepted result, elapsed time, operator minutes, retries/rework, integration defects, and recovery failures. Costs include coordinator, workers, reviewers, retries, integration, and tools; missing usage stays unknown. H3 is observational unless a later controlled study is approved, so do not infer causality from consultation logs alone. A 20% time-reduction target is an illustrative candidate only; the operator must record actual quality, cost, and productivity thresholds before execution. No target or savings claim is adopted retrospectively.

Decisions after the pilot may be: sequential Astra coordination, selective parallelism, recovery infrastructure first, mixed-model routing, instrumentation before dashboard, or no adoption. This protocol exists to choose among those paths; success is not defined as proving Astra should be adopted.

### Recorded later demand: optional Astra adoption

The operator added a product constraint after the pilot-protocol proposal was created: the current ByeByeVibe installation path must remain available for users who do not want Astra as orchestrator. This is coherent and should be recorded as a later adoption-track requirement rather than folded into the first pilot. The pilot should decide whether Astra orchestration is worth pursuing; a separate follow-up change should decide how users opt in, opt out, upgrade, and understand the capability tradeoffs.

Candidate requirement for that later change: Astra orchestration is an optional mode layered on top of the existing framework, not a replacement for the base ByeByeVibe install. The default and upgrade behavior should preserve existing users unless they explicitly choose the orchestrated mode. README, guide, kit README, bootstrap/install help, dry-run output, and post-install messages should present the choice in plain language: continue with the standard SDD workflow, enable Astra orchestration when the host/model/tooling requirements are available, or configure it later.

Capability detection should be honest and friendly. The installer can detect local facts such as available CLIs, existing project profile, GitHub remote, Graphify/GitNexus availability, and installed optional modules. It must not imply that model access, billing limits, Cursor/API availability, or organizational authorization exists unless that evidence is actually observed. When orchestration is unavailable, the message should name the missing capability, state that the standard ByeByeVibe workflow still works, and point to the later setup path without failing the core install.

This later track should also define upgrade and rollback semantics: enabling Astra orchestration should be reversible without rolling back the framework, disabling it should leave OpenSpec artifacts, gates, and ordinary `/opsx` phases usable, and consumer docs should avoid presenting Astra-only commands as required. The wording should follow the current add-on posture already used for Graphify, GitNexus, UI, and Probity: advisory detection, explicit user choice, clear scope, and no surprise writes.

Existing non-orchestrated installations and older ByeByeVibe releases need an explicit migration path into the optional Astra mode. That path should start from the installed kit version and repository state, show whether a normal framework upgrade is required first, and then offer Astra enablement as a second, opt-in step. A previous release should never be silently converted into an orchestrated workflow by a routine C2 upgrade. The later proposal should define version detection, minimum supported source version, repair path for known broken installs, dry-run diff, user-facing prompts, and rollback evidence for legacy consumers.

The pilot can gather inputs for this adoption change without implementing it: what capabilities were actually required, what failures confused the operator, what model-routing decisions were useful, which dashboard/status fields mattered, and which parts of the standard workflow remained unchanged. A later proposal could use working id `add-optional-astra-orchestration-mode`, but this research does not create that proposal or authorize README, guide, installer, or kit changes now.

Roadmap sequence (the pilot-protocol proposal now exists; later items remain candidates):

1. Reconcile the original Astra drafts with this research: verified product facts, role versus coordinator distinction, consumer link correction, and documented knowledge freshness limits.
2. Propose a bounded phase-run and dependency contract with one chosen host adapter, artifact/approval references, worktree ownership, index triggers, and restart semantics. Clarify the supervisor's relationship to the one-session rule explicitly.
3. Pilot two independent streams plus a dependent integration using available tools, recording run receipts and model usage where exposed. This should precede an autonomous control dashboard.
4. Propose a read-only dashboard using the observed data contract; add findings through the existing issue/review surface. The dashboard can proceed alongside pilot refinements once the data contract is stable.
5. Propose optional Astra adoption as a separate install/upgrade UX change, preserving the standard ByeByeVibe workflow for users who do not opt in, defining a migration path from older non-orchestrated releases, and making capability messages user friendly.
6. Expand automation and model routing only from measured results; interactive controls and distributed coordination are separate scope decisions.

Working assumption for the next discussion: human-reviewed proposals, automatic execution of already-authorized bounded actions, no new hub runtime, dashboard observation first. Still open: first host (local Codex, Cursor Cloud, or API companion), consumer pilot repository/task, allowed concurrency and budget, exact recorded approval mechanism, and whether the desired long-lived Astra supervisor should prompt a deliberate constitutional amendment. These are product/design choices for propose, not reasons to block this research revision.

## Recommended disposition

Revise the existing Astra research and documentation drafts: incorporate official product evidence, qualify feasibility claims, preserve historical observations with dates, fix the consumer link, and distinguish phase-local operation from the unimplemented principal-agent loop. Retain the useful protocol mapping. Do not merge the drafts solely because CI is green.

Proceed toward a bounded orchestration pilot through a separate reviewed proposal. A broader coordinator needs an explicit authority and persistence design rather than automatic rejection by analogy with Deer or automatic adoption because Astra supports subagents. Retain OpenSpec as the specification authority and treat dashboard state as a projection of evidence.

## Sources and limits

- Normative local sources: `openspec/project.md`; `openspec/infra.md`; `openspec/specs/sdd-session-handoff/spec.md`; `openspec/specs/sdd-session-coordination/spec.md`; `openspec/specs/sdd-ci-gates/spec.md`.
- Implementation evidence: `.github/workflows/sdd-gates.yml`; `sdd-kit/MANIFEST.yaml`; `scripts/verify-release-readiness.sh`; `scripts/verify-task-patterns.sh`; guide and template.
- Reviewed draft artifacts: `origin/cursor/apply-astra-orchestrator-66e1:openspec/changes/explore-astra-orchestrator/` and `doc/avaliacoes/2026-09-05-astra-orchestrator.md`.
- External verification: official OpenAI model guidance linked above, consulted specifically to resolve the research's named product unknowns.
- Expanded-operation anchors: `doc/i18n/CURSOR-AUTOMATIONS.md` sections 1–3; `openspec/specs/sdd-issue-traceability/spec.md`; `openspec/specs/sdd-metrics/spec.md`; `scripts/sdd-session-{lib,status,heartbeat,release}.sh`; `.cursor/rules/graphify.mdc`; `.cursor/skills/openspec-{explore,propose,apply-change,archive-change}/SKILL.md`; `openspec/changes/explore-oss-coverage-gaps/research.md` G6. Historical third-party claims in old evaluations were not re-verified or adopted as current product facts.
- Current official sources additionally fetched: OpenAI model catalog, Prompt caching, and Responses Multi-agent, linked in the relevant sections. Prices and account-specific access are deliberately not promised.
- Follow-up runtime probe: the Graphify query initially failed to print a Unicode arrow under Windows cp1252; `PYTHONIOENCODING=utf-8` allowed the same query to complete. No repository code was changed for this environment workaround. GitNexus still reported missing FTS indexes.
- This is a targeted architecture, documentation, and gate review, not an exhaustive security audit or a live Astra API/Cursor integration test. Knowledge indexes were consulted but not rebuilt during this review.

# Astra pilot documentation readiness review

Date: 2026-09-06. Scope: documentary apply of `add-astra-orchestration-pilot`.
Review method: **desk review**, including adversarial expected-outcome walkthroughs. Trials are **not measured**; no consumer result, cost, budget or adoption conclusion is populated. Document readiness is distinct from consumer admission, which remains **NOT READY**.

The operator explicitly authorized this documentary apply in a fresh apply session. Existing dirty proposal/design/tasks/delta and consolidated research were read as the authorized input; their pre-existing edits are not attributed to this apply. No proposal conflict was found against the current specs. Source and reviewed package fingerprints are recorded below so HEAD alone is not mistaken for the reviewed dirty revision.

## Requirement coverage

All twelve delta requirements were reviewed against the actual prose and template fields, not only headings. P = [protocol](../../../doc/experiments/astra-orchestration-pilot.md), R = [registration](../../../doc/experiments/templates/astra-pilot-registration.md), U = [run evidence](../../../doc/experiments/templates/astra-pilot-run.md), D = [decision](../../../doc/experiments/templates/astra-pilot-decision.md).

| Delta requirement | Reviewed sections | Semantic finding |
|---|---|---|
| Hub experiment package | [Index](../../../doc/experiments/README.md), P introduction; R initial status; D initial status | Discovery reaches all three templates; documentation, authorization and measured outcomes remain distinct |
| Trial admission is explicit | [P Trial admission](../../../doc/experiments/astra-orchestration-pilot.md#trial-admission), [R Limits and approval](../../../doc/experiments/templates/astra-pilot-registration.md#limits-and-approval), R Admission checklist | Budget/owner/enforcement, actual host/shell/locks, revision-bound authority and H1 versus implementation map gates are explicit; no required numeric defaults fabricated |
| Comparable staged hypotheses | [P Hypotheses](../../../doc/experiments/astra-orchestration-pilot.md#hypotheses), P Comparisons; R Demand and rubric, Arm schedule and accounting | All H1–H7 metrics/oracles/criteria/inconclusive paths, quality tolerances, hidden references, clocks/sampling and separately frozen routing present |
| Existing phase and worktree boundaries | [P Authority and integration](../../../doc/experiments/astra-orchestration-pilot.md#authority-and-integration), U Evidence/Recovery | Separate chats; valid approval retained across attempts; local scripts, distinct worktrees, combined checks and ordered spec promotion preserved |
| Knowledge evidence has identity and coverage | [P Knowledge tools](../../../doc/experiments/astra-orchestration-pilot.md#knowledge-tools), R Tools and snapshots, U Evidence | Consultation is not waived; source reads expose uncovered scope; stale/absent/injected paths block unknown impact; queries, AST refresh and document ingestion distinguished |
| Functional fault trials and stopping rules | [P Comparisons](../../../doc/experiments/astra-orchestration-pilot.md#comparisons), R Functional injection registration, U Recovery | Stimulus/oracle/deadline/failure distinct; F gates T, quality-selected topology gates M, material repair preserves failed costs |
| Fallback decisions are operationally explicit | [P Recovery](../../../doc/experiments/astra-orchestration-pilot.md#recovery), U Recovery/Findings | Every fallback includes detection, owner, blocked work, retained evidence and resumption; no speculative replacement writes |
| Source-backed run and finding records | [U Identity](../../../doc/experiments/templates/astra-pilot-run.md#identity), U Evidence/Findings/Recovery/Usage/Outcome | Identity, phase/status, authority, revision, checks, finding lifecycle, interventions, telemetry gaps and release distinction present |
| Decision report includes failures and complete costs | [D Quality gates](../../../doc/experiments/templates/astra-pilot-decision.md#quality-gates), D Costs and effort/Limitations/Decision | All attempts/exclusions retained; accepted integrated demand is denominator; zero undefined; full costs and operator effort visible; quality precedes efficiency |
| Post-pilot review preserves optional adoption boundaries | [D Post-pilot proposal review](../../../doc/experiments/templates/astra-pilot-decision.md#post-pilot-proposal-review), P Decision boundaries | Required evidence-backed proposal revisions/disposition, reversible opt-in, no silent C2 migration, separate dashboard/install/migration/routing scopes |
| Consumer copies preserve evidence provenance | [P Consumer handoff](../../../doc/experiments/astra-orchestration-pilot.md#consumer-handoff), R Experiment identity, U/D provenance fields | Copy only templates into consumer evidence; accessible full-revision pins replace placeholders; archive relocation preserves old receipts |
| Documentation readiness is reviewed without fake trials | This review, Scenario walkthrough and Remaining execution inputs | Semantic expected results recorded separately from measurements; unresolved normative mismatches would block readiness |

Task Acceptance review:

| Task | Acceptance evidence beyond structural gate |
|---|---|
| 1.1 | P Admission/Hypotheses protects H1 input; Comparisons enforces F/T/M, sampling/clocks/routing; Recovery/Knowledge tools supply complete D7/D8 matrix; Authority preserves separate chats and revision-bound approval |
| 2.1 | R explicitly separates assessment/execution, host verification and limit owner, quality tolerance, exclusions, sampling ceiling/stopping, clocks and configuration-specific stage checkboxes; ambiguous authority/unenforceable budget stay NOT READY |
| 2.2 | U records stimulus versus recovery, oracle/deadline, ownership/effects, invalidation/configuration changes, all effort categories, clocks and retained failed/contaminated attempts; Findings requires R6/scope triage; Outcome preserves unknown/disputed |
| 2.3 | D includes failures in numerator, undefined zero denominator, exclusions/setup/F/full totals and missing-cost limits; post-pilot review requests evidence-backed disposition with legacy/opt-in and separate follow-up boundaries |
| 3.1 | Index links all artifacts; P handoff specifies consumer path/copy and full-revision provenance; link/layout/archive checks recorded below; kit and remote drafts untouched |
| 3.2 | Requirement mapping and every D9/adversarial case below cover decision owners, evidence, expected result and resumption; input/package hashes identify reviewed content |
| 3.3 | Validation and scope results recorded below; coordination release required before final handoff; no runtime, trials or adoption assertions |

Current-spec compatibility: [handoff](../../specs/sdd-session-handoff/spec.md) and [coordination](../../specs/sdd-session-coordination/spec.md) retain phase/worktree authority; [install kit](../../specs/sdd-install-kit/spec.md) retains C2 UPGRADE_REPORT approval and payload integrity; [install narrative](../../specs/sdd-install-narrative/spec.md) retains consumer ownership and optional add-ons. [Tooling guidance](../../specs/sdd-tooling-guidance/spec.md) retains CLI-first, refusal and offer-only behavior; [metrics](../../specs/sdd-metrics/spec.md) remains historical proxies; [task patterns](../../specs/sdd-task-patterns/spec.md) retains gates and DOCS_SPECS limits; [CI gates](../../specs/sdd-ci-gates/spec.md) remains unchanged, including release-readiness and greenfield-install requirements. No modification to these capabilities is needed for hub-only documents.

## Scenario walkthrough

These are desk inputs and expected results, not executed consumer trials. “Owner” describes the registered consumer decision role, not an invented assigned human. All rows were checked against the linked package sections above.

| Case / detection | Decision owner | Affected work and preserved evidence | Expected decision/result | Resumption criterion |
|---|---|---|---|---|
| Normal admission: reviewer inspects complete stage registration | Operator + independent reviewer | H1 packet/approval/budget; later reviewed dependency map and F records | H1 may be admitted without leaking evaluator map; implementation only after its own gates; F precedes T and selected topology precedes M | Verified required fields and revision-bound authorization for the requested stage |
| Missing numeric budget or unit / no enforcement mechanism | Budget owner | All assessment/trial work blocked; retain incomplete registration | NOT READY even for F; no invented ceiling | Numeric enforceable cost/credit ceiling, mechanism and named stopping owner verified |
| Stale index yields empty result / source SHA mismatch | Knowledge owner + reviewer | Block impact-dependent mutations; retain query/error/index/source revisions and uncovered scope | Empty result does not establish no dependencies; authorized refresh or permitted actual source reads required | Required impact evidence established; no waived mandatory consultation |
| Worker interruption at registered checkpoint | Worktree owner + operator | Replacement writes blocked; retain original attempt, expected checkpoint, receipts and effects | Reconcile ownership and effects, then create linked attempt; stimulus alone is not recovery failure | Exclusive ownership, no duplicated effects and recovery oracle/deadline satisfied |
| Changed contract/base invalidates approved dependency | Contract approver + integration owner | Dependent work blocked; preserve old/new revisions and invalidate affected approval/test receipts | Reassess dependency and affected approval, then fresh combined checks | Approved available base and reviewed map; current acceptance evidence |
| Missing token telemetry / credits only | Budget owner + evaluator | Preserve actual unit/coverage and enforcement evidence | F only with enforceable alternative ceiling; incomparable costs mean economics inconclusive; no prose token estimates | Verified budget for functional work; comparable coverage for economic conclusion |
| H1 reference leaks via protocol/fixture before first answer | Independent evaluator | Retain input packet, leaked reference, first answer/timestamps and contaminated cost | H1 inconclusive, not supported by a prompted answer | Fresh equivalent fixture, evaluator isolation, new bounded assessment authorization coverage |
| F recovery oracle/deadline fails and scheduler requests T | Reviewer + operator | Block T/M; retain failed F, repairs and expenditure | Failure stays visible; a new configuration cannot erase it | Repaired configuration passes affected F cases before comparison |
| Zero accepted integrated demands with paid failed attempts | Evaluator | Retain all eligible failures/retries and comparable spend | Cost/accepted outcome undefined; report spend/failure count; no zero-cost success | Accepted comparable outcomes required for defined ratio; quality gates still mandatory |
| Missing/ambiguous approver, action/scope or revision | Human approver | Block affected action; retain exact authority gap and any still-valid approval | Receipt/silence/dashboard cannot authorize; new session alone does not discard valid approval | Explicit approval for uncovered scope/revision |
| Astra unavailable before admission: failed actual access check | Operator | No trial admitted; preserve probe/configuration/limitation | NOT READY; standard workflow remains available | Verified original access or registered/revalidated replacement |
| Astra unavailable mid-run: host error and active worker state | Operator + worktree owner | Stop new affected admissions; retain attempt/checkpoint/ownership/spend | No silent model swap; reconcile current writers first | Same verified configuration or replacement configuration with affected F revalidation |
| Knowledge tools absent/broken/declined | Knowledge owner + reviewer | Preserve mandatory attempts/errors, refusal and direct reads of symbols/callers/contracts/tests | No unrequested installation; fallback is not blanket waiver; unknown-impact work remains blocked | Required evidence established on actual revision under existing rules |
| Ownership or external effects remain uncertain after interruption | Operator/worktree owner | Block replacement writes; retain process/lock observations and actual effect receipts | No forced live-writer release or speculative retry; unknown is not safe | Source-backed ownership and duplicate-effect reconciliation |
| Git conflict or semantic integration failure | Integration owner | Stop affected integration, preserve both revisions and failed combined tests | Resolve in dependency order; disjoint authorized work may continue | Reassessed scope/contract if changed and fresh affected combined-revision checks |
| Overlapping spec promotions | Integration owner | Block conflicting promotion; retain both deltas and order decision | Serialize promotion through OpenSpec, not receipt order | Prerequisite promoted/available and subsequent delta revalidated |
| In-scope reproducible bug | Scope owner + reviewer | Keep reproduction, failing test, cause, repair and regression evidence | R6 precedes repair; branch fix is not release evidence | Passing regression and integrated checks within covered scope |
| Out-of-scope bug or contract-expanding repair | Operator/approver | Block unrelated repair; preserve reproduction and scope mismatch locally | Separate consumer change or contract reassessment/handoff; no unapproved issue/PR write | Explicit reviewed new scope in appropriate phase and tests |
| Consumer copies templates into own change | Consumer evidence owner | Preserve template hashes, consumer paths and resolved source pins | No hub-relative links or copied hub history; unresolved pins mean NOT READY | Accessible reviewed full revision contains exact source paths; consumer link check passes |
| Research is archived after a consumer pin exists | Hub maintainer + consumer evidence owner | Preserve original receipt/pin; record actual new archive location for new copies | Update hub relative link; old pin still identifies original revision/path; no guessed date | Both current hub and selected historical source targets verified |
| H7 receipt absent or contradictory | Independent evaluator | Preserve missing-field record or both contradictory sources; block unsupported completion claim | Absent = unknown; contradictory = disputed; phase/approval/test/integration scored separately | Source evidence resolves state against frozen independent oracle; never infer success |
| Faster arm changes worker models/scope or violates authority | Evaluator + approver | Preserve configuration deviations, approval violation and all costs | Confound precludes attributing benefit to concurrency; authorization failure rejects efficiency recommendation | Comparable authorized configuration passes functional and quality gates |
| Registered time/retry/spend limit reached | Named limit owner | Stop affected trial; preserve consumption and intervention receipt | No hidden extension, cost erasure or continuing for a nicer average | Explicit new decision within approved scope; material repair/configuration revalidated |
| Pilot evidence suggests future adoption / old C2 release | Human proposal reviewer | Preserve all failures/costs/compatibility observations and standard workflow | Review definitive proposal improvements; no automatic enablement; upgrade approval is not Astra approval | Separate reversible opt-in proposal, source-version/support/repair/dry-run/rollback requirements reviewed |
| Dashboard requested as completion authority | Human proposal reviewer | Preserve evidence gaps and dashboard request | Read-only projection; unknown/disputed remain visible; installation/migration/routing stay separate | Separate controls proposal if needed; OpenSpec authority retained |

Detected documentation hazards and resolution: H1 answer leakage through the evaluator protocol is prevented by the explicit restricted-input rule in P Trial admission and Consumer handoff; R/U retain reference fingerprints without embedding the reference. Uncommitted-package pins could falsely claim provenance: P Consumer handoff explicitly blocks consumer readiness until an accessible reviewed revision contains the package. Neither correction changes the authorized proposal's scope. No unresolved normative mismatch was found in the package; environment limitations below are not certified trial capabilities.

## Remaining execution inputs

Consumer repository/base and demand; reviewed consumer change and run/assessment approval; independent reviewer and integration owner; actual Astra/host/model/settings and phase-launch access; Bash/exclusive-lock behavior; required tool coverage; numeric spend/credit/time/retry limits and enforcement owner; quality/time/cost/effort thresholds; sampling/exclusion/clock rules; frozen routing policies; private H1/H7 evaluator oracles; source-accessible reviewed package revision; provider usage coverage. All remain unpopulated. No APP trial or host concurrency test was run in this hub.

Accepted limitation for this documentary apply: direct current sources establish document scope while graph coverage is stale/degraded. They do not establish consumer symbol blast radius or runtime readiness. The user prohibited index/generated-file writes, so no refresh was performed. The local registration script reports no `flock`, using its existing PID-file guard; this apply has one writer and read-only researchers. That is not proof of the exclusive-lock requirement on a future consumer; its admission remains blocked until actual required lock behavior is verified. This pre-existing platform limitation is recorded, not repaired or waived by the pilot.

## Knowledge and coordination evidence

| Consultation / operation | Observed result |
|---|---|
| `git rev-parse HEAD` | `861c20fd5ccaceb2215b895961d4d15bedcde2ac`; relevant dirty sources separately fingerprinted below |
| Graphify report read | 2026-08-17, built from `5e68200a`; **STALE** versus current HEAD |
| `graphify query 'session handoff'` with UTF-8 output | Exit 0; BFS depth 2, 24 nodes; handoff source anchors returned. Does not prove current Markdown semantic coverage |
| `npx gitnexus status` | Exit 0; **STALE**, indexed 2026-08-06T14:08:30.167Z at `8666235ea8101ffeb82a407a3812b92e0015b359`; MCP reports 33 commits behind |
| GitNexus MCP query `sdd session coordination install upgrade`, repo `byebyevibe` | Empty arrays with `FTS indexes missing — keyword search degraded`; **degraded**, not no dependencies |
| `gh issue list --state open --limit 100 --json number,title,url` | Exit 0; #364, #363, #349; no explicit Astra issue returned. Read-only; related #349 already noted in proposal |
| Register apply | Exit 0, session `23cc5095-3304-4174-ae35-24266881e988`; `flock` unavailable, existing PID-file guard active |
| Check apply | Exit 0; one documentary writer; researchers read only |
| Graph/index refresh and symbol mutations | Not performed; prohibited generated paths preserved, no code symbols changed |

## Validation evidence

Documentation package: **READY for documentary completion**. Consumer execution: **NOT READY**. Independent semantic review of the protocol, index and three templates found no blocking mismatch against D1–D9, the delta and task Acceptance clauses. The scenario matrix is a desk review, not trial evidence.

| Check | Result |
|---|---|
| Exact task gates 1.1, 2.1, 2.2, 2.3, 3.1, 3.2 extracted from tasks and executed with Bash | All six exit 0 |
| `npx openspec validate add-astra-orchestration-pilot --strict --no-interactive` | Exit 0; change valid |
| `npx openspec validate --all --strict --no-interactive` | Exit 0; 25 passed, 0 failed |
| `bash scripts/verify-task-patterns.sh` | Exit 0; all verifiable patterns valid, 0 skipped/warnings |
| `git diff --check` | Exit 0 |
| Local Markdown target and heading-fragment resolution | PASS; 45 local links across the five package files and this review |
| Representative consumer-copy layout | PASS; three template copies modeled in memory at `openspec/changes/consumer-pilot/evidence/astra-pilot/desk-fixture/`, six provenance placeholders replaced and resolved against the frozen source map; no hub-relative dependencies |
| Research archive-relocation fixture | PASS; modeled future relative reference resolves to moved research; original source map retains the historical reference |
| `git show HEAD:openspec/changes/evaluate-astra-orchestration-readiness/research.md` | Exit 0; historical source exists at actual HEAD, separately from the reviewed dirty research |

Copy/relocation fixtures are explicitly synthetic: `fixture.invalid`, a forty-zero revision token and archive date `2099-01-01` exist only in the in-memory check. They are not real publication URLs, commits or an archive action. No consumer repository or hub history was copied. Real consumer admission still requires accessible source pins containing the final reviewed package; no HTTP availability claim is made. Link verification used path resolution and heading-slug matching; fixture verification substituted all `HUB_*_PIN` values, checked source membership and preserved old/new source maps separately.

Validation harness corrections: the first Python subprocess invocation could not locate the PowerShell `bash` alias (WinError 2); executing the exact gates through the configured alias succeeded. The first copy-fixture assertion retained a placeholder name in its generated link label; replacing the fixture label resolved that harness error. Neither failure required a product/document change or is counted as a consumer trial.

Scope audit: this apply adds five package Markdown files and this review, and changes only task completion checkboxes in the existing tasks file. Pre-existing proposal/design/delta/research modifications and unrelated media remain preserved. No kit, MANIFEST, CI, current spec, runtime code, graph output or generated-agent file is changed by this apply; no checksum regeneration or release/version change is needed. No commit, archive or external write was performed. The lack of `flock` remains an explicit platform limitation, not a passed consumer concurrency gate.

## Reviewed artifact revisions

SHA-256 hashes below identify actual reviewed bytes at HEAD `861c20fd5ccaceb2215b895961d4d15bedcde2ac` plus working-tree content. The tasks input hash is captured before completion-checkbox updates; its requirement text remains unchanged. This review does not hash itself.

| Artifact | SHA-256 |
|---|---|
| `proposal.md` | `e7e485b6fc99e316e333758e27792c3acc0b63110bcb334959ba16fd3c923ce1` |
| `design.md` | `5387f21a67a8e2eb0b4042abeb389e002612942a9400dff9c8f2fa3847ff3dc9` |
| `tasks.md` before checkbox updates | `2c875aec41b3a4f689832e6667481ff5a776e12e413cedac80d1dad65e89788e` |
| `specs/sdd-astra-orchestration-pilot/spec.md` | `c35c22931e223184e81fdfe7f1cd5bcc0ade87d9b0fb566e9ca209df82973430` |
| `../evaluate-astra-orchestration-readiness/research.md` | `e21577e02d08de9461b8dcb8a0d8618a68712e26bf21d35d6db562fc5131adc1` |
| `doc/experiments/astra-orchestration-pilot.md` | `840ae64d46cfc11dd537b871f064496f400edeec540636206c99b2a81274099a` |
| `doc/experiments/README.md` | `53af4ab5481a610a9c7a096c549f3a9096442127da6f051e99de97f1920d9162` |
| `doc/experiments/templates/astra-pilot-decision.md` | `bb33ce1a372283e7a3b96bba76badf42aa6afd09730ce11a1dc9a35a587c413b` |
| `doc/experiments/templates/astra-pilot-registration.md` | `e9cb837ff5ce21351c781f6225d9b5be2da404474fcaf70683a3dccda667d8ba` |
| `doc/experiments/templates/astra-pilot-run.md` | `c5c7e6391169f337db7444714963a5b99c0ea1e35bfca7bb1ccea8ce1addfbcb` |

# Product validation plan

Status: **NOT READY** until required scenario, revision, tool and owner fields are complete. Template only; no product result is implied.

## Identity

| Field | Value |
|---|---|
| Plan ID / revision / date | unknown |
| Repository / profile / worktree | unknown |
| Change ID / proposal / tasks revision | unknown |
| Base revision / affected files or dirty-content hashes | unknown |
| Evidence directory | `openspec/changes/<change-id>/evidence/product-validation/<run-id>/` |
| Owner / reviewer / human approver, if any | unknown |
| Protocol provenance | unknown; pin the hub protocol/template revision when copied outside the hub |

## Scope

| Requirement / scenario | Task(s) | Changed behavior | Applicability | Expected observation | Method | Acceptance criterion | Owner |
|---|---|---|---|---|---|---|---|
| unknown | unknown | unknown | unknown | unknown | unknown | unknown | unknown |

Allowed applicability values: applicable, not applicable with reason, not run with reason. Runtime or UI methods are selected only when relevant. Documentation-only changes use semantic walkthroughs and mark browser/runtime checks not applicable with a reason.

## Deterministic gates

| Task | Gate command | Required before task completion | Notes |
|---|---|---|---|
| unknown | unknown | yes | unknown |

Structural Gate success alone does not establish semantic acceptance. A task can be completed only when its Gate passes and all required applicable scenarios have current passing evidence.

## Tool readiness and fallback

| Tool / source | Required for which scenario | Status and freshness | Failure or limitation | Selected fallback | Uncovered scope |
|---|---|---|---|---|---|
| unknown | unknown | unknown | unknown | unknown | unknown |

Follow session override -> configured CLI -> configured MCP -> capped configuration suggestion -> manual instructions. Do not silently install tools or assume success from unavailable/degraded automation.

## Performance registration

Complete this section before collecting any prospective performance comparison. For exploratory observations, mark this section not applicable and label later results exploratory.

| Field | Registered value |
|---|---|
| Comparison mode | prospective / exploratory only / not applicable |
| Metric(s) and unit(s) | unknown |
| Baseline identity | unknown |
| Candidate identity | unknown |
| Target / tolerance | unknown |
| Environment / device / browser / headless or visible | unknown |
| Warm-up / duration / repetitions | unknown |
| Stopping and exclusion policy | unknown |
| Randomness / seed policy | unknown |
| Cache and run-order policy | unknown |
| CPU/GPU/frame pacing/draw-call separation | unknown |

Missing registered values make performance acceptance inconclusive.

## Evidence retention

| Evidence kind | Durable receipt | Raw artifact location / digest / retention | Access limitation |
|---|---|---|---|
| unknown | unknown | unknown | unknown |

Do not fabricate missing raw material. Disclose gaps and limit claims.

## Completion rule

- [ ] Every required scenario has an owner, method and acceptance criterion.
- [ ] Not-applicable and not-run scenarios are justified.
- [ ] Required tools are available or the fallback and uncovered scope are explicit.
- [ ] Prospective performance comparisons have frozen measurement boundaries before collection.
- [ ] Evidence location is durable and revision-bound.
- [ ] The plan does not authorize deployment, Astra evaluation, consumer migration or new mandatory tooling.

Plan decision: **NOT READY**.
Decision owner/date/revision/evidence: unknown.

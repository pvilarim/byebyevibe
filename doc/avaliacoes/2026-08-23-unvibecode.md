# Evaluation: UnvibeCode — business workflow map + risk review (vs Graphify)

| Field | Value |
|-------|--------|
| **Date** | 2026-08-23 |
| **Evaluator** | Explore session `/opsx:explore` (Cloud Agent) |
| **Candidate** | [FinanceFlash/unvibecode](https://github.com/FinanceFlash/unvibecode) · PyPI [`unvibecode`](https://pypi.org/project/unvibecode/) **0.3.3** (internal package `shipreadyv2`) · Alphashots.ai |
| **Decision** | Deferred |
| **Scope** | Optional on-demand review for APP/HYBRID target repos — **not** sdd-kit payload; **not** a Graphify (or GitNexus) replacement |

## Executive summary

UnvibeCode turns a repository into (1) a connected code map + LLM context ZIP, (2) a **business workflow map**, and (3) optional **business risk findings**. It is **not** a knowledge-graph tool like Graphify; the code-map layer overlaps **GitNexus** more than Graphify. Live spike on a 5-file checkout demo (~48s): workflow reconstruction was useful; risk reporting was conservative (**0** reportable findings despite planted defects). **Deferred** for kit adoption because of license split (Apache-2.0 GitHub surface vs `LicenseRef-Proprietary` on PyPI), hosted code-context processing, and preview pricing that may become paid — while the unique business-workflow layer remains interesting for APP reviews.

## Problem it tried to solve

Explain multi-file business operations (checkout, booking, entitlements) to humans and LLMs, and surface evidence-backed business risks — a gap the SDD stack covers only indirectly (GitNexus = code impact; Graphify = concepts/docs; OpenSpec = intentional change).

## What was analyzed

- GitHub README + `docs/{HOW_IT_WORKS,DATA_PROCESSING,OUTPUTS,PUBLIC_PREVIEW,QUICKSTART}.md`, `LICENSE` (Apache-2.0), `prebuilt-workflow-paths/`, challenge doc.
- PyPI metadata for `unvibecode==0.3.3`: `License-Expression: LicenseRef-Proprietary`; depends on `openai`, `tree-sitter-language-pack`, etc.
- Installed wheel internals: thin `unvibecode` shim → `shipreadyv2` (`cli.py`, `customer_runner.py`, `engine_sources/*`).
- Live run: `python -m unvibecode review --repository /tmp/demo-checkout-shop` (synthetic Flask checkout with intentional idempotency / oversell / double-capture bugs).
- Prior overlap precedent: [`2026-08-02-code-review-graph.md`](./2026-08-02-code-review-graph.md) (discarded vs GitNexus).

### License and cost (verified)

| Surface | Finding | Source |
|---------|---------|--------|
| GitHub repo `LICENSE` | **Apache-2.0** | GitHub API `license.spdx_id` + `LICENSE` file |
| GitHub contents (CONTRIBUTING) | Public repo today is mainly **docs + workflow packs + quality tests** — not the full analysis product as the sole distribution | `.github/CONTRIBUTING.md` |
| PyPI `unvibecode` 0.3.3 | **`License-Expression: LicenseRef-Proprietary`** | Wheel `METADATA` |
| Customer price today | **No charge in public preview** — no activation key, no customer OpenAI key | `docs/PUBLIC_PREVIEW.md`, README |
| Future price | **Paid plans may be introduced** after demand/cost review; not an SLA | `docs/PUBLIC_PREVIEW.md` (“Usage controls, account-based access, or paid plans may be introduced…”) |

**Operator implication:** treat the *runnable product* (PyPI engine) as proprietary / vendor-controlled for redistribution and compliance; do not assume Apache-2.0 covers the analysis binary just because the GitHub marketing/docs repo shows that badge. Prefer copying only Apache-licensed `prebuilt-workflow-paths/` if a static checklist is needed without the CLI.

### Telemetry and data leaving the machine (verified)

| Kind | What happens | Phone-home? |
|------|----------------|-------------|
| Local “telemetry” in `customer_runner.py` | Writes **progress/status JSON** under `shipready_results/` (`write_json` / `write_customer_progress`). Comments call this telemetry; it is **local disk only**. | No |
| Product analytics SDKs | No PostHog / Segment / Mixpanel / Sentry client strings found in installed `shipreadyv2` sources. | N/A |
| Hosted business analysis | Structured code context for workflow + risk is sent to **`https://shipready-api.alphashots.ai/v1`**. CLI injects public preview token `unvibecode-public-preview-v1` as `OPENAI_API_KEY` and sets `OPENAI_BASE_URL` to that gateway (OpenAI SDK compatible). | **Yes** (required for workflow/risk lanes) |
| Fast lane (code map + ZIP) | Documented as local parse/graph/HTML/ZIP | Docs: local; spike completed map without blocking on findings |
| Operational metadata | Hosted service “may process request metadata” for reliability, security, abuse prevention | `docs/DATA_PROCESSING.md` |
| Spike observation | Pass 1 used hosted model id `gpt-5.4-mini` via their gateway (~45s LLM stage on demo) | Technical log from live run |

**Operator implication:** Connected Code Map can be valuable with less exposure; full Business Workflow / Risk Review **exfiltrates structured source context** to Alphashots’ hosted service. Unsuitable for regulated/proprietary repos without org approval. There is no documented offline mode for the business lanes.

### Live spike (observed)

| Metric | Result |
|--------|--------|
| Repo | Synthetic `demo-checkout-shop` (5 supported source files, ~1.1k estimated tokens) |
| Duration | ~48s end-to-end |
| Outputs | `01_connected_code_map_for_llm.html`, `complete_repository_context_for_llm.zip`, `02_business_workflow_map.html`, `03_business_risk_findings.html` |
| Workflows reconstructed | 3 — checkout orchestration; inventory reserve/release; order lifecycle |
| Risk selector | 5 candidates → **0 selected**; 2 investigation gaps (score 13/24 vs minimum 14); 3 rejected |
| Planted bugs | Oversell race, idempotency-key reuse with changed payload, capture without idempotency — **not** promoted to customer findings |

## Fit with the SDD stack

| Tool | Relation |
|------|----------|
| OpenSpec | Neutral — no change-artifact integration; packs could *inspire* specs but are not OpenSpec |
| GitNexus | **Partial overlap** on connected code (files/symbols/imports/calls). GitNexus remains the always-on code graph + MCP impact tools |
| Graphify | **Different job** — Graphify = knowledge/concept graph (docs + AST concepts, query/path/explain, local-first code AST). UnvibeCode = one-shot business review + LLM context packaging |
| AGENTS.md / sdd-kit | Adopting as always-on would add a third graph-ish tool, hosted dependency, and agent confusion. Packs-only copy is lower risk than CLI |

## Risks by workflow phase

| Phase | Risk | Notes |
|-------|------|-------|
| Explore | Tool-choice ambiguity vs Graphify/GitNexus | Frame as optional business review, not knowledge index |
| Propose | Hosted code egress | Do not run on secrets/regulated trees without approval |
| Apply | Stale one-shot reports; preview may gain paywalls | Not a substitute for `gitnexus_impact` / Probity |
| Archive | License drift PyPI vs GitHub | Re-check `License-Expression` before any kit mention |

## Expected vs observed gains

| Advertised gain | Assessment |
|-----------------|------------|
| Business workflow map for humans/LLMs | **Confirmed** on demo — clear entry→effects→outcome narrative with code refs |
| Critical business risk findings | **Weak on demo** — conservative evidence threshold; “no findings ≠ no defects” (also stated in their HTML) |
| Connected LLM context ZIP | **Confirmed** — chunks/connections/selections usable for later prompts |
| Replace Graphify | **No** — wrong layer |
| Free forever | **Uncertain** — free preview; paid plans explicitly contemplated |

## Alternatives already in the stack

- **Graphify** — concepts/docs/knowledge for agents (`graphify update` / query).
- **GitNexus** — code graph, blast radius, MCP tools for B/C/D.
- **correctness-review** (G7) — post-apply correctness skill.
- **Static option without CLI:** copy selected folders from Apache-licensed `prebuilt-workflow-paths/` (checklists + LLM skills) into an APP repo if domain packs are the only need.

## Decision and re-evaluation conditions

**Decision:** Deferred (do **not** add to `sdd-kit` / bootstrap / always-on AGENTS.md).

**Allowed informal use (outside kit):** operators may run the CLI on **authorized, non-sensitive APP** repos for workflow onboarding; prefer workflow map + ZIP over trusting empty risk reports.

**Conditions to reopen (toward Adopted as optional module or Discarded):**

1. License clarified in writing: one SPDX for GitHub **and** PyPI engine, or explicit dual-license FAQ.
2. Pricing: public preview remains free **or** a documented free tier suitable for SDD operators; if paid-only, prefer **Discarded** for kit.
3. Data: offline / customer-BYO-key mode for business review, or contractual DPA acceptable to hub consumers.
4. Evidence quality: spike on a real APP payment/booking codebase where risk findings demonstrate non-trivial true positives (beyond workflow narration).
5. Packs-only path: if only `prebuilt-workflow-paths/` is desired, evaluate as a **docs/content** module (no hosted dependency) under a separate change.

## References

- https://github.com/FinanceFlash/unvibecode
- https://pypi.org/project/unvibecode/ (0.3.3)
- https://github.com/FinanceFlash/unvibecode/blob/main/docs/DATA_PROCESSING.md
- https://github.com/FinanceFlash/unvibecode/blob/main/docs/PUBLIC_PREVIEW.md
- Hosted gateway observed in package: `https://shipready-api.alphashots.ai/v1`
- Stack comparison context: `doc/byebyevibe-guide.md` §2.4 (Graphify); [`2026-08-02-code-review-graph.md`](./2026-08-02-code-review-graph.md)
- Insertion methodology: `openspec/changes/explore-oss-coverage-gaps/metodologia-insercao.md`

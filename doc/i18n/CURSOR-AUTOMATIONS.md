# Cursor Automations — i18n translation waves

> Operator playbook for **ByeByeVibe** / this hub repo.  
> Capability: `sdd-docs-language` · Inventory: [`WAVES.md`](./WAVES.md) · Template: [`WAVE-PROPOSAL-TEMPLATE.md`](./WAVE-PROPOSAL-TEMPLATE.md) · Glossary: [`GLOSSARY.md`](./GLOSSARY.md)  
> Product docs (external): [Automations](https://cursor.com/docs/cloud-agent/automations) · [Cloud Agents](https://cursor.com/docs/cloud-agent) · UI: [cursor.com/automations](https://cursor.com/automations)

**How Automations use this file:** put the path in the Automation instructions, for example:

```text
Read and follow doc/i18n/CURSOR-AUTOMATIONS.md end-to-end.
Then execute ONLY the "Propose factory" section for the next pending disjoint slice.
```

The Cloud Agent clones the repo; if this file is on the branch/base the Automation uses (usually `master` after merge), the agent can open it like any other doc. You do **not** need the explore chat history.

---

## 1. What you are automating

PT→EN work is split into many OpenSpec changes:

| Pattern | Example |
|---------|---------|
| Change id | `translate-kit-wave-2c` |
| Phase order | explore (optional) → **propose** → **apply** → **archive** |
| Budget | ≤4 files **or** 1 skill × 2 mirrors; ≤350–400 LOC (`WAVES.md`) |
| Gates | `bash scripts/verify-i18n-wave.sh --files …` |

SDD rule: **one chat / one Cloud Agent run = one phase**. Do not propose and apply in the same run.

```
  ┌──────────────┐   Session Handoff    ┌──────────────┐   Handoff    ┌─────────────┐
  │ /opsx:propose │ ──────────────────▶ │ /opsx:apply   │ ──────────▶ │ /opsx:archive│
  │  (run A)      │   copy stub below    │  (run B)      │             │  (run C)     │
  └──────────────┘                      └──────────────┘             └─────────────┘
```

---

## 2. Manual merge — is it a blocker for all proposes?

**No.** Manual merge is **not** a blocker for generating proposes of **disjoint** waves.

| Situation | Blocked by unmerged PR? | What to do |
|-----------|-------------------------|------------|
| Propose wave B while propose PR for wave A is still open | **No**, if file slices do **not** overlap | Launch parallel Cloud Agents / Automations for B, C, D… |
| Propose wave B while A’s propose is unmerged but both touch the same files | **Yes** (conflict / double-own) | Wait or re-slice |
| **Apply** wave A | **Yes** (soft gate) | Apply agent needs `openspec/changes/<id>/` on its base — normally after propose PR is **merged** |
| Apply wave B that lists “after A apply+archive” (e.g. W2d after W2c) | **Yes** | Sequential: finish A apply(+archive) first |
| Archive | After apply PR merged (or apply landed on base) | Separate run |

```
  Propose A ──PR──▶ (await merge) ──▶ Apply A ──PR──▶ (await merge) ──▶ Archive A
  Propose B ──PR──▶ …                 (parallel OK if disjoint files)
  Propose C ──PR──▶ …
```

**Throughput:** manual merge slows the **apply chain**, not the **propose factory**.  
**Optional later (out of scope here):** GitHub auto-merge / merge queue for `docs(sdd): propose translate-*` only — reduces waiting; does not change SDD phases.

---

## 3. Cursor surfaces (when to use which)

| Surface | Best for | Notes |
|---------|----------|-------|
| [Cloud Agents](https://cursor.com/agents) / Desktop → Cloud | One-off propose or apply with a pasted Session Handoff | Isolated VM + branch; good for parallel proposes |
| [Automations](https://cursor.com/automations) | Recurring propose factory; apply-on-merge; cron inventory scan | Triggers: schedule, PR merged, label, webhook, Slack, … |
| `/multitask` (Agents Window) | Fire N independent proposes once | Still one phase each; do not multitask propose+apply of the same wave |
| Local chat + worktrees | Interactive apply with R11 locks | Cloud VMs are already isolated (CI/cloud exempt from local `.sdd/runtime` locks) |

Create Automations via UI, `/automate`, or [marketplace templates](https://cursor.com/marketplace/automations). This repo does **not** store Automation definitions (they live in Cursor’s product).

---

## 4. Recommended Automations for this repo

### 4.1 Propose factory (one wave per run)

**Trigger ideas:** cron (e.g. daily), Slack keyword, webhook, or manual “run now”.

**Repo:** this repository · **Base branch:** `master` (or your default).

**Hard exclusions (Propose factory):**

- **`doc/curso/**`** — out of language scope (human decision). Never invent `translate-curso-*`. Treat residual PT under `doc/curso/` as **not** a pending slice.
- Prefer **install-critical** slices first: canonical guide `doc/sistema-sdd-pedro.md` (mid-file section slices OK), then kit/hub install payloads still lacking a propose. Avoid low-value meta (Session Handoff stub chrome) while the guide still has residual PT.

**Instructions (paste into Automation UI — keep in sync with this section):**

```text
Read and follow doc/i18n/CURSOR-AUTOMATIONS.md end-to-end.
Then execute ONLY the "Propose factory" section (§4.1) for the next pending disjoint slice.

SINGLE SDD phase: /opsx:propose only. Do NOT apply. Do NOT archive.
Do NOT edit translation target files — only openspec/changes/<new-id>/.
Do NOT wait for previous propose PRs to be merged. Parallel disjoint proposes are allowed.

HARD EXCLUSIONS — never propose these surfaces:
- doc/curso/** (entire tree) — OUT of scope; do NOT create translate-curso-*
- openspec/changes/archive/**

PRIORITY order when choosing a slice:
1) doc/sistema-sdd-pedro.md (canonical install guide) — section-sized mid-file slices OK within LOC budget
2) Remaining install-critical kit/hub paths still without an owning translate-* propose
3) Other in-scope residual PT (avaliacoes, design, specs, …)
Skip low-value meta (e.g. only Session Handoff stub label tweaks) while the guide still has residual PT.

1. Read doc/i18n/WAVES.md, doc/i18n/WAVE-PROPOSAL-TEMPLATE.md, doc/i18n/GLOSSARY.md
2. Inventory residual Portuguese on in-scope surfaces only (WAVES.md). Skip archive/ and doc/curso/**
3. Owned paths = union of:
   a) path lists in active openspec/changes/translate-*/ on current base
   b) path lists in OPEN GitHub PRs/branches for translate-* proposes (gh pr list) — even if unmerged
4. Pick ONE disjoint slice not in owned set (≤4 files or 1 skill×2 mirrors; ≤350–400 LOC)
5. /opsx:propose translate-<surface>-wave-N from WAVE-PROPOSAL-TEMPLATE.md; English only (F7)
6. Open a DRAFT PR for propose artifacts only
7. Stop with ## Session Handoff for /opsx:apply (do not start apply)

Idle / stop condition:
- If no remaining disjoint residual-PT slice exists (after exclusions), open no PR and report:
  "Propose factory idle: no remaining disjoint translate slices."
- Leaving the Automation enabled is fine; future runs should keep no-op'ing until new scope appears.
```

### 4.2 Apply after propose merge

**Trigger ideas:** Pull request **merged** whose branch/title matches `translate-*-propose` / `docs(sdd): propose translate-`, or label `sdd-i18n-propose-ready`.

**Instructions (paste):**

```text
You are running a SINGLE SDD phase: /opsx:apply only for one translation wave.

1. Read doc/i18n/CURSOR-AUTOMATIONS.md
2. Identify change-id translate-<surface>-wave-N from the merged propose PR
3. Confirm openspec/changes/<id>/ exists on the current base with tasks.md unchecked
4. If tasks.md lists a prerequisite wave, confirm that prerequisite is apply-complete (prefer archived); else stop with Session Handoff naming the prerequisite
5. /opsx:apply <id> — in-place PT→EN only; freeze-list intact; no dual-file *.en.md / *-pt.md
6. If sdd-kit/templates/ touched: bash sdd-kit/gen-manifest-checksums.sh
7. Gate: bash scripts/verify-i18n-wave.sh --files <exact paths from proposal>
8. OPENSPEC_TELEMETRY=0 npx --yes @fission-ai/openspec@1.3.1 validate --all --strict
9. Open DRAFT PR for the apply. Stop with Session Handoff for /opsx:archive
Do NOT propose a new wave in this run. Do NOT merge PRs yourself.
```

### 4.3 Archive after apply merge

Same pattern: trigger on apply PR merged → `/opsx:archive <id>` only → small PR moving change to `openspec/changes/archive/`.

### 4.4 What NOT to put in one Automation

- Propose + apply + archive in a single run  
- “Translate the entire guide in one PR” (violates budgets)  
- Auto-approve or auto-merge without human review (R7)  
- Secrets, tokens, or Cursor API keys in repo files  

---

## 5. Parallel proposes — checklist

Before launching N Cloud Agents:

1. **Slice list** — explicit paths per wave; no path in two slices  
2. **Active changes** — `npx openspec list` / `openspec/changes/translate-*`  
3. **Kit checksums** — only one in-flight apply should touch `sdd-kit/templates/` + `MANIFEST.yaml` at a time (proposes that only add OpenSpec artifacts are fine in parallel)  
4. **Skills** — one logical skill × both mirrors per wave (`WAVES.md`)  
5. **Prompt** — each agent gets one change-id and one path list  

---

## 6. Session Handoff stubs (copy)

### Propose → Apply

```text
## Session Handoff

/opsx:apply translate-<surface>-wave-N

Change: openspec/changes/translate-<surface>-wave-N/
Read: proposal.md, design.md, tasks.md, doc/i18n/GLOSSARY.md, doc/i18n/WAVES.md, doc/i18n/CURSOR-AUTOMATIONS.md
Gate: bash scripts/verify-i18n-wave.sh --files <paths>
Infra: openspec/infra.md (assume ✅ — do not reinstall)
```

### Apply → Archive

```text
## Session Handoff

/opsx:archive translate-<surface>-wave-N

Change: openspec/changes/translate-<surface>-wave-N/
Read: tasks.md (all checked), doc/i18n/CURSOR-AUTOMATIONS.md
Infra: openspec/infra.md (assume ✅ — do not reinstall)
```

---

## 7. Current queue hint (translation)

Operators should re-check `npx openspec list` and open PRs; typical pattern:

| Stage | Action |
|-------|--------|
| Propose already merged, tasks open | Run **Apply** Automation / Cloud Agent (§4.2) |
| Need more waves (guide sections first; then kit/design/avaliacoes — **not** `doc/curso/`) | Run **Propose factory** (§4.1) in parallel for disjoint slices |
| Dependent pair (e.g. W2c then W2d) | Apply sequentially; do not parallelize those applies |

---

## 8. Quality bar before opening a PR

| Check | Command / rule |
|-------|----------------|
| Wave gates | `bash scripts/verify-i18n-wave.sh --files …` |
| OpenSpec | `OPENSPEC_TELEMETRY=0 npx --yes @fission-ai/openspec@1.3.1 validate --all --strict` |
| Kit templates | `bash sdd-kit/gen-manifest-checksums.sh` then `bash sdd-kit/verify.sh` |
| Language | English versioned artifacts (F7); chat MAY be pt-BR |
| Phase | Single `/opsx:*` phase per run |

**G-SMOKE** remains advisory/human (`WAVES.md`).

---

## 9. FAQ

**Can I call this documentation from Automations to develop the workflow there?**  
Yes. After this file is on the branch the Automation uses, instructions like “Read `doc/i18n/CURSOR-AUTOMATIONS.md` and execute §4.1” are enough. Iterate the Automation prompt in the Cursor UI; improve this file via a normal OpenSpec change when the playbook itself changes.

**Must every propose wait for the previous PR to merge?**  
No — only when slices overlap or when you are in **apply**/dependent-apply. See §2.

**Can one Automation create all remaining proposes in one run?**  
Prefer **one wave per run** (budgets + review). If you batch, still emit separate change-ids and separate PRs, and never apply in the same run.

**Does R11 session lock block Cloud Automations?**  
Local apply locks apply to persistent local worktrees. Ephemeral Cloud/CI agents are exempt from `.sdd/runtime` persistence; still use one apply per wave and avoid two applies editing the same paths on colliding branches.

---

## 10. Sources

1. `doc/i18n/WAVES.md` — budgets, order, gates  
2. `doc/i18n/WAVE-PROPOSAL-TEMPLATE.md` — propose shape  
3. `.cursor/rules/015-session-phases.mdc` — one phase per session  
4. `doc/sistema-sdd-pedro.md` §3.3 — parallel worktrees / coordination  
5. `openspec/specs/sdd-docs-language/spec.md` — normative language capability  
6. https://cursor.com/docs/cloud-agent/automations — product triggers/tools  

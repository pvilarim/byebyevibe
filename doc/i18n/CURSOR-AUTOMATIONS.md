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
Use **GitHub auto-merge** on apply/archive PRs (branch protection + green CI) to reduce waiting without combining SDD phases in one agent run.

---

## 3. Automation chain (recommended layout)

Run **three separate Automations** — never combine phases in one run (§5.4).

| Automation | Trigger (GitHub) | Phase | Opens PR? | Merge? |
|------------|------------------|-------|-----------|--------|
| **A — Propose factory** | Cron / manual | `/opsx:propose` | Draft propose PR | Human or auto-merge |
| **B — Apply on propose merge** | PR merged → title matches `propose translate-*` | `/opsx:apply` | Draft apply PR | Human or auto-merge |
| **B-guide — Guide apply chain** | PR merged → title matches `apply translate-guide-wave-` | `/opsx:apply` next wave (§5.2.1) | Ready apply PR | Agent merges (chain) |
| **C — Archive on apply merge** | PR merged → title matches `apply translate-*` | `/opsx:archive` | Ready archive PR | Auto-merge or agent (§5.3) |

```
  Propose PR merged ──▶ Automation B (apply) ──▶ Apply PR merged ──▶ Automation C (archive+merge)
        ▲                                                              │
        │                                                              ▼
   Automation A                                              change → archive/
   (parallel OK)                                            master updated
```

**Before re-enabling B or C:** close stale duplicate archive PRs (§5.3.1). They do not need merge — the change is often already on `master`.

---

## 4. Cursor surfaces (when to use which)

| Surface | Best for | Notes |
|---------|----------|-------|
| [Cloud Agents](https://cursor.com/agents) / Desktop → Cloud | One-off propose or apply with a pasted Session Handoff | Isolated VM + branch; good for parallel proposes |
| [Automations](https://cursor.com/automations) | Recurring propose factory; apply-on-merge; cron inventory scan | Triggers: schedule, PR merged, label, webhook, Slack, … |
| `/multitask` (Agents Window) | Fire N independent proposes once | Still one phase each; do not multitask propose+apply of the same wave |
| Local chat + worktrees | Interactive apply with R11 locks | Cloud VMs are already isolated (CI/cloud exempt from local `.sdd/runtime` locks) |

Create Automations via UI, `/automate`, or [marketplace templates](https://cursor.com/marketplace/automations). This repo does **not** store Automation definitions (they live in Cursor’s product).

---

## 5. Recommended Automations for this repo

### 5.1 Propose factory (one wave per run)

**Trigger ideas:** cron (e.g. daily), Slack keyword, webhook, or manual “run now”.

**Repo:** this repository · **Base branch:** `master` (or your default).

**Hard exclusions (Propose factory):**

- **`doc/curso/**`** — out of language scope (human decision). Never invent `translate-curso-*`. Treat residual PT under `doc/curso/` as **not** a pending slice.
- Prefer **install-critical** slices first: canonical guide `doc/byebyevibe-guide.md` (mid-file section slices OK), then kit/hub install payloads still lacking a propose. Avoid low-value meta (Session Handoff stub chrome) while the guide still has residual PT.

**Instructions (paste into Automation UI — keep in sync with this section):**

```text
Read and follow doc/i18n/CURSOR-AUTOMATIONS.md end-to-end.
Then execute ONLY the "Propose factory" section (§5.1) for the next pending disjoint slice.

SINGLE SDD phase: /opsx:propose only. Do NOT apply. Do NOT archive.
Do NOT edit translation target files — only openspec/changes/<new-id>/.
Do NOT wait for previous propose PRs to be merged. Parallel disjoint proposes are allowed.

HARD EXCLUSIONS — never propose these surfaces:
- doc/curso/** (entire tree) — OUT of scope; do NOT create translate-curso-*
- openspec/changes/archive/**

PRIORITY order when choosing a slice:
1) doc/byebyevibe-guide.md (canonical install guide) — section-sized mid-file slices OK within LOC budget
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

### 5.2 Apply after propose merge (Automation B)

**Purpose:** run `/opsx:apply` for exactly one `translate-*` wave after its propose PR landed on `master`.

**Repo / base:** this repository · `master`

**Trigger (pick one in Cursor Automations UI):**

| Trigger type | Suggested filter |
|--------------|------------------|
| Pull request merged | Base: `master` · Title contains: `propose translate-` **or** branch contains: `translate-` |
| Label (alternative) | Label added: `sdd-i18n-propose-ready` on merged PR |

**Branch naming (agent):** `cursor/apply-<change-id>-<suffix>` (e.g. `cursor/apply-translate-guide-wave-2-e452`)

**PR title:** `docs(sdd): apply translate-<surface>-wave-N`

**Merge policy:** open as **DRAFT**; enable **GitHub auto-merge** on the apply PR if branch protection allows. The apply agent MUST NOT merge its own PR (archive automation depends on a clean merge event).

**Operator checklist before enabling (generic §5.2 only — guide uses §5.2.1):**

1. Propose PR for the wave is **merged** on `master`
2. `openspec/changes/<id>/` exists on `master` with open tasks
3. Prerequisite waves (if any in `tasks.md`) are apply-complete — prefer **archived**
4. No other in-flight apply PR touches the same file paths

**Instructions (paste into Automation B — generic):**

```text
Read and follow doc/i18n/CURSOR-AUTOMATIONS.md end-to-end.
Then execute ONLY §5.2 "Apply after propose merge" for the wave that triggered this run.

SINGLE SDD phase: /opsx:apply only. Do NOT propose. Do NOT archive. Do NOT merge PRs.

IDENTIFY change-id:
1. From the merged propose PR title/body (e.g. translate-guide-wave-2), or
2. From the Automation trigger payload (merged PR metadata).
Set CHANGE_ID=translate-<surface>-wave-N.

PRE-FLIGHT (stop with Session Handoff if any check fails):
- test -d "openspec/changes/${CHANGE_ID}" || STOP "change folder missing on master — propose not merged?"
- test ! -d "openspec/changes/archive/"*"${CHANGE_ID}" || STOP "already archived"
- Count incomplete tasks: grep -c '^- \[ \]' openspec/changes/${CHANGE_ID}/tasks.md
  If prerequisite wave named in tasks.md: confirm prerequisite is archived on master
- gh pr list --state open --search "apply ${CHANGE_ID}" --json number
  If open apply PR exists for same change-id: STOP "duplicate apply PR — do not start second apply"

APPLY:
1. Read proposal.md, design.md, tasks.md, doc/i18n/GLOSSARY.md, doc/i18n/WAVES.md
2. /opsx:apply ${CHANGE_ID} — in-place PT→EN only on paths listed in proposal/tasks
3. Freeze-list / HTML marker tags / pins / SHA pins — byte-stable per tasks.md
4. Forbidden: dual-file *.en.md / *-pt.md; editing openspec/changes/archive/**
5. If sdd-kit/templates/ touched: bash sdd-kit/gen-manifest-checksums.sh

GATES (must pass before PR):
- bash scripts/verify-i18n-wave.sh --files <exact paths from proposal/tasks>
- OPENSPEC_TELEMETRY=0 npx --yes @fission-ai/openspec@1.3.1 validate --all --strict

PR:
- Branch: cursor/apply-${CHANGE_ID}-<short-suffix>
- Title: docs(sdd): apply ${CHANGE_ID}
- Body: list translated paths + gate commands run
- Open as DRAFT
- Do NOT merge

STOP with Session Handoff for /opsx:archive (§6).
```

### 5.2.1 Guide apply chain (Automation B-guide) — sequential `translate-guide-wave-*`

**Purpose:** after each **guide** apply PR merges on `master`, automatically run `/opsx:apply` for the **next** pending `translate-guide-wave-N` (waves share `doc/byebyevibe-guide.md` — **never** parallelize guide applies).

**When to use:** guide waves **5–14** (and any future `translate-guide-wave-*` with open tasks). Propose factory (§5.1) already created the changes; this chain only runs **apply**.

**Repo / base:** this repository · `master`

**Trigger (Cursor Automations UI):**

| Trigger type | Filter |
|--------------|--------|
| **Pull request merged** | Base: `master` · Title contains: `apply translate-guide-wave-` |
| Manual / cron (fallback) | Daily or “Run now” if the chain stalled after a merge |

**Do not** use the generic §5.2 trigger (`propose translate-`) for this chain — guide proposes are already merged.

**Queue helper (repo):**

```bash
bash scripts/translate-guide-next-wave.sh          # human-readable
bash scripts/translate-guide-next-wave.sh --json   # machine-readable
```

Exit `0` → next wave to apply. Exit `1` → idle (no open guide apply waves).

**Branch naming:** `cursor/apply-<change-id>-ee2e` (e.g. `cursor/apply-translate-guide-wave-5-ee2e`)

**PR title:** `docs(sdd): apply translate-guide-wave-N`

**Merge policy (this chain):** open PR **ready for review** (not draft). After gates pass locally, **merge the apply PR in the same run** (`gh pr merge`) so the next automation trigger fires. Operator may enable GitHub auto-merge instead.

**Instructions (paste into Automation B-guide):**

```text
Read and follow doc/i18n/CURSOR-AUTOMATIONS.md end-to-end.
Then execute ONLY §5.2.1 "Guide apply chain" — ONE guide apply per run.

SINGLE SDD phase: /opsx:apply only. Do NOT propose. Do NOT archive in this run.

QUEUE (mandatory first step):
  eval "$(bash scripts/translate-guide-next-wave.sh)"
  # Sets CHANGE_ID, WAVE, SLICE, GATE, INCOMPLETE_TASKS
  # If script exits 1: report "Guide apply chain idle" and STOP (no PR).

PRE-FLIGHT (stop with message if any fails):
- test -d "openspec/changes/${CHANGE_ID}"
- test "${INCOMPLETE_TASKS}" -gt 0
- gh pr list --state open --search "apply ${CHANGE_ID}" --json number -q 'length' | grep -q '^0$' || STOP "duplicate apply PR"
- Confirm prior guide waves on lower N are apply-complete (tasks all [x]) or archived

APPLY:
1. git checkout master && git pull origin master
2. git checkout -b "cursor/apply-${CHANGE_ID}-ee2e"
3. Read proposal.md, design.md, tasks.md, doc/i18n/GLOSSARY.md
4. /opsx:apply ${CHANGE_ID} — PT→EN in-place ONLY on doc/byebyevibe-guide.md lines in SLICE
5. Forbidden: dual-file *.en.md / *-pt.md; edits outside SLICE; openspec/changes/archive/**

GATES (must pass; use SLICE from script):
- ${GATE}
- bash scripts/verify-task-patterns.sh
- OPENSPEC_TELEMETRY=0 npx --yes @fission-ai/openspec@1.3.1 validate ${CHANGE_ID} --strict

PR + MERGE:
- git commit -m "docs(sdd): apply ${CHANGE_ID}"
- git push -u origin "cursor/apply-${CHANGE_ID}-ee2e"
- gh pr create --base master --title "docs(sdd): apply ${CHANGE_ID}" --body "Slice ${SLICE} of doc/byebyevibe-guide.md. Gate: ${GATE}"
- gh pr ready <number>
- gh pr merge <number> --merge --delete-branch

STOP with one line:
  "Guide apply chain: merged ${CHANGE_ID}. Next run should pick translate-guide-wave-$((WAVE+1)) via translate-guide-next-wave.sh"
```

**Operator setup checklist:**

1. Create Automation **B-guide** at [cursor.com/automations](https://cursor.com/automations) with trigger **PR merged** → title `apply translate-guide-wave-`.
2. Paste §5.2.1 instructions above into the Automation prompt.
3. Ensure `master` includes `scripts/translate-guide-next-wave.sh` (merge this doc/script PR first).
4. Optional: enable **Automation C** (§5.3) on the same trigger pattern to archive each wave after apply merge.
5. Close stale duplicate archive PRs (§5.3.1) before enabling C.

```
  apply guide-wave-N merged ──▶ Automation B-guide ──▶ apply wave-N+1 ──merge──▶ (re-triggers)
                         └──▶ Automation C (optional) ──▶ archive wave-N
```

### 5.3 Archive after apply merge (Automation C)

**Purpose:** run `/opsx:archive` for exactly one `translate-*` wave after its apply PR landed on `master`, then merge the archive PR when safe.

**Repo / base:** this repository · `master`

**Trigger (pick one):**

| Trigger type | Suggested filter |
|--------------|------------------|
| Pull request merged | Base: `master` · Title contains: `apply translate-` |
| Label (alternative) | Label added: `sdd-i18n-apply-ready` on merged PR |

**Branch naming (agent):** `cursor/archive-<change-id>-e452` — the suffix MUST be the fixed literal `e452`, matching `scripts/archive-and-merge.sh`. Do **not** use a per-run random suffix: the dedupe guard below looks the branch up by name, so a fresh suffix each run defeats it and opens a duplicate PR (see §5.3.1).

**PR title:** `chore(openspec): archive translate-<surface>-wave-N`

**Merge policy:** open as **ready for review** (not draft). Prefer **GitHub auto-merge** when CI is green. If auto-merge is unavailable, the agent MAY merge when: PR is mergeable, no duplicate open archive PR exists, and `openspec validate --all --strict` passed on the branch.

**Operator helper (local):** `bash scripts/archive-and-merge.sh <change-id>` prepares branch + push; PR creation may still need Cursor UI or a token with `pull_request` write scope.

#### 5.3.1 Stale archive PRs — close, do not merge

Repeated Cloud Agent runs open **duplicate** archive PRs for the same change-id. Root cause (confirmed 2026-08-05 against PRs #202–#223): the runs are **serial, ~5 minutes apart**, not parallel — each one passed the old `--search`-based dedupe because the GitHub search index had not yet listed the PR the previous run created. The 5-minute cadence outran the index. Fixed by looking the branch up with `--head` and pinning the branch suffix (§5.3, §5.3.2).

Before Automation C runs:

```bash
# List open archive PRs for one change — --head is immediately consistent
gh pr list --head "cursor/archive-translate-guide-wave-2-e452" --state open

# Broader sweep (search index may lag by minutes — treat empty as inconclusive)
gh pr list --state open --search "archive translate-guide-wave-2"
```

| Signal | Action |
|--------|--------|
| Change already under `openspec/changes/archive/*-<id>/` on `master` | **Close** all open archive PRs for that id — work is done |
| Multiple open archive PRs for same id | **Close** duplicates; keep zero or one |
| PR is `CONFLICTING` / `DIRTY` but change archived on master | **Close** — superseded |

Bulk-close stale duplicates (operator, after verifying master):

```bash
# Historical backlog — CLOSED 2026-08-05, kept for provenance. Do not re-run.
# 28 PRs, each verified line-by-line against master before closing.
# gh pr close 52 53 56 65 178 180 202 203 204 205 206 207 208 209 210 211 \
#             212 213 214 215 216 217 218 219 220 221 222 223
```

> **#17 is deliberately NOT in that list.** An earlier revision of this section listed it. `#17` (`archive add-sdd-ui-development-module`) is the one archive PR in the batch that also carries **live-spec deltas that never landed on `master`**: `openspec/infra.md` really does have a `## UI Development Module` section and the guide really does have `§2.11.1`, but no requirement in `openspec/specs/**` mandates either. Verify before closing it — see change `sync-ui-module-spec-requirements`.

**Verify before closing, every time.** The archive-move check alone is not sufficient — an archive PR can have its move already on `master` while its `openspec/specs/**` deltas never landed (`#17` is exactly that). For each candidate:

```bash
# 1. archive move already on master?  (mind the DATE prefix — it may differ from the PR's)
git ls-tree origin/master --name-only openspec/changes/archive/ | grep -i "<change-id>"

# 2. every requirement the PR adds under openspec/specs/** already on master?
#    Compare requirement BODIES, not headings: headings get reworded, and the
#    translate-* waves rewrote many bodies from pt-BR to English.
git show origin/master:openspec/specs/<capability>/spec.md | grep -c "<distinctive phrase>"
```

#### 5.3.2 Instructions (paste into Automation C)

```text
Read and follow doc/i18n/CURSOR-AUTOMATIONS.md end-to-end.
Then execute ONLY §5.3 "Archive after apply merge" for the wave that triggered this run.

SINGLE SDD phase: /opsx:archive only. Do NOT propose. Do NOT apply.

IDENTIFY change-id from merged apply PR (e.g. translate-guide-wave-2).
Set CHANGE_ID=translate-<surface>-wave-N.

PRE-FLIGHT — DEDUPE (mandatory; exit 0 with message, no PR):
1. Already archived on master?
   If openspec/changes/${CHANGE_ID} is missing AND
      ls openspec/changes/archive/*${CHANGE_ID}* 2>/dev/null | grep -q .
   → Report "SKIP: ${CHANGE_ID} already archived on master" and STOP.

2. Duplicate open archive PR?
   Look the branch up by name — NOT via --search. The GitHub search index is
   eventually consistent, so a just-created PR is often still invisible to
   --search minutes later; a repeating trigger then opens a duplicate every run.
   --head resolves the ref directly and is immediately consistent.
   OPEN=$(gh pr list --head "cursor/archive-${CHANGE_ID}-e452" --state open --json number -q 'length')
   If OPEN > 0 → Report "SKIP: archive PR already open for ${CHANGE_ID}" and STOP.

3. Tasks complete?
   INCOMPLETE=$(grep -c '^- \[ \]' openspec/changes/${CHANGE_ID}/tasks.md || echo 99)
   If INCOMPLETE > 0 → STOP with Session Handoff "tasks incomplete — finish apply first"

4. Apply landed on master?
   test -d "openspec/changes/${CHANGE_ID}" || STOP "change folder missing"

ARCHIVE:
1. Read tasks.md, design.md; sync any remaining delta specs to openspec/specs/ per tasks.md promotion section
2. Move openspec/changes/${CHANGE_ID} → openspec/changes/archive/$(date +%Y-%m-%d)-${CHANGE_ID}/
   (if target exists, STOP — do not double-archive)
3. OPENSPEC_TELEMETRY=0 npx --yes @fission-ai/openspec@1.3.1 validate --all --strict
4. Optional: bash scripts/sdd-metrics.sh --check-cadence (advisory; never fail archive)

PR:
- Branch: cursor/archive-${CHANGE_ID}-e452
- Title: chore(openspec): archive ${CHANGE_ID}
- Body: archive path + validate command + "one archive PR per change-id"
- Mark ready for review (not draft)

MERGE (only if all true):
- No other open archive PR for this CHANGE_ID
- PR mergeable (CLEAN) and CI green, OR GitHub auto-merge enabled
- If gh pr merge fails (permissions): leave PR open and report URL for human merge
- After merge: delete branch

FORBIDDEN:
- Creating a second archive PR for the same CHANGE_ID in the same run
- Merging when master already contains archive/*-${CHANGE_ID}
- apply or propose in this run
```

### 5.4 What NOT to put in one Automation

- Propose + apply + archive in a single run  
- “Translate the entire guide in one PR” (violates budgets)  
- Multiple archive PRs for the same `change-id` without dedupe (§5.3.1)  
- Secrets, tokens, or Cursor API keys in repo files  

**R7 note:** auto-merge on apply/archive PRs is acceptable when branch protection + CI gates enforce review; it does not replace OpenSpec propose review for type C/D work — translation waves are operational batches with pre-defined tasks.

---

## 6. Parallel proposes — checklist

Before launching N Cloud Agents:

1. **Slice list** — explicit paths per wave; no path in two slices  
2. **Active changes** — `npx openspec list` / `openspec/changes/translate-*`  
3. **Kit checksums** — only one in-flight apply should touch `sdd-kit/templates/` + `MANIFEST.yaml` at a time (proposes that only add OpenSpec artifacts are fine in parallel)  
4. **Skills** — one logical skill × both mirrors per wave (`WAVES.md`)  
5. **Prompt** — each agent gets one change-id and one path list  

---

## 7. Session Handoff stubs (copy)

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

## 8. Current queue hint (translation)

Operators should re-check `npx openspec list` and open PRs; typical pattern:

| Stage | Action |
|-------|--------|
| Guide apply chain (waves 5–14) | **Automation B-guide** (§5.2.1) on each `apply translate-guide-wave-*` merge; kickstart with manual Run if wave-4 already merged |
| Propose already merged, tasks open (non-guide) | Run **Apply** Automation B (§5.2) |
| Apply PR merged, tasks all checked | Run **Archive** Automation C (§5.3) |
| Need more waves (guide sections first; then kit/design/avaliacoes — **not** `doc/curso/`) | Run **Propose factory** (§4.1) in parallel for disjoint slices |
| Dependent pair (e.g. W2c then W2d) | Apply sequentially; do not parallelize those applies |

---

## 9. Quality bar before opening a PR

| Check | Command / rule |
|-------|----------------|
| Wave gates | `bash scripts/verify-i18n-wave.sh --files …` |
| OpenSpec | `OPENSPEC_TELEMETRY=0 npx --yes @fission-ai/openspec@1.3.1 validate --all --strict` |
| Kit templates | `bash sdd-kit/gen-manifest-checksums.sh` then `bash sdd-kit/verify.sh` |
| Language | English versioned artifacts (F7); chat MAY be pt-BR |
| Phase | Single `/opsx:*` phase per run |

**G-SMOKE** remains advisory/human (`WAVES.md`).

---

## 10. FAQ

**Can I call this documentation from Automations to develop the workflow there?**  
Yes. After this file is on the branch the Automation uses, instructions like “Read `doc/i18n/CURSOR-AUTOMATIONS.md` and execute §5.1” are enough. Iterate the Automation prompt in the Cursor UI; improve this file via a normal OpenSpec change when the playbook itself changes.

**Can apply and archive run in one Automation?**  
No — keep **Automation B** (apply) and **Automation C** (archive) separate. Chain them with GitHub “PR merged” triggers. Combining phases violates `.cursor/rules/015-session-phases.mdc` and caused duplicate archive PRs in practice.

**Why are there many open archive PRs for the same wave?**  
Parallel Cloud Agents each opened an archive PR before any merged. Close stale duplicates (§5.3.1); do not merge them if `master` already has `openspec/changes/archive/*-<id>/`.

**Should the archive Automation merge its own PR?**  
Prefer **GitHub auto-merge** when CI is green. The agent may merge only after dedupe checks (§5.3.2). If the integration token lacks permission, leave the PR open for human merge.

**Must every propose wait for the previous PR to merge?**  
No — only when slices overlap or when you are in **apply**/dependent-apply. See §2.

**Can one Automation create all remaining proposes in one run?**  
Prefer **one wave per run** (budgets + review). If you batch, still emit separate change-ids and separate PRs, and never apply in the same run.

**Does R11 session lock block Cloud Automations?**  
Local apply locks apply to persistent local worktrees. Ephemeral Cloud/CI agents are exempt from `.sdd/runtime` persistence; still use one apply per wave and avoid two applies editing the same paths on colliding branches.

---

## 11. Sources

1. `doc/i18n/WAVES.md` — budgets, order, gates  
2. `doc/i18n/WAVE-PROPOSAL-TEMPLATE.md` — propose shape  
3. `.cursor/rules/015-session-phases.mdc` — one phase per session  
4. `doc/byebyevibe-guide.md` §3.3 — parallel worktrees / coordination  
5. `openspec/specs/sdd-docs-language/spec.md` — normative language capability  
6. `scripts/archive-and-merge.sh` — local helper for archive branch + push  
7. https://cursor.com/docs/cloud-agent/automations — product triggers/tools  

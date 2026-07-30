# Design — Supply chain gates (G8: Renovate + OSV-Scanner)

## Context

- Type E research `explore-oss-coverage-gaps` (2026-07-25), gap **G8**: rule to "check advisories" without tooling; no automated updates or CI scanning.
- `metodologia-insercao.md` Phases 0–3: 6-point contract, mode **A** (automatic out-of-band) for OSV and Renovate; G1 MUST precede G8; OSV/Renovate independent of A–E classification.
- `doc/avaliacoes/2026-07-25-oss-coverage-gaps-tooling.md`: G8 **Adopted (pending change)**.
- G1 implemented: `.github/workflows/sdd-gates.yml` + mirror template; decisions D1–D11 in `openspec/changes/archive/2026-07-26-add-sdd-ci-gates-workflow/design.md`.
- This repo (DOCS_SPECS hub): OSV only if lockfile at repo root; Renovate **SKIP**.
- Rule 050: actions pinned by SHA; `permissions: contents: read`; no secrets in workflow.

### Phase 0 verification summary

| # | Verification | Result |
|---|--------------|--------|
| V1 | Already evaluated? | Yes — `doc/avaliacoes/2026-07-25-oss-coverage-gaps-tooling.md` G8 Adopted (pending) |
| V2 | Surface | Mode A — CI + scheduled bot; no new hook (avoids C3 overlap with pre-commit/Lefthook) |
| V3 | Collision | None with graphify/gitnexus hooks |
| V4 | Profile | APP / DOCS_SPECS / HYBRID matrix (install.sh) |
| F1 | Security | OSV action SHA-pinned; Renovate app = manual activation, no tokens in repo |
| F2 | License | OSV Apache 2.0; Renovate AGPL-3.0 — use as tool OK, no modified fork redistribution |
| F3 | Governance | OSV Google v2.3.8+; Renovate Mend, daily releases |
| F4 | Reversibility | Remove OSV step / `renovate.json` template disables gates |
| F5 | Operability | OSV on/off via workflow; Renovate via GitHub app + `renovate.json` |

## Goals / Non-Goals

**Goals:**

- Integrate **OSV-Scanner** as a fail-closed gate in `sdd-gates.yml` when a lockfile is present.
- Distribute **Renovate** (conservative `renovate.json`) via `sdd-kit` for APP/HYBRID.
- Profile matrix in `install.sh` (V4); MANIFEST bump 1.4.0 → **1.5.0**.
- Full registration in the 6-point contract (R1–R6); delta specs `sdd-supply-chain` + `sdd-ci-gates`.
- Compatibility with G1 D1–D11; documented rollback plan.
- Pilot optional for OSV (methodology Phase 2 exception — CI step + template only).

**Non-Goals:**

- Replace human review on Renovate major updates.
- Default automerge on majors.
- Install GitHub Renovate app via script (tokens) — documentation only `[MANUAL ACTION REQUIRED]`.
- Renovate on DOCS_SPECS profile (no app, no default `renovate.json`).
- Third git hook manager for scanning (pre-commit/Lefthook).
- Dedicated OSV workflow if integration in `sdd-gates` is sufficient (see D1).
- Integrate PR-Agent (G7 phase 2) in this change — re-evaluate workflow composition later.

## Knowledge sources consulted (R8)

- `openspec/changes/explore-oss-coverage-gaps/research.md` §G8 — Renovate + OSV-Scanner, templates by profile
- `openspec/changes/explore-oss-coverage-gaps/metodologia-insercao.md` — Phases 0–3, 6-point contract, mode A, G1→G8 dependency, A–E matrix
- `doc/avaliacoes/2026-07-25-oss-coverage-gaps-tooling.md` — G8 Adopted (pending)
- `.github/workflows/sdd-gates.yml`, `sdd-kit/templates/.github/workflows/sdd-gates.yml` — current G1 workflow
- `openspec/changes/archive/2026-07-26-add-sdd-ci-gates-workflow/design.md` — D1–D11
- `openspec/specs/sdd-ci-gates/spec.md` — requirements to extend without breaking D4 (report-only verify)
- `.cursor/rules/050-security.mdc` — pin SHA, advisories, F-SEC-5 (`gate:` never eval)
- `sdd-kit/MANIFEST.yaml`, `sdd-kit/install.sh` — profiles and distribution
- [google/osv-scanner-action](https://github.com/google/osv-scanner-action) — action v2.3.8, SHA `8dc09193bb540e09b23da07ad7e30bd33bf87018`
- [renovatebot/renovate](https://github.com/renovatebot/renovate) — preset and `renovate.json` schema

## Decisions

### D1: OSV inside `sdd-gates.yml` (not a separate workflow)

**Choice:** add `OSV-Scanner (blocking)` step to the existing `sdd-gates` job, after checkout and before or after OpenSpec gates (recommended: **after** `openspec validate` and `task patterns`, **before** report-only `sdd-kit verify`).

**Discarded alternative:** dedicated `.github/workflows/osv-scanner.yml` with the same triggers.

| Criterion | Inside sdd-gates | Separate workflow |
|-----------|------------------|-------------------|
| Single PR check | ✅ one "SDD Gates" check | ❌ two checks |
| Hub/template parity | ✅ one file to maintain | ❌ two files |
| D1 triggers | ✅ reuse | duplicated |
| G7 PR-Agent re-evaluation | one workflow to compose | more fragmentation |

**Rationale:** G8 research and G1 evaluation anticipate OSV *inside* existing CI; smaller operational surface; D11 (`permissions: contents: read`) maintained.

**D1–D11 compatibility:**

| G1 ID | G8 impact |
|-------|-----------|
| D1 triggers | Unchanged |
| D2 openspec blocking | Unchanged |
| D3 task patterns blocking | Unchanged |
| D4 verify report-only | Unchanged — OSV is a separate blocking step |
| D5 Node/Python setup | Unchanged — OSV action bundles binary |
| D6 openspec pin | Unchanged |
| D7 template COPY | Template `sdd-gates.yml` updated |
| D8 R3 N/A | Maintained — OSV/Renovate out-of-band |
| D9 MANIFEST bump | 1.4.0 → **1.5.0** |
| D10 branch protection manual | Document OSV in §2.13 |
| D11 permissions read | Maintained — OSV does not need write |

**Exception to G1 rule "existing commands only":** OSV uses pinned GitHub Action (`google/osv-scanner-action/osv-scanner-action@<sha>`). Documented in delta `sdd-ci-gates` as the only authorized external dependency for supply chain.

### D2: OSV action SHA pin

**Choice:**

```yaml
uses: google/osv-scanner-action/osv-scanner-action@8dc09193bb540e09b23da07ad7e30bd33bf87018 # v2.3.8
```

**Discarded alternative:** reusable workflow `osv-scanner-reusable.yml@v2.3.8` — may pull `actions/download-artifact@v8` by tag on older releases (transitive require-SHA policy). Prefer direct action with explicit `scan-args`.

**Apply:** confirm SHA on tag v2.3.8 at apply time; update `# vX.Y.Z` comment.

### D3: OSV — execution condition and lockfiles

**Choice:** step with `if:` based on lockfile detection at repo root:

```yaml
if: >-
  hashFiles('package-lock.json', 'pnpm-lock.yaml', 'yarn.lock',
            'poetry.lock', 'Pipfile.lock', 'Cargo.lock', 'go.sum',
            'Gemfile.lock', 'composer.lock') != ''
```

Recommended `scan-args`:

```yaml
with:
  scan-args: |-
    --recursive
    ./
```

- **Policy:** fail-closed if vulnerability in lockfile (action non-zero exit).
- **SKIP:** emit log `SKIP: no lockfile at repo root — OSV-Scanner not applicable` when `if` is false (DOCS_SPECS hub without deps).

### D4: Trigger mode — A for both

| Tool | Mode | Who triggers | Stage |
|------|------|--------------|-------|
| OSV-Scanner | A | push/PR (automatic) | Pre-merge, in SDD Gates job |
| Renovate | A | Scheduled (Mend bot) | PRs generated outside session; enter as type A/B |

No interactive step in explore/propose/apply.

### D5: Profile matrix (install.sh / MANIFEST)

| Profile | OSV-Scanner | Renovate (`renovate.json`) |
|---------|-------------|----------------------------|
| **APP** | Yes — step in `sdd-gates.yml` (if lockfile) | Yes — COPY `templates/renovate.json` + GitHub app doc |
| **DOCS_SPECS** | Yes — **only if** lockfile at repo root on install | **SKIP** — do not copy `renovate.json` |
| **HYBRID** | Yes | Yes |

`install.sh` implementation:

- `sdd-gates.yml`: always COPY (all profiles).
- `renovate.json`: COPY only APP/HYBRID; log `SKIP Renovate: profile DOCS_SPECS`.
- MANIFEST entry with `profiles: [APP, HYBRID]` for `renovate.json`.

### D6: Conservative Renovate preset (exact fields)

Template `sdd-kit/templates/renovate.json`:

```json
{
  "$schema": "https://docs.renovatebot.com/renovate-schema.json",
  "extends": [
    "config:recommended",
    ":dependencyDashboard",
    ":semanticCommits",
    ":separateMajorReleases",
    "group:monorepos"
  ],
  "timezone": "America/Sao_Paulo",
  "schedule": ["before 9am on monday"],
  "prConcurrentLimit": 5,
  "prHourlyLimit": 2,
  "rebaseWhen": "conflicted",
  "packageRules": [
    {
      "description": "Group non-major minor and patch",
      "matchUpdateTypes": ["minor", "patch"],
      "groupName": "non-major dependencies",
      "groupSlug": "non-major"
    },
    {
      "description": "Automerge patches only with green CI",
      "matchUpdateTypes": ["patch"],
      "automerge": true,
      "automergeType": "pr",
      "requiredStatusChecks": ["SDD Gates"]
    },
    {
      "description": "Never automerge majors",
      "matchUpdateTypes": ["major"],
      "automerge": false
    },
    {
      "description": "Minor requires human review",
      "matchUpdateTypes": ["minor"],
      "automerge": false
    }
  ],
  "lockFileMaintenance": {
    "enabled": true,
    "extends": ["schedule:monthly"]
  },
  "vulnerabilityAlerts": {
    "labels": ["security"],
    "automerge": false
  }
}
```

**Operational notes (R4):**

- `requiredStatusChecks: ["SDD Gates"]` and `automerge: true` only work with branch protection + automerge enabled on GitHub — document as opt-in `[MANUAL ACTION REQUIRED]`.
- No tokens in repo; app at [github.com/apps/renovate](https://github.com/apps/renovate).

### D7: SDD integration — PR classification

| Origin | Agent classification | Action |
|--------|---------------------|--------|
| Renovate patch | **Type A** | Quick review; merge if CI green |
| Renovate minor | **Type B/C** | Review breaking behaviour |
| Renovate major | **Type B/C** | Mandatory human review; no automerge |
| Red OSV on PR | **Type B** | Fix/update dependency before merge or `/opsx:archive` |

Independent of the A–E task in progress in the session — supply chain operates on the repo.

### D8: R3 — optional skill

**Choice:** **do not** create a dedicated skill; prefer ≤10 lines in `AGENTS.md` (R2) for Renovate/OSV classification. Skill only if apply reveals a discovery gap.

### D9: Renovate pilot

OSV: pilot optional (CI step only). Renovate: manual checklist in guide §2.13 — validate on pilot APP repo that preset PR volume is manageable (e.g. ≤5 PRs/week after stabilization); no mandatory formal pilot if preset is documented.

## A–E matrix (supply chain vs task in progress)

| Task type | OSV (CI) | Renovate (bot) |
|-----------|----------|----------------|
| A — Trivial | Continuous* | Continuous* |
| B — Bug fix | Continuous* | Continuous* |
| C — Refactor | Continuous* | Continuous* |
| D — Feature | Continuous* | Continuous* |
| E — Exploration | Continuous* | Continuous* |

\* Independent of classification — operate on the repo (`metodologia-insercao.md` §4.2).

## Registration — 6-point contract (Phase 3)

| # | Where | Content |
|---|-------|---------|
| R1 | `openspec/infra.md` + `sdd-kit/templates/openspec/infra.md` | OSV-Scanner (action SHA, status) + Renovate (config, manual app) |
| R2 | `AGENTS.md` + `sdd-kit/templates/AGENTS.core.md` | Classify Renovate PRs; red OSV = fix deps (type B) |
| R3 | — | N/A — prefer AGENTS.md |
| R4 | `doc/sistema-sdd-pedro.md` **§2.13** | Install Renovate app, read OSV in Actions, preset, troubleshooting |
| R5 | `doc/avaliacoes/2026-07-25-oss-coverage-gaps-tooling.md` | G8 → Adopted + reference to this change |
| R6 | `sdd-kit/` | `templates/renovate.json`; OSV in `templates/.../sdd-gates.yml`; `install.sh`; MANIFEST 1.5.0 + `gen-manifest-checksums.sh` |

## Rollback

| Component | Rollback |
|-----------|----------|
| OSV | Remove OSV step from `sdd-gates.yml` (hub + template) — gate disabled immediately |
| Renovate | Remove `renovate.json` + uninstall GitHub app on repo |
| MANIFEST | Revert bump 1.5.0 → 1.4.0 and new entries |
| Docs | Revert R1/R2/R4/R5 lines |

No locally installed binary; no residual state beyond versioned files.

## Risks / Trade-offs

| Risk | Mitigation |
|------|------------|
| OSV false positives block merge | Document temporary override (pin/advisory ignore) in §2.13; fixing deps is preferred path |
| Renovate PR spam | Conservative preset (schedule, limits, grouping); APP pilot checklist |
| Automerge patches break CI | `requiredStatusChecks: ["SDD Gates"]`; automerge manual opt-in |
| AGPL Renovate | Use as tool OK; record in evaluation; do not redistribute modified fork |
| Transitive unpinned actions in OSV upstream | Use pinned direct action (D2), not reusable workflow |
| Future conflict with PR-Agent (G7) | Re-evaluate workflow composition in G7 phase 2 change |
| `npx --yes` transitive (F-SEC-3) | Documented in 050; OSV does not worsen — does not use npx |

## Migration Plan

1. Apply updates template `sdd-gates.yml` and hub (same content).
2. `install.sh` starts copying `renovate.json` by profile.
3. C2 consumers: `upgrade.sh --dry-run` → `--apply` to receive templates.
4. Operator: install Renovate app (APP/HYBRID); configure branch protection including SDD Gates.
5. Post-register: `graphify update .` + `gitnexus analyze --force` (best-effort).

## Open Questions

| Question | Proposed resolution |
|----------|---------------------|
| OSV before or after openspec validate? | After validate + task patterns — SDD normative failures first |
| New capability vs ci-gates delta only? | **`sdd-supply-chain`** for Renovate + PR requirement; delta **`sdd-ci-gates`** for OSV step in workflow |
| MANIFEST bump minor or patch? | **Minor** 1.4.0 → 1.5.0 (new distributed capability) |

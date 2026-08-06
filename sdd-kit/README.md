# ByeByeVibe — sdd-kit v1.13.0

**ByeByeVibe** is the public name of this project. This folder (`sdd-kit/`) is the versioned **install payload** — commands and paths stay `sdd-kit/*`.

Versioned payload for reproducible SDD stack install (scripts, rules, skeletons), separate from the procedure guide `doc/byebyevibe-guide.md`.

## What this is (first contact)

**For newcomers from vibe coding / AI-assisted workflows:** this folder is the **install kit** for ByeByeVibe — a versioned control plane (OpenSpec + GitNexus + Graphify, gates, optional modules), **not** an app boilerplate or Next.js starter.

| Human name | Code | When to use |
|------------|------|-------------|
| **Greenfield install** (first time) | **C1** | New repo — bootstrap CLIs, then `install.sh` |
| **Upgrade SDD** (kit already installed) | **C2** | New guide/kit version — `upgrade.sh --dry-run` → `--apply` |
| **CLI-only refresh** | **C2b** | Update OpenSpec/GitNexus/Graphify without touching curated files |
| **Propagate domain specs** | **C3** | Share `openspec/specs/` via git — **do not** run install/upgrade |
| **UI module** (optional) | **C1-UI** | Design system / Impeccable + shadcn after C1 |
| **Probity / TDD enforce** (optional) | **G2** | APP — `@nizos/probity` after C1 |
| **SDD metrics** (on demand) | **G4** | Retrospectives: lead time, rework — calibrate as you go |

**Install scope in one line:** CLIs install once per machine; each repo receives its own payload copy — full scope model in [`doc/byebyevibe-guide.md`](../doc/byebyevibe-guide.md) §1.6.

**Lightweight fetch (C1, no full hub clone):** see [`doc/byebyevibe-guide.md`](../doc/byebyevibe-guide.md) §1.6 "Lightweight fetch recipe" for greenfield installs.

Discovery / hero: hub root [`README.md`](../README.md) (EN). Full procedure: [`doc/byebyevibe-guide.md`](../doc/byebyevibe-guide.md) §2.0b. Didactic narrative (What / Why / Without it + optional add-ons glance): guide **§2.1** and the block after **§2.8**.

## Scenarios

| Code | Situation | Scope | Entry command |
|------|-----------|-------|---------------|
| **C1** | Greenfield install (first time) | machine + repo | `bash scripts/bootstrap-sdd.sh` → `bash sdd-kit/install.sh --profile <PROFILE>` |
| **C2** | SDD upgrade (new guide/kit version) | repo | `bash sdd-kit/upgrade.sh --from X --to Y --dry-run` → approval → `--apply` |
| **C2b** | Outdated CLIs only | machine | `doc/byebyevibe-guide.md` §2.9.4 — **do not** touch the kit |
| **C3** | Domain specs propagation | repo | git/reference under `openspec/specs/` — **do not** run `install.sh` or `upgrade.sh` |
| **C1-UI** | Optional UI module (post-C1) | repo | `bash sdd-kit/install-ui-module.sh --detect` → `--apply [--yes]` — see guide §2.11 |
| **G2** | Probity module (TDD enforce, post-C1) | repo | `bash sdd-kit/install-probity-module.sh --detect` → `--apply [--yes]` — pin `@nizos/probity@1.10.0`; guide §2.16 |
| **G4** | On-demand SDD metrics (mode C) | repo | `bash scripts/sdd-metrics.sh` — guide §2.17; **not** Apache DevLake |

## Profiles

Two active profiles — pick by answering "will this repository hold application code?" Full decision copy: guide §1.6.

| Profile | `--profile` | What changes |
|---------|-------------|--------------|
| APP | `APP` | Commands 12.2a; TS/Supabase rules |
| DOCS_SPECS | `DOCS_SPECS` | Commands 12.2b |

`HYBRID` is deprecated (kit 1.9.0) — `--profile HYBRID` still works but normalizes to APP with a one-line notice.

## Quick commands

```bash
# Dry-run (do not write files)
bash sdd-kit/install.sh --profile DOCS_SPECS --dry-run

# Install payloads after openspec init
bash sdd-kit/install.sh --profile DOCS_SPECS

# Bootstrap CLIs in this repo (OpenSpec → GitNexus → Graphify → install.sh)
bash scripts/bootstrap-sdd.sh
# CI/agents: suppress didactic TTY banners (WARN/ERROR still print)
bash scripts/bootstrap-sdd.sh --quiet

# Hub → destination: one command, run from the hub against another repo (guide §1.6)
bash <hub>/scripts/bootstrap-sdd.sh <target-repo> --profile <PROFILE>

# Upgrade with report
bash sdd-kit/upgrade.sh --from 1.2.0 --to 1.3.0 --dry-run

# Post-install verification
bash sdd-kit/verify.sh
```

`--quiet` / `-q` on `bootstrap-sdd.sh` skips S-layer banners; non-TTY (CI) omits banners even without the flag. Optional: `--chat-lang pt-BR` or `SDD_CHAT_LANG=pt-BR` for runtime banner language.

**What `verify.sh` enforces vs. reports.** It is fail-closed on the version-sync check (every declared version string must match its `MANIFEST.yaml` authority — kit README heading against `version:`, both guide header claims against `guide_version:`; absent files skip, unparseable claims WARN) and on kit integrity. Two of the checks it orchestrates are conditionally report-only:

- `scripts/verify-infra.sh` (kit 1.8.2) writes the `openspec/infra.md` markers only on a TTY or with `--write`; a non-interactive run without `--write` prints findings and exits 0 without touching the file.
- `scripts/verify-task-patterns.sh` (kit 1.9.0) is fail-closed on DOCS_SPECS; on APP and on an undetected profile it is report-only — broken local `Pattern:` paths print WARN and exit 0.

## Structure

```
sdd-kit/
├── MANIFEST.yaml      # Version, files, merge strategy, gates
├── install.sh         # C1 — copy templates to canonical paths
├── install-ui-module.sh      # C1-UI — optional UI module post-C1
├── install-probity-module.sh # G2 — Probity (enforceTdd) optional post-C1; APP
├── upgrade.sh         # C2 — diff + UPGRADE_REPORT + --apply
├── verify.sh          # Orchestrates verify-infra + task-patterns + session-status + version sync
├── gen-manifest-checksums.sh # Recompute/verify MANIFEST sha256 fields after editing a template
└── templates/         # Mirrors paths in the target repo: scripts/, .cursor/ (rules, skills, commands),
                       #   .claude/ (skills, commands), .github/workflows/, doc/, openspec/
```

## CI gate (sdd-gates)

The kit ships `.github/workflows/sdd-gates.yml` (template under `templates/.github/workflows/`) — a GitHub Actions workflow that runs SDD gates on `push`/`pull_request`. It only orchestrates existing commands; no new dependency.

| Blocking gate | Condition |
|---------------|-----------|
| `openspec validate --all --strict` | Always — pinned to `min_openspec` from `MANIFEST.yaml` |
| `bash scripts/verify-task-patterns.sh` | When the script is present (SKIP notice otherwise) |
| **OSV-Scanner** | When a lockfile exists at the repo root; explicit SKIP when none. Action pinned by SHA (G8) |

`bash sdd-kit/verify.sh` also runs in the workflow, but as a **report-only** step (`continue-on-error: true`) — `verify-infra.sh` FAILs on knowledge CLIs that no runner has.

Dependency updates: `templates/renovate.json` (conservative preset) installs to the APP profile; the Renovate GitHub App itself is a manual one-off — see guide §2.13.

> `[MANUAL ACTION REQUIRED]` For the gate to **block merge in practice**, the operator must enable branch protection on the repository (Settings → Branches → require status check "SDD Gates"). See `doc/byebyevibe-guide.md` §2.12.

## Agent tooling installed automatically (C1)

`install.sh` copies these from `templates/` to both agent directories (`.claude/` and `.cursor/`) on every profile — no extra step, no manual copy:

| Artifact | What it does |
|----------|--------------|
| `openspec-help` skill + `/opsx:help` command | Day-1 operator map after install — files, phases, confidence |
| `sdd-skill-guidance` skill | Offers to save a skill when you keep re-teaching the same domain facts (offer-only) |
| `sdd-tooling-guidance` skill | Offers a CLI/MCP integration when the agent narrates manual steps for the same tool twice (offer-only) |
| `doc/sdd-operator-day1.md` | The tutorial `/opsx:help` narrates |
| `doc/tooling-install.md` | Per-tool install how-to referenced by `sdd-tooling-guidance` |

The `.claude/` and `.cursor/` copies of `sdd-tooling-guidance` diverge on purpose (Claude Code harness tools vs. Cursor degradation); the other mirrors are byte-identical.

Everything in the next section is **manual** — the kit ships no installer for it.

## Post-apply review skills (manual install)

The kit does not ship an automatic installer for on-demand review skills (mode C). To install in consumer repos, copy the skill files manually:

### correctness-review

```bash
# In the consumer repo (APP or DOCS_SPECS)
mkdir -p .claude/skills/correctness-review .cursor/skills/correctness-review
cp <path-to-this-hub>/.claude/skills/correctness-review/SKILL.md .claude/skills/correctness-review/SKILL.md
cp .claude/skills/correctness-review/SKILL.md .cursor/skills/correctness-review/SKILL.md
```

Register in the consumer repo `openspec/infra.md` (Skills section):

```
| `.claude/skills/correctness-review/` + `.cursor/skills/correctness-review/` | review | ✅ |
```

> **Note:** this pattern is identical for `simplify-review`. As of kit 1.10.0 the review skills remain manual-install by design: they are local skills without a binary or hook, they are not MANIFEST-tracked, and `install.sh` does not copy them. Use the commands above in each repo that wants them.

### simplify-review

Same procedure as above, replacing `correctness-review` with `simplify-review`.

## Hub vs consumer

- **Hub (DOCS_SPECS):** commit the full `sdd-kit/` to distribute C2 upgrades.
- **APP:** may receive only expanded files (`scripts/`, `.cursor/rules/`); keep `sdd-kit/` optional for upgrades.

## Version

`MANIFEST.yaml` `version` MUST match changelog §14 of `doc/byebyevibe-guide.md` and `openspec/project.md` Cross-references.

See guide **§1.6** for the four-layer model (procedure / payload / specs / state).

# ByeByeVibe — sdd-kit v1.6.1

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
| **Probity / TDD enforce** (optional) | **G2** | APP/HYBRID — `@nizos/probity` after C1 |
| **SDD metrics** (on demand) | **G4** | Retrospectives: lead time, rework — calibrate as you go |

Discovery / hero: hub root [`README.md`](../README.md) (EN). Full procedure: [`doc/byebyevibe-guide.md`](../doc/byebyevibe-guide.md) §2.0b. Didactic narrative (What / Why / Without it + optional add-ons glance): guide **§2.1** and the block after **§2.8**.

## Scenarios

| Code | Situation | Entry command |
|------|-----------|---------------|
| **C1** | Greenfield install (first time) | `bash scripts/bootstrap-sdd.sh` → `bash sdd-kit/install.sh --profile <PROFILE>` |
| **C2** | SDD upgrade (new guide/kit version) | `bash sdd-kit/upgrade.sh --from X --to Y --dry-run` → approval → `--apply` |
| **C2b** | Outdated CLIs only | `doc/byebyevibe-guide.md` §2.9.4 — **do not** touch the kit |
| **C3** | Domain specs propagation | git/reference under `openspec/specs/` — **do not** run `install.sh` or `upgrade.sh` |
| **C1-UI** | Optional UI module (post-C1) | `bash sdd-kit/install-ui-module.sh --detect` → `--apply [--yes]` — see guide §2.11 |
| **G2** | Probity module (TDD enforce, post-C1) | `bash sdd-kit/install-probity-module.sh --detect` → `--apply [--yes]` — pin `@nizos/probity@1.10.0`; guide §2.16 |
| **G4** | On-demand SDD metrics (mode C) | `bash scripts/sdd-metrics.sh` — guide §2.17; **not** Apache DevLake |

## Profiles

| Profile | `--profile` | What changes |
|---------|-------------|--------------|
| APP | `APP` | Commands 12.2a; TS/Supabase rules |
| DOCS_SPECS | `DOCS_SPECS` | Commands 12.2b; `verify-task-patterns.sh` |
| HYBRID | `HYBRID` | APP commands + optional rules |

## Quick commands

```bash
# Dry-run (do not write files)
bash sdd-kit/install.sh --profile DOCS_SPECS --dry-run

# Install payloads after openspec init
bash sdd-kit/install.sh --profile DOCS_SPECS

# Bootstrap CLIs (OpenSpec → GitNexus → Graphify → install.sh)
bash scripts/bootstrap-sdd.sh
# CI/agents: suppress didactic TTY banners (WARN/ERROR still print)
bash scripts/bootstrap-sdd.sh --quiet

# Upgrade with report
bash sdd-kit/upgrade.sh --from 1.2.0 --to 1.3.0 --dry-run

# Post-install verification
bash sdd-kit/verify.sh
```

`--quiet` / `-q` on `bootstrap-sdd.sh` skips S-layer banners; non-TTY (CI) omits banners even without the flag. Optional: `--chat-lang pt-BR` or `SDD_CHAT_LANG=pt-BR` for runtime banner language.

## Structure

```
sdd-kit/
├── MANIFEST.yaml      # Version, files, merge strategy, gates
├── install.sh         # C1 — copy templates to canonical paths
├── install-ui-module.sh      # C1-UI — optional UI module post-C1
├── install-probity-module.sh # G2 — Probity (enforceTdd) optional post-C1; APP/HYBRID
├── upgrade.sh         # C2 — diff + UPGRADE_REPORT + --apply
├── verify.sh          # Orchestrates verify-infra + task-patterns + session-status
└── templates/         # Mirrors paths in the target repo (scripts/, .cursor/rules/, doc/design/, …)
```

## CI gate (sdd-gates)

The kit ships `.github/workflows/sdd-gates.yml` (template under `templates/.github/workflows/`) — a GitHub Actions workflow that runs SDD gates on `push`/`pull_request`, fail-closed on `openspec validate` (pinned version = `min_openspec`). It only orchestrates existing commands; no new dependency.

> `[MANUAL ACTION REQUIRED]` For the gate to **block merge in practice**, the operator must enable branch protection on the repository (Settings → Branches → require status check "SDD Gates"). See `doc/byebyevibe-guide.md` §2.12.

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

> **Note:** this pattern is identical for `simplify-review`. There is no automatic `install.sh` script in this phase (Phase 1 — local skill without binary/hook). An automatic script is planned for v1.5.0 if APP-repo validation confirms adoption.

### simplify-review

Same procedure as above, replacing `correctness-review` with `simplify-review`.

## Hub vs consumer

- **Hub (DOCS_SPECS):** commit the full `sdd-kit/` to distribute C2 upgrades.
- **APP:** may receive only expanded files (`scripts/`, `.cursor/rules/`); keep `sdd-kit/` optional for upgrades.

## Version

`MANIFEST.yaml` `version` MUST match changelog §14 of `doc/byebyevibe-guide.md` and `openspec/project.md` Cross-references.

See guide **§1.6** for the four-layer model (procedure / payload / specs / state).

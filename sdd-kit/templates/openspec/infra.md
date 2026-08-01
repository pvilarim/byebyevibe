# Workspace Infrastructure Manifest

> Last verified: YYYY-MM-DD · Script: `scripts/verify-infra.sh`
>
> **Rule:** no secret values. Env vars list **names** and presence only (✅/❌).

## SDD Stack (repo)

| Component | Version | Status | Verify with |
|-----------|---------|--------|-------------|
| OpenSpec | <!-- openspec-version -->—<!-- /openspec-version --> | <!-- openspec-status -->❌<!-- /openspec-status --> | `npx openspec list` |
| GitNexus | <!-- gitnexus-version -->—<!-- /gitnexus-version --> | <!-- gitnexus-status -->❌<!-- /gitnexus-status --> | `npx gitnexus status` |
| Graphify | <!-- graphify-version -->—<!-- /graphify-version --> | <!-- graphify-status -->❌<!-- /graphify-status --> | `test -f graphify-out/GRAPH_REPORT.md` |

## MCP Servers

> Names only — dynamic auth is not committed. Confirm with `mcp_get_tools` in the session.

| Server | Status | Verify with |
|--------|--------|-------------|
| github-mcp-server (v1.7.0 local; remote via `api.githubcopilot.com/mcp/`) | `[NEEDS VERIFICATION]` | `mcp_get_tools` or `~/.cursor/mcp.json` |
| <!-- mcp-list -->other MCPs<!-- /mcp-list --> | — | `~/.cursor/mcp.json` or `mcp_get_tools` |

## Skills (repo)

| Path | Phase | Status |
|------|-------|--------|
| `.cursor/skills/openspec-explore/` | explore | [NEEDS VERIFICATION] |
| `.cursor/skills/openspec-propose/` | propose | [NEEDS VERIFICATION] |
| `.cursor/skills/openspec-apply-change/` | apply | [NEEDS VERIFICATION] |
| `.cursor/skills/openspec-archive-change/` | archive | [NEEDS VERIFICATION] |
| `.cursor/skills/openspec-help/` (`/opsx:help`) | day-1 operate (mode C) | [NEEDS VERIFICATION] |

## Session Coordination

| Script | Function | Status | Verify with |
|--------|----------|--------|-------------|
| `scripts/sdd-session-register.sh` | Register + flock apply | ❌ | `test -x scripts/sdd-session-register.sh` |
| `scripts/sdd-session-check.sh` | Validation before writes | ❌ | `bash scripts/sdd-session-check.sh --phase explore` |
| `scripts/sdd-session-status.sh` | List active sessions | ❌ | `bash scripts/sdd-session-status.sh` |
| `scripts/sdd-session-release.sh` | Release lock/presence | ❌ | `test -x scripts/sdd-session-release.sh` |

Local runtime (gitignored): `.sdd/runtime/` (`apply.lock`, `sessions/*.json`).

## Install Kit

| Artifact | Version | Status | Verify with |
|----------|---------|--------|-------------|
| `sdd-kit/MANIFEST.yaml` | <!-- kit-version -->—<!-- /kit-version --> | <!-- kit-status -->❌<!-- /kit-status --> | `grep version sdd-kit/MANIFEST.yaml` |
| `sdd-kit/install.sh` | — | <!-- kit-install-status -->❌<!-- /kit-install-status --> | `test -x sdd-kit/install.sh` |
| `sdd-kit/verify.sh` | — | <!-- kit-verify-status -->❌<!-- /kit-verify-status --> | `bash sdd-kit/verify.sh` |

## CI Gates

| Component | Status | Verify with |
|-----------|--------|-------------|
| Workflow `sdd-gates` | [NEEDS VERIFICATION] | `test -f .github/workflows/sdd-gates.yml` |
| Template in kit | [NEEDS VERIFICATION] | `test -f sdd-kit/templates/.github/workflows/sdd-gates.yml` |
| Branch protection (required check) | `[MANUAL ACTION]` | guide §2.12 |

Fail-closed: `openspec validate`, `verify-task-patterns.sh`, **OSV-Scanner** (when lockfile present). Operation: guide §2.12.

## Supply Chain

| Component | Status | Verify with |
|-----------|--------|-------------|
| OSV-Scanner (CI) | [NEEDS VERIFICATION] | `grep -q 'OSV-Scanner (blocking)' .github/workflows/sdd-gates.yml` |
| Action SHA | `8dc09193bb540e09b23da07ad7e30bd33bf87018` (# v2.3.8) | `grep 8dc09193bb540e09b23da07ad7e30bd33bf87018 .github/workflows/sdd-gates.yml` |
| Renovate (`renovate.json`) | APP/HYBRID only | `test -f renovate.json` |
| Renovate GitHub App | `[MANUAL ACTION]` | guide §2.13 |

Operation: `doc/sistema-sdd-pedro.md` §2.13.

## UI Development Module

| Component | Status | Verify with |
|-----------|--------|-------------|
| UI stack | [NEEDS VERIFICATION] | `grep 'UI stack' openspec/project.md` |
| Impeccable | pending | `test -d .cursor/skills/impeccable` |
| Open Design | manual / not installed | on demand — see doc/design/002 |
| Pencil | manual / not installed | on demand — see doc/design/002 |
| Figma MCP | manual / not installed | `mcp_get_tools` in the session |

## Probity Module

| Component | Status | Verify with |
|-----------|--------|-------------|
| `@nizos/probity@1.10.0` | SKIP until `--apply` on APP/HYBRID | `test -f probity.config.ts` |
| `probity.config.ts` | SKIP until `--apply` | `grep -q enforceTdd probity.config.ts` |
| Plugin / hook | SKIP | Claude Code: `/plugin install probity@probity` |
| `sdd-kit/install-probity-module.sh` | [NEEDS VERIFICATION] | `test -x sdd-kit/install-probity-module.sh` |

Optional G2 module (APP/HYBRID with tests). DOCS_SPECS without test runner: SKIP.
Operation: `doc/sistema-sdd-pedro.md` §2.16 · `doc/design/004-probity-module-install.md`.

## SDD Metrics (G4)

| Component | Status | Verify with |
|-----------|--------|-------------|
| `scripts/sdd-metrics.sh` | ❌ | `test -x scripts/sdd-metrics.sh` |
| On-demand report (mode C) | ❌ | `bash scripts/sdd-metrics.sh --help` |

Local script (git + `openspec/changes/archive/`) — do **not** adopt Apache DevLake. Operation: `doc/sistema-sdd-pedro.md` §2.17.

## Env vars (names only)

| Variable | Present | Verify with |
|----------|---------|-------------|
| <!-- env-list -->_(no .env.example in repo)_<!-- /env-list --> | — | `scripts/verify-infra.sh` |

## Agent rule

- **R10** (`AGENTS.md`): read this manifest before installing/reinstalling MCP, CLIs, plugins, or skills.
- **✅** = use directly; do **not** reinstall or web-search for setup.
- **❌** or `[NEEDS VERIFICATION]` = run `bash scripts/verify-infra.sh` or ask the operator.

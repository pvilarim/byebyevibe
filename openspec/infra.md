# Workspace Infrastructure Manifest

> Last verified: 2026-08-01 · Script: `scripts/verify-infra.sh`
>
> **Rule:** no secret values. Env vars list **names** and presence only (✅/❌).

## Preflight (last run)

> Updated only by `scripts/preflight-sdd.sh` — `verify-infra.sh` must not overwrite this section.

| Field | Value |
|-------|-------|
| Timestamp | <!-- preflight-timestamp -->—<!-- /preflight-timestamp --> |
| IDE(s) | <!-- preflight-ides -->—<!-- /preflight-ides --> |
| WARN summary | <!-- preflight-warns -->—<!-- /preflight-warns --> |
| MCP names (advisory) | <!-- preflight-mcp -->—<!-- /preflight-mcp --> |

## SDD Stack (repo)

| Component | Version | Status | Verify with |
|-----------|---------|--------|-------------|
| OpenSpec | <!-- openspec-version -->1.3.1<!-- /openspec-version --> | <!-- openspec-status -->✅<!-- /openspec-status --> | `npx openspec list` |
| GitNexus | <!-- gitnexus-version -->1.6.9<!-- /gitnexus-version --> | <!-- gitnexus-status -->✅<!-- /gitnexus-status --> | `npx gitnexus status` |
| Graphify | <!-- graphify-version -->graphify 0.9.31<!-- /graphify-version --> | <!-- graphify-status -->✅<!-- /graphify-status --> | `test -f graphify-out/GRAPH_REPORT.md` |

## MCP Servers

> Names only — dynamic auth is not committed. Confirm with `mcp_get_tools` in the session.
> Per-tool install how-to: [`doc/tooling-install.md`](../doc/tooling-install.md) (status here, guidance there).

| Server | Status | Verify with |
|--------|--------|-------------|
| github-mcp-server (v1.7.0 local; remote via `api.githubcopilot.com/mcp/`) | `[NEEDS VERIFICATION]` | `mcp_get_tools` or `~/.cursor/mcp.json` |
| <!-- mcp-list -->[NEEDS VERIFICATION]<!-- /mcp-list --> | — | `~/.cursor/mcp.json` or `mcp_get_tools` |

## Skills (repo)

| Path | Phase | Status |
|------|-------|--------|
| `.cursor/skills/openspec-explore/` | explore | ✅ |
| `.cursor/skills/openspec-propose/` | propose | ✅ |
| `.cursor/skills/openspec-apply-change/` | apply | ✅ |
| `.cursor/skills/openspec-archive-change/` | archive | ✅ |
| `.cursor/skills/openspec-help/` (`/opsx:help`) | day-1 operate (mode C) | ✅ |
| `.claude/skills/openspec-*/` | all | ✅ (mirror) |
| `.claude/skills/gitnexus/` | impact/debug | ✅ |
| `.cursor/skills/simplify-review/` | review | ✅ |
| `.claude/skills/correctness-review/` + `.cursor/skills/correctness-review/` | review | ✅ |

## Session Coordination

| Script | Function | Status | Verify with |
|--------|----------|--------|-------------|
| `scripts/sdd-session-register.sh` | Register + flock apply | ✅ | `test -x scripts/sdd-session-register.sh` |
| `scripts/sdd-session-check.sh` | Validation before writes | ✅ | `bash scripts/sdd-session-check.sh --phase explore` |
| `scripts/sdd-session-status.sh` | List active sessions | ✅ | `bash scripts/sdd-session-status.sh` |
| `scripts/sdd-session-heartbeat.sh` | Update heartbeat | ✅ | `test -x scripts/sdd-session-heartbeat.sh` |
| `scripts/sdd-session-release.sh` | Release lock/presence | ✅ | `test -x scripts/sdd-session-release.sh` |

Local runtime (gitignored): `.sdd/runtime/` (`apply.lock`, `sessions/*.json`).

Always-on rule: `.cursor/rules/016-session-coordination.mdc`.

## Install Kit

| Artifact | Version | Status | Verify with |
|----------|---------|--------|-------------|
| `sdd-kit/MANIFEST.yaml` | <!-- kit-version -->1.7.0<!-- /kit-version --> | <!-- kit-status -->✅<!-- /kit-status --> | `grep version sdd-kit/MANIFEST.yaml` |
| `sdd-kit/install.sh` | — | <!-- kit-install-status -->✅<!-- /kit-install-status --> | `test -x sdd-kit/install.sh` |
| `sdd-kit/install-ui-module.sh` | — | ✅ | `test -x sdd-kit/install-ui-module.sh` |
| `sdd-kit/install-probity-module.sh` | — | ✅ | `test -x sdd-kit/install-probity-module.sh` |
| `sdd-kit/upgrade.sh` | — | ✅ | `test -x sdd-kit/upgrade.sh` |
| `sdd-kit/verify.sh` | — | <!-- kit-verify-status -->✅<!-- /kit-verify-status --> | `bash sdd-kit/verify.sh` |

Payload source: `sdd-kit/templates/` (do not extract scripts from markdown §12). See `sdd-kit/README.md` for scenarios C1–C3 and C1-UI.

## CI Gates

| Component | Status | Verify with |
|-----------|--------|-------------|
| Workflow `sdd-gates` | ✅ | `test -f .github/workflows/sdd-gates.yml` |
| Template in kit | ✅ | `test -f sdd-kit/templates/.github/workflows/sdd-gates.yml` |
| Branch protection (required check) | `[MANUAL ACTION]` — configure on GitHub | guide §2.12 |

Fail-closed on `openspec validate --all --strict` (pinned `@fission-ai/openspec@1.3.1` = `min_openspec`), `verify-task-patterns.sh`, and **OSV-Scanner** when a lockfile is present. No skill/rule — automatic out-of-band. Operation: `doc/byebyevibe-guide.md` §2.12.

## Supply Chain

| Component | Status | Verify with |
|-----------|--------|-------------|
| OSV-Scanner (CI) | ✅ | `grep -q 'OSV-Scanner (blocking)' .github/workflows/sdd-gates.yml` |
| Action SHA | `8dc09193bb540e09b23da07ad7e30bd33bf87018` (# v2.3.8) | `grep 8dc09193bb540e09b23da07ad7e30bd33bf87018 .github/workflows/sdd-gates.yml` |
| Renovate (`renovate.json`) | SKIP — hub DOCS_SPECS | `test -f renovate.json` (APP/HYBRID after install) |
| Renovate GitHub App | `[MANUAL ACTION]` — install on APP/HYBRID | guide §2.13 |

OSV runs in the `SDD Gates` job when a lockfile exists at the repo root; explicit SKIP when none. Renovate: conservative preset via `sdd-kit/templates/renovate.json` (APP/HYBRID profiles). Operation: `doc/byebyevibe-guide.md` §2.13.

## UI Development Module

| Component | Status | Verify with |
|-----------|--------|-------------|
| UI stack | none (DOCS_SPECS hub) | `grep 'UI stack' openspec/project.md` |
| Impeccable | SKIP — hub without frontend | `test -d .cursor/skills/impeccable` |
| Open Design | manual / not installed | on demand — see `doc/design/002-ui-module-install.md` |
| Pencil | manual / not installed | on demand — see `doc/design/002-ui-module-install.md` |
| Figma MCP | manual / not installed | `mcp_get_tools` in the session |
| `doc/design/002-ui-module-install.md` | ✅ | `test -f doc/design/002-ui-module-install.md` |
| `doc/design/003-ui-stack-adapters.md` | ✅ | `test -f doc/design/003-ui-stack-adapters.md` |

## Probity Module

| Component | Status | Verify with |
|-----------|--------|-------------|
| `@nizos/probity@1.10.0` | SKIP — hub DOCS_SPECS (without test runner) | `test -f probity.config.ts` |
| `probity.config.ts` | SKIP | `grep -q enforceTdd probity.config.ts` |
| Plugin / hook | SKIP | Claude Code: `/plugin install probity@probity` |
| `sdd-kit/install-probity-module.sh` | ✅ (kit) | `test -x sdd-kit/install-probity-module.sh` |

Optional G2 module (APP/HYBRID with tests). Mandatory APP pilot before default activation — `openspec/changes/add-probity-tdd-module/piloto-nota.md`. Operation: guide §2.16 · `doc/design/004-probity-module-install.md`.

## SDD Metrics (G4)

| Component | Status | Verify with |
|-----------|--------|-------------|
| `scripts/sdd-metrics.sh` | ✅ | `test -x scripts/sdd-metrics.sh` |
| On-demand report (mode C) | ✅ | `bash scripts/sdd-metrics.sh --help` |

Local script (git + `openspec/changes/archive/`) — do **not** adopt Apache DevLake. Operation: `doc/byebyevibe-guide.md` §2.17.

## Docs language / i18n

| Component | Status | Verify with |
|-----------|--------|-------------|
| `scripts/verify-i18n-wave.sh` | ✅ | `test -x scripts/verify-i18n-wave.sh` · `bash scripts/verify-i18n-wave.sh --help` |
| `doc/i18n/GLOSSARY.md` · `WAVES.md` · `WAVE-PROPOSAL-TEMPLATE.md` | ✅ | `test -s doc/i18n/GLOSSARY.md` |

Mode C for translation waves (not a blocking `sdd-gates` step by default). Capability: `sdd-docs-language`.

## Env vars (names only)

> Read from `.env.example` when present. **Never** commit values or read `.env`.

| Variable | Present | Verify with |
|----------|---------|-------------|
| <!-- env-list -->_(no .env.example in repo)_<!-- /env-list --> | — | `scripts/verify-infra.sh` |

## Agent rule

- **R10** (`AGENTS.md`): read this manifest before installing/reinstalling MCP, CLIs, plugins, or skills.
- **✅** = use directly; do **not** reinstall or web-search for setup.
- **❌** or `[NEEDS VERIFICATION]` = run `bash scripts/verify-infra.sh` or ask the operator.
- **`declined`** = durable refusal: the operator considered this integration and refused it. Do **not** re-suggest it — use the remaining cascade rungs (CLI/MCP if configured, else manual instructions). `verify-infra.sh` suppresses `declined` rows from the tooling gap-check.
- **Stale:** if verification is >30 days old, treat as `[STALE >30d]` until re-verified.

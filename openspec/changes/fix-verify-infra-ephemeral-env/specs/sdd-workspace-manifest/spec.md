## MODIFIED Requirements

### Requirement: Infrastructure verification script

The repository MUST have `scripts/verify-infra.sh` — an idempotent script that checks SDD stack (OpenSpec, GitNexus, Graphify), MCP registration (names only), and env var presence (from `.env.example`, without reading `.env` values). The script MUST update verification timestamps in `openspec/infra.md` or print instructions to update them. The script MUST additionally report a tooling gap-check: presence/absence of MCP configuration files (`.mcp.json`, `.cursor/mcp.json`), availability on `PATH` of CLIs listed in the manifest, and key names present in `.env.example` — reporting absence only, never inferring which integrations the project should have. A commented-out key in `.env.example` MUST be reported as "considered and declined", not as a gap.

The script MUST write to `openspec/infra.md` only when running interactively (stdout is a TTY) or when passed an explicit `--write` flag. A non-interactive run without `--write` MUST be report-only: it prints its findings with a notice naming the `--write` flag, leaves `openspec/infra.md` byte-identical, and exits 0 (advisory) regardless of check outcomes. Interactive runs keep the authoritative behaviour: markers updated and a non-zero exit when core checks fail.

CLI presence checks MUST be resolved by `PATH` lookup (`command -v` or equivalent) and MUST NOT trigger package-registry resolution or downloads. Additional detail (installed version, GitNexus index freshness) MUST be collected only when the binary is present, by invoking it directly.

#### Scenario: Operator runs verification

- **WHEN** the operator runs `bash scripts/verify-infra.sh` at an interactive terminal
- **THEN** the script updates `openspec/infra.md` markers, reports ✅/❌ for each checked item, and exits 0 when core SDD tools are operational

#### Scenario: Non-interactive run leaves the manifest untouched

- **WHEN** `bash scripts/verify-infra.sh` runs with stdout not attached to a TTY (CI runner, remote agent sandbox) and without `--write`
- **THEN** `openspec/infra.md` is byte-identical after the run, the output carries a report-only notice naming `--write`, and the exit code is 0

#### Scenario: Explicit write from a non-interactive caller

- **WHEN** `bash scripts/verify-infra.sh --write` runs without a TTY (operator cron job, bootstrap post-install)
- **THEN** `openspec/infra.md` markers are updated exactly as in an interactive run

#### Scenario: Missing CLI is reported offline

- **WHEN** the `openspec` binary is absent from `PATH` and the script runs
- **THEN** the OpenSpec row reports ❌ without any npm-registry lookup or package download occurring

#### Scenario: Post-install bootstrap

- **WHEN** SDD bootstrap completes (`scripts/bootstrap-sdd.sh` or manual §2.8 checklist)
- **THEN** `openspec/infra.md` is created or updated with initial ✅ states for installed components

#### Scenario: Gap-check reports absence without inference

- **WHEN** `bash scripts/verify-infra.sh` runs in a repo with no `.mcp.json` and no `.env.example`
- **THEN** the output states exactly that (config files absent) without recommending specific integrations

#### Scenario: Commented key is not a gap

- **WHEN** `.env.example` contains a commented-out key name
- **THEN** the gap-check reports it as considered-and-declined rather than missing

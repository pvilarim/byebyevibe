## MODIFIED Requirements

### Requirement: Preflight updates infra.md Preflight section only

When `openspec/infra.md` exists (or is created by install templates), `scripts/preflight-sdd.sh` MUST update a `## Preflight (last run)` section including timestamp, detected IDE(s), WARN summary, and advisory MCP names, using dedicated HTML comment markers. No other tool in the post-install verification path SHALL overwrite those preflight markers. Marker ownership is additionally scoped **per mode**: in `--repo` mode, the script MUST NOT overwrite host-derived markers (`preflight-ides`, `preflight-mcp`) — it SHALL update only the timestamp and WARN summary. Host-derived markers are written only by runs that executed host checks (`--host` or `--all`).

#### Scenario: Preflight stamps timestamp marker

- **WHEN** preflight completes successfully against a repo with `openspec/infra.md` containing Preflight markers
- **THEN** the `preflight-timestamp` marker value is updated to a non-placeholder timestamp

#### Scenario: verify-infra does not clear Preflight

- **WHEN** `bash scripts/verify-infra.sh` runs after a preflight stamp
- **THEN** the Preflight section markers remain intact (verify-infra updates SDD Stack markers only)

#### Scenario: Repo-mode run preserves host stamp

- **WHEN** `bash scripts/preflight-sdd.sh --all` stamped `preflight-ides` with detected IDEs, and later `bash scripts/preflight-sdd.sh --repo` runs (e.g. invoked by `sdd-kit/install.sh`)
- **THEN** the `preflight-ides` and `preflight-mcp` marker values from the `--all` run remain unchanged, while `preflight-timestamp` reflects the repo-mode run

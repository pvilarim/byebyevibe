# Proposal: fix-install-audit-findings

**Issue:** — (originated from `/opsx:explore` install audit, 2026-08-01)

## Why

An adversarial audit of the installation chain (`bootstrap-sdd.sh` → `preflight-sdd.sh` → `install.sh` → `verify.sh` → `upgrade.sh` + UI/Probity modules) confirmed nine logic/ordering bugs and one unguarded hub-consistency gap. Two of them leave an operator with a half-installed repo and a recovery instruction that does not work; two more produce silent no-op "success" — the worst failure mode for an install kit whose whole point is deterministic, verifiable setup.

## What Changes

- **bootstrap-sdd.sh — profile detection ordering**: capture the HYBRID/APP/DOCS_SPECS hint **before** `openspec init` runs (reuse the phase-0 preflight hint), eliminating the spurious HYBRID WARN that today fires on every APP bootstrap because `openspec init` itself creates `openspec/`.
- **bootstrap-sdd.sh — wrong recovery instruction**: the HYBRID WARN tells the operator to "pass 'APP' … as 1st argument", but the 1st positional is `REPO_PATH`. Add a real `--profile` flag to bootstrap and fix the message.
- **bootstrap-sdd.sh — Graphify phase resilience**: make the Graphify phase failure-tolerant like GitNexus (WARN + continue to kit install instead of `set -e` abort mid-chain), and export `~/.local/bin` onto `PATH` after installing `uv` so `uv tool install` does not fail immediately in the very scenario the curl-install was added for.
- **install.sh / upgrade.sh — profile validation**: validate `--profile` against `APP|DOCS_SPECS|HYBRID` at parse time. Today an invalid profile plus `--skip-preflight` copies zero files and exits 0 ("Done."); `upgrade.sh --apply --profile FOO` prints "Apply complete" having applied nothing.
- **preflight-sdd.sh — stamp ownership by mode**: in `--repo` mode, do not overwrite host-derived markers (`preflight-ides`, `preflight-mcp`) — today every `install.sh` run downgrades `IDE(s)` to `none` and MCP to `—`, erasing the last real `--all` result.
- **install.sh — dry-run purity**: remove the duplicate `chmod +x` in the main loop that executes even under `--dry-run`.
- **install-probity-module.sh — honest status**: only write `✅` when the npm package was actually installed; use a package-level verify command (`node -e "require.resolve('@nizos/probity')"` or npm ls) for the package row instead of `test -f probity.config.ts`.
- **install-ui-module.sh — honest Impeccable status**: derive status from the actual install outcome (`.cursor/skills/impeccable` present) instead of the `--yes && node>=24` proxy, covering the interactive-yes path that today stays "pending" forever.
- **gen-manifest-checksums.sh — argument hygiene**: reject unknown arguments and add `--help`; today any typo silently rewrites `MANIFEST.yaml`.
- **verify.sh — hub drift gate**: add a hub-only parity check comparing live `scripts/*.sh` against `sdd-kit/templates/scripts/*.sh`; drift confirmed today in both directions (`verify-task-patterns.sh` live newer than template; `sdd-upgrade-diff.sh` template newer than live).

Out of scope (recorded, deferred): `min_openspec` enforcement at bootstrap, macOS `realpath` portability, MERGE-file update tooling, Cursor-only MCP detection, upgrade approval grep robustness, monorepo UI-stack detection, YAML-parser consolidation.

## Capabilities

### New Capabilities

(none)

### Modified Capabilities

- `sdd-install-kit`: install/upgrade MUST reject invalid profiles (no silent no-op); dry-run MUST be side-effect free; checksum generator MUST reject unknown args; hub verify MUST gate live-scripts↔templates parity; bootstrap MUST capture the profile hint before `openspec init`, accept `--profile`, and treat Graphify failures as non-fatal (WARN + continue).
- `sdd-install-preflight`: `--repo` mode MUST NOT overwrite host-derived Preflight markers (IDE/MCP) — marker ownership becomes per-mode, not per-script only.
- `sdd-probity-module`: infra status for the npm package MUST reflect actual package installation, with a package-level verify command.
- `sdd-ui-module`: Impeccable infra status MUST reflect the actual install outcome regardless of interactive vs `--yes` path.

## Impact

- **Scripts (hub + kit templates, pairwise)**: `scripts/bootstrap-sdd.sh`, `scripts/preflight-sdd.sh`, `sdd-kit/install.sh`, `sdd-kit/upgrade.sh`, `sdd-kit/verify.sh`, `sdd-kit/gen-manifest-checksums.sh`, `sdd-kit/install-probity-module.sh`, `sdd-kit/install-ui-module.sh`, and their `sdd-kit/templates/` counterparts where they exist.
- **MANIFEST.yaml**: sha256 fields regenerated after template edits (`gen-manifest-checksums.sh`).
- **Docs**: `doc/sistema-sdd-pedro.md` §2 touch-ups only where behavior described changes (bootstrap `--profile`, Graphify tolerance).
- No runtime/app code; DOCS_SPECS hub profile — all changes are shell/docs within this repo.

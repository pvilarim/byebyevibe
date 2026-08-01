# Design — fix-install-audit-findings

## Context

See proposal.md — Why. All findings live in shell scripts that exist in up to two copies (hub live `scripts/` / kit `sdd-kit/templates/scripts/`) plus kit-root scripts (`sdd-kit/*.sh`) that have template counterparts under `sdd-kit/templates/` for consumer distribution. Any edit to a template requires regenerating `MANIFEST.yaml` sha256 fields (`gen-manifest-checksums.sh`), or `verify.sh` kit-integrity fails. The hub is DOCS_SPECS: no app code, gates are shell-level (`sdd-gates.yml` runs `openspec validate --all --strict` + `verify-task-patterns.sh`).

Constraints that shape the approach:

- `set -euo pipefail` everywhere — tolerance must be explicit (`|| { …; }` or `if !`), never accidental.
- `bash 3.2` compatibility is not required (scripts already use `${var,,}`-free but arrays etc.); keep to existing idiom.
- Preflight marker ownership is already normative (`sdd-install-preflight`); this change refines it per-mode without breaking the existing "verify-infra must not touch preflight" rule.
- The drift found today (`verify-task-patterns.sh` live > template; `sdd-upgrade-diff.sh` template > live) must be reconciled **before** the new parity gate lands, or the gate fails on arrival.

## Goals / Non-Goals

**Goals:**

- Eliminate the two silent no-op success paths (invalid profile in install/upgrade).
- Make bootstrap survivable: correct profile hint timing, real `--profile` flag, Graphify tolerance, uv PATH fix.
- Make preflight `--repo` stamp non-destructive to host markers.
- Honest module status in infra.md (Probity package row, Impeccable row).
- Arg hygiene in `gen-manifest-checksums.sh`; dry-run purity in `install.sh`.
- Hub drift gate in `verify.sh` + reconcile current drift.

**Non-Goals:**

- No `min_openspec` enforcement at bootstrap (deferred; interacts with CI pin policy — separate change).
- No macOS/BSD `realpath` portability work.
- No MERGE-file update tooling; no YAML-parser consolidation; no multi-IDE MCP detection.
- No behavior change to C1 tool order (OpenSpec → GitNexus → Graphify → kit) — explicitly preserved.

## Decisions

**D1 — Profile hint: snapshot before init, in a variable.** Capture `PRE_INIT_HAD_OPENSPEC=$([[ -d openspec ]] && echo true || echo false)` before the OpenSpec phase and use it in the kit-install phase's HYBRID test. Alternative considered: reuse the preflight `profile-hint` result — rejected because preflight can be skipped (`--skip-preflight`) and its output isn't machine-parsed by bootstrap; a local snapshot is 2 lines and has no coupling.

**D2 — `--profile` on bootstrap propagates, never re-detects.** When set, skip detection entirely and pass through to `install.sh`. Validation duplicated at bootstrap parse time (fail before phase 0) even though `install.sh` will validate again — failing early is the point.

**D3 — Graphify tolerance mirrors the GitNexus block.** Wrap the whole Graphify phase in a single `if`-guarded group emitting one WARN on failure. The uv PATH fix is `export PATH="$HOME/.local/bin:$PATH"` immediately after the curl installer runs (idempotent; only when uv was just installed). Alternative: source the installer's `env` file — rejected, path varies by installer version.

**D4 — Profile validation is one shared `case` per script.** Same allowlist string in `install.sh`, `upgrade.sh`, `bootstrap-sdd.sh` (`APP|DOCS_SPECS|HYBRID`). No shared lib — these scripts must run standalone in consumer repos where only some of them exist.

**D5 — Preflight stamp per mode: skip host markers in `--repo`.** `stamp_infra` receives the mode; when mode is `repo`, call `replace_between` only for `preflight-timestamp` and `preflight-warns`. Alternative: separate repo-timestamp marker — rejected as marker sprawl; the spec keeps one timestamp meaning "last preflight run of any mode".

**D6 — Probity package status from ground truth.** After the npm step, test `grep -q '"@nizos/probity"' package.json` (devDependencies) to decide ✅ vs `pending` for the package row; config row keeps `test -f probity.config.ts`. The infra table's verify command for the package row becomes `grep -q '@nizos/probity' package.json`. Alternative `node -e require.resolve` — rejected: requires node_modules install state, noisier in CI.

**D7 — Impeccable status from ground truth.** Single decision point after `maybe_install_impeccable`: `[[ -d .cursor/skills/impeccable ]] → ✅ else pending/SKIP`. Removes the duplicated `update_infra_md "✅"` call keyed on `--yes && node>=24`.

**D8 — Drift gate lists pairs, compares with `diff -q`.** In `verify.sh` hub block, iterate `sdd-kit/templates/scripts/*.sh`, compare each against `scripts/<basename>` when the live file exists; any difference is a FAIL. Reconcile existing drift in this change: port the live `verify-task-patterns.sh` (newer — archive resolution) into the template; port the template `sdd-upgrade-diff.sh` (newer — TSV/source-aware parsing) into the live script. Then regenerate MANIFEST checksums.

**D9 — Dry-run purity by deletion.** The loop-level `chmod` in `install.sh` (after `apply_file`) is redundant with the one inside `apply_file` (which is already dry-run-guarded); delete the loop-level one rather than guarding it.

**D10 — gen-manifest-checksums.sh gets a standard arg loop.** `--check` and `--help` accepted; anything else → usage + exit 2. Matches the parse idiom of the other kit scripts.

## Risks / Trade-offs

- [Template edits without checksum regen break kit-integrity] → task explicitly regenerates via `gen-manifest-checksums.sh` and re-runs `verify.sh` as its gate.
- [Drift reconciliation (D8) may alter behavior of `sdd-upgrade-diff.sh` for hub users] → the newer template version is what consumers already receive; aligning the hub to it is convergence, not new behavior. Diff review in PR covers it.
- [Graphify tolerance could mask a genuinely broken host] → preflight already FAILs on missing python3; the WARN names the failed step and the guide §2 covers manual Graphify install; net risk accepted (same posture as GitNexus).
- [Per-mode stamping means a stale IDE list can outlive an IDE uninstall] → acceptable: the field is advisory; `--all` refresh remains the documented path.
- [bootstrap `--profile` adds a second source of truth vs install.sh detection] → mitigated by pass-through (bootstrap never re-detects when the flag is present).

## Migration Plan

Single PR on the designated branch; no consumer migration needed (consumers pick fixes up at next C2 upgrade — all touched consumer-visible files are `merge: COPY` except `sdd-upgrade-diff.sh` (MERGE), whose reconciliation only affects the hub copy). Rollback = revert the PR; no state or data involved.

## Open Questions

(none)

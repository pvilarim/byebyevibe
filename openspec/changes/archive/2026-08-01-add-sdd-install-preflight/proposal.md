**Issue:** —

## Why

Guide §1 lists host and IDE prerequisites for humans, but C1 has **no automated phase-0 gate**. Failures appear mid-bootstrap (missing Node/Git, absent `sdd-kit/`, GitNexus native build) or only in post-install §2.8. Explore merge `explore-install-preflight` closed D1–D4: add preflight so install runs in logical sequence with fewer stops.

## What Changes

- **New `scripts/preflight-sdd.sh`** (kit template + MANIFEST): `--host`, `--repo`, `--all`, optional `--json`; result levels FAIL | WARN | SKIP.
- **`bootstrap-sdd.sh`:** run full preflight at start; **`--skip-preflight`** for legacy/CI.
- **`install.sh`:** **repo-only** gate when standalone (`sdd-kit/` present, writable, profile hints); does **not** repeat full host scan (bootstrap already did, or operator chose Path B with repo gate only).
- **`openspec/infra.md` template:** new `## Preflight (last run)` section updated **only** by preflight; `verify-infra.sh` keeps updating SDD Stack post-install and MUST NOT overwrite Preflight.
- **Spec `sdd-install-preflight`:** FAIL/WARN/SKIP matrix (GitNexus build tools WARN + escape paths; IDE advisory WARN; github-mcp advisory).
- **Guide §1 + §2.0 / §2.1:** document phase 0 before OpenSpec → GitNexus → Graphify → kit.
- **Optional soft check** in `verify.sh`: warn if Preflight section never stamped (non-blocking).

## Capabilities

### New Capabilities

- `sdd-install-preflight`: phase-0 host/repo/operator prerequisite checks before C1; CLI flags; FAIL/WARN/SKIP semantics; GitNexus build-tools WARN with escape paths; IDE detection advisory; infra.md Preflight section ownership.

### Modified Capabilities

- `sdd-install-kit`: ship `preflight-sdd.sh` via templates + MANIFEST; wire bootstrap full preflight + `--skip-preflight`; wire install.sh repo-only gate; infra.md template Preflight section.
- `sdd-post-install-verification`: clarify that `verify-infra.sh` updates SDD Stack only and does not overwrite Preflight; optional soft checklist/verify hint that preflight has been run.

## Impact

- **New:** `sdd-kit/templates/scripts/preflight-sdd.sh` → `scripts/preflight-sdd.sh`; guide phase-0 prose; spec `sdd-install-preflight`
- **Modified:** `bootstrap-sdd.sh` (hub + kit template); `sdd-kit/install.sh`; `sdd-kit/templates/openspec/infra.md` (+ hub `openspec/infra.md` section scaffold); optionally `verify.sh` / `verify-infra.sh` (guard against overwriting Preflight); `sdd-kit/MANIFEST.yaml` + checksums; guide §1 / §2.0–2.1
- **Non-goals:** auto-install MCPs/plugins during preflight; blocking C1 on github-mcp absence; evaluating MANIFEST `gate:` via eval (F-SEC-5); changing C1 pillar order (OpenSpec → GitNexus → Graphify → kit)
- **Checksums:** run `bash sdd-kit/gen-manifest-checksums.sh` when templates change
- **Sources:** `openspec/changes/explore-install-preflight/research.md` (D1–D4); guide §1, §2.0–2.8, §2.15; `sdd-kit/templates/scripts/bootstrap-sdd.sh`; `scripts/verify-infra.sh`; `openspec/specs/sdd-install-kit`, `sdd-post-install-verification`

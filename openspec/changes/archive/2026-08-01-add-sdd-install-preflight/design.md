## Context

C1 install today documents prerequisites in guide §1 but automates almost nothing before OpenSpec/GitNexus/Graphify/`install.sh`. Bootstrap only ensures `uv` for Graphify; GitNexus failures are WARN-and-continue; `install.sh` checks integrity/language, not host tools. Post-install is covered by `verify-infra.sh` / `verify.sh` (`sdd-post-install-verification`). Explore `explore-install-preflight` closed D1–D4 for a **phase 0 preflight**.

Constraints: DOCS_SPECS hub (scripts + guide + specs); F7 EN artifacts; F-SEC-5 (never `eval` MANIFEST `gate:`); preserve C1 pillar order; R10 infra already ✅.

Sources: `openspec/changes/explore-install-preflight/research.md`; `proposal.md`; guide §1, §2.0–2.8, §2.15; `sdd-kit/templates/scripts/bootstrap-sdd.sh`; `sdd-kit/install.sh`; `scripts/verify-infra.sh`; `openspec/specs/sdd-install-kit`, `sdd-post-install-verification`.

## Goals / Non-Goals

**Goals:**

- Ship `scripts/preflight-sdd.sh` with `--host`, `--repo`, `--all`, optional `--json`.
- Integrate full preflight into `bootstrap-sdd.sh` (opt-out `--skip-preflight`).
- Add repo-only gate to standalone `install.sh` without duplicating full host scan.
- Stamp `## Preflight (last run)` in `openspec/infra.md` from preflight only; keep `verify-infra.sh` on SDD Stack markers.
- Spec FAIL/WARN/SKIP matrix (GitNexus build tools WARN + escapes; IDE advisory; github-mcp advisory).
- Document phase 0 in guide §1 and §2.0 / §2.1 sequence.

**Non-Goals:**

- Auto-installing MCPs, plugins, or CLIs during preflight (except documenting that bootstrap still installs uv later).
- Blocking C1 when github-mcp is absent.
- Evaluating MANIFEST `gate:` via `eval` (F-SEC-5).
- Changing OpenSpec → GitNexus → Graphify → kit order.
- Making flock / network probes hard-FAIL for greenfield C1 (see D6).

## Decisions

### D1 — Script placement, flags, and call sites (explore D1)

| Artifact | Role |
|----------|------|
| `sdd-kit/templates/scripts/preflight-sdd.sh` | Canonical implementation; MANIFEST COPY → `scripts/preflight-sdd.sh` |
| Hub mirror | Same path under `scripts/` after install / for hub operators |
| Flags | `--host` \| `--repo` \| `--all` (default `--all` when no mode flag); optional `--json`; optional `--profile APP\|DOCS_SPECS\|HYBRID` for severity wording; `--repo-root PATH` (default `.`) |
| `bootstrap-sdd.sh` | After `cd` to repo, before OpenSpec: run `bash scripts/preflight-sdd.sh --all` (or kit-relative fallback if script not yet expanded); abort on FAIL; add `--skip-preflight` |
| `install.sh` | At start (after arg parse, before copy): run **repo-only** checks (`--repo`) unless `--skip-preflight`; never runs `--host` |

**Bootstrap → install handoff:** install is always repo-scoped. Full host scan is bootstrap’s job. Path B (install-only) gets repo FAIL/WARN without requiring Node/Git re-check (operator may already have CLIs; missing `sdd-kit/` still FAILs).

**Script discovery in bootstrap:** prefer `$REPO/scripts/preflight-sdd.sh`; else `$REPO/sdd-kit/templates/scripts/preflight-sdd.sh` (hub / pre-expand). If neither exists and not `--skip-preflight`, FAIL with message to copy kit from hub.

### D2 — Result levels and host/repo matrix

| Level | Exit impact | Examples |
|-------|-------------|----------|
| **FAIL** | non-zero; abort caller | missing `git`, `node`/`npm`, Node &lt; 20.19, missing `python3` (&lt; 3.10), missing/unreadable `sdd-kit/`, repo root not writable |
| **WARN** | zero (continue); message required | missing build tools; missing `uv`; no IDE; no github-mcp in mcp.json; ambiguous HYBRID hints |
| **SKIP** | zero; note only | Probity/UI module checks when not requested; profile-irrelevant optional modules |

`--json` emits a machine-readable summary of checks `{id, level, message}` plus overall status; human lines still go to stderr when useful.

### D3 — GitNexus build tools (explore D2)

Absence of Linux `make`+`g++` (or macOS Xcode CLT heuristic) is **WARN**, never FAIL.

Message MUST list all three escapes:

1. Install build tools (`python3 make g++` / Xcode CLT)
2. `export GITNEXUS_SKIP_OPTIONAL_GRAMMARS=1`
3. Defer GitNexus via C2b §2.9.4

Severity text: **DOCS_SPECS** = normal WARN; **APP/HYBRID** = strong WARN (“code map / impact analysis may be unavailable”).

Aligns with current bootstrap GitNexus WARN-and-continue.

### D4 — IDE + MCP advisory (explore D3)

Detection cascade per tool:

1. `command -v cursor` / `code` / `claude`
2. Directory fallback: `$HOME/.cursor/`, `$HOME/.claude/`
3. None → WARN (not FAIL): `/opsx:*` unavailable until Cursor or Claude Code is installed

MCP: read `~/.cursor/mcp.json` names only (same privacy rule as verify-infra). Absence of github-mcp → WARN advisory (mode D, §2.15) — never FAIL.

### D5 — infra.md Preflight ownership (explore D4)

Add to `sdd-kit/templates/openspec/infra.md` (and hub scaffold):

```markdown
## Preflight (last run)

> Updated only by `scripts/preflight-sdd.sh` — `verify-infra.sh` must not overwrite this section.

| Field | Value |
|-------|-------|
| Timestamp | <!-- preflight-timestamp -->—<!-- /preflight-timestamp --> |
| IDE(s) | <!-- preflight-ides -->—<!-- /preflight-ides --> |
| WARN summary | <!-- preflight-warns -->—<!-- /preflight-warns --> |
| MCP names (advisory) | <!-- preflight-mcp -->—<!-- /preflight-mcp --> |
```

Preflight updates those four markers (create section if missing). `verify-infra.sh` continues using existing markers (`openspec-*`, `gitnexus-*`, `graphify-*`, `mcp-list`, kit-*) and MUST NOT write `preflight-*` markers. Document this in script header comments.

### D6 — Soft edges: flock, network, verify soft-warn

| Check | Level | Rationale |
|-------|-------|-----------|
| `flock` missing (Linux) | WARN | Needed for local apply R11, not for C1 copy |
| Outbound network | optional soft WARN or omit hard probe in v1 | Flaky in CI/offline; bootstrap/npm will fail loudly later |
| `verify.sh` “preflight never ran” | soft WARN, non-blocking | If Preflight timestamp still `—` / empty |

### D7 — Guide documentation

- §1: point operators to `bash scripts/preflight-sdd.sh --all` (and kit path) as automated check of the tables.
- §2.0 / §2.1 order: insert **phase 0 — Preflight** before step 1 OpenSpec; update AI install prompt to run preflight first (or rely on bootstrap).
- §2.8 optional soft checklist line for Preflight section stamped (non-blocking).

### D8 — MANIFEST / versioning

- Add MANIFEST entry for `scripts/preflight-sdd.sh` (COPY, all profiles), `gate:` as documentation string only (e.g. `test -x scripts/preflight-sdd.sh`) — never eval’d.
- Bump kit/guide version only if apply session also ships guide changelog (apply decides patch bump vs docs-only); propose does not force a version number beyond documenting the need.

## Risks / Trade-offs

| Risk | Mitigation |
|------|------------|
| Double-check friction (bootstrap + install) | install is repo-only; cheap; `--skip-preflight` on both |
| False FAIL on exotic Node version parsers | Use simple `node -v` major.minor compare; document minimum 20.19.0 |
| infra.md section drift / verify-infra overwrite | Distinct markers; verify-infra MUST NOT touch `preflight-*` |
| Bootstrap before kit expand can’t find script | Fallback to `sdd-kit/templates/scripts/preflight-sdd.sh` |
| Operators skip preflight in CI | Explicit `--skip-preflight`; soft verify warn only |
| Strong WARN ignored on APP | Message lists impact + three escapes; still non-blocking like today |

## Migration Plan

1. Land template script + MANIFEST + checksums; hub mirror `scripts/preflight-sdd.sh`.
2. Wire bootstrap/install flags; update infra template + hub section.
3. Guide §1 / §2.0–2.1 / soft §2.8.
4. Consumers: C2 upgrade or copy script; existing installs gain preflight on next bootstrap/upgrade.
5. Rollback: remove MANIFEST entry, hooks, section, guide paragraphs; no data migration.

## Open Questions

None blocking — D1–D4 closed in explore; D5–D8 are apply-level refinements of those decisions.

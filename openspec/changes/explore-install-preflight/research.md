# Research: SDD install preflight (explore merge)

> **Status:** Explore complete — ready for `/opsx:propose add-sdd-install-preflight`
> **Sources:** `doc/sistema-sdd-pedro.md` §1, §2.0–2.8, §2.15; `sdd-kit/templates/scripts/bootstrap-sdd.sh`; `scripts/verify-infra.sh`; `openspec/specs/sdd-post-install-verification/spec.md`; `openspec/specs/sdd-install-kit/spec.md`

## Problem

Prerequisites are documented in guide §1 for human reading, but there is **no automated pre-install gate**. Failures surface mid-bootstrap (missing Node, missing `sdd-kit/`, GitNexus native build failure) or only in post-install checklist §2.8. Goal: **phase 0 preflight** so C1 runs in logical sequence with fewer stops.

## AS-IS

| Layer | What it checks | When | Blocking? |
|-------|----------------|------|-----------|
| Guide §1 | OS, Node, Python, Git, IDE | Manual read | No |
| `bootstrap-sdd.sh` | `uv` only; HYBRID profile WARN | During bootstrap | GitNexus → WARN + continue |
| `install.sh` | sha256, path traversal, language | During C1 | Yes (integrity/lang) |
| `install-ui-module.sh --detect` | frontend, UI stack, Node major | Pre C1-UI | Informative |
| `install-probity-module.sh --detect` | test runner | Pre G2 | Informative |
| `verify-infra.sh` | CLIs, MCP names, session, kit | Post-install | Yes (core SDD) |
| `sdd-kit/verify.sh` | orchestrates post-install checks | Post-install | Yes |

**Gap:** No capability `sdd-install-preflight`. Post-install is covered by `sdd-post-install-verification`; pre-install is not.

## Host prerequisites (common)

| Requirement | Used by | C1 blocking? |
|-------------|---------|--------------|
| Git 2.40+ | GitNexus, Graphify hooks, session, G4 | **Yes** |
| Node ≥ 20.19.0 | OpenSpec, GitNexus (`npx`) | **Yes** |
| npm | global installs, CI | **Yes** |
| Python 3.10+ | Graphify, verify-infra, session uuid fallback | **Yes** (Graphify path) |
| Network outbound | npm, curl (uv), OAuth MCP | **Yes** on first install |
| uv (recommended) | Graphify (`uv tool install graphifyy`) | WARN → bootstrap installs |
| make/g++ or Xcode CLT | GitNexus tree-sitter | **WARN** (not FAIL) |
| flock (Linux) | session apply lock | **Yes** for local apply |

## Per-component requirements

### OpenSpec

- Node 20.19+; npm/npx
- Pin `@fission-ai/openspec@1.3.1` (`MANIFEST.min_openspec`)
- `openspec init --tools "cursor,claude"` → repo skeleton
- IDE for `/opsx:*` (operational, not script-blocking)
- `OPENSPEC_TELEMETRY=0` in CI/local (optional)

### GitNexus

- Node; `npm install -g gitnexus` (guide ≥ 1.4.8; hub 1.6.9)
- Git repo; build tools OR `GITNEXUS_SKIP_OPTIONAL_GRAMMARS=1`
- `gitnexus setup` → `~/.cursor/mcp.json` + skills
- Network for onnxruntime on first install (may fail → WARN today)

### Graphify

- Python 3.10+; uv recommended
- CLI `graphifyy` via `uv tool install graphifyy` (guide ≥ 0.8.4)
- `graphify hook install` needs git hooks
- `graphify update .` — AST, no API key required
- API key only for semantic `extract` (optional)

### sdd-kit / install.sh

- `sdd-kit/` present in target repo
- bash; sha256sum/shasum
- Profile explicit or detected (`package.json` / `openspec/`)
- `openspec/project.md` ideal after init (language policy)

### Post-kit (not C1 blocking)

| Module | Prerequisites |
|--------|----------------|
| Session R11 | session scripts, flock; CI exempt |
| sdd-gates CI | GHA, Node 22 + Python 3.13 on runner |
| Renovate | APP/HYBRID + `renovate.json` + GitHub App (manual) |
| github-mcp §2.15 | Cursor OAuth or Docker; advisory, fail-open |
| C1-UI | C1 complete; frontend; Node 24+ for Impeccable |
| Probity G2 | C1; vitest/jest/pytest |
| G4 metrics | git + archive |

## Recommended install sequence (with phase 0)

```
0a HOST     git, node≥20.19, npm, python3, uv?, build-tools?, network
0b REPO     sdd-kit/, writable, profile, partial SDD?
0c OPERATOR IDE detect + MCP names (advisory)
    │
1  OpenSpec init
2  GitNexus (WARN on native/network failure)
3  Graphify
4  install.sh
5  Curate AGENTS + restart IDE
6  MCP verify §2.6
7  verify.sh + checklist §2.8
8  Optional modules (--detect UI, Probity; github-mcp manual)
```

## Closed decisions (open questions)

### D1 — Preflight in bootstrap AND install.sh

| Script | Scope | Blocks? |
|--------|-------|---------|
| `preflight-sdd.sh` | `--host`, `--repo`, `--all` (optional `--json`) | FAIL on hard prerequisites |
| `bootstrap-sdd.sh` | calls full preflight at start | Yes |
| `install.sh` | repo-only: `sdd-kit/`, writable, profile hints | Yes when invoked standalone |
| `install.sh` | does not repeat full host checks if bootstrap already ran | — |

**Rationale:** Path B (`install.sh` only) is common; repo gate prevents mid-copy failures without duplicating full host scan.

### D2 — GitNexus without build tools → WARN with escape paths

- **DOCS_SPECS:** normal WARN
- **APP / HYBRID:** strong WARN (“code map missing — impact analysis unavailable”)
- Message MUST list:
  1. Install build tools (make/g++ or Xcode CLT)
  2. `export GITNEXUS_SKIP_OPTIONAL_GRAMMARS=1`
  3. Defer GitNexus via C2b §2.9.4

**Not FAIL** — aligns with current bootstrap behavior; avoids blocking minimal containers/WSL.

### D3 — IDE detection (advisory)

Cascade (first match wins for each IDE):

1. `command -v cursor` / `code` / `claude`
2. Fallback: `$HOME/.cursor/`, `$HOME/.claude/`
3. If none: `WARN: no IDE detected — /opsx:* unavailable until Cursor or Claude Code installed`

**Not FAIL** — scripts and CI run without IDE.

### D4 — `openspec/infra.md` Preflight section

Add `## Preflight (last run)` updated only by `preflight-sdd.sh`:

- timestamp
- detected IDE(s)
- host WARN/FAIL summary
- MCP server names from `~/.cursor/mcp.json` (advisory)

`verify-infra.sh` continues updating **SDD Stack** post-install only — do not overwrite Preflight section.

## MCP / plugins (phase 0c advisory)

| MCP / plugin | Required C1? | Check |
|--------------|--------------|-------|
| OpenSpec commands | Yes (repo) | `.cursor/commands/opsx-*` post-init |
| GitNexus MCP | Yes (operator) | after `gitnexus setup` |
| Graphify hook/skill | Yes (repo) | `graphify install` |
| github-mcp | No (mode D) | mcp.json — advisory |
| Probity plugin | No (G2) | `install-probity --detect` |
| Impeccable | No (C1-UI) | `install-ui --detect` |

## Proposed deliverables (for propose)

1. `scripts/preflight-sdd.sh` (or `sdd-kit/preflight.sh` + MANIFEST entry)
2. `bootstrap-sdd.sh` — call preflight at start; `--skip-preflight` for legacy/CI
3. `install.sh` — repo-only gate when standalone
4. `openspec/infra.md` template — `## Preflight (last run)` section
5. Spec `sdd-install-preflight` — FAIL/WARN/SKIP matrix by profile
6. Guide §1 + §2.0 — document phase 0
7. `sdd-kit/verify.sh` — optional: warn if preflight never ran (soft, non-blocking)

## Result levels

| Level | Action | Examples |
|-------|--------|----------|
| **FAIL** | abort before install | no git, no node, no `sdd-kit/`, repo not writable |
| **WARN** | continue with message | no build tools, no IDE, no github-mcp, GitNexus skipped |
| **SKIP** | irrelevant for profile | Probity on DOCS_SPECS without tests |

## Out of scope

- Auto-installing MCPs or plugins during preflight
- Blocking C1 on github-mcp absence
- Evaluating MANIFEST `gate:` fields (F-SEC-5)

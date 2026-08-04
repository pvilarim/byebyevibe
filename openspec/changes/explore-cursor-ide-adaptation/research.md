# Research — Cursor IDE adaptation and IDE-conditional token monitoring

**Explore session:** 2026-08-04 · **Status:** exploration captured — no proposal triggered yet
**Scope question:** can this repo's Claude-Code-oriented tooling run equivalently in Cursor, and is it feasible to activate a local token-usage monitor (`local-token-monitor`) conditioned on which IDE is detected?

## Context

- The repo already runs a dual-IDE mirror: `.claude/skills/openspec-explore/SKILL.md` and `.cursor/skills/openspec-explore/SKILL.md` are byte-identical (`diff` = 0); `.cursor/commands/opsx-explore.md` vs `.claude/commands/opsx/explore.md` differ only in frontmatter (`name`, `tags`), not content. `openspec/infra.md` documents `.cursor/skills/*` as source and `.claude/skills/*` as "(mirror)".
- IDE detection already exists and is wired into the manifest: `scripts/preflight-sdd.sh:257-278` detects `cursor`/`claude` binaries on `PATH` and `~/.cursor`/`~/.claude` directories, writing the result into `openspec/infra.md` → Preflight table → `IDE(s)` field. This is the natural hook point for any future IDE-conditional behavior — the pattern (detect → record → offer, never auto-act) mirrors R10 and `sdd-tooling-guidance`.
- Two Claude-Code-specific mechanisms have **no discovered Cursor equivalent**: `.claude/settings.json` `PreToolUse` hooks (event-triggered context injection) and `.claude/agents/*.md` subagents (parallel research invocation in Type D flow). Cursor Rules (`always`/`agent-requested`/`manual`) are a different mechanism (static, not event-triggered), not a drop-in replacement.
- No prior evaluation of `local-token-monitor` or Cursor token-usage tooling exists under `doc/avaliacoes/`.

## Findings

### F1 — `local-token-monitor` is a passive local-log reader, tied to Claude Code's log format

Single-file Python (3.11+, stdlib only, `http.server`/`json`/`threading`), zero dependencies, zero network calls. It reads `~/.claude/projects/<project>/<session>.jsonl` — an append-only log Claude Code already writes with per-event token counts — and serves a local dashboard on `127.0.0.1:8099`. The author states the architecture is conceptually agnostic ("every agent CLI that writes usage to disk fits the same shape") but the parser today only understands Claude Code's JSONL shape. No Cursor support exists upstream.

### F2 — Cursor has no equivalent append-only local ledger with token counts

Cursor's local chat/session state lives in SQLite, not JSONL:
- Global: `~/Library/Application Support/Cursor/User/globalStorage/state.vscdb` (macOS path; `~/.config/Cursor/...` on Linux, `%APPDATA%\Cursor\...` on Windows)
- Per-workspace: `User/workspaceStorage/<md5-hash-of-project-path>/state.vscdb`
- Chat content sits in an `ItemTable` under keys like `aiService.prompts` and `workbench.panel.aichat.view.aichat.chatdata`.

This gives prompt/message content, but **not a reliable local token-usage ledger**.

### F3 — Two independent real-world tools confirm the gap, not just theory

- **tokscale** (junhoyeo): README states explicitly — *"Tokscale does not parse local Cursor Agent CLI state under `~/.cursor`, and it does not treat the desktop SQLite DB as a usage ledger."* It instead authenticates against Cursor's cloud API (extracting the session token from `state.vscdb`, `cursorAuth/accessToken`) and syncs usage into a local CSV cache. This is architecturally different from reading a local file — it requires network access and an auth token.
- **tokcat** (handlecusion): claims Cursor support but does not document the extraction mechanism beyond "reads the session token Cursor stores locally" for quota cards; optional backfill explicitly goes through the cursor.com API.
- Cursor's own community forum has an open feature request titled *"We need a deterministic way to attribute Cursor token usage to local IDE sessions, features, and subagents"* — i.e., users confirm this does not exist today as a built-in or reliably-derivable capability.

### F4 — Implication for adaptation

Porting `local-token-monitor`'s value proposition (offline, zero-dependency, zero-credential, pure local-file read) to Cursor is not a parser swap. The only working precedent (tokscale) abandoned local-file parsing entirely in favor of cloud-API sync with a stored session token — a different trust and privacy model (network call + credential vs. pure local read).

## Non-goals (this exploration)

- No decision to fork or extend `local-token-monitor` for Cursor.
- No decision to adopt an API-based token-tracking approach (network + credential) as part of this repo's tooling.
- No change to `sdd-kit/` payload or `infra.md` schema yet.

## Open questions for propose/design

- Primary interest: personal/local use only (path A — document manual usage, Claude-Code-only, informal), or should this become part of `sdd-kit` for future installs (path C — advisory row in `infra.md`, same treatment as `github-mcp-server`)? Changes scope significantly.
- If Cursor support is ever wanted, is an API-auth-based approach (tokscale-style) acceptable given this repo's stated preference for offline/credential-free tooling (R10, `050-security.mdc`)? Leaning: no, unless explicitly requested — the trade-off (network + stored session token) should not be adopted silently.
- Should `scripts/preflight-sdd.sh` / `verify-infra.sh` gain a new advisory row for "local usage/cost monitoring" tooling, following the same pattern as MCP servers (name, status, verify-with, never blocking)?

## Sources consulted

- `github.com/claudneysessa/local-token-monitor` (README, via WebFetch)
- `vibe-replay.com/blog/cursor-local-storage/` (via WebSearch summary — direct fetch returned HTTP 403)
- `github.com/junhoyeo/tokscale` (README, via WebFetch)
- `github.com/handlecusion/tokcat` (README, via WebFetch)
- Cursor community forum: "We need a deterministic way to attribute Cursor token usage to local IDE sessions, features, and subagents" (via WebSearch summary — direct fetch returned HTTP 403)
- Repo: `scripts/preflight-sdd.sh:257-278`, `openspec/infra.md`, `.claude/settings.json`, `.claude/agents/*.md`, `.cursor/skills/openspec-explore/SKILL.md` vs `.claude/skills/openspec-explore/SKILL.md` (diff)

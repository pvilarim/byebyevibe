# Tooling install — per-tool how-to

> Per-tool install guidance referenced from [`openspec/infra.md`](../openspec/infra.md) rows (mirrors the UI-module precedent, [`doc/design/002-ui-module-install.md`](./design/002-ui-module-install.md)). Status lives in the manifest; **how-to lives here**.
>
> **Entry pattern:** each entry prefers an **official-doc link** plus the **command that proves the install worked** over a transcribed step-by-step walkthrough (walkthroughs rot; official docs and a verify command survive upstream drift). Every entry carries a **"verified on YYYY-MM"** marker — re-verify and re-stamp when you touch an entry.
>
> Cascade context: agents resolve external-tool actions per `sdd-tooling-guidance` (override → CLI → MCP → suggest → manual). Nothing here is ever installed unprompted — the operator runs all steps. Keys go in `.env` (never committed); MCP servers only from trusted registries or official sources. After any install, run `bash scripts/verify-infra.sh` to record status in the manifest.

---

## github-mcp-server

- **What it is:** GitHub's official MCP server (repos, PRs, issues, CI) — used when no GitHub CLI is configured, or by preference. Note the cascade: a configured `gh` CLI is the cheaper default for occasional GitHub actions.
- **Official docs:** <https://github.com/github/github-mcp-server>
- **Modes:** remote (`https://api.githubcopilot.com/mcp/`, OAuth — no local install) or local binary (v1.7.0 at last verification) with a PAT.
- **Verify with:** MCP tools listed in the session (`mcp_get_tools`), or for the local binary: `github-mcp-server --help`. Manifest row: `openspec/infra.md` → MCP Servers.
- **Keys:** PAT in `.env` as a name-only entry mirrored in `.env.example` — never committed.
- *Verified on 2026-08.*

## Figma MCP (MCP-only exception exemplar)

- **What it is:** Figma's official MCP server delivering **structured design context** (component/variable/layout data) — a capability no Figma CLI delivers. This is the recorded per-tool exception where MCP is the *primary* rung, not the fallback: **key → CLI → MCP, unless only MCP delivers the capability** — and here only MCP does.
- **Official docs:** <https://developers.figma.com/docs/figma-mcp-server/>
- **Verify with:** MCP tools listed in the session (`mcp_get_tools` shows `Figma` / `figma` server), then a `get_design_context` call on a known file URL.
- **Keys/auth:** per official docs (desktop-app local server or remote OAuth); nothing stored in the repo.
- *Verified on 2026-08.*

---

## Adding an entry

Copy the shape above: **What it is** (one line, plus its place in the cascade) · **Official docs** (link, official source only) · **Verify with** (a command or check that proves it works) · **Keys** (name-only in `.env.example`; values in `.env`, never committed) · ***Verified on YYYY-MM***. No speculative catalog — add entries when a tool is actually considered or configured.

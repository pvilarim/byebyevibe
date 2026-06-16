# Workspace Infrastructure Manifest

> Última verificação: 2026-06-16 · Script: `scripts/verify-infra.sh`
>
> **Regra:** sem valores de secrets. Env vars listam apenas **nomes** e presença (✅/❌).

## SDD Stack (repo)

| Componente | Versão | Estado | Verificar com |
|------------|--------|--------|---------------|
| OpenSpec | <!-- openspec-version -->1.3.1<!-- /openspec-version --> | <!-- openspec-status -->✅<!-- /openspec-status --> | `npx openspec list` |
| GitNexus | <!-- gitnexus-version -->1.6.7<!-- /gitnexus-version --> | <!-- gitnexus-status -->✅<!-- /gitnexus-status --> | `npx gitnexus status` |
| Graphify | <!-- graphify-version -->—<!-- /graphify-version --> | <!-- graphify-status -->❌<!-- /graphify-status --> | `test -f graphify-out/GRAPH_REPORT.md` |

## MCP Servers

> Nomes apenas — auth dinâmica não é commitada. Confirmar com `mcp_get_tools` na sessão.

| Servidor | Estado | Verificar com |
|----------|--------|---------------|
| <!-- mcp-list -->[NEEDS VERIFICATION]<!-- /mcp-list --> | — | `~/.cursor/mcp.json` ou `mcp_get_tools` |

## Skills (repo)

| Path | Fase | Estado |
|------|------|--------|
| `.cursor/skills/openspec-explore/` | explore | ✅ |
| `.cursor/skills/openspec-propose/` | propose | ✅ |
| `.cursor/skills/openspec-apply-change/` | apply | ✅ |
| `.cursor/skills/openspec-archive-change/` | archive | ✅ |
| `.claude/skills/openspec-*/` | todas | ✅ (espelho) |
| `.claude/skills/gitnexus/` | impact/debug | ✅ |
| `.cursor/skills/simplify-review/` | review | ✅ |

## Env vars (nomes apenas)

> Lidos de `.env.example` se existir. **Nunca** commitar valores nem ler `.env`.

| Variável | Presente | Verificar com |
|----------|----------|---------------|
| <!-- env-list -->_(sem .env.example no repo)_<!-- /env-list --> | — | `scripts/verify-infra.sh` |

## Regra agentes

- **R10** (`AGENTS.md`): ler este manifesto antes de instalar/reinstalar MCP, CLIs, plugins ou skills.
- **✅** = usar directamente; **não** reinstalar nem web-search de setup.
- **❌** ou `[NEEDS VERIFICATION]` = correr `bash scripts/verify-infra.sh` ou perguntar ao operador.
- **Stale:** se verificação >30 dias, tratar como `[STALE >30d]` até re-verificar.

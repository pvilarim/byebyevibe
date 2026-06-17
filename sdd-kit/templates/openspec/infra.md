# Workspace Infrastructure Manifest

> Última verificação: YYYY-MM-DD · Script: `scripts/verify-infra.sh`
>
> **Regra:** sem valores de secrets. Env vars listam apenas **nomes** e presença (✅/❌).

## SDD Stack (repo)

| Componente | Versão | Estado | Verificar com |
|------------|--------|--------|---------------|
| OpenSpec | <!-- openspec-version -->—<!-- /openspec-version --> | <!-- openspec-status -->❌<!-- /openspec-status --> | `npx openspec list` |
| GitNexus | <!-- gitnexus-version -->—<!-- /gitnexus-version --> | <!-- gitnexus-status -->❌<!-- /gitnexus-status --> | `npx gitnexus status` |
| Graphify | <!-- graphify-version -->—<!-- /graphify-version --> | <!-- graphify-status -->❌<!-- /graphify-status --> | `test -f graphify-out/GRAPH_REPORT.md` |

## MCP Servers

> Nomes apenas — auth dinâmica não é commitada. Confirmar com `mcp_get_tools` na sessão.

| Servidor | Estado | Verificar com |
|----------|--------|---------------|
| <!-- mcp-list -->[NEEDS VERIFICATION]<!-- /mcp-list --> | — | `~/.cursor/mcp.json` ou `mcp_get_tools` |

## Skills (repo)

| Path | Fase | Estado |
|------|------|--------|
| `.cursor/skills/openspec-explore/` | explore | [NEEDS VERIFICATION] |
| `.cursor/skills/openspec-propose/` | propose | [NEEDS VERIFICATION] |
| `.cursor/skills/openspec-apply-change/` | apply | [NEEDS VERIFICATION] |
| `.cursor/skills/openspec-archive-change/` | archive | [NEEDS VERIFICATION] |

## Install Kit

| Artefacto | Versão | Estado | Verificar com |
|-----------|--------|--------|---------------|
| `sdd-kit/MANIFEST.yaml` | <!-- kit-version -->—<!-- /kit-version --> | <!-- kit-status -->❌<!-- /kit-status --> | `grep version sdd-kit/MANIFEST.yaml` |
| `sdd-kit/install.sh` | — | <!-- kit-install-status -->❌<!-- /kit-install-status --> | `test -x sdd-kit/install.sh` |
| `sdd-kit/verify.sh` | — | <!-- kit-verify-status -->❌<!-- /kit-verify-status --> | `bash sdd-kit/verify.sh` |

## Session Coordination

| Script | Função | Estado | Verificar com |
|--------|--------|--------|---------------|
| `scripts/sdd-session-register.sh` | Registo + flock apply | ❌ | `test -x scripts/sdd-session-register.sh` |
| `scripts/sdd-session-check.sh` | Validação antes de writes | ❌ | `bash scripts/sdd-session-check.sh --phase explore` |
| `scripts/sdd-session-status.sh` | Listar sessões activas | ❌ | `bash scripts/sdd-session-status.sh` |
| `scripts/sdd-session-release.sh` | Libertar lock/presença | ❌ | `test -x scripts/sdd-session-release.sh` |

Runtime local (gitignored): `.sdd/runtime/` (`apply.lock`, `sessions/*.json`).

## Env vars (nomes apenas)

| Variável | Presente | Verificar com |
|----------|----------|---------------|
| <!-- env-list -->_(sem .env.example no repo)_<!-- /env-list --> | — | `scripts/verify-infra.sh` |

## Regra agentes

- **R10** (`AGENTS.md`): ler este manifesto antes de instalar/reinstalar MCP, CLIs, plugins ou skills.
- **✅** = usar directamente; **não** reinstalar nem web-search de setup.
- **❌** ou `[NEEDS VERIFICATION]` = correr `bash scripts/verify-infra.sh` ou perguntar ao operador.

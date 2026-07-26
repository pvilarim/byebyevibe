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
| github-mcp-server (v1.7.0 local; remoto via `api.githubcopilot.com/mcp/`) | `[NEEDS VERIFICATION]` | `mcp_get_tools` ou `~/.cursor/mcp.json` |
| <!-- mcp-list -->outros MCPs<!-- /mcp-list --> | — | `~/.cursor/mcp.json` ou `mcp_get_tools` |

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

## CI Gates

| Componente | Estado | Verificar com |
|------------|--------|---------------|
| Workflow `sdd-gates` | [NEEDS VERIFICATION] | `test -f .github/workflows/sdd-gates.yml` |
| Template no kit | [NEEDS VERIFICATION] | `test -f sdd-kit/templates/.github/workflows/sdd-gates.yml` |
| Branch protection (required check) | `[AÇÃO MANUAL]` | guia §2.12 |

Fail-closed: `openspec validate`, `verify-task-patterns.sh`, **OSV-Scanner** (quando lockfile presente). Operação: guia §2.12.

## Supply Chain

| Componente | Estado | Verificar com |
|------------|--------|---------------|
| OSV-Scanner (CI) | [NEEDS VERIFICATION] | `grep -q 'OSV-Scanner (blocking)' .github/workflows/sdd-gates.yml` |
| Action SHA | `8dc09193bb540e09b23da07ad7e30bd33bf87018` (# v2.3.8) | `grep 8dc09193bb540e09b23da07ad7e30bd33bf87018 .github/workflows/sdd-gates.yml` |
| Renovate (`renovate.json`) | APP/HYBRID only | `test -f renovate.json` |
| Renovate GitHub App | `[AÇÃO MANUAL]` | guia §2.13 |

Operação: `doc/sistema-sdd-pedro.md` §2.13.

## UI Development Module

| Componente | Estado | Verificar com |
|------------|--------|---------------|
| UI stack | [NEEDS VERIFICATION] | `grep 'UI stack' openspec/project.md` |
| Impeccable | pending | `test -d .cursor/skills/impeccable` |
| Open Design | manual / not installed | sob demanda — ver doc/design/002 |
| Pencil | manual / not installed | sob demanda — ver doc/design/002 |
| Figma MCP | manual / not installed | `mcp_get_tools` na sessão |

## Probity Module

| Componente | Estado | Verificar com |
|------------|--------|---------------|
| `@nizos/probity@1.10.0` | SKIP até `--apply` em APP/HYBRID | `test -f probity.config.ts` |
| `probity.config.ts` | SKIP até `--apply` | `grep -q enforceTdd probity.config.ts` |
| Plugin / hook | SKIP | Claude Code: `/plugin install probity@probity` |
| `sdd-kit/install-probity-module.sh` | [NEEDS VERIFICATION] | `test -x sdd-kit/install-probity-module.sh` |

Módulo opcional G2 (APP/HYBRID com testes). DOCS_SPECS sem test runner: SKIP.
Operação: `doc/sistema-sdd-pedro.md` §2.16 · `doc/design/004-probity-module-install.md`.

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

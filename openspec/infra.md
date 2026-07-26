# Workspace Infrastructure Manifest

> Última verificação: 2026-07-26 · Script: `scripts/verify-infra.sh`
>
> **Regra:** sem valores de secrets. Env vars listam apenas **nomes** e presença (✅/❌).

## SDD Stack (repo)

| Componente | Versão | Estado | Verificar com |
|------------|--------|--------|---------------|
| OpenSpec | <!-- openspec-version -->—<!-- /openspec-version --> | <!-- openspec-status -->❌<!-- /openspec-status --> | `npx openspec list` |
| GitNexus | <!-- gitnexus-version -->1.6.9<!-- /gitnexus-version --> | <!-- gitnexus-status -->✅<!-- /gitnexus-status --> | `npx gitnexus status` |
| Graphify | <!-- graphify-version -->—<!-- /graphify-version --> | <!-- graphify-status -->❌<!-- /graphify-status --> | `test -f graphify-out/GRAPH_REPORT.md` |

## MCP Servers

> Nomes apenas — auth dinâmica não é commitada. Confirmar com `mcp_get_tools` na sessão.

| Servidor | Estado | Verificar com |
|----------|--------|---------------|
| github-mcp-server (v1.7.0 local; remoto via `api.githubcopilot.com/mcp/`) | `[NEEDS VERIFICATION]` | `mcp_get_tools` ou `~/.cursor/mcp.json` |
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
| `.claude/skills/correctness-review/` + `.cursor/skills/correctness-review/` | review | ✅ |

## Session Coordination

| Script | Função | Estado | Verificar com |
|--------|--------|--------|---------------|
| `scripts/sdd-session-register.sh` | Registo + flock apply | ✅ | `test -x scripts/sdd-session-register.sh` |
| `scripts/sdd-session-check.sh` | Validação antes de writes | ✅ | `bash scripts/sdd-session-check.sh --phase explore` |
| `scripts/sdd-session-status.sh` | Listar sessões activas | ✅ | `bash scripts/sdd-session-status.sh` |
| `scripts/sdd-session-heartbeat.sh` | Actualizar heartbeat | ✅ | `test -x scripts/sdd-session-heartbeat.sh` |
| `scripts/sdd-session-release.sh` | Libertar lock/presença | ✅ | `test -x scripts/sdd-session-release.sh` |

Runtime local (gitignored): `.sdd/runtime/` (`apply.lock`, `sessions/*.json`).

Regra always-on: `.cursor/rules/016-session-coordination.mdc`.

## Install Kit

| Artefacto | Versão | Estado | Verificar com |
|-----------|--------|--------|---------------|
| `sdd-kit/MANIFEST.yaml` | <!-- kit-version -->1.6.1<!-- /kit-version --> | <!-- kit-status -->✅<!-- /kit-status --> | `grep version sdd-kit/MANIFEST.yaml` |
| `sdd-kit/install.sh` | — | <!-- kit-install-status -->✅<!-- /kit-install-status --> | `test -x sdd-kit/install.sh` |
| `sdd-kit/install-ui-module.sh` | — | ✅ | `test -x sdd-kit/install-ui-module.sh` |
| `sdd-kit/install-probity-module.sh` | — | ✅ | `test -x sdd-kit/install-probity-module.sh` |
| `sdd-kit/upgrade.sh` | — | ✅ | `test -x sdd-kit/upgrade.sh` |
| `sdd-kit/verify.sh` | — | <!-- kit-verify-status -->✅<!-- /kit-verify-status --> | `bash sdd-kit/verify.sh` |

Fonte de payloads: `sdd-kit/templates/` (não extrair scripts do markdown §12). Ver `sdd-kit/README.md` para cenários C1–C3 e C1-UI.

## CI Gates

| Componente | Estado | Verificar com |
|------------|--------|---------------|
| Workflow `sdd-gates` | ✅ | `test -f .github/workflows/sdd-gates.yml` |
| Template no kit | ✅ | `test -f sdd-kit/templates/.github/workflows/sdd-gates.yml` |
| Branch protection (required check) | `[AÇÃO MANUAL]` — configurar no GitHub | guia §2.12 |

Fail-closed no `openspec validate --all --strict` (pinado `@fission-ai/openspec@1.3.1` = `min_openspec`), `verify-task-patterns.sh`, e **OSV-Scanner** quando lockfile presente. Sem skill/rule — automático out-of-band. Operação: `doc/sistema-sdd-pedro.md` §2.12.

## Supply Chain

| Componente | Estado | Verificar com |
|------------|--------|---------------|
| OSV-Scanner (CI) | ✅ | `grep -q 'OSV-Scanner (blocking)' .github/workflows/sdd-gates.yml` |
| Action SHA | `8dc09193bb540e09b23da07ad7e30bd33bf87018` (# v2.3.8) | `grep 8dc09193bb540e09b23da07ad7e30bd33bf87018 .github/workflows/sdd-gates.yml` |
| Renovate (`renovate.json`) | SKIP — hub DOCS_SPECS | `test -f renovate.json` (APP/HYBRID após install) |
| Renovate GitHub App | `[AÇÃO MANUAL]` — instalar em APP/HYBRID | guia §2.13 |

OSV corre no job `SDD Gates` quando há lockfile na raiz; SKIP explícito quando não há. Renovate: preset conservador via `sdd-kit/templates/renovate.json` (perfis APP/HYBRID). Operação: `doc/sistema-sdd-pedro.md` §2.13.

## UI Development Module

| Componente | Estado | Verificar com |
|------------|--------|---------------|
| UI stack | none (DOCS_SPECS hub) | `grep 'UI stack' openspec/project.md` |
| Impeccable | SKIP — hub sem frontend | `test -d .cursor/skills/impeccable` |
| Open Design | manual / not installed | sob demanda — ver `doc/design/002-ui-module-install.md` |
| Pencil | manual / not installed | sob demanda — ver `doc/design/002-ui-module-install.md` |
| Figma MCP | manual / not installed | `mcp_get_tools` na sessão |
| `doc/design/002-ui-module-install.md` | ✅ | `test -f doc/design/002-ui-module-install.md` |
| `doc/design/003-ui-stack-adapters.md` | ✅ | `test -f doc/design/003-ui-stack-adapters.md` |

## Probity Module

| Componente | Estado | Verificar com |
|------------|--------|---------------|
| `@nizos/probity@1.10.0` | SKIP — hub DOCS_SPECS (sem test runner) | `test -f probity.config.ts` |
| `probity.config.ts` | SKIP | `grep -q enforceTdd probity.config.ts` |
| Plugin / hook | SKIP | Claude Code: `/plugin install probity@probity` |
| `sdd-kit/install-probity-module.sh` | ✅ (kit) | `test -x sdd-kit/install-probity-module.sh` |

Módulo opcional G2 (APP/HYBRID com testes). Piloto APP obrigatório antes de activação default — `openspec/changes/add-probity-tdd-module/piloto-nota.md`. Operação: guia §2.16 · `doc/design/004-probity-module-install.md`.

## SDD Metrics (G4)

| Componente | Estado | Verificar com |
|------------|--------|---------------|
| `scripts/sdd-metrics.sh` | ✅ | `test -x scripts/sdd-metrics.sh` |
| Relatório sob demanda (modo C) | ✅ | `bash scripts/sdd-metrics.sh --help` |

Script local (git + `openspec/changes/archive/`) — **não** adoptar Apache DevLake. Operação: `doc/sistema-sdd-pedro.md` §2.17.

## Docs language / i18n

| Componente | Estado | Verificar com |
|------------|--------|---------------|
| `scripts/verify-i18n-wave.sh` | ✅ | `test -x scripts/verify-i18n-wave.sh` · `bash scripts/verify-i18n-wave.sh --help` |
| `doc/i18n/GLOSSARY.md` · `WAVES.md` · `WAVE-PROPOSAL-TEMPLATE.md` | ✅ | `test -s doc/i18n/GLOSSARY.md` |

Mode C for translation waves (not a blocking `sdd-gates` step by default). Capability: `sdd-docs-language`.

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

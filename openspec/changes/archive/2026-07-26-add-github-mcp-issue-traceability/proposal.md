## Why

Changes OpenSpec nascem de prompts directos sem ligação a GitHub Issues; a cadeia pedido → issue → change → PR não existe no sistema SDD hoje. Isso gera escopo mal calibrado, duplicação de fixes para o mesmo bug, e PRs sem rastreabilidade ao ticket original — identificado como gap G5 em `openspec/changes/explore-oss-coverage-gaps/research.md`.

## What Changes

- Documentar `github-mcp-server` (oficial GitHub) em `openspec/infra.md` e no template `sdd-kit/templates/openspec/infra.md` — MCP passivo (modo D), consultado em explore e propose; não intercepta edições
- Adicionar campo `**Issue:**` no template de `proposal.md` do sdd-kit (`sdd-kit/templates/openspec/changes/_template/proposal.md`), obrigatório mas aceitando `—` quando não há issue de origem
- Actualizar `AGENTS.md` (≤10 linhas) e template `sdd-kit/templates/AGENTS.core.md`: quando consultar github-mcp por tipo de tarefa (B/D/E), sem criar regra always-on
- Documentar operação humana em nova secção `doc/sistema-sdd-pedro.md` §2.14 (instalar MCP, escopos, verificar, desligar, troubleshooting)
- Actualizar avaliação G5 em `doc/avaliacoes/2026-07-25-oss-coverage-gaps-tooling.md` de "pendente" → "Adoptado"
- Bump de versão em `sdd-kit/MANIFEST.yaml` (1.4.0 → 1.5.0) e actualização de checksums quando templates mudarem
- Delta spec `sdd-issue-traceability`: normaliza convenção do campo Issue em proposals + acionamento MCP por tipo A–E

## Capabilities

### New Capabilities

- `sdd-issue-traceability`: Rastreabilidade issue → change → PR via campo `Issue:` em proposals e consulta passiva do github-mcp-server nos tipos B, D e E

### Modified Capabilities

- `sdd-workspace-manifest`: Adicionar entrada `github-mcp-server` na secção MCP Servers de `openspec/infra.md`

## Impact

- Ficheiros modificados: `openspec/infra.md`, `AGENTS.md`, `doc/sistema-sdd-pedro.md`, `doc/avaliacoes/2026-07-25-oss-coverage-gaps-tooling.md`, `sdd-kit/MANIFEST.yaml`
- Templates modificados: `sdd-kit/templates/openspec/infra.md`, `sdd-kit/templates/AGENTS.core.md`, `sdd-kit/templates/openspec/changes/_template/proposal.md` (novo)
- Novos ficheiros: `openspec/specs/sdd-issue-traceability/spec.md`
- Sem novas dependências de runtime; sem binário, hook ou consumo LLM autónomo — MCP passivo, consultado sob demanda pelo agente
- Piloto dispensável (excepção metodologia-insercao.md Fase 2): inserção apenas documenta MCP config + template inerte; sem binário/hook novo; confirmado no research G5
- Dependência: G1 (sdd-gates) já implementado — sem bloqueio; G7 fase 2 (PR-Agent) depende deste change como pré-requisito documental

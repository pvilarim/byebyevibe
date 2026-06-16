# Design — Session handoff e manifesto de infraestrutura

## Context

- O SDD stack (OpenSpec, GitNexus, Graphify) já está instalado no piloto `spec-pedro` com skills `/opsx:*`, `AGENTS.md`, e spec `sdd-post-install-verification`.
- Skills actuais terminam com prompts genéricos ("Run `/opsx:apply`") sem mandar novo chat.
- Infraestrutura global (MCP em `~/.cursor/mcp.json`, skills globais, auth IDE) não é visível ao agente numa sessão nova — causa reinstalações e web searches desnecessários.
- Workshop IA 5/2026 (Branas) reforça: janela de contexto deve ser limpa entre planeamento e execução.
- Constraint: `AGENTS.md` ≤150 linhas; detalhe vai para ficheiros sob demanda.

## Goals / Non-Goals

**Goals:**

- Handoff explícito e copiável no fim de cada fase SDD.
- Manifesto versionado `openspec/infra.md` como fonte de verdade para infra instalada.
- Script idempotente de verificação alinhado com §2.8.
- Regra R10 + rule always-on para comportamento consistente entre IDEs.

**Non-Goals:**

- Automatizar abertura de novo chat (limitação da IDE — só sugerir).
- Commitar estado de auth MCP dinâmico em tempo real (snapshot manual/script).
- Substituir `.env.example` — manifesto complementa, não duplica schema de env.
- Bloquear hard o utilizador que insiste em continuar no mesmo chat (sugestão forte, não gate).

## Decisions

| ID | Decisão | Rationale | Alternativa rejeitada |
|----|---------|-----------|----------------------|
| D1 | `openspec/infra.md` versionado no repo | Visível a qualquer agente no clone; ancora R2 (specs > …) | `infra.generated.md` gitignored — invisível a agentes frescos |
| D2 | Secção `Session Handoff` nas skills, não só no AGENTS.md | Skills são lazy-loaded na fase certa; AGENTS ficaria inflado | Só AGENTS.md — agente não vê no momento do handoff |
| D3 | Rule `015-session-phases.mdc` always-on (~15 linhas) | Reforço permanente; proíbe explore→apply | Só skill — fácil de ignorar em sessões longas |
| D4 | Handoff é sugestão forte, excepto explore→apply | Respeita autonomia do utilizador; explore→apply é o caso mais nocivo | Bloquear todas transições — friccção excessiva |
| D5 | `verify-infra.sh` actualiza timestamps, não reescreve tudo | Evita diff ruidoso; humano commita mudanças materiais | Auto-commit — viola controle humano |
| D6 | Espelhar skills em `.cursor/` e `.claude/` | Paridade Cursor/Claude Code já estabelecida no repo | Só Cursor — quebra Claude Code |
| D7 | Duas capabilities novas + delta em post-install | Separação clara handoff vs manifesto; checklist estendido | Uma spec monolítica — difícil reutilizar |

## Risks / Trade-offs

| Risco | Mitigação |
|-------|-----------|
| `infra.md` fica stale | Timestamp + `[STALE >30d]`; script verify-infra; item §2.8 |
| AGENTS.md ultrapassa 150 linhas | R10 em 2 linhas; detalhe em infra.md e skills |
| Utilizador ignora handoff | Rule + skill; benefício documentado no guia §3.4 |
| Manifesto não reflecte MCP global | Secção "MCP Servers" com nota "verificar com mcp_get_tools"; script lista nomes |
| Duplicação entre §2.8 e infra.md | §2.8 aponta para verify-infra.sh que popula infra.md |

## Migration Plan

1. Apply deste change: criar artefactos, rule, manifesto inicial, script, actualizar skills.
2. Correr `bash scripts/verify-infra.sh` para popular timestamps.
3. Actualizar `doc/sistema-sdd-pedro.md` §2.8, §3.4, template §12.2.
4. Commit + archive change.
5. Rollback: reverter ficheiros; remover rule 015; infra.md opcional (não quebra runtime).

## Open Questions

- Nenhuma crítica. Template de handoff pode ser refinado após uso real em 2–3 changes.

## Implementation Notes

### Session Handoff block (template partilhado)

Inserir no fim de cada skill `/opsx:*`:

```markdown
## Session Handoff

Esta fase terminou. **Sugestão: abrir novo chat** para a próxima fase (contexto limpo).

Cole no primeiro message do novo chat:

---
/<comando> <change-id>

Change: openspec/changes/<change-id>/
Ler: <artefactos relevantes>
Infra: openspec/infra.md (assumir ✅ — não reinstalar)
---
```

Variantes por fase:
- explore → `/opsx:propose`
- propose → `/opsx:apply`
- apply (done) → `/opsx:archive`
- apply (paused) → `/opsx:apply` (retomar)

### infra.md structure

```markdown
# Workspace Infrastructure Manifest
> Última verificação: YYYY-MM-DD · Script: scripts/verify-infra.sh

## SDD Stack | ## MCP Servers | ## Skills (repo) | ## Env vars (nomes) | ## Regra agentes
```

### verify-infra.sh checks

1. `npx openspec list` (exit 0)
2. `npx gitnexus status` (parse up-to-date)
3. `test -f graphify-out/GRAPH_REPORT.md`
4. List MCP server names (if `~/.cursor/mcp.json` readable)
5. Cross `.env.example` keys with presence check (no values)
6. Print summary; suggest updating infra.md timestamps

### Files to touch in apply

| Ficheiro | Acção |
|----------|-------|
| `.cursor/skills/openspec-*/SKILL.md` (×4) | + Session Handoff |
| `.claude/skills/openspec-*/SKILL.md` (×4) | espelho |
| `.cursor/commands/opsx-*.md` (×4) | espelho |
| `.claude/commands/opsx/*.md` (×4) | espelho |
| `.cursor/rules/015-session-phases.mdc` | criar |
| `openspec/infra.md` | criar |
| `scripts/verify-infra.sh` | criar |
| `AGENTS.md` | R10 + contexto (~8 linhas) |
| `doc/sistema-sdd-pedro.md` | §2.8, §3.4, §12.2 |

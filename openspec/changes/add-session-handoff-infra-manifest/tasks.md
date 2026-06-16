# Tasks — add-session-handoff-infra-manifest

## 1. Manifesto de infraestrutura

- [ ] 1.1 Criar `openspec/infra.md` com secções SDD Stack, MCP Servers, Skills, Env vars (nomes), Regra agentes
- [ ] 1.2 Criar `scripts/verify-infra.sh` idempotente (OpenSpec, GitNexus, Graphify, env presence)
- [ ] 1.3 Correr `bash scripts/verify-infra.sh` e actualizar timestamps em `openspec/infra.md`

## 2. Regras e AGENTS.md

- [ ] 2.1 Criar `.cursor/rules/015-session-phases.mdc` (alwaysApply, ~15 linhas)
- [ ] 2.2 Adicionar R10 (infra conhecida) e entrada `openspec/infra.md` na tabela Contexto sob demanda em `AGENTS.md`
- [ ] 2.3 Confirmar `AGENTS.md` ≤150 linhas após edição

## 3. Session Handoff nas skills (Cursor)

- [ ] 3.1 Adicionar secção `## Session Handoff` em `.cursor/skills/openspec-explore/SKILL.md`
- [ ] 3.2 Adicionar secção `## Session Handoff` em `.cursor/skills/openspec-propose/SKILL.md`
- [ ] 3.3 Adicionar secção `## Session Handoff` em `.cursor/skills/openspec-apply-change/SKILL.md`
- [ ] 3.4 Adicionar secção `## Session Handoff` em `.cursor/skills/openspec-archive-change/SKILL.md`
- [ ] 3.5 Espelhar handoff nos 4 ficheiros `.cursor/commands/opsx-*.md`

## 4. Session Handoff nas skills (Claude Code)

- [ ] 4.1 Espelhar secção Session Handoff nos 4 ficheiros `.claude/skills/openspec-*/SKILL.md`
- [ ] 4.2 Espelhar handoff nos 4 ficheiros `.claude/commands/opsx/*.md`

## 5. Documentação SDD

- [ ] 5.1 Actualizar `doc/sistema-sdd-pedro.md` §3.4 — gates `⊕ novo chat + handoff prompt` entre fases
- [ ] 5.2 Actualizar `doc/sistema-sdd-pedro.md` §2.8 — itens `openspec/infra.md` e `015-session-phases.mdc`
- [ ] 5.3 Actualizar template §12.2 com R10 e referência a `openspec/infra.md`

## 6. Validação e fecho

- [ ] 6.1 `npx openspec validate add-session-handoff-infra-manifest`
- [ ] 6.2 Verificar que skills propose/apply referem leitura de `openspec/infra.md` no início da fase
- [ ] 6.3 Commit com mensagem `docs(sdd): session handoff e infra manifest (add-session-handoff-infra-manifest)`

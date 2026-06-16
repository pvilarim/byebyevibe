# Proposal — Session handoff e manifesto de infraestrutura

## Why

Sessões longas que misturam explore, propose e apply no mesmo chat poluem a janela de contexto e degradam a qualidade da execução. Em paralelo, agentes reiniciados não sabem que MCPs, skills, CLIs, plugins e env vars já estão instalados — redescobrem ou inventam infraestrutura que o workspace já tem. Precisamos de handoffs explícitos entre fases e um manifesto versionado que o agente leia antes de propor instalações.

## What Changes

- Adicionar secção **Session Handoff** obrigatória no fim das skills/commands `/opsx:explore`, `/opsx:propose`, `/opsx:apply` e `/opsx:archive` (Cursor + Claude), com prompt copiável para novo chat.
- Criar regra always-on `.cursor/rules/015-session-phases.mdc` — uma sessão = uma fase; proibir explore→apply no mesmo thread.
- Criar `openspec/infra.md` — manifesto versionado de infraestrutura (sem valores de secrets).
- Criar `scripts/verify-infra.sh` — verificação idempotente que actualiza timestamps e estado ✅/❌.
- Actualizar `AGENTS.md` com R10 (infra conhecida), entrada na tabela Contexto sob demanda, e referência ao manifesto.
- Actualizar `doc/sistema-sdd-pedro.md` §3.4 (pipeline visual) e §2.8 (checklist) com handoff e infra.
- Estender checklist pós-instalação para incluir `openspec/infra.md`.

## Capabilities

### New Capabilities

- `sdd-session-handoff`: Requisitos normativos para transição entre fases explore/propose/apply/archive — handoff prompts, regras de isolamento de contexto, proibição de misturar fases no mesmo chat.
- `sdd-workspace-manifest`: Requisitos para manifesto de infraestrutura (`openspec/infra.md`), script de verificação, e regra de agente "assumir instalado até prova em contrário".

### Modified Capabilities

- `sdd-post-install-verification`: Adicionar requisito de `openspec/infra.md` presente e actualizado no checklist §2.8.

## Impact

- `.cursor/skills/openspec-{explore,propose,apply-change,archive-change}/SKILL.md` — espelhos em `.claude/skills/` e `.cursor/commands/opsx-*.md`
- `.cursor/rules/015-session-phases.mdc` — novo
- `openspec/infra.md` — novo (versionado)
- `scripts/verify-infra.sh` — novo
- `AGENTS.md` — R10 + tabela contexto (~10 linhas adicionais; manter ≤150)
- `doc/sistema-sdd-pedro.md` — §2.8, §3.4, template §12.2
- `openspec/specs/sdd-session-handoff/` e `openspec/specs/sdd-workspace-manifest/` — novas specs (após archive)
- Sem alteração de código de aplicação; documentação, regras e harness SDD

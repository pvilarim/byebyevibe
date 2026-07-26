## Context

O sistema SDD (explore → propose → apply → archive) não tem nenhum mecanismo que ligue um change OpenSpec a uma GitHub Issue de origem. Changes nascem de prompts directos; não há campo obrigatório nem convenção de processo que force o agente a consultar o ticket original.

Consequências observadas (gap G5, `openspec/changes/explore-oss-coverage-gaps/research.md`):
- Agente implementa fora do escopo do ticket por não conhecer os critérios de aceite
- Dois changes para o mesmo bug (sem consulta de issues abertas em explore)
- PR sem ligação rastreável à issue de origem — dificulta review e changelog

A solução é **híbrida** (research §G5):
1. `github-mcp-server` (oficial GitHub) como MCP passivo — o agente consulta quando relevante, sem etapa nova no fluxo interactivo
2. Campo `**Issue:**` no template de `proposal.md` — convenção de processo, auditável por humano e agente

A inserção qualifica para a **excepção de piloto** (`metodologia-insercao.md` Fase 2): não instala binário novo, não adiciona hook, apenas documenta MCP config e adiciona template inerte.

### Verificações Fase 0 concluídas

| # | Verificação | Resultado |
|---|-------------|-----------|
| V1 | Já instalado? | Não — `openspec/infra.md` lista `[NEEDS VERIFICATION]` em MCP Servers |
| V2 | Superfície de contacto | MCP passivo (modo D) — mesmo slot de GitNexus MCP e Graphify MCP |
| V3 | Colisão de artefactos | Nenhuma — espaço de nomes `github-mcp-server` livre |
| V4 | Perfil de repo | Todos os perfis (APP, DOCS_SPECS, HYBRID) — campo Issue em todos os templates de proposal |
| V5 | Empilhamento de hooks | N/A — modo D não usa PreToolUse nem hooks |
| F1 | Segurança | Endpoint remoto GitHub (`api.githubcopilot.com/mcp/`) — sem token commitado; escopo mínimo `--toolsets issues`; read-only onde couber |
| F2 | Licença | MIT (github-mcp-server, oficial GitHub) |
| F3 | Governança viva | Mantido pela própria GitHub; v1.7.0 jul/2026; suporta spec MCP stateless 28/jul/2026 |
| F4 | Reversibilidade | Remoção = entrada `infra.md` + campo no template → sem impacto em runtime |
| F5 | Operabilidade | Toggle: o agente só consulta se MCP configurado; desligar = remover do `mcp.json` |

---

## Goals / Non-Goals

**Goals:**

- Registar `github-mcp-server` nos 6 pontos do contrato de inserção (metodologia-insercao.md Fase 3) para que o agente o descubra e saiba quando consultar
- Introduzir campo `**Issue:**` no template de `proposal.md` do sdd-kit, tornando a ligação issue → change auditável
- Documentar a convenção de processo (valores aceites: URL/`#123` ou `—`) em spec normativa (`sdd-issue-traceability`)
- Descrever operação humana em `doc/sistema-sdd-pedro.md` §2.14 (instalar, verificar, desligar, troubleshooting)
- Actualizar avaliação G5 de "pendente" → "Adoptado"

**Non-Goals:**

- Substituir `gh` CLI em cloud agents — o `gh` CLI read-only já existe em cloud agents e resolve consultas ad-hoc; github-mcp acrescenta descoberta estruturada local
- Criar hook automático ou etapa nova no fluxo interactivo explore → propose → apply
- Implementar integração com outros issue trackers (Linear, Jira) — escopo mínimo
- Criar skill dedicada se instrução em AGENTS.md for suficiente (ver D3 abaixo)
- Alterar comportamento de cloud agents (runners efémeros — R11 CI exception já documentada)
- Modificar qualquer ficheiro fora de `openspec/changes/<id>/` nesta fase (propose)

---

## Decisions

### D1: Modo de acionamento — D (MCP passivo), não C (skill sob demanda) nem B (hook)

**Escolha:** modo D — MCP disponível; agente consulta quando relevante sem instrução explícita do utilizador; sem hook interceptando edições; sem etapa obrigatória no fluxo.

**Alternativa descartada — modo C (skill):** criaria uma skill `github-issues-mcp` dedicada, mas a instrução de *quando consultar* é suficientemente compacta para entrar em AGENTS.md (≤10 linhas). A metodologia `metodologia-insercao.md` §R3 permite "preferir instrução em AGENTS.md se suficiente" — skill separada seria overhead não justificado.

**Alternativa descartada — modo B (hook PreToolUse):** interviria em cada acção de edição; incompatível com "não intercepta edições"; cria latência desnecessária para consulta de issues que só é relevante em explore e propose.

**Rationale:** GitNexus MCP e Graphify MCP são precedentes do modo D em funcionamento; o mesmo mecanismo serve sem criar padrão novo.

---

### D2: Campo `**Issue:**` como convenção de processo, não gate automático

**Escolha:** campo opcional mas declarado no template de `proposal.md`, com valores: URL completo, `#123` (referência curta), ou `—` (sem issue ou born-from-prompt).

**Alternativa descartada — gate de CI que rejeita proposal sem Issue preenchido:** enforcement desnecessário; muitos changes legítimos nascem de prompts directos (refactors, docs), e forçar `—` tem o mesmo efeito — o campo fica presente para rastreabilidade. Fail-open aqui é a escolha correcta.

**Alternativa descartada — campo obrigatório não nulo:** mesmo problema — para repos sem GitHub Issues, forçaria preenchimento espúrio.

**Rationale:** o valor está na *presença do campo* (auditabilidade), não na validação do valor. Precedente: campo `created:` no `.openspec.yaml` — declarado, não validado por gate.

---

### D3: Sem skill dedicada — instrução em AGENTS.md é suficiente

**Escolha:** a instrução de acionamento (quando o agente deve consultar github-mcp por tipo A–E) entra em AGENTS.md na secção Integrações (≤10 linhas) e na tabela de contexto sob demanda. Sem ficheiro de skill separado.

**Condição de reconsideração:** se a instrução de uso crescer (ex.: padrões de query de issues, formatação de resultados, heurísticas de relevância), promover para skill em `.claude/skills/github-issues-mcp/SKILL.md` + espelho em `.cursor/skills/`.

**Rationale:** `metodologia-insercao.md` §R3 — "preferir instrução em AGENTS.md se suficiente". A skill dedicada é overhead quando a instrução cabe em ≤10 linhas sem ramificação de lógica.

---

### D4: Configuração MCP — endpoint remoto GitHub (modo stateless)

**Escolha:** documentar configuração via endpoint remoto `https://api.githubcopilot.com/mcp/` (modo OAuth — sem token commitado) como opção primária; binário local (`ghcr.io/github/github-mcp-server`) como alternativa para air-gapped.

**Escopo mínimo:** documentar `--toolsets issues` para limitar superfície; read-only onde o cliente MCP suportar.

**Versão pinada:** v1.7.0 (jul/2026) como referência documental; o endpoint remoto segue versão do lado servidor (sem pin local); para binário local, pin por digest de imagem Docker.

**Segurança (F-SEC-5):** NUNCA commitar tokens; NUNCA avaliar campo `gate:` do MANIFEST via `eval`; configuração em `~/.cursor/mcp.json` (gitignored por defeito).

---

### D5: Bump de MANIFEST — 1.4.0 → 1.5.0

**Escolha:** bump de minor porque templates são modificados (novo campo em proposal template, linhas em infra.md e AGENTS.core.md). Sem novo ficheiro de script — sem impacto em `install.sh`/`upgrade.sh` além das checksums.

**Alternativa descartada — manter 1.4.0:** mudança nos templates existentes exige re-verificação de checksums, o que é indistinguível de um bump; a convenção do kit é bumpar minor quando templates mudam de conteúdo.

---

## Matriz A–E de acionamento (obrigatória — instrução do utilizador)

| Tipo de tarefa | Usar github-mcp? | Quando | O que consultar |
|----------------|-----------------|--------|-----------------|
| **A — Trivial** | ❌ Não | — | — |
| **B — Bug fix** | ✅ Sim | Framing do change (antes de proposal) | Issue de origem: enunciado, critérios de aceite, contexto de stack trace |
| **C — Refactor** | ⬜ Opcional | Se change referencia issue | Confirmar escopo do ticket vs intenção do refactor |
| **D — Feature** | ✅ Sim | Durante `/opsx:propose` | Issue de origem: user story, critérios de aceite, dependências declaradas |
| **E — Exploração** | ✅ Sim | Durante research.md | Issues relacionadas: duplicatas, contexto de bugs anteriores |

**Regra de consulta:** o agente consulta github-mcp quando o change tem campo `Issue:` preenchido com URL/`#123`, ou quando o tipo de tarefa é B ou D (mesmo sem issue explícita, ler issues abertas do repo para evitar duplicação).

---

## Overlap com `gh` CLI em cloud agents vs ganho local

| Aspecto | `gh` CLI (cloud agents) | `github-mcp-server` (local) |
|---------|------------------------|----------------------------|
| Disponibilidade | Cloud agents (runners efémeros) | Local (máquina do dev/agente com MCP) |
| Interface | Comandos shell (read-only) | MCP tools (structured, consultável em sessão) |
| Descoberta pelo agente | Não — agente precisa invocar explicitamente | Sim — MCP passivo; agente consulta quando relevante |
| Scope mínimo | Herda permissões do ambiente CI | `--toolsets issues` declarado |
| Uso em explore/propose | Limitado (cloud agents não têm explore/propose persistente) | Nativo — sessão interactiva |
| Duplicação | Nenhuma — cloud agents não têm MCP local configurado | Nenhuma — MCP local não está nos runners CI |

**Conclusão:** não há overlap funcional relevante; as duas ferramentas servem contextos diferentes (CI efémero vs sessão interactiva local). A instrução em AGENTS.md deve notar que `gh` CLI já existe em cloud agents para consultas ad-hoc.

---

## Risks / Trade-offs

| Risco | Mitigação |
|-------|-----------|
| **Token exposto** — operador commita `GITHUB_PERSONAL_ACCESS_TOKEN` em config | Documentar em §2.14 e em security rule: config vai em `~/.cursor/mcp.json` (gitignored); NUNCA commitar token |
| **Superfície de acesso excessiva** — MCP com todos os toolsets activos lê issues, PRs, código, etc. | Documentar `--toolsets issues` como configuração recomendada; guia §2.14 explica como verificar |
| **MCP indisponível** — endpoint remoto GitHub fora do ar | Modo D é fail-open: se MCP não responde, agente prossegue sem contexto de issue; não bloqueia o fluxo |
| **Staleness do campo Issue** | Campo `—` é válido; a spec permite change sem issue; o valor está na rastreabilidade quando existe, não em enforcement |
| **Campo Issue em proposals legadas** | Proposals já arquivadas não são retroativamente modificadas; o campo só aparece em proposals novas via template |
| **Drift de versão do MCP** | Endpoint remoto segue versão do lado servidor (GitHub controla); para binário local, documentar re-verificação semestral |

---

## Plano de rollback

### Quando acionar

- github-mcp-server é descontinuado ou muda de licença incompatível
- Endpoint remoto exige scope excessivo sem alternativa de scope mínimo
- Decisão de adoptar alternativa com melhor integração (ex.: Linear MCP, se o projecto migrar de issue tracker)

### Procedimento (< 10 minutos)

```bash
# 1. Remover entrada github-mcp-server de openspec/infra.md
# 2. Reverter secção Integrações em AGENTS.md (≤10 linhas adicionadas)
# 3. Remover campo **Issue:** do template proposal.md
#    (não afecta proposals já escritas — campo fica como texto livre)
# 4. Bump de versão MANIFEST e recalcular checksums
# 5. Criar change OpenSpec de remoção (tipo C) e arquivar
# 6. Actualizar doc/avaliacoes/ com decisão "Descartado" + condições de reabertura
```

Rollback não requer desinstalação em repos consumidores além de remover a entrada do `mcp.json` local — sem impacto em CI (não entra no `sdd-gates.yml`).

---

## Open Questions

| # | Questão | Impacto | Quando resolver |
|---|---------|---------|-----------------|
| Q1 | Criar skill `.claude/skills/github-issues-mcp/` se instrução em AGENTS.md crescer? | Define R3 do contrato; nesta fase: não | Quando instrução ultrapassar 10 linhas |
| Q2 | `verify.sh` deve verificar presença de `github-mcp-server` em `infra.md`? | Baixo — MCP não é runtime obrigatório | No próximo upgrade do kit |
| Q3 | Campo `Issue:` no template de `design.md` também? | Baixo — proposal é o ponto de ligação canónico | Feedback após uso em 3+ changes |

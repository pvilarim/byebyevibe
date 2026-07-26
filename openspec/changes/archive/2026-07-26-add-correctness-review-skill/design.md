## Context

O sistema SDD tem duas skills de review pós-apply:
- `simplify-review` — caça complexidade evitável (over-engineering, YAGNI, stdlib reinventada)
- `security-reviewer` — auditoria de segurança em auth/pagamentos/API routes

Nenhuma das duas cobre **correctness**: bugs lógicos, edge cases não tratados, violações de invariante, condições de corrida, comportamento inesperado em inputs extremos ou erros de contrato. Código gerado por IA tem padrão característico de falha nessa dimensão: sintaxe e estrutura correctas, semântica errada em casos limite.

A inserção segue a metodologia de `metodologia-insercao.md` (Fase 1 → Fase 3 directo):
- **Excepção de piloto aprovada:** skill sem binário, hook ou consumo LLM autónomo — apenas instrui o agente a revisar código com o modelo já activo na sessão. O utilizador confirmou explicitamente ("piloto dispensável").
- **Precedente:** `simplify-review` (`.claude/skills/simplify-review/SKILL.md` + espelho `.cursor/skills/`), adoptado sem piloto, integrado via AGENTS.md + infra.md.

### Verificações Fase 0 concluídas

| # | Verificação | Resultado |
|---|-------------|-----------|
| V1 | Já instalado? | Não — `openspec/infra.md` não lista `correctness-review` |
| V2 | Superfície de contacto | Modo C (sob demanda) — sem hook, sem PreToolUse; mesmo slot do `simplify-review` |
| V3 | Colisão de artefactos | Nenhuma — `.claude/skills/correctness-review/` e `.cursor/skills/correctness-review/` livres |
| V4 | Perfil de repo | Aplica-se a APP e DOCS_SPECS (qualquer código gerado) |
| V5 | Empilhamento de hooks | N/A — modo C não usa hooks |
| F1 | Segurança | Sem binário externo; sem token; sem dado de produção |
| F2 | Licença | MIT (mesmo padrão do `simplify-review`) |
| F3 | Governança viva | A skill é interna — manutenção própria |
| F4 | Reversibilidade | Remoção = `rm` dos dois ficheiros de skill + reverter AGENTS.md/infra.md |
| F5 | Operabilidade | Toggle on/off via invocação (modo C) |

---

## Goals / Non-Goals

**Goals:**

- Criar skill `correctness-review` que detecte bugs lógicos, edge cases não tratados, violações de contrato e invariantes em código gerado por IA
- Posicioná-la na pipeline pós-apply antes do `simplify-review` (actualizar AGENTS.md)
- Registar nos 6 pontos do contrato de inserção (metodologia-insercao.md Fase 3)
- Fornecer spec normativa (`sdd-correctness-review`) para que implementações futuras saibam o que a skill DEVE e NÃO DEVE fazer
- Garantir rollback documentado e testável

**Non-Goals:**

- Substituir `simplify-review` ou `security-reviewer` — são ortogonais
- Integrar PR-Agent (G7 Fase 2 — opcional, por repo, change separado)
- Criar hook automático ou consumo LLM autónomo (out-of-band)
- Implementar a skill como subagente autónomo nesta iteração (análogo ao `⏳ Subagent` do simplify-review)
- Tocar código de produção — este repo é DOCS_SPECS; a skill instrui agentes em repos APP

---

## Decisions

### D1: Modo de acionamento — C (sob demanda), não B (hook automático)

**Escolha:** modo C — utilizador ou agente invoca via skill description ("pós-apply, antes de commit/PR, tarefas B/C/D").

**Alternativa descartada:** hook PreToolUse automático (modo B). Motivo: (a) consome LLM em cada write, latência inaceitável para edições triviais (tipo A, docs); (b) `metodologia-insercao.md` reserva modo B a TDD Guard com toggle obrigatório; (c) `simplify-review` provou que modo C é suficiente para reviews de qualidade.

**Rationale:** selectividade > cobertura automática. A matriz A–E (abaixo) define quando invocar sem criar regra nova.

---

### D2: Estrutura da skill — espelho `.claude/` + `.cursor/`

**Escolha:** `.claude/skills/correctness-review/SKILL.md` (Claude Code) com espelho idêntico em `.cursor/skills/correctness-review/SKILL.md` (Cursor IDE), seguindo precedente do `simplify-review`.

**Alternativa descartada:** ficheiro único partilhado por symlink. Motivo: symlinks não são portáveis cross-platform e o precedente é cópia literal.

---

### D3: Contrato de 6 pontos de registro (Fase 3)

Obrigatório por `metodologia-insercao.md`. Os 6 pontos:

| # | Artefacto | Conteúdo |
|---|-----------|----------|
| R1 | `openspec/infra.md` | Linha na secção Skills: `correctness-review` · fase review · ✅ |
| R2 | `AGENTS.md` | ≤10 linhas em Integrações + linha na tabela "Reviews pós-implementação" com posição na ordem de pipeline |
| R3 | `.claude/skills/` + `.cursor/skills/` | Skill completa com `description:` auto-invoke, formato de saída, boundaries |
| R4 | `doc/sistema-sdd-pedro.md` | Nova subsecção: quando acionar, como ler output, como desligar, troubleshooting |
| R5 | `doc/avaliacoes/` | Entrada "Adoptado" com condições de reavaliação |
| R6 | `sdd-kit/` | Instrução de install manual (sem script automático nesta fase — idêntico ao `simplify-review`) |

---

### D4: Formato de saída da skill

**Escolha:** espelhar formato do `simplify-review` — cabeçalho com change/escopo/veredito, achados um por linha com tag + localização + descrição + sugestão, métrica final.

**Tags específicas de correctness** (distintas das tags de simplicidade):

| Tag | Significado |
|-----|-------------|
| `logic:` | Condição ou ramo lógico errado; resultado incorreto para input válido |
| `edge:` | Input extremo não tratado (null, vazio, overflow, unicode, concurrent) |
| `contract:` | Violação de pré/pós-condição ou invariante de API/função |
| `race:` | Condição de corrida potencial (shared mutable state, async sem lock) |
| `silent:` | Erro silencioso — excepção engolida, valor errado sem alerta |

**Vereditos** (análogos ao simplify-review):

| Veredito | Critério |
|----------|----------|
| `CORRECT` | Nenhum achado de correctness no escopo |
| `RISKY` | ≥1 achado acionável de correctness |
| `ESCOPO INSUFICIENTE` | Diff muito pequeno ou sem lógica para avaliar |

---

### D5: Pilot dispensado — justificação documentada

A `metodologia-insercao.md` Fase 2 dispensa piloto quando "a inserção não instala binário novo nem hook". Esta skill:
- Não instala binário
- Não adiciona hook (PreToolUse, pre-commit, etc.)
- Não cria serviço externo
- Não consome LLM de forma autónoma (opera dentro da sessão já activa)
- O utilizador confirmou explicitamente ("piloto dispensável")

Condição de reavaliação: se a skill vier a ser convertida em subagente autónomo ou hook, um piloto com critérios quantificados DEVE ser conduzido antes da promoção.

---

## Matriz A–E de acionamento

Obrigatória por instrução do utilizador ("design.md MUST incluir matriz A–E").

| Tipo de tarefa | Usar `correctness-review`? | Gatilho | Posição na pipeline |
|----------------|---------------------------|---------|---------------------|
| **A — Trivial** | ❌ Não | — | — |
| **B — Bug fix** | ✅ Sim (sempre) | Diff > 0 linhas de lógica | Antes do commit; depois de testes passarem |
| **C — Refactor** | ✅ Sim | Diff > ~80 linhas ou > 4 ficheiros | Pós-apply, antes de `simplify-review` |
| **D — Feature** | ✅ Sim (sempre) | Diff com lógica nova | Pós-apply, antes de `simplify-review` |
| **E — Exploração** | ❌ Não | — | — (sem código gerado) |

**Regra de gatilho unificada** (reutiliza heurística existente do `simplify-review`):
- Diff > ~80 linhas de código **ou** > 4 ficheiros **ou** qualquer tarefa tipo B/D
- Invocação sempre on-demand (nunca bloqueante automática)

**Ordem actualizada de reviews pós-implementação:**
```
/opsx:apply → [implementação] → testes (R6/TDD Guard)
  → correctness-review (B/C/D)
  → simplify-review (opcional, C/D)
  → security-reviewer (se auth/API/pagamentos)
  → commit (R9) → gates CI → /opsx:archive
```

---

## Risks / Trade-offs

| Risco | Mitigação |
|-------|-----------|
| **Falso positivo** — skill flagga código correcto, bloqueia fluxo psicologicamente | Skill é on-demand e não bloqueia commit; veredito `CORRECT` ou `ESCOPO INSUFICIENTE` encerra sem acção; utilizador pode discordar |
| **Overlap com `security-reviewer`** | Boundaries explícitas: `correctness-review` não reporta vulnerabilidades de segurança (→ `security-reviewer`); `security-reviewer` não caça bugs lógicos gerais |
| **Overlap com `simplify-review`** | `simplify-review` nunca caça correctness (declarado em seu SKILL.md: "Fora de scope: bugs de correctness"); `correctness-review` nunca caça complexidade desnecessária |
| **Custo LLM por revisão** | A skill opera na sessão já activa — sem chamada adicional de modelo além do que o agente já executa. Custo marginal ≈ 0 vs uma sessão sem a skill |
| **Qualidade depende do modelo** | Achados são sugestões, não verdades; utilizador valida. A skill instrui o modelo a ser conservador: só reportar achados com evidência no código, nunca especular |
| **Drift do SKILL.md** | `correctness-review` e `simplify-review` devem evoluir em paralelo — spec `sdd-correctness-review` é a fonte de verdade; qualquer mudança de comportamento normativo passa por change OpenSpec |

---

## Plano de rollback

Obrigatório por instrução do utilizador ("design.md MUST incluir plano de rollback").

### Quando acionar rollback

- A skill produz consistentemente achados sem valor (taxa de accionabilidade < 20% em 10 reviews)
- Conflito com outra ferramenta futura que cubra o mesmo escopo com melhor qualidade
- Decisão de adoptar PR-Agent fase 2 em modo automático, tornando a skill redundante

### Procedimento de rollback (reversível em < 5 minutos)

```bash
# 1. Remover ficheiros de skill
rm .claude/skills/correctness-review/SKILL.md
rmdir .claude/skills/correctness-review/
rm .cursor/skills/correctness-review/SKILL.md
rmdir .cursor/skills/correctness-review/

# 2. Reverter AGENTS.md (secção Reviews pós-implementação e tabela Commands)
#    — remover linha de correctness-review das duas tabelas

# 3. Reverter openspec/infra.md (secção Skills)
#    — remover linha correctness-review

# 4. Criar change OpenSpec de remoção (change tipo C) e arquivar

# 5. Actualizar doc/avaliacoes/ com decisão "Descartado" + condições de reabertura
```

Rollback não requer toque em `sdd-kit/` (não há script automático para esta fase) nem em specs de outros repos.

### Critérios de reavaliação

- **Reavaliação semestral** automática (mesma regra de G7 da metodologia)
- Se convertida em subagente autónomo: conduzir piloto com critérios quantificados (≥1 achado válido por 10 reviews; falso positivo < 30%)
- Se PR-Agent fase 2 for adoptado: avaliar se a skill local continua complementar (review em tempo real de sessão) ou redundante

---

## Open Questions

| # | Questão | Impacto | Quando resolver |
|---|---------|---------|-----------------|
| Q1 | Incluir a skill no `sdd-kit/install.sh` como item instalável para repos APP, ou manter instrução manual apenas? | Define R6 do contrato | No próximo upgrade do kit (v1.5.0) |
| Q2 | Subagente autónomo `.claude/agents/correctness-reviewer.md` (análogo ao `⏳ Subagent` do simplify-review)? | Requer piloto com critérios quantificados antes de promover | Após validação em repo APP real |
| Q3 | PR-Agent fase 2 (workflow de CI) entra no sdd-kit? | Change OpenSpec separado; governança PR-Agent ainda em transição | Reavaliação semestral (jan/2027) |

# Avaliação: Headroom — compressão de contexto para agentes

| Campo | Valor |
|-------|--------|
| **Data** | 2026-03-26 |
| **Avaliador** | Sessão de avaliação (Pedro Vilarim + agente) |
| **Candidato** | [Headroom](https://github.com/chopratejas/headroom) (`headroom-ai`) |
| **Decisão** | **Descartado** — não integrar no `sdd-kit` nem no pipeline normativo SDD |
| **Escopo** | Camada opcional de compressão (proxy / MCP / library) sobre outputs de tools e histórico de conversa |

## Resumo executivo

O Headroom comprime tool outputs, logs, RAG e histórico **antes** de chegarem ao LLM, com compressão reversível (CCR) e integração com Cursor/Claude via proxy ou MCP. Foi avaliado como possível “camada 4” do stack SDD para poupar tokens. **Conclusão: ganhos não compensam os riscos** face aos padrões já adoptados (subagents com síntese, `AGENTS.md` curto, Gates determinísticos, artefactos OpenSpec). **Implantação descartada.**

## Problema que tentava resolver

- Reduzir custo de tokens em sessões longas com muitas tool calls (GitNexus, Graphify, grep, verify scripts)
- Mitigar “context rot” sem depender só de handoff entre fases
- Complementar a eficiência já descrita em `doc/sistema-sdd-pedro.md` §7.1 (subagents, rules curtas)

## O que foi analisado

- README e documentação oficial (arquitectura, CCR, limitações)
- Encaixe com workflows `/opsx:explore`, `/opsx:propose`, `/opsx:apply`
- Skills OpenSpec e regras `AGENTS.md` (fontes 1–6, classificação A–E, Gates §12.10)
- Conflitos potenciais com governação de `AGENTS.md` (`headroom learn`, blocos auto-gerados)

## Encaixe no stack SDD

| Ferramenta | Relação |
|------------|---------|
| **OpenSpec** | Artefactos normativos (`proposal`, `design`, `tasks`, `specs`) não devem ser comprimidos; risco de trade-offs incompletos em propose |
| **GitNexus** | Outputs de `query` / `impact` são candidatos à compressão agressiva — **exactamente** onde o blast radius e callers alternativos importam |
| **Graphify** | Queries amplas em explore perdem alternativas se amostradas antes da síntese |
| **AGENTS.md / sdd-kit** | `headroom learn --apply` conflita com curadoria manual e anti-padrão de blocos auto-gerados (§2.5.1 guia SDD) |

## Riscos por fase do workflow

| Fase | Risco | Gravidade | Notas |
|------|-------|-----------|-------|
| **Explore** | Esconder possibilidades não vistas pelo modelo | **Alta** | Amostra estatística ≠ espaço de soluções; CCR só ajuda se o modelo souber *o que* recuperar |
| **Propose** | `design.md` com alternativas incompletas | **Alta** | Decisões prematuras; viola espírito de fontes verificáveis (R2, R3) |
| **Apply** | Patch incorrecto, gate mal interpretado, impacto ignorado | **Média–alta** | Logs de teste/Gates e primeiro `impact` não devem ser comprimidos |
| **Archive** | Pouco volume de contexto | **Baixa** | Ganho mínimo |

**Mecanismo comum:** o agente age como se tivesse visto tudo, quando trabalhou com uma vista parcial. O CCR mantém originais em cache local, mas **não garante** que o modelo chame `headroom_retrieve` a tempo.

## Ganhos esperados vs observados

| Ganho anunciado | Avaliação |
|-----------------|-----------|
| 60–95% menos tokens em tool outputs | Real em JSON/logs volumosos; **redundante** com subagents → `knowledge.md` / `codebase.md` em explore |
| Mesmas respostas (benchmarks) | Válido em tarefas fechadas; **não transferível** para descoberta de alternativas ou specs normativas |
| `headroom wrap cursor` | Opt-in local possível; **não** justifica entrada no kit partilhado |
| Output token shaping | Risco em apply/propose; desligado por defeito — ganho marginal face ao risco |

## Alternativas já no stack (preferidas)

1. **Compressão semântica:** subagents (`graphify-researcher`, `codebase-researcher`) devolvem síntese, não ruído bruto
2. **Contexto sob demanda:** `AGENTS.md` ≤150 linhas + tabela de ficheiros por situação
3. **Handoff entre fases:** novo chat propose → apply com artefactos git como fonte
4. **Gates determinísticos:** exit 0 em `tasks.md` — não delegar “pronto” ao julgamento do modelo sobre output comprimido
5. **Passthrough nativo do Headroom** para código e user messages — overlap parcial com protecções que o SDD já exige por outras vias

## Decisão

**Descartada a implantação** do Headroom como parte do sistema SDD (C1/C2, `sdd-kit`, `openspec/infra.md`, rules obrigatórias).

**Opt-in pessoal** (proxy local só para logs CI volumosos, fora de explore/propose/Gates) não é proibido, mas **não é documentado nem suportado** pelo kit.

### Condições para reabrir avaliação

- Modo “SDD-safe” documentado pelo upstream: whitelist por fase (nunca comprimir Gates, impact, `contextFiles`, specs)
- Evidência em repo piloto de que CCR + gates shell mantêm 100% pass rate em apply com compressão activa
- Nova proposta OpenSpec (`add-headroom-optional-layer`) com spec normativa de guardrails — **não** install automático

## Posicionamento final

```
OpenSpec + GitNexus + Graphify  →  governa O QUÊ e COM QUE EVIDÊNCIA
Headroom                        →  descartado; não camada normativa do SDD
```

## Referências

- Repositório: https://github.com/chopratejas/headroom
- Docs: https://headroom-docs.vercel.app/
- Discussão interna: sessão 2026-03-26 (explore / propose / apply)
- Índice: [README.md](./README.md)

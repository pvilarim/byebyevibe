# Research — Compatibilidade SDD core vs módulo UI

| Campo | Valor |
|-------|--------|
| **Data** | 2026-06-27 |
| **Change** | `add-sdd-ui-development-module` |
| **Objectivo** | Verificar conflitos técnicos entre OpenSpec, GitNexus, Graphify e o módulo UI (Impeccable, Open Design, Pencil, Figma MCP, shadcn) **antes** de `/opsx:apply` |
| **Decisão** | **Sem bloqueio estrutural** — adoptar com mitigações documentadas (ver §6) |

## Resumo executivo

Os três pilares SDD (OpenSpec, GitNexus, Graphify) **não conflitam de forma incompatível** com o módulo UI proposto. Operam em camadas diferentes:

| Sistema | Domínio | Relação com módulo UI |
|---------|---------|------------------------|
| **OpenSpec** | Mudanças, specs, `design.md` de change | Ortogonal — governa *features*; UI module governa *craft visual* |
| **GitNexus** | Grafo de código, impact analysis | **Complementar** — usar antes de editar `components/ui/` |
| **Graphify** | Knowledge graph de docs/código | **Complementar** — indexa `doc/design/*` após apply |
| **Impeccable** | Guardrails UI, `DESIGN.md` raiz | **Camada adicional** — não substitui SDD |
| **Open Design / Pencil / Figma** | Prototipagem externa/MCP | **Opcional** — runtime fora do C1-UI automático |

**Veredicto:** seguro implementar o change com as mitigações abaixo incorporadas em `002-ui-module-install.md` e `design.md`.

---

## 1. OpenSpec

### 1.1 Colisão de nomes `design.md` / `DESIGN.md`

| Ficheiro | Path | Propósito |
|----------|------|-----------|
| OpenSpec change design | `openspec/changes/<id>/design.md` | Decisões técnicas da mudança |
| Impeccable / Open Design | `DESIGN.md` (raiz ou app) | Contrato visual de marca |
| Open Design output | `DESIGN.md` (export OD) | Exploração de identidade |

**Conflito:** semântico (homónimo), **não** técnico — paths diferentes.

**Mitigação (MUST no `002`):**

- Tabela de disambiguação no guia de instalação UI
- Em prompts de agente: qualificar `openspec/.../design.md` vs `DESIGN.md` (raiz)
- Open Design exports → renomear para `design-exploration.md` ou mover para `design/od/` antes de merge no `DESIGN.md` canónico

### 1.2 Workflow `/opsx:*` vs comandos `/impeccable *`

| Fase SDD | Ferramenta UI | Conflito? |
|----------|---------------|-----------|
| explore | Open Design, matriz Fase 1 | Não — explore produz research, não código |
| propose | OD/Pencil para mockups | Não — artefactos em `openspec/changes/` ou `design/*.pen` |
| apply | Impeccable polish/audit | **Atenção** — ver §4.2 (hook durante apply) |
| archive | — | Não |

**Regra de ouro:** mudanças de **comportamento** (Tipo C/D) → OpenSpec primeiro. Mudanças **só visuais** (Tipo A, mesmo componente) → Impeccable sem change — alinhado a classificação A–E em `AGENTS.md`.

### 1.3 C1-UI vs C1 / C3

- **C1** core inalterado — sem conflito
- **C3** (specs de domínio) não dispara UI module — já decidido em `design.md` D6
- Nova spec `sdd-ui-module` segue padrão `sdd-install-kit` — sem sobreposição normativa

**Conclusão OpenSpec:** ✅ compatível com mitigação de nomenclatura.

---

## 2. GitNexus

### 2.1 Indexação e impact analysis

GitNexus indexa símbolos TypeScript/React incluindo `components/ui/*`.

| Cenário | Interacção |
|---------|------------|
| Refactor de componente shadcn | GitNexus `impact` **antes** de editar — reforça pipeline UI |
| Novo componente UI | `gitnexus analyze --force` após mudanças grandes — já em `AGENTS.md` |
| Hub DOCS_SPECS | Sem app UI — GitNexus indexa scripts/docs; módulo UI = docs only |

**Conclusão:** ✅ complementar, não concorrente.

### 2.2 Skills e hooks

| Artefacto | Path | Conflito |
|-----------|------|----------|
| GitNexus skills | `.claude/skills/gitnexus/` | Não — namespace separado |
| Impeccable skill | `.cursor/skills/impeccable/` | **Partilha pasta** `.cursor/skills/` com `openspec-*` |
| GitNexus MCP | `mcp.json` global | Coexiste com Figma/Pencil MCP |
| Impeccable hook Cursor | hook manifest no repo | **Independente** de hooks Claude GitNexus |

**Mitigação (MUST):**

- `002` documenta que Impeccable **não** substitui skills GitNexus
- `install-ui-module.sh` **não** modifica blocos `<!-- gitnexus:start -->` em `AGENTS.md` (anti-padrão §2.5.1)
- Após `npx impeccable install`, correr `npx gitnexus analyze --force` se UI components mudaram

### 2.3 `gitnexus_detect_changes` vs `impeccable detect`

Ambos podem correr em PR:

| Tool | Quando | LLM |
|------|--------|-----|
| GitNexus detect | Pré-commit, blast radius | Não |
| Impeccable detect | CI em paths marketing | Não |

**Conclusão:** ✅ podem coexistir em pipeline CI com paths distintos (`ignoreFiles` Impeccable vs escopo GitNexus).

---

## 3. Graphify

### 3.1 Indexação

- `graphify update .` indexa AST de código **e** estrutura de docs
- `doc/design/*` entra no knowledge graph após apply — **desejável** para agentes Tipo D
- `graphify hook install` (commit hook) continua válido; não interfere com Impeccable

### 3.2 Conteúdo fora do repo

Open Design e Figma vivem fora do repo — Graphify **não** indexa até decisões serem commitadas (`DESIGN.md`, screenshots em `doc/`, `.pen`).

**Mitigação:** Fase 2 da pipeline MUST commitar contrato no repo (já em `001` §4).

### 3.3 Sobrecarga de contexto

Graphify + Impeccable + OpenSpec aumentam fontes em `AGENTS.md` (já parcialmente com secção design).

**Mitigação:** manter ponteiros curtos (§5.3 guia); detalhe em `doc/design/`; `AGENTS.md` ≤150 linhas.

**Conclusão Graphify:** ✅ compatível.

---

## 4. Impeccable (componente central do módulo)

### 4.1 Hook Cursor em fase apply

Impeccable no Cursor pode **bloquear** escritas de UI com anti-padrões antes de entrarem no ficheiro.

| Risco | Gravidade | Mitigação |
|-------|-----------|-----------|
| Apply SDD escreve UI rápido; hook bloqueia iterção | Média | Durante `/opsx:apply` massivo de UI: `detector.ignoreFiles` temporário ou desactivar hook via `.impeccable/config.json` documentado em `002` |
| Falso positivo em código legado | Baixa | `ignoreFiles` para `/app`, `lib/parametric`, `design/**` (já em `001`) |

### 4.2 Node.js 22 vs 24

| Fonte | Requisito |
|-------|-----------|
| `openspec/project.md` | Node **22.x** |
| `doc/design/000` (Impeccable CLI) | Node **24+** |

**Conflito real:** versão mínima divergente.

**Mitigação (MUST em `002` e spec):**

- `install-ui-module.sh --detect` verifica `node -v`; se &lt;24, avisa e **não** corre `npx impeccable install` automaticamente
- Documentar: Impeccable requer Node 24+ no **ambiente do dev**; repo SDD mantém 22.x para tooling geral até `project.md` ser actualizado por change separado
- Avaliar bump `project.md` → Node 22 **ou** 24 LTS num change futuro — **fora de escopo** deste change

### 4.3 Ficheiros na raiz

Impeccable cria `PRODUCT.md`, `DESIGN.md`, `.impeccable/` na raiz do app.

| Ficheiro | Conflito com SDD |
|----------|------------------|
| `PRODUCT.md` | Não existe no SDD |
| `DESIGN.md` | Homónimo semântico — ver §1.1 |
| `.impeccable/config.json` | Não existe no SDD |

**Conclusão:** ✅ sem colisão de path com `openspec/`.

---

## 5. Open Design, Pencil, Figma MCP

### 5.1 Proliferação MCP

Stack completo num dev Cursor pode incluir:

```
GitNexus MCP | Graphify MCP | Figma MCP | Pencil MCP | Open Design MCP (od mcp)
```

| Risco | Mitigação |
|-------|-----------|
| Muitos servidores MCP | Instalar **sob demanda** (já decidido D9); `infra.md` regista quais estão ✅ |
| Auth Figma | Operador configura; R10 — não commitar tokens |
| OD + Figma + Pencil simultâneos | `001` §10 — uma fonte canónica por projeto |

### 5.2 shadcn/ui

`npx shadcn@latest init` adiciona `components.json`, `components/ui/`, altera `globals.css`.

| Sistema | Após shadcn init |
|---------|------------------|
| GitNexus | Reindex recomendado |
| Graphify | `graphify update .` |
| OpenSpec | Change separado se feature nova; init shadcn em C1-UI é infra UI |
| Impeccable | `/impeccable document` para sincronizar `DESIGN.md` |

**Conclusão:** ✅ sem conflito; sequência documentada em `002`.

---

## 6. Mitigações obrigatórias na implementação

| ID | Mitigação | Onde |
|----|-----------|------|
| M1 | Tabela disambiguação `design.md` vs `DESIGN.md` | `doc/design/002` |
| M2 | Impeccable não altera `AGENTS.md` gitnexus blocks | `install-ui-module.sh`, `002` |
| M3 | Gate Node 24+ antes de `npx impeccable install` | `install-ui-module.sh`, spec |
| M4 | Hook Impeccable: nota para fase apply intensiva | `002` § conflitos SDD |
| M5 | Pós-install UI: `gitnexus analyze` + `graphify update .` | `002` checklist |
| M6 | MCP design tools só sob demanda; registo em `infra.md` | `002`, spec |
| M7 | Skills Impeccable fora de `verify-task-patterns` | já em spec |

---

## 7. Matriz de compatibilidade final

| Par SDD ↔ UI | Conflito técnico | Bloqueia apply? | Acção |
|--------------|------------------|-----------------|-------|
| OpenSpec ↔ Impeccable | Homónimo design | Não | M1 |
| OpenSpec ↔ OD | Fluxo explore/propose | Não | Documentar fases |
| GitNexus ↔ Impeccable | Skills/hooks paralelos | Não | M2, M5 |
| Graphify ↔ Impeccable | Nenhum | Não | M5 |
| Graphify ↔ OD/Figma | OD fora do repo | Não | Commit Fase 2 |
| Session coord ↔ Impeccable hook | Hook bloqueia writes | Não | M4 |
| Node 22 (project) ↔ Node 24 (Impeccable) | Versão | **Parcial** | M3 |
| AGENTS ≤150 linhas ↔ UI ponteiros | Tamanho | Não | Ponteiros curtos |
| C1 core ↔ C1-UI | Ordem install | Não | Pré-requisito C1 |

---

## 8. Recomendação

**Prosseguir com `/opsx:apply`** incorporando mitigações M1–M7 nas tasks existentes (task 2.1 e 3.1 principalmente).

Não é necessário change separado de compatibilidade — os ajustes cabem no `add-sdd-ui-development-module` actual.

---

## Fontes consultadas

- `openspec/infra.md` — stack SDD actual
- `doc/sistema-sdd-pedro.md` §2.5.1, §3.3, §5.3, §7
- `doc/design/000-impeccable-design-system-guia.md` §5–6
- `doc/design/001-pipeline-open-design-shadcn-impeccable.md` §5, §10
- `openspec/changes/add-sdd-ui-development-module/design.md`
- `doc/avaliacoes/2026-03-26-headroom-context-compression.md` — precedente análise de conflito por fase
- `openspec/project.md` — Node 22.x
- `.cursor/rules/015-session-phases.mdc`, `016-session-coordination.mdc`

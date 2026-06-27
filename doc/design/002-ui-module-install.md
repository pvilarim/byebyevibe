# Módulo SDD de desenvolvimento de UI — instalação (C1-UI)

> **Cenário C1-UI** — add-on opcional **após** C1 core (`sdd-kit/install.sh`). Não substitui o stack OpenSpec + GitNexus + Graphify.

**Comando:** `bash sdd-kit/install-ui-module.sh --detect` → `--apply [--yes]`

**Detalhe da pipeline:** [`001-pipeline-open-design-shadcn-impeccable.md`](./001-pipeline-open-design-shadcn-impeccable.md) (fluxos A–D, matrizes, prompts — **não** duplicados aqui).

---

## 1. Quando instalar

| Perfil | Acção |
|--------|--------|
| **APP** / **HYBRID** com `app/` ou `apps/web/` | Correr C1-UI após checklist §2.8 |
| **DOCS_SPECS** sem frontend | `--detect` → `SKIP: no frontend`; docs `doc/design/*` distribuídos pelo kit |
| **API-only** | SKIP — sem módulo UI |

### Pré-requisitos

1. C1 concluído (`doc/sistema-sdd-pedro.md` §2.8)
2. Node.js **24+** no ambiente do dev **se** for instalar Impeccable (gate M3)
3. Next.js + Tailwind (recomendado) ou stack documentada em [`003-ui-stack-adapters.md`](./003-ui-stack-adapters.md)

---

## 2. Árvore de detecção (`--detect`)

```
package.json + (app/ | apps/web/)?
         │
    ┌────┴────┐
   NÃO       SIM
    │         │
 SKIP      detect_ui_stack()
```

| Resultado | Condição | Caminho |
|-----------|----------|---------|
| `SKIP: no frontend` | Sem `app/`, `apps/web/`, nem `package.json` com deps React | N/A |
| `UI stack: shadcn` | `components.json` ou `components/ui/` | **A** — `001` completo |
| `UI stack: tailwind-custom` | Tailwind presente, sem shadcn | **B** — ver `003` |
| `UI stack: other` | MUI, Chakra, etc. | **C** — ver `003` |

### Decisão shadcn (recomendado + opt-out)

Para repos Next.js + Tailwind **sem** design system detectado:

```
Recomendamos shadcn/ui como caminho default (Fase 2).
Instalar shadcn? [Y/n]
```

- **Y** (ou `--yes` no script) → Caminho A; seguir `001` §4
- **n** → `UI stack: tailwind-custom`; seguir [`003-ui-stack-adapters.md`](./003-ui-stack-adapters.md)

---

## 3. Comandos

```bash
# Detecção (sempre primeiro)
bash sdd-kit/install-ui-module.sh --detect

# Simular operações
bash sdd-kit/install-ui-module.sh --dry-run --apply

# Aplicar (copia doc/design/*; Impeccable só com --yes)
bash sdd-kit/install-ui-module.sh --apply --yes
```

### O que `--apply` faz

1. Copia `doc/design/000`–`003` de `sdd-kit/templates/doc/design/` (se ausentes ou mais recentes no kit)
2. Actualiza `openspec/infra.md` — secção UI Development Module
3. Regista `UI stack` em `openspec/project.md` (se campo presente)
4. **Com `--yes`:** corre `npx impeccable install` (Node 24+ obrigatório)
5. **Sem `--yes`:** não instala Impeccable; operador confirma manualmente

### O que `--apply` **não** faz

- Não altera C1 core (`install.sh`)
- Não instala Open Design, Pencil nem Figma MCP (sob demanda — M6)
- Não modifica blocos `<!-- gitnexus:start -->` em `AGENTS.md` (M2)

---

## 4. Disambiguação de ficheiros `design` (M1)

| Ficheiro | Path | Propósito |
|----------|------|-----------|
| OpenSpec change design | `openspec/changes/<id>/design.md` | Decisões técnicas da mudança |
| Impeccable / marca | `DESIGN.md` (raiz ou app) | Contrato visual de produto |
| Open Design export | `design-exploration.md` ou `design/od/` | Exploração — renomear antes de merge |

Em prompts de agente: qualificar sempre qual `design` se refere.

---

## 5. Compatibilidade com stack SDD

| ID | Mitigação | Onde |
|----|-----------|------|
| M1 | Tabela acima | Este documento §4 |
| M2 | Impeccable não altera blocos GitNexus | `install-ui-module.sh` |
| M3 | Gate Node 24+ antes de `npx impeccable install` | Script + checklist §6 |
| M4 | Hook Impeccable pode bloquear apply massivo de UI | `detector.ignoreFiles` temporário em `.impeccable/config.json` |
| M5 | Pós C1-UI: `npx gitnexus analyze --force` + `graphify update .` | Checklist §6 |
| M6 | MCP design (OD/Pencil/Figma) sob demanda | `openspec/infra.md` |
| M7 | Skills Impeccable fora de `verify-task-patterns` | `.cursor/skills/impeccable` separado |

### Conflitos skills / hooks

| Artefacto | Path | Notas |
|-----------|------|-------|
| SDD skills | `.claude/skills/openspec-*`, `gitnexus/` | Não substituídas |
| Impeccable skill | `.cursor/skills/impeccable/` | Instalada pelo CLI Impeccable |
| GitNexus MCP | `mcp.json` | Coexiste com Figma/Pencil MCP |

**Regra de ouro:** mudanças de **comportamento** (Tipo C/D) → OpenSpec primeiro. Mudanças **só visuais** (Tipo A) → Impeccable sem change.

---

## 6. Checklist pós C1-UI

Ver também `doc/sistema-sdd-pedro.md` §2.11.1.

- [ ] `bash sdd-kit/install-ui-module.sh --detect` reporta stack correcta
- [ ] `doc/design/002-ui-module-install.md` e `003-ui-stack-adapters.md` presentes
- [ ] `openspec/infra.md` — secção UI Development Module actualizada
- [ ] `UI stack:` registado em `openspec/project.md`
- [ ] Node 24+ confirmado antes de Impeccable
- [ ] `DESIGN.md` na raiz (após Impeccable) — distinto de `openspec/.../design.md`
- [ ] `npx gitnexus analyze --force` (se `components/ui/` mudou)
- [ ] `graphify update .` (indexar `doc/design/*`)
- [ ] IDE reiniciada após skills Impeccable

---

## 7. Referências

- Guia canónico: `doc/sistema-sdd-pedro.md` §2.11, §5.6
- Adapters sem shadcn: [`003-ui-stack-adapters.md`](./003-ui-stack-adapters.md)
- Avaliação: `doc/avaliacoes/2026-06-27-sdd-ui-development-module.md`
- Spec: `openspec/specs/sdd-ui-module/spec.md` (após archive)

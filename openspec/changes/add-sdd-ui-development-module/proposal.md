# Proposal — Módulo SDD de desenvolvimento de UI

## Why

A documentação da pipeline de design (Open Design → Pencil/Figma → shadcn → Impeccable) foi importada para `doc/design/000-*` e `doc/design/001-*`, mas **não está integrada** no fluxo canónico de instalação SDD (`doc/sistema-sdd-pedro.md` + `sdd-kit/`).

Consequências actuais:

1. Agentes e operadores não sabem **quando** instalar o módulo UI nem **como** adaptá-lo a repos sem shadcn/ui.
2. A pipeline assume shadcn como Fase 2, mas projectos APP podem usar Tailwind custom, MUI ou legado — sem árvore de decisão formal.
3. O módulo UI misturado no C1 core arriscaria instalar Impeccable em hubs DOCS_SPECS ou APIs sem frontend.
4. Ferramentas do módulo (Impeccable, Open Design, Pencil) não têm registo em `doc/avaliacoes/` nem spec normativa `sdd-*`.

**Objectivo:** distribuir o **módulo de desenvolvimento de UI** como add-on pós-C1, com procedimento curto no guia canónico e detalhe preservado em `doc/design/*`, seguindo o padrão de quatro camadas do §1.6 (procedimento / payload / specs / estado).

## What Changes

### Nova capability: `sdd-ui-module`

| Artefacto | Função |
|-----------|--------|
| `doc/design/002-ui-module-install.md` | Procedimento, árvore shadcn (recomendado + opt-out), checklist C1-UI |
| `doc/design/003-ui-stack-adapters.md` | Variantes Fase 2 sem shadcn (tailwind-custom, other) |
| `sdd-kit/install-ui-module.sh` | Add-on pós-C1: `--detect`, `--dry-run`, `--apply`, `--yes` |
| `sdd-kit/templates/doc/design/*` | Cópia versionada dos quatro ficheiros de design |
| `doc/avaliacoes/2026-06-27-sdd-ui-development-module.md` | Avaliação agregada (Adiado → Adoptado condicionado) |

### Guia canónico — secções novas (sem duplicar pipeline)

| Secção | Conteúdo (~100 linhas total) |
|--------|------------------------------|
| **§1.6** (delta) | Cenário **C1-UI** — módulo UI opcional pós-C1 |
| **§2.11** | Quando instalar, comando, pré-requisitos, checklist |
| **§5.6** | Tabela de referências cruzadas ao módulo UI |

**Não** colar fluxos A–D, matrizes ou prompts do `001` no guia — apenas ponteiros (§5.3).

### Decisões de produto (exploração Jun/2026)

| Decisão | Escolha |
|---------|---------|
| Core vs add-on | `install-ui-module.sh` separado de `install.sh` |
| shadcn | **Recomendado** em Next.js+Tailwind; **opt-out explícito** |
| Nome `001-pipeline-open-design-shadcn-impeccable.md` | **Manter**; nota no topo: shadcn = caminho default |
| Impeccable no `--apply` | Sim, com confirmação (`--yes` ou prompt) |
| Open Design / Pencil | Documentar; instalar sob demanda (não no `--apply` automático) |
| Perfis | Docs para todos; `install-ui-module.sh` só APP/HYBRID com frontend |

### Campo novo em `openspec/project.md` (template)

```markdown
UI stack: shadcn | tailwind-custom | other | none
```

Registado em `openspec/infra.md` após `--apply` ou `--detect`.

## Capabilities

### New Capabilities

- **`sdd-ui-module`**: add-on pós-C1, detecção de stack, procedimento, adapters, gates de verificação.

### Modified Capabilities

- **`sdd-install-kit`**: `MANIFEST.yaml` inclui `install-ui-module.sh` e templates `doc/design/*`.
- **`sdd-post-install-verification`**: checklist opcional §2.11.1 referenciado.
- **`sdd-workspace-manifest`**: secção UI Module em `openspec/infra.md`.

## Impact

- Novo: `doc/design/002-*`, `doc/design/003-*`
- Novo: `sdd-kit/install-ui-module.sh`
- Novo: `sdd-kit/templates/doc/design/*` (000–003)
- Modificado: `doc/design/000-*`, `doc/design/001-*` (nota topo shadcn default)
- Modificado: `doc/sistema-sdd-pedro.md` (§1.6 delta, §2.11, §5.6)
- Modificado: `sdd-kit/MANIFEST.yaml`, `sdd-kit/README.md`
- Modificado: `sdd-kit/templates/AGENTS.core.md` (ponteiros UI se ≤150 linhas)
- Modificado: `openspec/infra.md`, `openspec/project.md` (template UI stack)
- Modificado: `AGENTS.md` (secção documentação UI — já parcialmente feita)
- Novo: `doc/avaliacoes/2026-06-27-sdd-ui-development-module.md`

## Non-Goals

- Instalar Impeccable/Open Design/Pencil no C1 core SDD.
- Tornar shadcn obrigatório para usar Impeccable.
- Renomear `001-pipeline-open-design-shadcn-impeccable.md`.
- Duplicar ~900 linhas da pipeline no guia canónico.
- Implementar código APP (Next.js pages) neste hub DOCS_SPECS.
- Pacote npm separado para o módulo UI — fase 2.

## Avaliação da direcção (resumo)

| Opção | Veredicto |
|-------|-----------|
| A — Só docs em `doc/design/` sem guia | ❌ Agentes não encontram o módulo na instalação |
| B — Integrar no C1 `install.sh` | ❌ Risco em DOCS_SPECS/API |
| C — Add-on `install-ui-module.sh` + §2.11 | ✅ **Escolhida** |
| D — shadcn obrigatório | ❌ Exclui stacks legados |
| E — shadcn opt-in puro | ❌ Maioria fica sem guidance |

Ver `design.md` para trade-offs e árvore de decisão completa.

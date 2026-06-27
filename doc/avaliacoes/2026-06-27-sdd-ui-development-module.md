# Avaliação: Módulo SDD de desenvolvimento de UI (Impeccable + Open Design + Pencil)

| Campo | Valor |
|-------|--------|
| **Data** | 2026-06-27 |
| **Avaliador** | Sessão OpenSpec `add-sdd-ui-development-module` |
| **Candidato** | Módulo agregado: [Impeccable](https://github.com/pbakaus/impeccable), [Open Design](https://github.com/nexu-io/open-design), [Pencil](https://www.pencil.dev) + pipeline shadcn/ui |
| **Decisão** | **Adopted** — integrar como add-on C1-UI via `sdd-kit/install-ui-module.sh` (condicionado a mitigações M1–M7) |
| **Escopo** | C1-UI pós-instalação core; runtime OD/Pencil sob demanda |

## Resumo executivo

O módulo UI distribui documentação de pipeline (Open Design → Pencil/Figma → shadcn → Impeccable) e um script add-on separado do C1 core. **Adoptado** porque complementa o stack SDD sem conflito estrutural (ver `research.md` do change). Impeccable entra no `--apply` apenas com confirmação (`--yes`); Open Design e Pencil ficam documentados para instalação manual.

## Problema que tentava resolver

- Pipeline importada em `doc/design/000-*` e `001-*` sem integração no guia canónico nem no `sdd-kit/`
- Agentes não sabiam quando instalar ferramentas de UI nem como adaptar repos sem shadcn
- Risco de instalar Impeccable em hubs DOCS_SPECS sem frontend

## O que foi analisado

- `doc/design/000-impeccable-design-system-guia.md` e `001-pipeline-open-design-shadcn-impeccable.md`
- `openspec/changes/add-sdd-ui-development-module/research.md` — matriz de compatibilidade SDD
- Precedente Supabase rule `030-supabase.mdc` (gate SKIP por detecção)
- `doc/avaliacoes/2026-03-26-headroom-context-compression.md` — modelo de avaliação por fase

## Encaixe no stack SDD

| Ferramenta | Relação |
|------------|---------|
| **OpenSpec** | Ortogonal — governa features; UI module governa craft visual. Disambiguar `openspec/.../design.md` vs `DESIGN.md` (M1) |
| **GitNexus** | Complementar — `impact` antes de editar `components/ui/`; reindex pós C1-UI (M5) |
| **Graphify** | Complementar — indexa `doc/design/*` após apply |
| **AGENTS.md / sdd-kit** | Ponteiros curtos em §2.11; Impeccable não altera blocos GitNexus (M2) |

## Riscos por fase do workflow

| Fase | Risco | Notas |
|------|-------|-------|
| **Explore** | OD/Pencil fora do repo | Commitar contrato Fase 2 no repo |
| **Propose** | Confusão `design.md` vs `DESIGN.md` | Tabela M1 em `002-ui-module-install.md` |
| **Apply** | Hook Impeccable bloqueia writes massivos | M4 — `ignoreFiles` temporário documentado |
| **Archive** | Nenhum | Spec `sdd-ui-module` promovida no archive |

## Ganhos esperados vs observados

| Ganho anunciado | Avaliação |
|-----------------|-----------|
| Pipeline POC → produção com guardrails | Validado em `topocnc-art`; requer adaptação por repo |
| Impeccable anti "AI slop" | 44 regras determinísticas; requer Node 24+ (M3) |
| Open Design exploração rápida | Opcional; não no `--apply` automático |
| Pencil prototipagem in-repo | Opcional; MCP sob demanda |

## Alternativas já no stack

- shadcn/ui já listado em `openspec/project.md` para APP — sem procedimento de instalação até este módulo
- Skills SDD (`openspec-*`, `gitnexus`) — separadas de Impeccable (M7)
- Guia §5.3 — apontar, não duplicar pipeline no guia canónico

## Decisão e condições de reavaliação

**Decisão:** **Adopted** — módulo C1-UI no `sdd-kit/` com `install-ui-module.sh` e `doc/design/002-*`, `003-*`.

**Condições para reavaliar:**

- Bump Node mínimo do repo para 24+ LTS (change separado)
- Pacote npm dedicado ao módulo UI (fase 2 — fora de escopo actual)
- Conflito comprovado entre hook Impeccable e session coordination

## Referências

- Change: `openspec/changes/add-sdd-ui-development-module/`
- Pipeline: `doc/design/001-pipeline-open-design-shadcn-impeccable.md`
- Compatibilidade: `openspec/changes/add-sdd-ui-development-module/research.md`
- [Impeccable](https://github.com/pbakaus/impeccable) · [Open Design](https://github.com/nexu-io/open-design) · [Pencil](https://www.pencil.dev)

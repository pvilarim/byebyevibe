# Design — Módulo SDD de desenvolvimento de UI

## Context

- Exploração `/opsx:explore` (Jun/2026): pipeline importada de `topocnc-art` para `doc/design/000-*` e `001-*`.
- Guia SDD v1.3.0 define quatro camadas (§1.6): procedimento, payload, specs, estado — e cenários C1–C3.
- `openspec/project.md` lista shadcn/ui como stack default para APP, mas não há procedimento de instalação do módulo UI.
- Precedente: Supabase rule `030-supabase.mdc` com gate `SKIP` — módulo opcional por detecção.
- Este repo (`spec-pedro`) é hub **DOCS_SPECS** + distribuidor `sdd-kit/`.

## Goals / Non-Goals

**Goals:**

- Integrar módulo UI no guia canónico com **ponteiros**, não duplicação (§5.3).
- Preservar detalhe operacional em `doc/design/001-*` (fluxos A–D, matrizes, prompts).
- Suportar repos **com** e **sem** shadcn via adapters documentados.
- Add-on determinístico `install-ui-module.sh` com `--detect` / `--dry-run` / `--apply`.
- Spec normativa `sdd-ui-module` antes de propagar no MANIFEST.
- Avaliação agregada em `doc/avaliacoes/` antes de adoptar no kit.

**Non-Goals:**

- Código de produção APP neste change.
- Instalação automática de OD/Pencil no `--apply`.
- Renomear ficheiros `001-*`.
- Bump guia para v2.0 — delta incremental (v1.3.1 ou v1.4.0 conforme changelog).

## Knowledge sources consulted

- `doc/design/000-impeccable-design-system-guia.md` — Impeccable isolado
- `doc/design/001-pipeline-open-design-shadcn-impeccable.md` — pipeline completa
- `doc/sistema-sdd-pedro.md` §1.6, §5.1–§5.3, §12.10
- `openspec/specs/sdd-install-kit/spec.md` — padrão MANIFEST + install.sh
- `openspec/changes/archive/2026-06-17-add-sdd-install-kit/design.md` — modelo 4 camadas
- [Impeccable](https://github.com/pbakaus/impeccable) — agnóstico a design system se `DESIGN.md` existir
- [Open Design](https://github.com/nexu-io/open-design), [Pencil](https://www.pencil.dev) — runtime opcional

## Alternatives considered

### A — Pipeline só em `doc/design/` (status quo)

**Rejeitado:** agentes na instalação SDD não descobrem o módulo.

### B — Integrar no `sdd-kit/install.sh` (C1)

**Rejeitado:** instalaria Impeccable em DOCS_SPECS puro ou repos sem frontend.

### C — Add-on `install-ui-module.sh` pós-C1 (ESCOLHIDO)

| Prós | Contras |
|------|---------|
| Separação core SDD vs UI | Dois scripts para manter |
| `--detect` evita installs errados | Operador deve saber ordem C1 → C1-UI |
| Alinha com Supabase SKIP | |

### D — shadcn obrigatório

**Rejeitado:** exclui MUI, Chakra, legado.

### E — shadcn opt-in puro

**Rejeitado:** maioria dos projectos Next+Tailwind fica sem recomendação clara.

### F — shadcn recomendado + opt-out explícito (ESCOLHIDO)

Prompt no `--detect` ou `--apply` sem `--yes`: *"Recomendamos shadcn/ui. Instalar? [Y/n]"*. Recusa → Caminho B em `003`.

## Decisions

| ID | Decisão | Rationale |
|----|---------|-----------|
| D1 | Cenário **C1-UI** documentado em §1.6 | Distinto de C1 core e C3 specs |
| D2 | `install-ui-module.sh` separado | Não alterar contrato C1 existente |
| D3 | Guia §2.11 ≤ ~80 linhas + §5.6 tabela | §5.3 — apontar, não copiar |
| D4 | `002` install + `003` adapters | Gap entre pipeline e instalação |
| D5 | Manter nome `001-pipeline-open-design-shadcn-impeccable.md` | Evitar quebra de links |
| D6 | Nota no topo de `000`/`001`: shadcn = default | Clarificar sem rename |
| D7 | `UI stack` em `project.md` template | Constituição por repo |
| D8 | Impeccable no `--apply` com `--yes` | Evita install surpresa |
| D9 | OD/Pencil fora do `--apply` | Vendor/runtime; sob demanda |
| D10 | Docs `doc/design/*` no kit para **todos** perfis | Referência no hub |
| D11 | `install-ui-module.sh` gate: perfil APP/HYBRID + frontend | DOCS_SPECS: distribui docs só |
| D12 | `.cursor/skills/impeccable` separado de skills SDD | Documentar em `002`; não misturar verify |
| D13 | Avaliação agregada única em `doc/avaliacoes/` | §5.5 — registo antes de kit |
| D14 | Fase 2 = **UI_STACK adapter** | Generaliza pipeline sem reescrever `001` |

## Modelo do módulo UI

### Quatro camadas (alinhado §1.6)

```
┌────────────────────────────────────────────────────────────┐
│ Procedimento  doc/sistema-sdd-pedro.md §2.11, §5.6         │
├────────────────────────────────────────────────────────────┤
│ Payload       sdd-kit/install-ui-module.sh + templates/    │
├────────────────────────────────────────────────────────────┤
│ Specs         openspec/specs/sdd-ui-module/spec.md         │
├────────────────────────────────────────────────────────────┤
│ Estado        openspec/infra.md (Impeccable, UI stack)     │
├────────────────────────────────────────────────────────────┤
│ Detalhe       doc/design/000–003 (não duplicar no guia)    │
└────────────────────────────────────────────────────────────┘
```

### Pipeline reframed (preserva `001`)

```
Fase 1a   Open Design        → agnóstico
Fase 1b   Pencil / Figma     → shadcn preferencial, não obrigatório
Fase 2    UI_STACK adapter   → shadcn | tailwind-custom | other
Fase 3    Impeccable         → agnóstico se DESIGN.md + tokens existem
```

### Árvore de detecção (`--detect`)

```
                    package.json + (app/ | apps/web/)?
                           │
              ┌────────────┴────────────┐
             NÃO                       SIM
              │                         │
         SKIP: no frontend      detect_ui_stack()
         (nota infra.md)              │
                    ┌─────────────────┼─────────────────┐
                    │                 │                 │
              SHADCN_OK        TAILWIND_ONLY        OTHER
           components.json      tailwind, no ui/    MUI, etc.
           ou components/ui/          │                 │
                    │                 │                 │
              Caminho A          prompt shadcn?     Caminho C
              (001 completo)     Y → A  N → B      (003 + manual)
```

### Caminhos por stack

| Caminho | Condição | Fase 2 | Fase 3 |
|---------|----------|--------|--------|
| **A** | shadcn presente ou instalado | `001` §4 tal como está | Impeccable full |
| **B** | Tailwind, recusa shadcn | `003` tailwind-custom | Impeccable via `document` |
| **C** | other (MUI, etc.) | `003` manual | Impeccable se React/CSS UI |
| **SKIP** | sem frontend | n/a | n/a |

## Integração no guia canónico (esboço §2.11)

```markdown
### 2.11 Módulo de desenvolvimento de UI (C1-UI, opcional)

**Pré-requisito:** C1 concluído (§2.8).
**Perfis:** APP, HYBRID com frontend. DOCS_SPECS: só documentação.

1. bash sdd-kit/install-ui-module.sh --detect
2. Ler doc/design/002-ui-module-install.md §1 (decisão shadcn)
3. bash sdd-kit/install-ui-module.sh --apply [--yes]
4. Checklist §2.11.1

Detalhe: doc/design/001-pipeline-...md (não duplicar aqui).
```

## Integração `sdd-kit/MANIFEST.yaml`

Novos entries (exemplo):

```yaml
  - path: sdd-kit/install-ui-module.sh
    source: templates/install-ui-module.sh
    merge: COPY
    profiles: [APP, DOCS_SPECS, HYBRID]
    gate: "test -x sdd-kit/install-ui-module.sh"

  - path: doc/design/002-ui-module-install.md
    source: templates/doc/design/002-ui-module-install.md
    merge: COPY
    profiles: [APP, DOCS_SPECS, HYBRID]
    gate: "test -f doc/design/002-ui-module-install.md"
```

## Riscos e mitigações

| Risco | Mitigação |
|-------|-----------|
| Drift guia ↔ `001` | Guia só ponteiros; pipeline vive em `doc/design/` |
| Impeccable vs skills SDD | `002` § conflitos; `infra.md` regista paths |
| shadcn no nome do `001` confunde | Nota topo + `003` para alternativas |
| Install em repo sem Node 24+ | Gate em `002` checklist; falha explícita |
| Hub instala Impeccable por engano | `--detect` SKIP sem `app/` |

## Behavioral parity

- C1 core (`install.sh`) comportamento **inalterado**.
- C3 (propagação specs) **não** dispara `install-ui-module.sh`.
- `doc/design/000` e `001` conteúdo técnico **preservado**; apenas notas de adaptação no topo.

## Open questions (resolvidas neste design)

| Pergunta | Resolução |
|----------|-----------|
| Script separado ou flag em install.sh? | Separado (D2) |
| shadcn opt-in vs opt-out? | Recomendado + opt-out (D6/F) |
| Renomear 001? | Não (D5) |
| Impeccable automático? | Com `--yes` (D8) |
| Docs em todos perfis? | Sim (D10) |

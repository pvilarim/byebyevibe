# UI stack adapters — Fase 2 sem shadcn (Caminhos B e C)

> **shadcn/ui é o caminho default** para projectos Next.js + Tailwind. Este documento cobre **opt-out** explícito e stacks alternativas.
>
> Caminho A (shadcn): [`001-pipeline-open-design-shadcn-impeccable.md`](./001-pipeline-open-design-shadcn-impeccable.md) §4.

**Campo de constituição:** `UI stack: shadcn | tailwind-custom | other | none` em `openspec/project.md`.

---

## 1. Visão geral dos caminhos

| Caminho | `UI_STACK` | Fase 2 | Fase 3 (Impeccable) |
|---------|------------|--------|---------------------|
| **A** | `shadcn` | `001` §4 — shadcn init + tokens | Full (`polish`, `audit`, …) |
| **B** | `tailwind-custom` | Tokens em `globals.css`; componentes manuais | `/impeccable document` para sincronizar `DESIGN.md` |
| **C** | `other` | MUI, Chakra, Radix puro, legado | Impeccable se React + CSS UI |
| **SKIP** | `none` | Sem frontend | N/A |

---

## 2. Caminho B — `tailwind-custom`

### Quando usar

- Operador recusou shadcn no prompt C1-UI (`install-ui-module.sh`)
- Tailwind configurado (`tailwind.config.*`, `globals.css`) sem `components/ui/`

### Procedimento Fase 2

1. Definir tokens CSS semânticos em `globals.css` (cores, radius, spacing)
2. Criar componentes base em `components/ui/` **sem** shadcn CLI — ou pasta equivalente
3. Documentar decisões em `DESIGN.md` (raiz) — contrato de marca
4. Open Design / Pencil: exportar paleta e tipografia; commitar screenshots em `doc/design/` se útil

### Impeccable

```bash
# Após DESIGN.md e tokens existirem
npx impeccable document
npx impeccable audit
```

Impeccable é **agnóstico** ao design system se `DESIGN.md` + tokens existem.

### Pencil / Figma

- Prototipar com componentes Tailwind genéricos (não assumir `Button` shadcn)
- Mapear classes Tailwind no `DESIGN.md` em vez de variantes shadcn

---

## 3. Caminho C — `other`

### Quando usar

- `package.json` inclui `@mui/material`, `@chakra-ui/react`, `antd`, etc.
- Monorepo legado com UI library própria

### Procedimento Fase 2

1. **Não** correr `npx shadcn@latest init`
2. Registar `UI stack: other` em `openspec/project.md`
3. Adaptar [`001`](./001-pipeline-open-design-shadcn-impeccable.md) mentalmente:
   - Fase 1b (Pencil/Figma): usar componentes da library existente
   - Fase 2: tokens da library + theme provider
4. Impeccable: focar em layout, tipografia, acessibilidade — `/impeccable layout`, `/impeccable typeset`

### Limitações

- Pipeline `001` assume shadcn na Fase 2 — exemplos de código precisam tradução manual
- GitNexus impact analysis continua válido para ficheiros React

---

## 4. Detecção automática (`install-ui-module.sh --detect`)

| Sinal no repo | `UI_STACK` reportado |
|---------------|----------------------|
| `components.json` | `shadcn` |
| `components/ui/` + padrões shadcn | `shadcn` |
| `tailwind.config.*` sem ui/ | `tailwind-custom` (prompt shadcn) |
| `@mui/*`, `@chakra-ui/*`, etc. | `other` |
| Sem `app/` nem frontend | `none` (SKIP) |

---

## 5. Registo de estado

Após decisão:

1. Actualizar `openspec/project.md`: `UI stack: <valor>`
2. Actualizar `openspec/infra.md` — secção UI Development Module
3. Seguir checklist em [`002-ui-module-install.md`](./002-ui-module-install.md) §6

---

## 6. Referências

- Instalação C1-UI: [`002-ui-module-install.md`](./002-ui-module-install.md)
- Pipeline completa (Caminho A): [`001-pipeline-open-design-shadcn-impeccable.md`](./001-pipeline-open-design-shadcn-impeccable.md)
- Impeccable isolado: [`000-impeccable-design-system-guia.md`](./000-impeccable-design-system-guia.md)

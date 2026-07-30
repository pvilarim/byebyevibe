# UI stack adapters — Phase 2 without shadcn (Paths B and C)

> **shadcn/ui is the default path** for Next.js + Tailwind projects. This document covers explicit **opt-out** and alternative stacks.
>
> Path A (shadcn): [`001-pipeline-open-design-shadcn-impeccable.md`](./001-pipeline-open-design-shadcn-impeccable.md) §4.

**Constitution field:** `UI stack: shadcn | tailwind-custom | other | none` in `openspec/project.md`.

---

## 1. Path overview

| Path | `UI_STACK` | Phase 2 | Phase 3 (Impeccable) |
|---------|------------|--------|---------------------|
| **A** | `shadcn` | `001` §4 — shadcn init + tokens | Full (`polish`, `audit`, …) |
| **B** | `tailwind-custom` | Tokens in `globals.css`; manual components | `/impeccable document` to sync `DESIGN.md` |
| **C** | `other` | MUI, Chakra, plain Radix, legacy | Impeccable if React + CSS UI |
| **SKIP** | `none` | No frontend | N/A |

---

## 2. Path B — `tailwind-custom`

### When to use

- Operator declined shadcn in the C1-UI prompt (`install-ui-module.sh`)
- Tailwind configured (`tailwind.config.*`, `globals.css`) without `components/ui/`

### Phase 2 procedure

1. Define semantic CSS tokens in `globals.css` (colors, radius, spacing)
2. Create base components in `components/ui/` **without** shadcn CLI — or equivalent folder
3. Document decisions in `DESIGN.md` (root) — brand contract
4. Open Design / Pencil: export palette and typography; commit screenshots in `doc/design/` if useful

### Impeccable

```bash
# After DESIGN.md and tokens exist
npx impeccable document
npx impeccable audit
```

Impeccable is **agnostic** to the design system if `DESIGN.md` + tokens exist.

### Pencil / Figma

- Prototype with generic Tailwind components (do not assume shadcn `Button`)
- Map Tailwind classes in `DESIGN.md` instead of shadcn variants

---

## 3. Path C — `other`

### When to use

- `package.json` includes `@mui/material`, `@chakra-ui/react`, `antd`, etc.
- Legacy monorepo with its own UI library

### Phase 2 procedure

1. **Do not** run `npx shadcn@latest init`
2. Record `UI stack: other` in `openspec/project.md`
3. Adapt [`001`](./001-pipeline-open-design-shadcn-impeccable.md) mentally:
   - Phase 1b (Pencil/Figma): use existing library components
   - Phase 2: library tokens + theme provider
4. Impeccable: focus on layout, typography, accessibility — `/impeccable layout`, `/impeccable typeset`

### Limitations

- Pipeline `001` assumes shadcn in Phase 2 — code examples need manual translation
- GitNexus impact analysis remains valid for React files

---

## 4. Automatic detection (`install-ui-module.sh --detect`)

| Signal in repo | Reported `UI_STACK` |
|---------------|----------------------|
| `components.json` | `shadcn` |
| `components/ui/` + shadcn patterns | `shadcn` |
| `tailwind.config.*` without ui/ | `tailwind-custom` (shadcn prompt) |
| `@mui/*`, `@chakra-ui/*`, etc. | `other` |
| No `app/` or frontend | `none` (SKIP) |

---

## 5. State registration

After decision:

1. Update `openspec/project.md`: `UI stack: <value>`
2. Update `openspec/infra.md` — UI Development Module section
3. Follow checklist in [`002-ui-module-install.md`](./002-ui-module-install.md) §6

---

## 6. References

- C1-UI installation: [`002-ui-module-install.md`](./002-ui-module-install.md)
- Full pipeline (Path A): [`001-pipeline-open-design-shadcn-impeccable.md`](./001-pipeline-open-design-shadcn-impeccable.md)
- Impeccable standalone: [`000-impeccable-design-system-guia.md`](./000-impeccable-design-system-guia.md)

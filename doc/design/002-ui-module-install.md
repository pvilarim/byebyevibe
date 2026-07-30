# SDD UI Development Module — installation (C1-UI)

> **C1-UI scenario** — optional add-on **after** C1 core (`sdd-kit/install.sh`). Does not replace the OpenSpec + GitNexus + Graphify stack.

**Command:** `bash sdd-kit/install-ui-module.sh --detect` → `--apply [--yes]`

**Pipeline detail:** [`001-pipeline-open-design-shadcn-impeccable.md`](./001-pipeline-open-design-shadcn-impeccable.md) (flows A–D, matrices, prompts — **not** duplicated here).

---

## 1. When to install

| Profile | Action |
|--------|--------|
| **APP** / **HYBRID** with `app/` or `apps/web/` | Run C1-UI after checklist §2.8 |
| **DOCS_SPECS** without frontend | `--detect` → `SKIP: no frontend`; `doc/design/*` docs distributed by the kit |
| **API-only** | SKIP — no UI module |

### Prerequisites

1. C1 complete (`doc/sistema-sdd-pedro.md` §2.8)
2. Node.js **24+** in the dev environment **if** installing Impeccable (gate M3)
3. Next.js + Tailwind (recommended) or stack documented in [`003-ui-stack-adapters.md`](./003-ui-stack-adapters.md)

---

## 2. Detection tree (`--detect`)

```
package.json + (app/ | apps/web/)?
         │
    ┌────┴────┐
   NO        YES
    │         │
 SKIP      detect_ui_stack()
```

| Result | Condition | Path |
|-----------|----------|---------|
| `SKIP: no frontend` | No `app/`, `apps/web/`, or `package.json` with React deps | N/A |
| `UI stack: shadcn` | `components.json` or `components/ui/` | **A** — full `001` |
| `UI stack: tailwind-custom` | Tailwind present, no shadcn | **B** — see `003` |
| `UI stack: other` | MUI, Chakra, etc. | **C** — see `003` |

### shadcn decision (recommended + opt-out)

For Next.js + Tailwind repos **without** a detected design system:

```
We recommend shadcn/ui as the default path (Phase 2).
Install shadcn? [Y/n]
```

- **Y** (or `--yes` in the script) → Path A; follow `001` §4
- **n** → `UI stack: tailwind-custom`; follow [`003-ui-stack-adapters.md`](./003-ui-stack-adapters.md)

---

## 3. Commands

```bash
# Detection (always first)
bash sdd-kit/install-ui-module.sh --detect

# Simulate operations
bash sdd-kit/install-ui-module.sh --dry-run --apply

# Apply (copies doc/design/*; Impeccable only with --yes)
bash sdd-kit/install-ui-module.sh --apply --yes
```

### What `--apply` does

1. Copies `doc/design/000`–`003` from `sdd-kit/templates/doc/design/` (if missing or kit is newer)
2. Updates `openspec/infra.md` — UI Development Module section
3. Records `UI stack` in `openspec/project.md` (if field present)
4. **With `--yes`:** runs `npx impeccable install` (Node 24+ required)
5. **Without `--yes`:** does not install Impeccable; operator confirms manually

### What `--apply` **does not** do

- Does not change C1 core (`install.sh`)
- Does not install Open Design, Pencil, or Figma MCP (on demand — M6)
- Does not modify `<!-- gitnexus:start -->` blocks in `AGENTS.md` (M2)

---

## 4. `design` file disambiguation (M1)

| File | Path | Purpose |
|----------|------|-----------|
| OpenSpec change design | `openspec/changes/<id>/design.md` | Technical decisions for the change |
| Impeccable / brand | `DESIGN.md` (root or app) | Product visual contract |
| Open Design export | `design-exploration.md` or `design/od/` | Exploration — rename before merge |

In agent prompts: always qualify which `design` is meant.

---

## 5. SDD stack compatibility

| ID | Mitigation | Where |
|----|-----------|------|
| M1 | Table above | This document §4 |
| M2 | Impeccable does not alter GitNexus blocks | `install-ui-module.sh` |
| M3 | Node 24+ gate before `npx impeccable install` | Script + checklist §6 |
| M4 | Impeccable hook may block mass UI apply | Temporary `detector.ignoreFiles` in `.impeccable/config.json` |
| M5 | After C1-UI: `npx gitnexus analyze --force` + `graphify update .` | Checklist §6 |
| M6 | Design MCP (OD/Pencil/Figma) on demand | `openspec/infra.md` |
| M7 | Impeccable skills outside `verify-task-patterns` | `.cursor/skills/impeccable` separate |

### Skills / hooks conflicts

| Artifact | Path | Notes |
|-----------|------|-------|
| SDD skills | `.claude/skills/openspec-*`, `gitnexus/` | Not replaced |
| Impeccable skill | `.cursor/skills/impeccable/` | Installed by Impeccable CLI |
| GitNexus MCP | `mcp.json` | Coexists with Figma/Pencil MCP |

**Golden rule:** **behavior** changes (Type C/D) → OpenSpec first. **Visual-only** changes (Type A) → Impeccable without a change.

---

## 6. Post C1-UI checklist

See also `doc/sistema-sdd-pedro.md` §2.11.1.

- [ ] `bash sdd-kit/install-ui-module.sh --detect` reports correct stack
- [ ] `doc/design/002-ui-module-install.md` and `003-ui-stack-adapters.md` present
- [ ] `openspec/infra.md` — UI Development Module section updated
- [ ] `UI stack:` recorded in `openspec/project.md`
- [ ] Node 24+ confirmed before Impeccable
- [ ] `DESIGN.md` at repo root (after Impeccable) — distinct from `openspec/.../design.md`
- [ ] `npx gitnexus analyze --force` (if `components/ui/` changed)
- [ ] `graphify update .` (index `doc/design/*`)
- [ ] IDE restarted after Impeccable skills

---

## 7. References

- Canonical guide: `doc/sistema-sdd-pedro.md` §2.11, §5.6
- Adapters without shadcn: [`003-ui-stack-adapters.md`](./003-ui-stack-adapters.md)
- Evaluation: `doc/avaliacoes/2026-06-27-sdd-ui-development-module.md`
- Spec: `openspec/specs/sdd-ui-module/spec.md` (after archive)

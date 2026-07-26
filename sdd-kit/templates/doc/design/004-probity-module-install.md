# Módulo SDD Probity (G2) — instalação

> **Cenário G2** — add-on opcional **após** C1 core (`sdd-kit/install.sh`). Materializa R6 (`enforceTdd`) via PreToolUse. **Não** substitui CI (`sdd-gates`).

**Comando:** `bash sdd-kit/install-probity-module.sh --detect` → `--apply [--yes]`

**Pin:** `@nizos/probity@1.10.0` (MIT) — [nizos/probity](https://github.com/nizos/probity)

**Nota histórica:** TDD Guard foi superseded por Probity (2026-07). Não re-propor TDD Guard.

---

## 1. Quando instalar

| Perfil | Acção |
|--------|--------|
| **APP** / **HYBRID** com Vitest, Jest ou pytest | Correr após C1; **piloto obrigatório** antes de activar em produção |
| **DOCS_SPECS** sem test runner | `--detect` → `SKIP: no test runner` |
| Hub de specs | Scaffolding no kit apenas — não activar Probity |

### Pré-requisitos

1. C1 concluído (`AGENTS.md` + `openspec/infra.md`)
2. Test runner presente (`vitest` / `jest` / `pytest`)
3. GitNexus + Graphify activos (piloto mede empilhamento de 3 hooks)
4. R11 session coordination em apply local

---

## 2. Detecção (`--detect`)

```
AGENTS.md + openspec/infra.md?
         │
    ┌────┴────┐
   NÃO       SIM
    │         │
 WARN      detect_test_runner()
              │
         ┌────┴────┐
       none      vitest|jest|pytest
         │         │
       SKIP     Probity: applicable
```

---

## 3. Comandos

```bash
bash sdd-kit/install-probity-module.sh --detect
bash sdd-kit/install-probity-module.sh --dry-run --apply
bash sdd-kit/install-probity-module.sh --apply --yes
bash sdd-kit/install-probity-module.sh --uninstall
```

### O que `--apply` faz

1. Copia `probity.config.ts` (raiz) com `enforceTdd()` + `forbidCommandPattern(/rm\s+-rf/)`
2. Copia este doc para `doc/design/004-probity-module-install.md`
3. `npm install -D @nizos/probity@1.10.0` (com `--yes`)
4. Actualiza `openspec/infra.md` — secção Probity Module

### O que `--apply` **não** faz

- Não altera C1 core (`install.sh`)
- Não instala TDD Guard
- Não modifica blocos `<!-- gitnexus:start -->` em `AGENTS.md`
- Não activa lint-before-commit (`requireCommand` — opt-in, ver §7)

### Plugin Claude Code (obrigatório após apply)

```text
/plugin marketplace add nizos/probity
/plugin install probity@probity
# Reiniciar sessão Claude Code
```

Ordem sugerida de hooks PreToolUse: **GitNexus → Graphify → Probity**.

---

## 4. Piloto (obrigatório antes de activação default)

Critérios em `openspec/changes/add-probity-tdd-module/design.md`:

| Critério | Threshold |
|----------|-----------|
| Latência PreToolUse extra p95 | < 8s (N≥30 edits) |
| Falsos positivos tipo C | < 15% (N≥5 sessões) |
| Tipo B R6 compliance | 100% (N≥3 sessões) |
| Cursor IDE hooks | Disparam **OU** documentar "só Claude Code" |

Falhou → status "Adiado" na avaliação G2; `--uninstall`; não promover em consumidores.

---

## 5. Cursor IDE

Probity documenta Claude Code, Codex e Copilot CLI. Cursor third-party hooks: [docs](https://cursor.com/docs/reference/third-party-hooks).

**Estado:** validar no piloto (`preToolUse` ↔ PreToolUse). Se falhar: Claude Code primário; documentar limitação no guia §2.16.

---

## 6. Desligar / rollback

| Método | Quando |
|--------|--------|
| Globs em `probity.config.ts` | Excluir paths (já exclui `doc/**`, `openspec/**`, `sdd-kit/**`) |
| Tipo A (R1) | Não editar código de produção |
| Desinstalar plugin | Sessão só-docs |
| `--uninstall` | Remover módulo do repo |

```bash
bash sdd-kit/install-probity-module.sh --uninstall
/plugin uninstall probity@probity
```

---

## 7. Lint opt-in (gap — não no template default)

Probity oferece `requireCommand({ before: git commit, command: /npm run lint/ })`. Repos SDD variam de linter — **não** incluir no template. Adicionar manualmente se o repo tiver `npm run lint` estável.

---

## 8. Matriz A–E

| Tipo | Probity `enforceTdd` |
|------|---------------------|
| A — Trivial | off (globs) |
| B — Bug fix | **on** |
| C — Refactor | on |
| D — Feature | on |
| E — Exploração | n/a |

**Pipeline:** apply → enforceTdd (R6/Probity) → `correctness-review` → `simplify-review` → `security-reviewer` → commit → sdd-gates.

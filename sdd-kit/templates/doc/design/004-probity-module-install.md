# SDD Probity Module (G2) — installation

> **G2 scenario** — optional add-on **after** C1 core (`sdd-kit/install.sh`). Materializes R6 (`enforceTdd`) via PreToolUse. **Does not** replace CI (`sdd-gates`).

**Command:** `bash sdd-kit/install-probity-module.sh --detect` → `--apply [--yes]`

**Pin:** `@nizos/probity@1.10.0` (MIT) — [nizos/probity](https://github.com/nizos/probity)

**Historical note:** TDD Guard was superseded by Probity (2026-07). Do not re-propose TDD Guard.

---

## 1. When to install

| Profile | Action |
|--------|--------|
| **APP** / **HYBRID** with Vitest, Jest, or pytest | Run after C1; **pilot required** before enabling in production |
| **DOCS_SPECS** without test runner | `--detect` → `SKIP: no test runner` |
| Specs hub | Kit scaffolding only — do not enable Probity |

### Prerequisites

1. C1 complete (`AGENTS.md` + `openspec/infra.md`)
2. Test runner present (`vitest` / `jest` / `pytest`)
3. GitNexus + Graphify active (pilot measures stacking of 3 hooks)
4. R11 session coordination on local apply

---

## 2. Detection (`--detect`)

```
AGENTS.md + openspec/infra.md?
         │
    ┌────┴────┐
   NO        YES
    │         │
 WARN      detect_test_runner()
              │
         ┌────┴────┐
       none      vitest|jest|pytest
         │         │
       SKIP     Probity: applicable
```

---

## 3. Commands

```bash
bash sdd-kit/install-probity-module.sh --detect
bash sdd-kit/install-probity-module.sh --dry-run --apply
bash sdd-kit/install-probity-module.sh --apply --yes
bash sdd-kit/install-probity-module.sh --uninstall
```

### What `--apply` does

1. Copies `probity.config.ts` (root) with `enforceTdd()` + `forbidCommandPattern(/rm\s+-rf/)`
2. Copies this doc to `doc/design/004-probity-module-install.md`
3. `npm install -D @nizos/probity@1.10.0` (with `--yes`)
4. Updates `openspec/infra.md` — Probity Module section

### What `--apply` **does not** do

- Does not change C1 core (`install.sh`)
- Does not install TDD Guard
- Does not modify `<!-- gitnexus:start -->` blocks in `AGENTS.md`
- Does not enable lint-before-commit (`requireCommand` — opt-in, see §7)

### Claude Code plugin (required after apply)

```text
/plugin marketplace add nizos/probity
/plugin install probity@probity
# Restart Claude Code session
```

Suggested PreToolUse hook order: **GitNexus → Graphify → Probity**.

---

## 4. Pilot (required before default activation)

Criteria in `openspec/changes/add-probity-tdd-module/design.md`:

| Criterion | Threshold |
|----------|-----------|
| Extra PreToolUse latency p95 | < 8s (N≥30 edits) |
| Type C false positives | < 15% (N≥5 sessions) |
| Type B R6 compliance | 100% (N≥3 sessions) |
| Cursor IDE hooks | Fire **OR** document "Claude Code only" |

Failed → "Deferred" status in G2 evaluation; `--uninstall`; do not promote to consumers.

---

## 5. Cursor IDE

Probity documents Claude Code, Codex, and Copilot CLI. Cursor third-party hooks: [docs](https://cursor.com/docs/reference/third-party-hooks).

**Status:** validate in pilot (`preToolUse` ↔ PreToolUse). If it fails: Claude Code primary; document limitation in guide §2.16.

---

## 6. Disable / rollback

| Method | When |
|--------|--------|
| Globs in `probity.config.ts` | Exclude paths (already excludes `doc/**`, `openspec/**`, `sdd-kit/**`) |
| Type A (R1) | Do not edit production code |
| Uninstall plugin | Docs-only session |
| `--uninstall` | Remove module from repo |

```bash
bash sdd-kit/install-probity-module.sh --uninstall
/plugin uninstall probity@probity
```

---

## 7. Lint opt-in (gap — not in default template)

Probity offers `requireCommand({ before: git commit, command: /npm run lint/ })`. SDD repos vary in linter — **do not** include in the template. Add manually if the repo has a stable `npm run lint`.

---

## 8. A–E matrix

| Type | Probity `enforceTdd` |
|------|---------------------|
| A — Trivial | off (globs) |
| B — Bug fix | **on** |
| C — Refactor | on |
| D — Feature | on |
| E — Exploration | n/a |

**Pipeline:** apply → enforceTdd (R6/Probity) → `correctness-review` → `simplify-review` → `security-reviewer` → commit → sdd-gates.

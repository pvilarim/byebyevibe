# Tasks — translate-commands-wave-1

> Apply after human approval (R7). **In-place PT→EN** on `opsx-apply` command mirrors + minimal G-MIRROR peer-map fix. **Issue:** —

## 1. Prep (glossary + freeze)

- [x] 1.1 Confirm glossary covers terms needed for this wave; append rows to `doc/i18n/GLOSSARY.md` only if a new SDD term is introduced (same PR)
  - **Pattern:** `doc/i18n/GLOSSARY.md`
  - **Invariants:** `sdd-docs-language` — Glossary and wave inventory exist
  - **Gate:** `test -s doc/i18n/GLOSSARY.md && grep -qE 'Session Handoff|skill|wave|glossary|fail-closed|archive' doc/i18n/GLOSSARY.md`
  - **Forbidden:** invent synonym variants for glossary terms; dual-file `*.en.md` / `*-pt.md`

## 2. Fix G-MIRROR peer map for asymmetric opsx commands

- [x] 2.1 Update `scripts/verify-i18n-wave.sh` so `mirror_peer` maps `.cursor/commands/opsx-<verb>.md` ↔ `.claude/commands/opsx/<verb>.md`; for command pairs require peers listed + files exist but do **not** `cmp -s`; keep skill mirror `cmp -s` unchanged
  - **Pattern:** `scripts/verify-i18n-wave.sh`
  - **Invariants:** `sdd-docs-language` — G-MIRROR understands asymmetric opsx command paths
  - **Gate:** `grep -qE 'opsx/|commands/opsx' scripts/verify-i18n-wave.sh && bash scripts/verify-i18n-wave.sh --help >/dev/null`
  - **Forbidden:** weakening skill G-MIRROR `cmp`; rewriting unrelated gates; translating command targets in this task

## 3. Substitute opsx-apply command mirrors (in-place)

- [x] 3.1 Rewrite `.cursor/commands/opsx-apply.md` residual Portuguese prose (R11 coordination stubs, Session Handoff stubs, simplify-review suggestion copy, and any other deny-list hits) → glossary-canonical English; keep Cursor YAML frontmatter (`name`/`id`/…); freeze `/opsx:*`, R11 script names, apply workflow semantics, and fenced shell; align handoff stubs with F7 (MAY pt-BR — do not hard-require Portuguese-only responses)
  - **Pattern:** `AGENTS.md`
  - **Invariants:** `sdd-docs-language` — opsx-apply command mirrors are English; Freeze list of non-translatable tokens
  - **Gate:** `test -f .cursor/commands/opsx-apply.md && ! test -f .cursor/commands/opsx-apply.en.md && ! test -f .cursor/commands/opsx-apply-pt.md && grep -qF '/opsx:apply' .cursor/commands/opsx-apply.md && grep -qF 'sdd-session-register.sh' .cursor/commands/opsx-apply.md && grep -qiE 'Session Handoff|Session coordination' .cursor/commands/opsx-apply.md && ! grep -qiE 'Antes de editar ficheiros|Ao concluir ou pausar|assumir ✅|n[aã]o reinstalar|N ficheiros|Esta fase terminou|Cole no primeiro|artefactos pendentes' .cursor/commands/opsx-apply.md`
  - **Forbidden:** dual-file siblings; changing R11 flock/register/release semantics; rewriting `/opsx:*`; drive-by edits to other commands or skills

- [x] 3.2 Rewrite `.claude/commands/opsx/apply.md` residual Portuguese prose to the same English meaning as the Cursor body; keep Claude-specific YAML frontmatter (`name`/`tags`/…); freeze `/opsx:*` and R11 semantics
  - **Pattern:** `.cursor/commands/opsx-apply.md`
  - **Invariants:** `sdd-docs-language` — opsx-apply command mirrors are English
  - **Gate:** `test -f .claude/commands/opsx/apply.md && ! test -f .claude/commands/opsx/apply.en.md && ! test -f .claude/commands/opsx/apply-pt.md && grep -qF '/opsx:apply' .claude/commands/opsx/apply.md && grep -qF 'sdd-session-register.sh' .claude/commands/opsx/apply.md && ! grep -qiE 'Antes de editar ficheiros|Ao concluir ou pausar|assumir ✅|n[aã]o reinstalar|N ficheiros|Esta fase terminou|Cole no primeiro|artefactos pendentes' .claude/commands/opsx/apply.md`
  - **Forbidden:** forcing byte-identical frontmatter with Cursor; updating only one side; dual-file siblings

## 4. Wave gates

- [x] 4.1 Run per-wave i18n verification on the exact opsx-apply command file list
  - **Pattern:** `scripts/verify-i18n-wave.sh`
  - **Invariants:** `sdd-docs-language` — Per-wave and global verification script; opsx-apply command mirrors are English; G-MIRROR understands asymmetric opsx command paths
  - **Gate:** `bash scripts/verify-i18n-wave.sh --files .cursor/commands/opsx-apply.md,.claude/commands/opsx/apply.md`
  - **Forbidden:** marking tasks done if G-PT/G-INV/G-LINK/G-MIRROR/G-OPENSPEC fail; running `--dod` as a required gate for this wave

- [x] 4.2 Validate OpenSpec change + task Pattern paths
  - **Pattern:** `scripts/verify-task-patterns.sh`
  - **Gate:** `bash scripts/verify-task-patterns.sh && OPENSPEC_TELEMETRY=0 npx --yes @fission-ai/openspec@1.3.1 validate translate-commands-wave-1 --strict`

## 5. Post-register (best-effort)

- [x] 5.1 `graphify update .` if available (docs/commands/script touched); otherwise SKIP per infra
  - **Pattern:** `.cursor/rules/graphify.mdc`
  - **Gate:** `test -f graphify-out/GRAPH_REPORT.md || echo 'SKIP (graphify unavailable)'`
  - **Note:** SKIP if graphify CLI unavailable

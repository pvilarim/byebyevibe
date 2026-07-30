# Tasks — translate-agents-rules-wave-1c

> Apply after human approval (R7). **In-place PT→EN only** on the four remaining W1 Cursor rules (stack-scoped + graphify). Completes the W1 agents/rules track. **Issue:** —

## 1. Prep (glossary + freeze)

- [x] 1.1 Confirm glossary covers terms needed for this wave; append rows to `doc/i18n/GLOSSARY.md` only if a new SDD term is introduced (same PR)
  - **Pattern:** `doc/i18n/GLOSSARY.md`
  - **Invariants:** `sdd-docs-language` — Glossary and wave inventory exist
  - **Gate:** `test -s doc/i18n/GLOSSARY.md && grep -qE 'Session Handoff|apply|propose|fail-closed|worktree|wave' doc/i18n/GLOSSARY.md`
  - **Proibido:** invent synonym variants for glossary terms; dual-file `*.en.md` / `*-pt.md`

## 2. Substitute stack-scoped rules (in-place)

- [x] 2.1 Rewrite `.cursor/rules/010-typescript.mdc` Portuguese prose → glossary-canonical English at the same path; translate frontmatter `description`; freeze `globs`, `alwaysApply: false`, and identifiers `cn`, `Zod`, `@/`, named exports / Result / Tailwind composition guidance meaning
  - **Pattern:** `.cursor/rules/010-typescript.mdc`
  - **Invariants:** `sdd-docs-language` — Stack-scoped Cursor rules (W1c slice) are English; Waves replace Portuguese in-place — dual-file forbidden
  - **Gate:** `test -f .cursor/rules/010-typescript.mdc && ! test -f .cursor/rules/010-typescript.en.mdc && grep -q 'cn()' .cursor/rules/010-typescript.mdc && grep -q 'Zod' .cursor/rules/010-typescript.mdc && grep -q 'alwaysApply: false' .cursor/rules/010-typescript.mdc`
  - **Proibido:** dual-file siblings; translating path/glob strings; changing `alwaysApply`; rewriting `cn`/`Zod`

- [x] 2.2 Rewrite `.cursor/rules/020-python.mdc` Portuguese prose → English; translate `description`; freeze `globs`, `alwaysApply: false`, and identifiers `structlog`, `pytest-asyncio`, `Pydantic`, `asyncio`, `core/errors.py`
  - **Pattern:** `.cursor/rules/020-python.mdc`
  - **Invariants:** `sdd-docs-language` — Stack-scoped Cursor rules (W1c slice) are English; Freeze list of non-translatable tokens
  - **Gate:** `test -f .cursor/rules/020-python.mdc && ! test -f .cursor/rules/020-python.en.mdc && grep -q 'structlog' .cursor/rules/020-python.mdc && grep -q 'pytest-asyncio' .cursor/rules/020-python.mdc && grep -q 'alwaysApply: false' .cursor/rules/020-python.mdc`
  - **Proibido:** dual-file siblings; translating identifier/path strings; changing `alwaysApply`

- [x] 2.3 Rewrite `.cursor/rules/030-supabase.mdc` Portuguese prose → English; translate `description`; freeze `globs`, `alwaysApply: false`, and identifiers `RLS`, `ivfflat`, `Zod`, path `infra/supabase/schemas.ts`
  - **Pattern:** `.cursor/rules/030-supabase.mdc`
  - **Invariants:** `sdd-docs-language` — Stack-scoped Cursor rules (W1c slice) are English; Freeze list of non-translatable tokens
  - **Gate:** `test -f .cursor/rules/030-supabase.mdc && ! test -f .cursor/rules/030-supabase.en.mdc && grep -q 'RLS' .cursor/rules/030-supabase.mdc && grep -q 'ivfflat' .cursor/rules/030-supabase.mdc && grep -q 'infra/supabase/schemas.ts' .cursor/rules/030-supabase.mdc && grep -q 'alwaysApply: false' .cursor/rules/030-supabase.mdc`
  - **Proibido:** dual-file siblings; weakening RLS deny-by-default meaning; translating globs/paths/identifiers

- [x] 2.4 Verify `.cursor/rules/graphify.mdc` is English (body already EN); translate `description` only if residual PT; freeze `alwaysApply: true`, paths `graphify-out/`, `graphify-out/GRAPH_REPORT.md`, and command `graphify update .`
  - **Pattern:** `.cursor/rules/graphify.mdc`
  - **Invariants:** `sdd-docs-language` — Stack-scoped Cursor rules (W1c slice) are English; Freeze list of non-translatable tokens
  - **Gate:** `test -f .cursor/rules/graphify.mdc && ! test -f .cursor/rules/graphify.en.mdc && grep -q 'graphify-out/GRAPH_REPORT.md' .cursor/rules/graphify.mdc && grep -qF 'graphify update .' .cursor/rules/graphify.mdc && grep -q 'alwaysApply: true' .cursor/rules/graphify.mdc`
  - **Proibido:** dual-file siblings; drive-by rewrites of already-EN prose; translating paths/commands; changing `alwaysApply`

## 3. Wave gates

- [x] 3.1 Run per-wave i18n verification on the exact W1c file list
  - **Pattern:** `scripts/verify-i18n-wave.sh`
  - **Invariants:** `sdd-docs-language` — Per-wave and global verification script; Stack-scoped Cursor rules (W1c slice) are English
  - **Gate:** `bash scripts/verify-i18n-wave.sh --files .cursor/rules/010-typescript.mdc,.cursor/rules/020-python.mdc,.cursor/rules/030-supabase.mdc,.cursor/rules/graphify.mdc`
  - **Proibido:** marking tasks done if G-PT/G-INV/G-LINK/G-OPENSPEC fail; running `--dod` as a required gate for this wave

- [x] 3.2 Validate OpenSpec change + task Pattern paths
  - **Pattern:** `scripts/verify-task-patterns.sh`
  - **Gate:** `bash scripts/verify-task-patterns.sh && OPENSPEC_TELEMETRY=0 npx --yes @fission-ai/openspec@1.3.1 validate translate-agents-rules-wave-1c --strict`

## 4. Post-register (best-effort)

- [x] 4.1 `graphify update .` if available (rules/docs touched); otherwise SKIP per infra
  - **Pattern:** `.cursor/rules/graphify.mdc`
  - **Gate:** `test -f graphify-out/GRAPH_REPORT.md || echo 'SKIP (graphify unavailable)'`
  - **Note:** SKIP expected if `GRAPH_REPORT.md` absent in this environment

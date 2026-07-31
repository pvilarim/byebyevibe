# Tasks — translate-skills-wave-5

> Apply after human approval (R7). **In-place PT→EN only** on `openspec-archive-change` skill mirrors. **Issue:** —

## 1. Prep (glossary + freeze)

- [x] 1.1 Confirm glossary covers terms needed for this wave; append rows to `doc/i18n/GLOSSARY.md` only if a new SDD term is introduced (same PR)
  - **Pattern:** `doc/i18n/GLOSSARY.md`
  - **Invariants:** `sdd-docs-language` — Glossary and wave inventory exist
  - **Gate:** `test -s doc/i18n/GLOSSARY.md && grep -qE 'Session Handoff|skill|wave|glossary|fail-closed|archive' doc/i18n/GLOSSARY.md`
  - **Forbidden:** invent synonym variants for glossary terms; dual-file `*.en.md` / `*-pt.md`

## 2. Substitute openspec-archive-change mirrors (in-place)

- [x] 2.1 Rewrite `.cursor/skills/openspec-archive-change/SKILL.md` residual Portuguese prose (pattern-promotion prompt, Session Handoff stubs, metrics-cadence nudge, and any other deny-list hits) → glossary-canonical English; keep YAML keys/`name`/`license`/`compatibility`/`metadata`; freeze `/opsx:archive` `/opsx:explore` `/opsx:propose`, skill directory name `openspec-archive-change`, Guardrails semantics (prompt for selection; don't block on warnings; sync assessment), optional pattern-promotion checklist meaning, advisory metrics cadence, and fenced shell; align handoff stubs with F7 (MAY pt-BR — do not hard-require Portuguese-only responses)
  - **Pattern:** `AGENTS.md`
  - **Invariants:** `sdd-docs-language` — openspec-archive-change skill mirrors are English; Freeze list of non-translatable tokens
  - **Gate:** `test -f .cursor/skills/openspec-archive-change/SKILL.md && ! test -f .cursor/skills/openspec-archive-change/SKILL.en.md && ! test -f .cursor/skills/openspec-archive-change/SKILL-pt.md && grep -q '^name: openspec-archive-change$' .cursor/skills/openspec-archive-change/SKILL.md && grep -qF '/opsx:archive' .cursor/skills/openspec-archive-change/SKILL.md && grep -qiE 'Session Handoff|Guardrails|Archive Complete|sdd-metrics' .cursor/skills/openspec-archive-change/SKILL.md && ! grep -qiE 'Arquivo conclu[ií]do|Sugest[aã]o: novo chat|Cole no primeiro|assumir|n[aã]o reinstalar|Este change estabeleceu|antes de arquivar|Ap[oó]s archive bem-sucedido|<t[oó]pico>|<descri[cç][aã]o>' .cursor/skills/openspec-archive-change/SKILL.md`
  - **Forbidden:** dual-file siblings; changing archive sync assessment, pattern-promotion optionality, or metrics-cadence advisory behavior; rewriting `/opsx:*` or skill directory names; drive-by edits to other skills or commands

- [x] 2.2 Sync `.claude/skills/openspec-archive-change/SKILL.md` to match the Cursor mirror exactly (same English content)
  - **Pattern:** `.cursor/skills/openspec-archive-change/SKILL.md`
  - **Invariants:** `sdd-docs-language` — openspec-archive-change skill mirrors are English
  - **Gate:** `cmp -s .cursor/skills/openspec-archive-change/SKILL.md .claude/skills/openspec-archive-change/SKILL.md && ! test -f .claude/skills/openspec-archive-change/SKILL.en.md && ! test -f .claude/skills/openspec-archive-change/SKILL-pt.md`
  - **Forbidden:** divergent wording between mirrors; updating only one side

## 3. Wave gates

- [x] 3.1 Run per-wave i18n verification on the exact skill mirror file list
  - **Pattern:** `scripts/verify-i18n-wave.sh`
  - **Invariants:** `sdd-docs-language` — Per-wave and global verification script; openspec-archive-change skill mirrors are English
  - **Gate:** `bash scripts/verify-i18n-wave.sh --files .cursor/skills/openspec-archive-change/SKILL.md,.claude/skills/openspec-archive-change/SKILL.md`
  - **Forbidden:** marking tasks done if G-PT/G-INV/G-LINK/G-MIRROR/G-OPENSPEC fail; running `--dod` as a required gate for this wave

- [x] 3.2 Validate OpenSpec change + task Pattern paths
  - **Pattern:** `scripts/verify-task-patterns.sh`
  - **Gate:** `bash scripts/verify-task-patterns.sh && OPENSPEC_TELEMETRY=0 npx --yes @fission-ai/openspec@1.3.1 validate translate-skills-wave-5 --strict`

## 4. Post-register (best-effort)

- [x] 4.1 `graphify update .` if available (docs/skills touched); otherwise SKIP per infra
  - **Pattern:** `.cursor/rules/graphify.mdc`
  - **Gate:** `test -f graphify-out/GRAPH_REPORT.md || echo 'SKIP (graphify unavailable)'`
  - **Note:** SKIP if graphify CLI unavailable

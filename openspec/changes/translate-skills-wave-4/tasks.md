# Tasks — translate-skills-wave-4

> Apply after human approval (R7). **In-place PT→EN only** on `openspec-propose` skill mirrors. **Issue:** —

## 1. Prep (glossary + freeze)

- [ ] 1.1 Confirm glossary covers terms needed for this wave; append rows to `doc/i18n/GLOSSARY.md` only if a new SDD term is introduced (same PR)
  - **Pattern:** `doc/i18n/GLOSSARY.md`
  - **Invariants:** `sdd-docs-language` — Glossary and wave inventory exist
  - **Gate:** `test -s doc/i18n/GLOSSARY.md && grep -qE 'Session Handoff|skill|wave|glossary|fail-closed' doc/i18n/GLOSSARY.md`
  - **Forbidden:** invent synonym variants for glossary terms; dual-file `*.en.md` / `*-pt.md`

## 2. Substitute openspec-propose mirrors (in-place)

- [ ] 2.1 Rewrite `.cursor/skills/openspec-propose/SKILL.md` residual Portuguese prose (Session Handoff stub — phase-complete nudge, paste-into-first-message line, “Ler:” / “assumir ✅ — não reinstalar”, and any other deny-list hits) → glossary-canonical English; keep YAML keys/`name`/`license`/`compatibility`/`metadata`; freeze `/opsx:propose` `/opsx:apply`, OpenSpec CLI fences, §12.10 Gate/Pattern/Skill rules, propose workflow Steps/Output/Guardrails structure, and fenced shell; align handoff stubs with F7 (MAY pt-BR — do not hard-require Portuguese-only responses)
  - **Pattern:** `AGENTS.md`
  - **Invariants:** `sdd-docs-language` — openspec-propose skill mirrors are English; Freeze list of non-translatable tokens
  - **Gate:** `test -f .cursor/skills/openspec-propose/SKILL.md && ! test -f .cursor/skills/openspec-propose/SKILL.en.md && ! test -f .cursor/skills/openspec-propose/SKILL-pt.md && grep -q '^name: openspec-propose$' .cursor/skills/openspec-propose/SKILL.md && grep -qF '/opsx:apply' .cursor/skills/openspec-propose/SKILL.md && grep -qF '§12.10' .cursor/skills/openspec-propose/SKILL.md && grep -qiE 'Session Handoff' .cursor/skills/openspec-propose/SKILL.md && grep -qiE 'do not reinstall|assume' .cursor/skills/openspec-propose/SKILL.md && ! grep -qiE 'Esta fase terminou|Sugestão: abrir|Cole no primeiro|não reinstalar|assumir ✅|Ler: proposal' .cursor/skills/openspec-propose/SKILL.md`
  - **Forbidden:** dual-file siblings; changing propose workflow Steps, AskUserQuestion flow, or §12.10 Gate/Pattern rules; rewriting `/opsx:*` or skill directory names; drive-by edits to other skills or commands

- [ ] 2.2 Sync `.claude/skills/openspec-propose/SKILL.md` to match the Cursor mirror exactly (same English content)
  - **Pattern:** `.cursor/skills/openspec-propose/SKILL.md`
  - **Invariants:** `sdd-docs-language` — openspec-propose skill mirrors are English
  - **Gate:** `cmp -s .cursor/skills/openspec-propose/SKILL.md .claude/skills/openspec-propose/SKILL.md && ! test -f .claude/skills/openspec-propose/SKILL.en.md && ! test -f .claude/skills/openspec-propose/SKILL-pt.md`
  - **Forbidden:** divergent wording between mirrors; updating only one side

## 3. Wave gates

- [ ] 3.1 Run per-wave i18n verification on the exact skill mirror file list
  - **Pattern:** `scripts/verify-i18n-wave.sh`
  - **Invariants:** `sdd-docs-language` — Per-wave and global verification script; openspec-propose skill mirrors are English
  - **Gate:** `bash scripts/verify-i18n-wave.sh --files .cursor/skills/openspec-propose/SKILL.md,.claude/skills/openspec-propose/SKILL.md`
  - **Forbidden:** marking tasks done if G-PT/G-INV/G-LINK/G-MIRROR/G-OPENSPEC fail; running `--dod` as a required gate for this wave

- [ ] 3.2 Validate OpenSpec change + task Pattern paths
  - **Pattern:** `scripts/verify-task-patterns.sh`
  - **Gate:** `bash scripts/verify-task-patterns.sh && OPENSPEC_TELEMETRY=0 npx --yes @fission-ai/openspec@1.3.1 validate translate-skills-wave-4 --strict`

## 4. Post-register (best-effort)

- [ ] 4.1 `graphify update .` if available (docs/skills touched); otherwise SKIP per infra
  - **Pattern:** `.cursor/rules/graphify.mdc`
  - **Gate:** `test -f graphify-out/GRAPH_REPORT.md || echo 'SKIP (graphify unavailable)'`
  - **Note:** SKIP if graphify CLI unavailable

# Tasks — translate-skills-wave-2

> Apply after human approval (R7). **In-place PT→EN only** on `simplify-review` skill mirrors. **Issue:** —

## 1. Prep (glossary + freeze)

- [ ] 1.1 Confirm glossary covers terms needed for this wave; append rows to `doc/i18n/GLOSSARY.md` only if a new SDD term is introduced (same PR)
  - **Pattern:** `doc/i18n/GLOSSARY.md`
  - **Invariants:** `sdd-docs-language` — Glossary and wave inventory exist
  - **Gate:** `test -s doc/i18n/GLOSSARY.md && grep -qE 'Session Handoff|skill|wave|glossary|fail-closed' doc/i18n/GLOSSARY.md`
  - **Forbidden:** invent synonym variants for glossary terms; dual-file `*.en.md` / `*-pt.md`

## 2. Substitute simplify-review mirrors (in-place)

- [ ] 2.1 Rewrite `.cursor/skills/simplify-review/SKILL.md` Portuguese prose (frontmatter `description`/`adaptedFrom`, headings, tables, examples, verdicts, integration notes) → glossary-canonical English; keep YAML keys/`name`/`license`/`metadata`; freeze finding tags `delete:`/`stdlib:`/`native:`/`yagni:`/`shrink:`, marker `sdd-shortcut:`, `/opsx:apply`, sibling skill names, numeric thresholds (~80 lines / >4 files), protected-boundary table semantics, and fenced shell; align chat guidance with F7 (MAY pt-BR — do not hard-require Portuguese-only responses); map verdict `ESCOPO CONFLITANTE` → `CONFLICTING SCOPE` and vocabulary `achados` → `findings` without changing tag identifiers
  - **Pattern:** `AGENTS.md`
  - **Invariants:** `sdd-docs-language` — simplify-review skill mirrors are English; Freeze list of non-translatable tokens
  - **Gate:** `test -f .cursor/skills/simplify-review/SKILL.md && ! test -f .cursor/skills/simplify-review/SKILL.en.md && ! test -f .cursor/skills/simplify-review/SKILL-pt.md && grep -q '^name: simplify-review$' .cursor/skills/simplify-review/SKILL.md && grep -qE 'Post-implementation|When to invoke' .cursor/skills/simplify-review/SKILL.md && grep -qF 'delete:' .cursor/skills/simplify-review/SKILL.md && grep -qF 'yagni:' .cursor/skills/simplify-review/SKILL.md && grep -qF 'sdd-shortcut:' .cursor/skills/simplify-review/SKILL.md && grep -qF '/opsx:apply' .cursor/skills/simplify-review/SKILL.md && grep -qF 'correctness-review' .cursor/skills/simplify-review/SKILL.md && grep -qiE 'CONFLICTING SCOPE|Conflicting scope' .cursor/skills/simplify-review/SKILL.md && grep -qiE 'findings' .cursor/skills/simplify-review/SKILL.md && ! grep -qiE 'não aplica|ficheiro|Responder sempre em|ESCOPO CONFLITANTE|achados:|Quando invocar|Pós-implementação' .cursor/skills/simplify-review/SKILL.md`
  - **Forbidden:** dual-file siblings; changing invoke thresholds, tag set, or protected boundaries; rewriting `/opsx:*` or sibling skill directory names; drive-by edits to other skills

- [ ] 2.2 Sync `.claude/skills/simplify-review/SKILL.md` to match the Cursor mirror exactly (same English content)
  - **Pattern:** `.cursor/skills/simplify-review/SKILL.md`
  - **Invariants:** `sdd-docs-language` — simplify-review skill mirrors are English
  - **Gate:** `cmp -s .cursor/skills/simplify-review/SKILL.md .claude/skills/simplify-review/SKILL.md && ! test -f .claude/skills/simplify-review/SKILL.en.md && ! test -f .claude/skills/simplify-review/SKILL-pt.md`
  - **Forbidden:** divergent wording between mirrors; updating only one side

## 3. Wave gates

- [ ] 3.1 Run per-wave i18n verification on the exact skill mirror file list
  - **Pattern:** `scripts/verify-i18n-wave.sh`
  - **Invariants:** `sdd-docs-language` — Per-wave and global verification script; simplify-review skill mirrors are English
  - **Gate:** `bash scripts/verify-i18n-wave.sh --files .cursor/skills/simplify-review/SKILL.md,.claude/skills/simplify-review/SKILL.md`
  - **Forbidden:** marking tasks done if G-PT/G-INV/G-LINK/G-MIRROR/G-OPENSPEC fail; running `--dod` as a required gate for this wave

- [ ] 3.2 Validate OpenSpec change + task Pattern paths
  - **Pattern:** `scripts/verify-task-patterns.sh`
  - **Gate:** `bash scripts/verify-task-patterns.sh && OPENSPEC_TELEMETRY=0 npx --yes @fission-ai/openspec@1.3.1 validate translate-skills-wave-2 --strict`

## 4. Post-register (best-effort)

- [ ] 4.1 `graphify update .` if available (docs/skills touched); otherwise SKIP per infra
  - **Pattern:** `.cursor/rules/graphify.mdc`
  - **Gate:** `test -f graphify-out/GRAPH_REPORT.md || echo 'SKIP (graphify unavailable)'`
  - **Note:** SKIP if graphify CLI unavailable

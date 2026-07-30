# Tasks — translate-commands-wave-3

> Apply after human approval (R7). **In-place PT→EN** on `opsx-propose` command mirrors. Prefer apply base that already includes `translate-commands-wave-1` G-MIRROR peer map. **Issue:** —

## 1. Prep (glossary + freeze + prerequisite)

- [ ] 1.1 Confirm glossary covers terms needed for this wave; append rows to `doc/i18n/GLOSSARY.md` only if a new SDD term is introduced (same PR)
  - **Pattern:** `doc/i18n/GLOSSARY.md`
  - **Invariants:** `sdd-docs-language` — Glossary and wave inventory exist
  - **Gate:** `test -s doc/i18n/GLOSSARY.md && grep -qE 'Session Handoff|skill|wave|glossary|fail-closed|propose' doc/i18n/GLOSSARY.md`
  - **Forbidden:** invent synonym variants for glossary terms; dual-file `*.en.md` / `*-pt.md`

- [ ] 1.2 Confirm asymmetric opsx G-MIRROR peer map is present on the apply base (from `translate-commands-wave-1`); if missing, stop with Session Handoff naming the prerequisite — do not weaken skill `cmp`
  - **Pattern:** `scripts/verify-i18n-wave.sh`
  - **Invariants:** `sdd-docs-language` — G-MIRROR understands asymmetric opsx command paths (wave-1)
  - **Gate:** `grep -qE 'opsx/|commands/opsx' scripts/verify-i18n-wave.sh`
  - **Forbidden:** re-implementing the peer-map fix in this wave; weakening skill G-MIRROR `cmp`

## 2. Substitute opsx-propose command mirrors (in-place)

- [ ] 2.1 Rewrite `.cursor/commands/opsx-propose.md` residual Portuguese prose (Session Handoff stubs and any other deny-list hits) → glossary-canonical English; keep Cursor YAML frontmatter (`name`/`id`/…); freeze `/opsx:*`, propose workflow Steps/Output, and §12.10 enriched-tasks rules; align handoff stubs with F7 (MAY pt-BR — do not hard-require Portuguese-only responses)
  - **Pattern:** `AGENTS.md`
  - **Invariants:** `sdd-docs-language` — opsx-propose command mirrors are English; Freeze list of non-translatable tokens
  - **Gate:** `test -f .cursor/commands/opsx-propose.md && ! test -f .cursor/commands/opsx-propose.en.md && ! test -f .cursor/commands/opsx-propose-pt.md && grep -qF '/opsx:propose' .cursor/commands/opsx-propose.md && grep -qiE 'Session Handoff' .cursor/commands/opsx-propose.md && ! grep -qiE 'Esta fase terminou|Sugest[aã]o: abrir novo chat|contexto limpo|Cole no primeiro|assumir ✅|n[aã]o reinstalar|^Ler:' .cursor/commands/opsx-propose.md`
  - **Forbidden:** dual-file siblings; changing propose Steps/Output or §12.10 semantics; rewriting `/opsx:*`; drive-by edits to other commands or skills; editing `scripts/verify-i18n-wave.sh`; editing `.cursor/skills/openspec-propose/`

- [ ] 2.2 Rewrite `.claude/commands/opsx/propose.md` residual Portuguese prose to the same English meaning as the Cursor body; keep Claude-specific YAML frontmatter (`name`/`tags`/…); freeze `/opsx:*` and propose semantics
  - **Pattern:** `.cursor/commands/opsx-propose.md`
  - **Invariants:** `sdd-docs-language` — opsx-propose command mirrors are English
  - **Gate:** `test -f .claude/commands/opsx/propose.md && ! test -f .claude/commands/opsx/propose.en.md && ! test -f .claude/commands/opsx/propose-pt.md && grep -qF '/opsx:propose' .claude/commands/opsx/propose.md && ! grep -qiE 'Esta fase terminou|Sugest[aã]o: abrir novo chat|contexto limpo|Cole no primeiro|assumir ✅|n[aã]o reinstalar|^Ler:' .claude/commands/opsx/propose.md`
  - **Forbidden:** forcing byte-identical frontmatter with Cursor; updating only one side; dual-file siblings; editing `.claude/skills/openspec-propose/`

## 3. Wave gates

- [ ] 3.1 Run per-wave i18n verification on the exact opsx-propose command file list
  - **Pattern:** `scripts/verify-i18n-wave.sh`
  - **Invariants:** `sdd-docs-language` — Per-wave and global verification script; opsx-propose command mirrors are English
  - **Gate:** `bash scripts/verify-i18n-wave.sh --files .cursor/commands/opsx-propose.md,.claude/commands/opsx/propose.md`
  - **Forbidden:** marking tasks done if G-PT/G-INV/G-LINK/G-MIRROR/G-OPENSPEC fail; running `--dod` as a required gate for this wave

- [ ] 3.2 Validate OpenSpec change + task Pattern paths
  - **Pattern:** `scripts/verify-task-patterns.sh`
  - **Gate:** `bash scripts/verify-task-patterns.sh && OPENSPEC_TELEMETRY=0 npx --yes @fission-ai/openspec@1.3.1 validate translate-commands-wave-3 --strict`

## 4. Post-register (best-effort)

- [ ] 4.1 `graphify update .` if available (docs/commands touched); otherwise SKIP per infra
  - **Pattern:** `.cursor/rules/graphify.mdc`
  - **Gate:** `test -f graphify-out/GRAPH_REPORT.md || echo 'SKIP (graphify unavailable)'`
  - **Note:** SKIP if graphify CLI unavailable

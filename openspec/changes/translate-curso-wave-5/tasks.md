# Tasks — translate-curso-wave-5

> Apply after human approval (R7). **In-place PT→EN only** on the listed `doc/curso/scripts/` file. **Issue:** —

## 1. Prep (glossary + freeze)

- [ ] 1.1 Confirm glossary covers terms needed for this wave (`Session Handoff`, wave, canonical, Definition of Done); append rows to `doc/i18n/GLOSSARY.md` only if a new SDD term is introduced (same PR)
  - **Pattern:** `doc/i18n/GLOSSARY.md`
  - **Invariants:** `sdd-docs-language` — Glossary and wave inventory exist
  - **Gate:** `test -s doc/i18n/GLOSSARY.md && grep -qE 'Session Handoff|wave|glossary|canonical|Definition of Done' doc/i18n/GLOSSARY.md`
  - **Forbidden:** invent synonym variants for glossary terms; dual-file `*.en.md` / `*-pt.md`; editing workshop lessons or other `doc/curso/` files in this prep task

## 2. Substitute course-scripts surface (in-place)

- [ ] 2.1 Rewrite `doc/curso/scripts/AGENTS.md` Portuguese prose (title/intro, Commands table headers and usage blurbs, Prerequisites / Local rules / Flow headings and prose) → glossary-canonical English; keep `../../../AGENTS.md` pointer, script filenames `extract-lessons-batch.py` / `enrich-transcripts.py` / `_debug-lessons345.py`, CDP flag `--remote-debugging-port=9222`, VTT path `techleads.club/media_transcripts/`, Tech Leads Club auth note, `performance.clearResourceTimings()`, output patterns `aula-XX-workshop-*.md` / `aula-XX-shared-files.md`, Python 3.10+, and A–E / security inheritance intact
  - **Pattern:** `doc/curso/scripts/AGENTS.md`
  - **Invariants:** `sdd-docs-language` — Course wave-5 scripts AGENTS.md is English; Freeze list of non-translatable tokens
  - **Gate:** `test -f doc/curso/scripts/AGENTS.md && ! test -f doc/curso/scripts/AGENTS.en.md && ! test -f doc/curso/scripts/AGENTS-pt.md && grep -qF '../../../AGENTS.md' doc/curso/scripts/AGENTS.md && grep -qF 'extract-lessons-batch.py' doc/curso/scripts/AGENTS.md && grep -qF 'enrich-transcripts.py' doc/curso/scripts/AGENTS.md && grep -qF '--remote-debugging-port=9222' doc/curso/scripts/AGENTS.md && grep -qF 'techleads.club/media_transcripts/' doc/curso/scripts/AGENTS.md && grep -qiE 'Prerequisites|Local rules|Flow|Commands' doc/curso/scripts/AGENTS.md && ! grep -qiE 'Scripts do curso|Pré-requisitos|Regras locais|^## Fluxo|canónico|Não commitar|antes de navegar' doc/curso/scripts/AGENTS.md`
  - **Forbidden:** dual-file siblings; drive-by edits to workshop lessons (including aulas owned by `translate-curso-wave-1`..`4`) / shared-files / root `AGENTS.md`; changing CDP extract/enrich workflow semantics beyond language; leaving residual Portuguese prose

## 3. Wave gates

- [ ] 3.1 Run per-wave i18n verification on the exact course-scripts file
  - **Pattern:** `scripts/verify-i18n-wave.sh`
  - **Invariants:** `sdd-docs-language` — Per-wave and global verification script; Course wave-5 scripts AGENTS.md is English
  - **Gate:** `bash scripts/verify-i18n-wave.sh --files doc/curso/scripts/AGENTS.md`
  - **Forbidden:** marking tasks done if G-PT/G-INV/G-OPENSPEC fail; running `--dod` as a required gate for this wave; touching `sdd-kit/templates/` in this apply

- [ ] 3.2 Validate OpenSpec change + task Pattern paths
  - **Pattern:** `scripts/verify-task-patterns.sh`
  - **Gate:** `bash scripts/verify-task-patterns.sh && OPENSPEC_TELEMETRY=0 npx --yes @fission-ai/openspec@1.3.1 validate translate-curso-wave-5 --strict`

## 4. Post-register (best-effort)

- [ ] 4.1 `graphify update .` if available (docs touched); otherwise SKIP per infra
  - **Pattern:** `.cursor/rules/graphify.mdc`
  - **Gate:** `test -f graphify-out/GRAPH_REPORT.md || echo 'SKIP (graphify unavailable)'`
  - **Note:** SKIP if graphify CLI unavailable

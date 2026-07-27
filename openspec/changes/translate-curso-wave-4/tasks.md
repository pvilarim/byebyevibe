# Tasks — translate-curso-wave-4

> Apply after human approval (R7). **In-place PT→EN only** on the listed `doc/curso/` file. **Issue:** —

## 1. Prep (glossary + freeze)

- [ ] 1.1 Confirm glossary covers terms needed for this wave (`Session Handoff`, wave, evaluation, canonical, Definition of Done); append rows to `doc/i18n/GLOSSARY.md` only if a new SDD term is introduced (same PR)
  - **Pattern:** `doc/i18n/GLOSSARY.md`
  - **Invariants:** `sdd-docs-language` — Glossary and wave inventory exist
  - **Gate:** `test -s doc/i18n/GLOSSARY.md && grep -qE 'Session Handoff|wave|glossary|evaluation|canonical|Definition of Done' doc/i18n/GLOSSARY.md`
  - **Forbidden:** invent synonym variants for glossary terms; dual-file `*.en.md` / `*-pt.md`; editing other `doc/curso/` lessons in this prep task

## 2. Substitute course surface (in-place)

- [ ] 2.1 Rewrite `doc/curso/aula-01-workshop-ia-5-2026.md` Portuguese prose (title, summary, topics, link-table category labels, spoken-reference blurbs, how-to-use blurb, and full transcript body) → glossary-canonical English; keep lesson URL, Section/Lesson/Transcript ID values, duration, relative link to `aula-01-shared-files.md`, numbered link URLs, brand/tool names, speaker **Waldemar Neto (Valdemar)**, and adoption / Context Engineering / RPI talk facts intact; heading `Transcrição` → `Transcript` (or equivalent EN)
  - **Pattern:** `doc/curso/aula-01-workshop-ia-5-2026.md`
  - **Invariants:** `sdd-docs-language` — Course wave-4 workshop lesson 01 is English; Freeze list of non-translatable tokens
  - **Gate:** `test -f doc/curso/aula-01-workshop-ia-5-2026.md && ! test -f doc/curso/aula-01-workshop-ia-5-2026.en.md && ! test -f doc/curso/aula-01-workshop-ia-5-2026-pt.md && grep -qF 'aula-01-shared-files.md' doc/curso/aula-01-workshop-ia-5-2026.md && grep -qF 'https://www.techleads.club' doc/curso/aula-01-workshop-ia-5-2026.md && grep -qiE 'Transcript|Summary|Topics' doc/curso/aula-01-workshop-ia-5-2026.md && grep -qiE 'Waldemar|Valdemar|AGENTS\.md|Cursor|DORA|MCP' doc/curso/aula-01-workshop-ia-5-2026.md && ! grep -qiE 'Tópicos tratados|Referências na fala|Como usar:|Transcrição|Arquivo de Apresentação|Pesquisas e Referências Citadas' doc/curso/aula-01-workshop-ia-5-2026.md`
  - **Forbidden:** dual-file siblings; drive-by edits to other aulas (including aula-02 / `translate-curso-wave-3`, aula-03 / `translate-curso-wave-2`, and aula-04 / `translate-curso-wave-1`) / shared-files / `doc/curso/scripts/AGENTS.md`; changing adoption / Context Engineering / RPI talk facts or tooling recommendations beyond language; leaving raw Portuguese transcript prose

## 3. Wave gates

- [ ] 3.1 Run per-wave i18n verification on the exact course file
  - **Pattern:** `scripts/verify-i18n-wave.sh`
  - **Invariants:** `sdd-docs-language` — Per-wave and global verification script; Course wave-4 workshop lesson 01 is English
  - **Gate:** `bash scripts/verify-i18n-wave.sh --files doc/curso/aula-01-workshop-ia-5-2026.md`
  - **Forbidden:** marking tasks done if G-PT/G-INV/G-LINK/G-OPENSPEC fail; running `--dod` as a required gate for this wave; touching `sdd-kit/templates/` in this apply

- [ ] 3.2 Validate OpenSpec change + task Pattern paths
  - **Pattern:** `scripts/verify-task-patterns.sh`
  - **Gate:** `bash scripts/verify-task-patterns.sh && OPENSPEC_TELEMETRY=0 npx --yes @fission-ai/openspec@1.3.1 validate translate-curso-wave-4 --strict`

## 4. Post-register (best-effort)

- [ ] 4.1 `graphify update .` if available (docs touched); otherwise SKIP per infra
  - **Pattern:** `.cursor/rules/graphify.mdc`
  - **Gate:** `test -f graphify-out/GRAPH_REPORT.md || echo 'SKIP (graphify unavailable)'`
  - **Note:** SKIP if graphify CLI unavailable

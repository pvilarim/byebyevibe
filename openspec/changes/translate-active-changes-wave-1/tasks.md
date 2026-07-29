# Tasks — translate-active-changes-wave-1

> Apply after human approval (R7). **In-place PT→EN only** on the three listed `add-correctness-review-skill` artifacts. **Issue:** —

## 1. Prep (glossary + freeze)

- [ ] 1.1 Confirm glossary covers terms needed for this wave (`skill`, `evaluation`, Session Handoff, gate, change, wave); append rows to `doc/i18n/GLOSSARY.md` only if a new SDD term is introduced (same PR)
  - **Pattern:** `doc/i18n/GLOSSARY.md`
  - **Invariants:** `sdd-docs-language` — Glossary and wave inventory exist
  - **Gate:** `test -s doc/i18n/GLOSSARY.md && grep -qE 'skill|evaluation|Session Handoff|gate|wave|glossary' doc/i18n/GLOSSARY.md`
  - **Forbidden:** invent synonym variants for glossary terms; dual-file `*.en.md` / `*-pt.md`; editing `openspec/changes/archive/`

## 2. Substitute active-change artifacts (in-place)

- [ ] 2.1 Rewrite `openspec/changes/add-correctness-review-skill/proposal.md` Portuguese prose (Why, What Changes, Capabilities, Impact) → glossary-canonical English; keep change-id, skill paths, capability ids (`sdd-correctness-review`, `sdd-workspace-manifest`), and G7 / explore-oss references intact
  - **Pattern:** `openspec/changes/add-correctness-review-skill/proposal.md`
  - **Invariants:** `sdd-docs-language` — Active-changes wave-1 correctness-review artifacts are English; Freeze list of non-translatable tokens
  - **Gate:** `test -f openspec/changes/add-correctness-review-skill/proposal.md && ! test -f openspec/changes/add-correctness-review-skill/proposal.en.md && ! test -f openspec/changes/add-correctness-review-skill/proposal-pt.md && grep -qF 'correctness-review' openspec/changes/add-correctness-review-skill/proposal.md && grep -qF 'sdd-correctness-review' openspec/changes/add-correctness-review-skill/proposal.md && ! grep -qiE 'dispõe de|exactamente|Actualização da secção|Novos ficheiros|Piloto dispensável|utilizador|comportamento inesperado' openspec/changes/add-correctness-review-skill/proposal.md`
  - **Forbidden:** dual-file siblings; changing capability ids; rewriting skill mirror paths; drive-by edits to sibling completed-change packages

- [ ] 2.2 Rewrite `openspec/changes/add-correctness-review-skill/design.md` Portuguese prose (Context, Fase 0 checks, Goals/Non-Goals, Decisions, Risks, Migration/Rollback, A–E matrix narrative) → glossary-canonical English; keep A–E cells, pilot-exception approval, rollback steps, and path references intact
  - **Pattern:** `openspec/changes/add-correctness-review-skill/design.md`
  - **Invariants:** `sdd-docs-language` — Active-changes wave-1 correctness-review artifacts are English
  - **Gate:** `test -f openspec/changes/add-correctness-review-skill/design.md && ! test -f openspec/changes/add-correctness-review-skill/design.en.md && ! test -f openspec/changes/add-correctness-review-skill/design-pt.md && grep -qF 'correctness-review' openspec/changes/add-correctness-review-skill/design.md && grep -qiE 'Goals|Non-Goals|Rollback|A–E|A-E' openspec/changes/add-correctness-review-skill/design.md && ! grep -qiE 'Verificações Fase|piloto dispensável|utilizador confirmou|caça complexidade|Nenhuma das duas cobre|artefactos|ficheiro|ficheiros|secção|secções|canónico|actualmente' openspec/changes/add-correctness-review-skill/design.md`
  - **Forbidden:** changing A–E matrix outcomes; altering pilot-exception or rollback semantics; dual-file siblings; editing already-EN delta specs under `specs/`

- [ ] 2.3 Rewrite `openspec/changes/add-correctness-review-skill/tasks.md` Portuguese prose (section titles, task descriptions) → glossary-canonical English; keep historical `[x]` completion markers, Pattern/Gate/Invariants/Forbidden structure, and referenced paths intact
  - **Pattern:** `openspec/changes/add-correctness-review-skill/tasks.md`
  - **Invariants:** `sdd-docs-language` — Active-changes wave-1 correctness-review artifacts are English
  - **Gate:** `test -f openspec/changes/add-correctness-review-skill/tasks.md && ! test -f openspec/changes/add-correctness-review-skill/tasks.en.md && ! test -f openspec/changes/add-correctness-review-skill/tasks-pt.md && grep -qF 'correctness-review' openspec/changes/add-correctness-review-skill/tasks.md && grep -cF -- '- [x]' openspec/changes/add-correctness-review-skill/tasks.md | grep -qE '^[1-9]' && ! grep -qiE 'Escopo apply após|Criar `|Actualizar secção|Adicionar linha|Guia canónico|Avaliação|Correr `|Validar change|Pós-registro|utilizador confirmou|piloto dispensável' openspec/changes/add-correctness-review-skill/tasks.md`
  - **Forbidden:** flipping historical `[x]` to `[ ]`; dual-file siblings; changing Pattern/Gate command strings beyond language in surrounding prose; editing other completed-change `tasks.md` files

## 3. Wave gates

- [ ] 3.1 Run per-wave i18n verification on the exact active-change file list
  - **Pattern:** `scripts/verify-i18n-wave.sh`
  - **Invariants:** `sdd-docs-language` — Per-wave and global verification script; Active-changes wave-1 correctness-review artifacts are English
  - **Gate:** `bash scripts/verify-i18n-wave.sh --files openspec/changes/add-correctness-review-skill/proposal.md,openspec/changes/add-correctness-review-skill/design.md,openspec/changes/add-correctness-review-skill/tasks.md`
  - **Forbidden:** marking tasks done if G-PT/G-INV/G-LINK/G-OPENSPEC fail; running `--dod` as a required gate for this wave

- [ ] 3.2 Validate OpenSpec change + task Pattern paths
  - **Pattern:** `scripts/verify-task-patterns.sh`
  - **Gate:** `bash scripts/verify-task-patterns.sh && OPENSPEC_TELEMETRY=0 npx --yes @fission-ai/openspec@1.3.1 validate translate-active-changes-wave-1 --strict`

## 4. Post-register (best-effort)

- [ ] 4.1 `graphify update .` if available (docs touched); otherwise SKIP per infra
  - **Pattern:** `.cursor/rules/graphify.mdc`
  - **Gate:** `test -f graphify-out/GRAPH_REPORT.md || echo 'SKIP (graphify unavailable)'`
  - **Note:** SKIP if graphify CLI unavailable

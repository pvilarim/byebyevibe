# Tasks — translate-probity-wave-1

> Apply after human approval (R7). **In-place PT→EN only** on the three listed `add-probity-tdd-module` artifacts. **Issue:** —

## 1. Prep (glossary + freeze)

- [ ] 1.1 Confirm glossary covers terms needed for this wave (`pilot` / piloto, Session Handoff, gate, change, wave, evaluation, install kit); append rows to `doc/i18n/GLOSSARY.md` only if a new SDD term is introduced (same PR)
  - **Pattern:** `doc/i18n/GLOSSARY.md`
  - **Invariants:** `sdd-docs-language` — Glossary and wave inventory exist
  - **Gate:** `test -s doc/i18n/GLOSSARY.md && grep -qE 'Session Handoff|gate|wave|glossary|evaluation|install kit' doc/i18n/GLOSSARY.md`
  - **Forbidden:** invent synonym variants for glossary terms; dual-file `*.en.md` / `*-pt.md`; editing `openspec/changes/archive/`

## 2. Substitute Probity wave-1 artifacts (in-place)

- [ ] 2.1 Rewrite `openspec/changes/add-probity-tdd-module/proposal.md` Portuguese prose (Why, What Changes, Capabilities, Impact) → glossary-canonical English; keep change-id, capability ids (`sdd-probity-module`, `sdd-correctness-review`), pin `@nizos/probity@1.10.0`, `enforceTdd`, and script/path references intact
  - **Pattern:** `openspec/changes/add-probity-tdd-module/proposal.md`
  - **Invariants:** `sdd-docs-language` — Probity wave-1 active-change artifacts are English; Freeze list of non-translatable tokens
  - **Gate:** `test -f openspec/changes/add-probity-tdd-module/proposal.md && ! test -f openspec/changes/add-probity-tdd-module/proposal.en.md && ! test -f openspec/changes/add-probity-tdd-module/proposal-pt.md && grep -qF 'add-probity-tdd-module' openspec/changes/add-probity-tdd-module/proposal.md && grep -qF '@nizos/probity@1.10.0' openspec/changes/add-probity-tdd-module/proposal.md && grep -qF 'enforceTdd' openspec/changes/add-probity-tdd-module/proposal.md && ! grep -qiE 'não tem enforcement|novos projectos|Piloto obrigatório|Novos ficheiros|Actualização da pipeline|registo em' openspec/changes/add-probity-tdd-module/proposal.md`
  - **Forbidden:** dual-file siblings; changing capability ids; rewriting package pin; drive-by edits to `design.md` or sibling completed-change packages

- [ ] 2.2 Rewrite `openspec/changes/add-probity-tdd-module/tasks.md` Portuguese prose (section intros, task descriptions, Forbidden/notes) → glossary-canonical English; keep Pattern/Gate fences, `[x]` markers, script names, and path references intact
  - **Pattern:** `openspec/changes/add-probity-tdd-module/tasks.md`
  - **Invariants:** `sdd-docs-language` — Probity wave-1 active-change artifacts are English
  - **Gate:** `test -f openspec/changes/add-probity-tdd-module/tasks.md && ! test -f openspec/changes/add-probity-tdd-module/tasks.en.md && ! test -f openspec/changes/add-probity-tdd-module/tasks-pt.md && grep -qF 'install-probity-module.sh' openspec/changes/add-probity-tdd-module/tasks.md && grep -qF 'enforceTdd' openspec/changes/add-probity-tdd-module/tasks.md && grep -qE '^\- \[x\]' openspec/changes/add-probity-tdd-module/tasks.md && ! grep -qiE 'Escopo apply após|Piloto obrigatório|Registar resultado|Actualizar|correr `bash|Adiado' openspec/changes/add-probity-tdd-module/tasks.md`
  - **Forbidden:** flipping `[x]` ↔ `[ ]`; editing Gate shell commands except intentional non-i18n fixes; translating `design.md` in this wave

- [ ] 2.3 Rewrite `openspec/changes/add-probity-tdd-module/piloto-nota.md` Portuguese prose → glossary-canonical English; keep change-id, PENDING pilot status meaning, thresholds (p95 / false positives / R6), and DOCS_SPECS / APP worktree facts intact; do **not** rename the file
  - **Pattern:** `openspec/changes/add-probity-tdd-module/piloto-nota.md`
  - **Invariants:** `sdd-docs-language` — Probity wave-1 active-change artifacts are English
  - **Gate:** `test -f openspec/changes/add-probity-tdd-module/piloto-nota.md && ! test -f openspec/changes/add-probity-tdd-module/piloto-nota.en.md && ! test -f openspec/changes/add-probity-tdd-module/piloto-nota-pt.md && grep -qF 'add-probity-tdd-module' openspec/changes/add-probity-tdd-module/piloto-nota.md && grep -qiE 'PENDING|pending' openspec/changes/add-probity-tdd-module/piloto-nota.md && grep -q 'p95' openspec/changes/add-probity-tdd-module/piloto-nota.md && ! grep -qiE 'Nota de piloto|PILOTO PENDENTE|não falhou|bloqueado por ausência|O que este apply faz|não faz' openspec/changes/add-probity-tdd-module/piloto-nota.md`
  - **Forbidden:** renaming `piloto-nota.md`; inventing a completed pilot; editing `design.md`

## 3. Verify wave gates

- [ ] 3.1 Run per-wave i18n verification on the exact three paths
  - **Pattern:** `scripts/verify-i18n-wave.sh`
  - **Invariants:** `sdd-docs-language` — Per-wave verification gates
  - **Gate:** `bash scripts/verify-i18n-wave.sh --files openspec/changes/add-probity-tdd-module/proposal.md,openspec/changes/add-probity-tdd-module/tasks.md,openspec/changes/add-probity-tdd-module/piloto-nota.md`
  - **Forbidden:** `--dod` as a substitute for per-wave gate; translating out-of-scope files to force a green G-PT

- [ ] 3.2 OpenSpec strict validate
  - **Pattern:** `openspec/changes/translate-probity-wave-1/proposal.md`
  - **Gate:** `OPENSPEC_TELEMETRY=0 npx --yes @fission-ai/openspec@1.3.1 validate --all --strict`
  - **Forbidden:** disabling telemetry policy; weakening validate flags

## 4. Stop (no archive in apply session)

- [ ] 4.1 Emit Session Handoff for `/opsx:archive translate-probity-wave-1` after apply PR merges; do not archive in the apply chat
  - **Gate:** `test -f openspec/changes/translate-probity-wave-1/tasks.md && grep -qF 'translate-probity-wave-1' openspec/changes/translate-probity-wave-1/proposal.md`
  - **Forbidden:** `/opsx:archive` in the same session as apply; starting `translate-probity-wave-2` apply before its propose exists

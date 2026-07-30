# Tasks — translate-i18n-stubs-wave-1

> Apply after human approval (R7). **In-place PT→EN only** on the two listed stub surfaces. **Issue:** —

## 1. Prep (glossary + freeze)

- [x] 1.1 Confirm glossary covers terms needed for this wave (Session Handoff, gate, change, wave, glossary); append rows to `doc/i18n/GLOSSARY.md` only if a new SDD term is introduced (same PR)
  - **Pattern:** `doc/i18n/GLOSSARY.md`
  - **Invariants:** `sdd-docs-language` — Glossary and wave inventory exist
  - **Gate:** `test -s doc/i18n/GLOSSARY.md && grep -qE 'Session Handoff|gate|wave|glossary' doc/i18n/GLOSSARY.md`
  - **Forbidden:** invent synonym variants for glossary terms; dual-file `*.en.md` / `*-pt.md`; editing `openspec/changes/archive/`

## 2. Substitute i18n stub artifacts (in-place)

- [x] 2.1 Rewrite Portuguese Session Handoff stub labels in `doc/i18n/WAVE-PROPOSAL-TEMPLATE.md` → glossary-canonical English matching `doc/i18n/CURSOR-AUTOMATIONS.md` §6 (`Read:`, `assume ✅ — do not reinstall`); keep `translate-<surface>-wave-N` and `<paths>` placeholders intact
  - **Pattern:** `doc/i18n/WAVE-PROPOSAL-TEMPLATE.md`
  - **Invariants:** `sdd-docs-language` — i18n stub artifacts are English; Freeze list of non-translatable tokens
  - **Gate:** `test -f doc/i18n/WAVE-PROPOSAL-TEMPLATE.md && ! test -f doc/i18n/WAVE-PROPOSAL-TEMPLATE.en.md && ! test -f doc/i18n/WAVE-PROPOSAL-TEMPLATE-pt.md && grep -qF 'translate-<surface>-wave-N' doc/i18n/WAVE-PROPOSAL-TEMPLATE.md && grep -qE 'Read:|assume' doc/i18n/WAVE-PROPOSAL-TEMPLATE.md && ! grep -qiE 'Ler:|assumir|não reinstalar' doc/i18n/WAVE-PROPOSAL-TEMPLATE.md`
  - **Forbidden:** dual-file siblings; inventing a third stub dialect; rewriting non-stub sections beyond residual PT; drive-by edits to `CURSOR-AUTOMATIONS.md`

- [x] 2.2 Rewrite Portuguese Session Handoff stub labels in `openspec/changes/add-i18n-cursor-automations-guide/proposal.md` → glossary-canonical English matching §6; keep change-id `add-i18n-cursor-automations-guide` and path references intact
  - **Pattern:** `openspec/changes/add-i18n-cursor-automations-guide/proposal.md`
  - **Invariants:** `sdd-docs-language` — i18n stub artifacts are English
  - **Gate:** `test -f openspec/changes/add-i18n-cursor-automations-guide/proposal.md && ! test -f openspec/changes/add-i18n-cursor-automations-guide/proposal.en.md && ! test -f openspec/changes/add-i18n-cursor-automations-guide/proposal-pt.md && grep -qF 'add-i18n-cursor-automations-guide' openspec/changes/add-i18n-cursor-automations-guide/proposal.md && grep -qE 'Read:|assume' openspec/changes/add-i18n-cursor-automations-guide/proposal.md && ! grep -qiE 'Ler:|assumir|não reinstalar' openspec/changes/add-i18n-cursor-automations-guide/proposal.md`
  - **Forbidden:** dual-file siblings; rewriting Why/What Changes product scope beyond residual PT in the stub; editing sibling design/tasks unless they gain residual PT (out of this wave)

## 3. Verify wave gates

- [x] 3.1 Run per-wave i18n verification on the exact two paths
  - **Pattern:** `scripts/verify-i18n-wave.sh`
  - **Invariants:** `sdd-docs-language` — Per-wave verification gates
  - **Gate:** `bash scripts/verify-i18n-wave.sh --files doc/i18n/WAVE-PROPOSAL-TEMPLATE.md,openspec/changes/add-i18n-cursor-automations-guide/proposal.md`
  - **Forbidden:** `--dod` as a substitute for per-wave gate; translating out-of-scope files to force a green G-PT

- [x] 3.2 OpenSpec strict validate
  - **Pattern:** `openspec/changes/translate-i18n-stubs-wave-1/proposal.md`
  - **Gate:** `OPENSPEC_TELEMETRY=0 npx --yes @fission-ai/openspec@1.3.1 validate --all --strict`
  - **Forbidden:** disabling telemetry policy; weakening `--strict`

## 4. Handoff

- [x] 4.1 Mark tasks complete only after gates pass; emit Session Handoff for `/opsx:archive translate-i18n-stubs-wave-1` (do not archive in the apply session)
  - **Gate:** `test -f openspec/changes/translate-i18n-stubs-wave-1/tasks.md && grep -cE '^\- \[x\]' openspec/changes/translate-i18n-stubs-wave-1/tasks.md | awk '{exit !($1>=5)}'`
  - **Forbidden:** starting archive in the same session as apply; editing over-budget residuals in this wave

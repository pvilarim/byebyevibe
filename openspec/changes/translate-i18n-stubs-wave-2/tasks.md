# Tasks — translate-i18n-stubs-wave-2

> Apply after human approval (R7). **In-place PT→EN only** on the four listed stub surfaces. **Issue:** —

## 1. Prep (glossary + freeze)

- [x] 1.1 Confirm glossary covers terms needed for this wave (Session Handoff, gate, change, wave, glossary); append rows to `doc/i18n/GLOSSARY.md` only if a new SDD term is introduced (same PR)
  - **Pattern:** `doc/i18n/GLOSSARY.md`
  - **Invariants:** `sdd-docs-language` — Glossary and wave inventory exist
  - **Gate:** `test -s doc/i18n/GLOSSARY.md && grep -qE 'Session Handoff|gate|wave|glossary' doc/i18n/GLOSSARY.md`
  - **Forbidden:** invent synonym variants for glossary terms; dual-file `*.en.md` / `*-pt.md`; editing `openspec/changes/archive/`

## 2. Substitute active translate proposal stubs (in-place)

- [x] 2.1 Rewrite Portuguese Session Handoff stub labels in `openspec/changes/translate-agents-rules-wave-1/proposal.md` → glossary-canonical English matching `doc/i18n/CURSOR-AUTOMATIONS.md` §6 (`Read:`, `assume ✅ — do not reinstall`); keep change-id and Gate `--files` list intact
  - **Pattern:** `openspec/changes/translate-agents-rules-wave-1/proposal.md`
  - **Invariants:** `sdd-docs-language` — Active translate proposal Session Handoff stubs (wave-2) are English; Freeze list of non-translatable tokens
  - **Gate:** `test -f openspec/changes/translate-agents-rules-wave-1/proposal.md && ! test -f openspec/changes/translate-agents-rules-wave-1/proposal.en.md && ! test -f openspec/changes/translate-agents-rules-wave-1/proposal-pt.md && grep -qF 'translate-agents-rules-wave-1' openspec/changes/translate-agents-rules-wave-1/proposal.md && grep -qE 'Read:|assume' openspec/changes/translate-agents-rules-wave-1/proposal.md && ! grep -qiE 'Ler:|assumir|não reinstalar' openspec/changes/translate-agents-rules-wave-1/proposal.md`
  - **Forbidden:** dual-file siblings; rewriting Why/What Changes beyond residual PT in the stub; changing Gate `--files` paths

- [x] 2.2 Rewrite Portuguese Session Handoff stub labels in `openspec/changes/translate-agents-rules-wave-1b/proposal.md` → §6 English; keep change-id and Gate `--files` list intact
  - **Pattern:** `openspec/changes/translate-agents-rules-wave-1b/proposal.md`
  - **Invariants:** `sdd-docs-language` — Active translate proposal Session Handoff stubs (wave-2) are English
  - **Gate:** `test -f openspec/changes/translate-agents-rules-wave-1b/proposal.md && ! test -f openspec/changes/translate-agents-rules-wave-1b/proposal.en.md && ! test -f openspec/changes/translate-agents-rules-wave-1b/proposal-pt.md && grep -qF 'translate-agents-rules-wave-1b' openspec/changes/translate-agents-rules-wave-1b/proposal.md && grep -qE 'Read:|assume' openspec/changes/translate-agents-rules-wave-1b/proposal.md && ! grep -qiE 'Ler:|assumir|não reinstalar' openspec/changes/translate-agents-rules-wave-1b/proposal.md`
  - **Forbidden:** dual-file siblings; rewriting non-stub sections beyond residual PT; changing Gate `--files` paths

- [x] 2.3 Rewrite Portuguese Session Handoff stub labels in `openspec/changes/translate-agents-rules-wave-1c/proposal.md` → §6 English; keep change-id and Gate `--files` list intact
  - **Pattern:** `openspec/changes/translate-agents-rules-wave-1c/proposal.md`
  - **Invariants:** `sdd-docs-language` — Active translate proposal Session Handoff stubs (wave-2) are English
  - **Gate:** `test -f openspec/changes/translate-agents-rules-wave-1c/proposal.md && ! test -f openspec/changes/translate-agents-rules-wave-1c/proposal.en.md && ! test -f openspec/changes/translate-agents-rules-wave-1c/proposal-pt.md && grep -qF 'translate-agents-rules-wave-1c' openspec/changes/translate-agents-rules-wave-1c/proposal.md && grep -qE 'Read:|assume' openspec/changes/translate-agents-rules-wave-1c/proposal.md && ! grep -qiE 'Ler:|assumir|não reinstalar' openspec/changes/translate-agents-rules-wave-1c/proposal.md`
  - **Forbidden:** dual-file siblings; rewriting non-stub sections beyond residual PT; changing Gate `--files` paths

- [x] 2.4 SKIP — `translate-kit-wave-2c` archived to `openspec/changes/archive/2026-07-27-translate-kit-wave-2c/`; archive OUT per design (stub PT remains in archive only)
  - **Pattern:** `openspec/changes/translate-kit-wave-2c/proposal.md` (no longer in active changes)
  - **Note:** Target moved to archive after propose; not editable under wave non-goals

## 3. Verify wave gates

- [x] 3.1 Run per-wave i18n verification on the exact four paths
  - **Pattern:** `scripts/verify-i18n-wave.sh`
  - **Invariants:** `sdd-docs-language` — Per-wave verification gates
  - **Gate:** `bash scripts/verify-i18n-wave.sh --files openspec/changes/translate-agents-rules-wave-1/proposal.md,openspec/changes/translate-agents-rules-wave-1b/proposal.md,openspec/changes/translate-agents-rules-wave-1c/proposal.md`
  - **Forbidden:** `--dod` as a substitute for per-wave gate; translating out-of-scope files to force a green G-PT

- [x] 3.2 OpenSpec strict validate
  - **Pattern:** `openspec/changes/translate-i18n-stubs-wave-2/proposal.md`
  - **Gate:** `OPENSPEC_TELEMETRY=0 npx --yes @fission-ai/openspec@1.3.1 validate --all --strict`
  - **Forbidden:** disabling telemetry policy; weakening `--strict`

## 4. Handoff

- [x] 4.1 Mark tasks complete only after gates pass; emit Session Handoff for `/opsx:archive translate-i18n-stubs-wave-2` (do not archive in the apply session)
  - **Gate:** `test -f openspec/changes/translate-i18n-stubs-wave-2/tasks.md && grep -cE '^\- \[x\]' openspec/changes/translate-i18n-stubs-wave-2/tasks.md | awk '{exit !($1>=7)}'`
  - **Forbidden:** starting archive in the same session as apply; editing over-budget residuals or `translate-kit-wave-2d/proposal.md` in this wave

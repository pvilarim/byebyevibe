# Tasks — translate-i18n-stubs-wave-3

> Apply after human approval (R7). **In-place PT→EN only** on the two listed residual surfaces. **Issue:** —

## 1. Prep (glossary + freeze)

- [x] 1.1 Confirm glossary covers terms needed for this wave (Session Handoff, gate, change, wave, glossary); append rows to `doc/i18n/GLOSSARY.md` only if a new SDD term is introduced (same PR)
  - **Pattern:** `doc/i18n/GLOSSARY.md`
  - **Invariants:** `sdd-docs-language` — Glossary and wave inventory exist
  - **Gate:** `test -s doc/i18n/GLOSSARY.md && grep -qE 'Session Handoff|gate|wave|glossary' doc/i18n/GLOSSARY.md`
  - **Forbidden:** invent synonym variants for glossary terms; dual-file `*.en.md` / `*-pt.md`; editing `openspec/changes/archive/`

## 2. Substitute residual stubs (in-place)

- [x] 2.1 Rewrite Portuguese Session Handoff stub labels in `openspec/changes/translate-kit-wave-2d/proposal.md` → glossary-canonical English matching `doc/i18n/CURSOR-AUTOMATIONS.md` §6 (`Read:`, `assume ✅ — do not reinstall`); keep change-id, W2c prerequisite lines, and Gate `--files` list intact
  - **Pattern:** `openspec/changes/translate-kit-wave-2d/proposal.md`
  - **Invariants:** `sdd-docs-language` — Active translate residual stubs (wave-3) are English; Freeze list of non-translatable tokens
  - **Gate:** `test -f openspec/changes/translate-kit-wave-2d/proposal.md && ! test -f openspec/changes/translate-kit-wave-2d/proposal.en.md && ! test -f openspec/changes/translate-kit-wave-2d/proposal-pt.md && grep -qF 'translate-kit-wave-2d' openspec/changes/translate-kit-wave-2d/proposal.md && grep -qE 'Read:|assume' openspec/changes/translate-kit-wave-2d/proposal.md && ! grep -qiE 'Ler:|assumir|não reinstalar' openspec/changes/translate-kit-wave-2d/proposal.md`
  - **Forbidden:** dual-file siblings; rewriting Why/What Changes beyond residual PT in the stub; changing Gate `--files` paths; editing `sdd-kit/templates/` in this wave

- [x] 2.2 Rewrite residual Portuguese in `openspec/changes/translate-agents-rules-wave-1b/simplify-review.md` → glossary-canonical English; keep change-id and LEAN / ship semantics
  - **Pattern:** `openspec/changes/translate-agents-rules-wave-1b/simplify-review.md`
  - **Invariants:** `sdd-docs-language` — Active translate residual stubs (wave-3) are English
  - **Gate:** `test -f openspec/changes/translate-agents-rules-wave-1b/simplify-review.md && ! test -f openspec/changes/translate-agents-rules-wave-1b/simplify-review.en.md && ! test -f openspec/changes/translate-agents-rules-wave-1b/simplify-review-pt.md && grep -qF 'translate-agents-rules-wave-1b' openspec/changes/translate-agents-rules-wave-1b/simplify-review.md && grep -qiE 'LEAN|ship' openspec/changes/translate-agents-rules-wave-1b/simplify-review.md && ! grep -qiE 'Escopo:|ficheiros|Veredito:|Achados|nenhum|Substituição|artefacto' openspec/changes/translate-agents-rules-wave-1b/simplify-review.md`
  - **Forbidden:** dual-file siblings; changing the reviewed change-id; inventing a new verdict that contradicts LEAN / ship

## 3. Verify wave gates

- [x] 3.1 Run per-wave i18n verification on the exact two paths
  - **Pattern:** `scripts/verify-i18n-wave.sh`
  - **Invariants:** `sdd-docs-language` — Per-wave verification gates
  - **Gate:** `bash scripts/verify-i18n-wave.sh --files openspec/changes/translate-kit-wave-2d/proposal.md,openspec/changes/translate-agents-rules-wave-1b/simplify-review.md`
  - **Forbidden:** `--dod` as a substitute for per-wave gate; translating out-of-scope files to force a green G-PT

- [x] 3.2 OpenSpec strict validate
  - **Pattern:** `openspec/changes/translate-i18n-stubs-wave-3/proposal.md`
  - **Gate:** `OPENSPEC_TELEMETRY=0 npx --yes @fission-ai/openspec@1.3.1 validate --all --strict`
  - **Forbidden:** disabling telemetry policy; weakening `--strict`

## 4. Handoff

- [x] 4.1 Mark tasks complete only after gates pass; emit Session Handoff for `/opsx:archive translate-i18n-stubs-wave-3` (do not archive in the apply session)
  - **Gate:** `test -f openspec/changes/translate-i18n-stubs-wave-3/tasks.md && grep -cE '^\- \[x\]' openspec/changes/translate-i18n-stubs-wave-3/tasks.md | awk '{exit !($1>=5)}'`
  - **Forbidden:** starting archive in the same session as apply; editing over-budget residuals in this wave

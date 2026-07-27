# Tasks — translate-kit-wave-2d

> Apply after human approval (R7) **and** after `translate-kit-wave-2c` is apply-complete (prefer also archived). **In-place PT→EN only** on kit residual rules + proposal scaffold (+ checksums). **Issue:** —

## 0. Prerequisite (W2c)

- [ ] 0.1 Confirm `translate-kit-wave-2c` is apply-complete (kit `000-base.mdc` English) before editing W2d templates; if not, stop and run `/opsx:apply translate-kit-wave-2c` then `/opsx:archive translate-kit-wave-2c` in a separate session
  - **Pattern:** `sdd-kit/templates/.cursor/rules/000-base.mdc`
  - **Invariants:** `sdd-docs-language` — Wave size limits
  - **Gate:** `test -f sdd-kit/templates/.cursor/rules/000-base.mdc && grep -q 'Base project rules' sdd-kit/templates/.cursor/rules/000-base.mdc`
  - **Note:** Fails until W2c apply lands English on `000-base.mdc`. Prefer W2c also archived before W2d apply.
  - **Proibido:** applying W2d template writes while W2c apply is incomplete; mixing apply of W2c into this propose session

## 1. Prep (glossary + freeze)

- [ ] 1.1 Confirm glossary covers terms needed for this wave; append rows to `doc/i18n/GLOSSARY.md` only if a new SDD term is introduced (same PR)
  - **Pattern:** `doc/i18n/GLOSSARY.md`
  - **Invariants:** `sdd-docs-language` — Glossary and wave inventory exist
  - **Gate:** `test -s doc/i18n/GLOSSARY.md && grep -qE 'Session Handoff|install kit|fail-closed|wave|glossary' doc/i18n/GLOSSARY.md`
  - **Proibido:** invent synonym variants for glossary terms; dual-file `*.en.md` / `*-pt.md`

## 2. Substitute kit residual Cursor rules (in-place)

- [ ] 2.1 Rewrite `sdd-kit/templates/.cursor/rules/020-python.mdc` Portuguese prose → glossary-canonical English aligned with hub `.cursor/rules/020-python.mdc`; freeze globs (`**/*.py`), identifiers (`asyncio`, `Pydantic`, `structlog`, `pytest-asyncio`); translate YAML `description` value only; keep `alwaysApply: false`
  - **Pattern:** `.cursor/rules/020-python.mdc`
  - **Invariants:** `sdd-docs-language` — Kit Cursor rules residual and proposal scaffold (W2d slice) are English; YAML globs and alwaysApply preserved
  - **Gate:** `test -f sdd-kit/templates/.cursor/rules/020-python.mdc && ! test -f sdd-kit/templates/.cursor/rules/020-python.en.mdc && grep -q 'Python conventions' sdd-kit/templates/.cursor/rules/020-python.mdc && grep -qF '**/*.py' sdd-kit/templates/.cursor/rules/020-python.mdc && grep -q 'alwaysApply: false' sdd-kit/templates/.cursor/rules/020-python.mdc && grep -qF 'Pydantic' sdd-kit/templates/.cursor/rules/020-python.mdc && grep -qF 'asyncio' sdd-kit/templates/.cursor/rules/020-python.mdc`
  - **Proibido:** dual-file siblings; changing glob patterns; drive-by hub `.cursor/rules/020-python.mdc` edits; inventing synonym conventions vs hub

- [ ] 2.2 Rewrite `sdd-kit/templates/.cursor/rules/030-supabase.mdc` Portuguese prose → English aligned with hub `.cursor/rules/030-supabase.mdc`; freeze globs (`**/migrations/**`, `**/db/**`, `**/infra/supabase/**`), identifiers (`Zod`, `ivfflat`, `snake_case`); translate YAML `description` value only; keep `alwaysApply: false`
  - **Pattern:** `.cursor/rules/030-supabase.mdc`
  - **Invariants:** `sdd-docs-language` — Kit Cursor rules residual and proposal scaffold (W2d slice) are English; Freeze list of non-translatable tokens
  - **Gate:** `test -f sdd-kit/templates/.cursor/rules/030-supabase.mdc && ! test -f sdd-kit/templates/.cursor/rules/030-supabase.en.mdc && grep -q 'Supabase / Postgres rules' sdd-kit/templates/.cursor/rules/030-supabase.mdc && grep -qF '**/migrations/**' sdd-kit/templates/.cursor/rules/030-supabase.mdc && grep -q 'alwaysApply: false' sdd-kit/templates/.cursor/rules/030-supabase.mdc && grep -qF 'Zod' sdd-kit/templates/.cursor/rules/030-supabase.mdc && grep -qF 'ivfflat' sdd-kit/templates/.cursor/rules/030-supabase.mdc`
  - **Proibido:** dual-file siblings; changing glob patterns; drive-by hub rule edits

- [ ] 2.3 Rewrite `sdd-kit/templates/.cursor/rules/050-security.mdc` Portuguese prose → English aligned with hub `.cursor/rules/050-security.mdc`; freeze pins (`@fission-ai/openspec@1.3.1`), `OPENSPEC_TELEMETRY`, `gate:`, `F-SEC-5`, `F-SEC-3`, workflow names; translate YAML `description` value only; keep `alwaysApply: true`
  - **Pattern:** `.cursor/rules/050-security.mdc`
  - **Invariants:** `sdd-docs-language` — Kit Cursor rules residual and proposal scaffold (W2d slice) are English; Freeze list of non-translatable tokens
  - **Gate:** `test -f sdd-kit/templates/.cursor/rules/050-security.mdc && ! test -f sdd-kit/templates/.cursor/rules/050-security.en.mdc && grep -q 'Security rules' sdd-kit/templates/.cursor/rules/050-security.mdc && grep -q 'alwaysApply: true' sdd-kit/templates/.cursor/rules/050-security.mdc && grep -qF '@fission-ai/openspec@1.3.1' sdd-kit/templates/.cursor/rules/050-security.mdc && grep -qF 'OPENSPEC_TELEMETRY=0' sdd-kit/templates/.cursor/rules/050-security.mdc && grep -qF 'gate:' sdd-kit/templates/.cursor/rules/050-security.mdc && grep -qF 'F-SEC-5' sdd-kit/templates/.cursor/rules/050-security.mdc`
  - **Proibido:** dual-file siblings; rewriting package pins or `gate:`; drive-by hub rule edits; inventing synonym section titles vs hub

## 3. Substitute kit OpenSpec proposal scaffold (in-place)

- [ ] 3.1 Rewrite `sdd-kit/templates/openspec/changes/_template/proposal.md` Portuguese placeholders/labels → English **FILL IN** forms aligned with `doc/i18n/WAVE-PROPOSAL-TEMPLATE.md`; keep `**Issue:** —` and section headings; replace `PREENCHER` / `Ficheiros modificados` / PT Impact labels with EN equivalents
  - **Pattern:** `doc/i18n/WAVE-PROPOSAL-TEMPLATE.md`
  - **Invariants:** `sdd-docs-language` — Kit Cursor rules residual and proposal scaffold (W2d slice) are English; Waves replace Portuguese in-place — dual-file forbidden
  - **Gate:** `test -f sdd-kit/templates/openspec/changes/_template/proposal.md && ! test -f sdd-kit/templates/openspec/changes/_template/proposal.en.md && grep -qF '**Issue:**' sdd-kit/templates/openspec/changes/_template/proposal.md && grep -qE 'FILL IN|\\[FILL IN' sdd-kit/templates/openspec/changes/_template/proposal.md && ! grep -qiE 'PREENCHER|Ficheiros' sdd-kit/templates/openspec/changes/_template/proposal.md && grep -q '## Why' sdd-kit/templates/openspec/changes/_template/proposal.md && grep -q '## Impact' sdd-kit/templates/openspec/changes/_template/proposal.md`
  - **Proibido:** dual-file siblings; inventing a parallel bilingual scaffold; removing required OpenSpec proposal sections

## 4. Checksums (G-MANIFEST)

- [ ] 4.1 Regenerate `sdd-kit/MANIFEST.yaml` sha256 fields after template edits
  - **Pattern:** `sdd-kit/gen-manifest-checksums.sh`
  - **Invariants:** `sdd-docs-language` — Kit Cursor rules residual and proposal scaffold (W2d slice) are English (G-MANIFEST)
  - **Gate:** `bash sdd-kit/gen-manifest-checksums.sh && bash sdd-kit/verify.sh`
  - **Proibido:** hand-editing sha256 without regenerator; evaluating MANIFEST `gate:` via eval; skipping verify after checksum update

## 5. Wave gates

- [ ] 5.1 Run per-wave i18n verification on the exact W2d file list
  - **Pattern:** `scripts/verify-i18n-wave.sh`
  - **Invariants:** `sdd-docs-language` — Per-wave and global verification script; Kit Cursor rules residual and proposal scaffold (W2d slice) are English
  - **Gate:** `bash scripts/verify-i18n-wave.sh --files sdd-kit/templates/.cursor/rules/020-python.mdc,sdd-kit/templates/.cursor/rules/030-supabase.mdc,sdd-kit/templates/.cursor/rules/050-security.mdc,sdd-kit/templates/openspec/changes/_template/proposal.md`
  - **Proibido:** marking tasks done if G-PT/G-INV/G-LINK/G-MANIFEST/G-OPENSPEC fail; running `--dod` as a required gate for this wave

- [ ] 5.2 Validate OpenSpec change + task Pattern paths
  - **Pattern:** `scripts/verify-task-patterns.sh`
  - **Gate:** `bash scripts/verify-task-patterns.sh && OPENSPEC_TELEMETRY=0 npx --yes @fission-ai/openspec@1.3.1 validate translate-kit-wave-2d --strict`

## 6. Post-register (best-effort)

- [ ] 6.1 `graphify update .` if available (docs/templates touched); otherwise SKIP per infra
  - **Pattern:** `.cursor/rules/graphify.mdc`
  - **Gate:** `test -f graphify-out/GRAPH_REPORT.md || echo 'SKIP (graphify unavailable)'`
  - **Note:** SKIP if graphify CLI unavailable

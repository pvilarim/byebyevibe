# Tasks — translate-infra-wave-1

> Apply after human approval (R7). **In-place PT→EN only** on hub `openspec/infra.md`. **Issue:** —

## 1. Prep (glossary + freeze)

- [x] 1.1 Confirm glossary covers terms needed for this wave; append rows to `doc/i18n/GLOSSARY.md` only if a new SDD term is introduced (same PR)
  - **Pattern:** `doc/i18n/GLOSSARY.md`
  - **Invariants:** `sdd-docs-language` — Glossary and wave inventory exist
  - **Gate:** `test -s doc/i18n/GLOSSARY.md && grep -qE 'Session Handoff|install kit|fail-closed|wave|glossary' doc/i18n/GLOSSARY.md`
  - **Proibido:** invent synonym variants for glossary terms; dual-file `*.en.md` / `*-pt.md`

## 2. Substitute hub infra manifest (in-place)

- [x] 2.1 Rewrite `openspec/infra.md` Portuguese prose/table headers/section titles → glossary-canonical English aligned with kit `sdd-kit/templates/openspec/infra.md` chrome (`Component`/`Version`/`Status`/`Verify with`, `[MANUAL ACTION]`, `Agent rule`); freeze all `verify-infra.sh` HTML marker **tags**; translate Portuguese filler inside marker bodies only when present; keep pins, Action SHA, paths, hub-specific skill/status rows, and ✅/❌ cells byte-stable unless the cell text itself is Portuguese
  - **Pattern:** `sdd-kit/templates/openspec/infra.md`
  - **Invariants:** `sdd-docs-language` — Hub workspace infrastructure manifest is English; Freeze list of non-translatable tokens
  - **Gate:** `test -f openspec/infra.md && ! test -f openspec/infra.en.md && ! test -f openspec/infra-pt.md && grep -q 'Workspace Infrastructure Manifest' openspec/infra.md && grep -qE 'Last verified|Last verification' openspec/infra.md && grep -q '| Component |' openspec/infra.md && grep -q '## Agent rule' openspec/infra.md && grep -qF '[MANUAL ACTION]' openspec/infra.md && ! grep -qiE 'AÇÃO MANUAL|Componente|Verificar com|Regra agentes|directamente|não reinstalar' openspec/infra.md && grep -qF '<!-- openspec-version -->' openspec/infra.md && grep -qF '<!-- mcp-list -->' openspec/infra.md && grep -qF '<!-- env-list -->' openspec/infra.md && grep -qF '8dc09193bb540e09b23da07ad7e30bd33bf87018' openspec/infra.md && grep -qF '@nizos/probity@1.10.0' openspec/infra.md`
  - **Proibido:** dual-file siblings; moving/renaming HTML marker tags; rewriting Action SHA or package pins; drive-by kit template edits; changing live ✅/❌ via re-verify; inventing synonym table headers vs kit EN

## 3. Wave gates

- [x] 3.1 Run per-wave i18n verification on the exact infra file list
  - **Pattern:** `scripts/verify-i18n-wave.sh`
  - **Invariants:** `sdd-docs-language` — Per-wave and global verification script; Hub workspace infrastructure manifest is English
  - **Gate:** `bash scripts/verify-i18n-wave.sh --files openspec/infra.md`
  - **Proibido:** marking tasks done if G-PT/G-INV/G-LINK/G-OPENSPEC fail; running `--dod` as a required gate for this wave

- [x] 3.2 Validate OpenSpec change + task Pattern paths
  - **Pattern:** `scripts/verify-task-patterns.sh`
  - **Gate:** `bash scripts/verify-task-patterns.sh && OPENSPEC_TELEMETRY=0 npx --yes @fission-ai/openspec@1.3.1 validate translate-infra-wave-1 --strict`

## 4. Post-register (best-effort)

- [x] 4.1 `graphify update .` if available (docs touched); otherwise SKIP per infra
  - **Pattern:** `.cursor/rules/graphify.mdc`
  - **Gate:** `test -f graphify-out/GRAPH_REPORT.md || echo 'SKIP (graphify unavailable)'`
  - **Note:** SKIP if graphify CLI unavailable

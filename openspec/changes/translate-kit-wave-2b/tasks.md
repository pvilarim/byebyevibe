# Tasks — translate-kit-wave-2b

> Apply after human approval (R7). **In-place PT→EN only** on kit CLAUDE + openspec/infra templates (+ checksums). Kit `.cursor/rules/*.mdc` → later wave. **Issue:** —

## 1. Prep (glossary + freeze)

- [x] 1.1 Confirm glossary covers terms needed for this wave; append rows to `doc/i18n/GLOSSARY.md` only if a new SDD term is introduced (same PR)
  - **Pattern:** `doc/i18n/GLOSSARY.md`
  - **Invariants:** `sdd-docs-language` — Glossary and wave inventory exist
  - **Gate:** `test -s doc/i18n/GLOSSARY.md && grep -qE 'Session Handoff|install kit|fail-closed|wave|glossary' doc/i18n/GLOSSARY.md`
  - **Proibido:** invent synonym variants for glossary terms; dual-file `*.en.md` / `*-pt.md`

## 2. Substitute kit CLAUDE + openspec/infra templates (in-place)

- [x] 2.1 Rewrite `sdd-kit/templates/CLAUDE.md` Portuguese prose → glossary-canonical English aligned with hub `CLAUDE.md` section titles/wording; freeze paths, `AGENTS.md` pointer, graphify path, and `/opsx:*` references
  - **Pattern:** `CLAUDE.md`
  - **Invariants:** `sdd-docs-language` — Kit CLAUDE and openspec/infra install templates (W2b slice) are English; Waves replace Portuguese in-place — dual-file forbidden
  - **Gate:** `test -f sdd-kit/templates/CLAUDE.md && ! test -f sdd-kit/templates/CLAUDE.en.md && grep -q 'Entry point for Claude Code' sdd-kit/templates/CLAUDE.md && grep -qF './AGENTS.md' sdd-kit/templates/CLAUDE.md && grep -qF 'graphify-out/GRAPH_REPORT.md' sdd-kit/templates/CLAUDE.md`
  - **Proibido:** dual-file siblings; translating path strings; drive-by hub `CLAUDE.md` edits; inventing synonym section titles vs hub

- [x] 2.2 Rewrite `sdd-kit/templates/openspec/infra.md` Portuguese prose/table headers → English; freeze all `verify-infra.sh` HTML marker **tags**; translate Portuguese filler inside marker bodies only (`outros MCPs`, `_(sem .env.example no repo)_`, `[AÇÃO MANUAL]`); keep pins, SHA, and fenced/`backticked` commands byte-stable
  - **Pattern:** `openspec/infra.md`
  - **Invariants:** `sdd-docs-language` — Kit CLAUDE and openspec/infra install templates (W2b slice) are English; Freeze list of non-translatable tokens
  - **Gate:** `test -f sdd-kit/templates/openspec/infra.md && ! test -f sdd-kit/templates/openspec/infra.en.md && grep -qF '<!-- openspec-version -->' sdd-kit/templates/openspec/infra.md && grep -qF '<!-- /openspec-version -->' sdd-kit/templates/openspec/infra.md && grep -qF '<!-- mcp-list -->' sdd-kit/templates/openspec/infra.md && grep -qF '<!-- /mcp-list -->' sdd-kit/templates/openspec/infra.md && grep -qF '<!-- env-list -->' sdd-kit/templates/openspec/infra.md && grep -qF '<!-- /env-list -->' sdd-kit/templates/openspec/infra.md && grep -qF '8dc09193bb540e09b23da07ad7e30bd33bf87018' sdd-kit/templates/openspec/infra.md && grep -qF '@nizos/probity@1.10.0' sdd-kit/templates/openspec/infra.md && grep -qF 'bash scripts/verify-infra.sh' sdd-kit/templates/openspec/infra.md`
  - **Proibido:** dual-file siblings; moving/renaming HTML marker tags; copying residual Portuguese from hub live `openspec/infra.md`; changing SHA pins or package pins; evaluating MANIFEST `gate:`

## 3. Checksums (G-MANIFEST)

- [x] 3.1 Regenerate `sdd-kit/MANIFEST.yaml` sha256 fields after template edits
  - **Pattern:** `sdd-kit/gen-manifest-checksums.sh`
  - **Invariants:** `sdd-docs-language` — Kit CLAUDE and openspec/infra install templates (W2b slice) are English (G-MANIFEST)
  - **Gate:** `bash sdd-kit/gen-manifest-checksums.sh && bash sdd-kit/verify.sh`
  - **Proibido:** hand-editing sha256 without regenerator; evaluating MANIFEST `gate:` via eval; skipping verify after checksum update

## 4. Wave gates

- [x] 4.1 Run per-wave i18n verification on the exact W2b file list
  - **Pattern:** `scripts/verify-i18n-wave.sh`
  - **Invariants:** `sdd-docs-language` — Per-wave and global verification script; Kit CLAUDE and openspec/infra install templates (W2b slice) are English
  - **Gate:** `bash scripts/verify-i18n-wave.sh --files sdd-kit/templates/CLAUDE.md,sdd-kit/templates/openspec/infra.md`
  - **Proibido:** marking tasks done if G-PT/G-INV/G-LINK/G-MANIFEST/G-OPENSPEC fail; running `--dod` as a required gate for this wave

- [x] 4.2 Validate OpenSpec change + task Pattern paths
  - **Pattern:** `scripts/verify-task-patterns.sh`
  - **Gate:** `bash scripts/verify-task-patterns.sh && OPENSPEC_TELEMETRY=0 npx --yes @fission-ai/openspec@1.3.1 validate translate-kit-wave-2b --strict`

## 5. Post-register (best-effort)

- [x] 5.1 `graphify update .` if available (docs/templates touched); otherwise SKIP per infra
  - **Pattern:** `.cursor/rules/graphify.mdc`
  - **Gate:** `test -f graphify-out/GRAPH_REPORT.md || echo 'SKIP (graphify unavailable)'`
  - **Note:** SKIP if graphify CLI unavailable

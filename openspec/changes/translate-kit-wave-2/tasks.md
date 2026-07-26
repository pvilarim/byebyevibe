# Tasks — translate-kit-wave-2

> Apply after human approval (R7). **In-place PT→EN only** on kit README + AGENTS.* templates (+ checksums). CLAUDE/infra kit copies → `translate-kit-wave-2b`. **Issue:** —

## 1. Prep (glossary + freeze)

- [ ] 1.1 Confirm glossary covers terms needed for this wave; append rows to `doc/i18n/GLOSSARY.md` only if a new SDD term is introduced (same PR)
  - **Pattern:** `doc/i18n/GLOSSARY.md`
  - **Invariants:** `sdd-docs-language` — Glossary and wave inventory exist
  - **Gate:** `test -s doc/i18n/GLOSSARY.md && grep -qE 'Session Handoff|install kit|fail-closed|wave|glossary' doc/i18n/GLOSSARY.md`
  - **Proibido:** invent synonym variants for glossary terms; dual-file `*.en.md` / `*-pt.md`

## 2. Substitute kit README + AGENTS templates (in-place)

- [ ] 2.1 Rewrite `sdd-kit/README.md` residual Portuguese prose → glossary-canonical English at the same path; keep ByeByeVibe branding, scenario codes (`C1`/`C2`/`C2b`/`C3`/`C1-UI`/`G2`/`G4`), profile names, and all fenced `bash` blocks byte-stable
  - **Pattern:** `sdd-kit/README.md`
  - **Invariants:** `sdd-docs-language` — Kit README and AGENTS install templates (W2 slice) are English; Waves replace Portuguese in-place — dual-file forbidden
  - **Gate:** `test -f sdd-kit/README.md && ! test -f sdd-kit/README.en.md && grep -q 'ByeByeVibe' sdd-kit/README.md && grep -qF 'bash sdd-kit/install.sh' sdd-kit/README.md && grep -qE '\*\*C1\*\*|\*\*C2\*\*' sdd-kit/README.md`
  - **Proibido:** dual-file siblings; translating path/command fences; renaming scenario codes; drive-by script changes

- [ ] 2.2 Rewrite `sdd-kit/templates/AGENTS.core.md` Portuguese prose → English aligned with hub W1 section titles where mirrored; translate `[PREENCHER:…]` placeholders to `[FILL:…]`; freeze `<!-- SDD_KIT_COMMANDS_START -->` / `<!-- SDD_KIT_COMMANDS_END -->`, paths, `/opsx:*`, pins, and R1–R11 numbering
  - **Pattern:** `sdd-kit/templates/AGENTS.core.md`
  - **Invariants:** `sdd-docs-language` — Kit README and AGENTS install templates (W2 slice) are English; Freeze list of non-translatable tokens
  - **Gate:** `test -f sdd-kit/templates/AGENTS.core.md && ! test -f sdd-kit/templates/AGENTS.core.en.md && grep -qF '<!-- SDD_KIT_COMMANDS_START -->' sdd-kit/templates/AGENTS.core.md && grep -qF '<!-- SDD_KIT_COMMANDS_END -->' sdd-kit/templates/AGENTS.core.md && grep -q '/opsx:propose' sdd-kit/templates/AGENTS.core.md && test "$(wc -l < sdd-kit/templates/AGENTS.core.md)" -le 150`
  - **Proibido:** dual-file siblings; moving/renaming HTML markers; renumbering R1–R11; translating path strings; exceeding MANIFEST `wc -l ≤ 150` gate for installed AGENTS.md

- [ ] 2.3 Rewrite `sdd-kit/templates/AGENTS.commands.DOCS_SPECS.md` Portuguese table headers/cells → English; freeze all fenced/command column values (`npx openspec`, `graphify`, `bash scripts/…`)
  - **Pattern:** `sdd-kit/templates/AGENTS.commands.DOCS_SPECS.md`
  - **Invariants:** `sdd-docs-language` — Kit README and AGENTS install templates (W2 slice) are English; Freeze list of non-translatable tokens
  - **Gate:** `test -f sdd-kit/templates/AGENTS.commands.DOCS_SPECS.md && ! test -f sdd-kit/templates/AGENTS.commands.DOCS_SPECS.en.md && grep -q 'npx openspec list' sdd-kit/templates/AGENTS.commands.DOCS_SPECS.md && grep -q 'graphify update' sdd-kit/templates/AGENTS.commands.DOCS_SPECS.md`
  - **Proibido:** dual-file siblings; changing command strings; altering table column count

- [ ] 2.4 Rewrite `sdd-kit/templates/AGENTS.commands.APP.md` Portuguese table headers/cells → English; freeze command column values (`npm run dev`, `npx openspec`, `graphify`, session/metrics scripts)
  - **Pattern:** `sdd-kit/templates/AGENTS.commands.APP.md`
  - **Invariants:** `sdd-docs-language` — Kit README and AGENTS install templates (W2 slice) are English; Freeze list of non-translatable tokens
  - **Gate:** `test -f sdd-kit/templates/AGENTS.commands.APP.md && ! test -f sdd-kit/templates/AGENTS.commands.APP.en.md && grep -q 'npm run dev' sdd-kit/templates/AGENTS.commands.APP.md && grep -q 'npx openspec list' sdd-kit/templates/AGENTS.commands.APP.md`
  - **Proibido:** dual-file siblings; changing command strings; altering table column count

## 3. Checksums (G-MANIFEST)

- [ ] 3.1 Regenerate `sdd-kit/MANIFEST.yaml` sha256 fields after template edits
  - **Pattern:** `sdd-kit/gen-manifest-checksums.sh`
  - **Invariants:** `sdd-docs-language` — Kit README and AGENTS install templates (W2 slice) are English (G-MANIFEST)
  - **Gate:** `bash sdd-kit/gen-manifest-checksums.sh && bash sdd-kit/verify.sh`
  - **Proibido:** hand-editing sha256 without regenerator; evaluating MANIFEST `gate:` via eval; skipping verify after checksum update

## 4. Wave gates

- [ ] 4.1 Run per-wave i18n verification on the exact W2 file list
  - **Pattern:** `scripts/verify-i18n-wave.sh`
  - **Invariants:** `sdd-docs-language` — Per-wave and global verification script; Kit README and AGENTS install templates (W2 slice) are English
  - **Gate:** `bash scripts/verify-i18n-wave.sh --files sdd-kit/README.md,sdd-kit/templates/AGENTS.core.md,sdd-kit/templates/AGENTS.commands.DOCS_SPECS.md,sdd-kit/templates/AGENTS.commands.APP.md`
  - **Proibido:** marking tasks done if G-PT/G-INV/G-LINK/G-MANIFEST/G-OPENSPEC fail; running `--dod` as a required gate for this wave

- [ ] 4.2 Validate OpenSpec change + task Pattern paths
  - **Pattern:** `scripts/verify-task-patterns.sh`
  - **Gate:** `bash scripts/verify-task-patterns.sh && OPENSPEC_TELEMETRY=0 npx --yes @fission-ai/openspec@1.3.1 validate translate-kit-wave-2 --strict`

## 5. Post-register (best-effort)

- [ ] 5.1 `graphify update .` if available (docs/templates touched); otherwise SKIP per infra
  - **Pattern:** `.cursor/rules/graphify.mdc`
  - **Gate:** `test -f graphify-out/GRAPH_REPORT.md || echo 'SKIP (graphify unavailable)'`
  - **Note:** SKIP expected if `GRAPH_REPORT.md` absent in this environment

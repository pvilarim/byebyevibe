# Tasks — translate-kit-design-wave-2

> Apply after human approval (R7). **In-place PT→EN only** on the kit Impeccable design guide mirror + MANIFEST checksum regen. **Issue:** —

## 1. Prep (glossary + freeze)

- [ ] 1.1 Confirm glossary covers terms needed for this wave (`install kit`, canonical, Session Handoff, wave, evaluation); append rows to `doc/i18n/GLOSSARY.md` only if a new SDD term is introduced (same PR)
  - **Pattern:** `doc/i18n/GLOSSARY.md`
  - **Invariants:** `sdd-docs-language` — Glossary and wave inventory exist
  - **Gate:** `test -s doc/i18n/GLOSSARY.md && grep -qE 'install kit|Session Handoff|wave|glossary|canonical|evaluation' doc/i18n/GLOSSARY.md`
  - **Forbidden:** invent synonym variants for glossary terms; dual-file `*.en.md` / `*-pt.md`; editing hub `doc/design/000-*` or kit `001|002|003|004` in this prep task

## 2. Substitute kit design mirror (in-place)

- [ ] 2.1 Rewrite `sdd-kit/templates/doc/design/000-impeccable-design-system-guia.md` Portuguese prose (title, callouts, tables, checklists, status line) → glossary-canonical English; prefer aligning with hub `doc/design/000-impeccable-design-system-guia.md` if already EN from `translate-design-wave-2`, else glossary-map from AS-IS PT; keep paths, brand/tool names, `DOCS_SPECS`, Impeccable slash commands, and relative links intact; normalize `[REFERÊNCIA — REQUER ADAPTAÇÃO]` / `[se aplicável]` to English equivalents with the same meaning
  - **Pattern:** `sdd-kit/templates/doc/design/000-impeccable-design-system-guia.md`
  - **Invariants:** `sdd-docs-language` — Kit design wave-2 Impeccable guide mirror is English; Freeze list of non-translatable tokens
  - **Gate:** `test -f sdd-kit/templates/doc/design/000-impeccable-design-system-guia.md && ! test -f sdd-kit/templates/doc/design/000-impeccable-design-system-guia.en.md && ! test -f sdd-kit/templates/doc/design/000-impeccable-design-system-guia-pt.md && grep -qF 'DOCS_SPECS' sdd-kit/templates/doc/design/000-impeccable-design-system-guia.md && grep -qF 'doc/sistema-sdd-pedro.md' sdd-kit/templates/doc/design/000-impeccable-design-system-guia.md && grep -qiE 'Impeccable|shadcn' sdd-kit/templates/doc/design/000-impeccable-design-system-guia.md && grep -qiE 'if applicable|REFERENCE|adaptation' sdd-kit/templates/doc/design/000-impeccable-design-system-guia.md && ! grep -qiE 'Próximo passo|guia canónico|O que é o Impeccable|Não é|se aplicável|REQUER ADAPTAÇÃO|Guia canónico' sdd-kit/templates/doc/design/000-impeccable-design-system-guia.md`
  - **Forbidden:** dual-file siblings; editing hub `doc/design/000-*`; drive-by edits to kit `001|002|003|004`; changing adoption recommendations beyond language

- [ ] 2.2 Regenerate kit MANIFEST checksums after the template edit
  - **Pattern:** `sdd-kit/gen-manifest-checksums.sh`
  - **Invariants:** `sdd-docs-language` — Kit design wave-2 Impeccable guide mirror is English
  - **Gate:** `bash sdd-kit/gen-manifest-checksums.sh && bash sdd-kit/verify.sh`
  - **Forbidden:** hand-editing `sha256:` fields; skipping verify after regen

## 3. Wave gates

- [ ] 3.1 Run per-wave i18n verification on the exact kit design file
  - **Pattern:** `scripts/verify-i18n-wave.sh`
  - **Invariants:** `sdd-docs-language` — Per-wave and global verification script; Kit design wave-2 Impeccable guide mirror is English
  - **Gate:** `bash scripts/verify-i18n-wave.sh --files sdd-kit/templates/doc/design/000-impeccable-design-system-guia.md`
  - **Forbidden:** marking tasks done if G-PT/G-INV/G-LINK/G-MANIFEST/G-OPENSPEC fail; running `--dod` as a required gate for this wave; touching kit `002|003|004` or hub design paths in this apply

- [ ] 3.2 Validate OpenSpec change + task Pattern paths
  - **Pattern:** `scripts/verify-task-patterns.sh`
  - **Gate:** `bash scripts/verify-task-patterns.sh && OPENSPEC_TELEMETRY=0 npx --yes @fission-ai/openspec@1.3.1 validate translate-kit-design-wave-2 --strict`

## 4. Post-register (best-effort)

- [ ] 4.1 `graphify update .` if available (docs touched); otherwise SKIP per infra
  - **Pattern:** `.cursor/rules/graphify.mdc`
  - **Gate:** `test -f graphify-out/GRAPH_REPORT.md || echo 'SKIP (graphify unavailable)'`
  - **Note:** SKIP if graphify CLI unavailable

# Tasks — translate-specs-wave-2

> Apply after human approval (R7). **In-place PT→EN only** on `openspec/specs/sdd-install-kit/spec.md`. **Issue:** —

## 1. Prep (glossary + freeze)

- [ ] 1.1 Confirm glossary covers terms needed for this wave (`install kit`, `gate`, `fail-closed`, wave, canonical); append rows to `doc/i18n/GLOSSARY.md` only if a new SDD term is introduced (same PR)
  - **Pattern:** `doc/i18n/GLOSSARY.md`
  - **Invariants:** `sdd-docs-language` — Glossary and wave inventory exist
  - **Gate:** `test -s doc/i18n/GLOSSARY.md && grep -qE 'install kit|fail-closed|gate|wave|glossary|canonical' doc/i18n/GLOSSARY.md`
  - **Forbidden:** invent synonym variants for glossary terms; dual-file `*.en.md` / `*-pt.md`; editing `sdd-kit/upgrade.sh` or `bootstrap-sdd.sh` in this prep task

## 2. Substitute install-kit spec (in-place)

- [ ] 2.1 Rewrite `openspec/specs/sdd-install-kit/spec.md` residual Portuguese prose (bootstrap HYBRID warning requirement/scenarios; upgrade dry-run `COPY` labeling; upgrade header mode text; mixed PT fragments such as MANIFEST `merge: MERGE` classification wording) → glossary-canonical English; keep paths, merge identifiers `COPY`/`MERGE`/`APPLY_TEMPLATE`, profiles APP/DOCS_SPECS/HYBRID, OpenSpec `MUST`/`WHEN`/`THEN`, and frozen runtime literals `[x] Actualização aprovada` plus bootstrap WARN/confirm stderr strings byte-stable when cited
  - **Pattern:** `openspec/specs/sdd-install-kit/spec.md`
  - **Invariants:** `sdd-docs-language` — Specs wave-2 sdd-install-kit residual PT is English; Freeze list of non-translatable tokens
  - **Gate:** `test -f openspec/specs/sdd-install-kit/spec.md && ! test -f openspec/specs/sdd-install-kit/spec.en.md && ! test -f openspec/specs/sdd-install-kit/spec-pt.md && grep -qF 'sdd-kit/upgrade.sh' openspec/specs/sdd-install-kit/spec.md && grep -qF '[x] Actualização aprovada' openspec/specs/sdd-install-kit/spec.md && grep -qF 'COPY' openspec/specs/sdd-install-kit/spec.md && grep -qF 'APPLY_TEMPLATE' openspec/specs/sdd-install-kit/spec.md && ! grep -qiE 'Quando \`package\.json\`|MUST emitir um aviso|pedindo confirmação|Não deve terminar|o operador executa|o operador corre|A saída de \`upgrade|mostra rótulo COPY|ficará|ficheiros classificados|O header impresso|modo de execução|após aprovar o relatório|O MANIFEST MUST classificar ficheiros' openspec/specs/sdd-install-kit/spec.md`
  - **Forbidden:** dual-file siblings; rewriting frozen runtime contract strings; changing integrity/approval/path-traversal semantics; drive-by edits to other specs; leaving residual Portuguese **prose** outside allowlisted quoted literals

## 3. Wave gates

- [ ] 3.1 Run per-wave i18n verification on the exact install-kit spec path
  - **Pattern:** `scripts/verify-i18n-wave.sh`
  - **Invariants:** `sdd-docs-language` — Per-wave and global verification script; Specs wave-2 sdd-install-kit residual PT is English
  - **Gate:** `bash scripts/verify-i18n-wave.sh --files openspec/specs/sdd-install-kit/spec.md`
  - **Forbidden:** marking tasks done if G-INV/G-LINK/G-OPENSPEC fail; treating frozen quoted contract literals as a reason to rewrite scripts in this apply; running `--dod` as a required gate for this wave; touching `sdd-kit/templates/` in this apply
  - **Note:** If G-PT fails solely on allowlisted frozen literals (`Actualização` / bootstrap WARN PT), document the hit in the apply PR and keep literals — do not expand scope to script EN migration

- [ ] 3.2 Validate OpenSpec change + task Pattern paths
  - **Pattern:** `scripts/verify-task-patterns.sh`
  - **Gate:** `bash scripts/verify-task-patterns.sh && OPENSPEC_TELEMETRY=0 npx --yes @fission-ai/openspec@1.3.1 validate translate-specs-wave-2 --strict`

## 4. Post-register (best-effort)

- [ ] 4.1 `graphify update .` if available (docs touched); otherwise SKIP per infra
  - **Pattern:** `.cursor/rules/graphify.mdc`
  - **Gate:** `test -f graphify-out/GRAPH_REPORT.md || echo 'SKIP (graphify unavailable)'`
  - **Note:** SKIP if graphify CLI unavailable

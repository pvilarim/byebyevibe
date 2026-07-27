# Tasks — translate-specs-wave-2

> Apply after human approval (R7). **In-place PT→EN only** on `openspec/specs/sdd-install-kit/spec.md`. **Issue:** —

## 1. Prep (glossary + freeze)

- [ ] 1.1 Confirm glossary covers terms needed for this wave (`install kit` / `sdd-kit`, `gate`, `fail-closed`, wave, canonical); append rows to `doc/i18n/GLOSSARY.md` only if a new SDD term is introduced (same PR)
  - **Pattern:** `doc/i18n/GLOSSARY.md`
  - **Invariants:** `sdd-docs-language` — Glossary and wave inventory exist
  - **Gate:** `test -s doc/i18n/GLOSSARY.md && grep -qE 'install kit|sdd-kit|fail-closed|gate|wave|glossary|canonical' doc/i18n/GLOSSARY.md`
  - **Forbidden:** invent synonym variants for glossary terms; dual-file `*.en.md` / `*-pt.md`; editing `sdd-kit/upgrade.sh` or other specs in this prep task

## 2. Substitute capability spec (in-place)

- [ ] 2.1 Rewrite `openspec/specs/sdd-install-kit/spec.md` residual Portuguese prose (upgrade MERGE classification sentence; HYBRID `bootstrap-sdd.sh` requirement + scenarios; dry-run `COPY` label requirement + scenario; dry-run vs APPLY header requirement + scenarios; any other residual PT) → glossary-canonical English; keep paths `sdd-kit/`, `MANIFEST.yaml`, scripts, merge labels `COPY`/`MERGE`, profiles, ByeByeVibe dual-naming, and OpenSpec `MUST`/`WHEN`/`THEN` intact; for the UPGRADE_REPORT approval gate, describe the approved-checkbox marker by reference to the literal that `sdd-kit/upgrade.sh` greps (do **not** paste legacy Portuguese checkbox text into the EN spec)
  - **Pattern:** `openspec/specs/sdd-install-kit/spec.md`
  - **Invariants:** `sdd-docs-language` — Specs wave-2 sdd-install-kit capability spec is English; Freeze list of non-translatable tokens
  - **Gate:** `test -f openspec/specs/sdd-install-kit/spec.md && ! test -f openspec/specs/sdd-install-kit/spec.en.md && ! test -f openspec/specs/sdd-install-kit/spec-pt.md && grep -qF 'sdd-kit/upgrade.sh' openspec/specs/sdd-install-kit/spec.md && grep -qF 'merge: COPY' openspec/specs/sdd-install-kit/spec.md && grep -qF 'bootstrap-sdd.sh' openspec/specs/sdd-install-kit/spec.md && grep -qiE 'ByeByeVibe|integrity|dry-run' openspec/specs/sdd-install-kit/spec.md && ! grep -qiE 'O MANIFEST MUST classificar|Quando \`package.json\`|Não deve terminar|A saída de \`upgrade.sh|O header impresso|o operador executa|o operador corre|ficheiros classificados|Actualização aprovada' openspec/specs/sdd-install-kit/spec.md`
  - **Forbidden:** dual-file siblings; changing integrity/MERGE/COPY/bootstrap semantics; editing `sdd-kit/upgrade.sh` or wave-1 spec paths; embedding legacy Portuguese approval checkbox substrings; leaving residual Portuguese prose

## 3. Wave gates

- [ ] 3.1 Run per-wave i18n verification on the exact install-kit spec path
  - **Pattern:** `scripts/verify-i18n-wave.sh`
  - **Invariants:** `sdd-docs-language` — Per-wave and global verification script; Specs wave-2 sdd-install-kit capability spec is English
  - **Gate:** `bash scripts/verify-i18n-wave.sh --files openspec/specs/sdd-install-kit/spec.md`
  - **Forbidden:** marking tasks done if G-PT/G-INV/G-LINK/G-OPENSPEC fail; running `--dod` as a required gate for this wave; touching `sdd-kit/templates/` or full `upgrade.sh` i18n in this apply

- [ ] 3.2 Validate OpenSpec change + task Pattern paths
  - **Pattern:** `scripts/verify-task-patterns.sh`
  - **Gate:** `bash scripts/verify-task-patterns.sh && OPENSPEC_TELEMETRY=0 npx --yes @fission-ai/openspec@1.3.1 validate translate-specs-wave-2 --strict`

## 4. Post-register (best-effort)

- [ ] 4.1 `graphify update .` if available (docs touched); otherwise SKIP per infra
  - **Pattern:** `.cursor/rules/graphify.mdc`
  - **Gate:** `test -f graphify-out/GRAPH_REPORT.md || echo 'SKIP (graphify unavailable)'`
  - **Note:** SKIP if graphify CLI unavailable

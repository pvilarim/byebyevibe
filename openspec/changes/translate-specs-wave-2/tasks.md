# Tasks — translate-specs-wave-2

> Apply after human approval (R7). **In-place PT→EN only** on `openspec/specs/sdd-install-kit/spec.md`. **Issue:** —

## 1. Prep (glossary + freeze)

- [ ] 1.1 Confirm glossary covers terms needed for this wave (`install kit` / sdd-kit, `gate`, wave, canonical); append rows to `doc/i18n/GLOSSARY.md` only if a new SDD term is introduced (same PR)
  - **Pattern:** `doc/i18n/GLOSSARY.md`
  - **Invariants:** `sdd-docs-language` — Glossary and wave inventory exist
  - **Gate:** `test -s doc/i18n/GLOSSARY.md && grep -qE 'install kit|sdd-kit|fail-closed|gate|wave|glossary|canonical' doc/i18n/GLOSSARY.md`
  - **Forbidden:** invent synonym variants for glossary terms; dual-file `*.en.md` / `*-pt.md`; editing `sdd-kit/upgrade.sh` or wave-1 owned specs in this prep task

## 2. Substitute install-kit capability spec (in-place)

- [ ] 2.1 Rewrite `openspec/specs/sdd-install-kit/spec.md` residual Portuguese prose (MANIFEST upgrade-tool MERGE sentence; bootstrap hybrid-warning requirement title/body/scenarios; dry-run COPY label requirement/scenarios; upgrade header mode requirement/scenarios; UPGRADE_REPORT approval-gate requirement/scenarios that currently embed the legacy Portuguese marker) → glossary-canonical English; keep paths `sdd-kit/`, `scripts/bootstrap-sdd.sh`, `UPGRADE_REPORT.md`, MANIFEST keys (`merge:`, `COPY`, `MERGE`), label token `APPLY_TEMPLATE`, OpenSpec `MUST`/`WHEN`/`THEN`, and script names intact; **describe** the approval checkbox via reference to `sdd-kit/upgrade.sh` match contract — **do not** paste legacy Portuguese marker wording (G-PT deny-list)
  - **Pattern:** `openspec/specs/sdd-install-kit/spec.md`
  - **Invariants:** `sdd-docs-language` — Specs wave-2 install-kit capability spec is English; Freeze list of non-translatable tokens
  - **Gate:** `test -f openspec/specs/sdd-install-kit/spec.md && ! test -f openspec/specs/sdd-install-kit/spec.en.md && ! test -f openspec/specs/sdd-install-kit/spec-pt.md && grep -qF 'sdd-kit/upgrade.sh' openspec/specs/sdd-install-kit/spec.md && grep -qF 'UPGRADE_REPORT.md' openspec/specs/sdd-install-kit/spec.md && grep -qF 'merge: COPY' openspec/specs/sdd-install-kit/spec.md && grep -qF 'APPLY_TEMPLATE' openspec/specs/sdd-install-kit/spec.md && grep -qiE 'bootstrap-sdd|profile' openspec/specs/sdd-install-kit/spec.md && ! grep -qiE 'Actualização aprovada|O MANIFEST MUST classificar|Quando \`package\.json\`|Não deve terminar|A saída de \`upgrade\.sh\`|ficheiro|ficheiros classificados|o operador (executa|corre)' openspec/specs/sdd-install-kit/spec.md`
  - **Forbidden:** dual-file siblings; changing dry-run/apply/bootstrap semantics; editing `sdd-kit/upgrade.sh` in this wave; drive-by edits to other specs; embedding deny-list Portuguese approval-marker text; leaving residual Portuguese prose

## 3. Wave gates

- [ ] 3.1 Run per-wave i18n verification on the exact install-kit spec path
  - **Pattern:** `scripts/verify-i18n-wave.sh`
  - **Invariants:** `sdd-docs-language` — Per-wave and global verification script; Specs wave-2 install-kit capability spec is English
  - **Gate:** `bash scripts/verify-i18n-wave.sh --files openspec/specs/sdd-install-kit/spec.md`
  - **Forbidden:** skipping G-PT failures; widening `--files` to unrelated surfaces; `--dod` in this wave

- [ ] 3.2 OpenSpec strict validate (pinned CLI; telemetry off)
  - **Pattern:** `scripts/verify-i18n-wave.sh`
  - **Invariants:** `sdd-docs-language` — G-OPENSPEC via pinned `@fission-ai/openspec@1.3.1`
  - **Gate:** `OPENSPEC_TELEMETRY=0 npx --yes @fission-ai/openspec@1.3.1 validate --all --strict`
  - **Forbidden:** unpinned openspec CLI; enabling telemetry; editing archive changes to force green

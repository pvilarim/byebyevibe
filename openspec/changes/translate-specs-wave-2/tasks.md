# Tasks — translate-specs-wave-2

> Apply after human approval (R7). **In-place PT→EN only** on `openspec/specs/sdd-install-kit/spec.md`. **Issue:** —

## 1. Prep (glossary + freeze)

- [ ] 1.1 Confirm glossary covers terms needed for this wave (`gate`, `fail-closed`, `install kit`, wave, canonical); append rows to `doc/i18n/GLOSSARY.md` only if a new SDD term is introduced (same PR)
  - **Pattern:** `doc/i18n/GLOSSARY.md`
  - **Invariants:** `sdd-docs-language` — Glossary and wave inventory exist
  - **Gate:** `test -s doc/i18n/GLOSSARY.md && grep -qE 'fail-closed|install kit|gate|wave|glossary|canonical' doc/i18n/GLOSSARY.md`
  - **Forbidden:** invent synonym variants for glossary terms; dual-file `*.en.md` / `*-pt.md`; editing the three specs owned by `translate-specs-wave-1` in this prep task

## 2. Substitute sdd-install-kit spec (in-place)

- [ ] 2.1 Rewrite residual Portuguese in `openspec/specs/sdd-install-kit/spec.md` (upgrade MANIFEST merge sentence; bootstrap HYBRID warning requirement title/body/scenarios; COPY dry-run label requirement title/body/scenario; any other PT requirement/scenario prose) → glossary-canonical English; keep paths, MANIFEST keys (`merge:`, `sha256:`, `gate:`), script names, OpenSpec `MUST`/`WHEN`/`THEN`, and the exact runtime marker `[x] Actualização aprovada` byte-stable
  - **Pattern:** `openspec/specs/sdd-install-kit/spec.md`
  - **Invariants:** `sdd-docs-language` — Specs wave-2 sdd-install-kit capability spec is English; Freeze list of non-translatable tokens
  - **Gate:** `test -f openspec/specs/sdd-install-kit/spec.md && ! test -f openspec/specs/sdd-install-kit/spec.en.md && ! test -f openspec/specs/sdd-install-kit/spec-pt.md && grep -qF 'sdd-kit/upgrade.sh' openspec/specs/sdd-install-kit/spec.md && grep -qF '[x] Actualização aprovada' openspec/specs/sdd-install-kit/spec.md && grep -qF 'merge: COPY' openspec/specs/sdd-install-kit/spec.md && grep -qF 'bootstrap-sdd.sh' openspec/specs/sdd-install-kit/spec.md && ! grep -qiE 'classificar ficheiros|emite aviso|rótulo COPY para ficheiros|Quando \`package\.json\`|o operador executa|o operador corre|sem nenhum aviso|O header impresso|reflectir o modo|após aprovar o relatório|alinhado com MANIFEST|HYBRID ambíguo' openspec/specs/sdd-install-kit/spec.md`
  - **Forbidden:** dual-file siblings; renaming `[x] Actualização aprovada` or editing `sdd-kit/upgrade.sh`; changing integrity/upgrade/bootstrap semantics; drive-by edits to wave-1 specs; leaving residual Portuguese prose outside the freeze marker

## 3. Wave gates

- [ ] 3.1 Run per-wave i18n verification on the exact install-kit spec path
  - **Pattern:** `scripts/verify-i18n-wave.sh`
  - **Invariants:** `sdd-docs-language` — Per-wave and global verification script; Specs wave-2 sdd-install-kit capability spec is English
  - **Gate:** `bash scripts/verify-i18n-wave.sh --files openspec/specs/sdd-install-kit/spec.md`
  - **Note:** If G-PT fails solely on the freeze marker `[x] Actualização aprovada`, document the allowlist in the apply PR and do not rename the marker; optional minimal verify exemption only if required to exit 0 — do not change `upgrade.sh` in this wave
  - **Forbidden:** marking tasks done if G-INV/G-LINK/G-OPENSPEC fail; running `--dod` as a required gate for this wave; touching `sdd-kit/templates/` or wave-1 spec paths in this apply

- [ ] 3.2 Validate OpenSpec change + task Pattern paths
  - **Pattern:** `scripts/verify-task-patterns.sh`
  - **Gate:** `bash scripts/verify-task-patterns.sh && OPENSPEC_TELEMETRY=0 npx --yes @fission-ai/openspec@1.3.1 validate translate-specs-wave-2 --strict`

## 4. Post-register (best-effort)

- [ ] 4.1 `graphify update .` if available (docs touched); otherwise SKIP per infra
  - **Pattern:** `.cursor/rules/graphify.mdc`
  - **Gate:** `test -f graphify-out/GRAPH_REPORT.md || echo 'SKIP (graphify unavailable)'`
  - **Note:** SKIP if graphify CLI unavailable

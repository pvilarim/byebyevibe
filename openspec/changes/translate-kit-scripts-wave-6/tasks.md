# Tasks — translate-kit-scripts-wave-6

> Apply after human approval (R7). **In-place PT→EN only** on `sdd-kit/templates/install-ui-module.sh`. Align embedded infra UI-module table chrome with infra-wave-1 / kit-scripts wave-5 EN forms. Refresh MANIFEST checksums. Do **not** edit the hub twin or live `openspec/infra.md`. **Issue:** —

## 1. Prep (glossary + freeze)

- [ ] 1.1 Confirm glossary covers terms needed for this wave (`install kit`, `gate`, `wave`, `session`); append rows to `doc/i18n/GLOSSARY.md` only if a new SDD term is introduced (same PR)
  - **Pattern:** `doc/i18n/GLOSSARY.md`
  - **Invariants:** `sdd-docs-language` — Glossary and wave inventory exist
  - **Gate:** `test -s doc/i18n/GLOSSARY.md && grep -qE 'install kit|sdd-kit|gate|wave|glossary|inventory|session|canonical' doc/i18n/GLOSSARY.md`
  - **Forbidden:** invent synonym variants for glossary terms; dual-file `*.en.md` / `*-pt.md`; editing unrelated owned translate paths in this prep task

## 2. Substitute templates/install-ui-module.sh (in-place)

- [ ] 2.1 Rewrite `sdd-kit/templates/install-ui-module.sh` Portuguese embedded infra UI-module table chrome and any residual Portuguese comments/operator strings → glossary-canonical English; keep `--detect` / `--dry-run` / `--apply` / `--yes` / stack detection / Impeccable install control flow intact
  - **Pattern:** `sdd-kit/templates/install-ui-module.sh`
  - **Invariants:** `sdd-docs-language` — Kit-scripts wave-6 templates/install-ui-module.sh residual-PT script is English; Freeze list of non-translatable tokens
  - **Gate:** `test -f sdd-kit/templates/install-ui-module.sh && ! test -f sdd-kit/templates/install-ui-module.en.sh && ! test -f sdd-kit/templates/install-ui-module-pt.sh && grep -qE -- '--detect|--dry-run|--apply|--yes' sdd-kit/templates/install-ui-module.sh && grep -qF 'UI Development Module' sdd-kit/templates/install-ui-module.sh && grep -qE '\\| Component \\|.*\\| Status \\|.*\\| Verify with \\|' sdd-kit/templates/install-ui-module.sh && ! grep -qiE 'Componente|Verificar com|sob demanda|na sessão' sdd-kit/templates/install-ui-module.sh`
  - **Forbidden:** dual-file siblings; changing detect/apply/impeccable semantics; editing hub `sdd-kit/install-ui-module.sh`; editing live `openspec/infra.md`; leaving residual Portuguese that fails G-PT

- [ ] 2.2 Regenerate kit MANIFEST checksums for the edited template source
  - **Pattern:** `sdd-kit/gen-manifest-checksums.sh`
  - **Invariants:** `sdd-docs-language` — Kit-scripts wave-6 templates/install-ui-module.sh residual-PT script is English
  - **Gate:** `bash sdd-kit/gen-manifest-checksums.sh && bash sdd-kit/verify.sh`
  - **Forbidden:** hand-editing unrelated MANIFEST fields; skipping checksum refresh after template content change

## 3. Wave gates

- [ ] 3.1 Run per-wave i18n verification on the exact template path
  - **Pattern:** `scripts/verify-i18n-wave.sh`
  - **Invariants:** `sdd-docs-language` — Per-wave and global verification script; Kit-scripts wave-6 templates/install-ui-module.sh residual-PT script is English
  - **Gate:** `bash scripts/verify-i18n-wave.sh --files sdd-kit/templates/install-ui-module.sh`
  - **Forbidden:** marking tasks done if G-PT/G-INV/G-MANIFEST/G-OPENSPEC fail; running `--dod` as a required gate for this wave; touching over-budget surfaces or the hub twin in this apply

- [ ] 3.2 Validate OpenSpec change + task Pattern paths
  - **Pattern:** `scripts/verify-task-patterns.sh`
  - **Gate:** `bash scripts/verify-task-patterns.sh && OPENSPEC_TELEMETRY=0 npx --yes @fission-ai/openspec@1.3.1 validate translate-kit-scripts-wave-6 --strict`

## 4. Post-register (best-effort)

- [ ] 4.1 `graphify update .` if available (docs/scripts touched); otherwise SKIP per infra
  - **Pattern:** `.cursor/rules/graphify.mdc`
  - **Gate:** `test -f graphify-out/GRAPH_REPORT.md || echo 'SKIP (graphify unavailable)'`
  - **Note:** SKIP if graphify CLI unavailable

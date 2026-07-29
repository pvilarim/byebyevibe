# Tasks — translate-kit-scripts-wave-4

> Apply after human approval (R7). **In-place PT→EN only** on `sdd-kit/upgrade.sh`. Atomically rename the approval checkbox + `grep` needle to English. Do **not** edit specs-wave-2 artifacts. **Issue:** —

## 1. Prep (glossary + freeze)

- [ ] 1.1 Confirm glossary covers terms needed for this wave (`install kit`, `gate`, `wave`, upgrade-adjacent wording); append rows to `doc/i18n/GLOSSARY.md` only if a new SDD term is introduced (same PR)
  - **Pattern:** `doc/i18n/GLOSSARY.md`
  - **Invariants:** `sdd-docs-language` — Glossary and wave inventory exist
  - **Gate:** `test -s doc/i18n/GLOSSARY.md && grep -qE 'install kit|sdd-kit|gate|wave|glossary|inventory|canonical' doc/i18n/GLOSSARY.md`
  - **Forbidden:** invent synonym variants for glossary terms; dual-file `*.en.md` / `*-pt.md`; editing unrelated owned translate paths in this prep task

## 2. Substitute upgrade.sh (in-place)

- [ ] 2.1 Rewrite `sdd-kit/upgrade.sh` Portuguese comments, dry-run `UPGRADE_REPORT.md` scaffold prose, and operator-facing `echo`/stderr strings → glossary-canonical English; keep COPY/MERGE classification, profile filtering, `--force` branch safety, and sha256 integrity checks intact
  - **Pattern:** `sdd-kit/upgrade.sh`
  - **Invariants:** `sdd-docs-language` — Kit-scripts wave-4 upgrade.sh residual-PT script is English; Freeze list of non-translatable tokens
  - **Gate:** `test -f sdd-kit/upgrade.sh && ! test -f sdd-kit/upgrade.en.sh && ! test -f sdd-kit/upgrade-pt.sh && grep -qE -- '--dry-run|--apply' sdd-kit/upgrade.sh && grep -qF 'UPGRADE_REPORT' sdd-kit/upgrade.sh && ! grep -qiE 'actualização|mutuamente exclusivos|não encontrado|não foi aprovado|Matriz de ficheiros|Relatório de actualização|PARAR: revisar' sdd-kit/upgrade.sh`
  - **Forbidden:** dual-file siblings; changing COPY/MERGE/`--force`/integrity semantics; editing `openspec/specs/sdd-install-kit/spec.md`; leaving residual Portuguese that fails G-PT

- [ ] 2.2 Atomically align the approval checkbox scaffold text and the `--apply` `grep -q` needle to the same English form (recommended stem: `Upgrade approved`); update operator error hints that quote the needle
  - **Pattern:** `sdd-kit/upgrade.sh`
  - **Invariants:** `sdd-docs-language` — Kit-scripts wave-4 upgrade.sh residual-PT script is English
  - **Gate:** `test "$(grep -cE 'Upgrade approved' sdd-kit/upgrade.sh)" -ge 2 && grep -qE 'grep -q .\\\[x\\\] Upgrade approved' sdd-kit/upgrade.sh && ! grep -qiE 'Actualização aprovada|atualização aprovada' sdd-kit/upgrade.sh`
  - **Forbidden:** renaming scaffold without updating grep (or the reverse); inventing a second divergent needle; editing specs-wave-2 paths

## 3. Wave gates

- [ ] 3.1 Run per-wave i18n verification on the exact script path
  - **Pattern:** `scripts/verify-i18n-wave.sh`
  - **Invariants:** `sdd-docs-language` — Per-wave and global verification script; Kit-scripts wave-4 upgrade.sh residual-PT script is English
  - **Gate:** `bash scripts/verify-i18n-wave.sh --files sdd-kit/upgrade.sh`
  - **Forbidden:** marking tasks done if G-PT/G-INV/G-OPENSPEC fail; running `--dod` as a required gate for this wave; touching over-budget surfaces in this apply

- [ ] 3.2 Validate OpenSpec change + task Pattern paths
  - **Pattern:** `scripts/verify-task-patterns.sh`
  - **Gate:** `bash scripts/verify-task-patterns.sh && OPENSPEC_TELEMETRY=0 npx --yes @fission-ai/openspec@1.3.1 validate translate-kit-scripts-wave-4 --strict`

## 4. Post-register (best-effort)

- [ ] 4.1 `graphify update .` if available (docs/scripts touched); otherwise SKIP per infra
  - **Pattern:** `.cursor/rules/graphify.mdc`
  - **Gate:** `test -f graphify-out/GRAPH_REPORT.md || echo 'SKIP (graphify unavailable)'`
  - **Note:** SKIP if graphify CLI unavailable

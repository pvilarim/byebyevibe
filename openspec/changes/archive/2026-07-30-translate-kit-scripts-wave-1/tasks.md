# Tasks — translate-kit-scripts-wave-1

> Apply after human approval (R7). **In-place PT→EN only** on the two `sdd-upgrade-diff.sh` paths (+ MANIFEST checksums). **Issue:** —

## 1. Prep (glossary + freeze)

- [x] 1.1 Confirm glossary covers terms needed for this wave (`install kit`, `inventory`, `gate`, `wave`); append rows to `doc/i18n/GLOSSARY.md` only if a new SDD term is introduced (same PR)
  - **Pattern:** `doc/i18n/GLOSSARY.md`
  - **Invariants:** `sdd-docs-language` — Glossary and wave inventory exist
  - **Gate:** `test -s doc/i18n/GLOSSARY.md && grep -qE 'install kit|sdd-kit|gate|wave|glossary|inventory|canonical' doc/i18n/GLOSSARY.md`
  - **Forbidden:** invent synonym variants for glossary terms; dual-file `*.en.md` / `*-pt.md`; editing unrelated owned translate paths in this prep task

## 2. Substitute upgrade-diff scripts (in-place)

- [x] 2.1 Rewrite `scripts/sdd-upgrade-diff.sh` Portuguese comments and operator-facing `echo`/stderr strings → glossary-canonical English; keep `CURATED_FILES` path-only parser, exit codes, and path identifiers intact; do **not** port template `source:` / `CURATED_DESTS` logic into the hub in this wave
  - **Pattern:** `scripts/sdd-upgrade-diff.sh`
  - **Invariants:** `sdd-docs-language` — Kit-scripts wave-1 sdd-upgrade-diff residual-PT scripts are English; Freeze list of non-translatable tokens
  - **Gate:** `test -f scripts/sdd-upgrade-diff.sh && ! test -f scripts/sdd-upgrade-diff.en.sh && ! test -f scripts/sdd-upgrade-diff-pt.sh && grep -qF 'CURATED_FILES' scripts/sdd-upgrade-diff.sh && grep -qF 'sdd-kit/MANIFEST.yaml' scripts/sdd-upgrade-diff.sh && ! grep -qiE 'ficheiro|ficheiros|inventário|não detectado|não existe|apenas\.|Compara ficheiros|Fonte inventário|Nenhuma diferença' scripts/sdd-upgrade-diff.sh`
  - **Forbidden:** dual-file siblings; syncing hub logic to template; drive-by edits to `upgrade.sh` / `bootstrap-sdd.sh` / `install-ui-module.sh`; leaving residual Portuguese that fails G-PT

- [x] 2.2 Rewrite `sdd-kit/templates/scripts/sdd-upgrade-diff.sh` Portuguese comments and operator-facing `echo`/stderr strings → glossary-canonical English; keep `CURATED_DESTS` / `CURATED_SOURCES` and MANIFEST `source:` parsing intact
  - **Pattern:** `sdd-kit/templates/scripts/sdd-upgrade-diff.sh`
  - **Invariants:** `sdd-docs-language` — Kit-scripts wave-1 sdd-upgrade-diff residual-PT scripts are English; Freeze list of non-translatable tokens
  - **Gate:** `test -f sdd-kit/templates/scripts/sdd-upgrade-diff.sh && ! test -f sdd-kit/templates/scripts/sdd-upgrade-diff.en.sh && ! test -f sdd-kit/templates/scripts/sdd-upgrade-diff-pt.sh && grep -qF 'CURATED_DESTS' sdd-kit/templates/scripts/sdd-upgrade-diff.sh && grep -qF 'CURATED_SOURCES' sdd-kit/templates/scripts/sdd-upgrade-diff.sh && ! grep -qiE 'ficheiro|ficheiros|inventário|não detectado|não existe|apenas\.|Compara ficheiros|Fonte inventário|Nenhuma diferença' sdd-kit/templates/scripts/sdd-upgrade-diff.sh`
  - **Forbidden:** dual-file siblings; removing `source:` parsing; rewriting unrelated kit templates; leaving residual Portuguese that fails G-PT

## 3. Kit checksums + wave gates

- [x] 3.1 Regenerate MANIFEST checksums after the template edit
  - **Pattern:** `sdd-kit/gen-manifest-checksums.sh`
  - **Invariants:** `sdd-docs-language` — Kit-scripts wave-1 sdd-upgrade-diff residual-PT scripts are English
  - **Gate:** `bash sdd-kit/gen-manifest-checksums.sh && grep -A6 'path: scripts/sdd-upgrade-diff.sh' sdd-kit/MANIFEST.yaml | grep -q 'sha256:'`
  - **Forbidden:** hand-editing unrelated MANIFEST merge/profile fields; skipping checksum regeneration

- [x] 3.2 Run per-wave i18n verification on the exact script paths
  - **Pattern:** `scripts/verify-i18n-wave.sh`
  - **Invariants:** `sdd-docs-language` — Per-wave and global verification script; Kit-scripts wave-1 sdd-upgrade-diff residual-PT scripts are English
  - **Gate:** `bash scripts/verify-i18n-wave.sh --files scripts/sdd-upgrade-diff.sh,sdd-kit/templates/scripts/sdd-upgrade-diff.sh`
  - **Forbidden:** marking tasks done if G-PT/G-INV/G-MANIFEST/G-OPENSPEC fail; running `--dod` as a required gate for this wave; touching over-budget surfaces in this apply

- [x] 3.3 Validate OpenSpec change + task Pattern paths
  - **Pattern:** `scripts/verify-task-patterns.sh`
  - **Gate:** `bash scripts/verify-task-patterns.sh && OPENSPEC_TELEMETRY=0 npx --yes @fission-ai/openspec@1.3.1 validate translate-kit-scripts-wave-1 --strict`

## 4. Post-register (best-effort)

- [x] 4.1 `graphify update .` if available (docs/scripts touched); otherwise SKIP per infra
  - **Pattern:** `.cursor/rules/graphify.mdc`
  - **Gate:** `test -f graphify-out/GRAPH_REPORT.md || echo 'SKIP (graphify unavailable)'`
  - **Note:** SKIP if graphify CLI unavailable

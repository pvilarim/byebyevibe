# Tasks — translate-kit-scripts-wave-3

> Apply after human approval (R7). **In-place PT→EN only** on the two `bootstrap-sdd.sh` paths (+ MANIFEST checksums). Preserve hub↔template profile-detection divergence. **Issue:** —

## 1. Prep (glossary + freeze)

- [ ] 1.1 Confirm glossary covers terms needed for this wave (`install kit`, `gate`, `wave`, bootstrap-adjacent wording); append rows to `doc/i18n/GLOSSARY.md` only if a new SDD term is introduced (same PR)
  - **Pattern:** `doc/i18n/GLOSSARY.md`
  - **Invariants:** `sdd-docs-language` — Glossary and wave inventory exist
  - **Gate:** `test -s doc/i18n/GLOSSARY.md && grep -qE 'install kit|sdd-kit|gate|wave|glossary|inventory|canonical' doc/i18n/GLOSSARY.md`
  - **Forbidden:** invent synonym variants for glossary terms; dual-file `*.en.md` / `*-pt.md`; editing unrelated owned translate paths in this prep task

## 2. Substitute bootstrap scripts (in-place)

- [ ] 2.1 Rewrite `scripts/bootstrap-sdd.sh` Portuguese comments and operator-facing `echo`/stderr strings → glossary-canonical English; keep OpenSpec/GitNexus/Graphify/`sdd-kit/install.sh` control flow and the hub profile-inference logic intact; do **not** port template HYBRID coexistence detection into the hub in this wave
  - **Pattern:** `scripts/bootstrap-sdd.sh`
  - **Invariants:** `sdd-docs-language` — Kit-scripts wave-3 bootstrap residual-PT scripts are English; Freeze list of non-translatable tokens
  - **Gate:** `test -f scripts/bootstrap-sdd.sh && ! test -f scripts/bootstrap-sdd.en.sh && ! test -f scripts/bootstrap-sdd-pt.sh && grep -qF 'sdd-kit/install.sh' scripts/bootstrap-sdd.sh && grep -qE 'PROFILE=' scripts/bootstrap-sdd.sh && ! grep -qiE 'não|opcional —|falhou — a continuar|instalação do GitNexus' scripts/bootstrap-sdd.sh`
  - **Forbidden:** dual-file siblings; syncing hub logic to template; drive-by edits to `upgrade.sh` / `verify-infra.sh` / `install-ui-module.sh`; leaving residual Portuguese that fails G-PT

- [ ] 2.2 Rewrite `sdd-kit/templates/scripts/bootstrap-sdd.sh` Portuguese comments and operator-facing `echo`/stderr strings → glossary-canonical English; keep the template-only HYBRID coexistence stderr warning and default-`APP` behavior intact (translate wording only)
  - **Pattern:** `sdd-kit/templates/scripts/bootstrap-sdd.sh`
  - **Invariants:** `sdd-docs-language` — Kit-scripts wave-3 bootstrap residual-PT scripts are English; Freeze list of non-translatable tokens
  - **Gate:** `test -f sdd-kit/templates/scripts/bootstrap-sdd.sh && ! test -f sdd-kit/templates/scripts/bootstrap-sdd.en.sh && ! test -f sdd-kit/templates/scripts/bootstrap-sdd-pt.sh && grep -qF 'HYBRID' sdd-kit/templates/scripts/bootstrap-sdd.sh && grep -qF 'sdd-kit/install.sh' sdd-kit/templates/scripts/bootstrap-sdd.sh && ! grep -qiE 'não|opcional —|falhou — a continuar|instalação do GitNexus|coexistem|por defeito|se não for APP' sdd-kit/templates/scripts/bootstrap-sdd.sh`
  - **Forbidden:** dual-file siblings; removing HYBRID warning behavior; rewriting unrelated kit templates; leaving residual Portuguese that fails G-PT

## 3. Kit checksums + wave gates

- [ ] 3.1 Regenerate MANIFEST checksums after the template edit
  - **Pattern:** `sdd-kit/gen-manifest-checksums.sh`
  - **Invariants:** `sdd-docs-language` — Kit-scripts wave-3 bootstrap residual-PT scripts are English
  - **Gate:** `bash sdd-kit/gen-manifest-checksums.sh && grep -A6 'path: scripts/bootstrap-sdd.sh' sdd-kit/MANIFEST.yaml | grep -q 'sha256:'`
  - **Forbidden:** hand-editing unrelated MANIFEST merge/profile fields; skipping checksum regeneration

- [ ] 3.2 Run per-wave i18n verification on the exact script paths
  - **Pattern:** `scripts/verify-i18n-wave.sh`
  - **Invariants:** `sdd-docs-language` — Per-wave and global verification script; Kit-scripts wave-3 bootstrap residual-PT scripts are English
  - **Gate:** `bash scripts/verify-i18n-wave.sh --files scripts/bootstrap-sdd.sh,sdd-kit/templates/scripts/bootstrap-sdd.sh`
  - **Forbidden:** marking tasks done if G-PT/G-INV/G-MANIFEST/G-OPENSPEC fail; running `--dod` as a required gate for this wave; touching over-budget surfaces in this apply

- [ ] 3.3 Validate OpenSpec change + task Pattern paths
  - **Pattern:** `scripts/verify-task-patterns.sh`
  - **Gate:** `bash scripts/verify-task-patterns.sh && OPENSPEC_TELEMETRY=0 npx --yes @fission-ai/openspec@1.3.1 validate translate-kit-scripts-wave-3 --strict`

## 4. Post-register (best-effort)

- [ ] 4.1 `graphify update .` if available (docs/scripts touched); otherwise SKIP per infra
  - **Pattern:** `.cursor/rules/graphify.mdc`
  - **Gate:** `test -f graphify-out/GRAPH_REPORT.md || echo 'SKIP (graphify unavailable)'`
  - **Note:** SKIP if graphify CLI unavailable

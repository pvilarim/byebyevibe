# Tasks — translate-specs-wave-2

> Apply after human approval (R7). **In-place PT→EN only** on `openspec/specs/sdd-install-kit/spec.md`. **Issue:** —

## 1. Prep (glossary + freeze)

- [x] 1.1 Confirm glossary covers terms needed for this wave (`install kit`, `gate`, `wave`, fail-closed, canonical); append rows to `doc/i18n/GLOSSARY.md` only if a new SDD term is introduced (same PR)
  - **Pattern:** `doc/i18n/GLOSSARY.md`
  - **Invariants:** `sdd-docs-language` — Glossary and wave inventory exist
  - **Gate:** `test -s doc/i18n/GLOSSARY.md && grep -qE 'install kit|sdd-kit|gate|wave|glossary|canonical|fail-closed' doc/i18n/GLOSSARY.md`
  - **Forbidden:** invent synonym variants for glossary terms; dual-file `*.en.md` / `*-pt.md`; editing wave-1 owned specs (`sdd-ci-gates`, `sdd-post-install-verification`, `sdd-session-coordination`) in this prep task

## 2. Substitute capability spec (in-place)

- [x] 2.1 Rewrite `openspec/specs/sdd-install-kit/spec.md` residual Portuguese prose (Deterministic SDD upgrade MERGE sentence; bootstrap HYBRID warning requirement/scenarios; dry-run COPY label; upgrade header dry-run/apply scenarios; approval-gate scenario chrome) → glossary-canonical English; keep paths `sdd-kit/`, `MANIFEST.yaml`, `install.sh`, `upgrade.sh`, `verify.sh`, `scripts/bootstrap-sdd.sh`, `scripts/sdd-upgrade-diff.sh`, `scripts/sdd-metrics.sh`, `UPGRADE_REPORT.md`, merge labels `COPY`/`MERGE`, profiles APP/DOCS_SPECS/HYBRID, header strings `SDD UPGRADE REPORT (dry-run)` / `SDD UPGRADE APPLY`, and OpenSpec `MUST`/`WHEN`/`THEN` keywords intact; per design D5 keep bootstrap stderr warning string byte-stable in backticks and cross-reference `sdd-kit/upgrade.sh` for the UPGRADE_REPORT approval checkbox contract without re-embedding deny-listed `Actualização`/`atualização` tokens
  - **Pattern:** `openspec/specs/sdd-install-kit/spec.md`
  - **Invariants:** `sdd-docs-language` — Specs wave-2 sdd-install-kit residual-PT capability spec is English; Freeze list of non-translatable tokens
  - **Gate:** `test -f openspec/specs/sdd-install-kit/spec.md && ! test -f openspec/specs/sdd-install-kit/spec.en.md && ! test -f openspec/specs/sdd-install-kit/spec-pt.md && grep -qF 'sdd-kit/upgrade.sh' openspec/specs/sdd-install-kit/spec.md && grep -qF 'merge: MERGE' openspec/specs/sdd-install-kit/spec.md && grep -qF 'merge: COPY' openspec/specs/sdd-install-kit/spec.md && grep -qF 'SDD UPGRADE REPORT (dry-run)' openspec/specs/sdd-install-kit/spec.md && grep -qF 'SDD UPGRADE APPLY' openspec/specs/sdd-install-kit/spec.md && grep -qF 'WARN: package.json e openspec/ coexistem — perfil pode ser HYBRID.' openspec/specs/sdd-install-kit/spec.md && grep -qiE 'UPGRADE_REPORT|approval' openspec/specs/sdd-install-kit/spec.md && ! grep -qiE 'O MANIFEST MUST classificar|emite aviso em repo|Quando \`package.json\`|Não deve terminar|sem nenhum aviso|mostra rótulo COPY|ficheiros classificados|o operador corre|após aprovar o relatório' openspec/specs/sdd-install-kit/spec.md`
  - **Forbidden:** dual-file siblings; changing install/upgrade/verify semantics; renaming the upgrade approval checkbox inside `sdd-kit/upgrade.sh` in this wave; drive-by edits to other specs; leaving residual Portuguese prose that fails G-PT

## 3. Wave gates

- [x] 3.1 Run per-wave i18n verification on the exact capability-spec file
  - **Pattern:** `scripts/verify-i18n-wave.sh`
  - **Invariants:** `sdd-docs-language` — Per-wave and global verification script; Specs wave-2 sdd-install-kit residual-PT capability spec is English
  - **Gate:** `bash scripts/verify-i18n-wave.sh --files openspec/specs/sdd-install-kit/spec.md`
  - **Forbidden:** marking tasks done if G-PT/G-INV/G-LINK/G-OPENSPEC fail; running `--dod` as a required gate for this wave; touching `sdd-kit/templates/` or wave-1 owned specs in this apply

- [x] 3.2 Validate OpenSpec change + task Pattern paths
  - **Pattern:** `scripts/verify-task-patterns.sh`
  - **Gate:** `bash scripts/verify-task-patterns.sh && OPENSPEC_TELEMETRY=0 npx --yes @fission-ai/openspec@1.3.1 validate translate-specs-wave-2 --strict`

## 4. Post-register (best-effort)

- [x] 4.1 `graphify update .` if available (docs touched); otherwise SKIP per infra
  - **Pattern:** `.cursor/rules/graphify.mdc`
  - **Gate:** `test -f graphify-out/GRAPH_REPORT.md || echo 'SKIP (graphify unavailable)'`
  - **Note:** SKIP if graphify CLI unavailable

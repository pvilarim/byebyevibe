# Tasks — translate-specs-wave-2

> Apply after human approval (R7). **In-place PT→EN only** on the listed capability spec. **Issue:** —

## 1. Prep (glossary + freeze)

- [ ] 1.1 Confirm glossary covers terms needed for this wave (`install kit`, gate, wave, fail-closed, Session Handoff, canonical); append rows to `doc/i18n/GLOSSARY.md` only if a new SDD term is introduced (same PR)
  - **Pattern:** `doc/i18n/GLOSSARY.md`
  - **Invariants:** `sdd-docs-language` — Glossary and wave inventory exist
  - **Gate:** `test -s doc/i18n/GLOSSARY.md && grep -qE 'install kit|fail-closed|Session Handoff|wave|glossary|canonical' doc/i18n/GLOSSARY.md`
  - **Forbidden:** invent synonym variants for glossary terms; dual-file `*.en.md` / `*-pt.md`; editing specs wave-1 paths or `sdd-kit/templates/` in this prep task

## 2. Substitute capability spec (in-place)

- [ ] 2.1 Rewrite `openspec/specs/sdd-install-kit/spec.md` residual Portuguese prose (requirement titles/bodies and scenarios still in PT: bootstrap HYBRID warning; upgrade classify label alignment; upgrade header mode distinction; mixed PT in Deterministic SDD upgrade MANIFEST sentence; any other residual PT outside frozen literals) → glossary-canonical English; keep paths, MANIFEST keys, profiles, OpenSpec `MUST`/`WHEN`/`THEN`, and **byte-stable contract literals** `[x] Actualização aprovada` and `WARN: package.json e openspec/ coexistem — perfil pode ser HYBRID.` intact; keep documented English output labels (`COPY`, `APPLY_TEMPLATE`, `SDD UPGRADE REPORT (dry-run)`, `SDD UPGRADE APPLY`, integrity `ERROR:`/`WARN:`) intact
  - **Pattern:** `openspec/specs/sdd-install-kit/spec.md`
  - **Invariants:** `sdd-docs-language` — Specs wave-2 sdd-install-kit capability spec is English; Freeze list of non-translatable tokens
  - **Gate:** `test -f openspec/specs/sdd-install-kit/spec.md && ! test -f openspec/specs/sdd-install-kit/spec.en.md && ! test -f openspec/specs/sdd-install-kit/spec-pt.md && grep -qF 'sdd-kit/install.sh' openspec/specs/sdd-install-kit/spec.md && grep -qF 'sha256:' openspec/specs/sdd-install-kit/spec.md && grep -qF '[x] Actualização aprovada' openspec/specs/sdd-install-kit/spec.md && grep -qF 'WARN: package.json e openspec/ coexistem — perfil pode ser HYBRID.' openspec/specs/sdd-install-kit/spec.md && grep -qF 'APPLY_TEMPLATE' openspec/specs/sdd-install-kit/spec.md && ! grep -qiE 'emite aviso em repo|alinhado com MANIFEST|distingue modo dry-run|classificar ficheiros|confirmação explícita|perfil por defeito|Não deve terminar|o operador executa|o operador corre|ficheiro' openspec/specs/sdd-install-kit/spec.md`
  - **Forbidden:** dual-file siblings; translating/removing the approval checkbox or HYBRID WARN contract literals; changing install/upgrade/verify semantics; drive-by edits to other specs; leaving residual Portuguese prose outside frozen literals

## 3. Wave gates

- [ ] 3.1 Run per-wave i18n verification on the exact capability-spec file
  - **Pattern:** `scripts/verify-i18n-wave.sh`
  - **Invariants:** `sdd-docs-language` — Per-wave and global verification script; Specs wave-2 sdd-install-kit capability spec is English
  - **Gate:** `bash scripts/verify-i18n-wave.sh --files openspec/specs/sdd-install-kit/spec.md`
  - **Forbidden:** marking tasks done if G-PT/G-INV/G-LINK/G-OPENSPEC fail without documenting allowlist for frozen contract literals; running `--dod` as a required gate for this wave; touching `sdd-kit/templates/` or specs wave-1 paths in this apply

- [ ] 3.2 Validate OpenSpec change + task Pattern paths
  - **Pattern:** `scripts/verify-task-patterns.sh`
  - **Gate:** `bash scripts/verify-task-patterns.sh && OPENSPEC_TELEMETRY=0 npx --yes @fission-ai/openspec@1.3.1 validate translate-specs-wave-2 --strict`

## 4. Post-register (best-effort)

- [ ] 4.1 `graphify update .` if available (docs touched); otherwise SKIP per infra
  - **Pattern:** `.cursor/rules/graphify.mdc`
  - **Gate:** `test -f graphify-out/GRAPH_REPORT.md || echo 'SKIP (graphify unavailable)'`
  - **Note:** SKIP if graphify CLI unavailable

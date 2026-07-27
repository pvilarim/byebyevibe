# Tasks — translate-specs-wave-2

> Apply after human approval (R7). **In-place PT→EN only** on `openspec/specs/sdd-install-kit/spec.md`. **Issue:** —

## 1. Prep (glossary + freeze)

- [ ] 1.1 Confirm glossary covers terms needed for this wave (`install kit`, `upgrade`, `wave`, `fail-closed`, `canonical`); append rows to `doc/i18n/GLOSSARY.md` only if a new SDD term is introduced (same PR)
  - **Pattern:** `doc/i18n/GLOSSARY.md`
  - **Invariants:** `sdd-docs-language` — Glossary and wave inventory exist
  - **Gate:** `test -s doc/i18n/GLOSSARY.md && grep -qE 'install kit|sdd-kit|fail-closed|wave|glossary|canonical' doc/i18n/GLOSSARY.md`
  - **Forbidden:** invent synonym variants for glossary terms; dual-file `*.en.md` / `*-pt.md`; editing `sdd-kit/upgrade.sh` or wave-1 spec paths in this prep task

## 2. Substitute sdd-install-kit (in-place)

- [ ] 2.1 Rewrite `openspec/specs/sdd-install-kit/spec.md` residual Portuguese prose (Deterministic SDD upgrade mixed PT fragment; bootstrap HYBRID warning requirement/scenarios; upgrade COPY label / header mode requirements and scenarios; any other deny-list hits) → glossary-canonical English; keep paths `sdd-kit/install.sh`, `sdd-kit/upgrade.sh`, `sdd-kit/MANIFEST.yaml`, `scripts/bootstrap-sdd.sh`, `scripts/sdd-upgrade-diff.sh`, MANIFEST `merge: COPY` / `merge: MERGE`, profile names, OpenSpec `MUST`/`WHEN`/`THEN`, and the literal approval marker `[x] Actualização aprovada` intact
  - **Pattern:** `openspec/specs/sdd-install-kit/spec.md`
  - **Invariants:** `sdd-docs-language` — Specs wave-2 sdd-install-kit residual PT is English; Freeze list of non-translatable tokens
  - **Gate:** `test -f openspec/specs/sdd-install-kit/spec.md && ! test -f openspec/specs/sdd-install-kit/spec.en.md && ! test -f openspec/specs/sdd-install-kit/spec-pt.md && grep -qF 'sdd-kit/upgrade.sh' openspec/specs/sdd-install-kit/spec.md && grep -qF '\[x\] Actualização aprovada' openspec/specs/sdd-install-kit/spec.md && grep -qF 'merge: COPY' openspec/specs/sdd-install-kit/spec.md && grep -qF 'bootstrap-sdd.sh' openspec/specs/sdd-install-kit/spec.md && ! grep -qiE 'O MANIFEST MUST classificar|Quando \`package\.json\`|emite um aviso|A saída de \`upgrade\.sh\`|O header impresso|Dry-run mostra rótulo|não recebe aviso|o operador executa|o operador corre' openspec/specs/sdd-install-kit/spec.md`
  - **Forbidden:** dual-file siblings; translating `[x] Actualização aprovada`; changing install/upgrade/bootstrap semantics; editing `sdd-kit/upgrade.sh` or wave-1 owned specs; leaving residual Portuguese prose outside the freeze marker

## 3. Wave gates

- [ ] 3.1 Run per-wave i18n verification on the exact install-kit spec path
  - **Pattern:** `scripts/verify-i18n-wave.sh`
  - **Invariants:** `sdd-docs-language` — Per-wave and global verification script; Specs wave-2 sdd-install-kit residual PT is English
  - **Gate:** `bash scripts/verify-i18n-wave.sh --files openspec/specs/sdd-install-kit/spec.md`
  - **Forbidden:** marking tasks done if G-PT/G-INV/G-LINK/G-OPENSPEC fail for reasons other than a documented freeze-marker allowlist; running `--dod` as a required gate for this wave; touching `sdd-kit/templates/` or wave-1 specs in this apply
  - **Note:** If G-PT fails solely on `[x] Actualização aprovada`, keep the token; record allowlist in the apply PR; do not rewrite `upgrade.sh` in this wave

- [ ] 3.2 Validate OpenSpec change + task Pattern paths
  - **Pattern:** `scripts/verify-task-patterns.sh`
  - **Gate:** `bash scripts/verify-task-patterns.sh && OPENSPEC_TELEMETRY=0 npx --yes @fission-ai/openspec@1.3.1 validate translate-specs-wave-2 --strict`

## 4. Post-register (best-effort)

- [ ] 4.1 `graphify update .` if available (docs touched); otherwise SKIP per infra
  - **Pattern:** `.cursor/rules/graphify.mdc`
  - **Gate:** `test -f graphify-out/GRAPH_REPORT.md || echo 'SKIP (graphify unavailable)'`
  - **Note:** SKIP if graphify CLI unavailable

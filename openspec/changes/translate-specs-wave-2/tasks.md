# Tasks — translate-specs-wave-2

> Apply after human approval (R7). **In-place PT→EN** on `sdd-install-kit` + mechanical EN contract literals in companion scripts. **Issue:** —

## 1. Prep (glossary + freeze)

- [ ] 1.1 Confirm glossary covers terms needed for this wave (`install kit`, `wave`, `fail-closed`, `gate`, glossary, canonical); append rows to `doc/i18n/GLOSSARY.md` only if a new SDD term is introduced (same PR)
  - **Pattern:** `doc/i18n/GLOSSARY.md`
  - **Invariants:** `sdd-docs-language` — Glossary and wave inventory exist
  - **Gate:** `test -s doc/i18n/GLOSSARY.md && grep -qE 'install kit|fail-closed|gate|wave|glossary|canonical' doc/i18n/GLOSSARY.md`
  - **Forbidden:** invent synonym variants; dual-file `*.en.md` / `*-pt.md`; editing wave-1 owned specs in this prep task

## 2. Substitute install-kit spec (in-place)

- [ ] 2.1 Rewrite `openspec/specs/sdd-install-kit/spec.md` residual Portuguese prose (upgrade MERGE classification sentence; HYBRID bootstrap requirement/scenarios; COPY classify-label requirement/scenarios; dry-run/apply header requirement/scenarios; “guia” → “guide” in version-alignment THEN; approval-checkbox requirement/scenarios using English marker) → glossary-canonical English; keep paths, MANIFEST `merge:` values, header strings `SDD UPGRADE REPORT (dry-run)` / `SDD UPGRADE APPLY`, and OpenSpec `MUST`/`WHEN`/`THEN` intact
  - **Pattern:** `openspec/specs/sdd-install-kit/spec.md`
  - **Invariants:** `sdd-docs-language` — Specs wave-2 sdd-install-kit residual PT is English; Freeze list of non-translatable tokens
  - **Gate:** `test -f openspec/specs/sdd-install-kit/spec.md && ! test -f openspec/specs/sdd-install-kit/spec.en.md && ! test -f openspec/specs/sdd-install-kit/spec-pt.md && grep -qF 'merge: COPY' openspec/specs/sdd-install-kit/spec.md && grep -qF 'SDD UPGRADE REPORT (dry-run)' openspec/specs/sdd-install-kit/spec.md && grep -qF '[x] Upgrade approved' openspec/specs/sdd-install-kit/spec.md && ! grep -qiE 'ficheiros|rótulo|coexistem|por defeito|Actualização aprovada|o operador|não recebe|reflectir|emite aviso|classificar ficheiros' openspec/specs/sdd-install-kit/spec.md`
  - **Forbidden:** dual-file siblings; changing MERGE/COPY/HYBRID/approval semantics; drive-by edits to wave-1 specs; leaving residual Portuguese prose; keeping Portuguese approval/WARN quotes in the spec

## 3. Companion contract literals (scripts)

- [ ] 3.1 Update `sdd-kit/upgrade.sh` so dry-run scaffold + `--apply` approval detection use the English marker `[x] Upgrade approved` (and matching unchecked scaffold / ERROR hint lines); keep exit codes and control flow identical
  - **Pattern:** `sdd-kit/upgrade.sh`
  - **Invariants:** `sdd-docs-language` — Specs wave-2 sdd-install-kit residual PT is English
  - **Gate:** `grep -qF '[x] Upgrade approved' sdd-kit/upgrade.sh && ! grep -qF 'Actualização aprovada' sdd-kit/upgrade.sh`
  - **Forbidden:** rewriting unrelated upgrade logic; translating the entire UPGRADE_REPORT scaffold beyond marker/ERROR lines required for parity; changing dry-run vs apply headers

- [ ] 3.2 Rewrite residual Portuguese operator strings in `sdd-kit/templates/scripts/bootstrap-sdd.sh` to English (GitNexus optional echoes + HYBRID coexistence WARN block); preserve profile detection behavior (warn + default APP when `package.json` and `openspec/` coexist)
  - **Pattern:** `sdd-kit/templates/scripts/bootstrap-sdd.sh`
  - **Invariants:** `sdd-docs-language` — Specs wave-2 sdd-install-kit residual PT is English
  - **Gate:** `test -f sdd-kit/templates/scripts/bootstrap-sdd.sh && grep -qiE 'package.json.*openspec|HYBRID' sdd-kit/templates/scripts/bootstrap-sdd.sh && ! grep -qiE 'coexistem|por defeito|não aborta|falhou — a continuar|instalação do GitNexus falhou|Confirmar: relançar' sdd-kit/templates/scripts/bootstrap-sdd.sh`
  - **Forbidden:** dual-file siblings; removing HYBRID detect/warn behavior; skipping checksum refresh after this edit

- [ ] 3.3 Sync hub `scripts/bootstrap-sdd.sh` to the English template content (including HYBRID detect/warn), then refresh kit checksums
  - **Pattern:** `scripts/bootstrap-sdd.sh`
  - **Invariants:** `sdd-docs-language` — Specs wave-2 sdd-install-kit residual PT is English
  - **Gate:** `cmp -s scripts/bootstrap-sdd.sh sdd-kit/templates/scripts/bootstrap-sdd.sh && bash sdd-kit/gen-manifest-checksums.sh && bash sdd-kit/verify.sh`
  - **Forbidden:** divergent hub vs template after apply; committing template edit without MANIFEST checksum update

## 4. Wave gates

- [ ] 4.1 Run per-wave i18n verification on the G-PT file list (spec + both bootstraps)
  - **Pattern:** `scripts/verify-i18n-wave.sh`
  - **Invariants:** `sdd-docs-language` — Per-wave and global verification script; Specs wave-2 sdd-install-kit residual PT is English
  - **Gate:** `bash scripts/verify-i18n-wave.sh --files openspec/specs/sdd-install-kit/spec.md,sdd-kit/templates/scripts/bootstrap-sdd.sh,scripts/bootstrap-sdd.sh`
  - **Forbidden:** marking tasks done if G-PT/G-INV/G-LINK/G-MANIFEST/G-OPENSPEC fail; running `--dod` as a required gate; editing wave-1 owned specs

- [ ] 4.2 Validate OpenSpec change + task Pattern paths
  - **Pattern:** `scripts/verify-task-patterns.sh`
  - **Gate:** `bash scripts/verify-task-patterns.sh && OPENSPEC_TELEMETRY=0 npx --yes @fission-ai/openspec@1.3.1 validate translate-specs-wave-2 --strict`

## 5. Post-register (best-effort)

- [ ] 5.1 `graphify update .` if available (docs/scripts touched); otherwise SKIP per infra
  - **Pattern:** `.cursor/rules/graphify.mdc`
  - **Gate:** `test -f graphify-out/GRAPH_REPORT.md || echo 'SKIP (graphify unavailable)'`
  - **Note:** SKIP if graphify CLI unavailable

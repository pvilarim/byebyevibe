# Tasks — translate-specs-wave-2

> Apply after human approval (R7). **In-place PT→EN only** on `openspec/specs/sdd-install-kit/spec.md` plus lockstep EN migration of the UPGRADE_REPORT approval marker in `sdd-kit/upgrade.sh`. **Issue:** —

## 1. Prep (glossary + freeze)

- [ ] 1.1 Confirm glossary covers terms needed for this wave (`install kit`, `gate`, `fail-closed`, `wave`, Session Handoff); append rows to `doc/i18n/GLOSSARY.md` only if a new SDD term is introduced (same PR)
  - **Pattern:** `doc/i18n/GLOSSARY.md`
  - **Invariants:** `sdd-docs-language` — Glossary and wave inventory exist
  - **Gate:** `test -s doc/i18n/GLOSSARY.md && grep -qE 'install kit|fail-closed|Session Handoff|gate|wave|glossary' doc/i18n/GLOSSARY.md`
  - **Forbidden:** invent synonym variants for glossary terms; dual-file `*.en.md` / `*-pt.md`; editing wave-1 owned specs in this prep task

## 2. Substitute install-kit spec + approval marker contract (in-place)

- [ ] 2.1 Rewrite `openspec/specs/sdd-install-kit/spec.md` residual Portuguese prose (requirement titles/bodies/scenarios still in PT, including bootstrap HYBRID warning, COPY dry-run label prose, and European spellings such as `ficheiros`) → glossary-canonical English; keep MANIFEST keys, `merge:` values, flags, profile names, OpenSpec `MUST`/`WHEN`/`THEN`, and paths intact; quote the **English** approval marker that will match `upgrade.sh` after task 2.2 (prefer `[x] Update approved`)
  - **Pattern:** `openspec/specs/sdd-install-kit/spec.md`
  - **Invariants:** `sdd-docs-language` — Specs wave-2 sdd-install-kit capability spec is English; Freeze list of non-translatable tokens
  - **Gate:** `test -f openspec/specs/sdd-install-kit/spec.md && ! test -f openspec/specs/sdd-install-kit/spec.en.md && ! test -f openspec/specs/sdd-install-kit/spec-pt.md && grep -qF 'sdd-kit/upgrade.sh' openspec/specs/sdd-install-kit/spec.md && grep -qF '\[x\] Update approved' openspec/specs/sdd-install-kit/spec.md && ! grep -qiE 'Actualização aprovada|classificar ficheiros|emite aviso|por defeito|o operador executa|mostra rótulo|ficheiros classificados' openspec/specs/sdd-install-kit/spec.md`
  - **Forbidden:** dual-file siblings; changing install/upgrade semantics beyond marker language; drive-by edits to wave-1 specs; leaving residual Portuguese prose; disagreeing with the marker string in `upgrade.sh`

- [ ] 2.2 Migrate `sdd-kit/upgrade.sh` UPGRADE_REPORT approval contract to the same English marker as task 2.1: scaffold checkbox text, `grep` needle, and operator hint; translate only nearby Portuguese comments/strings required for G-PT on this file; do **not** edit `sdd-kit/templates/` or `MANIFEST.yaml`
  - **Pattern:** `sdd-kit/upgrade.sh`
  - **Invariants:** `sdd-docs-language` — Specs wave-2 sdd-install-kit capability spec is English
  - **Gate:** `test -f sdd-kit/upgrade.sh && grep -qF '[x] Update approved' sdd-kit/upgrade.sh && ! grep -qiE 'Actualização aprovada|Relatório de actualização' sdd-kit/upgrade.sh && grep -qF '[x] Update approved' openspec/specs/sdd-install-kit/spec.md`
  - **Forbidden:** editing kit templates / MANIFEST checksums; changing dry-run/apply control flow beyond the approval-marker string; leaving PT deny-list tokens in `upgrade.sh`; marker mismatch vs the capability spec

## 3. Wave gates

- [ ] 3.1 Run per-wave i18n verification on the exact wave-2 file list
  - **Pattern:** `scripts/verify-i18n-wave.sh`
  - **Invariants:** `sdd-docs-language` — Per-wave and global verification script; Specs wave-2 sdd-install-kit capability spec is English
  - **Gate:** `bash scripts/verify-i18n-wave.sh --files openspec/specs/sdd-install-kit/spec.md,sdd-kit/upgrade.sh`
  - **Forbidden:** marking tasks done if G-PT/G-INV/G-LINK/G-OPENSPEC fail; running `--dod` as a required gate for this wave; touching `sdd-kit/templates/` in this apply

- [ ] 3.2 Validate OpenSpec change + task Pattern paths
  - **Pattern:** `scripts/verify-task-patterns.sh`
  - **Gate:** `bash scripts/verify-task-patterns.sh && OPENSPEC_TELEMETRY=0 npx --yes @fission-ai/openspec@1.3.1 validate translate-specs-wave-2 --strict`

## 4. Post-register (best-effort)

- [ ] 4.1 `graphify update .` if available (docs touched); otherwise SKIP per infra
  - **Pattern:** `.cursor/rules/graphify.mdc`
  - **Gate:** `test -f graphify-out/GRAPH_REPORT.md || echo 'SKIP (graphify unavailable)'`
  - **Note:** SKIP if graphify CLI unavailable

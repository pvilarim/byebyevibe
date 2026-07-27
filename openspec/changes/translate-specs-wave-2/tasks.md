# Tasks — translate-specs-wave-2

> Apply after human approval (R7). **In-place PT→EN** on the install-kit spec plus coordinated EN contract strings in `upgrade.sh` / kit `bootstrap-sdd.sh`. **Issue:** —

## 1. Prep (glossary + freeze)

- [ ] 1.1 Confirm glossary covers terms needed for this wave (`install kit`, `gate`, `fail-closed`, wave, canonical); append rows to `doc/i18n/GLOSSARY.md` only if a new SDD term is introduced (same PR)
  - **Pattern:** `doc/i18n/GLOSSARY.md`
  - **Invariants:** `sdd-docs-language` — Glossary and wave inventory exist
  - **Gate:** `test -s doc/i18n/GLOSSARY.md && grep -qE 'install kit|fail-closed|Session Handoff|gate|wave|glossary|canonical' doc/i18n/GLOSSARY.md`
  - **Forbidden:** invent synonym variants for glossary terms; dual-file `*.en.md` / `*-pt.md`; editing wave-1 spec paths (`sdd-ci-gates` / `sdd-post-install-verification` / `sdd-session-coordination`) in this prep task

## 2. Substitute install-kit spec + contract strings (in-place)

- [ ] 2.1 Rewrite `openspec/specs/sdd-install-kit/spec.md` Portuguese / mixed prose (requirement titles such as bootstrap HYBRID warn / COPY label / upgrade header; requirement bodies; scenario WHEN/THEN still in PT) → glossary-canonical English; keep paths, MANIFEST keys, profile labels, sha256 integrity semantics, dry-run/apply mutual exclusion, MERGE vs COPY, and path-traversal MUST semantics intact; reference the **new EN** approval needle and HYBRID WARN (see 2.2–2.3) instead of PT literals
  - **Pattern:** `openspec/specs/sdd-install-kit/spec.md`
  - **Invariants:** `sdd-docs-language` — Specs wave-2 sdd-install-kit surface is English; Freeze list of non-translatable tokens
  - **Gate:** `test -f openspec/specs/sdd-install-kit/spec.md && ! test -f openspec/specs/sdd-install-kit/spec.en.md && ! test -f openspec/specs/sdd-install-kit/spec-pt.md && grep -qF 'sdd-kit/upgrade.sh' openspec/specs/sdd-install-kit/spec.md && grep -qF 'sha256:' openspec/specs/sdd-install-kit/spec.md && grep -qF 'Upgrade approved' openspec/specs/sdd-install-kit/spec.md && grep -qF 'WARN: package.json and openspec/ coexist — profile may be HYBRID.' openspec/specs/sdd-install-kit/spec.md && ! grep -qiE 'classificar ficheiros|emite aviso|coexistem|rótulo|Actualização aprovada|Não deve terminar|ficheiros classificados' openspec/specs/sdd-install-kit/spec.md`
  - **Forbidden:** dual-file siblings; changing integrity / MERGE / path-traversal semantics; drive-by edits to other specs; leaving residual Portuguese prose (except none — PT contract strings must be gone from this file)

- [ ] 2.2 Update `sdd-kit/upgrade.sh` UPGRADE_REPORT scaffold checkbox and `--apply` approval `grep` to the English needle `Upgrade approved` (scaffold: `- [ ] Upgrade approved by the user`; grep pattern: `\[x\] Upgrade approved`); keep MERGE/COPY apply behavior and integrity checks unchanged
  - **Pattern:** `sdd-kit/upgrade.sh`
  - **Invariants:** `sdd-docs-language` — Specs wave-2 sdd-install-kit surface is English
  - **Gate:** `grep -qF 'Upgrade approved by the user' sdd-kit/upgrade.sh && grep -qF '\[x\] Upgrade approved' sdd-kit/upgrade.sh && ! grep -qF 'Actualização aprovada' sdd-kit/upgrade.sh && grep -qF 'Applying COPY files only' sdd-kit/upgrade.sh`
  - **Forbidden:** changing COPY-only apply policy; removing integrity checks; translating unrelated script noise beyond the approval checkbox / grep / user-facing approval error lines that mention the old PT marker

- [ ] 2.3 Update `sdd-kit/templates/scripts/bootstrap-sdd.sh` HYBRID coexistence WARN (+ follow-on confirmation lines) to English; keep default-to-APP when `package.json` and `openspec/` coexist; do **not** edit hub `scripts/bootstrap-sdd.sh` in this wave
  - **Pattern:** `sdd-kit/templates/scripts/bootstrap-sdd.sh`
  - **Invariants:** `sdd-docs-language` — Specs wave-2 sdd-install-kit surface is English
  - **Gate:** `grep -qF 'WARN: package.json and openspec/ coexist — profile may be HYBRID.' sdd-kit/templates/scripts/bootstrap-sdd.sh && ! grep -qiE 'coexistem|por defeito|Confirmar: relançar|A continuar com' sdd-kit/templates/scripts/bootstrap-sdd.sh && grep -qF 'PROFILE="APP"' sdd-kit/templates/scripts/bootstrap-sdd.sh`
  - **Forbidden:** editing hub `scripts/bootstrap-sdd.sh`; changing profile selection matrix beyond language of WARN lines; dual-file siblings

- [ ] 2.4 Regenerate kit MANIFEST checksums after the bootstrap template edit
  - **Pattern:** `sdd-kit/gen-manifest-checksums.sh`
  - **Invariants:** `sdd-docs-language` — Specs wave-2 sdd-install-kit surface is English
  - **Gate:** `bash sdd-kit/gen-manifest-checksums.sh && bash sdd-kit/verify.sh`
  - **Forbidden:** hand-editing `sha256:` fields; skipping verify after regen

## 3. Wave gates

- [ ] 3.1 Run per-wave i18n verification on the exact file list
  - **Pattern:** `scripts/verify-i18n-wave.sh`
  - **Invariants:** `sdd-docs-language` — Per-wave and global verification script; Specs wave-2 sdd-install-kit surface is English
  - **Gate:** `bash scripts/verify-i18n-wave.sh --files openspec/specs/sdd-install-kit/spec.md,sdd-kit/upgrade.sh,sdd-kit/templates/scripts/bootstrap-sdd.sh`
  - **Forbidden:** marking tasks done if G-PT/G-INV/G-LINK/G-MANIFEST/G-OPENSPEC fail; running `--dod` as a required gate for this wave; touching wave-1 spec paths or kit `templates/doc/design/` in this apply

- [ ] 3.2 Validate OpenSpec change + task Pattern paths
  - **Pattern:** `scripts/verify-task-patterns.sh`
  - **Gate:** `bash scripts/verify-task-patterns.sh && OPENSPEC_TELEMETRY=0 npx --yes @fission-ai/openspec@1.3.1 validate translate-specs-wave-2 --strict`

## 4. Post-register (best-effort)

- [ ] 4.1 `graphify update .` if available (docs touched); otherwise SKIP per infra
  - **Pattern:** `.cursor/rules/graphify.mdc`
  - **Gate:** `test -f graphify-out/GRAPH_REPORT.md || echo 'SKIP (graphify unavailable)'`
  - **Note:** SKIP if graphify CLI unavailable

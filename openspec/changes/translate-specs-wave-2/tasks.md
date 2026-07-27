# Tasks — translate-specs-wave-2

> Apply after human approval (R7). **In-place PT→EN only** on `openspec/specs/sdd-install-kit/spec.md`. **Issue:** —

## 1. Prep (glossary + freeze)

- [ ] 1.1 Confirm glossary covers terms needed for this wave (`gate`, `fail-closed`, install kit / sdd-kit, wave, canonical); append rows to `doc/i18n/GLOSSARY.md` only if a new SDD term is introduced (same PR)
  - **Pattern:** `doc/i18n/GLOSSARY.md`
  - **Invariants:** `sdd-docs-language` — Glossary and wave inventory exist
  - **Gate:** `test -s doc/i18n/GLOSSARY.md && grep -qE 'fail-closed|sdd-kit|install kit|wave|glossary|canonical|gate' doc/i18n/GLOSSARY.md`
  - **Forbidden:** invent synonym variants for glossary terms; dual-file `*.en.md` / `*-pt.md`; editing wave-1 capability specs in this prep task

## 2. Substitute sdd-install-kit (in-place)

- [ ] 2.1 Rewrite `openspec/specs/sdd-install-kit/spec.md` residual Portuguese prose (upgrade/bootstrap requirement titles and bodies still in PT; scenario titles/WHEN/THEN still in PT) → glossary-canonical English; keep paths `sdd-kit/`, `scripts/bootstrap-sdd.sh`, `scripts/sdd-upgrade-diff.sh`, `UPGRADE_REPORT.md`, MANIFEST keys `merge: COPY` / `merge: MERGE`, flags `--dry-run` / `--apply` / `--from` / `--to`, OpenSpec `MUST`/`WHEN`/`THEN`, and the runtime approval marker `[x] Actualização aprovada` intact
  - **Pattern:** `openspec/specs/sdd-install-kit/spec.md`
  - **Invariants:** `sdd-docs-language` — Specs wave-2 sdd-install-kit residual PT is English; Freeze list of non-translatable tokens
  - **Gate:** `test -f openspec/specs/sdd-install-kit/spec.md && ! test -f openspec/specs/sdd-install-kit/spec.en.md && ! test -f openspec/specs/sdd-install-kit/spec-pt.md && grep -qF 'sdd-kit/upgrade.sh' openspec/specs/sdd-install-kit/spec.md && grep -qF '[x] Actualização aprovada' openspec/specs/sdd-install-kit/spec.md && grep -qF 'merge: COPY' openspec/specs/sdd-install-kit/spec.md && grep -qF 'bootstrap-sdd.sh' openspec/specs/sdd-install-kit/spec.md && ! grep -qiE 'O MANIFEST MUST classificar|pedindo confirmação|por defeito|Não deve terminar|mostra rótulo|ficheiros classificados|coexistem, `bootstrap' openspec/specs/sdd-install-kit/spec.md`
  - **Forbidden:** dual-file siblings; changing integrity/upgrade/bootstrap semantics; rewriting `upgrade.sh` or guide UPGRADE_REPORT scaffold; drive-by edits to wave-1 specs; leaving residual Portuguese prose outside the freeze approval marker

- [ ] 2.2 If G-PT still fails solely because of the freeze marker `Actualização aprovada`, add a **narrow** documented exemption in `scripts/verify-i18n-wave.sh` for that exact phrase only (comment cites `sdd-kit/upgrade.sh` contract); otherwise SKIP this task
  - **Pattern:** `scripts/verify-i18n-wave.sh`
  - **Invariants:** `sdd-docs-language` — Specs wave-2 sdd-install-kit residual PT is English
  - **Gate:** `test -f scripts/verify-i18n-wave.sh && (grep -qF 'Actualização aprovada' scripts/verify-i18n-wave.sh || echo 'SKIP (no exemption needed)')`
  - **Forbidden:** broad Portuguese allowlists; disabling G-PT; changing `PT_DENY_REGEX` to drop unrelated tokens; editing `sdd-kit/upgrade.sh` in this task

## 3. Verify wave gates

- [ ] 3.1 Run per-wave i18n verification on the exact file list (include verify script if task 2.2 edited it)
  - **Pattern:** `scripts/verify-i18n-wave.sh`
  - **Invariants:** `sdd-docs-language` — Per-wave and global verification script; Specs wave-2 sdd-install-kit residual PT is English
  - **Gate:** `bash scripts/verify-i18n-wave.sh --files openspec/specs/sdd-install-kit/spec.md`
  - **Forbidden:** marking tasks done if G-PT/G-INV/G-LINK/G-OPENSPEC fail; running `--dod` as a required gate for this wave; touching `sdd-kit/templates/` in this apply

- [ ] 3.2 Validate OpenSpec change + task Pattern paths
  - **Pattern:** `scripts/verify-task-patterns.sh`
  - **Gate:** `bash scripts/verify-task-patterns.sh && OPENSPEC_TELEMETRY=0 npx --yes @fission-ai/openspec@1.3.1 validate translate-specs-wave-2 --strict`

## 4. Post-register (best-effort)

- [ ] 4.1 `graphify update .` if available (docs touched); otherwise SKIP per infra
  - **Pattern:** `.cursor/rules/graphify.mdc`
  - **Gate:** `test -f graphify-out/GRAPH_REPORT.md || echo 'SKIP (graphify unavailable)'`
  - **Note:** SKIP if graphify CLI unavailable

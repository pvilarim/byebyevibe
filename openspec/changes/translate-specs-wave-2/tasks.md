# Tasks — translate-specs-wave-2

> Apply after human approval (R7). **In-place PT→EN only** on `openspec/specs/sdd-install-kit/spec.md`. **Issue:** —

## 1. Prep (glossary + freeze)

- [ ] 1.1 Confirm glossary covers terms needed for this wave (`install kit`, `gate`, `fail-closed`, wave, canonical); append rows to `doc/i18n/GLOSSARY.md` only if a new SDD term is introduced (same PR)
  - **Pattern:** `doc/i18n/GLOSSARY.md`
  - **Invariants:** `sdd-docs-language` — Glossary and wave inventory exist
  - **Gate:** `test -s doc/i18n/GLOSSARY.md && grep -qE 'install kit|fail-closed|gate|wave|glossary|canonical|sdd-kit' doc/i18n/GLOSSARY.md`
  - **Forbidden:** invent synonym variants for glossary terms; dual-file `*.en.md` / `*-pt.md`; editing other capability specs; changing `sdd-kit/upgrade.sh` approval checkbox text in this prep task

## 2. Substitute install-kit capability spec (in-place)

- [ ] 2.1 Rewrite `openspec/specs/sdd-install-kit/spec.md` residual Portuguese prose (mixed MERGE sentence under Deterministic SDD upgrade; bootstrap HYBRID warning requirement + scenarios; dry-run COPY label requirement + scenario; upgrade header dry-run/apply requirement + scenarios; any other residual PT titles/bodies) → glossary-canonical English; keep paths/scripts/`MANIFEST` keys/`COPY`/`MERGE`/`APPLY_TEMPLATE` negation, profile names, ByeByeVibe dual-naming, OpenSpec `MUST`/`WHEN`/`THEN`, and the runtime approval substring `[x] Actualização aprovada` (quoted where the gate is specified) byte-stable
  - **Pattern:** `openspec/specs/sdd-install-kit/spec.md`
  - **Invariants:** `sdd-docs-language` — Specs wave-2 install-kit capability spec is English; Freeze list of non-translatable tokens
  - **Gate:** `test -f openspec/specs/sdd-install-kit/spec.md && ! test -f openspec/specs/sdd-install-kit/spec.en.md && ! test -f openspec/specs/sdd-install-kit/spec-pt.md && grep -qF 'sdd-kit/install.sh' openspec/specs/sdd-install-kit/spec.md && grep -qF 'merge: COPY' openspec/specs/sdd-install-kit/spec.md && grep -qF '[x] Actualização aprovada' openspec/specs/sdd-install-kit/spec.md && grep -qiE 'bootstrap|HYBRID|dry-run|integrity' openspec/specs/sdd-install-kit/spec.md && ! grep -qiE 'emite aviso em repo|classificar ficheiros|rótulo COPY|Não deve terminar|coexistem — perfil|mostra rótulo|header distingue modo' openspec/specs/sdd-install-kit/spec.md`
  - **Forbidden:** dual-file siblings; translating away `[x] Actualização aprovada`; changing integrity/MERGE/dry-run semantics; drive-by edits to other specs or to `sdd-kit/upgrade.sh`; leaving residual Portuguese prose outside the frozen approval substring

## 3. Wave gates

- [ ] 3.1 Run per-wave i18n verification on the exact install-kit spec path
  - **Pattern:** `scripts/verify-i18n-wave.sh`
  - **Invariants:** `sdd-docs-language` — Per-wave and global verification script; Specs wave-2 install-kit capability spec is English
  - **Gate:** `bash scripts/verify-i18n-wave.sh --files openspec/specs/sdd-install-kit/spec.md`
  - **Forbidden:** marking tasks done if G-PT/G-INV/G-LINK/G-OPENSPEC fail for reasons other than the documented frozen approval substring allowlist; running `--dod` as a required gate for this wave; touching `sdd-kit/templates/` in this apply
  - **Note:** If G-PT fails solely on the frozen `[x] Actualização aprovada` substring, keep that substring (do not translate it); confirm proposal allowlist; only then re-check whether the gate script needs an explicit allowlist exception in a **separate** non-this-wave change — do not weaken install-kit semantics here

- [ ] 3.2 Validate OpenSpec change + task Pattern paths
  - **Pattern:** `scripts/verify-task-patterns.sh`
  - **Gate:** `bash scripts/verify-task-patterns.sh && OPENSPEC_TELEMETRY=0 npx --yes @fission-ai/openspec@1.3.1 validate translate-specs-wave-2 --strict`

## 4. Post-register (best-effort)

- [ ] 4.1 `graphify update .` if available (docs touched); otherwise SKIP per infra
  - **Pattern:** `.cursor/rules/graphify.mdc`
  - **Gate:** `test -f graphify-out/GRAPH_REPORT.md || echo 'SKIP (graphify unavailable)'`
  - **Note:** SKIP if graphify CLI unavailable

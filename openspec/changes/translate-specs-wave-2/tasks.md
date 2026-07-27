# Tasks — translate-specs-wave-2

> Apply after human approval (R7). **In-place PT→EN only** on `openspec/specs/sdd-install-kit/spec.md`. **Issue:** —

## 1. Prep (glossary + freeze)

- [ ] 1.1 Confirm glossary covers terms needed for this wave (`install kit`, `fail-closed`, `gate`, wave, canonical); append rows to `doc/i18n/GLOSSARY.md` only if a new SDD term is introduced (same PR)
  - **Pattern:** `doc/i18n/GLOSSARY.md`
  - **Invariants:** `sdd-docs-language` — Glossary and wave inventory exist
  - **Gate:** `test -s doc/i18n/GLOSSARY.md && grep -qE 'install kit|fail-closed|gate|wave|glossary|canonical' doc/i18n/GLOSSARY.md`
  - **Forbidden:** invent synonym variants for glossary terms; dual-file `*.en.md` / `*-pt.md`; editing specs owned by `translate-specs-wave-1` in this prep task

## 2. Substitute install-kit capability spec (in-place)

- [ ] 2.1 Rewrite `openspec/specs/sdd-install-kit/spec.md` residual Portuguese prose (mixed PT requirement bodies and scenarios: MANIFEST upgrade-tool classification; bootstrap profile warning; dry-run `COPY` label scenarios; any PT scenario titles; Portuguese UPGRADE_REPORT approval wording) → glossary-canonical English; keep paths under `sdd-kit/`, MANIFEST keys (`sha256:`, `merge:`, `gate:`), CLI flags, profile names, ByeByeVibe brand, OpenSpec `MUST`/`WHEN`/`THEN`, and normative install/upgrade/verify semantics intact; if the live script still expects a historical Portuguese approval checkbox string, freeze that quoted token under allowlist rather than changing script behavior in this wave
  - **Pattern:** `openspec/specs/sdd-install-kit/spec.md`
  - **Invariants:** `sdd-docs-language` — Specs wave-2 install-kit capability spec is English; Freeze list of non-translatable tokens
  - **Gate:** `test -f openspec/specs/sdd-install-kit/spec.md && ! test -f openspec/specs/sdd-install-kit/spec.en.md && ! test -f openspec/specs/sdd-install-kit/spec-pt.md && grep -qF 'sdd-kit/MANIFEST.yaml' openspec/specs/sdd-install-kit/spec.md && grep -qF 'sha256:' openspec/specs/sdd-install-kit/spec.md && grep -qF 'upgrade.sh' openspec/specs/sdd-install-kit/spec.md && grep -qF 'bootstrap-sdd.sh' openspec/specs/sdd-install-kit/spec.md && grep -qF 'ByeByeVibe' openspec/specs/sdd-install-kit/spec.md && ! grep -qiE 'O MANIFEST MUST|classificar ficheiros|Quando \`package\.json\`|Não deve terminar|A saída de \`upgrade\.sh\`|para ficheiros com|mostra rótulo|fichei?ros classificados|Actualização aprovada' openspec/specs/sdd-install-kit/spec.md`
  - **Forbidden:** dual-file siblings; changing integrity/dry-run/apply/bootstrap semantics; drive-by edits to wave-1 specs or kit templates; leaving residual Portuguese prose; evaluating `gate:` via `eval`

## 3. Wave gates

- [ ] 3.1 Run per-wave i18n verification on the exact install-kit spec path
  - **Pattern:** `scripts/verify-i18n-wave.sh`
  - **Invariants:** `sdd-docs-language` — Per-wave and global verification script; Specs wave-2 install-kit capability spec is English
  - **Gate:** `bash scripts/verify-i18n-wave.sh --files openspec/specs/sdd-install-kit/spec.md`
  - **Forbidden:** marking tasks done if G-PT/G-INV/G-LINK/G-OPENSPEC fail; running `--dod` as a required gate for this wave

- [ ] 3.2 Validate OpenSpec change + task Pattern paths
  - **Pattern:** `scripts/verify-task-patterns.sh`
  - **Gate:** `bash scripts/verify-task-patterns.sh && OPENSPEC_TELEMETRY=0 npx --yes @fission-ai/openspec@1.3.1 validate translate-specs-wave-2 --strict`

## 4. Post-register (best-effort)

- [ ] 4.1 `graphify update .` if available (docs touched); otherwise SKIP per infra
  - **Pattern:** `.cursor/rules/graphify.mdc`
  - **Gate:** `test -f graphify-out/GRAPH_REPORT.md || echo 'SKIP (graphify unavailable)'`
  - **Note:** SKIP if graphify CLI unavailable

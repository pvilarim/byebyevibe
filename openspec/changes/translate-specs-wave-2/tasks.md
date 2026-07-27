# Tasks — translate-specs-wave-2

> Apply after human approval (R7). **In-place PT→EN only** on `openspec/specs/sdd-install-kit/spec.md`. **Issue:** —

## 1. Prep (glossary + freeze)

- [ ] 1.1 Confirm glossary covers terms needed for this wave (`install kit` / `sdd-kit`, `gate`, `fail-closed`, wave, canonical); append rows to `doc/i18n/GLOSSARY.md` only if a new SDD term is introduced (same PR)
  - **Pattern:** `doc/i18n/GLOSSARY.md`
  - **Invariants:** `sdd-docs-language` — Glossary and wave inventory exist
  - **Gate:** `test -s doc/i18n/GLOSSARY.md && grep -qE 'install kit|sdd-kit|fail-closed|gate|wave|glossary|canonical' doc/i18n/GLOSSARY.md`
  - **Forbidden:** invent synonym variants for glossary terms; dual-file `*.en.md` / `*-pt.md`; editing the three specs owned by `translate-specs-wave-1` in this prep task

## 2. Substitute install-kit capability spec (in-place)

- [ ] 2.1 Before rewriting the UPGRADE_REPORT approval marker, locate the live checkbox/string contract in `sdd-kit/upgrade.sh` (or documented consumer template). If the script still requires `[x] Actualização aprovada`, keep that marker byte-stable in the spec (allowlist as contractual/quoted) and translate surrounding prose only; if the script already matches an English marker (or has no hard-coded PT string), use glossary-canonical English checkbox text consistently in the spec
  - **Pattern:** `sdd-kit/upgrade.sh`
  - **Invariants:** `sdd-docs-language` — Freeze list of non-translatable tokens; Specs wave-2 residual-PT install-kit capability spec is English
  - **Gate:** `test -f sdd-kit/upgrade.sh && (grep -qF 'Actualização aprovada' sdd-kit/upgrade.sh || grep -qiE 'Upgrade approved|UPGRADE_REPORT|approved' sdd-kit/upgrade.sh)`
  - **Forbidden:** changing `upgrade.sh` behavior in this language wave unless a separate approved change owns the script; leaving the apply session without recording which marker was kept

- [ ] 2.2 Rewrite `openspec/specs/sdd-install-kit/spec.md` residual Portuguese prose (mixed MANIFEST/`merge: MERGE` sentence; bootstrap HYBRID warning requirement + scenarios; upgrade dry-run COPY label + header requirements/scenarios; any remaining PT fragments) → glossary-canonical English; keep paths `sdd-kit/`, `MANIFEST.yaml`, `install.sh`, `upgrade.sh`, `verify.sh`, `scripts/bootstrap-sdd.sh`, `scripts/sdd-upgrade-diff.sh`, `scripts/sdd-metrics.sh`, MANIFEST keys `sha256:` / `merge:` / `gate:`, profile names, ByeByeVibe, and OpenSpec `MUST`/`WHEN`/`THEN` keywords intact
  - **Pattern:** `openspec/specs/sdd-install-kit/spec.md`
  - **Invariants:** `sdd-docs-language` — Specs wave-2 residual-PT install-kit capability spec is English; Freeze list of non-translatable tokens
  - **Gate:** `test -f openspec/specs/sdd-install-kit/spec.md && ! test -f openspec/specs/sdd-install-kit/spec.en.md && ! test -f openspec/specs/sdd-install-kit/spec-pt.md && grep -qF 'sdd-kit/install.sh' openspec/specs/sdd-install-kit/spec.md && grep -qF 'sha256:' openspec/specs/sdd-install-kit/spec.md && grep -qF 'ByeByeVibe' openspec/specs/sdd-install-kit/spec.md && grep -qiE 'fail-closed|integrity|dry-run|HYBRID|MERGE|COPY' openspec/specs/sdd-install-kit/spec.md && ! grep -qiE 'Quando \`package\.json\`|emitir um aviso|Não deve terminar|para ficheiros com|mostra rótulo|o operador corre|após aprovar o relatório|O MANIFEST MUST classificar ficheiros' openspec/specs/sdd-install-kit/spec.md`
  - **Forbidden:** dual-file siblings; changing integrity/dry-run/MERGE semantics; drive-by edits to wave-1 specs or kit templates; leaving residual Portuguese prose that fails G-PT

## 3. Wave gates

- [ ] 3.1 Run per-wave i18n verification on the exact install-kit spec path
  - **Pattern:** `scripts/verify-i18n-wave.sh`
  - **Invariants:** `sdd-docs-language` — Per-wave and global verification script; Specs wave-2 residual-PT install-kit capability spec is English
  - **Gate:** `bash scripts/verify-i18n-wave.sh --files openspec/specs/sdd-install-kit/spec.md`
  - **Forbidden:** marking tasks done if G-PT/G-INV/G-LINK/G-OPENSPEC fail; running `--dod` as a required gate for this wave; touching `sdd-kit/templates/` or wave-1 spec paths in this apply

- [ ] 3.2 Validate OpenSpec change + task Pattern paths
  - **Pattern:** `scripts/verify-task-patterns.sh`
  - **Gate:** `bash scripts/verify-task-patterns.sh && OPENSPEC_TELEMETRY=0 npx --yes @fission-ai/openspec@1.3.1 validate translate-specs-wave-2 --strict`

## 4. Post-register (best-effort)

- [ ] 4.1 `graphify update .` if available (docs touched); otherwise SKIP per infra
  - **Pattern:** `.cursor/rules/graphify.mdc`
  - **Gate:** `test -f graphify-out/GRAPH_REPORT.md || echo 'SKIP (graphify unavailable)'`
  - **Note:** SKIP if graphify CLI unavailable

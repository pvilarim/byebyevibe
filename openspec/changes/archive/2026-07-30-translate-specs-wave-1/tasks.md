# Tasks — translate-specs-wave-1

> Apply after human approval (R7). **In-place PT→EN only** on the three listed capability specs. **Issue:** —

## 1. Prep (glossary + freeze)

- [x] 1.1 Confirm glossary covers terms needed for this wave (`gate`, `Session Handoff`, `fail-closed`, `worktree`, wave, canonical); append rows to `doc/i18n/GLOSSARY.md` only if a new SDD term is introduced (same PR)
  - **Pattern:** `doc/i18n/GLOSSARY.md`
  - **Invariants:** `sdd-docs-language` — Glossary and wave inventory exist
  - **Gate:** `test -s doc/i18n/GLOSSARY.md && grep -qE 'fail-closed|Session Handoff|worktree|gate|wave|glossary|canonical' doc/i18n/GLOSSARY.md`
  - **Forbidden:** invent synonym variants for glossary terms; dual-file `*.en.md` / `*-pt.md`; editing `openspec/specs/sdd-install-kit/spec.md` in this prep task

## 2. Substitute capability specs (in-place)

- [x] 2.1 Rewrite `openspec/specs/sdd-ci-gates/spec.md` residual Portuguese prose (report-only `sdd-kit verify` requirement body and scenarios still in PT) → glossary-canonical English; keep workflow path `.github/workflows/sdd-gates.yml`, `continue-on-error: true` semantics, `openspec validate` / `verify-task-patterns.sh` / OSV fail-closed contracts, Action pin names, and OpenSpec `MUST`/`WHEN`/`THEN` keywords intact
  - **Pattern:** `openspec/specs/sdd-ci-gates/spec.md`
  - **Invariants:** `sdd-docs-language` — Specs wave-1 residual-PT capability specs are English; Freeze list of non-translatable tokens
  - **Gate:** `test -f openspec/specs/sdd-ci-gates/spec.md && ! test -f openspec/specs/sdd-ci-gates/spec.en.md && ! test -f openspec/specs/sdd-ci-gates/spec-pt.md && grep -qF '.github/workflows/sdd-gates.yml' openspec/specs/sdd-ci-gates/spec.md && grep -qF 'continue-on-error: true' openspec/specs/sdd-ci-gates/spec.md && grep -qiE 'fail-closed|report-only' openspec/specs/sdd-ci-gates/spec.md && ! grep -qiE 'não estão|o step |corre num runner|não é afectado|falha com saída' openspec/specs/sdd-ci-gates/spec.md`
  - **Forbidden:** dual-file siblings; changing fail-closed vs report-only semantics; drive-by edits to `sdd-install-kit` or other specs; leaving residual Portuguese prose

- [x] 2.2 Rewrite `openspec/specs/sdd-post-install-verification/spec.md` Portuguese prose (Purpose/requirements/scenarios still in PT) → glossary-canonical English; keep paths `openspec/project.md`, `AGENTS.md`, `CLAUDE.md`, `graphify-out/GRAPH_REPORT.md`, `openspec/infra.md`, `.cursor/rules/*.mdc`, profile names APP/DOCS_SPECS/HYBRID, and checklist MUST semantics intact
  - **Pattern:** `openspec/specs/sdd-post-install-verification/spec.md`
  - **Invariants:** `sdd-docs-language` — Specs wave-1 residual-PT capability specs are English
  - **Gate:** `test -f openspec/specs/sdd-post-install-verification/spec.md && ! test -f openspec/specs/sdd-post-install-verification/spec.en.md && ! test -f openspec/specs/sdd-post-install-verification/spec-pt.md && grep -qF 'openspec/project.md' openspec/specs/sdd-post-install-verification/spec.md && grep -qF 'AGENTS.md' openspec/specs/sdd-post-install-verification/spec.md && grep -qF 'openspec/infra.md' openspec/specs/sdd-post-install-verification/spec.md && ! grep -qiE 'O repositório MUST|a verificação pós|ficheiros auxiliares|redireciona comportamento|secção Session|conforme §' openspec/specs/sdd-post-install-verification/spec.md`
  - **Forbidden:** dual-file siblings; weakening post-install MUST checks; editing unrelated specs; leaving residual Portuguese prose

- [x] 2.3 Rewrite `openspec/specs/sdd-session-coordination/spec.md` Portuguese Purpose (and any residual PT) → glossary-canonical English; keep script names `sdd-session-register.sh` / `sdd-session-check.sh` / `sdd-session-status.sh` / `sdd-session-release.sh`, lock path `.sdd/runtime/apply.lock`, session JSON fields, and per-worktree exclusivity semantics intact
  - **Pattern:** `openspec/specs/sdd-session-coordination/spec.md`
  - **Invariants:** `sdd-docs-language` — Specs wave-1 residual-PT capability specs are English
  - **Gate:** `test -f openspec/specs/sdd-session-coordination/spec.md && ! test -f openspec/specs/sdd-session-coordination/spec.en.md && ! test -f openspec/specs/sdd-session-coordination/spec-pt.md && grep -qF 'sdd-session-check.sh' openspec/specs/sdd-session-coordination/spec.md && grep -qF '.sdd/runtime/apply.lock' openspec/specs/sdd-session-coordination/spec.md && grep -qiE 'worktree|apply lock|Session' openspec/specs/sdd-session-coordination/spec.md && ! grep -qiE 'Coordenação operacional|evitando apply concorrente|mesma máquina|Complementa' openspec/specs/sdd-session-coordination/spec.md`
  - **Forbidden:** dual-file siblings; changing lock/registry semantics; drive-by edits to other specs; leaving residual Portuguese prose

## 3. Wave gates

- [x] 3.1 Run per-wave i18n verification on the exact capability-spec file list
  - **Pattern:** `scripts/verify-i18n-wave.sh`
  - **Invariants:** `sdd-docs-language` — Per-wave and global verification script; Specs wave-1 residual-PT capability specs are English
  - **Gate:** `bash scripts/verify-i18n-wave.sh --files openspec/specs/sdd-ci-gates/spec.md,openspec/specs/sdd-post-install-verification/spec.md,openspec/specs/sdd-session-coordination/spec.md`
  - **Forbidden:** marking tasks done if G-PT/G-INV/G-LINK/G-OPENSPEC fail; running `--dod` as a required gate for this wave; touching `sdd-kit/templates/` or `sdd-install-kit` in this apply

- [x] 3.2 Validate OpenSpec change + task Pattern paths
  - **Pattern:** `scripts/verify-task-patterns.sh`
  - **Gate:** `bash scripts/verify-task-patterns.sh && OPENSPEC_TELEMETRY=0 npx --yes @fission-ai/openspec@1.3.1 validate translate-specs-wave-1 --strict`

## 4. Post-register (best-effort)

- [x] 4.1 `graphify update .` if available (docs touched); otherwise SKIP per infra
  - **Pattern:** `.cursor/rules/graphify.mdc`
  - **Gate:** `test -f graphify-out/GRAPH_REPORT.md || echo 'SKIP (graphify unavailable)'`
  - **Note:** SKIP if graphify CLI unavailable

# Tasks — translate-kit-wave-2c

> Apply after human approval (R7). **In-place PT→EN only** on kit Cursor rules W2c slice (+ checksums). Deferred W2d: `020`/`030`/`050` + `_template/proposal.md`. **Issue:** —

## 1. Prep (glossary + freeze)

- [x] 1.1 Confirm glossary covers terms needed for this wave; append rows to `doc/i18n/GLOSSARY.md` only if a new SDD term is introduced (same PR)
  - **Pattern:** `doc/i18n/GLOSSARY.md`
  - **Invariants:** `sdd-docs-language` — Glossary and wave inventory exist
  - **Gate:** `test -s doc/i18n/GLOSSARY.md && grep -qE 'Session Handoff|install kit|fail-closed|wave|glossary' doc/i18n/GLOSSARY.md`
  - **Proibido:** invent synonym variants for glossary terms; dual-file `*.en.md` / `*-pt.md`

## 2. Substitute kit Cursor rules W2c slice (in-place)

- [x] 2.1 Rewrite `sdd-kit/templates/.cursor/rules/000-base.mdc` Portuguese prose → glossary-canonical English aligned with hub `.cursor/rules/000-base.mdc`; freeze paths and `/opsx:propose`; translate YAML `description` value only
  - **Pattern:** `.cursor/rules/000-base.mdc`
  - **Invariants:** `sdd-docs-language` — Kit Cursor rules install templates (W2c slice) are English; Waves replace Portuguese in-place — dual-file forbidden
  - **Gate:** `test -f sdd-kit/templates/.cursor/rules/000-base.mdc && ! test -f sdd-kit/templates/.cursor/rules/000-base.en.mdc && grep -q 'Base project rules' sdd-kit/templates/.cursor/rules/000-base.mdc && grep -qF './AGENTS.md' sdd-kit/templates/.cursor/rules/000-base.mdc && grep -qF '/opsx:propose' sdd-kit/templates/.cursor/rules/000-base.mdc && grep -q 'alwaysApply: true' sdd-kit/templates/.cursor/rules/000-base.mdc`
  - **Proibido:** dual-file siblings; translating path strings; drive-by hub `.cursor/rules/000-base.mdc` edits; inventing synonym section titles vs hub

- [x] 2.2 Rewrite `sdd-kit/templates/.cursor/rules/015-session-phases.mdc` Portuguese prose → English aligned with hub `.cursor/rules/015-session-phases.mdc`; freeze `/opsx:*`, `openspec/infra.md`, `openspec/changes/<id>/`; translate YAML `description` value only
  - **Pattern:** `.cursor/rules/015-session-phases.mdc`
  - **Invariants:** `sdd-docs-language` — Kit Cursor rules install templates (W2c slice) are English; Freeze list of non-translatable tokens
  - **Gate:** `test -f sdd-kit/templates/.cursor/rules/015-session-phases.mdc && ! test -f sdd-kit/templates/.cursor/rules/015-session-phases.en.mdc && grep -q 'SDD session phases' sdd-kit/templates/.cursor/rules/015-session-phases.mdc && grep -qF 'Session Handoff' sdd-kit/templates/.cursor/rules/015-session-phases.mdc && grep -qF 'openspec/infra.md' sdd-kit/templates/.cursor/rules/015-session-phases.mdc && grep -q 'alwaysApply: true' sdd-kit/templates/.cursor/rules/015-session-phases.mdc`
  - **Proibido:** dual-file siblings; rewriting slash-command tokens; drive-by hub rule edits

- [x] 2.3 Rewrite `sdd-kit/templates/.cursor/rules/016-session-coordination.mdc` Portuguese prose → English aligned with hub `.cursor/rules/016-session-coordination.mdc`; freeze script paths (`sdd-session-register.sh`, `sdd-session-check.sh`, `sdd-session-release.sh`, `sdd-session-status.sh`), `worktree`, R11 pointers; translate YAML `description` value only
  - **Pattern:** `.cursor/rules/016-session-coordination.mdc`
  - **Invariants:** `sdd-docs-language` — Kit Cursor rules install templates (W2c slice) are English; Freeze list of non-translatable tokens
  - **Gate:** `test -f sdd-kit/templates/.cursor/rules/016-session-coordination.mdc && ! test -f sdd-kit/templates/.cursor/rules/016-session-coordination.en.mdc && grep -q 'SDD session coordination' sdd-kit/templates/.cursor/rules/016-session-coordination.mdc && grep -qF 'scripts/sdd-session-register.sh' sdd-kit/templates/.cursor/rules/016-session-coordination.mdc && grep -qF 'scripts/sdd-session-check.sh' sdd-kit/templates/.cursor/rules/016-session-coordination.mdc && grep -qF 'scripts/sdd-session-release.sh' sdd-kit/templates/.cursor/rules/016-session-coordination.mdc && grep -q 'alwaysApply: true' sdd-kit/templates/.cursor/rules/016-session-coordination.mdc`
  - **Proibido:** dual-file siblings; translating script path strings; drive-by hub rule edits

- [x] 2.4 Rewrite `sdd-kit/templates/.cursor/rules/010-typescript.mdc` Portuguese prose → English aligned with hub `.cursor/rules/010-typescript.mdc`; freeze globs (`**/*.ts`, `**/*.tsx`), identifiers (`cn`, `Zod`, `@/`); translate YAML `description` value only; keep `alwaysApply: false`
  - **Pattern:** `.cursor/rules/010-typescript.mdc`
  - **Invariants:** `sdd-docs-language` — Kit Cursor rules install templates (W2c slice) are English; YAML globs and alwaysApply preserved
  - **Gate:** `test -f sdd-kit/templates/.cursor/rules/010-typescript.mdc && ! test -f sdd-kit/templates/.cursor/rules/010-typescript.en.mdc && grep -q 'TypeScript conventions' sdd-kit/templates/.cursor/rules/010-typescript.mdc && grep -qF '**/*.ts' sdd-kit/templates/.cursor/rules/010-typescript.mdc && grep -qF '**/*.tsx' sdd-kit/templates/.cursor/rules/010-typescript.mdc && grep -q 'alwaysApply: false' sdd-kit/templates/.cursor/rules/010-typescript.mdc && grep -qF 'cn()' sdd-kit/templates/.cursor/rules/010-typescript.mdc && grep -qF 'Zod' sdd-kit/templates/.cursor/rules/010-typescript.mdc`
  - **Proibido:** dual-file siblings; changing glob patterns; drive-by hub rule edits; inventing synonym conventions vs hub

## 3. Checksums (G-MANIFEST)

- [x] 3.1 Regenerate `sdd-kit/MANIFEST.yaml` sha256 fields after template edits
  - **Pattern:** `sdd-kit/gen-manifest-checksums.sh`
  - **Invariants:** `sdd-docs-language` — Kit Cursor rules install templates (W2c slice) are English (G-MANIFEST)
  - **Gate:** `bash sdd-kit/gen-manifest-checksums.sh && bash sdd-kit/verify.sh`
  - **Proibido:** hand-editing sha256 without regenerator; evaluating MANIFEST `gate:` via eval; skipping verify after checksum update

## 4. Wave gates

- [x] 4.1 Run per-wave i18n verification on the exact W2c file list
  - **Pattern:** `scripts/verify-i18n-wave.sh`
  - **Invariants:** `sdd-docs-language` — Per-wave and global verification script; Kit Cursor rules install templates (W2c slice) are English
  - **Gate:** `bash scripts/verify-i18n-wave.sh --files sdd-kit/templates/.cursor/rules/000-base.mdc,sdd-kit/templates/.cursor/rules/015-session-phases.mdc,sdd-kit/templates/.cursor/rules/016-session-coordination.mdc,sdd-kit/templates/.cursor/rules/010-typescript.mdc`
  - **Proibido:** marking tasks done if G-PT/G-INV/G-LINK/G-MANIFEST/G-OPENSPEC fail; running `--dod` as a required gate for this wave

- [x] 4.2 Validate OpenSpec change + task Pattern paths
  - **Pattern:** `scripts/verify-task-patterns.sh`
  - **Gate:** `bash scripts/verify-task-patterns.sh && OPENSPEC_TELEMETRY=0 npx --yes @fission-ai/openspec@1.3.1 validate translate-kit-wave-2c --strict`

## 5. Post-register (best-effort)

- [x] 5.1 `graphify update .` if available (docs/templates touched); otherwise SKIP per infra
  - **Pattern:** `.cursor/rules/graphify.mdc`
  - **Gate:** `test -f graphify-out/GRAPH_REPORT.md || echo 'SKIP (graphify unavailable)'`
  - **Note:** SKIP if graphify CLI unavailable

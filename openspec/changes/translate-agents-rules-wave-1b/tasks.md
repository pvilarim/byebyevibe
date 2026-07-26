# Tasks — translate-agents-rules-wave-1b

> Apply after human approval (R7). **In-place PT→EN only** on the four always-apply Cursor rules. Remaining rules (`010`/`020`/`030`/`graphify.mdc`) → `translate-agents-rules-wave-1c`. **Issue:** —

## 1. Prep (glossary + freeze)

- [ ] 1.1 Confirm glossary covers terms needed for this wave; append rows to `doc/i18n/GLOSSARY.md` only if a new SDD term is introduced (same PR)
  - **Pattern:** `doc/i18n/GLOSSARY.md`
  - **Invariants:** `sdd-docs-language` — Glossary and wave inventory exist
  - **Gate:** `test -s doc/i18n/GLOSSARY.md && grep -qE 'Session Handoff|apply|propose|fail-closed|worktree' doc/i18n/GLOSSARY.md`
  - **Proibido:** invent synonym variants for glossary terms; dual-file `*.en.md` / `*-pt.md`

## 2. Substitute always-apply rules (in-place)

- [ ] 2.1 Rewrite `.cursor/rules/000-base.mdc` Portuguese prose → glossary-canonical English at the same path; translate frontmatter `description`; keep pointers to `AGENTS.md`, `openspec/project.md`, `openspec/specs/`, `graphify-out/GRAPH_REPORT.md`, GitNexus, `/opsx:propose`
  - **Pattern:** `.cursor/rules/000-base.mdc`
  - **Invariants:** `sdd-docs-language` — Always-apply Cursor rules (W1b slice) are English; Waves replace Portuguese in-place — dual-file forbidden
  - **Gate:** `test -f .cursor/rules/000-base.mdc && ! test -f .cursor/rules/000-base.en.mdc && grep -q 'AGENTS.md' .cursor/rules/000-base.mdc && grep -q '/opsx:propose' .cursor/rules/000-base.mdc`
  - **Proibido:** dual-file siblings; translating path strings; changing `alwaysApply: true`

- [ ] 2.2 Rewrite `.cursor/rules/015-session-phases.mdc` Portuguese prose → English; preserve phase names `explore | propose | apply | archive`, `Session Handoff`, `/opsx:*`, and `openspec/changes/<id>/` / `openspec/infra.md` paths
  - **Pattern:** `.cursor/rules/015-session-phases.mdc`
  - **Invariants:** `sdd-docs-language` — Always-apply Cursor rules (W1b slice) are English; Freeze list of non-translatable tokens
  - **Gate:** `grep -q 'Session Handoff' .cursor/rules/015-session-phases.mdc && grep -qF 'explore | propose | apply | archive' .cursor/rules/015-session-phases.mdc && grep -q 'openspec/infra.md' .cursor/rules/015-session-phases.mdc`
  - **Proibido:** merging phases into one chat as policy change; removing Session Handoff requirement; dual-file siblings

- [ ] 2.3 Rewrite `.cursor/rules/016-session-coordination.mdc` Portuguese prose → English; preserve MUST/advisory distinction; freeze all `scripts/sdd-session-*.sh` paths, R11, `openspec/infra.md`, `.sdd/runtime/`, and CI exemption wording meaning
  - **Pattern:** `.cursor/rules/016-session-coordination.mdc`
  - **Invariants:** `sdd-docs-language` — Always-apply Cursor rules (W1b slice) are English; Freeze list of non-translatable tokens
  - **Gate:** `grep -q 'scripts/sdd-session-register.sh' .cursor/rules/016-session-coordination.mdc && grep -q 'scripts/sdd-session-check.sh' .cursor/rules/016-session-coordination.mdc && grep -q 'scripts/sdd-session-release.sh' .cursor/rules/016-session-coordination.mdc && grep -q 'R11' .cursor/rules/016-session-coordination.mdc`
  - **Proibido:** weakening Apply MUST register/check/release; translating script paths; dual-file siblings

- [ ] 2.4 Rewrite `.cursor/rules/050-security.mdc` Portuguese prose → English (NEVER/ALWAYS lists, openspec telemetry, CI/CD, supply-chain/MANIFEST sections); freeze pins, `OPENSPEC_TELEMETRY=0`, `gate:`, `F-SEC-3`/`F-SEC-5`, workflow filenames
  - **Pattern:** `.cursor/rules/050-security.mdc`
  - **Invariants:** `sdd-docs-language` — Always-apply Cursor rules (W1b slice) are English; Freeze list of non-translatable tokens
  - **Gate:** `grep -q 'OPENSPEC_TELEMETRY=0' .cursor/rules/050-security.mdc && grep -q '@fission-ai/openspec@1.3.1' .cursor/rules/050-security.mdc && grep -q 'sdd-kit/MANIFEST.yaml' .cursor/rules/050-security.mdc && grep -qE 'F-SEC-5|F-SEC-3' .cursor/rules/050-security.mdc`
  - **Proibido:** changing NEVER/ALWAYS semantics; evaluating `gate:` as executable; dual-file siblings; translating fence/command text

## 3. Wave gates

- [ ] 3.1 Run per-wave i18n verification on the exact W1b file list
  - **Pattern:** `scripts/verify-i18n-wave.sh`
  - **Invariants:** `sdd-docs-language` — Per-wave and global verification script; Always-apply Cursor rules (W1b slice) are English
  - **Gate:** `bash scripts/verify-i18n-wave.sh --files .cursor/rules/000-base.mdc,.cursor/rules/015-session-phases.mdc,.cursor/rules/016-session-coordination.mdc,.cursor/rules/050-security.mdc`
  - **Proibido:** marking tasks done if G-PT/G-INV/G-LINK/G-OPENSPEC fail; running `--dod` as a required gate for this wave

- [ ] 3.2 Validate OpenSpec change + task Pattern paths
  - **Pattern:** `scripts/verify-task-patterns.sh`
  - **Gate:** `bash scripts/verify-task-patterns.sh && OPENSPEC_TELEMETRY=0 npx --yes @fission-ai/openspec@1.3.1 validate translate-agents-rules-wave-1b --strict`

## 4. Post-register (best-effort)

- [ ] 4.1 `graphify update .` if available (rules/docs touched); otherwise SKIP per infra
  - **Pattern:** `.cursor/rules/graphify.mdc`
  - **Gate:** `test -f graphify-out/GRAPH_REPORT.md || echo 'SKIP (graphify unavailable)'`

# Tasks — translate-agents-rules-wave-1

> Apply after human approval (R7). **In-place PT→EN only** on the three entry-point files. Rules (`.cursor/rules/*.mdc`) → `translate-agents-rules-wave-1b`. **Issue:** —

## 1. Prep (glossary + freeze)

- [ ] 1.1 Confirm glossary covers terms needed for this wave; append rows to `doc/i18n/GLOSSARY.md` only if a new SDD term is introduced (same PR)
  - **Pattern:** `doc/i18n/GLOSSARY.md`
  - **Invariants:** `sdd-docs-language` — Glossary and wave inventory exist
  - **Gate:** `test -s doc/i18n/GLOSSARY.md && grep -qE 'change|propose|apply|Session Handoff|fail-closed' doc/i18n/GLOSSARY.md`
  - **Proibido:** invent synonym variants for glossary terms; dual-file `*.en.md` / `*-pt.md`

## 2. Substitute entry-point files (in-place)

- [ ] 2.1 Rewrite `CLAUDE.md` Portuguese prose → glossary-canonical English at the same path; keep pointers to `AGENTS.md` / `openspec/project.md` / Graphify; freeze paths and tool names
  - **Pattern:** `CLAUDE.md`
  - **Invariants:** `sdd-docs-language` — Agent entry-point documents are English; Waves replace Portuguese in-place — dual-file forbidden
  - **Gate:** `test -f CLAUDE.md && ! test -f CLAUDE.en.md && grep -qiE 'AGENTS\.md|openspec/project\.md' CLAUDE.md`
  - **Proibido:** dual-file siblings; translating path strings; changing guide version pin as drive-by scope

- [ ] 2.2 Rewrite `openspec/project.md` Portuguese prose → English (Purpose, Architecture, Conventions, Constraints, Cross-references, Non-goals); preserve F7 Language line; freeze paths (`doc/sistema-sdd-pedro.md`, `doc/avaliacoes/`, `sdd-kit/`) and brand names
  - **Pattern:** `openspec/project.md`
  - **Invariants:** `sdd-docs-language` — Agent entry-point documents are English; Chat may remain Portuguese (F7); Freeze list of non-translatable tokens
  - **Gate:** `grep -qE 'Language \(F7\)|versioned artifacts MUST be English' openspec/project.md && grep -qE 'pt-BR|chat' openspec/project.md && grep -q 'doc/sistema-sdd-pedro.md' openspec/project.md`
  - **Proibido:** removing F7; renaming paths; dual-file siblings

- [ ] 2.3 Rewrite `AGENTS.md` sections through Workflow (project context, Commands, knowledge sources, on-demand context, design-system docs, task classification protocol, R1–R11, Workflow) to English; preserve command tables, paths, `/opsx:*`, and pins
  - **Pattern:** `AGENTS.md`
  - **Invariants:** `sdd-docs-language` — Agent entry-point documents are English; Freeze list of non-translatable tokens
  - **Gate:** `grep -qE '^## (Project context|Commands|Knowledge sources|On-demand context|Universal rules)' AGENTS.md && grep -q '/opsx:propose' AGENTS.md && grep -q 'verify-i18n-wave' AGENTS.md`
  - **Proibido:** renumbering R1–R11; translating fenced shell commands; changing semantic meaning of rules

- [ ] 2.4 Rewrite remaining `AGENTS.md` sections (Integrations, Testing, PR/commits, post-implementation reviews, subagents, Security, Communication) to English; keep F7 and Pedro chat MAY pt-BR instruction in English wording
  - **Pattern:** `AGENTS.md`
  - **Invariants:** `sdd-docs-language` — Agent entry-point documents are English; Chat may remain Portuguese (F7)
  - **Gate:** `grep -qE '^## (Integrations|Testing|Communication)' AGENTS.md && grep -qE 'F7|chat MAY|versioned.*MUST be English' AGENTS.md && grep -qiE 'Pedro|pt-BR' AGENTS.md`
  - **Proibido:** removing F7; authorizing PT versioned artifacts

## 3. Wave gates

- [ ] 3.1 Run per-wave i18n verification on the exact W1 file list
  - **Pattern:** `scripts/verify-i18n-wave.sh`
  - **Invariants:** `sdd-docs-language` — Per-wave and global verification script; Agent entry-point documents are English
  - **Gate:** `bash scripts/verify-i18n-wave.sh --files AGENTS.md,openspec/project.md,CLAUDE.md`
  - **Proibido:** marking tasks done if G-PT/G-INV/G-LINK/G-OPENSPEC fail; running `--dod` as a required gate for this wave

- [ ] 3.2 Validate OpenSpec change + task Pattern paths
  - **Pattern:** `scripts/verify-task-patterns.sh`
  - **Gate:** `bash scripts/verify-task-patterns.sh && OPENSPEC_TELEMETRY=0 npx --yes @fission-ai/openspec@1.3.1 validate translate-agents-rules-wave-1 --strict`

## 4. Post-register (best-effort)

- [ ] 4.1 `graphify update .` if available (docs touched); otherwise SKIP per infra
  - **Pattern:** `.cursor/rules/graphify.mdc`
  - **Gate:** `test -f graphify-out/GRAPH_REPORT.md || echo 'SKIP (graphify unavailable)'`

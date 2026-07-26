# Tasks — add-english-docs-policy

> Apply scope after human approval (R7). **Layer 1 / Camada 1 only** — no mass PT→EN substitution. **Issue:** —

## 1. i18n documentation (glossary + inventory + template)

- [x] 1.1 Create `doc/i18n/GLOSSARY.md` with seed table from explore research (legacy pt-BR → canonical EN), freeze-list pointer, and allowlist notes for proper nouns / quotes
  - **Pattern:** `openspec/changes/explore-public-release-surface/research.md`
  - **Invariants:** `sdd-docs-language` — Glossary and wave inventory exist
  - **Gate:** `test -s doc/i18n/GLOSSARY.md && grep -qE 'change|propose|apply|gate|Session Handoff' doc/i18n/GLOSSARY.md`

- [x] 1.2 Create `doc/i18n/WAVES.md`: LOC inventory, wave order (W0 policy → W1… → WDoD), in-scope table (`doc/curso/` in; `openspec/changes/archive/` out), wave budgets (≤350–400 LOC, ≤4 files, 1 skill×2 mirrors), how to run `verify-i18n-wave.sh`
  - **Pattern:** `openspec/changes/explore-public-release-surface/research.md`
  - **Invariants:** `sdd-docs-language` — Wave size limits; In-scope and out-of-scope surfaces
  - **Gate:** `test -s doc/i18n/WAVES.md && grep -q 'doc/curso/' doc/i18n/WAVES.md && grep -q 'openspec/changes/archive/' doc/i18n/WAVES.md && grep -qE '350|400' doc/i18n/WAVES.md`

- [x] 1.3 Create `doc/i18n/WAVE-PROPOSAL-TEMPLATE.md` for future `translate-*-wave-N` changes (substitution in-place; dual-file forbidden; required gates; Session Handoff stub)
  - **Pattern:** `sdd-kit/templates/openspec/changes/_template/proposal.md`
  - **Invariants:** `sdd-docs-language` — Waves replace Portuguese in-place — dual-file forbidden
  - **Gate:** `test -s doc/i18n/WAVE-PROPOSAL-TEMPLATE.md && grep -q 'translate-' doc/i18n/WAVE-PROPOSAL-TEMPLATE.md && grep -q 'verify-i18n-wave' doc/i18n/WAVE-PROPOSAL-TEMPLATE.md`

## 2. Verification script

- [x] 2.1 Create executable `scripts/verify-i18n-wave.sh`: bash; flags `--files`, `--dod`, `--help`; implement G-INV, G-GLOSS, G-PT, G-LINK, G-MIRROR, G-MANIFEST, G-OPENSPEC; `--dod` runs global residual-PT scan over in-scope globs from WAVES; exit 0 on pass, non-zero on fail; no secrets; no new network deps beyond hub OpenSpec validate
  - **Pattern:** `scripts/verify-task-patterns.sh`
  - **Invariants:** `sdd-docs-language` — Per-wave and global verification script
  - **Gate:** `test -x scripts/verify-i18n-wave.sh && bash scripts/verify-i18n-wave.sh --help | grep -qE 'G-INV|G-PT|G-DoD|G-OPENSPEC'`

- [x] 2.2 Smoke the script against a known-EN file (e.g. `README.md`) with `--files` so G-PT does not false-fail; confirm `--help` exit 0; document deny-list location in script header or `doc/i18n/`
  - **Pattern:** `scripts/verify-infra.sh`
  - **Gate:** `bash scripts/verify-i18n-wave.sh --files README.md >/tmp/verify-i18n-smoke.txt && test -s /tmp/verify-i18n-smoke.txt`

## 3. Pointers (no mass rewrite)

- [x] 3.1 Update `AGENTS.md`: Comunicação clarifies F7 (chat MAY pt-BR; versioned artifacts MUST EN); Commands or Contexto sob demanda points to `doc/i18n/` and `bash scripts/verify-i18n-wave.sh`; ≤15 lines added
  - **Pattern:** `AGENTS.md`
  - **Invariants:** `sdd-docs-language` — Chat may remain Portuguese (F7)
  - **Gate:** `grep -q 'verify-i18n-wave' AGENTS.md && grep -qE 'doc/i18n|GLOSSARY|WAVES' AGENTS.md`

- [x] 3.2 Update `openspec/project.md` Conventions: replace/clarify the language line so versioned artifacts MUST be English while chat MAY be pt-BR (F7)
  - **Pattern:** `openspec/project.md`
  - **Gate:** `grep -qE 'English|EN' openspec/project.md && grep -qE 'pt-BR|chat' openspec/project.md`

- [x] 3.3 Register `scripts/verify-i18n-wave.sh` in `openspec/infra.md` (status + verify-with); optional pointer to `doc/i18n/`
  - **Pattern:** `openspec/infra.md`
  - **Invariants:** `sdd-workspace-manifest` — i18n verification script registered in infrastructure manifest
  - **Gate:** `grep -q 'verify-i18n-wave' openspec/infra.md`

## 4. Specs promotion

- [x] 4.1 Promote `openspec/changes/add-english-docs-policy/specs/sdd-docs-language/spec.md` to `openspec/specs/sdd-docs-language/spec.md`
  - **Pattern:** `openspec/specs/sdd-metrics/spec.md`
  - **Gate:** `test -f openspec/specs/sdd-docs-language/spec.md`

- [x] 4.2 Apply ADDED delta for `sdd-workspace-manifest` into `openspec/specs/sdd-workspace-manifest/spec.md`
  - **Pattern:** `openspec/specs/sdd-workspace-manifest/spec.md`
  - **Gate:** `grep -q 'verify-i18n-wave' openspec/specs/sdd-workspace-manifest/spec.md`

## 5. Validation

- [x] 5.1 Run `bash scripts/verify-task-patterns.sh` on active changes
  - **Pattern:** `scripts/verify-task-patterns.sh`
  - **Gate:** `bash scripts/verify-task-patterns.sh`

- [x] 5.2 Validate this change with openspec CLI
  - **Pattern:** `openspec/changes/add-english-docs-policy/proposal.md`
  - **Gate:** `OPENSPEC_TELEMETRY=0 npx --yes @fission-ai/openspec@1.3.1 validate add-english-docs-policy --strict`

## 6. Post-register (best-effort)

- [x] 6.1 `graphify update .` if available (docs/scripts touched)
  - **Pattern:** `.cursor/rules/graphify.mdc`
  - **Gate:** `test -f graphify-out/GRAPH_REPORT.md || echo 'SKIP (graphify ❌ in infra.md)'`

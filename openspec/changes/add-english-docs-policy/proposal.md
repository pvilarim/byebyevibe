**Issue:** —

## Why

The public hub (ByeByeVibe) still has large Portuguese surfaces (`doc/sistema-sdd-pedro.md`, skills, evaluations, course). Explore `explore-public-release-surface` decided **English is the canonical default** of the repository and that pt-BR in versioned files is legacy to **replace in-place** — not a permanent bilingual layer. Without a Layer-1 policy (glossary, inventory, wave limits, verification gates), mass translation would overflow tokens, invent synonyms, break invariants, and leave residual PT. This change installs that policy only; substitution waves come later.

## What Changes

- **New capability `sdd-docs-language`:** EN = default/canonical language for versioned artifacts; new artifacts MUST be EN; chat MAY remain pt-BR (F7); migration waves MUST replace PT→EN in-place (dual-file `*.en.md` / `*-pt.md` **forbidden**); Definition of Done = residual PT prose ≈ 0 on in-scope surfaces.
- **`doc/i18n/GLOSSARY.md`:** canonical EN term bank (seed from explore research).
- **`doc/i18n/WAVES.md`:** PT inventory, wave order, in-scope vs exceptions (`doc/curso/` in-scope; `openspec/changes/archive/` out).
- **`scripts/verify-i18n-wave.sh`:** per-wave gates G-INV, G-GLOSS, G-PT, G-LINK, G-MIRROR, G-MANIFEST, G-OPENSPEC, plus global G-DoD mode.
- **Wave budget (normative):** ≤350–400 LOC substituted, ≤4 files touched (or 1 logical skill × 2 mirrors), zero residual PT prose in the wave slice.
- **Pointers:** `AGENTS.md` Comunicação + Commands; `openspec/project.md` Conventions (chat vs artifacts); `openspec/infra.md` registration of the verify script.
- **Wave proposal template:** `doc/i18n/WAVE-PROPOSAL-TEMPLATE.md` for future `translate-*-wave-N` changes (substitution, not “add English layer”).

## Capabilities

### New Capabilities

- `sdd-docs-language`: English-default documentation language policy; glossary; wave inventory/limits; i18n verification script (per-wave + global DoD); F7 chat-vs-artifacts rule.

### Modified Capabilities

- `sdd-workspace-manifest`: register `scripts/verify-i18n-wave.sh` (and i18n docs pointers) in `openspec/infra.md`.

## Impact

- New: `openspec/specs/sdd-docs-language/spec.md` (promoted on archive), `doc/i18n/GLOSSARY.md`, `doc/i18n/WAVES.md`, `doc/i18n/WAVE-PROPOSAL-TEMPLATE.md`, `scripts/verify-i18n-wave.sh`
- Modified: `AGENTS.md`, `openspec/project.md`, `openspec/infra.md` (pointers only — no mass rewrite of the guide/skills)
- **Non-goals (this change):** mass PT→EN migration of guide/skills/evaluations/course; root `CHANGELOG.md` (F3); path renames (`sistema-sdd-pedro.md`, `doc/avaliacoes/`); rewrite of `openspec/changes/archive/`; dual-file EN/PT; making the i18n script a blocking CI gate in this change
- **Follow-ups:** one `/opsx:propose translate-…` per wave after policy archive; `add-root-changelog` (F3) remains separate
- **Issue:** —

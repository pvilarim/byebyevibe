# Knowledge Summary — translate-kit-wave-2

> Research scope: `sdd-docs-language` W2 kit surface — `sdd-kit/README.md` + `AGENTS.*` templates (+ checksums).

## [NEEDS VERIFICATION] Graph status

`graphify-out/GRAPH_REPORT.md` **does not exist**. GitNexus MCP not queried. Anchoring to documentation sources:

- `doc/i18n/WAVES.md`, `GLOSSARY.md`, `WAVE-PROPOSAL-TEMPLATE.md`
- `openspec/specs/sdd-docs-language/spec.md`
- `openspec/changes/translate-agents-rules-wave-1c/` (precedent)
- `sdd-kit/install.sh` (AGENTS commands injection), `sdd-kit/gen-manifest-checksums.sh`

Gaps are acceptable: targets are markdown install payloads, not executable symbols.

## Key Concepts

| Concept | Notes |
|---------|-------|
| Wave budgets | ≤350–400 LOC; ≤4 files; slice DoD = zero residual PT |
| In-place substitution | Dual-file `*.en.md` / `*-pt.md` **forbidden** |
| G-MANIFEST | Touched `sdd-kit/templates/` → `bash sdd-kit/gen-manifest-checksums.sh` + `sdd-kit/verify.sh` |
| Profile injection | `<!-- SDD_KIT_COMMANDS_START -->` / `<!-- SDD_KIT_COMMANDS_END -->` markers — freeze |
| W1c prerequisite | Apply-complete + merged (PR #71); archive may still be pending |

## Wave-2 file list (in scope)

| File | ~LOC |
|------|------|
| `sdd-kit/README.md` | 112 |
| `sdd-kit/templates/AGENTS.core.md` | 121 |
| `sdd-kit/templates/AGENTS.commands.DOCS_SPECS.md` | 13 |
| `sdd-kit/templates/AGENTS.commands.APP.md` | 10 |
| **Total** | **256** |

## Deferred (`translate-kit-wave-2b`)

- `sdd-kit/templates/CLAUDE.md`
- `sdd-kit/templates/openspec/infra.md`
- Kit `.cursor/rules/*.mdc` copies, `_template/proposal.md`, design docs under kit

## Freeze tokens (this wave)

Paths (`sdd-kit/`, `doc/sistema-sdd-pedro.md`, …), HTML markers `SDD_KIT_COMMANDS_*`, profile codes (`APP`/`DOCS_SPECS`/`HYBRID`, `C1`–`C3`, `C1-UI`, `G2`, `G4`), fenced shell (`install.sh`, `upgrade.sh`, `verify.sh`, openspec/gitnexus/graphify), pins, brand names (ByeByeVibe, …).

## Sources consulted

`doc/i18n/*`, `sdd-docs-language` spec, W1c change artifacts, `sdd-kit/install.sh`, AS-IS target files. Graphify/GitNexus: SKIP / `[NEEDS VERIFICATION]`.

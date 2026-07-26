# Knowledge Summary — translate-agents-rules-wave-1c

> Research scope: `sdd-docs-language` capability, wave budgets, W1/W1b/W1c split, freeze list, glossary, verify-i18n-wave.sh gates, `.cursor/rules/*.mdc` translation.

## [NEEDS VERIFICATION] Graph status

`graphify-out/GRAPH_REPORT.md` **does not exist**. Anchoring to documentation sources:

- `doc/i18n/WAVES.md`
- `doc/i18n/GLOSSARY.md`
- `doc/i18n/WAVE-PROPOSAL-TEMPLATE.md`
- `openspec/specs/sdd-docs-language/spec.md`
- `openspec/changes/translate-agents-rules-wave-1/proposal.md`
- `openspec/changes/translate-agents-rules-wave-1b/proposal.md`
- `scripts/verify-i18n-wave.sh`

---

## Key Concepts Found

| Concept | Source | Notes |
|---------|--------|-------|
| `sdd-docs-language` capability | `openspec/specs/sdd-docs-language/spec.md` | Normative spec; EN=default for versioned artifacts; F7 chat vs. artifacts |
| Wave budget | `doc/i18n/WAVES.md` §Wave budgets | ≤350–400 LOC, ≤4 files OR 1 skill×2 mirrors, 1 apply session |
| W1 scope | `translate-agents-rules-wave-1/proposal.md` | `AGENTS.md`, `openspec/project.md`, `CLAUDE.md` — applied |
| W1b scope | `translate-agents-rules-wave-1b/proposal.md` | 4 always-apply `.mdc` rules: `000-base`, `015-session-phases`, `016-session-coordination`, `050-security` |
| W1c scope | W1b proposal §Budget split | Remaining rules: `010-typescript`, `020-python`, `030-supabase`, `graphify.mdc` |
| Freeze list | `doc/i18n/GLOSSARY.md` §Freeze list | Paths, change-ids, `/opsx:*`, shell fences, pins, MANIFEST keys, brand names |
| Allowlist | `doc/i18n/GLOSSARY.md` §Allowlist | Proper nouns, URLs, quoted historical PT, code identifiers, fenced shell |
| Term bank | `doc/i18n/GLOSSARY.md` §Term bank | Legacy pt-BR → canonical EN mapping; expand per wave |
| Verification gates | `scripts/verify-i18n-wave.sh` | G-INV, G-GLOSS, G-PT, G-LINK, G-MIRROR, G-MANIFEST, G-OPENSPEC, G-DoD |
| Dual-file forbidden | spec Requirement "Waves replace Portuguese in-place" | No `*.en.md` / `*-pt.md` |

---

## Relationships (edge types)

| From | Edge | To |
|------|------|----|
| W1 | **precedes** | W1b |
| W1b | **precedes** | W1c |
| W1c | **defers** remaining rules from | W1b proposal §Budget split |
| All waves | **governed by** | `sdd-docs-language` spec |
| Waves | **verified by** | `verify-i18n-wave.sh` |
| Glossary | **constrains** | term usage in all waves |
| Freeze list | **protects** | paths, commands, code identifiers |

---

## W1c In-Scope Files (4 files, ≤4-file budget)

| Path | ~LOC PT | Effort |
|------|---------|--------|
| `.cursor/rules/010-typescript.mdc` | ~19 | Low |
| `.cursor/rules/020-python.mdc` | ~18 | Low |
| `.cursor/rules/030-supabase.mdc` | ~19 | Low |
| `.cursor/rules/graphify.mdc` | 11 (already EN) | Trivial / verify only |

**Total:** ~67 LOC PT to substitute — well within 350–400 budget.

---

## Relevant Gates for W1c

| Gate | Applies? | Notes |
|------|----------|-------|
| G-INV | Yes | No translated command forms (`/opsx:aplicar` etc.) |
| G-GLOSS | Yes | Glossary present + canonical terms |
| G-PT | Yes | Deny-list residual PT tokens on wave files |
| G-LINK | Yes | Relative markdown links resolve |
| G-MIRROR | **No** | No `.claude/rules/` mirror for `.mdc` files |
| G-MANIFEST | **No** | `sdd-kit/templates/.cursor/rules/` NOT touched this wave (separate wave) |
| G-OPENSPEC | Yes | `openspec validate --all --strict` |
| G-DoD | **No** | Global — later wave |

**Required command:**

```bash
bash scripts/verify-i18n-wave.sh --files .cursor/rules/010-typescript.mdc,.cursor/rules/020-python.mdc,.cursor/rules/030-supabase.mdc,.cursor/rules/graphify.mdc
```

---

## Notes on `.cursor/rules/*.mdc` Translation

1. **YAML frontmatter:** preserve keys (`description`, `globs`, `alwaysApply`); translate `description` string value to English.
2. **Body prose:** substitute PT→EN using glossary canonical forms.
3. **Code identifiers / fences:** freeze (e.g., `@/`, `cn()`, `pytest-asyncio`, `pgvector`, `ivfflat`, `structlog`).
4. **`graphify.mdc`:** already English — verify only (no substitution needed).
5. **No mirror pair:** `.mdc` rules are Cursor-only; G-MIRROR N/A.
6. **Kit templates:** `sdd-kit/templates/.cursor/rules/` are **separate** files; touching them triggers G-MANIFEST and requires `bash sdd-kit/gen-manifest-checksums.sh`. Recommend deferring kit rules to a dedicated `translate-kit-rules-wave-*` or folding into W2 (`sdd-kit/README.md` + templates).

---

## Prior Decisions

| Decision | Source |
|----------|--------|
| Split W1 into W1/W1b/W1c | W1 proposal §Budget split; W1b proposal §Budget split |
| Always-apply rules first (W1b before W1c) | W1b proposal §Why |
| Kit templates require checksum update | `AGENTS.md` §sdd-kit — checksum maintenance |

---

## Gaps

| Gap | Impact |
|-----|--------|
| [KNOWLEDGE GAP] Graph nodes for i18n concepts | Cannot trace concept relations via MCP; anchored to docs |
| `graphify-out/GRAPH_REPORT.md` missing | No god-node / community analysis available |
| Kit templates wave undefined | Need separate W2 or `translate-kit-rules-wave-*` to cover `sdd-kit/templates/.cursor/rules/` |

---

## Recommendation

**Enough known to proceed.** W1c scope is well-defined (4 files, ~67 LOC PT, low risk). Proceed with `proposal.md` and `design.md` using this knowledge summary. No additional research required before proposing.

# Documentation language glossary (canonical English)

> Capability: `sdd-docs-language` · Seed: `openspec/changes/explore-public-release-surface/research.md`  
> Policy: English is the canonical default for versioned artifacts. Legacy pt-BR prose is replaced **in-place** by substitution waves — not maintained as a bilingual layer.

## How to use

1. Waves **MUST** use the **canonical EN** column for SDD vocabulary.
2. Do **not** invent synonym variants for the same concept across waves.
3. If a wave needs a term not listed here, **add it in the same wave** before or with the substitution.
4. Freeze-list and allowlist entries are **not** terms to “translate.”

## Freeze list (never rewrite as “translation”)

| Category | Examples | Why |
|----------|----------|-----|
| Paths / globs | `openspec/changes/`, `sdd-kit/install.sh`, `doc/sistema-sdd-pedro.md` | Breaks install and agents |
| Change-ids / branches | `add-english-docs-policy`, `translate-guide-wave-1` | Links and `openspec validate` |
| Slash commands / skills | `/opsx:apply`, `/opsx:propose`, `openspec-explore` | Skill discovery |
| Shell / CI fences | `npx openspec validate`, `bash scripts/verify-i18n-wave.sh` | Executability |
| Package pins / versions | `@fission-ai/openspec@1.3.1` | Supply chain |
| Code identifiers | `enforceTdd`, MANIFEST keys (`sha256:`, `gate:`) | Runtime / kit integrity |
| Stable EN heading anchors | RFC-style headings in specs | Internal links |
| Brand / tool names | ByeByeVibe, OpenSpec, GitNexus, Graphify, Probity, Impeccable | Identity + SEO |

See also: `doc/i18n/WAVES.md` (G-INV) and `scripts/verify-i18n-wave.sh`.

## Allowlist (not residual Portuguese)

These may remain in English-migrated files without failing G-PT / G-DoD:

- **Proper nouns** and brand names (table above)
- **URLs** and path strings (including Portuguese path segments until a separate rename change)
- **Quoted historical Portuguese** (citations of prior docs, workshop titles, research quotes) when clearly quoted
- **Code identifiers** and fenced shell/command text (byte-stable)
- **Change-ids** and skill directory names even if they contain English verbs

Document wave-specific allowlist exceptions in that wave’s proposal when needed.

## Term bank (legacy pt-BR → canonical EN)

| Legacy pt-BR | Canonical EN | Notes |
|--------------|--------------|-------|
| mudança / change OpenSpec | change | kebab-case change-id stays intact |
| propor / proposta | propose / proposal | |
| aplicar | apply | |
| explorar | explore | |
| arquivar | archive | |
| porta / gate | gate | verification command |
| habilidade | skill | path `.cursor/skills/` intact |
| sessão / handoff | session / Session Handoff | |
| worktree | worktree | do not translate |
| perfil APP / DOCS_SPECS | APP / DOCS_SPECS profile | |
| kit de instalação | install kit / sdd-kit | path `sdd-kit/` intact |
| guia canónico | canonical guide | path may stay `doc/sistema-sdd-pedro.md` until a rename wave |
| avaliação | evaluation | path `doc/avaliacoes/` until rename |
| correcção manual | manual fix (out of kit) | from OSS research |
| falha fechada / aberta | fail-closed / fail-open | |
| inventário | inventory | |
| glossário | glossary | |
| onda / wave | wave | substitution unit |
| Definition of Done / DoD | Definition of Done / DoD | residual PT ≈ 0 in-scope |

## Expand as waves land

Append new rows in the same PR that introduces the term. Prefer short, stable EN nouns over stylish synonyms.

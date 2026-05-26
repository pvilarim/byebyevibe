# Design — Guia SDD v1.1 + AGENTS.md alvo

## Contexto

Fonte: análise cruzada `doc/sistema-sdd-pedro.md` v1.0, workshop Aula 01 (link #20 agents.md), padrão https://agents.md/, estado actual do repo piloto.

## Decisões

### D1 — Guia como fonte; repo como piloto

O `doc/sistema-sdd-pedro.md` actualiza-se **antes** do `AGENTS.md` do `spec-pedro`. Instalações futuras copiam o guia, não o estado acidental do piloto.

### D2 — AGENTS.md: encurtar + referenciar

Integrações GitNexus/Graphify em ≤10 linhas cada; detalhe em skills (`.claude/skills/gitnexus/`). Remove blocos `<!-- gitnexus:start -->` do canónico.

**Fonte:** §2.5.1 do guia; workshop “não gerar AGENTS com IA”.

### D3 — Perfil DOCS_SPECS para spec-pedro

Sem `npm run dev` na raiz. Commands: openspec, gitnexus, graphify (template 12.2b).

### D4 — Não adoptar (registo explícito)

| Proposta | Decisão | Razão |
|----------|---------|-------|
| YAML AAIF no AGENTS.md | Rejeitado | Overhead; agents.md usa Markdown livre |
| Duplicar stack no AGENTS.md | Rejeitado | `openspec/project.md` é constituição |
| Apagar `.mdc` | Rejeitado | Cursor precisa globs |
| IA gera AGENTS.md | Rejeitado | Workshop + §2.5.1 |

### D5 — Registo de mudanças

- Changelog no próprio guia (§ Changelog do guia)
- Este change OpenSpec `update-sdd-install-guide-agents-format`

## Knowledge sources consulted

- Graphify: workshop / AGENTS.md (quando grafo indexado)
- Guia: `doc/sistema-sdd-pedro.md` §2.5, §5.3, anexo 12
- Workshop: `doc/curso/aula-01-workshop-ia-5-2026.md` (Context Engineering, agents.md link #20)
- Externo: https://agents.md/

## Riscos

- R1 — Re-run `gitnexus analyze` pode re-injectar bloco GitNexus → mitigação: política §2.5.1 no guia.
- R2 — Guia longo → mitigação: índice + §2.0 prompt para IA.

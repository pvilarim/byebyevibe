# Research — Superfície pública no lançamento (visibilidade + changelog)

| Campo | Valor |
|-------|-------|
| **Data** | 2026-07-26 |
| **Change** | `explore-public-release-surface` (tipo E — exploração) |
| **Estado** | **Adiado — desenvolvimento futuro** |
| **Gatilho** | Preparar / tratar o repo **ByeByeVibe** (`byebyevibe`) como **lançamento público** (discovery GitHub para terceiros) |
| **Objectivo** | Registar decisões de explore sobre (1) o que visitantes vêem vs docs/processo interno e (2) changelog de produto visível |
| **Não fazer agora** | Não implementar i18n, `CHANGELOG.md`, split de repos, nem `.gitignore` de specs |
| **Fontes** | Explore 2026-07-26; `doc/avaliacoes/2026-07-26-sdd-discovery-positioning.md` roadmap §11; `doc/sistema-sdd-pedro.md` § Changelog do guia; design discovery D1/D10 |

## Resumo executivo

Num repo GitHub **público**, **não é possível** ter pastas versionadas e invisíveis a visitantes. Esconder `openspec/` / `doc/` via `.gitignore` quebra o hub SDD (agents, gates, OpenSpec).

**Desenvolvimento futuro (quando for público de facto):**

1. **Preferir** policy EN + waves de tradução (roadmap discovery §11 passo ④) — superfície amigável sem fingir invisibilidade.
2. **Opcional** `CHANGELOG.md` EN na raiz (fino) apontando ao changelog canónico do guia §14 (hoje só existe lá; **não** há `CHANGELOG.md` na raiz).
3. **Só se necessário** split `byebyevibe` (público) + repo ops privado — não é pré-requisito.
4. **Proibido como “solução”:** gitignore de `openspec/specs/`, `openspec/changes/`, ou `sdd-kit/` para “não mostrar português”.

Chat humano ↔ agente permanece **pt-BR** (AGENTS.md). Specs normativas muitas já estão em EN.

## Problema explorado

| Pedido | Interpretação |
|--------|----------------|
| Specs/pastas no repo mas “não visíveis” | Evitar que terceiros vejam conteúdo pt-BR e o trilho de desenvolvimento |
| Changelog das modificações principais | Superfície estável de “o que mudou” no projecto |

## Decisão registada (adiada)

| ID | Item | Decisão | Quando reabrir |
|----|------|---------|----------------|
| F1 | Esconder pastas no git público | **Não implementar** (impossível sem tirar do git) | — |
| F2 | Policy “artefactos novos = EN” + waves i18n | **Adiado** — change futuro `add-english-docs-policy` (ou equivalente) | Lançamento / repo público |
| F3 | `CHANGELOG.md` raiz (EN, fino) | **Adiado** — change futuro `add-root-changelog` | Lançamento / repo público |
| F4 | GitHub Releases espelhando versões kit | **Adiado** — opcional junto de F3 | Lançamento / repo público |
| F5 | Repo ops privado (guia/avaliações/archive) | **Adiado — só se dor real** após F2 | Se superfície pública ainda parecer “ruído” |
| F6 | `.gitignore` de specs/changes/docs | **Descartado** como estratégia de privacidade | Nova proposta só com justificação forte |

## Relação com o backlog de discovery

```
① README EN                    ✅
②–③ ByeByeVibe + slug          ✅ (manual no GitHub)
④ Policy EN + waves            ← F2 (este research; futuro)
   + CHANGELOG.md raiz (EN)    ← F3 (este research; futuro)
⑤ GIF                          Adiado (P5)
⑥ Landing/Discord              Não implementar
```

Inventário i18n e inventário exacto pt-BR→EN: **adiados** com F2 (não inventariar agora).

## Changelog — AS-IS (2026-07-26)

| Superfície | Estado |
|------------|--------|
| `doc/sistema-sdd-pedro.md` § Changelog do guia | ✅ canónico (v1.6.1 …) — pt-BR |
| `sdd-kit/MANIFEST.yaml` `version` | ✅ alinhado ao guia |
| `CHANGELOG.md` na raiz | ❌ inexistente |
| GitHub Releases como changelog de produto | não adoptado como processo |

## Non-goals deste explore

- Implementar tradução, `CHANGELOG.md`, ou split de repos nesta sessão
- Alterar MANIFEST / install paths
- Tornar o repo privado

## Próximo passo (quando o gatilho disparar)

Abrir novo chat:

```
/opsx:propose add-english-docs-policy
# e/ou
/opsx:propose add-root-changelog

Ler: openspec/changes/explore-public-release-surface/research.md
Avaliação: doc/avaliacoes/2026-07-26-sdd-discovery-positioning.md (F1–F6 / P11–P12)
Infra: openspec/infra.md (assumir ✅)
```

Um change por fatia (F2 vs F3); não mega-PR.

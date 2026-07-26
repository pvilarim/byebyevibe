## Context

- Roadmap §11 (research `add-sdd-discovery-positioning`): após README → **nome público (P10)** → i18n → GIF.
- Explore 2026-07-26 (chat): shortlist comparou Shipdeck / Agent Plane / SDD Kit / ByeByeVibe; decisão humana: **ByeByeVibe** + subtítulo canónico EN.
- AS-IS: H1 `SDD Install Kit`; repo `pvilarim/gitnexus-graphify-openspec`; pasta técnica `sdd-kit/`; English do hero já está correcto na tagline/anti-boilerplate — falta a marca.
- Perfil hub: **DOCS_SPECS**. Consumidores APP/HYBRID dependem de paths `sdd-kit/*`.
- Fontes: `README.md`, `openspec/changes/add-sdd-discovery-positioning/research.md` §11, `doc/avaliacoes/2026-07-26-sdd-discovery-positioning.md`, specs `sdd-discovery-positioning` + `sdd-install-kit`.

## Goals / Non-Goals

**Goals:**

1. Fixar marca pública **ByeByeVibe** e copy hero EN aprovada.
2. Inventariar **onde** o nome muda vs **onde** o path `sdd-kit/` permanece.
3. Listar bugs/riscos do rename e mitigação (especialmente não renomear pasta).
4. Checklist **[AÇÃO MANUAL]** (GitHub rename, About/topics, remotes, URLs autor).
5. Secção Maintainer no README com LinkedIn + portfólio (URLs do operador).
6. Actualizar specs de discovery/install-kit para o dual naming.

**Non-Goals:**

- Renomear pasta `sdd-kit/` ou comandos `bash sdd-kit/…` (**BREAKING** para consumidores).
- Tradução completa EN do hub (passo ④).
- GIF/asciinema (P5).
- Landing, Discord, one-liner `npx`, app scaffold, BMAD.
- Reescrever archive / PRs históricos.
- Alterar MANIFEST merge strategies, gates CI, ou lógica de install/upgrade.

## Decisions

### D1: Display name = ByeByeVibe; path = `sdd-kit/`

| Camada | Valor |
|--------|-------|
| Display / H1 / About | **ByeByeVibe** |
| Tagline | From vibe coding to shippable AI engineering. |
| Anti-boilerplate | Not another Next.js starter — the SDD control plane (OpenSpec + graphs + gates) your repo is missing. |
| Path / CLI / MANIFEST | **`sdd-kit/`** (inalterado) |
| Repo slug (manual) | `byebyevibe` (recomendado) |

**Porquê:** marca carrega o gancho vibe→engineering; path estável evita quebrar clones, docs de consumidores, CI e checksums. Alternativas rejeitadas neste change: renomear pasta para `byebyevibe/` (blast radius alto); manter só “SDD Kit” (P10 incompleto).

### D2: Inglês do hero — já correcto; aplicar literalmente

O bloco aprovado está em inglês idiomático correcto (`engineering`, não “engeneering”; em dash `—`; “shippable AI engineering” alinhado ao research). Apply **substitui** o H1 actual; mantém CTA `sdd-kit/install.sh`, demo `/opsx`, compare table.

Glossário curto no README ou kit intro:

> **ByeByeVibe** is the public name of this project. The install payload lives in `sdd-kit/`.

### D3: Onde mudar o nome (inventário apply)

| Superfície | Acção |
|------------|-------|
| `README.md` (H1, About blurb, glossário, Maintainer) | **Mudar** display |
| `sdd-kit/README.md` (título/intro) | **Mudar** display; comandos `sdd-kit/` intactos |
| `doc/avaliacoes/2026-07-26-…` | P10 → **Adoptado**; working title → ByeByeVibe |
| `doc/avaliacoes/README.md` | Linha índice se mencionar working title |
| `doc/sistema-sdd-pedro.md` | Ponteiros first-contact / “SDD Install Kit” como **marca** → ByeByeVibe (payload continua sdd-kit) |
| `openspec/project.md` | Discovery / nome público |
| `AGENTS.md` | Referência discovery; nota GitNexus index name pode ficar até reindex |
| Headers de scripts (`# SDD Install Kit — …`) | **Opcional** → `# ByeByeVibe (sdd-kit) — …` (cosmético) |
| Echo `install.sh` (`=== SDD Install Kit v… ===`) | **Opcional** display |
| `sdd-kit/MANIFEST.yaml` comentário topo | Opcional |
| Paths `sdd-kit/**`, gates, workflows job names | **Não mudar** |
| `openspec/changes/archive/**`, PRs antigos | **Não mudar** |
| Links `github.com/pvilarim/gitnexus-graphify-openspec` em docs vivos | Actualizar **após** rename manual (ou nota “após rename”) |

### D4: Maintainer — LinkedIn + portfólio no README?

**Sim**, numa secção no **fundo** do README (não no hero):

```markdown
## Maintainer

Pedro Vilarim — [LinkedIn](URL) · [Portfolio](URL)
```

**Porquê:** credibilidade em projecto solo / small-team sem Discord/Landing (D9).  
**Não:** no primeiro viewport (hero budget do discovery; anti-ruído).  
**Apply:** placeholders `<!-- TODO: LinkedIn URL -->` / `<!-- TODO: Portfolio URL -->` **ou** URLs reais se o operador as fornecer antes do apply. Sem URLs → tarefa marcada com `[AÇÃO MANUAL]` e links omitidos até fornecidos (não inventar).

### D5: Ações manuais (operador)

Ver Migration Plan + checklist na avaliação/README. Agente **não** altera GitHub Settings.

### D6: Alias pt-BR “TchauVibe”

**Não** é marca canónica. Opcional numa linha do guia pt-BR (“também referido informalmente como…”) — **fora** do README EN. Evita duas marcas em discovery global.

## Risks / Trade-offs

| Risco | Mitigação |
|-------|-----------|
| Renomear pasta `sdd-kit/` quebra consumidores, CI, MANIFEST, checksums | **Proibido** neste change (D1) |
| Confusão ByeByeVibe vs path `sdd-kit/` | Glossário 1 linha no README + kit intro (D2) |
| Tom “ByeBye” parecer toy vs Spec Kit | Subtítulo + anti-boilerplate + stack nomeada nas primeiras linhas (já no README) |
| Atrai Camada B (vibe template seekers) | Anti-posicionamento acima da dobra (spec discovery) |
| Repo rename parte remotes/CI badges/links | Checklist manual + actualizar links vivos pós-rename; GitHub faz redirect temporário do slug antigo |
| Grep/gates que exigem texto “SDD Install Kit” no H1 | Actualizar gates das tasks deste change; rever `verify-task-patterns` / tasks antigas só se falharem |
| Echo/scripts ainda dizem “SDD Install Kit” | Cosmético — opcional D3; não quebra install |
| Index GitNexus `gitnexus-graphify-openspec` | Documentar; reindex/`gitnexus analyze` após rename de repo se necessário — não bloqueia docs |
| MANIFEST sha256 | Só regenerar se templates editados; rename de comentários em scripts **não** no MANIFEST files list normalmente |
| Links autor errados / PII a mais | Só URLs públicas que o Pedro fornecer; sem email/telefone |
| Double work se i18n antes do nome | Já respeitado: nome **antes** de tradução total (§11) |

### Bugs / armadilhas concretas no apply

1. **Substituir em massa `sdd-kit` → `byebyevibe`** — quebraria todos os comandos. Apply só troca **display strings**, não paths.
2. **Atualizar só README e esquecer About checklist** — discovery GitHub fica inconsistente.
3. **Atualizar evaluation P10 para Adoptado sem merge do rename de repo** — P10 docs pode ser Adoptado; rename GitHub fica `[AÇÃO MANUAL]` pendente (dois estados).
4. **Alterar `AGENTS.md` GitNexus index name** sem reindex — pode confundir agentes; preferir nota “repo público ByeByeVibe; index legado …” até reindex.
5. **Editar templates em `sdd-kit/templates/`** (ex. design docs com slug antigo) → **obrigatório** `bash sdd-kit/gen-manifest-checksums.sh` antes do commit.
6. **Inglês**: não reintroduzir typos (`engeneering`); manter copy D1 verbatim.

## Migration Plan

1. Apply docs/specs neste hub (display name + glossário + Maintainer placeholders).
2. Operador: fornecer URLs LinkedIn/portfólio → substituir placeholders (ou omitir links até lá).
3. **[AÇÃO MANUAL]** GitHub: Settings → General → **Rename** para `byebyevibe`; colar About; topics; Homepage opcional (portfólio ou vazio).
4. Operador: `git remote set-url origin git@github.com:pvilarim/byebyevibe.git` (ou HTTPS).
5. Actualizar links absolutos restantes nos docs vivos num follow-up micro se o rename ocorrer depois do merge.
6. Rollback docs: reverter PR; rollback GitHub: rename de volta (redirects).

## Open Questions

| # | Questão | Estado |
|---|---------|--------|
| Q1 | URLs exactas LinkedIn + portfólio? | **Aberta** — operador; placeholders até resposta |
| Q2 | Slug final `byebyevibe` vs `bye-bye-vibe`? | **Proposta:** `byebyevibe` |
| Q3 | Actualizar echoes/headers de scripts neste apply? | **Proposta:** sim, cosmético mínimo nos 4 scripts topo do kit (`install/upgrade/verify` + README kit) |
| Q4 | Mencionar “TchauVibe” no guia pt-BR? | **Proposta:** não neste change (evita dual brand) |

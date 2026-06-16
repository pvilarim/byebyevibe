# Sistema de Desenvolvimento Assistido por IA

**GitNexus + Graphify + OpenSpec, integrados no Cursor e VS Code + Claude Code**

> **Guia canónico de instalação (v1.2.0)** — usar em qualquer repositório Git, manualmente ou via agente de IA. Templates prontos a colar nos anexos 12.x.

## Como usar este documento

| Modo | Acção |
|------|--------|
| **Humano — instalação nova** | Seguir §2 na ordem indicada (2.1 → 2.8). |
| **Humano — actualização** | Seguir §2.9 (2.9.1 → 2.9.7); comparar ficheiros com §2.9.5 e §12.8. |
| **Agente de IA — instalação** | Executar o prompt em §2.0; aplicar templates 12.1–12.2 conforme perfil do repo. |
| **Agente de IA — actualização** | Executar o prompt em §2.9.2; produzir relatório §12.8 **antes** de editar ficheiros curados. |
| **Piloto / teste** | Após instalar ou actualizar, validar com checklist §2.8 ou §2.9.7. |

- **Padrão `AGENTS.md`:** alinhado a [agents.md](https://agents.md/) + workshop TLC (Context Engineering, on-demand loading).
- **Versão do guia:** 1.2.0 — ver [Changelog do guia](#changelog-do-guia).
- **Não substitui** `openspec/project.md` (constituição do projecto) nem specs em `openspec/specs/`.

---

## Aviso prévio honesto sobre fricção real

Antes de qualquer coisa: as três ferramentas geram ou modificam `AGENTS.md`/`CLAUDE.md` quando são instaladas. Sem governação explícita isto cria conflitos — uma ferramenta sobrescreve o que a outra escreveu. Este guia resolve isso com **um único `AGENTS.md` curado por ti**, com as três ferramentas a ser instaladas com flags que evitam sobrescrita. Vê secção 4 e 9 para detalhes.

Segunda fricção: o ecossistema move-se depressa. Versões neste documento são as de Maio 2026. Comandos básicos são estáveis; flags exóticas podem mudar — confirma em `--help` antes de automatizar.

---

## Índice

1. [Pré-requisitos](#1-pré-requisitos-questão-6)
2. [Passo a passo de instalação](#2-passo-a-passo-de-instalação-questão-1) — inclui §2.0 (IA), §2.5 (AGENTS.md), §2.8 (verificação), §2.9 (actualização)
3. [Classificação de tarefas e pipelines](#3-classificação-de-tarefas-e-pipelines-questões-2-3-31)
4. [Tabela mestre: ferramenta × responsabilidade × I/O](#4-tabela-mestre-questão-3)
5. [Documentos e referências cruzadas](#5-documentos-e-referências-cruzadas-questão-32)
6. [Dimensão de research e prevenção de fontes duvidosas](#6-dimensão-de-research-questão-33)
7. [Protocolos por tarefa: tokens, alucinações, segurança, auditoria](#7-protocolos-por-tarefa-questão-34)
8. [Regras gerais do sistema e onde vivem](#8-regras-gerais-do-sistema-questão-4)
9. [Configuração Cursor](#9-configuração-cursor-questão-5)
10. [Configuração VS Code + Claude Code](#10-configuração-vs-code--claude-code-questão-5)
11. [Protocolos de código](#11-protocolos-de-código-questão-7)
12. [Anexos: templates completos](#12-anexos-templates-completos)
13. [Alinhamento workshop ↔ agents.md](#13-alinhamento-workshop--agentsmd)
14. [Integrações futuras (Cline)](#14-integrações-futuras-cline)
15. [Changelog do guia](#changelog-do-guia)

---

## 1. Pré-requisitos (questão 6)

### 1.1 Sistema operativo e runtimes

| Componente | Versão mínima | Notas |
|---|---|---|
| OS | macOS 13+, Ubuntu 22.04+, Windows 11 + WSL2 | Windows nativo funciona mas WSL2 evita 80% dos problemas |
| Node.js | 20.19.0+ | Obrigatório para OpenSpec e GitNexus |
| Python | 3.10+ | Obrigatório para Graphify |
| Git | 2.40+ | Obrigatório para hooks de auto-rebuild |
| Build tools | `python3 make g++` (Linux), Xcode CLT (macOS) | GitNexus precisa para tree-sitter; podes saltar com `GITNEXUS_SKIP_OPTIONAL_GRAMMARS=1` |

### 1.2 Ferramentas de instalação recomendadas

```bash
# uv para Python (mais rápido que pip, gere PATH automaticamente)
curl -LsSf https://astral.sh/uv/install.sh | sh

# pnpm para Node (opcional mas recomendado)
npm install -g pnpm
```

### 1.3 IDEs

- **Cursor** ≥ 1.0 (a versão actual já suporta `.cursor/rules/*.mdc` com frontmatter YAML)
- **VS Code** ≥ 1.109 (Fev 2026 — leitura nativa de `CLAUDE.md`, `.claude/rules`, `.claude/agents`, `.claude/skills`)
- **Claude Code CLI** ≥ 2.1.140 (Maio 2026 — extensão VS Code é casca sobre o CLI)

### 1.4 Subscrição

Claude Pro/Max OU API key Anthropic. Sem isto, Claude Code não funciona. OpenSpec, GitNexus e Graphify são open source e gratuitos — só pagas o motor LLM por trás.

### 1.5 Conhecimento prévio mínimo

- Saber editar JSON e YAML
- Confortável em terminal (vais usar bastante `cd`, `npm`, `pip`, `git`)
- Compreender MCP a alto nível (o protocolo que liga as ferramentas ao agente)

---

## 2. Passo a passo de instalação (questão 1)

### 2.1 Ordem importa

Instala nesta ordem específica. **Não inverter** — cada passo assume que o anterior está feito:

```
1. OpenSpec    → 2. GitNexus    → 3. Graphify    → 4. Curar AGENTS.md    → 5. Configurar IDEs
```

A razão: OpenSpec gera o esqueleto `openspec/`, GitNexus indexa código e cria `AGENTS.md` inicial, Graphify adiciona contexto não-código. Se inverteres, ferramentas posteriores podem sobrescrever ficheiros criadas antes.

### 2.0 Instalação assistida por IA (prompt)

Cola este prompt na raiz do repositório alvo (substitui `REPO_ROOT` e o perfil):

```
Instala o sistema SDD (OpenSpec + GitNexus + Graphify) neste repositório seguindo
estritamente o guia em doc/sistema-sdd-pedro.md v1.2 (ou o caminho onde o guia
estiver no repo).

Perfil do repositório: [APP | DOCS_SPECS | HYBRID]
- APP = aplicação com npm/pnpm dev, testes, deploy
- DOCS_SPECS = specs, documentação, scripts (sem npm run dev na raiz)
- HYBRID = ambos

Ordem: openspec init --tools "cursor,claude" → gitnexus setup → gitnexus analyze
→ graphify install + graphify install --platform cursor → graphify hook install
→ graphify update . (ou graphify extract . se houver API key LLM)
→ curar AGENTS.md com template 12.2a (APP) ou 12.2b (DOCS_SPECS) — NÃO gerar
AGENTS.md do zero com IA; NÃO colar blocos <!-- gitnexus:start --> completos.

Entregar: checklist §2.8 preenchida + lista de ficheiros criados/alterados.
```

### 2.2 Passo 1 — OpenSpec (intenção)

```bash
# Instalação global
npm install -g @fission-ai/openspec@latest

# Verificação
openspec --version          # Esperar 1.3.1 ou superior

# Inicializar no projecto
cd ~/projects/meu-repo   # raiz do repo alvo
openspec init --tools "cursor,claude"

# Modo não-interactivo: gera comandos opsx em .cursor/ e .claude/
# Adiciona outras ferramentas separadas por vírgula se necessário (ver openspec init --help)
```

O que isto cria:
```
openspec/
├── project.md              # Editar manualmente: stack, convenções, decisões arquitecturais
├── AGENTS.md               # GERADO — NÃO EDITAR (regenerado por openspec update)
├── specs/                  # Vazio inicialmente; cresce com archive
└── changes/                # Vazio inicialmente; cresce com propose
.claude/commands/opsx-*.md  # Slash commands do OpenSpec para Claude Code
.cursor/commands/opsx-*.md  # Slash commands do OpenSpec para Cursor
```

**Acção obrigatória após init**: editar `openspec/project.md`. Este ficheiro é a Constituição do projecto. Sem ele bem escrito, OpenSpec não dá benefício real. Vê template no anexo 12.1.

### 2.3 Passo 2 — GitNexus (código)

```bash
# Instalação global
npm install -g gitnexus

# Verificação
gitnexus --version          # Esperar 1.4.8 ou superior

# Setup MCP one-time (configura ~/.cursor/mcp.json e claude-code)
gitnexus setup

# Indexar o repo (correr a partir da raiz do repo)
cd ~/projects/multi-agent-bot
gitnexus analyze

# Para reindexar após mudanças significativas:
gitnexus analyze --force

# Para gerar wiki LLM-powered:
gitnexus wiki
```

O que isto cria:
```
.gitnexus/                   # Base de dados local (gitignored)
~/.gitnexus/registry.json    # Registo global de repos indexados
~/.cursor/mcp.json           # GitNexus registado como MCP server
~/.cursor/skills/            # Skills do GitNexus para Cursor
~/.claude/skills/            # Skills do GitNexus para Claude Code
~/.claude/hooks/             # PreToolUse hooks que enriquecem grep/glob com graph
AGENTS.md                    # CRIADO ou MODIFICADO — atenção a conflito (ver §4)
CLAUDE.md                    # CRIADO ou MODIFICADO — atenção a conflito
```

**Atenção**: se já tens `AGENTS.md` curado, **renomeia-o antes** (`AGENTS.tools-generated.md`), corre `gitnexus analyze`, depois aplica o template **12.2** — **não** copies o bloco completo `<!-- gitnexus:start -->` para o canónico (ver §2.5.1). O detalhe operacional vive nas skills em `.claude/skills/gitnexus/`.

### 2.4 Passo 3 — Graphify (conhecimento)

```bash
# Instalação via uv (recomendado — coloca CLI no PATH automaticamente)
uv tool install graphifyy

# Verificação
graphify --version          # Esperar 0.8.4 ou superior

# Instalar skill no Claude Code
graphify install            # auto-detecta plataforma; macOS/Linux

# Instalar skill no Cursor
graphify install --platform cursor

# Instalar skill no VS Code (Claude Code extension)
graphify vscode install

# Instalar hook git para rebuild automático em commits
graphify hook install

# Construir grafo inicial — a partir da raiz do repo
cd ~/projects/meu-repo
graphify update .           # AST + estrutura (sem API key LLM)

# Com API key (ANTHROPIC/GEMINI/etc.) para semântica completa:
# graphify extract . --max-workers 4

# Vault Obsidian ou pasta externa (opcional):
# graphify extract /caminho/para/vault --out graphify-out-vault
```

O que isto cria:
```
graphify-out/
├── graph.json              # O grafo serializado
├── GRAPH_REPORT.md         # Resumo legível por humanos e LLMs
├── graph.html              # Visualização interactiva no browser
└── .graphify_root          # Ponteiro para o root do projecto
~/.claude/skills/graphify/  # SKILL.md instalado
~/.cursor/skills/graphify/  # SKILL.md instalado
AGENTS.md                   # MODIFICADO — atenção a conflito (ver §4)
```

**Atenção idêntica ao GitNexus**: no `AGENTS.md` canónico, resume Graphify em 2–3 linhas (ler `GRAPH_REPORT.md`, `graphify update .` após código). Detalhe em `CLAUDE.md` / `.cursor/rules/graphify.mdc` se instalados.

### 2.5 Passo 4 — Curar o `AGENTS.md` único

Este é o passo crítico. Ferramentas geram ou alteram `AGENTS.md`/`CLAUDE.md` — o canónico é **curado por ti**, com template **12.2a** (app) ou **12.2b** (docs/specs).

```bash
# 1. Preserva output automático
mv AGENTS.md AGENTS.tools-generated.md 2>/dev/null || true
echo "AGENTS.tools-generated.md" >> .gitignore
echo "CLAUDE.tools-generated.md" >> .gitignore

# 2. Cria AGENTS.md a partir do anexo 12.2a ou 12.2b (NÃO pedir à IA para inventar)
$EDITOR AGENTS.md

# 3. CLAUDE.md mínimo: apontar para ./AGENTS.md (template §10.3)
```

**O `AGENTS.md` canónico DEVE conter (formato alvo v1.1):**

| Secção | Conteúdo |
|--------|----------|
| Contexto | Aponta `./openspec/project.md` — **não** duplicar stack |
| **Commands** | Tabela de comandos reais deste repo (dev, test, openspec, gitnexus, graphify) |
| Fontes de conhecimento | Ordem 1–7 (§5.2) |
| **Contexto sob demanda** | Tabela situação → ficheiro (§2.5.3) |
| Protocolo A–E + R1–R9 | §3 e §8.2 |
| Workflow OpenSpec | `/opsx:*`, graphify update, gitnexus analyze |
| **Integrações** | GitNexus + Graphify em ≤10 linhas cada; ponte para skills |
| Segurança + comunicação | §7 |

**Meta:** ~100–150 linhas. Se `gitnexus analyze` ou `graphify install` voltarem a injectar blocos longos, **remover** e manter só o resumo em Integrações.

#### 2.5.1 Anti-padrões (não adoptar no `AGENTS.md` canónico)

| Anti-padrão | Porquê | Em vez disso |
|-------------|--------|--------------|
| Pedir à IA para gerar o `AGENTS.md` inicial | Ficheiro gigante, genérico, context rot | Template 12.2 + edição humana iterativa |
| Colar bloco `<!-- gitnexus:start -->` completo | Duplica skills; +40 linhas sempre no contexto | §2.5 Integrações + skills lazy |
| Duplicar stack de `openspec/project.md` | Drift em 3 meses | Apontar para `project.md` |
| YAML AAIF (`agent.name`, `compliance`) | Overhead; não usado por Cursor/Claude | Markdown livre ([agents.md](https://agents.md/)) |
| Mover tudo para `AGENTS.md` e apagar `.mdc` | Cursor perde auto-attach por glob | `AGENTS.md` + `.cursor/rules/*.mdc` |
| `AGENTS.md` > 200 linhas sem razão | Confunde modelo; custo de tokens | Quebrar em docs referenciados + Skills |

#### 2.5.2 Perfis de repositório

| Perfil | Sinais | Template Commands | `AGENTS.md` aninhado |
|--------|--------|-------------------|----------------------|
| **APP** | `package.json`, `npm run dev`, app Next/etc. | `dev`, `test`, `lint`, `build` (nota: não correr build em sessão agente se agents.md assim disser) | Por package em monorepos |
| **DOCS_SPECS** | `openspec/`, `doc/`, sem app na raiz | `openspec list`, `gitnexus status`, `graphify update .` | `doc/**/scripts/`, pastas com tooling próprio |
| **HYBRID** | App + `openspec/` + `doc/` | Combinar ambas tabelas no Commands | Ambos |

#### 2.5.3 Contexto sob demanda (mapa no `AGENTS.md`)

Incluir tabela como esta (adaptar paths ao repo):

```markdown
## Contexto sob demanda

| Situação | Carregar |
|----------|----------|
| Stack, convenções, non-goals | `openspec/project.md` |
| Requisitos por capability | `openspec/specs/` |
| Change em curso | `openspec/changes/<id>/` |
| Relações entre conceitos / teoria | `graphify-out/GRAPH_REPORT.md` |
| Legado: entender codebase | Perguntar padrões AS-IS **sem criar ficheiros**; depois documentar |
| Convenções TS/Python/DB (ficheiro aberto) | `.cursor/rules/010-*.mdc`, etc. |
| Guia SDD completo (instalação) | `doc/sistema-sdd-pedro.md` |
```

#### 2.5.4 `AGENTS.md` aninhados ([agents.md](https://agents.md/))

Criar `AGENTS.md` em subpastas com lógica própria (scripts, packages). O agente usa o ficheiro **mais próximo** do ficheiro editado. Ver template **12.7**.

### 2.6 Passo 5 — Verificar configuração MCP

```bash
# Cursor: verifica que os dois servidores MCP estão registados
cat ~/.cursor/mcp.json
# Deve mostrar gitnexus e (se usaste graphify mcp) graphify

# Claude Code: lista os MCPs activos
claude mcp list
# Deve mostrar gitnexus

# Testa GitNexus
gitnexus status              # Deve mostrar o repo indexado

# Testa Graphify
ls graphify-out/             # Deve ter graph.json e GRAPH_REPORT.md
```

### 2.7 Passo 6 — Sanity check end-to-end

Abre Claude Code ou Cursor e tenta:

```
/opsx:propose adicionar validação de input no endpoint /users
```

Deves ver o agente a criar `openspec/changes/add-user-input-validation/` com `proposal.md`, `design.md`, `tasks.md` e `specs/`. Se o agente também consultar GitNexus/Graphify durante a propose-phase (lê código existente e contexto), os três stacks estão integrados.

Se algo falhar: corre `gitnexus status`, verifica que `mcp.json` está correcto, e relê AGENTS.md.

### 2.8 Verificação pós-instalação (checklist)

Usar após cada instalação (humano ou IA):

- [ ] `openspec/project.md` editado com Purpose, Stack, Cross-references
- [ ] `AGENTS.md` existe, ≤150 linhas, **sem** bloco duplicado `<!-- gitnexus:start -->`
- [ ] `AGENTS.tools-generated.md` e `CLAUDE.tools-generated.md` no `.gitignore`
- [ ] `CLAUDE.md` aponta para `./AGENTS.md` (≤25 linhas úteis)
- [ ] `.cursor/rules/000-base.mdc` e `050-security.mdc` presentes
- [ ] `npx openspec list` corre sem erro
- [ ] `npx gitnexus status` → index up-to-date
- [ ] `graphify-out/GRAPH_REPORT.md` existe (após `graphify update .`)
- [ ] `/opsx:propose` (ou `npx openspec new change teste`) cria change
- [ ] IDE reiniciada (slash commands e skills)
- [ ] Perfil APP/DOCS_SPECS reflectido na tabela Commands do `AGENTS.md`

### 2.9 Actualização de instalação existente

Usar quando o repositório **já tem** OpenSpec, GitNexus e/ou Graphify configurados e o objectivo é **actualizar** para uma nova versão do guia ou das ferramentas — **não** repetir §2 como instalação verde.

#### 2.9.1 Quando usar e o que não fazer

| Situação | Acção |
|----------|--------|
| Primeira vez no repo | §2.1 → §2.8 (instalação nova) |
| Nova versão do guia (`v1.1` → `v1.2`, etc.) | §2.9 |
| Só CLIs desactualizadas, ficheiros curados OK | §2.9.4 (ferramentas) + §2.9.7 parcial |
| `openspec/` ausente | Instalação nova (§2) |

**Nunca na actualização:**

- Correr `openspec init` de novo (pode duplicar ou conflitar harness).
- Substituir `AGENTS.md` / `openspec/project.md` pelo output de `gitnexus analyze`, `graphify install` ou `openspec update`.
- Aplicar templates §12 por cima de conteúdo local **sem** relatório de diff (§12.8).
- `git push --force` na branch de actualização.

#### 2.9.2 Detecção da versão instalada

Antes de actualizar, registar no relatório (§12.8):

```bash
# Versão do guia referenciada no repo (se existir)
grep -E 'sistema-sdd-pedro\.md|Guia de instalação SDD' openspec/project.md || true

# Versões das ferramentas
openspec --version 2>/dev/null || npx openspec --version
gitnexus --version
graphify --version

# Sinais de instalação SDD
test -d openspec && echo "openspec: OK"
test -f AGENTS.md && wc -l AGENTS.md
test -d .cursor/rules && ls .cursor/rules/*.mdc 2>/dev/null | wc -l
```

| Campo | Onde ler |
|-------|----------|
| Versão do guia no repo | `openspec/project.md` → Cross-references (`doc/sistema-sdd-pedro.md` **vX.Y.Z**) |
| Versão alvo | Cabeçalho deste documento ou changelog §14 |
| Perfil | APP / DOCS_SPECS / HYBRID (§2.5.2) — inferir de `package.json`, Commands em `AGENTS.md` |

Se `openspec/project.md` não referencia versão do guia, assumir **desconhecida** e tratar merge como **conservador** (manter texto local; só acrescentar secções novas do template).

#### 2.9.3 Actualização assistida por IA (prompt)

Cola na raiz do repositório alvo (substitui `VERSÃO_ALVO` e confirma caminho do guia):

```
Actualiza a instalação SDD existente neste repositório para o guia
doc/sistema-sdd-pedro.md VERSÃO_ALVO (ex.: v1.2.0).

NÃO é instalação nova — seguir estritamente §2.9 do guia.

Ordem obrigatória:
1. Criar branch `chore/upgrade-sdd-VERSÃO_ALVO`.
2. §2.9.2 — registar versão actual (project.md, --version das ferramentas).
3. §2.9.5 — extrair templates do guia para
   `openspec/changes/upgrade-sdd-VERSÃO_ALVO/sdd-staging/` (ficheiros da matriz).
4. Correr `./scripts/sdd-upgrade-diff.sh openspec/changes/upgrade-sdd-VERSÃO_ALVO/sdd-staging/`
5. Preencher `openspec/changes/upgrade-sdd-VERSÃO_ALVO/UPGRADE_REPORT.md` (template §12.8)
   com classificação por ficheiro: KEEP_LOCAL | MERGE | APPLY_TEMPLATE | NEW | SKIP.
6. PARAR e apresentar o relatório ao utilizador. Não editar ficheiros curados até aprovação
   explícita (ou instrução "aplicar MERGE/APPLY_TEMPLATE").
7. Após aprovação: §2.9.4 (actualizar CLIs e harness gerado).
8. Aplicar apenas linhas/ficheiros aprovados no relatório; preservar Purpose, Stack, Commands
   e regras específicas do repo.
9. Actualizar referência em `openspec/project.md` para VERSÃO_ALVO.
10. §2.9.7 checklist + commit `chore(sdd): upgrade to guia vX.Y.Z`.

Regras de merge (§2.9.6):
- AGENTS.md: manter Commands e entradas locais da tabela "Contexto sob demanda";
  sincronizar secções normativas (A–E, R1–R9, Integrações) com template 12.2.
- openspec/project.md: NUNCA substituir Purpose/Stack/Architecture; só actualizar
  Cross-references e secções novas do template 12.1.
- .cursor/rules/*.mdc: APPLY_TEMPLATE só para 000-base e 050-security se o guia
  indicar breaking change; 010/020/030 — MERGE ou KEEP_LOCAL.
- CLAUDE.md: manter ≤25 linhas; template §10.3.

Entregar: UPGRADE_REPORT.md + lista de ficheiros alterados + diff resumido.
```

#### 2.9.4 Actualização das ferramentas (sem tocar ficheiros curados)

Executar **depois** do staging/diff e **antes** do merge aprovado nos ficheiros curados (ou em paralelo se o relatório já estiver pronto):

```bash
# 1. CLIs globais
npm install -g @fission-ai/openspec@latest
npm install -g gitnexus
uv tool upgrade graphifyy 2>/dev/null || uv tool install graphifyy

# 2. Preservar AGENTS.md canónico
cp AGENTS.md /tmp/AGENTS.md.backup 2>/dev/null || true
cp CLAUDE.md /tmp/CLAUDE.md.backup 2>/dev/null || true

# 3. Harness OpenSpec (regenera .cursor/commands, .claude/commands, openspec/AGENTS.md gerado)
cd REPO_ROOT
openspec update

# 4. Restaurar canónicos se ferramentas sobrescreveram
if grep -q 'gitnexus:start' AGENTS.md 2>/dev/null; then
  mv AGENTS.md AGENTS.tools-generated.md
  cp /tmp/AGENTS.md.backup AGENTS.md
fi

# 5. GitNexus + Graphify
gitnexus setup          # idempotente; actualiza MCP/skills globais
gitnexus analyze --force
graphify install
graphify install --platform cursor
graphify hook install
graphify update .

# 6. Confirmar versões
openspec --version && gitnexus --version && graphify --version
```

Ficheiros **gerados** (seguro sobrescrever com `openspec update`):

| Caminho | Notas |
|---------|--------|
| `.cursor/commands/opsx-*.md` | Slash commands Cursor |
| `.claude/commands/opsx-*.md` | Slash commands Claude Code |
| `openspec/AGENTS.md` | Gerado pelo OpenSpec — **não** confundir com `AGENTS.md` raiz |

#### 2.9.5 Matriz de comparação (existente vs template)

Para cada ficheiro **curado**, o agente (ou humano) compara o que está no repo com o template indicado. Usar staging + script:

```bash
# Extrair templates do guia para staging (agente cria ficheiros a partir de §12 / §9 / §10)
mkdir -p openspec/changes/upgrade-sdd-v1.2.0/sdd-staging/.cursor/rules

# Exemplo: copiar conteúdo de 12.2 + 12.2b para staging/AGENTS.md, etc.

chmod +x scripts/sdd-upgrade-diff.sh
./scripts/sdd-upgrade-diff.sh openspec/changes/upgrade-sdd-v1.2.0/sdd-staging/
```

| Ficheiro no repo | Template no guia | Tipo de merge | O que comparar |
|------------------|------------------|---------------|----------------|
| `AGENTS.md` | §12.2 + §12.2a ou §12.2b | MERGE | Secções normativas vs Commands/contexto local; linhas ≤150; sem `gitnexus:start` |
| `openspec/project.md` | §12.1 | MERGE conservador | Purpose, Stack, Architecture, Constraints — **manter local**; Cross-references e versão do guia — **actualizar** |
| `CLAUDE.md` | §10.3 | MERGE | Delegação para `AGENTS.md`; não duplicar blocos longos |
| `.cursor/rules/000-base.mdc` | §9.2 | APPLY ou MERGE | Apontar para `AGENTS.md`; referência a `/opsx:propose` |
| `.cursor/rules/050-security.mdc` | §9.2 | APPLY ou MERGE | Guardrails; alinhar se guia adicionou regra nova |
| `.cursor/rules/010-typescript.mdc` | §9.2 | KEEP ou MERGE | Opcional; só se repo usa TS |
| `.cursor/rules/020-python.mdc` | §12.5 | KEEP ou MERGE | Opcional |
| `.cursor/rules/030-supabase.mdc` | §12.5 | KEEP ou MERGE | Opcional |
| `.cursor/rules/graphify.mdc` | §4 / integração Graphify | MERGE | Resumo `graphify update`; não duplicar skill |
| `doc/**/AGENTS.md` (aninhados) | §12.7 | KEEP_LOCAL | Preservar; só actualizar se guia mudou formato aninhado |

**Classificações** (usar em `UPGRADE_REPORT.md`):

| Tag | Significado |
|-----|-------------|
| `KEEP_LOCAL` | Manter ficheiro actual; nenhuma alteração |
| `MERGE` | Unir manualmente: template fornece secções novas; repo mantém especificidades |
| `APPLY_TEMPLATE` | Substituir por template (só 000-base / 050-security quando changelog do guia manda) |
| `NEW` | Ficheiro não existe no repo; criar a partir do template |
| `SKIP` | Não aplicável a este perfil (ex.: 030-supabase sem Supabase) |

#### 2.9.6 Regras de merge por ficheiro

**`AGENTS.md`**

1. Começar pelo ficheiro **local** (não pelo template).
2. Do template 12.2, sincronizar: Fontes de conhecimento, Protocolo A–E, R1–R9, Workflow, Integrações (resumo), Segurança.
3. **Não** apagar linhas da tabela Commands nem entradas extra em "Contexto sob demanda".
4. Se após merge >150 linhas, mover detalhe para `doc/` ou skills — não inflar o canónico.

**`openspec/project.md`**

1. Preservar integralmente: Purpose, Stack, Architecture, Conventions, Constraints, Non-goals.
2. Actualizar: linha `Guia de instalação SDD` em Cross-references para a versão alvo.
3. Se o template 12.1 tiver secção **nova** (ex.: campo que não existia em v1.0), **acrescentar** com placeholder `[PREENCHER]` — não inventar conteúdo.

**`.cursor/rules/*.mdc`**

1. `000-base` e `050-security`: diff linha a linha; aplicar mudanças de segurança do guia.
2. Regras por glob (`010`, `020`, `030`): só actualizar se o projeto usa essa stack; caso contrário `SKIP`.

**`CLAUDE.md`**

1. Máximo ~25 linhas úteis; deve apontar para `./AGENTS.md`.
2. Se GitNexus injectou bloco longo, mover para `CLAUDE.tools-generated.md` e restaurar template §10.3.

#### 2.9.7 Checklist pós-atualização

Repetir §2.8 e acrescentar:

- [ ] `UPGRADE_REPORT.md` arquivado em `openspec/changes/upgrade-sdd-*/` (ou commitado no change)
- [ ] Versão do guia em `openspec/project.md` actualizada (ex.: **v1.2.0**)
- [ ] `AGENTS.md` sem regressão (Commands locais intactos; sem `gitnexus:start`)
- [ ] Backups `/tmp/*.backup` ou branch permitem rollback
- [ ] `openspec update` aplicado; slash commands `/opsx:*` funcionam após reiniciar IDE
- [ ] `gitnexus analyze --force` e `graphify update .` executados
- [ ] Changelog do guia §14 lido para **breaking changes** da versão alvo

---

## 3. Classificação de tarefas e pipelines (questões 2, 3, 3.1)

### 3.1 Não há *uma* pipeline. Há cinco.

A tua intuição na conversa anterior estava correcta: forçar todos os trabalhos pelo mesmo fluxo é exagero para uns e insuficiente para outros. Define-se cinco tipos de trabalho, cada um com a sua pipeline:

#### Tipo A — Trivial (sem spec, sem research)
**Detecção**: prompt curto, mudança óbvia, sem implicação arquitectural.
Ex: "corrige este typo", "renomeia esta variável para `userEmail`", "actualiza versão do package no `package.json`".
**Pipeline**: directa → implementar → testar
**Ferramentas envolvidas**: nenhuma das três (Claude Code edita directamente).

#### Tipo B — Bug fix definido
**Detecção**: erro reproduzível, ficheiro/função conhecida, sem ambiguidade na causa.
Ex: "o endpoint X está a retornar 500 quando Y, deveria retornar 400".
**Pipeline**: framing leve → **GitNexus (blast radius)** → patch → testar
**Ferramentas envolvidas**: GitNexus apenas (para garantir que o fix não parte algo a jusante).
**OpenSpec/Graphify**: não.

#### Tipo C — Refactor de módulo existente
**Detecção**: "refactor", "extrair", "mover", "renomear símbolo global", "consolidar".
Ex: "extrai a lógica de autenticação para um serviço dedicado".
**Pipeline**: framing → **GitNexus (AS-IS)** → **OpenSpec (proposal + design)** → implementar
**Ferramentas envolvidas**: GitNexus + OpenSpec.
**Graphify**: opcional, só se o refactor envolver decisões teóricas.

#### Tipo D — Feature nova com base teórica (caso central do Pedro)
**Detecção**: "implementa X baseado em Y framework/teoria/conceito", "novo módulo de Z", referência a docs internos ou papers.
Ex: "implementa sistema de associação de conceitos KBS no RAG", "adiciona análise solar baseada nos princípios Ladybug".
**Pipeline**: framing → **Graphify (research teoria) + GitNexus (AS-IS) em paralelo** → human review gate → **OpenSpec (propose informado)** → human review gate → implementar
**Ferramentas envolvidas**: as três.
**Gates humanos**: dois — após research, e após spec.

#### Tipo E — Exploração / R&D
**Detecção**: "investiga", "explora", "compara X vs Y", "viabilidade de…".
Ex: "qual a melhor abordagem para integrar Blender MCP no nosso pipeline?".
**Pipeline**: framing → **Graphify (procura o que já existe e foi documentado)** → produzir `research.md` em `openspec/changes/explore-<topic>/`
**Ferramentas envolvidas**: Graphify principal, OpenSpec apenas para arquivar o estudo.
**Saída**: documento, não código. Decisão de implementar é uma tarefa Tipo C ou D *separada*.

### 3.2 Detecção automática vs declaração explícita

**Recomendação: usa declaração explícita.** Detecção automática a partir de prompt genérico é tentadora mas falível — um prompt como "ajuda com o sistema de auth" pode ser Tipo A (typo) ou Tipo D (refactor profundo) dependendo do contexto que tu tens na cabeça e o agente não tem.

O AGENTS.md deve ter um bloco que ensina o agente a **perguntar antes**:

```markdown
## Task Type Detection Protocol

Before starting ANY work, classify the task using this decision tree:

1. Is the change literally one line, with no semantic risk? → Type A. Proceed.
2. Is the change a localized bug fix with a known root cause? → Type B. Run GitNexus impact check first.
3. Does the change restructure existing code without new behavior? → Type C. Open OpenSpec proposal.
4. Does the change introduce new behavior grounded in our knowledge base, theory, or external research? → Type D. Run Graphify + GitNexus research first.
5. Is the request to investigate/compare/decide, not to implement? → Type E. Graphify research only, no code.

If unsure between two types, ASK the user which type before proceeding.
NEVER skip classification. NEVER assume Type A by default.
```

### 3.3 Tarefas paralelas e isolamento de contexto

Quando há paralelismo (Tipo D), as duas threads de research devem rodar em **subagents isolados** para evitar contaminação de contexto:

- **Claude Code**: cria `.claude/agents/graphify-researcher.md` e `.claude/agents/codebase-researcher.md`. Cada subagent tem o seu próprio contexto, retorna apenas o sumário, e não polui o agente principal.
- **Cursor**: usa o Explore agent built-in para um lado, e prompt directo no Composer para outro — ou abre dois worktrees git e duas sessões.

A síntese acontece *após* os dois subagents terminarem, no agente principal, com base nos dois `.md` produzidos.

### 3.4 Pipeline visual completa

```
                                 PROMPT do utilizador
                                          │
                                          ▼
                          ┌────────────────────────────────┐
                          │  Classificação do tipo (A-E)   │
                          │  (com pergunta se ambíguo)     │
                          └────────────────────────────────┘
                                          │
        ┌─────────────┬───────────────────┼───────────────────┬─────────────┐
        ▼             ▼                   ▼                   ▼             ▼
     Tipo A        Tipo B              Tipo C              Tipo D         Tipo E
   directo      GitNexus only      GitNexus + OS      Graphify ∥ GitNexus  Graphify
        │             │                   │                   │             │
        │             ▼                   ▼                   ▼             ▼
        │       impact check         AS-IS doc         knowledge.md +   research.md
        │             │                   │             codebase.md         │
        │             │                   │                   │             ▼
        │             │                   │              ⊕ human gate   arquivar
        │             │                   │                   │             em
        │             │                   │           /opsx:propose      openspec/
        │             │                   │                   │             changes/
        │             │             /opsx:propose       ⊕ human gate
        │             │                   │                   │
        │             │             ⊕ human gate         /opsx:apply
        │             │                   │                   │
        ▼             ▼            /opsx:apply                ▼
     edição        patch                  │            /opsx:archive
       ↓            ↓                     ▼                   │
     testes       testes           /opsx:archive              ▼
                                          │             /graphify --update
                                          ▼                  (loop)
                                  /graphify --update
                                       (loop)
```

A seta de feedback `/graphify --update` é o que torna o sistema **acumulativo**: cada spec arquivado entra no knowledge graph e fica disponível para próximas tarefas.

---

## 4. Tabela mestre (questão 3)

### 4.1 Responsabilidades

| Aspecto | OpenSpec | GitNexus | Graphify |
|---|---|---|---|
| **Domínio** | Intenção e decisões | Estrutura de código | Conhecimento multimodal |
| **Pergunta que responde** | "O quê e porquê?" | "Como o código está organizado, o que parte se eu mudar X?" | "O que já sei, decidi ou escrevi sobre Y?" |
| **Input principal** | Prompt humano + estado actual | Código-fonte (TS, Py, Go, Rust, Java, C/C++, Ruby, C#, Kotlin, Scala, PHP, Swift) | Qualquer pasta: código, docs, PDFs, imagens, vídeos, SQL, Obsidian, papers |
| **Output principal** | `openspec/changes/<id>/{proposal,design,tasks}.md` + `specs/` | Knowledge graph queryável (KuzuDB) + ferramentas MCP | `graph.json` + `GRAPH_REPORT.md` + `graph.html` + MCP |
| **Persistência** | Git (Markdown plano) | `.gitnexus/` local (gitignored), regenerável | `graphify-out/` local (gitignored), regenerável |
| **Trigger automático** | Slash commands (`/opsx:propose`, `/opsx:apply`, `/opsx:archive`) | PreToolUse hook (enriquece grep/glob) + queries diretas via MCP | PreToolUse hook (lê grafo antes de file-read) + queries via MCP |
| **Quando NÃO usar** | Tarefa Tipo A (trivial) | Tarefa Tipo E (research puro) | Tarefas só de código sem implicação teórica |
| **Sinal de problema** | Specs ficam desactualizados (não fazes archive) | Index stale (mudaste muito código sem reanalisar) | Grafo sem nodes para topic relevante |

### 4.2 Detecção pelo agente

Como o agente "sabe" qual ferramenta usar? Três mecanismos combinados:

1. **AGENTS.md** declara explicitamente quando cada ferramenta é consultada — ver template anexo 12.2.
2. **Hooks pré-tool** (Claude Code) interceptam comandos e enriquecem automaticamente. Ex: antes de qualquer `grep`, o hook do GitNexus injecta contexto de call chains relacionadas.
3. **Skill descriptions** — cada skill tem uma descrição que diz ao agente quando se auto-invocar. Ex: a skill do Graphify diz "use when investigating concepts, theory, or cross-domain relationships".

A combinação evita ter de escrever explicitamente "agora chama GitNexus" em cada prompt.

### 4.3 Inputs e outputs detalhados

```
┌──────────────────────────────────────────────────────────────────────────┐
│ OpenSpec                                                                 │
├──────────────────────────────────────────────────────────────────────────┤
│ INPUTS                                                                   │
│   • Prompt humano em /opsx:propose                                       │
│   • openspec/project.md (Constitution — sempre lido)                     │
│   • openspec/specs/*.md (specs vigentes)                                 │
│   • openspec/config.yaml (rules + context)                               │
│   • Opcionalmente: knowledge.md e codebase.md de fases de research       │
│                                                                          │
│ OUTPUTS                                                                  │
│   • openspec/changes/<change-id>/proposal.md   (porquê, escopo)          │
│   • openspec/changes/<change-id>/design.md     (decisões técnicas)       │
│   • openspec/changes/<change-id>/tasks.md      (checklist)               │
│   • openspec/changes/<change-id>/specs/        (delta specs ADDED/MOD)   │
│   • Após archive: openspec/specs/ actualizado + changes/archive/         │
└──────────────────────────────────────────────────────────────────────────┘

┌──────────────────────────────────────────────────────────────────────────┐
│ GitNexus                                                                 │
├──────────────────────────────────────────────────────────────────────────┤
│ INPUTS                                                                   │
│   • Código-fonte do repo                                                 │
│   • Configs de toolchain (tsconfig, go.mod, etc.)                        │
│                                                                          │
│ OUTPUTS (via MCP, não como ficheiros)                                    │
│   • query(text)         — busca semântica + textual                      │
│   • context(symbol)     — sumário de função/classe + vizinhança          │
│   • impact(target)      — blast radius upstream/downstream               │
│   • detect_changes()    — diff vs index, surfaces o que mudou            │
│   • rename(old, new)    — propor renaming seguro (sempre dry_run=true)   │
│   • cypher(query)       — query bruta ao grafo                           │
│                                                                          │
│ OUTPUTS COMPLEMENTARES (ficheiros)                                       │
│   • gitnexus wiki  → wiki/index.md + páginas por módulo                  │
└──────────────────────────────────────────────────────────────────────────┘

┌──────────────────────────────────────────────────────────────────────────┐
│ Graphify                                                                 │
├──────────────────────────────────────────────────────────────────────────┤
│ INPUTS                                                                   │
│   • Qualquer pasta (código, docs, vault, PDFs, imagens, vídeos)          │
│   • URLs (papers via arxiv, vídeos YouTube)                              │
│                                                                          │
│ OUTPUTS                                                                  │
│   • graphify-out/graph.json         — grafo serializado                  │
│   • graphify-out/GRAPH_REPORT.md    — sumário god-nodes + surpresas      │
│   • graphify-out/graph.html         — viz interactiva                    │
│   • Opcionalmente: --wiki produz markdown wiki + index.md                │
│                                                                          │
│ OUTPUTS via MCP                                                          │
│   • query_graph(text)          — busca semântica no grafo                │
│   • get_node(id)               — detalhe de um node                      │
│   • get_neighbors(id)          — vizinhança                              │
│   • shortest_path(a, b)        — relação entre dois conceitos            │
└──────────────────────────────────────────────────────────────────────────┘
```

---

## 5. Documentos e referências cruzadas (questão 3.2)

### 5.1 Hierarquia de documentos

Há quatro níveis. Cada um aponta para o seguinte. **As referências cruzadas são o que faz o sistema funcionar como um todo.**

```
Nível 1 — Constitution (raramente muda)
├── AGENTS.md                        ← entry point universal
├── openspec/project.md              ← stack + convenções + decisões
└── CLAUDE.md                        ← apenas referencia AGENTS.md
└── .cursor/rules/000-base.mdc       ← apenas referencia AGENTS.md

Nível 2 — Specs vigentes (muda com cada feature)
└── openspec/specs/<capability>/spec.md

Nível 3 — Mudanças em curso (efémero, vira spec quando archive)
└── openspec/changes/<change-id>/
    ├── proposal.md
    ├── design.md
    ├── tasks.md
    └── specs/

Nível 4 — Conhecimento (regenerável, mas referenciado)
├── graphify-out/GRAPH_REPORT.md     ← linkado de AGENTS.md
├── graphify-out/graph.json          ← consumido via MCP
└── .gitnexus/lbug                   ← consumido via MCP
```

### 5.2 Referências cruzadas obrigatórias

Cada ficheiro deve referenciar explicitamente os outros relevantes. Sem isto, o agente não sabe que existem.

**`AGENTS.md` deve conter** (templates completos em 12.2a / 12.2b):

- Secções obrigatórias: Contexto (aponta `project.md`), **Commands**, Fontes 1–7, **Contexto sob demanda**, Protocolo A–E, R1–R9, Workflow, **Integrações** (resumo), Segurança.
- Ver §2.5 e anti-padrões §2.5.1.

```markdown
## Fontes de conhecimento (por prioridade)

1. `./openspec/specs/` — requisitos actuais
2. `./openspec/changes/` — propostas e arquivo
3. `./graphify-out/GRAPH_REPORT.md` — knowledge graph
4. GitNexus via MCP — estrutura de código, impact
5. Graphify via MCP ou CLI `graphify query` — conceitos
6. Docs externos citados em `openspec/project.md`
7. Web search (último recurso)

## Contexto sob demanda

Ver tabela em §2.5.3 do guia de instalação (adaptar paths).
```

**`openspec/project.md` deve conter**:

```markdown
## Cross-references

- Code structure is indexed in `.gitnexus/` — use GitNexus MCP tools to navigate
- Knowledge base (theory, docs, vault) is in `graphify-out/` — see GRAPH_REPORT.md
- Active changes are in `openspec/changes/` — always check before starting new work
```

**`openspec/changes/<id>/design.md` deve, sempre que aplicável, citar**:

```markdown
## Knowledge sources consulted

- Graphify: <conceito1> → <conceito2> via shortest_path (graph.json:node:xyz)
- GitNexus: impact analysis on AuthService showed 12 downstream dependents
- Previous spec: openspec/specs/auth-session/spec.md
- Previous archived change: openspec/changes/archive/2026-03-15-add-jwt/
```

### 5.3 O que NÃO duplicar

Não copies stack ou convenções do `project.md` para o `AGENTS.md`. Aponta. A duplicação é a origem de drift — daqui a três meses tens duas versões da mesma regra em desacordo.

### 5.4 Quando regenerar referências

| Evento | Acção |
|---|---|
| Mudaste muito código | `gitnexus analyze` |
| Adicionaste docs/papers ao vault | `graphify . --update` |
| Acabaste uma feature | `/opsx:archive` (actualiza specs) |
| Onboarding novo dev/agente | Apenas garantir que abre o repo, AGENTS.md carrega tudo |
| Hook automático | `graphify hook install` faz rebuild em cada commit |

---

## 6. Dimensão de research (questão 3.3)

### 6.1 Quanto research é apropriado por tipo de tarefa

| Tipo | Tempo de research | Output esperado | Sinal de excesso |
|---|---|---|---|
| **A** | 0 | nenhum | qualquer research |
| **B** | < 5 min | impact check do GitNexus (1 query) | leste mais de 3 ficheiros |
| **C** | 15-30 min | AS-IS document de 1 página | mais de 500 linhas de notes |
| **D** | 1-3 horas | `knowledge.md` (≤ 1 página) + `codebase.md` (≤ 1 página) | mais de 5 god-nodes referenciados, mais de 10 ficheiros lidos |
| **E** | 2-8 horas | `research.md` com recomendação clara, alternativas, e riscos | research sem conclusão acionável |

### 6.2 Anti-padrões de research

- **Boil-the-ocean**: ler tudo o que é tangencialmente relevante. *Solução*: definir 3 perguntas concretas antes de começar; parar quando respondidas.
- **Confirmation bias**: research conduzido para validar uma decisão já tomada. *Solução*: forçar listagem de pelo menos 2 alternativas, mesmo que descartadas.
- **Research-without-output**: 2 horas a ler, zero linhas escritas. *Solução*: começar a escrever `research.md` em 30 min mesmo com lacunas.

### 6.3 Hierarquia de fontes — confiabilidade decrescente

```
1. Specs vigentes (openspec/specs/)              ← Verdade do projecto
2. Specs arquivados (openspec/changes/archive/)  ← Verdade histórica decidida
3. Knowledge graph do teu vault (Graphify)       ← Verdade tua, curada
4. GitNexus (código actual)                      ← Verdade do que está running
5. Docs externos referenciados no project.md     ← Verdade de upstream
6. Web search                                    ← Suspeito até prova em contrário
7. Memória do LLM sem fonte                      ← Não fiável, sempre verificar
```

Regra: **uma afirmação no `research.md` ou `design.md` que não pode ser ancorada num dos níveis 1-5 deve ser flagged como `[ASSUMPTION]` para validação humana**.

### 6.4 Evitar fontes duvidosas

Para web search (quando inevitável, como Tipo E novo):

- Prefere domínios primários: docs oficiais, ArXiv, sites do projecto open-source, GitHub do projecto, RFC.
- Rejeita: SEO content farms (medium spam, generic tutorials sem autor identificável), respostas StackOverflow sem confirmação cruzada, posts > 2 anos para ferramentas em mudança rápida.
- Confirma cada claim em **pelo menos duas fontes independentes** se for usado para decisão arquitectural.
- Para papers: prefere versões publicadas em conferências peer-reviewed; preprints ArXiv precisam de leitura crítica.

Template para validar uma fonte antes de a adicionar ao Graphify:

```
- [ ] Autor identificado e credível no domínio?
- [ ] Data publicação < 2 anos (para tech rápida) ou clássico estabelecido?
- [ ] Conteúdo é primário (não citação de citação)?
- [ ] Pode ser validado experimentalmente neste projecto?
- [ ] Aceitar para Graphify? Sim/Não/Com nota de cautela
```

### 6.5 Anti-alucinação no research

- Graphify tagga cada edge como `EXTRACTED`, `INFERRED` ou `AMBIGUOUS` — usar isto. No `research.md`, ao citar uma relação, marcar de qual tipo veio.
- GitNexus retorna staleness — se index é antigo, reindexar antes de confiar no impact.
- LLM deve ser instruído (via AGENTS.md) a recusar afirmações sem fonte: "If you cannot point to a source in this repo's knowledge graph, write `[NEEDS VERIFICATION]` instead of guessing."

---

## 7. Protocolos por tarefa (questão 3.4)

### 7.1 Protocolos transversais (aplicam a todos os tipos)

**Token efficiency**
- `CLAUDE.md` ≤ 200 linhas. Detalhes vão para `@imported.md` files que são carregados sob demanda.
- Cursor rules: cada `.mdc` ≤ 500 linhas; total `alwaysApply: true` ≤ 2000 tokens.
- Usa subagents para exploração: o subagent vê o ruído, retorna apenas a síntese ao agente principal.
- Skills (`.claude/skills/<name>/SKILL.md`) carregam só a descrição; o corpo só é carregado quando invocado — usar isto para playbooks longos.

**Anti-alucinação**
- AGENTS.md tem cláusula: "If unsure, ASK before assuming. If the user provides an unfamiliar term, search the knowledge graph BEFORE answering."
- Para chamadas a APIs externas: o agente deve sempre verificar via GitNexus se a API/função existe no repo antes de a usar; se não existir, declarar `[ASSUMPTION]`.
- Para nomes de bibliotecas: verificar em `package.json`/`pyproject.toml` antes de assumir versão.

**Simplicidade**
- Princípio "smallest reasonable change" — qualquer task que toque > 5 ficheiros precisa de OpenSpec proposal.
- Recusar abstracções antecipadas. Se design.md propõe uma factory/adapter/wrapper "para flexibilidade futura", rejeitar e pedir caso concreto.

**Escalabilidade**
- Specs arquivados são fonte primária para próximas features — não re-explicar conceitos já decididos.
- Graphify hook automático em cada commit garante que o knowledge graph não fica stale.
- Convenções de nomenclatura consistentes facilitam queries futuras (ex: change-id sempre `verb-noun-modifier`).

**Segurança**
- Claude Code: hooks `PreToolUse` para bloquear `rm -rf`, `git push --force`, `sudo`, comandos a paths fora do repo. Template em 12.4.
- Permissões: `permissions.allow` enumera Bash safe; `permissions.deny` lista hard blocks. Nunca `Bash(*)` em allow.
- Segredos: NUNCA em `CLAUDE.md`, `AGENTS.md`, `project.md` ou qualquer ficheiro em git. Sempre em `.env` (gitignored) ou variáveis de ambiente.
- Graphify: por design, código local não sai da máquina (tree-sitter local); apenas docs/PDFs/imagens vão para o LLM via skill (a tua sessão IDE). Validar isto se trabalhares com IP sensível.
- GitNexus: 100% local.
- OpenSpec: 100% local (sem API keys).

**Auditoria**
- Todos os specs vivem no git — `git log openspec/specs/` mostra evolução de requisitos.
- Mensagens de commit referem o change-id: `feat(auth): implement add-jwt change`.
- `openspec/changes/archive/` mantém histórico de proposals, designs e tasks que levaram a cada feature — fonte primária para post-mortems.
- Hook PreToolUse pode loggar todas as tool calls para `.claude/logs/` (template em 12.4).
- GitNexus expõe `detect_changes()` para auditar drift entre código e o último index.

### 7.2 Protocolos específicos por tipo

**Tipo A — Trivial**
- Recusar se ambíguo. Pedir confirmação se a mudança parecer ter implicação.
- Não criar OpenSpec change.
- Commit directo. Mensagem: `chore: <descrição curta>`.

**Tipo B — Bug fix**
- Sempre `gitnexus impact <target>` antes de patch.
- Sempre adicionar teste que falha *antes* da fix.
- Verificar que o teste passa após.
- Commit: `fix(<scope>): <descrição> (closes #<issue> se houver)`.

**Tipo C — Refactor**
- OpenSpec proposal obrigatório.
- `design.md` deve incluir secção "Behavioral parity" — listar invariantes que devem permanecer iguais.
- Testes existentes devem passar sem mudanças (excepto importação se ficheiros se moveram).
- Sem novo comportamento adicionado num refactor — caso contrário é Tipo D.

**Tipo D — Feature com base teórica**
- Dois research docs obrigatórios: `knowledge.md` e `codebase.md`.
- `design.md` cita explicitamente nodes do Graphify e impact do GitNexus.
- Pelo menos uma alternativa rejeitada documentada.
- Testes para o caso teórico central, não só para o código.

**Tipo E — Exploração**
- Output é documento, não código. Recusar PRs de código directos a partir de Tipo E.
- `research.md` arquivado em `openspec/changes/explore-<topic>/` mesmo se não levar a implementação.
- Conclusão em formato "Recommendation: <action> because <reason>. Alternatives considered: <list>. Risks: <list>."

---

## 8. Regras gerais do sistema (questão 4)

### 8.1 Onde vivem as regras

**Princípio**: regras universais num único sítio canónico, com aliases para cada ferramenta.

```
AGENTS.md (raiz)                      ← FONTE DE VERDADE para regras universais
  ↑
  ├─ CLAUDE.md                        ← apenas: "Strictly follow ./AGENTS.md"
  ├─ .cursor/rules/000-base.mdc       ← apenas: "Strictly follow ./AGENTS.md"
  └─ openspec/AGENTS.md               ← gerado por OpenSpec, NÃO editar manualmente
                                        (contém apenas instruções sobre OpenSpec)

openspec/project.md                   ← FONTE DE VERDADE para stack + convenções
                                        do projecto específico

.cursor/rules/*.mdc                   ← regras com glob scoping
                                        (ex: regras específicas para *.tsx)

.claude/agents/*.md                   ← personas de subagents
.claude/skills/*/SKILL.md             ← playbooks invocáveis
.claude/hooks/*                       ← guardrails determinísticos
.claude/settings.json                 ← permissões
```

### 8.2 As nove regras universais (em AGENTS.md)

```markdown
# Universal rules for AI agents working in this repo

## R1 — Task Type Detection
Before any work, classify the task (A through E — see "Task Type Detection
Protocol" below). If ambiguous, ASK.

## R2 — Knowledge Source Priority
Consult sources in this order: specs > archived changes > Graphify > GitNexus
> external docs > web. Web is last resort.

## R3 — No Hallucinations
If a fact cannot be anchored to one of the sources in R2, mark it
`[NEEDS VERIFICATION]` instead of asserting it. NEVER invent library names,
API signatures, or file paths.

## R4 — Smallest Reasonable Change
Prefer the minimal change that solves the problem. No speculative
abstractions, factories, or wrappers without a concrete second use case
in the codebase TODAY.

## R5 — Behavioral Parity in Refactors
Refactors do NOT introduce new behavior. If you find yourself wanting to,
stop and create a new OpenSpec proposal.

## R6 — Test Before Fix
Bugs require a failing test first, then the fix.

## R7 — Spec Before Code (for non-trivial work)
For tasks of type C, D, and E, the OpenSpec proposal must be reviewed and
approved BEFORE any code is written.

## R8 — Source Anchoring
Every non-trivial claim in design.md, research.md, or commit messages
must cite a source: spec ID, archived change ID, Graphify node, GitNexus
function name, or external URL.

## R9 — Auditability
Every commit references either an OpenSpec change-id (`feat(auth):
implement add-jwt`) or a fix issue (`fix(api): handle null x (closes
#42)`). No `wip`, `misc`, or unscoped commits.
```

### 8.3 Hierarquia de precedência

Quando regras competem:

```
1. Hooks (PreToolUse)              ← Determinístico, não negociável
2. permissions.deny                ← Bloqueia mesmo se model "quer"
3. AGENTS.md universal rules       ← Aplicado a todos
4. openspec/project.md             ← Específico do projecto
5. .cursor/rules/*.mdc (glob match)← Específico de ficheiros/contexto
6. Slash commands (skills)         ← On-demand
7. User prompt                     ← Mais flexível
```

User prompt nunca anula um hook. Se um hook bloqueia, o user tem de reconfigurar o hook conscientemente, não bypass via prompt.

---

## 9. Configuração Cursor (questão 5)

### 9.1 Estrutura final de ficheiros

```
projecto/
├── AGENTS.md                                 ← curado, fonte de verdade
├── .cursor/
│   ├── rules/
│   │   ├── 000-base.mdc                      ← alwaysApply, aponta para AGENTS.md
│   │   ├── 010-typescript.mdc                ← auto-attach: globs: ["**/*.ts", "**/*.tsx"]
│   │   ├── 020-python.mdc                    ← auto-attach: globs: ["**/*.py"]
│   │   ├── 030-supabase.mdc                  ← auto-attach: globs: ["**/migrations/**", "**/db/**"]
│   │   ├── 040-n8n.mdc                       ← auto-attach: globs: ["**/n8n/**"]
│   │   └── 050-security.mdc                  ← alwaysApply, guardrails
│   ├── commands/                             ← gerados por OpenSpec, não editar
│   │   ├── opsx-propose.md
│   │   ├── opsx-apply.md
│   │   └── opsx-archive.md
│   ├── skills/                               ← gerados por GitNexus + Graphify
│   │   ├── gitnexus-exploring/
│   │   ├── gitnexus-impact/
│   │   └── graphify/
│   └── mcp.json                              ← gitnexus + (opcional) graphify
```

### 9.2 Regras a criar

**`.cursor/rules/000-base.mdc`** — sempre aplicada, redirecciona para AGENTS.md:

```markdown
---
description: Base rules for this project (alwaysApply)
alwaysApply: true
---

# Base rules

Strictly follow the rules and conventions in `./AGENTS.md` at the repo root.

Additionally:
- Project constitution is in `./openspec/project.md`
- Active specs are in `./openspec/specs/`
- Knowledge base is in `./graphify-out/GRAPH_REPORT.md`
- Code structure is queryable via GitNexus MCP tools

For any non-trivial task (type C/D/E), invoke `/opsx:propose <description>`
before writing code.
```

**`.cursor/rules/050-security.mdc`** — sempre aplicada, hard limits:

```markdown
---
description: Security guardrails (alwaysApply)
alwaysApply: true
---

# Security rules

NEVER:
- Write secrets, API keys, tokens, or passwords to any file in this repo
- Run `rm -rf` on paths outside the current repo
- Execute `git push --force` or `git push --force-with-lease` without explicit user approval
- Disable hooks with `--no-verify` without explaining why
- Add dependencies without checking their security advisories first

ALWAYS:
- Read .env.example to understand expected env vars; never read .env
- Sanitize all user inputs in API routes (Zod, valibot, or equivalent)
- Use parameterised queries for any DB access; no string concatenation
- Add input validation as the FIRST line in any route handler
```

**`.cursor/rules/010-typescript.mdc`** — auto-attach a TS files:

```markdown
---
description: TypeScript conventions
globs:
  - "**/*.ts"
  - "**/*.tsx"
alwaysApply: false
---

# TypeScript rules for this project

- Strict mode is on. No `any` without comment explaining why.
- No default exports (use named exports).
- Imports: absolute paths from `@/` for internal, relative only for siblings.
- Async/await over .then chains.
- Errors: use Result types or typed exceptions; never silent failures.
- Schemas: Zod for runtime validation at all I/O boundaries.
```

(Adicionar templates equivalentes para Python, Supabase, n8n nas restantes regras — anexo 12.5)

### 9.3 MCP config (`~/.cursor/mcp.json` global)

```json
{
  "mcpServers": {
    "gitnexus": {
      "command": "npx",
      "args": ["-y", "gitnexus@latest", "mcp"]
    },
    "graphify": {
      "command": "python",
      "args": ["-m", "graphify.serve", "graphify-out/graph.json"]
    }
  }
}
```

Em Windows, prefixar com `cmd /c`:
```json
{
  "command": "cmd",
  "args": ["/c", "npx", "-y", "gitnexus@latest", "mcp"]
}
```

### 9.4 Verificação

Em Cursor, abre Composer e digita:
- `@rules` deve mostrar as 6 .mdc carregadas (3 always + 3 attached conforme ficheiro aberto).
- `/rules` mostra qual o estado.
- Testar: `/opsx:propose teste-instalação` — deve criar pasta `openspec/changes/teste-instalacao/`.

---

## 10. Configuração VS Code + Claude Code (questão 5)

### 10.1 Pré-requisitos

- VS Code 1.109+
- Extension "Claude Code" (publisher: anthropic) — verificar publisher cuidadosamente, há knock-offs.
- Claude Code CLI ≥ 2.1.140 (a extensão inclui CLI mas é melhor garantir versão recente: `claude install`).

### 10.2 Estrutura final

```
projecto/
├── AGENTS.md                            ← mesmo ficheiro do Cursor
├── CLAUDE.md                            ← curto, aponta para AGENTS.md
├── .claude/
│   ├── settings.json                    ← permissões
│   ├── commands/                        ← gerados por OpenSpec
│   ├── skills/                          ← gerados por GitNexus + Graphify
│   │   ├── gitnexus-exploring/
│   │   ├── gitnexus-impact/
│   │   ├── gitnexus-refactor/
│   │   └── graphify/
│   ├── agents/                          ← subagents customizados
│   │   ├── graphify-researcher.md
│   │   ├── codebase-researcher.md
│   │   └── security-reviewer.md
│   └── hooks/                           ← guardrails determinísticos
│       ├── block-dangerous.sh
│       ├── session-start.sh
│       └── post-edit-typecheck.sh
```

### 10.3 `CLAUDE.md` (raiz)

```markdown
# CLAUDE.md — entry point for Claude Code

Strictly follow the rules and conventions in `./AGENTS.md`.

This file exists for compatibility with Claude Code's lookup order; the
source of truth is AGENTS.md to keep behavior consistent across tools
(Cursor, Codex, etc.).

## Quick context

- Stack and conventions: `./openspec/project.md`
- Active specs: `./openspec/specs/`
- Active proposals: `./openspec/changes/`
- Knowledge graph: `./graphify-out/GRAPH_REPORT.md`
- Code graph: via GitNexus MCP (`gitnexus_query`, `gitnexus_impact`, etc.)

## Task type protocol

See "Task Type Detection Protocol" in AGENTS.md. Always classify before
acting.
```

### 10.4 `.claude/settings.json`

```json
{
  "permissions": {
    "allow": [
      "Bash(npm run *)",
      "Bash(pnpm *)",
      "Bash(npx gitnexus *)",
      "Bash(graphify *)",
      "Bash(openspec *)",
      "Bash(git status)",
      "Bash(git diff *)",
      "Bash(git log *)",
      "Bash(git add *)",
      "Bash(git commit *)",
      "Bash(git branch *)",
      "Bash(git checkout *)",
      "WebSearch",
      "WebFetch(domain:docs.anthropic.com)",
      "WebFetch(domain:supabase.com)",
      "WebFetch(domain:n8n.io)"
    ],
    "deny": [
      "Bash(rm -rf *)",
      "Bash(sudo *)",
      "Bash(git push --force*)",
      "Bash(cat .env)",
      "Bash(curl * | bash)",
      "Bash(curl * | sh)"
    ]
  }
}
```

### 10.5 Hook crítico — `.claude/hooks/block-dangerous.sh`

```bash
#!/bin/bash
COMMAND=$(jq -r '.tool_input.command' 2>/dev/null)

# Block dangerous patterns even if they slip past permissions
PATTERNS=(
  'rm -rf /'
  'rm -rf ~'
  '> /dev/sda'
  'mkfs'
  'dd if='
  ':(){:|:&};:'
)

for p in "${PATTERNS[@]}"; do
  if echo "$COMMAND" | grep -q "$p"; then
    jq -n --arg reason "Dangerous command blocked: $p" '{
      hookSpecificOutput: {
        hookEventName: "PreToolUse",
        permissionDecision: "deny",
        permissionDecisionReason: $reason
      }
    }'
    exit 2
  fi
done

exit 0
```

Registrar em `.claude/settings.json`:

```json
{
  "hooks": {
    "PreToolUse": [
      {
        "matcher": "Bash",
        "hooks": [
          {
            "type": "command",
            "command": "\"$CLAUDE_PROJECT_DIR\"/.claude/hooks/block-dangerous.sh"
          }
        ]
      }
    ]
  }
}
```

### 10.6 Subagents

`.claude/agents/graphify-researcher.md`:

```markdown
---
name: graphify-researcher
description: Use to research theory, concepts, and prior knowledge from the
  Graphify knowledge graph. Invoke for type D and E tasks before writing
  any spec or code. Returns a compact knowledge.md summary.
tools: Read, mcp__graphify__query_graph, mcp__graphify__get_node,
  mcp__graphify__shortest_path
model: opus
---

You are a research librarian for this project's knowledge graph.

Your job:
1. Read the user's research question.
2. Query the Graphify graph (graphify-out/graph.json) for relevant concepts.
3. Find shortest paths between key concepts and trace what connects them.
4. Identify god-nodes that the question touches.
5. Return a `knowledge.md` document (≤1 page) with:
   - Key concepts found (with graph node IDs)
   - Relationships between them (cite edge types)
   - Prior decisions or specs that touch these concepts
   - Gaps where the graph has nothing (mark `[KNOWLEDGE GAP]`)
   - Recommendation: is enough known to proceed, or do we need more research?

NEVER write code. NEVER speculate about what is not in the graph.
If the graph has no relevant nodes, say so explicitly.
```

`.claude/agents/codebase-researcher.md`:

```markdown
---
name: codebase-researcher
description: Use to research how the current code is structured for a
  given area. Invoke for type C and D tasks. Returns a compact
  codebase.md AS-IS document.
tools: Read, Grep, Glob, mcp__gitnexus__query, mcp__gitnexus__context,
  mcp__gitnexus__impact
model: sonnet
---

You are a codebase archaeologist.

Your job:
1. Read the user's question about an area of the codebase.
2. Use GitNexus MCP tools to find the relevant entry points.
3. Trace call chains, identify clusters, and map dependencies.
4. Run impact analysis for any symbols that will change.
5. Return a `codebase.md` document (≤1 page) with:
   - Entry points (files + functions)
   - Key call chains relevant to the question
   - Blast radius for proposed changes
   - Patterns already used in this area (cite specific files)
   - Risk areas (tight coupling, missing tests, etc.)

NEVER write code. NEVER speculate. Cite exact file:line references.
```

### 10.7 Verificação

```bash
# Listar configurações activas
claude /context
claude /agents
claude /hooks
claude mcp list

# Testar subagent
# No Claude Code:
> Use the codebase-researcher agent to map the auth flow
```

---

## 11. Protocolos de código (questão 7)

### 11.1 Princípios não-negociáveis

Estes vão para `openspec/project.md` na secção "Coding standards":

1. **Replicabilidade**: cada solução é testável de forma reproduzível. Sem testes, sem merge.
2. **Legibilidade > esperteza**: código claro com 2 funções é melhor que one-liner enigmático.
3. **Self-documenting names**: variáveis e funções comunicam intenção. Comentários explicam *porquê*, não *o quê*.
4. **Comments document decisions, not mechanics**: `// retries 3x because n8n webhook timeout is 10s` é útil. `// increment i` é ruído.
5. **Modularização por capability, não por type**: pasta `auth/` com `auth.service.ts`, `auth.controller.ts`, `auth.types.ts`, em vez de pastas globais `services/`, `controllers/`, `types/`.
6. **No silent failures**: erros são propagados ou registados explicitamente, nunca engolidos.
7. **Input validation at boundaries**: cada entrada externa (API, webhook, CSV, env) é validada por schema (Zod, Pydantic) no primeiro ponto de contacto.
8. **Tracing built-in**: para o multi-agent bot do Pedro, cada agent step deve loggar (correlation ID, agent name, input hash, output hash, duration, errors).

### 11.2 Estrutura de comentários

```typescript
/**
 * AssociationEngine — implements KBS-style bisociative association between concepts.
 *
 * Why this exists: standard cosine similarity treats all related concepts the same.
 * KBS framework (see openspec/specs/kbs-association/spec.md) distinguishes routine
 * similarity from bisociative leaps. This engine encodes the distinction.
 *
 * Sources:
 * - openspec/specs/kbs-association/spec.md (R-KBS-001)
 * - Graphify nodes: bisociation, koestler-frame, simonton-chance
 *
 * Threading: NOT thread-safe. Wrap in lock if calling concurrently.
 */
export class AssociationEngine {
  // ...
}
```

Comentários inline (raros):

```typescript
// Reset retries when we hit a 429 — Supabase rate limit window is 60s,
// not 5s like other endpoints. See infra/rate-limits.md.
if (response.status === 429) {
  await sleep(60_000);
  retries = 0;
}
```

### 11.3 Estrutura modular para o multi-agent bot

```
src/
├── agents/                          ← capability: cada agent é módulo isolado
│   ├── orchestrator/
│   │   ├── orchestrator.service.ts
│   │   ├── orchestrator.types.ts
│   │   ├── orchestrator.test.ts
│   │   └── README.md                ← purpose, inputs, outputs, dependencies
│   ├── retrieval/
│   ├── synthesis/
│   └── validation/
├── infra/                           ← capability: integration with externals
│   ├── supabase/
│   │   ├── client.ts
│   │   ├── schemas.ts               ← Zod schemas mirroring DB schema
│   │   ├── migrations/
│   │   └── README.md
│   ├── n8n/
│   └── tavily/
├── core/                            ← shared, framework-agnostic
│   ├── tracing/
│   │   ├── correlation.ts
│   │   ├── logger.ts
│   │   └── errors.ts
│   └── validation/
└── lib/                             ← pure utility, no I/O
    ├── id.ts
    └── time.ts
```

Cada pasta capability tem:
- Um único entry point (`index.ts` que re-exporta apenas a API pública)
- `README.md` explicando propósito, dependências, e como testar
- Testes co-locados (`*.test.ts`)

### 11.4 Rastreabilidade de dados

Para o pipeline multi-agent, cada peça de dado que flui entre etapas carrega:

```typescript
type TraceContext = {
  correlationId: string;          // ID único de toda a request
  agentChain: string[];           // ["orchestrator", "retrieval", "synthesis"]
  step: number;
  parentSpanId: string | null;
  spanId: string;
  startedAt: ISOTimestamp;
};

type AgentInput<T> = {
  trace: TraceContext;
  payload: T;
  schemaVersion: string;          // e.g. "v1.2.0" — para detectar drift
};
```

Toda função que processa dados entre agents recebe e propaga este contexto. Logger interno escreve cada step em formato estruturado para Supabase (`agent_traces` table) ou logger compatível.

### 11.5 Prevenção de bugs

- **Tests are first-class**: cada bug fix começa com teste que falha. Cada feature inclui testes para casos felizes, edge cases, e error paths.
- **Property-based testing** para lógica pura (fast-check em TS, hypothesis em Python).
- **Contract tests** nas fronteiras (cada agent declara o seu contrato Zod; outros agents validam contra esse contrato).
- **Type safety end-to-end**: TS strict + Zod runtime; Pydantic em Python.

### 11.6 Prevenção de ataques

| Vector | Defesa | Onde implementar |
|---|---|---|
| SQL injection | Parameterised queries via Supabase client; nunca string concat | `infra/supabase/client.ts` |
| Prompt injection | Sanitize all external strings antes de meter em prompts a LLMs; usar role separation | `agents/*/prompt.ts` |
| SSRF (Tavily, web fetch) | Allowlist de domínios; reject IPs privados e localhost | `infra/web/fetch.ts` |
| Webhook spoofing | HMAC verification em todos os webhooks | `infra/n8n/webhook.handler.ts` |
| Secret leakage | Hooks PreToolUse bloqueiam leitura de `.env`; logger redacta padrões `sk-*`, `api_key=*` | `.claude/hooks/`, `core/tracing/logger.ts` |
| Dependency injection | Audit `pnpm audit` / `pip-audit` em CI; reject deps com vulns críticas | `.github/workflows/audit.yml` |
| XSS (se houver UI) | Sanitização em render; CSP headers; React por defeito escapa, JSX dangerouslySetInnerHTML proibido sem review | Configuração frontend |
| Rate limiting | Tokens bucket por user/agent na entrada de cada API; backoff exponencial | `core/rate-limit.ts` |

### 11.7 Documentação por módulo

Cada capability tem `README.md`:

```markdown
# Retrieval Agent

## Purpose
Pulls candidate documents from the pgvector store given a query embedding.

## API
- `retrieve(input: RetrieveInput): Promise<RetrieveOutput>`

## Inputs
- `RetrieveInput`: schema in `retrieval.types.ts`

## Outputs
- `RetrieveOutput`: schema in `retrieval.types.ts`

## Dependencies
- `infra/supabase/client.ts` — pgvector queries
- `core/tracing/correlation.ts` — trace propagation

## Tests
- `retrieval.test.ts` (unit)
- `retrieval.integration.test.ts` (against a test Supabase instance)

## Cross-references
- Spec: `openspec/specs/retrieval/spec.md`
- Design history: `openspec/changes/archive/2026-04-08-add-retrieval/`

## Known limits
- Top-K hard-coded to 20; if you need more, this needs a new spec.
- No re-ranking yet — see `openspec/changes/archive/2026-04-22-reranking/`
  for why we deferred it.
```

---

## 12. Anexos: templates completos

### 12.1 Template `openspec/project.md`

```markdown
# Project: <project name>

## Purpose
<One paragraph: what this project does, for whom, and what success looks like.>

## Stack
- Runtime: Node.js 20.x, Python 3.11
- Frontend: Next.js 15 (App Router), Tailwind, shadcn/ui
- Backend: Next.js server actions + n8n workflows
- Database: Supabase (Postgres + pgvector)
- LLM: Anthropic Claude (primary), Gemini 2.5 Flash (cost-optimized)
- Search: Tavily
- Testing: Vitest (TS), pytest (Python), Playwright (e2e)

## Architecture
<3-5 bullets describing the high-level shape. Reference diagrams in /docs.>

## Conventions
- Module organization: by capability (auth/, retrieval/), not by type
- No default exports
- Strict TypeScript; Zod at all I/O boundaries
- Errors typed; no silent failures
- Tests co-located with code
- Correlation IDs propagated through every agent step

## Constraints
- Multi-agent traces stored in `agent_traces` Supabase table
- All external inputs validated via Zod before any business logic
- Secrets only in env vars; never in code/specs/markdown

## Cross-references
- Code graph: `.gitnexus/` (via MCP tools)
- Knowledge graph: `graphify-out/GRAPH_REPORT.md`
- Specs: `openspec/specs/`
- Active changes: `openspec/changes/`

## Non-goals
- We do NOT build our own LLM evaluation framework — use Langfuse.
- We do NOT host our own vector DB — Supabase pgvector is the choice.
- We do NOT implement auth from scratch — Supabase Auth handles it.
```

### 12.2 Núcleo comum `AGENTS.md` (todas as instalações)

Bloco partilhado — colar e completar Commands conforme 12.2a ou 12.2b.

```markdown
# AGENTS.md — Instruções Universais para Agentes de IA

> Canónico para Cursor, Claude Code, Codex, etc. `CLAUDE.md` e `.cursor/rules/` apenas apontam aqui.
> Padrão: https://agents.md/

## Contexto do projecto

Ver `./openspec/project.md` (stack, convenções, constraints). **Não duplicar** stack aqui.

## Commands

[PREENCHER: tabela do perfil 12.2a APP ou 12.2b DOCS_SPECS]

## Fontes de conhecimento (por prioridade)

1. `./openspec/specs/`  2. `./openspec/changes/`  3. `./graphify-out/GRAPH_REPORT.md`
4. GitNexus MCP  5. Graphify MCP ou `graphify query`  6. Docs em `project.md`  7. Web (último recurso)

Nunca afirmar factos sem fonte 1–6. Tipo D/E: Graphify + GitNexus antes de código.

## Contexto sob demanda

| Situação | Ficheiro |
|----------|----------|
| Constituição | `openspec/project.md` |
| Specs | `openspec/specs/` |
| Change activo | `openspec/changes/<id>/` |
| Grafo | `graphify-out/GRAPH_REPORT.md` |
| Guia SDD | `doc/sistema-sdd-pedro.md` |
| Actualização SDD | `doc/sistema-sdd-pedro.md` §2.9 |
| TS / Py / DB | `.cursor/rules/010-*.mdc`, `020-*.mdc`, `030-*.mdc` |

## Protocolo de tarefas (A–E)

| Tipo | Pipeline |
|------|----------|
| A Trivial | Edição directa |
| B Bug | GitNexus impact → patch → teste |
| C Refactor | GitNexus AS-IS → `/opsx:propose` → implementar |
| D Feature | Graphify ∥ GitNexus → propose → implementar |
| E Exploração | Graphify → `research.md` |

Se ambíguo, PERGUNTAR. Nunca assumir Tipo A.

## Regras R1–R9

R1 classificar · R2 specs>graphify>gitnexus · R3 `[NEEDS VERIFICATION]` · R4 mudança mínima ·
R5 refactor sem comportamento novo · R6 teste antes do fix · R7 spec antes de código (C/D/E) ·
R8 citar fontes · R9 commits com scope/change-id

## Workflow

`/opsx:propose` · `/opsx:apply` · `/opsx:archive` · `/opsx:explore` · `graphify update .` · `npx gitnexus analyze --force`

## Integrações (resumo)

**GitNexus:** impact antes de editar símbolos; `detect_changes` antes de commit. Skills: `.claude/skills/gitnexus/`.

**Graphify:** ler `GRAPH_REPORT.md` antes de grep em perguntas de arquitectura; `graphify update .` após mudanças de código.

## Testing

[PREENCHER: npm test / pytest / openspec validate / N/A para docs-only]

## PR e commits

Conventional Commits; referenciar change-id OpenSpec quando aplicável. Não commitar `graphify-out/`, `.gitnexus/`.

## Segurança

Sem segredos em git; validar inputs; queries parametrizadas; não ler `.env`.

## Comunicação

[Adaptar: pt-BR, directo, sem preâmbulo]
```

### 12.2a Commands — perfil APP

```markdown
| Comando | Uso |
|---------|-----|
| `npm run dev` / `pnpm dev` | Desenvolvimento (não `npm run build` em sessão agente) |
| `npm test` / `pnpm test` | Testes |
| `npm run lint` | Lint |
| `npx openspec list` | Changes OpenSpec |
| `npx gitnexus analyze --force` | Reindexar código |
| `graphify update .` | Actualizar grafo |
```

### 12.2b Commands — perfil DOCS_SPECS

```markdown
| Comando | Uso |
|---------|-----|
| `npx openspec list` | Changes activos |
| `npx openspec new change "<id>"` | Novo change (CLI) |
| `/opsx:propose` | Proposta (Cursor/Claude) |
| `npx gitnexus status` | Estado do index |
| `npx gitnexus analyze --force` | Reindexar |
| `graphify update .` | Grafo AST |
| `graphify query "<pergunta>"` | Busca no grafo |

Nota: não há `npm run dev` na raiz deste perfil.
```

### 12.3 Template `openspec/changes/<id>/design.md` (com cross-references)

```markdown
# Design — <change title>

## Context

<Why this change. Link to proposal.md for the user-facing motivation.>

## Knowledge sources consulted

### From Graphify
- Concept: `bisociation` (node graphify://node/bisociation-001)
- Concept: `frame-shifting` (node graphify://node/frame-shift-022)
- Shortest path: `bisociation` → `cognitive-distance` → `creativity-score`
- Relevant papers in vault: "Koestler 1964 — Act of Creation", "Simonton 1999"

### From GitNexus
- Current implementation: `src/agents/retrieval/retrieval.service.ts:42`
- Call chain: `orchestrator.run() → retrieval.retrieve() → embedding.embed()`
- Blast radius: 7 downstream consumers of `RetrieveOutput`
- Tests affected: `retrieval.test.ts`, `orchestrator.integration.test.ts`

### From OpenSpec history
- Prior spec: `openspec/specs/retrieval/spec.md` (R-RET-001 to R-RET-008)
- Archived change: `openspec/changes/archive/2026-04-08-add-retrieval/`
  (decision to use pgvector over Pinecone)

## Decisions

### D1 — Use cosine similarity as base, bisociative re-rank as second stage
Rationale: KBS framework distinguishes routine and bisociative associations.
Single-stage similarity loses this. Source: Graphify path traced above.

### D2 — Store bisociation scores in same table, new column
Rationale: avoids migration overhead; column nullable for backward compat.
Source: openspec/specs/retrieval/spec.md R-RET-003 (schema stability).

## Alternatives considered

### A1 — Use a separate embedding model for "creative" queries
Rejected: doubles infra cost; concept already covered by re-rank stage.

### A2 — Defer to a later change
Rejected: blocking 3 other features in the queue.

## Open questions

- [Q1] Threshold for bisociation classification — value TBD via experimentation.
  Will be encoded as env var until empirically settled.

## Risks

- R1 — Bisociation scoring is novel; may need iteration. Mitigation: feature
  flag, rollback plan.
- R2 — Performance: re-rank adds ~50ms p99. Mitigation: cache hot queries.
```

### 12.4 Template hooks Claude Code

`.claude/hooks/session-start.sh`:

```bash
#!/bin/bash
# Loads project context summary at session start.

if [ -f "$PWD/openspec/project.md" ]; then
  echo "📄 Project: $(grep -m1 '^# Project' openspec/project.md | sed 's/# Project: //')"
fi

# Active changes
ACTIVE=$(ls openspec/changes/ 2>/dev/null | grep -v '^archive$' | wc -l | tr -d ' ')
if [ "$ACTIVE" -gt 0 ]; then
  echo "🚧 Active OpenSpec changes: $ACTIVE"
  ls openspec/changes/ 2>/dev/null | grep -v '^archive$' | sed 's/^/   - /'
fi

# Graphify freshness
if [ -f "graphify-out/.graphify_root" ]; then
  AGE=$(find graphify-out/graph.json -mtime +7 2>/dev/null | wc -l | tr -d ' ')
  if [ "$AGE" -gt 0 ]; then
    echo "⚠️  Graphify index is >7 days old. Consider: /graphify . --update"
  fi
fi

# GitNexus freshness
if command -v gitnexus &>/dev/null && [ -d ".gitnexus" ]; then
  STATUS=$(gitnexus status 2>/dev/null | grep -E 'stale|outdated')
  if [ -n "$STATUS" ]; then
    echo "⚠️  GitNexus index may be stale. Consider: gitnexus analyze"
  fi
fi

exit 0
```

`.claude/hooks/post-edit-typecheck.sh`:

```bash
#!/bin/bash
# Runs typecheck after Claude edits a TS file.

FILE=$(jq -r '.tool_input.file_path' 2>/dev/null)

if [[ "$FILE" == *.ts || "$FILE" == *.tsx ]]; then
  if [ -f "tsconfig.json" ]; then
    if ! pnpm tsc --noEmit --pretty false 2>&1 | head -20; then
      echo "❌ Type errors introduced — Claude should review."
    fi
  fi
fi

exit 0
```

Registar em `.claude/settings.json`:

```json
{
  "hooks": {
    "SessionStart": [
      {
        "hooks": [{"type": "command", "command": "$CLAUDE_PROJECT_DIR/.claude/hooks/session-start.sh"}]
      }
    ],
    "PostToolUse": [
      {
        "matcher": "Edit|Write",
        "hooks": [{"type": "command", "command": "$CLAUDE_PROJECT_DIR/.claude/hooks/post-edit-typecheck.sh"}]
      }
    ]
  }
}
```

### 12.5 Templates `.cursor/rules/*.mdc` adicionais

`.cursor/rules/020-python.mdc`:

```markdown
---
description: Python conventions
globs:
  - "**/*.py"
alwaysApply: false
---

# Python conventions

- Python 3.11+; use type hints everywhere
- Pydantic v2 for all I/O schemas
- Async via `asyncio`; no `time.sleep` in async code
- Errors: custom exception hierarchy in `core/errors.py`; never bare `except:`
- Logging: structured (structlog), never print()
- Tests: pytest with `pytest-asyncio`; co-located in `tests/` adjacent to module
- Imports: absolute; ordered (stdlib, third-party, internal)
- No mutable default arguments
```

`.cursor/rules/030-supabase.mdc`:

```markdown
---
description: Supabase + Postgres conventions
globs:
  - "**/migrations/**"
  - "**/db/**"
  - "**/infra/supabase/**"
alwaysApply: false
---

# Supabase / Postgres rules

- All migrations are reversible (up + down)
- Migration names: `YYYYMMDDHHMM_<verb>_<noun>.sql`
- RLS enabled on every table; default deny
- Columns: snake_case
- Tables: plural, snake_case (users, agent_traces)
- pgvector: index is `ivfflat` with `lists = sqrt(rows)`
- Schemas mirrored in TypeScript via `infra/supabase/schemas.ts` (Zod)
- NEVER: raw string SQL with interpolation; use parameterized queries
```

`.cursor/rules/040-n8n.mdc`:

```markdown
---
description: n8n workflow conventions
globs:
  - "**/n8n/**"
  - "**/*.workflow.json"
alwaysApply: false
---

# n8n rules

- Workflow files versioned in repo; exported as JSON
- One workflow per feature; cross-workflow calls via webhook with HMAC
- Always include `Set` node with correlation_id as first step
- Error workflow set on every workflow (centralized error handler)
- Credentials never inline; use n8n credentials store with env-var refs
```

### 12.6 Comando de instalação one-shot

Guardar como `scripts/bootstrap-sdd.sh` (ajustar `REPO`):

```bash
#!/usr/bin/env bash
set -euo pipefail
REPO="${1:-.}"
cd "$REPO"

echo "==> OpenSpec..."
npm install -g @fission-ai/openspec@latest
openspec init --tools "cursor,claude" "$REPO" 2>/dev/null || openspec init --tools "cursor,claude"

echo "==> GitNexus..."
npm install -g gitnexus
gitnexus setup
gitnexus analyze

echo "==> Graphify..."
command -v uv >/dev/null || curl -LsSf https://astral.sh/uv/install.sh | sh
uv tool install graphifyy
graphify install
graphify install --platform cursor
graphify hook install
graphify update .

echo ""
echo "✅ Ferramentas instaladas. OBRIGATÓRIO manualmente:"
echo "   1. Editar openspec/project.md"
echo "   2. Criar AGENTS.md com template 12.2a ou 12.2b (NÃO gerar com IA)"
echo "   3. mv AGENTS.md AGENTS.tools-generated.md se ferramentas sobrescreveram"
echo "   4. Checklist §2.8"
echo "   5. Reiniciar IDE; testar /opsx:propose"
```

### 12.7 Template `AGENTS.md` aninhado (subpasta)

Exemplo para `doc/curso/scripts/AGENTS.md` ou `packages/foo/AGENTS.md`:

```markdown
# AGENTS.md — [nome da pasta]

Instruções locais; o canónico na raiz é `../../AGENTS.md`.

## Commands

| Comando | Uso |
|---------|-----|
| `python script.py` | [descrever] |

## Regras locais

- [Regra específica desta pasta]
- Herdar segurança e protocolo A–E do `AGENTS.md` raiz
```

### 12.8 Template `UPGRADE_REPORT.md` (actualização SDD)

Guardar em `openspec/changes/upgrade-sdd-<versão>/UPGRADE_REPORT.md` **antes** de editar ficheiros curados.

```markdown
# Relatório de actualização SDD

| Campo | Valor |
|-------|--------|
| Repositório | [nome/caminho] |
| Perfil | APP / DOCS_SPECS / HYBRID |
| Versão guia (antes) | vX.Y.Z ou desconhecida |
| Versão guia (alvo) | vA.B.C |
| Data | YYYY-MM-DD |
| Branch | chore/upgrade-sdd-vA.B.C |

## Versões das ferramentas

| Ferramenta | Antes | Depois |
|------------|-------|--------|
| OpenSpec | | |
| GitNexus | | |
| Graphify | | |

## Resumo executivo

- [ ] Actualização aprovada pelo utilizador
- Breaking changes do guia aplicáveis: [sim/não — listar]

## Matriz de ficheiros

| Ficheiro | Existe | Linhas (antes) | Classificação | Acção proposta | Aprovado |
|----------|--------|----------------|---------------|----------------|----------|
| AGENTS.md | sim/não | | MERGE | Sincronizar 12.2; manter Commands | [ ] |
| openspec/project.md | | | MERGE | Actualizar Cross-references; manter Purpose/Stack | [ ] |
| CLAUDE.md | | | MERGE | Template §10.3 | [ ] |
| .cursor/rules/000-base.mdc | | | APPLY/MERGE | | [ ] |
| .cursor/rules/050-security.mdc | | | APPLY/MERGE | | [ ] |
| .cursor/rules/010-typescript.mdc | | | SKIP/KEEP | | [ ] |
| .cursor/rules/020-python.mdc | | | SKIP/KEEP | | [ ] |
| .cursor/rules/030-supabase.mdc | | | SKIP/KEEP | | [ ] |
| .cursor/rules/graphify.mdc | | | MERGE/KEEP | | [ ] |

Classificações: `KEEP_LOCAL` · `MERGE` · `APPLY_TEMPLATE` · `NEW` · `SKIP`

## Diffs relevantes (resumo)

### AGENTS.md
- Secções só no local: …
- Secções só no template: …
- Conflitos: …

### openspec/project.md
- …

## Ficheiros gerados (não curados)

| Caminho | Acção |
|---------|--------|
| `.cursor/commands/opsx-*` | `openspec update` |
| `openspec/AGENTS.md` | regenerado — ignorar para canónico |

## Pós-actualização

- [ ] §2.9.4 executado
- [ ] §2.9.7 checklist
- [ ] IDE reiniciada
- [ ] `/opsx:propose` testado
```

### 12.9 Script de diff (`scripts/sdd-upgrade-diff.sh`)

Inventaria ficheiros curados e, com directorio de staging, mostra `diff -u`:

```bash
# Só inventário
./scripts/sdd-upgrade-diff.sh

# Com staging (templates extraídos do guia para openspec/changes/.../sdd-staging/)
./scripts/sdd-upgrade-diff.sh openspec/changes/upgrade-sdd-v1.2.0/sdd-staging/
```

Estrutura esperada do staging (espelha paths do repo):

```
sdd-staging/
├── AGENTS.md
├── CLAUDE.md
├── openspec/project.md          # opcional: só para diff de Cross-references
└── .cursor/rules/
    ├── 000-base.mdc
    ├── 050-security.mdc
    └── …
```

O agente **extrai** o conteúdo dos blocos de código deste guia (§9.2, §10.3, §12.1–12.2) para esses ficheiros — não inventar templates.

---

## 13. Alinhamento workshop ↔ agents.md

| Tema (Workshop IA 5/2026, Aula 01) | Onde no guia |
|-----------------------------------|--------------|
| [agents.md](https://agents.md/) como padrão | §2.5, 12.2 |
| `AGENTS.md` curto; on-demand loading | §2.5.3, 12.2 |
| Não pedir à IA para gerar `AGENTS.md` | §2.5.1 |
| Exemplos reais > regras abstritas | §7, §11 |
| Context rot; janela nova por tarefa | §3, §7 |
| Skills lazy vs rules estáticas | §4.2, §8.1 |
| Legado: AS-IS antes de instrumentar | §2.5.3, §2.0 prompt |
| `CLAUDE.md` aponta para `AGENTS.md` | §10.3 |

---

## 14. Integrações futuras (Cline)

> **Não implementado.** Avaliação e roadmap em documento separado — não altera instalação §2 nem actualização §2.9 até adopção formal.

O runtime [Cline](https://cline.bot/) foi avaliado como complemento opcional ao SDD, com papéis **fora** da competição directa com Cursor Agent no IDE:

| Papel | Descrição resumida |
|-------|-------------------|
| Verificador pós-apply (C1) | Auditar diff vs OpenSpec após implementação |
| Orquestrador CI (C2) | `openspec validate`, checklists §2.8/§2.9 em pipeline |
| Coordinator research (C3) | Paralelizar Graphify ∥ GitNexus em Tipo D |
| Gateway externo (C4) | Slack/Linear → classificação A–E (opcional) |

**Documento completo:** [`doc/cline-integracao-sdd.md`](./cline-integracao-sdd.md) (v0.1.0).

**Regra provisória:** Cline não é fonte de regras — `AGENTS.md` permanece canónico. Implementação prevista em fases documentadas no roadmap §9 daquele ficheiro.

---

## Changelog do guia

### 1.2.1 (2026-06-16)

- **§14** — Referência a integração futura Cline (`doc/cline-integracao-sdd.md`); sem alteração de procedimentos de instalação.

### 1.2.0 (2026-06-15)

- **§2.9** — Actualização de instalação existente (detecção, prompt IA, ferramentas, merge, checklist).
- **§2.9.5** — Matriz de comparação ficheiros curados vs templates (KEEP_LOCAL / MERGE / APPLY_TEMPLATE / NEW / SKIP).
- **§12.8** — Template `UPGRADE_REPORT.md` para aprovação humana antes de editar ficheiros.
- **§12.9** + `scripts/sdd-upgrade-diff.sh` — inventário e diff contra staging.
- Tabela "Como usar" distingue instalação vs actualização (humano e agente).

### 1.1.0 (2026-05-25)

- Guia explicitamente como **artefacto de instalação** reutilizável (humano + IA).
- §2.0 prompt de instalação assistida; §2.8 checklist de verificação.
- Formato alvo `AGENTS.md`: Commands, on-demand, integrações resumidas (agents.md).
- §2.5.1 anti-padrões; §2.5.2 perfis APP / DOCS_SPECS / HYBRID.
- Templates 12.2a / 12.2b / 12.7; `graphify update` em vez de `graphify .`.
- `openspec init --tools`; bootstrap actualizado.

### 1.0.0 (2026-05)

- Versão inicial: OpenSpec + GitNexus + Graphify, Cursor, Claude Code.

---

## Apêndice — Disclaimer técnico final

Este sistema combina três projectos open source em rápida evolução. Os comandos básicos (`openspec init`, `gitnexus analyze`, `graphify .`) são estáveis. Flags exóticas, formato exacto de subagents, e detalhes de hooks podem mudar em releases mensais. Antes de automatizar processos críticos em produção:

1. Confirmar versões com `<ferramenta> --version`
2. Ler CHANGELOG da release mais recente
3. Testar em branch separada antes de PR

Se algo falhar na configuração, a ordem habitual de debug é:
1. `gitnexus status` e `claude mcp list` — MCPs estão registados?
2. `cat ~/.cursor/mcp.json` — sintaxe correcta?
3. Restart Cursor/VS Code após qualquer mudança de configuração (skills são carregadas no arranque da sessão).
4. Logs: `.claude/logs/` se hooks de logging estiverem configurados.

---

*Guia v1.2.0 — Junho 2026. Ferramentas de referência: OpenSpec 1.3.1+, GitNexus 1.6+, Graphify 0.8.5+, Claude Code 2.1.140+, Cursor `.mdc`, VS Code 1.109+. Confirmar com `--version` antes de automatizar.*

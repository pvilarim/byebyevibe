"""
Enriquece arquivos de transcrição com resumo, tópicos e referências aos links.
"""
from __future__ import annotations

import re
from pathlib import Path

CURSO = Path(r"c:\apps\spec-pedro\doc\curso")

LESSONS = {
    1: {
        "title": "Desenvolvimento Assistido por IA — Fundamentos e Context Engineering",
        "speaker": "Waldemar Neto (Valdemar)",
        "summary": (
            "Abertura do workshop com panorama de adoção de IA em 2026: curva de ROI (DORA), "
            "diferença entre dev usuário vs construtor de agentes, vibe coding vs desenvolvimento "
            "assistido, fundamentos de LLM/agente/harness, Context Engineering (AGENTS.md, on-demand "
            "loading, context rot), fluxo RPI (Research → Plan → Implement), Skills, MCP, design docs, "
            "tasks no Linear e Q&A sobre legado, idioma, gestão de contexto e segurança."
        ),
        "topics": [
            "Estado da adoção de IA e métricas de produtividade (DORA, METR, Microsoft)",
            "Iceberg: uso de IA vs construção de agentes",
            "Vibe coding vs desenvolvimento assistido por IA",
            "LLM probabilística, agente, harness e Context Engineering",
            "AGENTS.md, carregamento sob demanda e context rot",
            "MCP para contexto externo (Linear, Confluence)",
            "Fluxo RPI e modo plano no Cursor",
            "Skills (padrão Anthropic) vs rules — carregamento lazy",
            "Technical Design Doc e quebra de projetos em fases/tasks",
            "Sub-agentes genéricos e gestão de janela de contexto",
            "Q&A: legado, inglês vs português, MCP seguro, CLAUDE.md vs AGENTS.md",
        ],
        "refs": [
            (r"\b(dora|DORA)\b", "DORA 2026 — ROI Report", "https://dora.dev/ai/roi/report/"),
            (r"Pragmatic Engineer|pragmatic engineer", "Pragmatic Engineer — AI Tooling Survey 2026", "https://newsletter.pragmaticengineer.com/p/ai-tooling-2026"),
            (r"metr|METR", "METR — Impacto de IA em devs OSS", "https://metr.org/blog/2025-07-10-early-2025-ai-experienced-os-dev-study/"),
            (r"agents\.? ponto MD|agents\.md|AGENTS\.MD", "AGENTS.md", "http://agents.md/"),
            (r"CLAUDE\.MD|cloud ponto MD|Claude MD", "CLAUDE.md", "http://claude.md/"),
            (r"\bgerminar MD\b", "GEMINI.md", "http://gemini.md/"),
            (r"\bMCP\b", "MCP — Server Concepts (Tools)", "https://modelcontextprotocol.io/docs/learn/server-concepts#tools"),
            (r"sub.?agente|subagents?", "Claude Docs — Sub-agents", "https://code.claude.com/docs/en/sub-agents"),
            (r"agent.?skills|tech.?leads.?club/agent-skills|redes kills", "Skills TLC (open-source)", "https://github.com/tech-leads-club/agent-skills"),
            (r"skill.?creator|anthropic.*skill", "Anthropic — skill-creator", "https://github.com/anthropics/skills/tree/main/skills/skill-creator"),
            (r"AI Engineering|Chip Huyen", "AI Engineering — Chip Huyen", "https://www.oreilly.com/library/view/ai-engineering/9781098166298/"),
            (r"Product Mind(?:red|set| Engineer)|mentalidade de produto", "Engenheiro com Mentalidade de Produto (Novatec)", "https://novatec.com.br/livros/engenheiro-software-com-mentalidade-produto/"),
            (r"Lost in the Middle|context window", "Lost in the Middle (arXiv)", "https://arxiv.org/abs/2402.01438"),
            (r"caveman", "Caveman (compactação — mencionado negativamente)", "https://github.com/juliusbrussee/caveman"),
            (r"agentic.?patterns", "agentic-patterns.com", "http://agentic-patterns.com/"),
            (r"context.?mesh", "Context-Mesh", "https://www.context-mesh.org/"),
            (r"excalidraw|escolhe draw", "Excalidraw da aula", "https://link.excalidraw.com/l/7V6DWtFSy3p/17NLUnE2HMl"),
        ],
    },
    2: {
        "title": "Spec-Driven Development, Harness e Code Review com IA",
        "speaker": "Waldemar Neto (Valdemar)",
        "summary": (
            "Parte da tarde do dia 1: limites do plano nativo para projetos grandes, intro ao "
            "Spec-Driven Development (TLC spec-driven), fases spec/design/tasks com gates e evals, "
            "sub-agentes paralelos, harness (feedforward vs feedback), comparação de ferramentas SDD, "
            "code review multi-skill com sub-agentes e benchmark vs CodeRabbit/Copilot/Bugbot."
        ),
        "topics": [
            "Limites do plano do Cursor para features grandes (ex.: Stripe)",
            "Spec-Driven Development: spec → design (opcional) → tasks atômicas",
            "Gates, evals e Definition of Done verificável por comando",
            "Tasks atômicas vs tasks do board (Jira/Linear)",
            "Implementação com sub-agentes e contexto em ~17%",
            "Conexão PRD/TDD/RPI/SDD e o que commitar no repo",
            "Harness engineering (Martin Fowler): guias vs sensores",
            "BMAD e frameworks alternativos de SDD",
            "OpenSpec, Superpowers, GitHub spec-kit",
            "Code review com IA: skills por responsabilidade (security, requirements, regressão)",
            "Comparação CodeRabbit vs Cursor Bugbot vs skill customizada",
        ],
        "refs": [
            (r"Martin fowler|harness engineering", "Martin Fowler — Harness Engineering", "https://martinfowler.com/articles/harness-engineering.html"),
            (r"Open spec|OpenSpec|openspec", "OpenSpec", "https://openspec.dev/"),
            (r"Superpower|superpowers", "Superpowers (SDD)", "https://github.com/obra/superpowers"),
            (r"BMAD|B médio|bmed", "BMAD-Method", "https://github.com/bmad-code-org/BMAD-METHOD"),
            (r"GSD|gsd.?build", "GSD", "https://github.com/gsd-build/gsd-2/"),
            (r"getdesign|getDesign|design\.md", "getDesign.md", "http://getdesign.md/"),
            (r"Kiro", "Kiro (AWS)", "https://kiro.dev/"),
            (r"Code Rabbit|CodeRabbit", "Kodus (code review)", "https://kodus.io/"),
            (r"Simon Willison|red.?green|TDD com agentes", "Simon Willison — Red/Green TDD", "https://simonwillison.net/guides/agentic-engineering-patterns/red-green-tdd/"),
            (r"Atlassian.*PRD|PRD", "Atlassian — definição de PRD", "https://www.atlassian.com/agile/product-management/requirements"),
            (r"TLC spec|spec driver|spect.?driven|espectro Driver", "Skills TLC (incl. spec-driven)", "https://github.com/tech-leads-club/agent-skills"),
            (r"pr.?review|pier review|Code review", "Skill /pr-review (gist)", "https://gist.github.com/waldemarnt/2f7e56618a8512548e1677489a912051"),
        ],
    },
    3: {
        "title": "Futuro da Carreira do Dev e Fluxo AI-Native",
        "speaker": "Felipe Adamolli",
        "summary": (
            "Talk de carreira conectando IA ao mercado de trabalho: dados de vagas, product engineer, "
            "platô de produtividade (~30–40%), fluxo de desenvolvimento ponta a ponta com IA (planejamento "
            "a produção), times menores e papéis híbridos, diferenças Brasil vs Vale do Silício, papel "
            "evolutivo do QA e 4 movimentos práticos para segunda-feira."
        ),
        "topics": [
            "Realidade vs hype: % de código gerado por IA (Cursor, Anthropic, enterprise)",
            "PMs e designers abrindo PRs; vagas de dev/PM/recruiter",
            "Platô de produtividade e gargalos além do código",
            "Disrupção bancária no Brasil como analogia de adoção",
            "Ciclo de adoção — ainda na fase dos pragmáticos",
            "O que não faz mais sentido: Scrum rígido, story points, estimativas",
            "Fluxo AI-native: Slack→Linear, PRs por risco, self-healing",
            "Product Engineer vs PM vs Builder",
            "Estrutura de times flat; managers como IC 20% do tempo",
            "Contexto de negócio (analytics, CRM) para o dev",
            "Brasil: burocracia vs empresas AI-native",
            "Papel do QA evoluindo (gate → coach/plataforma)",
            "4 dicas práticas + livros recomendados",
        ],
        "refs": [
            (r"mentalidade de produto|Product Mind|Engenheiro de Software com Mentalidade", "Engenheiro com Mentalidade de Produto (Novatec)", "https://novatec.com.br/livros/engenheiro-software-com-mentalidade-produto/"),
            (r"Staff Engineer|Will Larson|staffeng", "Staff Engineer — Will Larson", "https://staffeng.com/"),
            (r"Pragmatic Engineer|building Cursor", "Pragmatic Engineer — Building Cursor", "https://newsletter.pragmaticengineer.com/p/cursor"),
            (r"Anthropic.*Claude Code|como.*Anthropic.*usa", "How Anthropic teams use Claude Code", "https://www.anthropic.com/news/how-anthropic-teams-use-claude-code"),
            (r"Product Engineer|Product Engineering at Facebook", "Product Engineering at Facebook", "https://engineering.fb.com/2012/10/31/android/product-engineering-at-facebook/"),
            (r"How Cursor uses Cursor|Cursor uses Cursor", "How Cursor uses Cursor (YouTube)", "https://www.youtube.com/watch?v=kcBt3cuZAhI"),
            (r"AI.?native engineering|Running an AI-native", "Running an AI-native engineering org", "https://www.youtube.com/watch?v=igO8iyca2_g"),
            (r"agentic workflows.*SDLC|SDLC", "Cursor agentic workflows across SDLC", "https://www.youtube.com/watch?v=dJAVS1g3NDw"),
            (r"Claude Code.*YouTube|Building and prototyping with Claude", "Building and prototyping with Claude Code", "https://www.youtube.com/watch?v=DAQJvGjlgVM"),
            (r"excalidraw|Excalidraw", "Excalidraw da aula", "https://link.excalidraw.com/l/4Iy48DtTz4f/2PkgDWAnCaj"),
            (r"Dev Lab|waldemarnetodevlab", "Dev Lab YouTube", "https://www.youtube.com/@waldemarnetodevlab"),
        ],
    },
    4: {
        "title": "Case Velora — AI-First na Prática (ONG/Nonprofit)",
        "speaker": "Geovani (Staff Engineer, Velora — Canadá)",
        "summary": (
            "Case curto (~15 min) de empresa média (Velora, software para ONGs) adotando AI-first "
            "em toda a organização: AI champions, stack Cursor+Notion+Slack+Linear, tickets como "
            "'slices' para agentes, abandono do Scrum tradicional, bot de PR review, protótipos no "
            "Cursor por PM/design, e desafios de padronização e segurança (SOC2)."
        ),
        "topics": [
            "Velora: contexto (Canadá, ~200 pessoas, 6 times de dev)",
            "AI-first company-wide, não só engenharia",
            "Time de AI champions e entrevistas com foco em IA",
            "Stack integrada: Notion Agents, Cursor, Slack, Linear",
            "CEO prototipa → devs+CTO entregam produto em ~3 meses",
            "Scrum → To Do / In Progress / Done; tickets 'slices' para agentes",
            "TDD humano + IA expandindo detalhes e protótipos",
            "1–2 devs por projeto com autonomia ponta a ponta",
            "Bot interno de PR review com fallback humano (segurança)",
            "Design/produto saiu do Figma → protótipos no Cursor",
            "Fluxo: descoberta → PRD → TDD → slices → plan → PR → ship",
            "Desafios: padronização, homologação SOC2, volume de revisão",
            "Dicas: evangelizar, treinar, começar hoje",
        ],
        "refs": [
            (r"slides|Claudio|slide", "Slides do case (Geovani)", "https://tlc-workshop-ai.giovannymassuia.io/?slide=9"),
            (r"\bCursor\b", "Cursor", "https://www.cursor.com/"),
            (r"\bLinear\b", "Linear", "https://linear.app/"),
            (r"\bNotion\b", "Notion", "https://www.notion.so/"),
            (r"\bSlack\b", "Slack", "https://slack.com/"),
            (r"Elevate|levante", "Formação Elevate (TLC)", "https://github.com/tech-leads-club/awesome-tech-lead"),
        ],
    },
    5: {
        "title": "Spec-Driven na Prática — Compozy, Harness e Taskloopers",
        "speaker": "Rodrigo Branas",
        "summary": (
            "Workshop hands-on de Rodrigo Branas sobre Spec-Driven Development aplicado: modelo "
            "harness com guias (roles/skills) e sensores (tests, browser, CLI), gestão de contexto, "
            "projeto Compozy (orquestração de agentes), taskloopers para paralelismo, memória "
            "observacional vs RAG, design.md e bloqueio de código sem teste."
        ),
        "topics": [
            "Disrupção de UX/software via MCP e linguagem natural",
            "Harness = LLM + orquestração; guias vs sensores",
            "Context window, compactação e custo de tokens",
            "Spec-Driven na prática com skills e taskloopers",
            "Compozy — framework de orquestração de agentes",
            "Skeeper e workflows multi-agente",
            "Paralelismo de tarefas e produtividade",
            "Memória observacional vs RAG tradicional",
            "Bloqueio de código sem teste para agentes",
            "design.md / awesome-design-md",
            "Ferramentas: cmux, wt, muxy, tailwindsql, Reversa",
            "LLM local (hello world Akita on Rails)",
        ],
        "refs": [
            (r"Compozy|compozy", "Compozy", "https://github.com/compozy/compozy"),
            (r"Skeeper|skeeper", "Skeeper", "https://github.com/compozy/skeeper"),
            (r"getdesign|design\.md|awesome.?design", "getdesign.md / awesome-design-md", "http://getdesign.md/"),
            (r"memória observacional|Memória Observacional", "Memória Observacional (LinkedIn)", "https://www.linkedin.com/pulse/conhe%C3%A7a-mem%C3%B3ria-observacional-arquitetura-que-bate-at%C3%A9-mendon%C3%A7a-hupwf/"),
            (r"bloqueia.*código sem teste|bloqueio de código", "Bloqueio de código sem teste", "https://www.linkedin.com/pulse/voc%C3%AA-bloqueia-c%C3%B3digo-sem-teste-e-libera-agentes-de-ia-mendon%C3%A7a-wfkoe/"),
            (r"RAG acerta 34|seu RAG", "RAG 34% vs 91% (LinkedIn)", "https://www.linkedin.com/pulse/seu-rag-acerta-34-poderia-acertar-91-o-llm-est%C3%A1-bom-n%C3%A3o-mendon%C3%A7a-m4vwf/"),
            (r"LLM local|hello world.*LLM|Akita", "Hello World de LLM local", "https://akitaonrails.com/2025/04/25/hello-world-de-llm-criando-seu-proprio-chat-de-i-a-que-roda-local/"),
            (r"benchmark.*misturar.*modelos|misturar 2 modelos", "Benchmark — misturar 2 modelos?", "https://akitaonrails.com/2026/04/25/llm-benchmarks-vale-a-pena-misturar-2-modelos/"),
            (r"\bReversa\b", "Reversa (GitHub)", "https://github.com/sandeco/reversa"),
            (r"\bcmux\b", "cmux (Manaflow AI)", "https://github.com/manaflow-ai/cmux"),
            (r"\bwt\b.*git|thobiassilva/wt", "wt (Thobias Silva)", "https://github.com/thobiassilva/wt"),
            (r"muxy", "muxy.app", "http://muxy.app/"),
            (r"tailwindsql", "tailwindsql.com", "http://tailwindsql.com/"),
            (r"branas\.io|branas", "branas.io", "http://branas.io/"),
            (r"bridgetime", "bridgetime.cc/plan", "https://bridgetime.cc/plan"),
        ],
    },
}


def parse_shared_links(path: Path) -> list[tuple[str, str, str]]:
    """Retorna (categoria, texto, url)."""
    if not path.exists():
        return []
    text = path.read_text(encoding="utf-8")
    items: list[tuple[str, str, str]] = []
    cat = "Geral"
    for line in text.splitlines():
        if line.startswith("## "):
            cat = line[3:].strip()
        m = re.match(r"- \[(.+?)\]\((.+?)\)", line)
        if m:
            items.append((cat, m.group(1), m.group(2)))
    return items


def build_links_table(items: list[tuple[str, str, str]], num: int) -> str:
    if not items:
        return f"*Nenhum link registrado — ver [`aula-{num:02d}-shared-files.md`](./aula-{num:02d}-shared-files.md).*"
    lines = [
        f"Lista completa: [`aula-{num:02d}-shared-files.md`](./aula-{num:02d}-shared-files.md)",
        "",
        "| # | Categoria | Recurso | URL |",
        "|---|-----------|---------|-----|",
    ]
    for i, (cat, label, url) in enumerate(items, 1):
        safe_label = label.replace("|", "\\|")
        lines.append(f"| {i} | {cat} | {safe_label} | {url} |")
    return "\n".join(lines)


def build_header(num: int, meta: dict, items: list[tuple[str, str, str]]) -> str:
    topics = "\n".join(f"- {t}" for t in meta["topics"])
    links_table = build_links_table(items, num)
    speech_refs = build_speech_refs(meta, items)
    return f"""## Resumo

{meta["summary"]}

**Palestrante:** {meta["speaker"]}

## Tópicos tratados

{topics}

## Links compartilhados

{links_table}

{speech_refs}

> **Como usar:** consulte o resumo e os tópicos para contexto rápido; use a tabela numerada e a seção *Referências na fala* para cruzar o conteúdo falado com os links em [`aula-{num:02d}-shared-files.md`](./aula-{num:02d}-shared-files.md).

---

"""


def annotate_transcription(text: str, refs: list[tuple[str, str, str]], url_to_num: dict[str, int]) -> str:
    """Adiciona bloco de refs após parágrafos que mencionam recursos."""
    paragraphs = text.split("\n\n")
    out: list[str] = []
    used_global: set[str] = set()

    for para in paragraphs:
        if not para.strip():
            out.append(para)
            continue
        matched: list[str] = []
        for pattern, label, url in refs:
            if label in used_global:
                continue
            if re.search(pattern, para, flags=re.IGNORECASE):
                num = url_to_num.get(url)
                prefix = f"#{num} " if num else ""
                matched.append(f"[{prefix}{label}]({url})")
                used_global.add(label)
        out.append(para)
        if matched:
            refs_line = " · ".join(matched)
            out.append(f"> 🔗 **Links:** {refs_line}")
    return "\n\n".join(out)


def strip_inline_refs(text: str) -> str:
    text = re.sub(r" → \[[^\]]+\]\([^)]+\)", "", text)
    text = re.sub(r"\n> 🔗 \*\*Links:\*\*[^\n]*", "", text)
    return text


def build_speech_refs(meta: dict, items: list[tuple[str, str, str]]) -> str:
    """Mapeia tópicos da aula aos links da tabela."""
    url_to_num = {url: i for i, (_, _, url) in enumerate(items, 1)}
    lines = ["## Referências na fala", "", "Cruzamento entre o que foi dito e os links da tabela acima:", ""]
    for topic in meta["topics"]:
        nums: list[str] = []
        topic_lower = topic.lower()
        for i, (cat, label, url) in enumerate(items, 1):
            label_lower = label.lower()
            cat_lower = cat.lower()
            # Heurística simples: palavras-chave compartilhadas
            keys = [w for w in re.findall(r"[a-záéíóúãõç0-9]+", topic_lower) if len(w) > 3]
            if any(k in label_lower or k in cat_lower for k in keys):
                nums.append(str(i))
            elif topic_lower.split("(")[0].strip()[:20] in label_lower:
                nums.append(str(i))
        for pattern, label, url in meta["refs"]:
            if url in url_to_num and any(
                w in topic_lower for w in re.findall(r"[a-záéíóúãõç0-9]+", label.lower()) if len(w) > 4
            ):
                n = str(url_to_num[url])
                if n not in nums:
                    nums.append(n)
        if nums:
            links = ", ".join(f"#{n}" for n in sorted(set(nums), key=int))
            lines.append(f"- **{topic}** → links {links}")
        else:
            lines.append(f"- **{topic}**")
    lines.append("")
    return "\n".join(lines)


def enrich_file(num: int) -> None:
    meta = LESSONS[num]
    transcript_path = CURSO / f"aula-{num:02d}-workshop-ia-5-2026.md"
    shared_path = CURSO / f"aula-{num:02d}-shared-files.md"
    content = transcript_path.read_text(encoding="utf-8")

    # Remove bloco de enriquecimento anterior se existir
    content = re.sub(
        r"\r?\n---\r?\n\r?\n## Resumo\r?\n.*?(?=\r?\n## Transcrição\r?\n)",
        "\n---\n\n",
        content,
        count=1,
        flags=re.DOTALL,
    )
    # Remove referências inline de execuções anteriores
    content = strip_inline_refs(content)

    items = parse_shared_links(shared_path)
    header = build_header(num, meta, items)

    m = re.search(r"(---\r?\n\r?\n+)(## Transcrição\r?\n\r?\n+)", content)
    if not m:
        raise ValueError(f"Estrutura inesperada em {transcript_path.name}")

    before = content[: m.start(1) + len(m.group(1))]
    trans_rest = content[m.start(2) :]
    trans_body = re.sub(r"^## Transcrição\r?\n\r?\n+", "", trans_rest)
    url_to_num = {url: i for i, (_, _, url) in enumerate(items, 1)}
    trans_body = annotate_transcription(trans_body, meta["refs"], url_to_num)

    new_content = before + header + "## Transcrição\n\n" + trans_body
    transcript_path.write_text(new_content, encoding="utf-8")
    print(f"OK aula {num:02d}: +resumo, +{len(meta['topics'])} tópicos, tabela com {len(items)} links")


def main() -> None:
    for num in LESSONS:
        enrich_file(num)


if __name__ == "__main__":
    main()

"""
Extrai transcrição e links de múltiplas aulas via Chrome CDP.
Uso: python extract-lessons-batch.py
"""
import asyncio
import json
import re
import sys
import urllib.request
from pathlib import Path

try:
    import websockets
except ImportError:
    import subprocess
    subprocess.check_call([sys.executable, "-m", "pip", "install", "websockets", "-q"])
    import websockets

CDP = "http://127.0.0.1:9222"
SECTION_ID = "1027866"
OUT_DIR = Path(r"c:\apps\spec-pedro\doc\curso")

LESSONS = [
    {"num": 3, "id": "3906407", "url": "https://www.techleads.club/c/workshop-ia-5-2026-gravacao/sections/1027866/lessons/3906407"},
    {"num": 4, "id": "3906408", "url": "https://www.techleads.club/c/workshop-ia-5-2026-gravacao/sections/1027866/lessons/3906408"},
    {"num": 5, "id": "3906409", "url": "https://www.techleads.club/c/workshop-ia-5-2026-gravacao/sections/1027866/lessons/3906409"},
]


def vtt_to_text(vtt: str) -> str:
    lines = vtt.splitlines()
    out, prev = [], None
    for line in lines:
        line = line.strip()
        if not line or line == "WEBVTT":
            continue
        if re.match(r"[\d:\.]+\s+-->\s+[\d:\.]+", line):
            continue
        if re.match(r"^\d+$", line):
            continue
        clean = re.sub(r"<[^>]+>", "", line).strip()
        clean = clean.replace("&amp;", "&").replace("&lt;", "<").replace("&gt;", ">")
        if clean and clean != prev:
            out.append(clean)
            prev = clean
    return "\n".join(out)


def join_paragraphs(text: str) -> str:
    lines = text.splitlines()
    out, buffer = [], []

    def flush():
        if buffer:
            out.append(" ".join(buffer))
            buffer.clear()

    for line in lines:
        stripped = line.strip()
        if not stripped:
            flush()
            out.append("")
            continue
        buffer.append(stripped)
        if re.search(r"[.!?;:]\s*$", stripped):
            flush()
    flush()

    result, prev_blank = [], False
    for line in out:
        if line == "":
            if not prev_blank:
                result.append("")
            prev_blank = True
        else:
            result.append(line)
            prev_blank = False
    return "\n".join(result)


def duration_from_vtt(vtt: str) -> str:
    timestamps = re.findall(r"(\d{2}:\d{2}:\d{2})\.\d+ -->", vtt)
    return timestamps[-1] if timestamps else "?"


def categorize_links(links: list[dict]) -> dict[str, list[tuple[str, str]]]:
    skip = {
        "feed", "sign_in", "sign_up", "terms", "privacy", "notifications",
        "messages", "members", "events", "explore", "search", "oauth", "cable",
        "play.google.com/store/apps", "apps.apple.com/us/app/circle",
    }
    categories: dict[str, list[tuple[str, str]]] = {
        "Apresentação / Arquivos": [],
        "Pesquisas e Referências": [],
        "Livros": [],
        "Skills e Agentes": [],
        "MCP e Ferramentas": [],
        "Spec-Driven / Design Docs": [],
        "Code Review e Qualidade": [],
        "Contexto e Padrões": [],
        "Vídeos": [],
        "Excalidraw / Diagramas": [],
        "Canais TLC": [],
        "Outros": [],
    }

    def cat_for(text: str, href: str) -> str:
        t, h = text.lower(), href.lower()
        if "assets-v2.circle.so" in h or ".pdf" in h or ".pptx" in h or " mb" in t:
            return "Apresentação / Arquivos"
        if "excalidraw" in h:
            return "Excalidraw / Diagramas"
        if "youtube.com" in h or "youtu.be" in h:
            return "Vídeos"
        if "oreilly.com" in h or "novatec.com.br" in h:
            return "Livros"
        if "github.com/tech-leads-club" in h or "agent-skills" in h or "gist.github.com" in h or "skills" in h:
            return "Skills e Agentes"
        if "openspec" in h or "getdesign" in h or "design.md" in h or "atlassian.com/agile" in h or "stitch.withgoogle" in h:
            return "Spec-Driven / Design Docs"
        if "kodus" in h or "simonwillison" in h or "pr-review" in t:
            return "Code Review e Qualidade"
        if "mcp" in h or "claude.com/docs" in h or "agents.md" in h or "claude.md" in h or "gemini.md" in h:
            return "MCP e Ferramentas"
        if "arxiv" in h or "dora.dev" in h or "metr.org" in h or "martinfowler" in h or "medium.com" in h or "pragmaticengineer" in h:
            return "Pesquisas e Referências"
        if "substack" in h or "awesome-tech-lead" in h or "instagram.com" in h:
            return "Canais TLC"
        if "bmad" in h or "gsd-build" in h or "superpowers" in h or "kiro.dev" in h or "aiox-core" in h:
            return "Skills e Agentes"
        if "context-mesh" in h or "gitagent" in h or "agentic-patterns" in h or "caveman" in h or "context-mode" in h:
            return "Contexto e Padrões"
        return "Outros"

    seen = set()
    for item in links:
        text, href = item.get("text", "").strip(), item.get("href", "").strip()
        if not text or not href or len(text) < 2:
            continue
        if any(s in href for s in skip):
            continue
        if href in seen:
            continue
        is_external = "techleads.club" not in href and "circle.so" not in href
        is_asset = "assets-v2.circle.so" in href
        if not is_external and not is_asset:
            continue
        seen.add(href)
        categories[cat_for(text, href)].append((text, href))

    return {k: v for k, v in categories.items() if v}


async def send(ws, method, params=None, cid=1):
    await ws.send(json.dumps({"id": cid, "method": method, "params": params or {}}))
    while True:
        msg = json.loads(await asyncio.wait_for(ws.recv(), 30))
        if msg.get("id") == cid:
            return msg.get("result", {})


async def js(ws, code, cid=99):
    r = await send(ws, "Runtime.evaluate", {
        "expression": code, "returnByValue": True, "awaitPromise": True
    }, cid)
    ex = r.get("exceptionDetails")
    if ex:
        raise RuntimeError(ex.get("text", str(ex)))
    return r.get("result", {}).get("value")


def find_transcript_id(resources: list[str]) -> tuple[str | None, str | None]:
    techleads = [
        u for u in resources
        if "media_transcripts/" in u and u.endswith(".vtt") and "techleads.club" in u
    ]
    vtt_url = techleads[-1] if techleads else None
    if not vtt_url:
        candidates = [u for u in resources if "media_transcripts/" in u and u.endswith(".vtt")]
        vtt_url = candidates[-1] if candidates else None
    if not vtt_url:
        vtt_url = next((u for u in reversed(resources) if ".vtt" in u), None)
    transcript_id = None
    if vtt_url:
        m = re.search(r"media_transcripts/(\d+)", vtt_url)
        if m:
            transcript_id = m.group(1)
    return transcript_id, vtt_url


async def extract_lesson(ws, lesson: dict, cid_base: int) -> dict:
    num, lid, url = lesson["num"], lesson["id"], lesson["url"]
    print(f"\n=== Aula {num} ({lid}) ===")

    await js(ws, f"""
(function() {{
  if (performance.clearResourceTimings) performance.clearResourceTimings();
  window.location.href = {json.dumps(url)};
}})()
""", cid=cid_base)
    await asyncio.sleep(15)

    await js(ws, """
(function(){
  var v = document.querySelector('video');
  if (v) { v.play().catch(function(){}); return 'video'; }
  return 'no-video';
})()
""", cid=cid_base + 1)
    await asyncio.sleep(5)

    resources_raw = await js(ws, """
JSON.stringify(
  window.performance.getEntriesByType('resource')
    .map(r => r.name)
    .filter(u => u.includes('vtt') || u.includes('transcript') || u.includes('media_transcript'))
)
""", cid=cid_base + 2)
    resources = json.loads(resources_raw) if resources_raw else []
    transcript_id, vtt_url = find_transcript_id(resources)

    if not vtt_url and transcript_id:
        vtt_url = f"https://www.techleads.club/media_transcripts/{transcript_id}.vtt"
    if not vtt_url:
        html = await js(ws, "document.documentElement.outerHTML", cid=cid_base + 3) or ""
        m = re.search(r"media_transcripts[/\"]+(\d+)", html)
        if m:
            transcript_id = m.group(1)
            vtt_url = f"https://www.techleads.club/media_transcripts/{transcript_id}.vtt"

    if not vtt_url:
        raise RuntimeError(f"VTT nao encontrado para aula {num}. Carregue o video completamente.")

    vtt = await js(ws, f"""
(async () => {{
  const r = await fetch({json.dumps(vtt_url)}, {{credentials: 'include'}});
  if (!r.ok) return 'ERROR:' + r.status;
  return await r.text();
}})()
""", cid=cid_base + 4)

    if not vtt or str(vtt).startswith("ERROR"):
        raise RuntimeError(f"Erro VTT aula {num}: {vtt}")

    links_json = await js(ws, """
(function(){
  var seen = {};
  var result = [];
  Array.from(document.querySelectorAll('a[href]')).forEach(function(a) {
    var href = (a.href || '').trim();
    var text = (a.innerText || a.textContent || '').trim().replace(/\\s+/g, ' ');
    if (!href || href.startsWith('javascript') || seen[href]) return;
    seen[href] = 1;
    result.push({text: text.substring(0, 150), href: href});
  });
  return JSON.stringify(result);
})()
""", cid=cid_base + 5)
    links = json.loads(links_json) if links_json else []

    title = await js(ws, """
(function(){
  var h = document.querySelector('h1, h2, [class*="lesson-title"], [class*="LessonTitle"]');
  return h ? h.innerText.trim() : document.title;
})()
""", cid=cid_base + 6) or f"Aula {num:02d}"

    href = await js(ws, "location.href", cid=cid_base + 7)
    if lid not in (href or ""):
        raise RuntimeError(f"Navegacao falhou: esperado {lid}, atual {href}")

    text = join_paragraphs(vtt_to_text(vtt))
    dur = duration_from_vtt(vtt)

    transcript_md = f"""# Aula {num:02d} — {title}

**URL:** {url}  
**Seção:** {SECTION_ID} | **Aula:** {lid} | **Transcript ID:** {transcript_id or '?'}  
**Duração aproximada:** {dur}

---

## Transcrição

{text}
"""
    transcript_path = OUT_DIR / f"aula-{num:02d}-workshop-ia-5-2026.md"
    transcript_path.write_text(transcript_md, encoding="utf-8")

    cats = categorize_links(links)
    link_lines = [
        f"# Aula {num:02d} — Arquivos e Links Compartilhados",
        "",
        f"**Aula:** {title}",
        f"**URL:** {url}",
        "",
        "---",
        "",
    ]
    for cat, items in cats.items():
        link_lines += [f"## {cat}", ""]
        for text_l, href in items:
            link_lines.append(f"- [{text_l}]({href})")
        link_lines.append("")

    link_lines += ["---", "", "> *Gerado via Chrome DevTools Protocol.*"]
    links_path = OUT_DIR / f"aula-{num:02d}-shared-files.md"
    links_path.write_text("\n".join(link_lines), encoding="utf-8")

    print(f"  Transcript ID: {transcript_id} | Dur: {dur} | Chars: {len(text)}")
    print(f"  Salvo: {transcript_path.name}, {links_path.name} ({sum(len(v) for v in cats.values())} links)")
    print(f"  Inicio: {text[:100]}...")

    return {"num": num, "transcript_id": transcript_id, "dur": dur, "chars": len(text)}


async def main(lesson_filter: list[int] | None = None):
    lessons = [l for l in LESSONS if lesson_filter is None or l["num"] in lesson_filter]
    if not lessons:
        print("Nenhuma aula para processar.", file=sys.stderr)
        sys.exit(1)

    with urllib.request.urlopen(f"{CDP}/json", timeout=5) as r:
        tabs = json.loads(r.read())
    tab = next((t for t in tabs if t.get("type") == "page" and "techleads" in t.get("url", "")), None)
    if not tab:
        print("Abra o Tech Leads Club no Chrome com CDP (porta 9222).", file=sys.stderr)
        sys.exit(1)

    results = []
    async with websockets.connect(tab["webSocketDebuggerUrl"], max_size=50 * 1024 * 1024) as ws:
        for i, lesson in enumerate(lessons):
            try:
                results.append(await extract_lesson(ws, lesson, cid_base=100 * (i + 1)))
            except Exception as e:
                print(f"  ERRO aula {lesson['num']}: {e}", file=sys.stderr)
                results.append({"num": lesson["num"], "error": str(e)})

    print("\n=== Resumo ===")
    for r in results:
        if "error" in r:
            print(f"Aula {r['num']}: FALHOU - {r['error']}")
        else:
            print(f"Aula {r['num']}: OK (ID {r['transcript_id']}, {r['dur']}, {r['chars']} chars)")

    if any("error" in r for r in results):
        sys.exit(1)


if __name__ == "__main__":
    nums = [int(x) for x in sys.argv[1:]] if len(sys.argv) > 1 else None
    asyncio.run(main(nums))

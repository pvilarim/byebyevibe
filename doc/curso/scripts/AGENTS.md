# AGENTS.md — Scripts do curso (Workshop IA 5/2026)

Instruções locais para `doc/curso/scripts/`. O canónico na raiz do repo é `../../../AGENTS.md`.

## Commands

| Comando | Uso |
|---------|-----|
| `python extract-lessons-batch.py` | Extrair transcrições e links (Chrome CDP) |
| `python enrich-transcripts.py` | Enriquecer MDs (resumo, tópicos, refs) |
| `python _debug-lessons345.py` | Debug de transcript IDs (temporário) |

## Pré-requisitos

- Chrome com `--remote-debugging-port=9222` e profile autenticado (Tech Leads Club)
- Python 3.10+

## Regras locais

- Chamar `performance.clearResourceTimings()` antes de navegar para cada lesson (batch)
- Preferir VTT de `techleads.club/media_transcripts/`
- Não commitar tokens, cookies ou credenciais de sessão
- Herdar protocolo A–E e segurança do `AGENTS.md` raiz

## Fluxo

1. `extract-lessons-batch.py` → `aula-XX-workshop-*.md` + `aula-XX-shared-files.md`
2. `enrich-transcripts.py` → cabeçalho estruturado + refs na transcrição

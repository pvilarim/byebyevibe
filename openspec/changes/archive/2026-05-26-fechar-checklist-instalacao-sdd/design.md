# Design — Fechar checklist de instalação SDD

## Context

- Guia canónico: `doc/sistema-sdd-pedro.md` v1.1.0, §2.8 define 11 itens de verificação.
- Piloto `spec-pedro` (perfil DOCS_SPECS): commit `65b025e` já aplicou AGENTS.md, OpenSpec harness, `.cursor/`, `.claude/`.
- Change activo `update-sdd-install-guide-agents-format`: 17/18 tasks; falta validação IDE/`/opsx:propose`.
- Utilizador executou `/opsx-propose fechar o checklist` — prova parcial do slash command.

## Goals / Non-Goals

**Goals:**

- Checklist §2.8 100% verificado e rastreável.
- Change `update-sdd-install-guide-agents-format` arquivado com specs fundidas.
- Primeira capability em `openspec/specs/sdd-post-install-verification/`.

**Non-Goals:**

- Reinstalar ferramentas (OpenSpec, GitNexus, Graphify) — já presentes.
- Alterar conteúdo do guia v1.1 (só marcar exemplo de checklist preenchido se útil).
- Commitar scripts Python untracked em `doc/curso/scripts/`.

## Decisions

| ID | Decisão | Rationale |
|----|---------|-----------|
| D1 | Evidência em `VERIFICATION.md` dentro do change antes de archive | Audit trail sem poluir `doc/` |
| D2 | Arquivar `update-sdd-install-guide-agents-format` após marcar tasks | Evita dois changes activos sobre o mesmo trabalho |
| D3 | Spec `sdd-post-install-verification` espelha §2.8 | Fonte normativa reutilizável em futuros repos |
| D4 | Não criar spec `curso-transcripts` neste change | Escopo separado; fora do fecho de checklist |

## Risks / Trade-offs

| Risco | Mitigação |
|-------|-----------|
| Slash commands não carregam até reiniciar IDE | Item explícito em tasks; utilizador confirma |
| `openspec archive` falha sem specs | Criar spec nova antes de archive do change antigo |
| Graphify/GitNexus stale após dias | Re-correr `graphify update .` e `gitnexus status` no apply |

## Migration Plan

1. Completar artefactos deste change (`fechar-checklist-instalacao-sdd`).
2. `/opsx:apply` — executar tasks (verificação + VERIFICATION.md).
3. `/opsx:archive` em `update-sdd-install-guide-agents-format`.
4. `/opsx:archive` em `fechar-checklist-instalacao-sdd` quando apply concluído.

## Open Questions

- Nenhuma crítica; utilizador já reiniciou IDE se `/opsx:propose` respondeu.

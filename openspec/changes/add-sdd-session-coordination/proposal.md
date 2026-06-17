# Proposal — Coordenação de sessões SDD (máquina local)

## Why

Numa única máquina com várias sessões Cursor/VS Code/Claude Code na **mesma working copy**, o risco não é merge Git — é **dois agentes a editar o mesmo working tree** (status sujo partilhado, commits que capturam ficheiros do vizinho, last-write-wins). O handoff entre fases (`sdd-session-handoff`) resolve transição explore→apply no **mesmo chat**, mas não detecta **concorrência entre chats**.

Cenário alvo: operador com 1 PC, N sessões, opcionalmente worktrees para paralelismo seguro.

## What Changes

- Nova capability **`sdd-session-coordination`**: locks locais (`flock`), registo de presença, scripts `sdd-session-*`, regra always-on `016-session-coordination.mdc`.
- **`/opsx:apply`** (e opcionalmente propose com escrita) MUST correr `sdd-session-check.sh` antes de editar ficheiros; bloquear apply concorrente na mesma worktree.
- **`AGENTS.md`**: R11 (coordenação local) + comando na tabela Commands (~3 linhas; manter ≤150).
- **`doc/sistema-sdd-pedro.md`**: §3.3 (paralelismo + worktree + locks), §2.8 checklist, §12.2 template AGENTS, `bootstrap-sdd.sh` referência.
- **`openspec/infra.md`**: secção Session Coordination (scripts + paths).
- **`.gitignore`**: `.sdd/runtime/` (locks locais, não versionados).
- Delta em **`sdd-post-install-verification`**: itens de checklist pós-instalação.
- Delta em **`sdd-session-handoff`**: apply MUST libertar lock ao concluir/pausar.

## Onde vive a verdade (não é um documento único)

| Camada | Ficheiro | Papel |
|--------|----------|-------|
| **Entrada canónica agentes** | `AGENTS.md` | R11 + comando `sdd-session-status` (curto, always-loaded) |
| **Requisitos normativos** | `openspec/specs/sdd-session-coordination/` | Spec testável (fonte R2) |
| **Guia operacional humano+IA** | `doc/sistema-sdd-pedro.md` §3.3, §2.8 | Detalhe, worktree, checklist instalação |
| **Manifesto infra** | `openspec/infra.md` | Scripts ✅ e paths |
| **Enforcement IDE** | `.cursor/rules/016-session-coordination.mdc` | alwaysApply |
| **Execução** | `scripts/sdd-session-*.sh` | Comportamento determinístico |

**Não** duplicar o design completo em `AGENTS.md` — seguir o mesmo padrão de R10 + `openspec/infra.md` + handoff (`add-session-handoff-infra-manifest`).

## Aplicação em cada instalação SDD

Sempre que o stack SDD for instalado ou actualizado num repo (APP, DOCS_SPECS, HYBRID):

1. Scripts copiados/actualizados via templates §12 + checklist §2.8.
2. Regra `016-session-coordination.mdc` presente.
3. Skills apply/propose referem session-check.
4. `verify-infra.sh` valida scripts executáveis.

Repos **sem** SDD não recebem isto automaticamente — só via bootstrap ou upgrade §2.9.

## Capabilities

### New Capabilities

- `sdd-session-coordination`: locks locais, presença, detecção apply paralelo na mesma worktree, integração skills apply, checklist §2.8.

### Modified Capabilities

- `sdd-post-install-verification`: itens `scripts/sdd-session-check.sh`, `016-session-coordination.mdc`, `.sdd/runtime/` no gitignore.
- `sdd-session-handoff`: apply MUST registar/libertar lock; handoff em pause inclui `sdd-session-release`.

## Impact

- `scripts/sdd-session-{register,heartbeat,check,status,release}.sh` — novos
- `.cursor/rules/016-session-coordination.mdc` — novo
- `.cursor/skills/openspec-apply-change/SKILL.md` (+ espelhos Claude/commands) — session-check no início/fim
- `.cursor/skills/openspec-propose/SKILL.md` — advisory status (opcional)
- `AGENTS.md`, `doc/sistema-sdd-pedro.md`, `openspec/infra.md`, `.gitignore`
- `scripts/verify-infra.sh` — validar scripts session
- `scripts/bootstrap-sdd.sh` — mencionar session coordination no pós-bootstrap
- Perfil DOCS_SPECS: implementação **neste** repo; repos APP recebem via instalação SDD (mesmos artefactos)

## Non-Goals

- Detecção nativa de outros chats Cursor (sem API pública).
- Locks distribuídos multi-máquina.
- Extensão VS Code (fase 2 opcional, fora deste change).
- Bloquear explore/propose read-only (apenas advisory).

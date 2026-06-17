# Design — Coordenação de sessões SDD (máquina local)

## Context

- Exploração prévia: risco = working tree partilhada, não Git merge.
- Constraint operacional confirmado: **uma máquina**, N sessões IDE.
- `sdd-session-handoff` já cobre fase única por chat; falta coordenação de **escrita concorrente**.
- Workshop Branas (aula 05): worktree para paralelismo; evitar 2 writers na mesma tree.
- `AGENTS.md` ≤150 linhas; detalhe em specs + guia SDD (padrão R10/infra).

## Goals / Non-Goals

**Goals:**

- Bloquear apply concorrente na **mesma worktree** (mesma pasta de trabalho).
- Permitir apply paralelo em **worktrees diferentes** (locks por path).
- Registo de presença legível por humano (`sdd-session-status`).
- Integrar em instalação SDD (§2.8) e skills `/opsx:apply`.
- Fonte normativa em `openspec/specs/sdd-session-coordination/`.

**Non-Goals:**

- API Cursor para listar chats.
- Redis/lock remoto.
- Extensão VS Code (documentar como fase 2).
- Impedir explore read-only.

## Decisions

| ID | Decisão | Rationale | Alternativa rejeitada |
|----|---------|-----------|----------------------|
| D1 | `flock` em `.sdd/runtime/apply.lock` por worktree | Exclusão OS-level fiável numa máquina; não depende do agente obedecer | Só JSON de presença — race sem flock |
| D2 | `.sdd/runtime/` gitignored | Locks são estado local efémero | Versionar locks — poluição de commits |
| D3 | JSON de presença em `.sdd/runtime/sessions/<id>.json` | UX + advisory; heartbeat TTL 5 min | Só flock — sem metadata para o utilizador |
| D4 | Bloqueio hard em **apply**; advisory em explore/propose | Apply é o risco real | Bloquear tudo — friccção excessiva |
| D5 | R11 em AGENTS.md (~2 linhas) + spec + §3.3 guia | Padrão canónico do repo (não monolito) | Tudo em AGENTS.md — estoura 150 linhas |
| D6 | `sdd-session-check.sh` no início de apply skill | Enforcement no momento certo | Só rule — agente pode ignorar antes de editar |
| D7 | `sdd-session-release.sh` no fim/pause apply | Evita locks stale desnecessários | TTL só — 5 min de bloqueio após crash aceitável |
| D8 | Escopo por `change-id` + `paths_scope` no JSON | Detecta overlap de changes | Só worktree — não avisa paths sobrepostos no mesmo tree após flock libertado |
| D9 | Integrar §2.8 + verify-infra | “Cada instalação SDD” = checklist obrigatório | Só doc — fácil esquecer |

## Architecture

```
┌─────────────────────────────────────────────────────────────┐
│  AGENTS.md R11  →  016-session-coordination.mdc (always)    │
│  openspec-apply SKILL → sdd-session-check (início)        │
│                       → sdd-session-release (fim/pause)   │
└──────────────────────────┬──────────────────────────────────┘
                           ▼
              .sdd/runtime/          (gitignored)
              ├── apply.lock         ← flock exclusivo (apply)
              └── sessions/
                  └── <uuid>.json    ← presença + heartbeat
```

### Session JSON schema

```json
{
  "session_id": "uuid",
  "phase": "apply",
  "change_id": "add-user-auth",
  "worktree_path": "/abs/path/to/repo",
  "branch": "main",
  "paths_scope": ["openspec/changes/add-user-auth/**"],
  "pid": 12345,
  "started_at": "ISO8601",
  "heartbeat_at": "ISO8601"
}
```

### Conflict rules (`sdd-session-check.sh`)

| Condição | Resultado |
|----------|-----------|
| `flock` apply.lock falha | Exit 1 — outro apply na mesma worktree |
| Outra sessão apply, mesmo `worktree_path`, heartbeat < 5 min | Exit 1 + mensagem |
| Worktrees diferentes | Exit 0 |
| Fase explore/propose | Exit 0 (advisory em status) |
| Lock stale (heartbeat > 5 min, PID morto) | Exit 0 + warning; opcional `--clean-stale` |

### Scripts

| Script | Função |
|--------|--------|
| `sdd-session-register.sh` | Cria JSON + adquire flock (apply) |
| `sdd-session-heartbeat.sh` | Actualiza `heartbeat_at` |
| `sdd-session-check.sh` | Valida conflitos; usado pela skill apply |
| `sdd-session-status.sh` | Lista sessões activas (humano/agente) |
| `sdd-session-release.sh` | Remove JSON + liberta flock |

## Documentação canónica (resposta ao utilizador)

**Não** vai tudo num único documento. Hierarquia:

1. **`AGENTS.md`** — ponteiro R11 + comando (agente lê sempre).
2. **`openspec/specs/sdd-session-coordination/spec.md`** — requisitos (fonte de verdade normativa).
3. **`doc/sistema-sdd-pedro.md`** — procedimento humano (worktree, checklist, exemplos bash).
4. **`openspec/infra.md`** — estado dos scripts após `verify-infra.sh`.

Instalação SDD em **qualquer** repo: templates §12 propagam os mesmos ficheiros; §2.8 valida presença.

## Risks / Trade-offs

| Risco | Mitigação |
|-------|-----------|
| Agente ignora session-check | flock ainda bloqueia segundo apply; rule 016 reforça |
| Crash sem release | flock libertado com processo; TTL limpa JSON stale |
| Utilizador corre apply manual sem script | Documentar; pre-commit opcional (fase 2) |
| Windows paths | Scripts usam paths absolutos; testar Git Bash/WSL |

## Migration Plan

1. Apply deste change no repo piloto `spec-pedro`.
2. Actualizar §2.8 e correr checklist.
3. Archive → promove spec para `openspec/specs/`.
4. Repos APP existentes: upgrade SDD §2.9 aplica MERGE nos templates.

## Open Questions

- Windows nativo sem Git Bash: validar `flock` — se falhar, fallback `mkdir` atómico documentado em fase 2.

## Implementation Notes

### Skill apply — bloco a inserir (início)

```markdown
## Session coordination (apply)

Antes de editar ficheiros:

\`\`\`bash
bash scripts/sdd-session-register.sh --phase apply --change-id "<id>"
bash scripts/sdd-session-check.sh --phase apply --change-id "<id>"
\`\`\`

Se exit ≠ 0: **parar** e informar o utilizador (outro apply activo na mesma worktree).

Ao concluir ou pausar:

\`\`\`bash
bash scripts/sdd-session-release.sh
\`\`\`
```

### Rule 016 (outline, ~20 linhas)

- Apply MUST correr session-check antes de writes.
- Paralelismo seguro = worktree separado.
- Referir `doc/sistema-sdd-pedro.md` §3.3.

### verify-infra.sh delta

- `test -x scripts/sdd-session-check.sh`
- `grep -q '.sdd/runtime' .gitignore`

## Context

### Estado actual

- **G2** em `explore-oss-coverage-gaps/research.md`: R6 sem enforcement; candidato original TDD Guard (PreToolUse + reporters por test runner).
- **Supersessão (2026-07):** [Probity](https://github.com/nizos/probity) é o sucessor oficial — lê transcript da sessão (prompts, test runs, edits) em vez de reporters customizados ([migrating-from-tdd-guard.md](https://github.com/nizos/probity/blob/main/docs/migrating-from-tdd-guard.md)).
- **Stack SDD:** GitNexus + Graphify já usam PreToolUse; Probity será o terceiro hook in-band (modo B — único gap assim).
- **Precedente:** C1-UI (`install-ui-module.sh`, spec `sdd-ui-module`, `doc/design/002-ui-module-install.md`).
- **Pipeline reviews:** `correctness-review` posicionada "após testes (R6/TDD Guard)" — texto desactualizado.

### Verificações Fase 0

| # | Verificação | Resultado |
|---|-------------|-----------|
| V1 | Já instalado? | Não — `openspec/infra.md` não lista Probity |
| V2 | Superfície | PreToolUse (modo B) — partilha com GitNexus/Graphify |
| V3 | Colisão | Nenhuma — `probity.config.ts` e `install-probity-module.sh` livres |
| V4 | Perfil | APP/HYBRID com testes; SKIP DOCS_SPECS |
| V5 | Empilhamento hooks | **Piloto obrigatório** — medir p95 com 3 hooks |
| F1 | Segurança | `@nizos/probity@1.10.0` pinado; advisories antes de apply; `forbidCommandPattern(/rm\s+-rf/)` opcional alinhado `050-security` |
| F2 | Licença | MIT |
| F3 | Governança | Activo — v1.10.0 npm (jul/2026); maintainer nizos (mesmo de TDD Guard) |
| F4 | Reversibilidade | `install-probity-module.sh --uninstall` + remover plugin/hook |
| F5 | Operabilidade | Globs excluem docs; desinstalar plugin = desligar módulo |

### Fontes externas (R8)

| Recurso | URL |
|---------|-----|
| Probity repo | https://github.com/nizos/probity |
| Setup (Claude Code, Codex, Copilot CLI) | https://github.com/nizos/probity/blob/main/docs/setup.md |
| Rules (`enforceTdd`, `forbidCommandPattern`, `requireCommand`) | https://github.com/nizos/probity/blob/main/docs/rules.md |
| Migração TDD Guard → Probity | https://github.com/nizos/probity/blob/main/docs/migrating-from-tdd-guard.md |
| TDD Guard (legado) | https://github.com/nizos/tdd-guard — "grew into Probity" |
| Cursor third-party hooks | https://cursor.com/docs/reference/third-party-hooks |
| npm | `@nizos/probity@1.10.0` |

---

## Goals / Non-Goals

**Goals:**

- Materializar R6 em repos APP/HYBRID via `enforceTdd()` no PreToolUse durante apply
- Módulo opcional pós-C1 com `--detect` / `--apply` / `--dry-run` / `--yes`
- Substituir TDD Guard por Probity em toda a documentação SDD (nota histórica preservada)
- Registar nos 6 pontos do contrato; delta spec `sdd-probity-module`
- Piloto quantificado antes de MANIFEST bump
- Fail-closed: kit MUST shipar `probity.config.ts` template (sem config, Probity bloqueia)

**Non-Goals:**

- Integrar TDD Guard no kit (legado; só mencionar migração)
- Probity obrigatório em DOCS_SPECS
- Substituir CI (`sdd-gates` + `npm test` no merge)
- Duplicar lint integration do TDD Guard (`requireCommand` lint antes de commit — documentar como gap opcional)
- Rule always-on `.mdc` para Probity
- `eval` do campo `gate:` no MANIFEST (F-SEC-5)

---

## Decisions

### D1: Ferramenta — Probity, não TDD Guard

**Escolha:** `@nizos/probity@1.10.0` como candidato G2 definitivo.

**Rationale:** Maintainer oficial supersedeu TDD Guard; Probity elimina reporters por test runner (lê transcript); suporta Vitest + pytest (stack em `openspec/project.md`); mesma superfície PreToolUse.

**Alternativa descartada:** TDD Guard — legado; reporters extra; maintainer recomenda Probity para novos projectos.

---

### D2: Modo de acionamento — B (in-band), não C

**Escolha:** PreToolUse hook via plugin Claude Code (`/plugin install probity@probity`) ou `.claude/settings.json` manual.

**Rationale:** G2 exige interceptar Write/Edit sem teste falhando — só hook cumpre. `metodologia-insercao.md` reserva modo B a G2.

**Desligar (substitui toggle TDD Guard):**

| Método | Quando |
|--------|--------|
| Globs em `probity.config.ts` | Excluir `doc/**`, `openspec/**`, `sdd-kit/**` — tipo A/docs |
| Classificação A–E (R1) | Tipo A: agente não edita código de produção; globs como rede de segurança |
| Desinstalar plugin / remover hook | Sessão só-docs ou operador prefere R6 manual |
| `--detect` SKIP | Repo sem test runner (Vitest/Jest/pytest) |

---

### D3: Config template — `probity.config.ts`

**Escolha:** Template no kit com scope restrito a código de produção e testes.

```ts
import { defineConfig, enforceTdd, forbidCommandPattern } from '@nizos/probity'

export default defineConfig({
  rules: [
    {
      files: [
        'app/**', 'components/**', 'lib/**', 'src/**',
        '**/*.{test,spec}.{ts,tsx,js,jsx}',
        'tests/**', 'test/**', '__tests__/**',
        '!doc/**', '!openspec/**', '!sdd-kit/**',
      ],
      rules: [
        enforceTdd({
          instructions: (defaults) => `${defaults}

### SDD R6 addendum
- Bug fix (tipo B): MUST demonstrate a failing test reproducing the bug before changing production code.
- Refactor (tipo C): existing tests MUST stay green; new behaviour requires new failing tests first.
- Feature (tipo D): red-green-refactor cycle per acceptance criterion.`,
        }),
      ],
    },
    forbidCommandPattern({
      match: /rm\s+-rf/,
      reason: 'Destructive rm blocked per SDD security rule 050-security.',
    }),
  ],
})
```

**Notas:**

- `fastPath: false` por defeito (validator AI verifica refactor step)
- Python: instalar `@ast-grep/lang-python` no mesmo scope se pytest fast-path desejado
- Sem config na raiz → Probity fail-closed (bloqueia writes)

---

### D4: Script kit — `install-probity-module.sh`

**Escolha:** Script separado de `install.sh`, análogo C1-UI.

**Fluxo:**

1. `--detect`: verifica `package.json` + test runner (vitest/jest/pytest em scripts ou deps); SKIP se DOCS_SPECS sem testes
2. `--dry-run`: lista operações
3. `--apply`: copia `probity.config.ts`, `npm install -D @nizos/probity@1.10.0`, actualiza `openspec/infra.md`, instruções plugin/hook
4. `--yes`: aceita instalação npm sem prompt interactivo
5. `--uninstall`: remove config, hook entries documentadas, devDependency

**Não faz:** alterar C1 core; instalar TDD Guard; modificar blocos `<!-- gitnexus:start -->` em AGENTS.md

---

### D5: Empilhamento PreToolUse (GitNexus + Graphify + Probity)

**Ordem sugerida no hook array:** GitNexus → Graphify → Probity (Probity último — decisão de bloqueio TDD após indexação).

**Risco:** latência acumulada por edit + custo LLM do validator Probity.

**Mitigação:** scope `files` restrito; `maxEvents`/`maxContentChars` default; piloto mede p95.

---

### D6: Suporte Cursor IDE

**Estado:** [NEEDS VERIFICATION] — Cursor suporta third-party hooks ([docs](https://cursor.com/docs/reference/third-party-hooks)); mapeamento PreToolUse Claude → preToolUse Cursor a validar no piloto.

**Plano piloto:**

1. Testar `.cursor/hooks.json` com `npx @nizos/probity --agent claude-code` (ou flag Cursor quando documentada)
2. Confirmar Write/Edit disparam hook
3. Se falhar: documentar em guia §2.16 "Claude Code primário; Cursor — [resultado piloto]"

Probity oficialmente suporta: Claude Code, Codex, GitHub Copilot CLI — **não** Cursor nativamente ainda.

---

### D7: Matriz A–E (acionamento)

| Tipo | Probity enforceTdd | correctness-review | CI sdd-gates |
|------|-------------------|-------------------|--------------|
| A — Trivial | off (globs) | não | roda |
| B — Bug fix | **on** | sim | roda |
| C — Refactor | on | sim (diff > ~80 linhas) | roda |
| D — Feature | on | sim | roda |
| E — Exploração | n/a (sem código prod) | n/a | valida artefactos |

**Pipeline actualizada:**

```
/opsx:apply → [implementação] → enforceTdd (R6/Probity)
  → correctness-review (B/C/D)
  → simplify-review (opcional)
  → security-reviewer (se aplicável)
  → commit → sdd-gates (CI)
```

---

### D8: Contrato de 6 pontos

| # | Destino | Conteúdo |
|---|---------|----------|
| R1 | `openspec/infra.md` + template | `@nizos/probity@1.10.0` · módulo opcional · `test -f probity.config.ts` |
| R2 | `AGENTS.md` + `AGENTS.core.md` | ≤10 linhas Integrações; matriz A–E; pipeline reviews |
| R3 | `.claude/skills/probity-guard/` + espelho `.cursor/skills/` | **Só se** AGENTS.md >10 linhas após R2; description = quando consultar troubleshooting |
| R4 | `doc/sistema-sdd-pedro.md` §2.16 | Humano: install, piloto, Cursor, desligar, rollback |
| R5 | `doc/avaliacoes/` G2 | "Adoptado" após archive |
| R6 | `sdd-kit/install-probity-module.sh`, templates, MANIFEST bump, `verify.sh` check |

Pós-install: `graphify update .` + `npx gitnexus analyze --force`

---

### D9: Lint gap (opcional, não no scope apply inicial)

TDD Guard integrava lint-before-commit. Probity oferece `requireCommand({ before: git commit, command: /npm run lint/ })` — **não** incluir no template default (repos SDD variam em linter). Documentar em §2.16 como opt-in.

---

### D10: Skill opcional `probity-guard`

**Escolha:** criar skill só se R2 exceder ~10 linhas em Integrações.

**Conteúdo mínimo:** quando auto-invocar (troubleshooting bloqueio enforceTdd, override temporário, desinstalar), links para guia §2.16.

---

## Risks / Trade-offs

| Risco | Mitigação |
|-------|-----------|
| Latência PreToolUse p95 inaceitável com 3 hooks | Piloto quantificado; scope `files`; abortar promoção MANIFEST se critério falhar |
| Falsos positivos em refactor tipo C | Piloto N sessões; tuning `instructions`; override temporário documentado |
| Cursor sem suporte nativo | Piloto; fallback Claude Code; documentar limitação |
| Custo LLM por write (validator AI) | Scope restrito; `maxEvents` default; orçamento no piloto |
| Agente re-propor TDD Guard | Nota histórica em research/avaliação |
| Sem config → bloqueio total | Kit MUST shipar template; `--detect` avisa |

---

## Piloto (Fase 2 — obrigatório antes MANIFEST)

**Repo:** worktree APP com Vitest ou pytest — **não** este hub DOCS_SPECS.

**Pré-requisitos:** C1 + GitNexus + Graphify activos; R11 register/check/release.

### Critérios de sucesso (quantificados)

| Critério | Threshold | Medição |
|----------|-----------|---------|
| Latência PreToolUse extra p95 | **< 8s** por Write/Edit com 3 hooks activos | `--debug` JSONL Probity + timestamps hook; N≥30 edits |
| Falsos positivos tipo C | **< 15%** bloqueios injustificados | N≥5 sessões apply tipo C; operador classifica |
| Tipo B R6 compliance | **100%** bugs com teste falhando antes do fix | N≥3 sessões tipo B |
| Cursor IDE hooks | Write/Edit disparam hook **OU** documentar "só Claude Code" | Teste manual 10 edits |

**Falha:** decisão "Adiado" em avaliação; artefactos removidos do repo piloto; MANIFEST não bumped.

---

## Migration Plan

### Apply (esta change — hub DOCS_SPECS)

1. Criar script + templates no sdd-kit (sem activar neste repo)
2. Actualizar documentação (lista canónica em `tasks.md`)
3. Promover spec `sdd-probity-module`
4. Actualizar delta `sdd-correctness-review`

### Pós-apply (operador APP)

```bash
bash sdd-kit/install-probity-module.sh --detect
bash sdd-kit/install-probity-module.sh --apply --yes
/plugin marketplace add nizos/probity
/plugin install probity@probity
# Reiniciar sessão Claude Code
```

### Rollback

```bash
bash sdd-kit/install-probity-module.sh --uninstall
/plugin uninstall probity@probity
npm uninstall @nizos/probity
rm -f probity.config.ts
# Reverter openspec/infra.md secção Probity
```

---

## Open Questions

1. **Cursor hooks:** resultado do piloto determina se §2.16 lista Cursor como suportado ou "Claude Code only".
2. **Skill probity-guard:** criar ou não depende do tamanho final de AGENTS.md Integrações (decisão no apply).
3. **MANIFEST version bump:** só após piloto verde — apply desta change pode deixar MANIFEST entry com `profiles: [APP, HYBRID]` mas comentário "promover após piloto" OU incluir entry e marcar piloto como gate manual pré-merge.

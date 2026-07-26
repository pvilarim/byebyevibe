## Context

Este change fecha 6 achados da revisão adversarial (F-C2-5, F-C2-8, F-OPS-3, F-OPS-4, F-SEC-5, F-SEC-3) que ficaram como FOLLOW-UP após os changes anteriores (`fix-sdd-upgrade-security`, `fix-sdd-pre-archive`). Os achados agrupam-se em dois temas:

**Tema A — Operações de upgrade/install mais seguras:** O `upgrade.sh` não filtra por perfil nem verifica branch; o `install.sh` não avisa sobre CI não-GitHub; o `verify.sh` polui `FAILURES` em CI.

**Tema B — Documentação de riscos de supply chain e MANIFEST:** O campo `gate:` do MANIFEST é morto mas representa risco de eval futuro; o `npx --yes` sem lockfile é uma limitação de supply chain que não está documentada para operadores que adaptem o workflow.

Ficheiros afectados:
- `sdd-kit/upgrade.sh` (F-C2-5, F-C2-8)
- `sdd-kit/verify.sh` (F-OPS-3)
- `sdd-kit/install.sh` (F-OPS-4)
- `sdd-kit/MANIFEST.yaml` (F-SEC-5)
- `.cursor/rules/050-security.mdc` — hub (F-SEC-5, F-SEC-3)
- `sdd-kit/templates/.cursor/rules/050-security.mdc` — template distribuído (F-SEC-5, F-SEC-3)

## Goals / Non-Goals

**Goals:**
- `upgrade.sh` rejeita `--apply` sem `--profile` explícito
- `upgrade.sh --apply` bloqueia com erro se a branch for `main`/`master` (sem `--force`)
- `verify.sh` não conta `sdd-session-status.sh` como FAIL em ambientes CI
- `install.sh` emite WARN ao instalar `.github/workflows/` em ambientes não-GitHub
- `MANIFEST.yaml` documenta que `gate:` é metadata não executável
- `050-security.mdc` (hub + template) documenta o risco de eval futuro e a limitação de supply chain do `npx --yes`

**Non-Goals:**
- Implementar parsing de `gate:` como comando real no `install.sh`/`verify.sh`
- Resolver F-SEC-4 (pin de actions por SHA) — já resolvido em `fix-sdd-upgrade-security`
- Resolver F-OPS-2 (mensagem de skip enganosa) — cambio de mensagem já aplicado em `fix-sdd-pre-archive`
- Modificar `sdd-gates.yml` (hub ou template) — não é necessário para estes achados

## Decisions

### D1 — `--profile` obrigatório em `upgrade.sh`

O `install.sh` já aceita e exige `--profile`. O `upgrade.sh` deve ter paridade: sem `--profile`, o dry-run ainda corre (para compatibilidade de inspecção rápida), mas `--apply` bloqueia com erro explicativo. Alternativa considerada: `--profile` opcional com default `ALL` — rejeitada porque um DOCS_SPECS receber `010-typescript.mdc` silenciosamente é exactamente o bug (F-C2-5).

A implementação reutiliza o mesmo bloco Python do `install.sh` (extrai `profiles` do MANIFEST). Para dry-run sem `--profile`, mostra todos os ficheiros com etiqueta `[all-profiles]` para preservar utilidade de inspecção.

### D2 — Verificação de branch em `--apply`

Usar `git rev-parse --abbrev-ref HEAD` (mais portável que `git branch --show-current` que requer git ≥2.22). Bloquear em `main`/`master` sem `--force`. O operador que sabe o que faz pode passar `--force` para um apply directo em main — o script avisa mas não proíbe. Alternativa: bloquear absolutamente — rejeitada como demasiado restritiva para pipelines CI legítimos que fazem deploy em main.

### D3 — Guarda `CI` em `verify.sh`

`${CI:-}` é a variável de ambiente que GitHub Actions, GitLab CI, CircleCI e outros definem como `true`. O bloco `sdd-session-status.sh` já está num `if [[ -x ... ]]`, portanto adicionar uma guarda exterior `if [[ -z "${CI:-}" ]]` é a menor mudança possível. Em CI, o check é omitido (não contado como FAIL nem como OK).

### D4 — Detecção de CI não-GitHub em `install.sh`

Detectar via variáveis de ambiente conhecidas: `GITLAB_CI`, `GITEA_ACTIONS`, `TF_BUILD` (Azure DevOps), `CIRCLECI`. Se qualquer uma estiver definida e o destino for `.github/workflows/`, emitir WARN para stderr antes do `cp`. O `cp` ainda acontece (o operador pode precisar do ficheiro como referência); o WARN é suficiente para o achado. Alternativa: recusar o copy — rejeitada por ser demasiado disruptiva.

### D5 — Comentário `gate:` no MANIFEST e documentação em `050-security.mdc`

O MANIFEST recebe um comentário de topo (e em cada bloco com `gate:` representativo) explicando que `gate:` é metadata documental. A `050-security.mdc` recebe uma linha na secção CI/CD existente. O template distribuído (`sdd-kit/templates/.cursor/rules/050-security.mdc`) recebe a mesma adição — a secção CI/CD já existe no template (adicionada em `fix-sdd-upgrade-security`).

### D6 — Documentação de supply chain em `050-security.mdc`

F-SEC-3 pede documentação da limitação: `npx --yes @fission-ai/openspec@1.3.1` pina a versão major.minor.patch mas não pina dependências transitivas (que usam `^`). A correcção completa (lockfile commitado + `npm ci`) é fora de escopo deste change (não é o SDD hub que gere o `node_modules` do consumer). A documentação da limitação em `050-security.mdc` é o tratamento correcto para operadores que adaptem o workflow.

## Risks / Trade-offs

- **`--profile` obrigatório em `upgrade.sh --apply` é breaking** para scripts de automação que não passavam o flag. Mitigação: dry-run sem `--profile` continua a funcionar (para inspecção); o erro para `--apply` é explícito e inclui a instrução de remediação.
- **Detecção de CI não-GitHub é heurística** — depende de variáveis de ambiente conhecidas; um CI customizado sem essas variáveis não recebe o WARN. Mitigação: o achado F-OPS-4 pede apenas WARN, não bloqueio; a cobertura parcial é melhor que zero.
- **Comentário no MANIFEST é documental, não técnico** — não impede um agente malicioso de remover o comentário e adicionar eval. Mitigação: o risco real é de uma versão futura do `install.sh`/`upgrade.sh` que implemente eval por engano; o comentário e a regra 050 funcionam como barreira normativa.

## Migration Plan

1. Operadores que usem `upgrade.sh --apply` devem adicionar `--profile <PERFIL>` ao comando.
2. Sem outras migrações necessárias — todas as outras mudanças são aditivas ou corrigem comportamentos que eram silenciosamente errados.

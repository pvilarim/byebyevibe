## Why

A revisão adversarial do change `add-sdd-ci-gates-workflow` (2026-07-25) identificou 8 achados de categoria "follow-up" em documentos normativos. Estes gaps afectam a fidelidade de agentes de IA (comandos errados no AGENTS.md), a completude de specs (requisito D4 sem cobertura formal), e a rastreabilidade de decisões (D12 ausente no design). Sem correcção, um agente que leia `AGENTS.md` recebe um comando `npx openspec validate` sem scope nem versão pinada — diferente do que o CI corre — e operadores que seguem o fluxo C1 passam pela §2.8 sem saber que o gate de CI foi instalado.

## What Changes

- **AGENTS.md** — Command `npx openspec validate --all --strict` → `npx --yes @fission-ai/openspec@1.3.1 validate --all --strict` (alinha ao package real do CI); integração CI Gates corrigida na mesma linha
- **AGENTS.md** — Verificar/confirmar que linhas 50 e 79 já estão em v1.4.0 (F-NORM-3; já corrigido no archive anterior — tarefa de verificação)
- **sdd-kit/templates/AGENTS.core.md** — Mesma correcção de comando npx no template distribuído
- **openspec/changes/add-sdd-ci-gates-workflow/specs/sdd-ci-gates/spec.md** — Adicionar requisito D4: `verify-infra.sh` DEVE correr com `continue-on-error` (report-only, nunca bloqueante)
- **openspec/changes/add-sdd-ci-gates-workflow/design.md** — Adicionar decisão D12: `OPENSPEC_TELEMETRY: "0"` — o que desactiva, para quem, e por que está no workflow
- **doc/sistema-sdd-pedro.md §2.8** — Adicionar item de checklist: `.github/workflows/sdd-gates.yml` presente
- **doc/sistema-sdd-pedro.md** tabela C1 — Adicionar `→ §2.12` na linha Humano C1 após `→ §2.8`
- **.cursor/rules/050-security.mdc** — Adicionar secção `## CI/CD` com regras explícitas para workflows
- **sdd-kit/templates/.cursor/rules/050-security.mdc** — Mesma secção `## CI/CD` no template distribuído
- **openspec/infra.md** — Verificar/confirmar timestamp `2026-07-25` (F-NORM-6; já corrigido — tarefa de verificação)

## Capabilities

### New Capabilities

_(nenhuma — este change é exclusivamente de correcção documental)_

### Modified Capabilities

- `sdd-ci-gates`: Adicionar requisito formal D4 — `sdd-kit/verify.sh` corre com `continue-on-error` (report-only) para não bloquear por CLIs ausentes no runner; sem esta cobertura, uma refactorização futura pode inadvertidamente tornar o passo bloqueante sem violar nenhum requisito escrito

## Impact

- `AGENTS.md` (hub): 2 locais com `npx openspec validate` → comando scopado + versão pinada
- `sdd-kit/templates/AGENTS.core.md`: 1 local com `npx openspec validate` → corrigido (afecta todos os repos consumidores que instalarem o kit)
- `openspec/changes/add-sdd-ci-gates-workflow/specs/sdd-ci-gates/spec.md`: 1 requisito novo (additive, não breaking)
- `openspec/changes/add-sdd-ci-gates-workflow/design.md`: 1 decisão nova (D12), tabela de decisions
- `doc/sistema-sdd-pedro.md`: 2 locais (§2.8 checklist + tabela C1)
- `.cursor/rules/050-security.mdc` + `sdd-kit/templates/.cursor/rules/050-security.mdc`: secção `## CI/CD` nova (additive)
- Sem alteração de comportamento de scripts, workflows ou gates — apenas documentação e spec

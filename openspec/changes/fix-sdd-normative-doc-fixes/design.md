# Design — Correcções normativas pós-revisão adversarial

## Context

A revisão adversarial `explore-adversarial-sdd-review` (2026-07-25) produz um mapa de achados agrupados por criticidade. Os achados "FOLLOW-UP" endereçados aqui são todos de natureza documental — zero alteração de comportamento de scripts ou gates. Os 8 findings do request são:

| Finding | Ficheiro(s) afectado(s) | Estado actual |
|---------|------------------------|---------------|
| F-NORM-3 | `AGENTS.md` L50 + L79 | ✅ Já corrigido (archive anterior) |
| F-NORM-4 | `AGENTS.md` + `sdd-kit/templates/AGENTS.core.md` | ❌ Aberto |
| F-NORM-5 | `openspec/changes/add-sdd-ci-gates-workflow/specs/sdd-ci-gates/spec.md` | ❌ Aberto |
| F-NORM-6 | `openspec/infra.md` | ✅ Já corrigido (timestamp 2026-07-25) |
| F-OPS-5 | `openspec/changes/add-sdd-ci-gates-workflow/design.md` | ❌ Aberto |
| F-C1-5 | `doc/sistema-sdd-pedro.md` §2.8 | ❌ Aberto |
| F-C1-6 | `doc/sistema-sdd-pedro.md` tabela C1 | ❌ Aberto |
| F-SEC-9 | `.cursor/rules/050-security.mdc` + template | ❌ Aberto |

## Goals / Non-Goals

**Goals:**
- Corrigir os 6 achados abertos enumerados acima
- Verificar e documentar que F-NORM-3 e F-NORM-6 já estão fechados
- Manter fidelidade total ao comportamento real (zero alteração de scripts/gates)
- Actualizar template do kit distribuído quando o hub for actualizado

**Non-Goals:**
- Corrigir os achados 🔴 Críticos (âmbito de changes separados)
- Endereçar F-OPS-6 (paridade de versão CI/min_openspec) neste change
- Alterar o workflow `.github/workflows/sdd-gates.yml` além de correcção de versão

## Decisions

| ID | Decisão | Rationale |
|----|---------|-----------|
| D1 | Usar `@fission-ai/openspec@1.3.1` como versão canónica nos docs | É a única versão da série 1.3.x disponível no npm; `1.3.2` referenciado no workflow não existe. O workflow deve ser corrigido para `@1.3.1` (ou para a versão `min_openspec` do MANIFEST). |
| D2 | Corrigir também o workflow de `@1.3.2` → `@1.3.1` | Versão 1.3.2 não existe no registry npm; o workflow falharia ao tentar instalar com cache fria. Correcto é `min_openspec = 1.3.1`. |
| D3 | Req D4 no spec como "MUST" com cenário | D4 é política normativa — uma refactorização futura que torne o step bloqueante violaria o requisito sem sinal explícito. Um cenário com `continue-on-error` garante rastreabilidade. |
| D4 | D12 em `design.md` da CI gates como decisão formal | `OPENSPEC_TELEMETRY: "0"` é segurança/privacidade — merece decisão rastreável, não só comentário inline. O comentário no workflow permanece; D12 é a âncora normativa. |
| D5 | Secção `## CI/CD` em `050-security.mdc` é additive | Não altera nem remove regras existentes — apenas adiciona guardrails que já eram implícitos (menor scope de token, sem `pull_request_target` + secrets, pin SHA). |
| D6 | Actualizar hub + template do kit para cada ficheiro alterado | Qualquer ficheiro em `sdd-kit/templates/.cursor/rules/` distribuído pelo kit deve espelhar a versão hub. |

## Detalhes por finding

### F-NORM-4 — Comando npx sem scope nem versão

**Problema:** `AGENTS.md` linha 24 documenta `npx openspec validate --all --strict` como "mesmo comando do workflow". O workflow corre `npx --yes @fission-ai/openspec@1.3.1 validate --all --strict --no-interactive`. `npx openspec` e `npx @fission-ai/openspec` podem resolver pacotes diferentes.

**Correcção:**
- `AGENTS.md` L24: `\`npx openspec validate --all --strict\`` → `\`npx --yes @fission-ai/openspec@1.3.1 validate --all --strict\``
- `AGENTS.md` secção "CI Gates" (L124): actualizar referência inline
- `sdd-kit/templates/AGENTS.core.md`: na secção `CI Gates (sdd-gates)`, alinhar comando
- `.github/workflows/sdd-gates.yml` L39: `@fission-ai/openspec@1.3.2` → `@fission-ai/openspec@1.3.1`
- `sdd-kit/templates/.github/workflows/sdd-gates.yml` L39: mesmo fix

### F-NORM-5 — Spec sdd-ci-gates sem requisito D4

**Problema:** A decisão D4 (verify-infra.sh report-only, continue-on-error) é normativa mas sem spec. Uma alteração futura que torne o step bloqueante não viola nenhum requisito escrito.

**Correcção:** Adicionar ao spec `openspec/changes/add-sdd-ci-gates-workflow/specs/sdd-ci-gates/spec.md`:

```
### Requirement: verify-infra.sh runs report-only in CI

O passo `sdd-kit/verify.sh` DEVE correr com `continue-on-error: true` porque
`verify-infra.sh` reporta FAIL para CLIs de conhecimento (GitNexus, Graphify) ausentes
no runner efémero. Este step NUNCA deve bloquear merge — é report-only.
```

Com cenário de validação correspondente.

### F-OPS-5 — D12 ausente no design de CI gates

**Problema:** `OPENSPEC_TELEMETRY: "0"` existe no workflow sem decisão D-N associada. Um operador que adapte o workflow para GitLab não sabe se esta linha é crítica.

**Correcção:** Adicionar D12 à tabela Decisions de `design.md`:

```
| D12 | `OPENSPEC_TELEMETRY: "0"` no env do job | @fission-ai/openspec envia dados anónimos via PostHog por defeito. Em CI desactivar elimina exfiltração implícita de metadados do repo (nomes de changes, paths). Operadores que adaptem o workflow DEVEM incluir esta variável. Em local: definir no shell ou `.env` (regra 050). |
```

### F-C1-5 — §2.8 sem item para sdd-gates.yml

**Problema:** Checklist tem 18 itens; nenhum confirma presença do workflow de CI, que é instalado para todos os perfis.

**Correcção:** Adicionar ao final da checklist §2.8:
```
- [ ] `.github/workflows/sdd-gates.yml` presente (ver §2.12 para configurar branch protection manual)
```

### F-C1-6 — Tabela C1 não aponta para §2.12

**Problema:** A linha "Humano — instalação nova (C1)" termina em `→ §2.8`; um utilizador que a segue nunca lê §2.12 (branch protection), deixando o gate inoperante.

**Correcção:** Actualizar linha C1:
```
§2.1 → CLIs → `bash sdd-kit/install.sh --profile X` → §2.8 → §2.12
```

### F-SEC-9 — 050-security.mdc sem secção CI/CD

**Problema:** O workflow referencia a regra 050 (`D11 — menor escopo de token (regra 050)`) mas a regra não define o que isso significa para CI, nem proíbe padrões perigosos como `pull_request_target` com secrets.

**Correcção:** Adicionar secção `## CI/CD` com regras explícitas:
- NUNCA usar `pull_request_target` com secrets (RCE de PRs externos)
- SEMPRE pinar actions por commit SHA imutável (não tag mutável)
- SEMPRE incluir `OPENSPEC_TELEMETRY=0` ao usar `@fission-ai/openspec` em CI
- Adicionar `permissions: contents: read` por defeito; justificar escopos mais amplos

## Risks / Trade-offs

| Risco | Mitigação |
|-------|-----------|
| Corrigir versão no workflow quebra CI se `@1.3.1` for removido do registry | `@1.3.1` já existe e foi publicado; versões publicadas não são removidas por convenção npm |
| Editar `design.md` de change arquivado não actualiza o CI | CI valida changes activos via `openspec validate --all --strict`; changes arquivados não são validados |
| Adicionar req D4 ao spec pode fazer o `openspec validate` falhar | O spec é um delta spec no change arquivado; não afecta validação de changes activos |

## Migration Plan

Todas as alterações são aditivas ou correcções de conteúdo — sem scripts de migração. O `sdd-kit/install.sh` continua inalterado. Repos consumidores que já instalaram o kit não são afectados (os ficheiros alterados são documentação e spec do hub). A excepção é `sdd-kit/templates/.cursor/rules/050-security.mdc` e `sdd-kit/templates/AGENTS.core.md` — que afectam instalações **futuras** (C1 novo).

## Open Questions

_(nenhuma — todos os achados têm solução clara)_

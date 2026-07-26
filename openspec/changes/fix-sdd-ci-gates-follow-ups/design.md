## Context

Seis findings de follow-up da revisão adversarial de `add-sdd-ci-gates-workflow` (PR #23) ficaram em aberto após `fix-sdd-pre-archive` e `fix-sdd-upgrade-security`. Todos afectam os mesmos dois ficheiros distributáveis (`sdd-gates.yml` × 2) ou a regra de coordenação local que tem `alwaysApply: true` num ambiente CI onde os scripts de sessão não existem.

Estado actual dos ficheiros alvo:
- `.github/workflows/sdd-gates.yml` + template: existem no branch `cursor/fix-sdd-upgrade-security-2b0e` (PR #26, ainda não merged em master)
- `.cursor/rules/016-session-coordination.mdc` + template: em master
- `sdd-kit/MANIFEST.yaml`: em master, versão `1.3.2`

## Goals / Non-Goals

**Goals:**
- (F-SEC-4) Pinar as três GitHub Actions a commits SHA imutáveis com comentário de versão
- (F-SEC-8) Adicionar `timeout-minutes` no job (10 min) e nos steps críticos (3 min cada)
- (F-OPS-2) Corrigir mensagem de skip de `verify-task-patterns.sh` para não assumir perfil APP
- (F-OPS-6) Pinar openspec CLI à versão do kit (`@1.3.2`) em vez de `@1.3.1` desalinhado
- (F-OPS-1) Adicionar excepção explícita CI à regra 016 (hub e template)
- (F-C1-3) Adicionar `scripts/bootstrap-sdd.sh` ao MANIFEST com `merge: COPY`, todos os perfis

**Non-Goals:**
- F-SEC-3 (lockfile npm para npx) — requer mudança maior de processo, follow-up separado
- F-C1-5 e F-C1-6 (guia §2.8 / §2.12 checklist) — docs do guia, follow-up separado
- F-OPS-3, F-OPS-4 — scope mais alargado, follow-up separado

## Decisions

**D1 — SHAs das GitHub Actions (F-SEC-4):**
Usar as versões mais recentes confirmadas a 2026-07-14 via gh CLI:
```yaml
- uses: actions/checkout@9c091bb21b7c1c1d1991bb908d89e4e9dddfe3e0 # v7.0.0
- uses: actions/setup-node@249970729cb0ef3589644e2896645e5dc5ba9c38 # v6.5.0
- uses: actions/setup-python@ece7cb06caefa5fff74198d8649806c4678c61a1 # v6.3.0
```
Bump simultâneo de versão major é necessário porque v4/v5 correm em Node20 que o GitHub depreca em Q4 2026. O bump não altera comportamento do workflow para os steps de openspec/verify.

**D2 — timeout-minutes (F-SEC-8):**
`timeout-minutes: 10` no job; `timeout-minutes: 3` em `OpenSpec validate` e `Task patterns` (os dois steps bloqueantes). O `sdd-kit verify` tem `continue-on-error: true` — não precisa de timeout de step individual, mas o timeout de job cobre.

**D3 — Mensagem de skip (F-OPS-2):**
Substituir `"SKIP: scripts/verify-task-patterns.sh not present (APP profile)"` por `"SKIP: scripts/verify-task-patterns.sh not found — install via sdd-kit if profile is DOCS_SPECS/HYBRID"`. Não assumir perfil.

**D4 — Versão openspec CLI (F-OPS-6):**
Mudar `@fission-ai/openspec@1.3.1` para `@fission-ai/openspec@1.3.2` (= `version` em `sdd-kit/MANIFEST.yaml`). O spec `sdd-ci-gates` exige "pelo menos `min_openspec`" — mas pinar à versão exacta do kit é mais preciso e evita divergência local/CI.

**D5 — Excepção CI em rule 016 (F-OPS-1):**
Adicionar ao final da rule, após as regras existentes:
```
- **Excepção CI:** runners efêmeros (GitHub Actions, etc.) estão isentos de R11 — `.sdd/runtime/` é gitignored e não persiste; `sdd-session-register/check` aplica-se apenas a máquinas locais com estado persistente.
```
Idem no template distribuível.

**D6 — bootstrap-sdd.sh no MANIFEST (F-C1-3):**
Adicionar entrada logo após a secção de scripts existentes:
```yaml
  - path: scripts/bootstrap-sdd.sh
    source: templates/scripts/bootstrap-sdd.sh
    merge: COPY
    profiles: [APP, DOCS_SPECS, HYBRID]
    gate: "test -x scripts/bootstrap-sdd.sh"
```
O template já existe. O `install.sh` vai copiar o script para `scripts/bootstrap-sdd.sh` no repo alvo — depois da primeira instalação o utilizador usa `bash scripts/bootstrap-sdd.sh` directamente. Antes de instalar, usa `bash sdd-kit/templates/scripts/bootstrap-sdd.sh` (sem mudança de documentação necessária neste change — out of scope F-C1-5/F-C1-6).

## Risks / Trade-offs

- **Bump de major das actions:** checkout v7 e setup-node v6 são compatíveis com Node22 e com ubuntu-latest. O risco de regressão é baixo; o runner GitHub Actions já corre Node24 por defeito desde 2026-06-16.
- **SHA hardcoded nos dois workflows:** se os repos fizerem fork e tiverem Dependabot configurado, o Dependabot actualiza os SHAs automaticamente (lê o comentário `# vX.Y.Z`). Sem Dependabot, os SHAs ficam stale — aceitável para uma ferramenta interna de baixa frequência de actualização.
- **bootstrap-sdd.sh no MANIFEST:** um `--apply` de upgrade vai sobrescrever o `scripts/bootstrap-sdd.sh` com o template. Com o backup automático de `fix-sdd-upgrade-security` (PR #26), qualquer customização local gera `.bak.TIMESTAMP` — sem perda de dados.

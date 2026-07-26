## Why

A revisão adversarial de `add-sdd-ci-gates-workflow` (PR #23) identificou 6 findings de follow-up que não foram incluídos nos changes anteriores (`fix-sdd-pre-archive`, `fix-sdd-upgrade-security`): dois afectam segurança operacional do workflow (actions mutáveis, sem timeout), dois afectam comportamento incorreto do workflow (skip message enganosa, versão de CLI desalinhada), um afecta conformidade da regra 016 em ambientes CI, e um afecta a integridade do instalador greenfield (entry point `bootstrap-sdd.sh` ausente do MANIFEST). Todos são funcionalmente incorretos ou criam falsa segurança sem acção correctiva.

## What Changes

- **`.github/workflows/sdd-gates.yml`** e **`sdd-kit/templates/.github/workflows/sdd-gates.yml`** — (F-OPS-2) corrigir mensagem de skip de `verify-task-patterns.sh` para não assumir perfil APP; (F-OPS-6) pinar openspec CLI à versão do kit (`1.3.2`) em vez de `1.3.1`; (F-SEC-4) pinar as três GitHub Actions por commit SHA imutável em vez de tag mutável; (F-SEC-8) adicionar `timeout-minutes: 10` no job e `timeout-minutes: 3` nos steps críticos
- **`.cursor/rules/016-session-coordination.mdc`** e **`sdd-kit/templates/.cursor/rules/016-session-coordination.mdc`** — (F-OPS-1) adicionar excepção explícita para runners CI efêmeros onde `sdd-session-register/check` não se aplica
- **`sdd-kit/MANIFEST.yaml`** — (F-C1-3) adicionar entrada para `scripts/bootstrap-sdd.sh` com `merge: COPY` e `profiles: [APP, DOCS_SPECS, HYBRID]`; o template já existe em `sdd-kit/templates/scripts/bootstrap-sdd.sh`
- **`doc/sistema-sdd-pedro.md`** — (F-C1-3) corrigir §2.0 prompt IA e README para apontar `bash sdd-kit/templates/scripts/bootstrap-sdd.sh` até após C1 instalar o script no repo alvo

## Capabilities

### New Capabilities

*(nenhuma — este change não introduz comportamento novo)*

### Modified Capabilities

- `sdd-ci-gates`: delta spec para requisitos de pinagem por SHA, timeout, mensagem de skip correcta, e alinhamento de versão CLI
- `sdd-install-kit`: delta spec para `bootstrap-sdd.sh` como entry point obrigatório do MANIFEST

## Impact

Ficheiros afectados: `.github/workflows/sdd-gates.yml`, `sdd-kit/templates/.github/workflows/sdd-gates.yml`, `.cursor/rules/016-session-coordination.mdc`, `sdd-kit/templates/.cursor/rules/016-session-coordination.mdc`, `sdd-kit/MANIFEST.yaml`, `doc/sistema-sdd-pedro.md`. Todos Tipo A/B — sem novo comportamento. A pinagem por SHA é o único ponto que pode causar quebra futura se as actions upstream moverem o SHA; o comentário `# vX.Y.Z` junto ao SHA documenta a versão correspondente.

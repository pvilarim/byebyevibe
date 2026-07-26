## ADDED Requirements

### Requirement: verify-infra.sh runs report-only in CI

O passo que executa `sdd-kit/verify.sh` no workflow de CI MUST ser configurado com `continue-on-error: true`. O `sdd-kit/verify.sh` invoca internamente `scripts/verify-infra.sh`, que reporta FAIL para CLIs de conhecimento (GitNexus, Graphify) ausentes no runner efémero; tornar este step bloqueante produziria falso-negativo que impediria merge legítimo. A política fail-closed MUST aplicar-se exclusivamente aos steps de `openspec validate` e `verify-task-patterns.sh` — o step `sdd-kit verify` MUST NOT bloquear merge.

#### Scenario: Runner sem GitNexus/Graphify instalados

- **WHEN** o step `sdd-kit verify (report-only)` corre num runner onde GitNexus e Graphify não estão instalados
- **THEN** o step reporta WARN/FAIL internamente mas o workflow continua e o resultado global do job não é afectado por este step isoladamente

#### Scenario: openspec validate falha no mesmo run

- **WHEN** `openspec validate --all --strict` falha com saída não-zero
- **THEN** o workflow termina com falha (fail-closed) independentemente do resultado do step report-only

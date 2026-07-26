# Tasks — add-sdd-metrics-cadence-nudge

> Escopo apply após aprovação humana (R7). **Pré-requisito:** `add-sdd-metrics-script` aplicado no hub (`scripts/sdd-metrics.sh` + §2.17 base). Piloto dispensável (bash local; sem binário/hook/LLM novo). **Non-goals:** rule always-on; CI cron; DevLake. **Issue:** —

## 0. Pré-requisito

- [x] 0.1 Confirmar que G4 base está no hub (script executável + secção §2.17)
  - **Pattern:** `openspec/changes/add-sdd-metrics-script/proposal.md`
  - **Invariants:** dependência de `add-sdd-metrics-script`
  - **Gate:** `test -x scripts/sdd-metrics.sh && grep -q '2.17' doc/sistema-sdd-pedro.md && grep -q 'sdd-metrics' doc/sistema-sdd-pedro.md`

## 1. Playbook de interpretação (§2.17)

- [x] 1.1 Acrescentar em `doc/sistema-sdd-pedro.md` §2.17 a secção “Interpretar → actuar”: tabela M1–M4 → acções de processo; ritual 1 insight → 1 ajuste; nota DevLake continua fora
  - **Pattern:** `doc/sistema-sdd-pedro.md`
  - **Invariants:** `sdd-metrics` — Interpretation playbook maps metrics to process actions
  - **Gate:** `grep -q 'Interpretar' doc/sistema-sdd-pedro.md && grep -qE 'M1|M2|M3' doc/sistema-sdd-pedro.md && grep -q 'insight' doc/sistema-sdd-pedro.md`

- [x] 1.2 Documentar limiares de cadência (N=5 archives, T=30 dias) e o fluxo do nudge no archive na mesma §2.17
  - **Pattern:** `doc/sistema-sdd-pedro.md`
  - **Gate:** `grep -qE '5|30' doc/sistema-sdd-pedro.md && grep -q 'check-cadence\|cadência\|nudge' doc/sistema-sdd-pedro.md`

## 2. Stamp + --check-cadence no script

- [x] 2.1 Garantir `.sdd/metrics-last-run` gitignored (entrada em `.gitignore`)
  - **Pattern:** `.gitignore`
  - **Invariants:** `sdd-metrics` — Last-run stamp enables cadence checks
  - **Gate:** `grep -qE 'metrics-last-run|\.sdd/' .gitignore`

- [x] 2.2 Estender `scripts/sdd-metrics.sh`: gravar stamp ISO `YYYY-MM-DD` em `.sdd/metrics-last-run` após relatório exit 0; adicionar `--check-cadence` (defaults N=5, T=30; onboarding sem stamp per design D2/Open Questions); espelhar template kit
  - **Pattern:** `scripts/sdd-session-status.sh`
  - **Invariants:** `sdd-metrics` — Cadence check is advisory and opt-in; Last-run stamp enables cadence checks
  - **Gate:** `grep -q 'check-cadence' scripts/sdd-metrics.sh && grep -q 'metrics-last-run' scripts/sdd-metrics.sh && diff -q scripts/sdd-metrics.sh sdd-kit/templates/scripts/sdd-metrics.sh`

- [x] 2.3 Regenerar checksums do MANIFEST se o template mudou; bump patch do kit se G4 já publicou 1.6.0 (senão alinhar com versão actual)
  - **Pattern:** `sdd-kit/MANIFEST.yaml`
  - **Gate:** `bash sdd-kit/gen-manifest-checksums.sh && grep -A6 'sdd-metrics.sh' sdd-kit/MANIFEST.yaml | grep -q 'sha256:'`

- [x] 2.4 Validar comportamento do cadence check (exit codes)
  - **Pattern:** `scripts/sdd-session-status.sh`
  - **Gate:** `bash scripts/sdd-metrics.sh --help | grep -q 'check-cadence' && (bash scripts/sdd-metrics.sh --check-cadence; ec=$?; test "$ec" -eq 0 -o "$ec" -eq 1)`

## 3. Nudge no Session Handoff (archive)

- [x] 3.1 Actualizar `.claude/skills/openspec-archive-change/SKILL.md`: no Session Handoff pós-archive, correr `--check-cadence` se o script existir; se nudge due, incluir ≤5 linhas advisory (comando + §2.17); nunca auto-executar relatório; nunca falhar archive se script ausente
  - **Pattern:** `.claude/skills/openspec-archive-change/SKILL.md`
  - **Invariants:** `sdd-session-handoff` — Archive Session Handoff includes metrics cadence nudge when due
  - **Gate:** `grep -q 'check-cadence\|sdd-metrics' .claude/skills/openspec-archive-change/SKILL.md && grep -q '2.17' .claude/skills/openspec-archive-change/SKILL.md`

- [x] 3.2 Espelhar em `.cursor/skills/openspec-archive-change/SKILL.md`
  - **Pattern:** `.cursor/skills/openspec-archive-change/SKILL.md`
  - **Gate:** `grep -q 'check-cadence\|sdd-metrics' .cursor/skills/openspec-archive-change/SKILL.md`

## 4. Descoberta leve (R3 N/A)

- [x] 4.1 Acrescentar ≤3 linhas em `AGENTS.md` (Integrações / métricas): cadência archive + playbook §2.17; **sem** skill/rule nova
  - **Pattern:** `AGENTS.md`
  - **Invariants:** `sdd-metrics` — Mode C preserved — no always-on metrics skill
  - **Gate:** `grep -q 'sdd-metrics' AGENTS.md && grep -q '2.17' AGENTS.md && ! test -f .cursor/rules/0*metrics*.mdc`

- [x] 4.2 Espelhar em `sdd-kit/templates/AGENTS.core.md` se a secção Metrics existir / for criada pelo G4
  - **Pattern:** `sdd-kit/templates/AGENTS.core.md`
  - **Gate:** `grep -q 'sdd-metrics' sdd-kit/templates/AGENTS.core.md || grep -q '2.17' sdd-kit/templates/AGENTS.core.md`

## 5. Specs — promoção

- [x] 5.1 Aplicar deltas `sdd-metrics` e `sdd-session-handoff` em `openspec/specs/` (merge ADDED); se `openspec/specs/sdd-metrics/spec.md` ainda não existir, garantir que G4 foi promovido primeiro (task 0.1)
  - **Pattern:** `openspec/specs/sdd-session-handoff/spec.md`
  - **Gate:** `grep -q 'check-cadence\|cadence\|playbook\|Interpretation' openspec/specs/sdd-metrics/spec.md && grep -q 'metrics cadence\|sdd-metrics' openspec/specs/sdd-session-handoff/spec.md`

## 6. Validação

- [x] 6.1 Correr `bash scripts/verify-task-patterns.sh`
  - **Pattern:** `scripts/verify-task-patterns.sh`
  - **Gate:** `bash scripts/verify-task-patterns.sh`

- [x] 6.2 Validar change com openspec CLI
  - **Pattern:** `openspec/changes/add-sdd-metrics-cadence-nudge/proposal.md`
  - **Gate:** `OPENSPEC_TELEMETRY=0 npx --yes @fission-ai/openspec@1.3.1 validate add-sdd-metrics-cadence-nudge --strict`

## 7. Pós-registro (best-effort)

- [x] 7.1 `graphify update .` + `npx gitnexus analyze --force` se disponíveis
  - **Pattern:** `.cursor/rules/graphify.mdc`
  - **Gate:** `test -f graphify-out/GRAPH_REPORT.md || echo 'SKIP (graphify ❌ em infra.md)'`

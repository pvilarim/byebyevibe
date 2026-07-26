# Tasks — fix-sdd-ci-gates-follow-ups

> 6 findings de follow-up da revisão adversarial de `add-sdd-ci-gates-workflow` (PR #23).
> Research: `openspec/changes/explore-adversarial-sdd-review/research.md`
> Design: `openspec/changes/fix-sdd-ci-gates-follow-ups/design.md`
>
> **Dependência de apply:** os ficheiros de workflow só existem em master após merge do PR #26
> (`cursor/fix-sdd-upgrade-security-2b0e`). Se o PR #26 ainda não foi merged, extrair com:
> ```
> git show origin/cursor/fix-sdd-upgrade-security-2b0e:.github/workflows/sdd-gates.yml
> git show origin/cursor/fix-sdd-upgrade-security-2b0e:sdd-kit/templates/.github/workflows/sdd-gates.yml
> ```

## 1. F-SEC-4 — Pinar GitHub Actions por commit SHA

- [ ] 1.1 Extrair o workflow hub de `origin/cursor/fix-sdd-upgrade-security-2b0e:.github/workflows/sdd-gates.yml` (ou do estado corrente após merge do PR #26) e substituir as três referências de actions por SHA:
  ```yaml
  - uses: actions/checkout@9c091bb21b7c1c1d1991bb908d89e4e9dddfe3e0 # v7.0.0
  - uses: actions/setup-node@249970729cb0ef3589644e2896645e5dc5ba9c38 # v6.5.0
  - uses: actions/setup-python@ece7cb06caefa5fff74198d8649806c4678c61a1 # v6.3.0
  ```
  - **Pattern:** `.github/workflows/sdd-gates.yml`
  - **Gate:** `grep -q '9c091bb21b7c1c1d1991bb908d89e4e9dddfe3e0' .github/workflows/sdd-gates.yml`

- [ ] 1.2 Aplicar a mesma substituição em `sdd-kit/templates/.github/workflows/sdd-gates.yml`
  - **Pattern:** `sdd-kit/templates/.github/workflows/sdd-gates.yml`
  - **Gate:** `grep -q '9c091bb21b7c1c1d1991bb908d89e4e9dddfe3e0' sdd-kit/templates/.github/workflows/sdd-gates.yml`

## 2. F-SEC-8 — Adicionar timeout-minutes

- [ ] 2.1 No job `sdd-gates`, após `runs-on: ubuntu-latest`, adicionar `timeout-minutes: 10`. Nos steps `OpenSpec validate` e `Task patterns`, adicionar `timeout-minutes: 3` (hub):
  ```yaml
  sdd-gates:
    runs-on: ubuntu-latest
    timeout-minutes: 10
  ```
  e em cada step bloqueante:
  ```yaml
  - name: OpenSpec validate (blocking)
    timeout-minutes: 3
    run: ...
  - name: Task patterns (blocking)
    timeout-minutes: 3
    run: ...
  ```
  - **Pattern:** `.github/workflows/sdd-gates.yml`
  - **Gate:** `grep -q 'timeout-minutes: 10' .github/workflows/sdd-gates.yml`

- [ ] 2.2 Aplicar a mesma adição em `sdd-kit/templates/.github/workflows/sdd-gates.yml`
  - **Pattern:** `sdd-kit/templates/.github/workflows/sdd-gates.yml`
  - **Gate:** `grep -q 'timeout-minutes: 10' sdd-kit/templates/.github/workflows/sdd-gates.yml`

## 3. F-OPS-2 — Corrigir mensagem de skip

- [ ] 3.1 No step `Task patterns` do hub, substituir a mensagem:
  ```bash
  echo "SKIP: scripts/verify-task-patterns.sh not found — install via sdd-kit if profile is DOCS_SPECS/HYBRID"
  ```
  (remover `not present (APP profile)`)
  - **Pattern:** `.github/workflows/sdd-gates.yml`
  - **Gate:** `grep -q 'DOCS_SPECS/HYBRID' .github/workflows/sdd-gates.yml`

- [ ] 3.2 Aplicar a mesma correcção em `sdd-kit/templates/.github/workflows/sdd-gates.yml`
  - **Pattern:** `sdd-kit/templates/.github/workflows/sdd-gates.yml`
  - **Gate:** `grep -q 'DOCS_SPECS/HYBRID' sdd-kit/templates/.github/workflows/sdd-gates.yml`

## 4. F-OPS-6 — Pinar openspec CLI à versão do kit

- [ ] 4.1 No hub, substituir `@fission-ai/openspec@1.3.1` por `@fission-ai/openspec@1.3.2` no step de validate:
  - **Pattern:** `.github/workflows/sdd-gates.yml`
  - **Gate:** `grep -q '@fission-ai/openspec@1.3.2' .github/workflows/sdd-gates.yml`

- [ ] 4.2 Aplicar a mesma substituição em `sdd-kit/templates/.github/workflows/sdd-gates.yml`
  - **Pattern:** `sdd-kit/templates/.github/workflows/sdd-gates.yml`
  - **Gate:** `grep -q '@fission-ai/openspec@1.3.2' sdd-kit/templates/.github/workflows/sdd-gates.yml`

## 5. F-OPS-1 — Excepção CI em rule 016

- [ ] 5.1 Em `.cursor/rules/016-session-coordination.mdc` (hub), adicionar ao final:
  ```
  - **Excepção CI:** runners efêmeros (GitHub Actions, etc.) estão isentos de R11 — `.sdd/runtime/` é gitignored e não persiste; `sdd-session-register/check` aplica-se apenas a máquinas locais com estado persistente.
  ```
  - **Pattern:** `.cursor/rules/016-session-coordination.mdc`
  - **Gate:** `grep -q 'Excepção CI' .cursor/rules/016-session-coordination.mdc`

- [ ] 5.2 Aplicar a mesma adição em `sdd-kit/templates/.cursor/rules/016-session-coordination.mdc`
  - **Pattern:** `sdd-kit/templates/.cursor/rules/016-session-coordination.mdc`
  - **Gate:** `grep -q 'Excepção CI' sdd-kit/templates/.cursor/rules/016-session-coordination.mdc`

## 6. F-C1-3 — Adicionar bootstrap-sdd.sh ao MANIFEST

- [ ] 6.1 Em `sdd-kit/MANIFEST.yaml`, após a entrada `sdd-upgrade-diff.sh` (linha ~59), adicionar:
  ```yaml
    - path: scripts/bootstrap-sdd.sh
      source: templates/scripts/bootstrap-sdd.sh
      merge: COPY
      profiles: [APP, DOCS_SPECS, HYBRID]
      gate: "test -x scripts/bootstrap-sdd.sh"
  ```
  - **Pattern:** `sdd-kit/MANIFEST.yaml`
  - **Gate:** `grep -q 'bootstrap-sdd.sh' sdd-kit/MANIFEST.yaml`

- [ ] 6.2 Verificar que `sdd-kit/install.sh --dry-run` lista `scripts/bootstrap-sdd.sh` nas operações planeadas:
  ```bash
  bash sdd-kit/install.sh --profile APP --dry-run 2>&1 | grep -q 'bootstrap-sdd'
  ```
  - **Pattern:** `sdd-kit/MANIFEST.yaml`
  - **Gate:** `bash sdd-kit/install.sh --profile APP --dry-run 2>&1 | grep -q 'bootstrap-sdd'`

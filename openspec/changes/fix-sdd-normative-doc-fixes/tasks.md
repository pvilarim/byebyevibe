## 1. Verificações (F-NORM-3 e F-NORM-6 — já corrigidos)

- [ ] 1.1 Confirmar `AGENTS.md` L50 contém `(v1.4.0)` e L79 contém `(v1.4.0)`
  - **Gate:** `grep -q 'v1\.4\.0' AGENTS.md && echo ok`
  - **Pattern:** `AGENTS.md`

- [ ] 1.2 Confirmar `openspec/infra.md` timestamp é `2026-07-25` (não stale)
  - **Gate:** `grep -q '2026-07-25' openspec/infra.md && echo ok`
  - **Pattern:** `openspec/infra.md`

## 2. F-NORM-4 — Alinhar comando npx no AGENTS.md (hub)

- [ ] 2.1 Actualizar tabela Commands em `AGENTS.md`: substituir `` `npx openspec validate --all --strict` `` por `` `npx --yes @fission-ai/openspec@1.3.1 validate --all --strict` ``
  - **Gate:** `grep -q '@fission-ai/openspec@1\.3\.1' AGENTS.md && echo ok`
  - **Pattern:** `AGENTS.md`

- [ ] 2.2 Actualizar secção "CI Gates" em `AGENTS.md`: substituir referência `` `npx openspec validate --all --strict` `` na frase "Antes de push" pelo comando scopado
  - **Gate:** `grep -c '@fission-ai/openspec@1\.3\.1' AGENTS.md | grep -qE '^[2-9]' && echo ok`
  - **Pattern:** `AGENTS.md`

## 3. F-NORM-4 — Alinhar comando npx no template AGENTS.core.md

- [ ] 3.1 Localizar secção "CI Gates (sdd-gates)" em `sdd-kit/templates/AGENTS.core.md` e adicionar linha de comando `npx --yes @fission-ai/openspec@1.3.1 validate --all --strict` (ou secção CI Gates se ainda não existir)
  - **Gate:** `grep -q '@fission-ai/openspec@1\.3\.1' sdd-kit/templates/AGENTS.core.md && echo ok`
  - **Pattern:** `sdd-kit/templates/AGENTS.core.md`

## 4. F-NORM-4 — Corrigir versão no workflow (1.3.2 → 1.3.1)

- [ ] 4.1 Em `.github/workflows/sdd-gates.yml`: substituir `@fission-ai/openspec@1.3.2` por `@fission-ai/openspec@1.3.1`
  - **Gate:** `grep -q '@fission-ai/openspec@1\.3\.1' .github/workflows/sdd-gates.yml && ! grep -q '@fission-ai/openspec@1\.3\.2' .github/workflows/sdd-gates.yml && echo ok`
  - **Pattern:** `.github/workflows/sdd-gates.yml`

- [ ] 4.2 Em `sdd-kit/templates/.github/workflows/sdd-gates.yml`: mesma substituição
  - **Gate:** `grep -q '@fission-ai/openspec@1\.3\.1' sdd-kit/templates/.github/workflows/sdd-gates.yml && ! grep -q '@fission-ai/openspec@1\.3\.2' sdd-kit/templates/.github/workflows/sdd-gates.yml && echo ok`
  - **Pattern:** `sdd-kit/templates/.github/workflows/sdd-gates.yml`

## 5. F-NORM-5 — Adicionar requisito D4 ao spec sdd-ci-gates

- [ ] 5.1 Adicionar requisito "verify-infra.sh runs report-only in CI" ao spec `openspec/changes/add-sdd-ci-gates-workflow/specs/sdd-ci-gates/spec.md` (conforme draft em `specs/sdd-ci-gates/spec.md` deste change)
  - **Gate:** `grep -q 'continue-on-error' openspec/changes/add-sdd-ci-gates-workflow/specs/sdd-ci-gates/spec.md && echo ok`
  - **Pattern:** `openspec/changes/add-sdd-ci-gates-workflow/specs/sdd-ci-gates/spec.md`

## 6. F-OPS-5 — Adicionar D12 ao design de CI gates

- [ ] 6.1 Adicionar linha D12 à tabela Decisions em `openspec/changes/add-sdd-ci-gates-workflow/design.md`: `OPENSPEC_TELEMETRY: "0"` — desactiva telemetria PostHog em CI; operadores que adaptem o workflow devem incluir esta variável
  - **Gate:** `grep -q 'D12' openspec/changes/add-sdd-ci-gates-workflow/design.md && echo ok`
  - **Pattern:** `openspec/changes/add-sdd-ci-gates-workflow/design.md`

## 7. F-C1-5 — Adicionar item sdd-gates.yml ao checklist §2.8

- [ ] 7.1 Adicionar ao final da checklist §2.8 em `doc/sistema-sdd-pedro.md` o item: `` - [ ] `.github/workflows/sdd-gates.yml` presente (ver §2.12 para configurar branch protection manual) ``
  - **Gate:** `grep -q 'sdd-gates.yml' doc/sistema-sdd-pedro.md && echo ok`
  - **Pattern:** `doc/sistema-sdd-pedro.md`

## 8. F-C1-6 — Actualizar tabela C1 para incluir §2.12

- [ ] 8.1 Actualizar linha "Humano — instalação nova (C1)" da tabela "Como usar este documento" em `doc/sistema-sdd-pedro.md`: substituir `→ §2.8` no final por `→ §2.8 → §2.12`
  - **Gate:** `grep -q '§2\.8 → §2\.12' doc/sistema-sdd-pedro.md && echo ok`
  - **Pattern:** `doc/sistema-sdd-pedro.md`

## 9. F-SEC-9 — Adicionar secção ## CI/CD ao 050-security.mdc (hub)

- [ ] 9.1 Adicionar secção `## CI/CD` ao `.cursor/rules/050-security.mdc` com regras: sem `pull_request_target` com secrets, pinar actions por SHA, incluir `OPENSPEC_TELEMETRY=0`, `permissions: contents: read` por defeito
  - **Gate:** `grep -q '## CI/CD' .cursor/rules/050-security.mdc && echo ok`
  - **Pattern:** `.cursor/rules/050-security.mdc`

- [ ] 9.2 Espelhar mesma secção `## CI/CD` em `sdd-kit/templates/.cursor/rules/050-security.mdc`
  - **Gate:** `grep -q '## CI/CD' sdd-kit/templates/.cursor/rules/050-security.mdc && echo ok`
  - **Pattern:** `sdd-kit/templates/.cursor/rules/050-security.mdc`

## 10. Validação final

- [ ] 10.1 Correr `npx --yes @fission-ai/openspec@1.3.1 validate fix-sdd-normative-doc-fixes` sem erros
  - **Gate:** `OPENSPEC_TELEMETRY=0 npx --yes @fission-ai/openspec@1.3.1 validate fix-sdd-normative-doc-fixes --no-interactive; echo $?`

- [ ] 10.2 Correr `bash scripts/verify-task-patterns.sh` sem erros (valida Pattern: deste tasks.md)
  - **Gate:** `bash scripts/verify-task-patterns.sh && echo ok`

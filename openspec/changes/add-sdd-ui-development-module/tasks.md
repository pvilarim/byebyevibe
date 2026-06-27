# Tasks — add-sdd-ui-development-module

## 1. Avaliação e documentação base

- [ ] 1.1 Criar `doc/avaliacoes/2026-06-27-sdd-ui-development-module.md` (avaliação agregada Impeccable + OD + Pencil)
  - **Pattern:** `doc/avaliacoes/TEMPLATE.md`
  - **Invariants:** `sdd-ui-module` spec — Requirement: Evaluation before kit adoption
  - **Gate:** `test -f doc/avaliacoes/2026-06-27-sdd-ui-development-module.md && grep -qi 'Adopted\|Adiado' doc/avaliacoes/2026-06-27-sdd-ui-development-module.md`

- [ ] 1.2 Actualizar índice `doc/avaliacoes/README.md` com entrada do módulo UI
  - **Pattern:** `doc/avaliacoes/README.md` (tabela índice Headroom)
  - **Gate:** `grep -q 'sdd-ui-development-module' doc/avaliacoes/README.md`

- [ ] 1.3 Adicionar nota no topo de `doc/design/000-*` e `doc/design/001-*`: shadcn = caminho default; ver `003`
  - **Pattern:** `doc/design/001-pipeline-open-design-shadcn-impeccable.md` (banner importação existente)
  - **Gate:** `grep -q 'caminho default' doc/design/000-impeccable-design-system-guia.md && grep -q 'caminho default' doc/design/001-pipeline-open-design-shadcn-impeccable.md`

## 2. Documentos de procedimento (002 e 003)

- [ ] 2.1 Criar `doc/design/002-ui-module-install.md` — C1-UI, árvore shadcn, checklist, conflito skills, mitigações M1–M7
  - **Pattern:** `openspec/changes/add-sdd-ui-development-module/research.md`
  - **Invariants:** `sdd-ui-module` — shadcn recommended + opt-out; compatibilidade SDD
  - **Gate:** `test -f doc/design/002-ui-module-install.md && grep -q 'opt-out\|opt.out' doc/design/002-ui-module-install.md && grep -q 'install-ui-module' doc/design/002-ui-module-install.md && grep -q 'DESIGN.md' doc/design/002-ui-module-install.md`

- [ ] 2.2 Criar `doc/design/003-ui-stack-adapters.md` — Caminho B (tailwind-custom) e C (other)
  - **Pattern:** `doc/design/001-pipeline-open-design-shadcn-impeccable.md` §4
  - **Gate:** `test -f doc/design/003-ui-stack-adapters.md && grep -q 'tailwind-custom' doc/design/003-ui-stack-adapters.md && grep -q 'UI_STACK' doc/design/003-ui-stack-adapters.md`

## 3. Script install-ui-module.sh

- [ ] 3.1 Implementar `sdd-kit/install-ui-module.sh` com `--detect`, `--dry-run`, `--apply`, `--yes`
  - **Pattern:** `sdd-kit/install.sh`
  - **Invariants:** `sdd-ui-module` — detect SKIP sem frontend; M3 gate Node 24+
  - **Gate:** `bash sdd-kit/install-ui-module.sh --help >/dev/null 2>&1 || bash sdd-kit/install-ui-module.sh --detect 2>&1 | grep -qi 'SKIP\|shadcn\|tailwind\|frontend'`

- [ ] 3.2 Lógica `--detect`: `components.json` / `components/ui/` → shadcn; tailwind sem ui → prompt path
  - **Pattern:** `openspec/changes/add-sdd-ui-development-module/design.md` § árvore de detecção
  - **Gate:** `bash sdd-kit/install-ui-module.sh --detect 2>&1; test $? -eq 0`

- [ ] 3.3 `--apply`: copiar `doc/design/*` do templates; Impeccable só com `--yes`; actualizar `infra.md`
  - **Pattern:** `sdd-kit/install.sh`
  - **Gate:** `grep -q 'impeccable' sdd-kit/install-ui-module.sh && grep -q '\-\-yes' sdd-kit/install-ui-module.sh`

## 4. sdd-kit templates e MANIFEST

- [ ] 4.1 Copiar `doc/design/000–003` para `sdd-kit/templates/doc/design/`
  - **Pattern:** `sdd-kit/templates/scripts/verify-infra.sh`
  - **Gate:** `test -f sdd-kit/templates/doc/design/002-ui-module-install.md && test -f sdd-kit/templates/doc/design/003-ui-stack-adapters.md`

- [ ] 4.2 Actualizar `sdd-kit/MANIFEST.yaml` com `install-ui-module.sh` e quatro `doc/design/*`
  - **Pattern:** `sdd-kit/MANIFEST.yaml` (entries session scripts)
  - **Gate:** `grep -q 'install-ui-module' sdd-kit/MANIFEST.yaml && grep -q 'doc/design/002' sdd-kit/MANIFEST.yaml`

- [ ] 4.3 Actualizar `sdd-kit/README.md` com cenário C1-UI
  - **Pattern:** `sdd-kit/README.md` (tabela C1/C2/C3)
  - **Gate:** `grep -q 'C1-UI\|install-ui-module' sdd-kit/README.md`

## 5. Guia canónico

- [ ] 5.1 Adicionar C1-UI em §1.6 (cenários de instalação)
  - **Pattern:** `doc/sistema-sdd-pedro.md` §1.6 tabela C1–C3
  - **Gate:** `grep -q 'C1-UI' doc/sistema-sdd-pedro.md`

- [ ] 5.2 Criar §2.11 Módulo de desenvolvimento de UI (~80 linhas, só ponteiros)
  - **Pattern:** `openspec/changes/add-sdd-ui-development-module/design.md` § esboço §2.11
  - **Gate:** `grep -q '2.11' doc/sistema-sdd-pedro.md && grep -q 'install-ui-module' doc/sistema-sdd-pedro.md && grep -q 'doc/design/002' doc/sistema-sdd-pedro.md`

- [ ] 5.3 Criar §2.11.1 checklist verificação UI module
  - **Pattern:** `doc/sistema-sdd-pedro.md` §2.8
  - **Gate:** `grep -q '2.11.1' doc/sistema-sdd-pedro.md`

- [ ] 5.4 Criar §5.6 referências cruzadas módulo UI
  - **Pattern:** `doc/sistema-sdd-pedro.md` §5.5
  - **Gate:** `grep -q '5.6' doc/sistema-sdd-pedro.md && grep -q 'doc/design/001' doc/sistema-sdd-pedro.md`

- [ ] 5.5 Bump changelog guia (v1.3.1 ou v1.4.0) com entrada UI module
  - **Pattern:** `doc/sistema-sdd-pedro.md` changelog 1.3.0
  - **Gate:** `grep -q 'UI module\|módulo.*UI\|ui-development' doc/sistema-sdd-pedro.md`

## 6. Infra, project, AGENTS

- [ ] 6.1 Secção UI Development Module em `openspec/infra.md` e template kit
  - **Pattern:** `openspec/infra.md` secção Install Kit
  - **Gate:** `grep -q 'UI Development Module\|Módulo.*UI' openspec/infra.md`

- [ ] 6.2 Campo `UI stack:` no template `openspec/project.md` (§12.1) e `sdd-kit/templates/`
  - **Pattern:** `openspec/project.md` Stack section
  - **Gate:** `grep -q 'UI stack' openspec/project.md || grep -q 'UI stack' doc/sistema-sdd-pedro.md`

- [ ] 6.3 Ponteiros UI em `sdd-kit/templates/AGENTS.core.md` Contexto sob demanda (se ≤150 linhas após merge)
  - **Pattern:** `AGENTS.md` secção Documentação relacionada
  - **Gate:** `grep -q 'doc/design/002' sdd-kit/templates/AGENTS.core.md || grep -q 'doc/design/002' AGENTS.md`

- [ ] 6.4 Cross-references em `openspec/project.md` para §2.11 e `doc/design/`
  - **Pattern:** `openspec/project.md` Cross-references
  - **Gate:** `grep -q 'doc/design' openspec/project.md`

## 7. Spec normativa e validação

- [ ] 7.1 Promover `openspec/changes/add-sdd-ui-development-module/specs/sdd-ui-module/spec.md` para `openspec/specs/` no archive
  - **Pattern:** `openspec/specs/sdd-install-kit/spec.md`
  - **Gate:** `test -f openspec/changes/add-sdd-ui-development-module/specs/sdd-ui-module/spec.md`

- [ ] 7.2 Correr `scripts/verify-task-patterns.sh` no `tasks.md` deste change
  - **Pattern:** `scripts/verify-task-patterns.sh`
  - **Gate:** `bash scripts/verify-task-patterns.sh openspec/changes/add-sdd-ui-development-module/tasks.md`

- [ ] 7.3 Validar change: `npx openspec validate add-sdd-ui-development-module` (se CLI disponível)
  - **Gate:** `npx openspec validate add-sdd-ui-development-module 2>/dev/null || test -f openspec/changes/add-sdd-ui-development-module/proposal.md`

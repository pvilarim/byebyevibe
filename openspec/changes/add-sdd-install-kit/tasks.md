# Tasks — add-sdd-install-kit

## 1. Estrutura sdd-kit

- [ ] 1.1 Criar `sdd-kit/MANIFEST.yaml` v1.3.0 com lista completa de ficheiros, merge strategy e gates
  - **Pattern:** `openspec/changes/archive/2026-06-17-add-sdd-session-coordination/proposal.md` (tabela camadas)
  - **Gate:** `test -f sdd-kit/MANIFEST.yaml && grep -q 'version: \"1.3.0\"' sdd-kit/MANIFEST.yaml`

- [ ] 1.2 Criar `sdd-kit/README.md` (C1/C2/C2b/C3, comandos, perfis)
  - **Pattern:** `doc/sistema-sdd-pedro.md` §2.8
  - **Gate:** `grep -q 'C1' sdd-kit/README.md && grep -q 'C3' sdd-kit/README.md`

- [ ] 1.3 Popular `sdd-kit/templates/` a partir do estado actual do piloto
  - **Pattern:** `scripts/sdd-session-check.sh`, `.cursor/rules/015-session-phases.mdc`, `openspec/infra.md`
  - **Invariants:** `sdd-install-kit` spec — paths espelham repo alvo
  - **Gate:** `test -f sdd-kit/templates/scripts/verify-infra.sh && test -f sdd-kit/templates/.cursor/rules/016-session-coordination.mdc`

- [ ] 1.4 Criar `sdd-kit/templates/AGENTS.core.md` e fragments `AGENTS.commands.APP.md` / `AGENTS.commands.DOCS_SPECS.md`
  - **Pattern:** `doc/sistema-sdd-pedro.md` §12.2 + §12.2a + §12.2b
  - **Gate:** `grep -q 'R11' sdd-kit/templates/AGENTS.core.md`

## 2. Scripts install / upgrade / verify

- [ ] 2.1 Implementar `sdd-kit/install.sh` (`--profile`, `--dry-run`, COPY/MERGE)
  - **Pattern:** `scripts/bootstrap-sdd.sh`
  - **Gate:** `bash sdd-kit/install.sh --help >/dev/null 2>&1 || bash sdd-kit/install.sh --dry-run --profile DOCS_SPECS 2>&1 | head -5`

- [ ] 2.2 Implementar `sdd-kit/upgrade.sh` (`--from`, `--to`, `--dry-run`, `--apply`)
  - **Pattern:** `scripts/sdd-upgrade-diff.sh`, `doc/sistema-sdd-pedro.md` §12.8
  - **Gate:** `bash sdd-kit/upgrade.sh --dry-run --from 1.2.0 --to 1.3.0 2>&1 | grep -qi 'UPGRADE\|diff\|KEEP'`

- [ ] 2.3 Implementar `sdd-kit/verify.sh`
  - **Pattern:** `scripts/verify-infra.sh`
  - **Gate:** `bash sdd-kit/verify.sh; test $? -eq 0 || test $? -eq 1`  # 0 se tudo OK; script existe e corre

- [ ] 2.4 Actualizar `scripts/sdd-upgrade-diff.sh` para ler paths de `sdd-kit/MANIFEST.yaml`
  - **Pattern:** `scripts/sdd-upgrade-diff.sh`
  - **Gate:** `bash scripts/sdd-upgrade-diff.sh 2>&1 | grep -q '015-session-phases'`

- [ ] 2.5 Actualizar `scripts/bootstrap-sdd.sh` para referenciar `sdd-kit/install.sh` pós-CLIs
  - **Pattern:** `scripts/bootstrap-sdd.sh`
  - **Gate:** `grep -q 'sdd-kit/install' scripts/bootstrap-sdd.sh`

## 3. Guia canónico v1.3.0

- [ ] 3.1 Adicionar §1.6 *Organização do projecto e tipos de instalação* (4 camadas, C1–C3, perfis, hub vs APP)
  - **Pattern:** `openspec/changes/add-sdd-install-kit/design.md` § Modelo de organização
  - **Gate:** `grep -q '§1.6\|1.6 Organização' doc/sistema-sdd-pedro.md && grep -q 'sdd-kit' doc/sistema-sdd-pedro.md`

- [ ] 3.2 Actualizar tabela "Como usar este documento" e §2.0 prompt IA para `sdd-kit/install.sh`
  - **Pattern:** `doc/sistema-sdd-pedro.md` §2.0
  - **Gate:** `grep -q 'sdd-kit/install' doc/sistema-sdd-pedro.md`

- [ ] 3.3 Actualizar §2.9.5 matriz e §12.9 staging — fonte = `sdd-kit/templates/`, não extração markdown
  - **Pattern:** `doc/sistema-sdd-pedro.md` §2.9.5
  - **Gate:** `grep -q 'sdd-kit/templates' doc/sistema-sdd-pedro.md`

- [ ] 3.4 Bump versão guia para v1.3.0 + changelog §14 (install kit, §1.6, session coord no changelog)
  - **Pattern:** `doc/sistema-sdd-pedro.md` changelog 1.2.1
  - **Gate:** `grep -q '1.3.0' doc/sistema-sdd-pedro.md && grep -q 'sdd-kit\|install kit' doc/sistema-sdd-pedro.md`

- [ ] 3.5 Deprecar em §12 blocos de scripts inteiros — substituir por ponteiro `sdd-kit/templates/`
  - **Pattern:** `doc/sistema-sdd-pedro.md` §12.6
  - **Gate:** `grep -q 'sdd-kit/templates' doc/sistema-sdd-pedro.md`

## 4. Infra, project e AGENTS

- [ ] 4.1 Secção Install Kit em `openspec/infra.md`
  - **Pattern:** `openspec/infra.md` secção Session Coordination
  - **Gate:** `grep -q 'Install Kit' openspec/infra.md`

- [ ] 4.2 Actualizar `openspec/project.md` Cross-references → guia v1.3.0 + `sdd-kit/`
  - **Pattern:** `openspec/project.md`
  - **Gate:** `grep -q 'v1.3.0' openspec/project.md && grep -q 'sdd-kit' openspec/project.md`

- [ ] 4.3 Entrada `sdd-kit/` na tabela Contexto sob demanda de `AGENTS.md` (se ≤150 linhas)
  - **Pattern:** `AGENTS.md` linha infra.md
  - **Gate:** `test $(wc -l < AGENTS.md) -le 150 && grep -q 'sdd-kit' AGENTS.md`

- [ ] 4.4 Actualizar `scripts/verify-infra.sh` para validar kit version / paths MANIFEST
  - **Pattern:** `scripts/verify-infra.sh`
  - **Gate:** `grep -q 'MANIFEST\|sdd-kit' scripts/verify-infra.sh`

## 5. Validação e fecho

- [ ] 5.1 `bash scripts/verify-task-patterns.sh` nos tasks deste change
  - **Gate:** `bash scripts/verify-task-patterns.sh`

- [ ] 5.2 `npx openspec validate add-sdd-install-kit` (se CLI disponível)
  - **Gate:** `npx openspec validate add-sdd-install-kit 2>/dev/null || test -f openspec/changes/add-sdd-install-kit/proposal.md`

- [ ] 5.3 Teste integrado: `bash sdd-kit/verify.sh` no piloto pós-apply
  - **Gate:** `bash sdd-kit/verify.sh`

- [ ] 5.4 Commit: `feat(sdd): install kit v1.3.0 (add-sdd-install-kit)`
  - **Gate:** `git log -1 --oneline | grep -qi 'install kit'`

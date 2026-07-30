# Tasks — translate-supply-chain-wave-1

> Apply scope after human approval (R7). **In-place PT→EN only** on the listed active-change artifacts. **Issue:** —

## 1. Substitute active-change artifacts (PT→EN)

- [x] 1.1 Translate `openspec/changes/add-supply-chain-gates/proposal.md` to glossary-canonical English in-place
  - **Pattern:** `openspec/changes/add-supply-chain-gates/proposal.md`
  - **Invariants:** `sdd-docs-language` — Supply-chain wave-1 active-change artifacts are English
  - **Gate:** `! grep -Eiq 'não|também|através|apenas|qualquer|conforme|secção|seção|requisito|comportamento|utilizando|incluindo|seguinte|verificação|avaliação|canónico|actualmente|atualização|próximo|depois de|antes de|Objectivo|adopção|activados|activação|dispensável|bloqueante' openspec/changes/add-supply-chain-gates/proposal.md`
  - **Forbidden:** dual-file siblings; rewriting freeze-list tokens (`add-supply-chain-gates`, `explore-oss-coverage-gaps`, `/opsx:*`, workflow names); editing `design.md`; editing sibling `specs/sdd-supply-chain/`; editing other completed-change proposals

- [x] 1.2 Translate `openspec/changes/add-supply-chain-gates/tasks.md` to glossary-canonical English in-place (keep historical `[x]` markers and Gate/Pattern command strings structurally intact)
  - **Pattern:** `openspec/changes/add-supply-chain-gates/tasks.md`
  - **Invariants:** `sdd-docs-language` — Supply-chain wave-1 active-change artifacts are English
  - **Gate:** `! grep -Eiq 'não|também|através|apenas|qualquer|conforme|secção|seção|requisito|comportamento|utilizando|incluindo|seguinte|verificação|avaliação|canónico|actualmente|atualização|próximo|depois de|antes de|Pré-requisito|piloto|Actualizar|Criar |Correr |Espelhar|Promover|canónico|Avaliação' openspec/changes/add-supply-chain-gates/tasks.md`
  - **Forbidden:** flipping historical `[x]` to `[ ]`; dual-file siblings; changing Pattern/Gate command strings beyond language in surrounding prose; editing `design.md`; editing live `.github/workflows/sdd-gates.yml` or kit templates

- [x] 1.3 Translate `openspec/changes/add-supply-chain-gates/specs/sdd-ci-gates/spec.md` to glossary-canonical English in-place
  - **Pattern:** `openspec/changes/add-supply-chain-gates/specs/sdd-ci-gates/spec.md`
  - **Invariants:** `sdd-docs-language` — Supply-chain wave-1 active-change artifacts are English
  - **Gate:** `! grep -Eiq 'não|também|através|apenas|qualquer|conforme|secção|seção|requisito|comportamento|utilizando|incluindo|seguinte|verificação|avaliação|canónico|actualmente|atualização|próximo|depois de|antes de|quando o|então o|corre num|afectado' openspec/changes/add-supply-chain-gates/specs/sdd-ci-gates/spec.md`
  - **Forbidden:** changing normative OSV fail-closed / SKIP semantics; dual-file siblings; editing promoted `openspec/specs/sdd-ci-gates/spec.md` (owned by specs-wave-1 propose); editing sibling `specs/sdd-supply-chain/`

## 2. Optional glossary

- [x] 2.1 Expand `doc/i18n/GLOSSARY.md` only if apply introduces a new SDD term not already listed; otherwise SKIP
  - **Pattern:** `doc/i18n/GLOSSARY.md`
  - **Gate:** `test -f doc/i18n/GLOSSARY.md && grep -q 'Canonical EN' doc/i18n/GLOSSARY.md`
  - **Note:** none expected — Session Handoff / gate / change / wave / evaluation vocabulary already seeded

## 3. Wave gates

- [x] 3.1 Run per-wave i18n verification on the exact active-change file list
  - **Pattern:** `scripts/verify-i18n-wave.sh`
  - **Invariants:** `sdd-docs-language` — Per-wave and global verification script; Supply-chain wave-1 active-change artifacts are English
  - **Gate:** `bash scripts/verify-i18n-wave.sh --files openspec/changes/add-supply-chain-gates/proposal.md,openspec/changes/add-supply-chain-gates/tasks.md,openspec/changes/add-supply-chain-gates/specs/sdd-ci-gates/spec.md`
  - **Forbidden:** marking tasks done if G-PT/G-INV/G-LINK/G-OPENSPEC fail; running `--dod` as a required gate for this wave; including `design.md` in `--files` for this wave

- [x] 3.2 Validate OpenSpec change + task Pattern paths
  - **Pattern:** `scripts/verify-task-patterns.sh`
  - **Gate:** `bash scripts/verify-task-patterns.sh && OPENSPEC_TELEMETRY=0 npx --yes @fission-ai/openspec@1.3.1 validate translate-supply-chain-wave-1 --strict`

## 4. Post-register (best-effort)

- [x] 4.1 `graphify update .` if available (docs touched); otherwise SKIP per infra
  - **Pattern:** `.cursor/rules/graphify.mdc`
  - **Gate:** `test -f graphify-out/GRAPH_REPORT.md || echo 'SKIP (graphify unavailable)'`
  - **Note:** SKIP if graphify CLI unavailable

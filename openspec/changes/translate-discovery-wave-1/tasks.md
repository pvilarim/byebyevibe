# Tasks — translate-discovery-wave-1

> Apply scope after human approval (R7). **Propose-only in this session.** Language substitution in-place; no dual-file siblings; no product re-decision. **Issue:** —

## 1. Substitute active-change artifacts (PT→EN)

- [ ] 1.1 Translate `openspec/changes/add-sdd-discovery-positioning/proposal.md` to glossary-canonical English in-place
  - **Pattern:** `openspec/changes/add-sdd-discovery-positioning/proposal.md`
  - **Invariants:** `sdd-docs-language` — Discovery wave-1 active-change artifacts are English
  - **Gate:** `! grep -Eiq 'não|também|através|apenas|qualquer|conforme|secção|seção|requisito|comportamento|utilizando|incluindo|seguinte|verificação|avaliação|canónico|actualmente|atualização|próximo|depois de|antes de|Objectivo|adopção|documentar|precisamos|melhorias' openspec/changes/add-sdd-discovery-positioning/proposal.md`
  - **Forbidden:** dual-file siblings; rewriting freeze-list tokens (`add-sdd-discovery-positioning`, `sdd-discovery-positioning`, `/opsx:*`); editing `research.md`; editing `doc/avaliacoes/2026-07-26-sdd-discovery-positioning.md`; editing other completed-change proposals

- [ ] 1.2 Translate `openspec/changes/add-sdd-discovery-positioning/design.md` to glossary-canonical English in-place
  - **Pattern:** `openspec/changes/add-sdd-discovery-positioning/design.md`
  - **Invariants:** `sdd-docs-language` — Discovery wave-1 active-change artifacts are English
  - **Gate:** `! grep -Eiq 'não|também|através|apenas|qualquer|conforme|secção|seção|requisito|comportamento|utilizando|incluindo|seguinte|verificação|avaliação|canónico|actualmente|atualização|próximo|depois de|antes de|ficheiro|sessão|mudança|proposta|Adiada|Adiado|Adoptado|Actualizar' openspec/changes/add-sdd-discovery-positioning/design.md`
  - **Forbidden:** changing D9/D10/D11 decision semantics; dual-file siblings; editing `research.md`

- [ ] 1.3 Translate `openspec/changes/add-sdd-discovery-positioning/tasks.md` to glossary-canonical English in-place (keep historical `[x]` markers and Gate/Pattern command strings structurally intact)
  - **Pattern:** `openspec/changes/add-sdd-discovery-positioning/tasks.md`
  - **Invariants:** `sdd-docs-language` — Discovery wave-1 active-change artifacts are English
  - **Gate:** `! grep -Eiq 'não|também|através|apenas|qualquer|conforme|secção|seção|requisito|comportamento|utilizando|incluindo|seguinte|verificação|avaliação|canónico|actualmente|atualização|próximo|depois de|antes de|Pré-requisito|Actualizar|Criar |Adicionar |Garantir|Promover|Aplicar |Indexar' openspec/changes/add-sdd-discovery-positioning/tasks.md`
  - **Forbidden:** flipping historical `[x]` to `[ ]`; dual-file siblings; changing Pattern/Gate command strings beyond language in surrounding prose; editing other completed-change `tasks.md` files; editing live `README.md` / kit README / guide

## 2. Optional glossary

- [ ] 2.1 Expand `doc/i18n/GLOSSARY.md` only if apply introduces a new SDD term not already listed; otherwise SKIP
  - **Pattern:** `doc/i18n/GLOSSARY.md`
  - **Gate:** `test -f doc/i18n/GLOSSARY.md && grep -q 'Canonical EN' doc/i18n/GLOSSARY.md`
  - **Note:** none expected — Session Handoff / gate / change / wave / evaluation / discovery vocabulary already seeded

## 3. Wave gates

- [ ] 3.1 Run per-wave i18n verification on the exact active-change file list
  - **Pattern:** `scripts/verify-i18n-wave.sh`
  - **Invariants:** `sdd-docs-language` — Per-wave and global verification script; Discovery wave-1 active-change artifacts are English
  - **Gate:** `bash scripts/verify-i18n-wave.sh --files openspec/changes/add-sdd-discovery-positioning/proposal.md,openspec/changes/add-sdd-discovery-positioning/design.md,openspec/changes/add-sdd-discovery-positioning/tasks.md`
  - **Forbidden:** marking tasks done if G-PT/G-INV/G-LINK/G-OPENSPEC fail; running `--dod` as a required gate for this wave; including `research.md` or avaliacoes evaluation path in `--files`

- [ ] 3.2 Validate OpenSpec change + task Pattern paths
  - **Pattern:** `scripts/verify-task-patterns.sh`
  - **Gate:** `bash scripts/verify-task-patterns.sh && OPENSPEC_TELEMETRY=0 npx --yes @fission-ai/openspec@1.3.1 validate translate-discovery-wave-1 --strict`

## 4. Post-register (best-effort)

- [ ] 4.1 `graphify update .` if available (docs touched); otherwise SKIP per infra
  - **Pattern:** `.cursor/rules/graphify.mdc`
  - **Gate:** `test -f graphify-out/GRAPH_REPORT.md || echo 'SKIP (graphify unavailable)'`
  - **Note:** SKIP if graphify CLI unavailable

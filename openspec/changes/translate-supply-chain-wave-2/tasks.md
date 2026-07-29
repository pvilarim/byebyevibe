# Tasks — translate-supply-chain-wave-2

> Apply scope after human approval (R7). **Propose-only in this session.** Language substitution in-place; no dual-file siblings; no product re-decision. **Issue:** —

## 1. Substitute active-change design (PT→EN)

- [ ] 1.1 Translate `openspec/changes/add-supply-chain-gates/design.md` to glossary-canonical English in-place (keep decision IDs D1–D9, G1 compatibility table IDs, SHA pins, and fenced commands structurally intact)
  - **Pattern:** `openspec/changes/add-supply-chain-gates/design.md`
  - **Invariants:** `sdd-docs-language` — Supply-chain wave-2 design artifact is English
  - **Gate:** `! grep -Eiq 'não|também|através|apenas|qualquer|conforme|secção|seção|requisito|comportamento|utilizando|incluindo|seguinte|verificação|avaliação|canónico|actualmente|atualização|próximo|depois de|antes de|durante o|quando o|então o|ficheiro|ficheiros|sessão|dispensável|bloqueante|activação|Objectivo|adopção|Escolha|Alternativa|Mantém|actual ' openspec/changes/add-supply-chain-gates/design.md`
  - **Forbidden:** dual-file siblings; rewriting freeze-list tokens (`add-supply-chain-gates`, `explore-oss-coverage-gaps`, `/opsx:*`, workflow names, OSV SHA `8dc09193bb540e09b23da07ad7e30bd33bf87018`); changing decision outcomes D1–D9; editing wave-1 paths (`proposal.md`, `tasks.md`, `specs/sdd-ci-gates/`); editing sibling `specs/sdd-supply-chain/`; editing live `.github/workflows/sdd-gates.yml` or kit templates

## 2. Optional glossary

- [ ] 2.1 Expand `doc/i18n/GLOSSARY.md` only if apply introduces a new SDD term not already listed; otherwise SKIP
  - **Pattern:** `doc/i18n/GLOSSARY.md`
  - **Gate:** `test -f doc/i18n/GLOSSARY.md && grep -q 'Canonical EN' doc/i18n/GLOSSARY.md`
  - **Note:** none expected — Session Handoff / gate / change / wave / evaluation vocabulary already seeded

## 3. Wave gates

- [ ] 3.1 Run per-wave i18n verification on the exact design file
  - **Pattern:** `scripts/verify-i18n-wave.sh`
  - **Invariants:** `sdd-docs-language` — Per-wave and global verification script; Supply-chain wave-2 design artifact is English
  - **Gate:** `bash scripts/verify-i18n-wave.sh --files openspec/changes/add-supply-chain-gates/design.md`
  - **Forbidden:** marking tasks done if G-PT/G-INV/G-LINK/G-OPENSPEC fail; running `--dod` as a required gate for this wave; including wave-1 paths in `--files` for this wave

- [ ] 3.2 Validate OpenSpec change + task Pattern paths
  - **Pattern:** `scripts/verify-task-patterns.sh`
  - **Gate:** `bash scripts/verify-task-patterns.sh && OPENSPEC_TELEMETRY=0 npx --yes @fission-ai/openspec@1.3.1 validate translate-supply-chain-wave-2 --strict`

## 4. Post-register (best-effort)

- [ ] 4.1 `graphify update .` if available (docs touched); otherwise SKIP per infra
  - **Pattern:** `.cursor/rules/graphify.mdc`
  - **Gate:** `test -f graphify-out/GRAPH_REPORT.md || echo 'SKIP (graphify unavailable)'`
  - **Note:** SKIP if graphify CLI unavailable

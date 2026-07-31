# Tasks — translate-kit-scripts-wave-2

> Apply after human approval (R7). **In-place PT→EN only** on the two `verify-infra.sh` paths (+ MANIFEST checksums). **Prefer after** `translate-infra-wave-1` apply so hub `openspec/infra.md` chrome is already English. **Issue:** —

## 1. Prep (glossary + freeze + prerequisite)

- [x] 1.1 Confirm glossary covers terms needed for this wave (`verification` / gate wording, `install kit`, `wave`); append rows to `doc/i18n/GLOSSARY.md` only if a new SDD term is introduced (same PR)
  - **Pattern:** `doc/i18n/GLOSSARY.md`
  - **Invariants:** `sdd-docs-language` — Glossary and wave inventory exist
  - **Gate:** `test -s doc/i18n/GLOSSARY.md && grep -qE 'install kit|sdd-kit|gate|wave|glossary|inventory|canonical' doc/i18n/GLOSSARY.md`
  - **Forbidden:** invent synonym variants for glossary terms; dual-file `*.en.md` / `*-pt.md`; editing unrelated owned translate paths in this prep task

- [x] 1.2 Confirm soft prerequisite: hub `openspec/infra.md` already uses EN chrome (`Last verified`, env `Variable | Present | Verify with`, `## Agent rule`) — if still Portuguese, STOP with Session Handoff naming `/opsx:apply translate-infra-wave-1` first
  - **Pattern:** `openspec/infra.md`
  - **Invariants:** `sdd-docs-language` — Kit-scripts wave-2 verify-infra residual-PT scripts are English
  - **Gate:** `grep -qF '> Last verified:' openspec/infra.md && grep -qF '| Variable | Present | Verify with |' openspec/infra.md && grep -qF '## Agent rule' openspec/infra.md`
  - **Forbidden:** translating `openspec/infra.md` inside this wave; forcing apply against residual PT chrome without handoff

## 2. Substitute verify-infra scripts (in-place)

- [x] 2.1 Rewrite `scripts/verify-infra.sh` Portuguese operator strings and infra.md chrome matchers/rewrites → glossary-canonical English aligned to kit manifesto (`Last verified`, `Variable | Present | Verify with`, `## Agent rule`); keep HTML marker names, exit codes, and check logic intact
  - **Pattern:** `scripts/verify-infra.sh`
  - **Invariants:** `sdd-docs-language` — Kit-scripts wave-2 verify-infra residual-PT scripts are English; Freeze list of non-translatable tokens
  - **Gate:** `test -f scripts/verify-infra.sh && ! test -f scripts/verify-infra.en.sh && ! test -f scripts/verify-infra-pt.sh && grep -qF '> Last verified:' scripts/verify-infra.sh && grep -qF '| Variable | Present | Verify with |' scripts/verify-infra.sh && grep -qF '## Agent rule' scripts/verify-infra.sh && grep -qF 'openspec-version' scripts/verify-infra.sh && ! grep -qiE 'verificação|Última verificação|Variável \| Presente|Regra agentes|ausente|sem \.env\.example no repo' scripts/verify-infra.sh`
  - **Forbidden:** dual-file siblings; editing `openspec/infra.md`; inventing chrome synonyms not in kit EN manifesto; leaving residual Portuguese that fails G-PT

- [x] 2.2 Rewrite `sdd-kit/templates/scripts/verify-infra.sh` identically (hub and template are byte-identical today — keep them equivalent after EN substitution)
  - **Pattern:** `sdd-kit/templates/scripts/verify-infra.sh`
  - **Invariants:** `sdd-docs-language` — Kit-scripts wave-2 verify-infra residual-PT scripts are English; Freeze list of non-translatable tokens
  - **Gate:** `test -f sdd-kit/templates/scripts/verify-infra.sh && ! test -f sdd-kit/templates/scripts/verify-infra.en.sh && ! test -f sdd-kit/templates/scripts/verify-infra-pt.sh && cmp -s scripts/verify-infra.sh sdd-kit/templates/scripts/verify-infra.sh && grep -qF '> Last verified:' sdd-kit/templates/scripts/verify-infra.sh && ! grep -qiE 'verificação|Última verificação|Variável \| Presente|Regra agentes|ausente|sem \.env\.example no repo' sdd-kit/templates/scripts/verify-infra.sh`
  - **Forbidden:** dual-file siblings; intentional hub↔template fork in this wave; rewriting unrelated kit templates; leaving residual Portuguese that fails G-PT

## 3. Kit checksums + wave gates

- [x] 3.1 Regenerate MANIFEST checksums after the template edit
  - **Pattern:** `sdd-kit/gen-manifest-checksums.sh`
  - **Invariants:** `sdd-docs-language` — Kit-scripts wave-2 verify-infra residual-PT scripts are English
  - **Gate:** `bash sdd-kit/gen-manifest-checksums.sh && grep -A6 'path: scripts/verify-infra.sh' sdd-kit/MANIFEST.yaml | grep -q 'sha256:'`
  - **Forbidden:** hand-editing unrelated MANIFEST merge/profile fields; skipping checksum regeneration

- [x] 3.2 Run per-wave i18n verification on the exact script paths
  - **Pattern:** `scripts/verify-i18n-wave.sh`
  - **Invariants:** `sdd-docs-language` — Per-wave and global verification script; Kit-scripts wave-2 verify-infra residual-PT scripts are English
  - **Gate:** `bash scripts/verify-i18n-wave.sh --files scripts/verify-infra.sh,sdd-kit/templates/scripts/verify-infra.sh`
  - **Forbidden:** marking tasks done if G-PT/G-INV/G-MANIFEST/G-OPENSPEC fail; running `--dod` as a required gate for this wave; touching over-budget surfaces in this apply

- [x] 3.3 Validate OpenSpec change + task Pattern paths
  - **Pattern:** `scripts/verify-task-patterns.sh`
  - **Gate:** `bash scripts/verify-task-patterns.sh && OPENSPEC_TELEMETRY=0 npx --yes @fission-ai/openspec@1.3.1 validate translate-kit-scripts-wave-2 --strict`

## 4. Post-register (best-effort)

- [x] 4.1 `graphify update .` if available (docs/scripts touched); otherwise SKIP per infra
  - **Pattern:** `.cursor/rules/graphify.mdc`
  - **Gate:** `test -f graphify-out/GRAPH_REPORT.md || echo 'SKIP (graphify unavailable)'`
  - **Note:** SKIP if graphify CLI unavailable

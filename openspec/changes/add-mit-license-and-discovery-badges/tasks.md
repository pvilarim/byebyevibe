## 1. Hub license files

- [x] 1.1 Create root `LICENSE` (no extension) with the canonical MIT License body and copyright line `Copyright (c) 2026 Pedro Vilarim`. Do not put a third-party table in this file.
  - **Pattern:** `openspec/changes/add-mit-license-and-discovery-badges/design.md`
  - **Invariants:** Hub ships an MIT LICENSE file (`sdd-discovery-positioning`)
  - **Forbidden:** NOTICE content inside `LICENSE`; filename `LICENSE.md`
  - **Gate:** `test -f LICENSE && grep -q 'MIT License' LICENSE && grep -q 'Pedro Vilarim' LICENSE && grep -q '2026' LICENSE && ! grep -qi 'PolyForm' LICENSE && echo OK`

- [x] 1.2 Create root `NOTICE.md` from design D3: compose-not-relicense statement; table of OpenSpec, GitNexus, Graphify, Probity, Impeccable, OSV-Scanner, Renovate with licenses and upstream links; GitNexus PolyForm Noncommercial / not-MIT / commercial-use caveat; do not claim the kit vendors GitNexus skills.
  - **Pattern:** `openspec/changes/add-mit-license-and-discovery-badges/design.md`
  - **Invariants:** Hub ships NOTICE for composed-tool licenses (`sdd-discovery-positioning`)
  - **Forbidden:** MIT legal text duplicated as the whole file; claim that `sdd-kit/` vendors `.claude/skills/gitnexus/`
  - **Gate:** `grep -q 'PolyForm Noncommercial' NOTICE.md && grep -q 'does not cover commercial use' NOTICE.md && grep -q 'OpenSpec' NOTICE.md && grep -q 'Graphify' NOTICE.md && grep -q 'AGPL-3.0' NOTICE.md && echo OK`

## 2. Root README chrome

- [x] 2.1 Insert the three honest badges (Release, SDD Gates, License: MIT) after the tagline and before the dual-naming paragraph, per design D4. Optional `align="center"` on the badge paragraph only.
  - **Pattern:** `README.md`
  - **Invariants:** Root README shows honest status badges only (`sdd-discovery-positioning`)
  - **Forbidden:** npm, OpenSSF Scorecard, Discord, PolyForm, or wrapping the whole README in `<div align="center">`
  - **Gate:** `grep -q 'img.shields.io/github/v/release/pvilarim/byebyevibe' README.md && grep -q 'actions/workflows/sdd-gates.yml/badge.svg' README.md && grep -q 'License-MIT' README.md && ! grep -q 'npm/v/' README.md && ! grep -q 'securityscorecards.dev' README.md && ! grep -q 'img.shields.io/discord' README.md && echo OK`

- [x] 2.2 In "Stack & companions", after the compose-OpenSpec line, add one sentence pointing at `NOTICE.md` and stating GitNexus is PolyForm Noncommercial (not MIT).
  - **Pattern:** `README.md`
  - **Invariants:** Discovery surfaces disclose composed-stack licenses (`sdd-discovery-positioning`)
  - **Gate:** `grep -A8 'Stack & companions' README.md | grep -q 'NOTICE.md' && grep -A8 'Stack & companions' README.md | grep -q 'PolyForm' && echo OK`

- [x] 2.3 Add Docs table rows for `LICENSE` (MIT — this repository) and `NOTICE.md` (licenses of composed tools). Do not add a new `## Licenses` section.
  - **Pattern:** `README.md`
  - **Forbidden:** new top-level `## Licenses` heading
  - **Gate:** `grep -q 'LICENSE' README.md && grep -q 'NOTICE.md' README.md && ! grep -q '^## Licenses' README.md && echo OK`

## 3. Kit README (kit-only fetch)

- [x] 3.1 Add a short license paragraph to `sdd-kit/README.md` (after the first-contact block, before `## Scenarios`) stating payload files are MIT and naming GitNexus PolyForm Noncommercial inline, plus OpenSpec MIT, Graphify Apache-2.0, and the optional/supply-chain SPDX ids from D3. A hub `NOTICE.md` link is extra, not a substitute.
  - **Pattern:** `sdd-kit/README.md`
  - **Invariants:** Discovery surfaces disclose composed-stack licenses (`sdd-discovery-positioning`)
  - **Forbidden:** editing `doc/byebyevibe-guide.md` or `sdd-kit/MANIFEST.yaml`
  - **Gate:** `grep -q 'PolyForm Noncommercial' sdd-kit/README.md && grep -q 'MIT' sdd-kit/README.md && echo OK`

## 4. Guardrails

- [x] 4.1 Confirm `install.sh`, `upgrade.sh`, `MANIFEST.yaml`, and `sdd-kit/templates/` were not modified and that neither `LICENSE` nor `NOTICE.md` is a MANIFEST payload path.
  - **Pattern:** `sdd-kit/MANIFEST.yaml`
  - **Forbidden:** adding `LICENSE` / `NOTICE.md` to the install payload
  - **Gate:** `! grep -E 'path:.*(LICENSE|NOTICE\\.md)' sdd-kit/MANIFEST.yaml && echo OK`

## 5. Validate

- [x] 5.1 Validate the change and task patterns.
  - **Gate:** `OPENSPEC_TELEMETRY=0 npx --yes @fission-ai/openspec@1.3.1 validate add-mit-license-and-discovery-badges --strict && bash scripts/verify-task-patterns.sh`

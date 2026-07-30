# Tasks — add-sdd-discovery-positioning

> Apply scope after human approval (R7). **DOCS_SPECS** profile — docs/specs only in this hub. **Non-goals (D9):** app boilerplate, Landing/Pages, Discord, one-liner fame, BMAD, GitHub brand. **Out of this apply (D10 / research §11):** final rename/name, full EN translation, P5 GIF/asciinema. README demo = text. Working title ok. **Issue:** —

## 1. Canonical evaluation (starting document)

- [x] 1.1 Create `doc/avaliacoes/2026-07-26-sdd-discovery-positioning.md` from `openspec/changes/add-sdd-discovery-positioning/research.md` (TEMPLATE structure + analysis content; statuses: P0/P1 surfaces Adopted after apply; P5–P10 Deferred; app scaffold Non-goal)
  - **Pattern:** `doc/avaliacoes/TEMPLATE.md`
  - **Invariants:** `sdd-discovery-positioning` — Competitive evaluation document is the lasting research artifact
  - **Gate:** `test -f doc/avaliacoes/2026-07-26-sdd-discovery-positioning.md && grep -q 'vibe coding' doc/avaliacoes/2026-07-26-sdd-discovery-positioning.md && grep -q 'spec-kit\|Spec Kit' doc/avaliacoes/2026-07-26-sdd-discovery-positioning.md`

- [x] 1.2 Index the evaluation in `doc/avaliacoes/README.md` (new table row; **Mixed** or **Adopted** decision per text)
  - **Pattern:** `doc/avaliacoes/README.md`
  - **Gate:** `grep -q '2026-07-26-sdd-discovery-positioning' doc/avaliacoes/README.md`

## 2. Root README (EN discovery)

- [x] 2.1 Create root `README.md`: hero from-vibe-to-agentic; anti-boilerplate; CTA `sdd-kit/install.sh`; opsx demo; OpenSpec/GitNexus/Graphify/gates/modules/**SDD metrics (calibrate as you go — research §12 / design D11, no ML claim)** overview; short compare; pt-BR guide link; About/topics checklist or pointer to evaluation
  - **Pattern:** `openspec/changes/add-sdd-discovery-positioning/research.md`
  - **Invariants:** `sdd-discovery-positioning` — Root README exists with vibe-to-agentic positioning; Root README includes demo and capability overview; Positioning forbids pretending to be an app starter
  - **Gate:** `test -f README.md && grep -qiE 'vibe coding|agentic' README.md && grep -qiE 'not another|boilerplate|starter' README.md && grep -q 'sdd-kit/install.sh' README.md && grep -qiE 'opsx|OpenSpec' README.md && grep -qi 'GitNexus' README.md && grep -qi 'Graphify' README.md && grep -qiE 'sdd-metrics|calibrat|retrospective|rework|lead.time' README.md`

## 3. Kit README (positioning + friendly map)

- [x] 3.1 Prepend/intro in `sdd-kit/README.md`: what the kit is; C1/C2/C3 (and G2/G4 if applicable) map → human-readable names; link to root README / guide; preserve existing operational tables and commands
  - **Pattern:** `sdd-kit/README.md`
  - **Invariants:** `sdd-install-kit` — Kit README includes discovery positioning for newcomers
  - **Gate:** `grep -qiE 'vibe|newcomer|first contact|posicionamento|what this is' sdd-kit/README.md && grep -qE 'C1|Instalação|Greenfield|primeira vez' sdd-kit/README.md && grep -q 'install.sh' sdd-kit/README.md && grep -q 'APP' sdd-kit/README.md`

## 4. Quickstart in canonical guide

- [x] 4.1 Add short first-contact / vibe-coder section in `doc/sistema-sdd-pedro.md` (point to root README + `install.sh --dry-run`); link from “How to use this document” or index; note in Changelog
  - **Pattern:** `doc/sistema-sdd-pedro.md`
  - **Invariants:** `sdd-discovery-positioning` — First-contact quickstart in the canonical guide
  - **Gate:** `grep -qiE 'vibe|first.contact|primeiro contacto|quickstart' doc/sistema-sdd-pedro.md && grep -q 'README.md' doc/sistema-sdd-pedro.md`

## 5. Cross-refs and manual action

- [x] 5.1 Update `openspec/project.md` Cross-references (pointer to evaluation and/or root README); optional ≤5 lines in `AGENTS.md` On-demand context if it fits without bloat
  - **Pattern:** `openspec/project.md`
  - **Gate:** `grep -q '2026-07-26-sdd-discovery-positioning\|discovery-positioning\|README.md' openspec/project.md`

- [x] 5.2 Ensure checklist `[MANUAL ACTION REQUIRED]` with suggested About + topics (`vibe-coding`, `spec-driven-development`, `context-engineering`, `claude-code`, `cursor`) in evaluation and/or README
  - **Pattern:** `openspec/changes/add-sdd-discovery-positioning/research.md`
  - **Invariants:** `sdd-discovery-positioning` — Manual GitHub About and topics checklist
  - **Gate:** `grep -q 'AÇÃO MANUAL NECESSÁRIA' doc/avaliacoes/2026-07-26-sdd-discovery-positioning.md && grep -q 'AÇÃO MANUAL NECESSÁRIA' README.md && grep -q 'vibe-coding' doc/avaliacoes/2026-07-26-sdd-discovery-positioning.md`

## 6. Specs — promotion (on archive / end of apply)

- [x] 6.1 Promote `openspec/changes/add-sdd-discovery-positioning/specs/sdd-discovery-positioning/spec.md` → `openspec/specs/sdd-discovery-positioning/spec.md`
  - **Pattern:** `openspec/specs/sdd-metrics/spec.md`
  - **Gate:** `test -f openspec/specs/sdd-discovery-positioning/spec.md`

- [x] 6.2 Apply ADDED delta of `sdd-install-kit` in `openspec/specs/sdd-install-kit/spec.md`
  - **Pattern:** `openspec/specs/sdd-install-kit/spec.md`
  - **Gate:** `grep -qi 'discovery positioning\|Kit README includes discovery' openspec/specs/sdd-install-kit/spec.md`

## 7. Validation

- [x] 7.1 `OPENSPEC_TELEMETRY=0 npx --yes @fission-ai/openspec@1.3.1 validate add-sdd-discovery-positioning --strict` and `bash scripts/verify-task-patterns.sh`
  - **Pattern:** `scripts/verify-task-patterns.sh`
  - **Gate:** `OPENSPEC_TELEMETRY=0 npx --yes @fission-ai/openspec@1.3.1 validate add-sdd-discovery-positioning --strict && bash scripts/verify-task-patterns.sh`

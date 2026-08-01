## 1. README restructure (primary)

- [ ] 1.1 Reorder `README.md` to the 17-section v2 outline (hero → Why install → anti-boilerplate → Get started → problem → core tools → User-friendly OpenSpec → demo → optional modules → calibrate → disambiguation → who/compare/docs → manual checklist → maintainer). **Pattern:** `README.md` **Gate:** `grep -qiE 'Why install|Why teams' README.md && grep -qi 'AI-assisted development' README.md`
- [ ] 1.2 Ensure above-fold anti-boilerplate and approved tagline/market line. **Pattern:** `README.md` **Gate:** `grep -qiE 'vibe coding|shippable AI engineering' README.md && grep -qiE 'not another|boilerplate|starter' README.md`
- [ ] 1.3 Core tools table with What / Without it for OpenSpec, GitNexus, Graphify, `sdd-kit/`, CI `sdd-gates`, session locks. **Pattern:** `README.md` **Gate:** `grep -qi 'Without it' README.md && grep -qi 'Core tools' README.md`
- [ ] 1.4 User-friendly OpenSpec section: `/opsx:help`, `/opsx:onboard`, explore→propose→apply→archive; link `doc/sdd-operator-day1.md`. **Pattern:** `README.md` **Gate:** `grep -qiE 'opsx:help|/opsx:help' README.md`
- [ ] 1.5 Optional modules block (C1-UI, G2 Probity, review skills, G4 pointer). **Pattern:** `README.md` **Gate:** `grep -qi 'Optional module' README.md`
- [ ] 1.6 Calibrate as you go — `sdd-metrics.sh`, process retrospectives; forbid positive ML/self-learning claims (negation disclaimer OK if no positive claim). **Pattern:** `README.md` **Gate:** `grep -qiE 'calibrat|sdd-metrics' README.md && ! grep -qiE 'self-learning agent|ML-based|automatic kit adaptation' README.md`
- [ ] 1.7 Preserve invariants: install CTA, demo loop, compare table, manual About checklist, maintainer links. **Pattern:** `README.md` **Gate:** `grep -q 'sdd-kit/install.sh' README.md && grep -qi 'Maintainer' README.md && grep -qi 'opsx' README.md`

## 2. Cross-surface updates

- [ ] 2.1 Add v2 layout decision to `doc/avaliacoes/2026-07-26-sdd-discovery-positioning.md` (roadmap item ④ → change `update-readme-discovery-v2`; what changed; P5/P11 intact). **Pattern:** `doc/avaliacoes/2026-07-26-sdd-discovery-positioning.md` **Gate:** `grep -q 'update-readme-discovery-v2' doc/avaliacoes/2026-07-26-sdd-discovery-positioning.md`
- [ ] 2.2 Verify `doc/sistema-sdd-pedro.md` §2.0b mentions `/opsx:help`; add one line only if missing. **Pattern:** `doc/sistema-sdd-pedro.md` **Gate:** `grep -qiE 'opsx:help|/opsx:help' doc/sistema-sdd-pedro.md`

## 3. Validation

- [ ] 3.1 OpenSpec strict validate for this change. **Gate:** `OPENSPEC_TELEMETRY=0 npx --yes @fission-ai/openspec@1.3.1 validate update-readme-discovery-v2 --strict`
- [ ] 3.2 Task pattern verification (if script present). **Gate:** `bash scripts/verify-task-patterns.sh openspec/changes/update-readme-discovery-v2/tasks.md`

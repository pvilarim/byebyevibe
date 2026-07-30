## Why

Gap G2 (`explore-oss-coverage-gaps/research.md`) identifies that rule R6 — "failing test first, then fix" — exists in `AGENTS.md` and the SDD guide but has no in-session enforcement: agents mark tasks complete and apply fixes without regression coverage. The original candidate was TDD Guard; the maintainer declared it superseded by **Probity** ([nizos/probity](https://github.com/nizos/probity)) — new projects should adopt Probity; TDD Guard is kept for legacy only ([tdd-guard README](https://github.com/nizos/tdd-guard)). This change proposes the optional G2 module with Probity, following the C1-UI precedent and insertion methodology (Phases 0–3), with a mandatory pilot before promoting to MANIFEST.

## What Changes

- New optional **APP/HYBRID** module via `sdd-kit/install-probity-module.sh` (`--detect` → `--apply [--yes]`), analogous to `install-ui-module.sh`
- Package `@nizos/probity@1.10.0` (devDependency in the APP repo) with `probity.config.ts` template and `enforceTdd()` rule to materialize R6
- **Mode B** mechanism (PreToolUse hook) — the only in-band gap in the SDD stack; stacks with GitNexus + Graphify (pilot measures p95 latency and false positives)
- Documentary replacement **TDD Guard → Probity** across all SDD documentation citing G2 (canonical list in `tasks.md` § doc migration)
- Registration at the 6 contract points (`infra.md`, `AGENTS.md`, optional skill, guide §2.16, G2 evaluation, sdd-kit/MANIFEST)
- Review pipeline update: `tests (R6/Probity enforceTdd)` → `correctness-review` → `simplify-review` → …
- New spec `sdd-probity-module`; delta in `sdd-correctness-review` (pipeline position)
- Historical note: "TDD Guard superseded by Probity (2026-07)" — do not re-propose TDD Guard

## Capabilities

### New Capabilities

- `sdd-probity-module`: Optional post-C1 module that installs Probity, `probity.config.ts` template, `install-probity-module.sh` script, registration in `infra.md`, and normative requirements for APP/HYBRID repos with tests (Vitest/pytest)

### Modified Capabilities

- `sdd-correctness-review`: Update pipeline position requirement — "R6/TDD Guard" → "R6/Probity (enforceTdd)"

## Impact

- **New files (apply):** `sdd-kit/install-probity-module.sh`, `sdd-kit/templates/install-probity-module.sh`, `sdd-kit/templates/probity.config.ts`, `doc/design/004-probity-module-install.md` (optional), `openspec/specs/sdd-probity-module/spec.md`
- **Modified (apply):** `doc/avaliacoes/2026-07-25-oss-coverage-gaps-tooling.md`, `doc/avaliacoes/README.md`, `openspec/changes/explore-oss-coverage-gaps/research.md`, `openspec/changes/explore-oss-coverage-gaps/metodologia-insercao.md`, `doc/sistema-sdd-pedro.md` (new §2.16), `AGENTS.md`, `sdd-kit/templates/AGENTS.core.md`, `openspec/infra.md` + template, `sdd-kit/README.md`, `sdd-kit/MANIFEST.yaml`, `.claude/skills/correctness-review/SKILL.md`, `.cursor/skills/correctness-review/SKILL.md`, `openspec/specs/sdd-correctness-review/spec.md`
- **External dependency:** `@nizos/probity@1.10.0` (MIT) — devDependency in the APP repo; no Probity API key (reuses agent session)
- **Profiles:** APP and HYBRID with tests — active; DOCS_SPECS — SKIP (this hub)
- **Mandatory pilot:** APP worktree with Vitest or pytest before MANIFEST bump; quantified criteria in `design.md`
- **Non-goals:** TDD Guard in the kit; mandatory Probity in DOCS_SPECS; replacing CI (`sdd-gates`); automatic lint integration (document optional gap)

## Context

- Capability: `sdd-docs-language` · inventory `doc/i18n/WAVES.md` · template `doc/i18n/WAVE-PROPOSAL-TEMPLATE.md` · glossary `doc/i18n/GLOSSARY.md` · automation playbook `doc/i18n/CURSOR-AUTOMATIONS.md` §4.1.
- `translate-specs-wave-1` (DRAFT PR #104) owns `sdd-ci-gates` / `sdd-post-install-verification` / `sdd-session-coordination` and **defers** `openspec/specs/sdd-install-kit/spec.md` to `translate-specs-wave-2`.
- Owned-set on current base + open translate PRs (#78, #84, #93–#104, active `translate-*` changes) does **not** list `sdd-install-kit/spec.md` as primary ownership.
- Residual PT on that file: mixed EN/PT requirement titles and bodies (bootstrap hybrid warning; dry-run COPY label; upgrade header mode; MANIFEST upgrade-tool MERGE sentence; approval-gate scenarios embedding the legacy Portuguese checkbox string).
- G-PT deny-list includes `atualização` / `actualização` / `ficheiro` / `não` / … — pasting the script’s literal approval marker into the EN spec would fail the wave gate.

## Goals / Non-Goals

**Goals:**

- Substitute all Portuguese prose in `openspec/specs/sdd-install-kit/spec.md` with glossary-canonical English **in-place** (whole-file G-PT).
- Preserve normative meaning: upgrade dry-run vs apply; bootstrap profile warning; COPY label vs `APPLY_TEMPLATE`; UPGRADE_REPORT approval gate behavior.
- Keep OpenSpec structure (`## Purpose`, `### Requirement:`, `#### Scenario:`, `MUST`/`WHEN`/`THEN`) and freeze-list identifiers byte-stable.
- Pass `bash scripts/verify-i18n-wave.sh --files openspec/specs/sdd-install-kit/spec.md`.

**Non-Goals:**

- Editing `sdd-kit/upgrade.sh`, guide checklist lines, or renaming the runtime approval marker string (future kit-script / guide wave).
- Wave-1’s three capability specs (owned by #104).
- Already-English specs without residual PT.
- Rewriting `openspec/changes/archive/`.
- Canonical guide, skills/commands, kit templates, hub infra, evaluations, design, course.
- Dual-file `*.en.md` / `*-pt.md`.
- Global G-DoD (`--dod`).
- Changing install/upgrade/bootstrap semantics — language only.

## Knowledge sources consulted (R8)

- `doc/i18n/GLOSSARY.md` — term bank + freeze/allowlist
- `doc/i18n/WAVES.md` — budgets; `openspec/specs/` in-scope for residual PT only
- `doc/i18n/WAVE-PROPOSAL-TEMPLATE.md` — proposal shape
- `doc/i18n/CURSOR-AUTOMATIONS.md` — propose-factory phase; parallel disjoint proposes
- `openspec/specs/sdd-docs-language/spec.md` — EN default, in-place waves
- AS-IS: `openspec/specs/sdd-install-kit/spec.md`
- `sdd-kit/upgrade.sh` — runtime `grep` for approval checkbox (freeze reference only)
- `scripts/verify-i18n-wave.sh`
- Open PR #104 proposal (explicit deferral of this file to wave-2)
- Graphify / GitNexus — SKIP / docs-only (markdown capability spec; no code symbols edited in propose)
- GitHub Issues — no open issue required (**Issue:** —)

## Decisions

### D1: Scope = `sdd-install-kit` alone (wave-2 deferred from #104)

| Option | Verdict |
|--------|---------|
| A — Guide W3 mid-file section | Rejected — G-PT scans whole `--files` paths |
| B — aula-05 alone (~503) | Rejected — exceeds ≤350–400 LOC |
| C — Kit `templates/doc/design/002+003+004` | Deferred — checksum-aware; prefer after hub design apply+archive |
| D — `doc/design/001` alone (~593) | Rejected — exceeds LOC budget |
| E — `sdd-install-kit` alone (~292) | **Chosen** — within budget; disjoint; explicitly deferred by wave-1 |
| F — Include `sdd-kit/upgrade.sh` in `--files` and translate marker | Rejected — script still has broad residual PT; whole-file G-PT would fail unless full script i18n |

**Rationale:** Completes the residual-PT specs track started by wave-1 without overlapping owned paths.

### D2: In-place substitution only (no dual-file)

**Chosen:** Rewrite Portuguese prose at the same path. Forbidden: `spec.en.md`, `*-pt.md`, or parallel language trees under `openspec/specs/`.

**Rationale:** Normative `sdd-docs-language` / WAVES.md — dual-file EN/PT siblings are forbidden.

### D3: Approval marker — reference script contract; do not embed deny-list PT

`sdd-kit/upgrade.sh` currently requires a checked approval line whose Portuguese wording matches deny-list token `Actualização` / `atualização`. Embedding that literal string in the EN spec fails G-PT.

**Chosen:** English requirement/scenario text MUST describe the gate as: `UPGRADE_REPORT.md` must exist and must satisfy the approval checkbox match enforced by `sdd-kit/upgrade.sh` before `--apply` writes (cite the script path; do not paste the legacy Portuguese marker). Runtime behavior stays unchanged until a future wave renames the marker in the script + scaffolds.

**Rationale:** Clears G-PT on the capability spec without expanding this wave into kit-script i18n.

### D4: Spec delta = lasting EN requirement for this slice

**Chosen:** ADDED requirement under `sdd-docs-language` that `openspec/specs/sdd-install-kit/spec.md` MUST be English after substitution. Do not invent a new `sdd-install-kit-i18n` capability. Do not weaken or rewrite install-kit normative meaning beyond language.

**Rationale:** Same pattern as prior translate-* ADDED slice requirements.

## Risks / Trade-offs

| Risk | Mitigation |
|------|------------|
| Apply agent pastes Portuguese approval marker into EN spec | Tasks + design forbid embedding deny-list tokens; gate G-PT |
| Semantic drift of upgrade/bootstrap contracts | Tasks require fact parity; freeze script names, MANIFEST keys, label tokens `COPY` / `APPLY_TEMPLATE` |
| Confusion vs wave-1 ownership | Explicit disjoint path; proposal cites #104 deferral |
| Operators expect marker rename now | Non-goal called out; Session Handoff can note follow-up kit-script wave |

## Migration plan

1. Human approves this propose (R7) — DRAFT PR.
2. Separate `/opsx:apply translate-specs-wave-2` session after propose merge (or when artifacts are on apply base). Disjoint from wave-1 apply.
3. Apply substitutes `sdd-install-kit/spec.md` in place; run wave gates.
4. Archive later (separate session): promote ADDED requirement into `openspec/specs/sdd-docs-language/spec.md`.
5. Follow-ups (other runs): kit-script/guide marker rename; aula-05 split; kit design mirrors; guide G-PT strategy.

## Open Questions

- None for propose. Marker rename English wording (e.g. `[x] Upgrade approved`) deferred to a future change that edits `sdd-kit/upgrade.sh` + scaffolds together.

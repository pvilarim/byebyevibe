# Design — translate-specs-wave-2 (`sdd-install-kit` residual PT→EN)

## Context

- Layer-1 policy and wave budgets live under `sdd-docs-language` / `doc/i18n/*`.
- Active translate ownership on current base includes kit W2c/W2d, hub `openspec/infra.md`, skills waves 1–6, avaliacoes-wave-1, design-waves 1–2, agents-rules 1/1b/1c. None own `openspec/specs/sdd-install-kit/spec.md` as a primary translation target.
- Open translate PRs (owned paths): #78 kit apply; #84 avaliacoes-wave-2; #93–#98 commands-wave-1..4; #99–#103 curso aulas / scripts AGENTS; #104 `translate-specs-wave-1` (ci-gates + post-install + session-coordination) — explicitly defers install-kit to wave-2.
- Canonical guide (`doc/sistema-sdd-pedro.md`) remains deferred for mid-file G-PT; aula-05 (~503) exceeds ≤350–400 LOC; kit `templates/doc/design/` prefers post hub-design apply+archive + G-MANIFEST awareness.
- Chosen slice: `openspec/specs/sdd-install-kit/spec.md` alone (~292 LOC / 1 file) — residual deny-list hits + Portuguese requirement/scenario clusters (bootstrap HYBRID warning; dry-run COPY label; upgrade header modes; mixed MERGE sentence on upgrade tools).

## Goals / Non-Goals

**Goals:**

- Substitute all Portuguese prose in `openspec/specs/sdd-install-kit/spec.md` with glossary-canonical English **in-place** (whole-file G-PT), except freeze/allowlist runtime strings documented below.
- Preserve normative meaning: greenfield install integrity, upgrade dry-run/apply gates, MANIFEST `sha256:` / `merge:` contracts, bootstrap profile warning, ByeByeVibe vs `sdd-kit/` dual naming.
- Keep OpenSpec structure (`## Purpose`, `### Requirement:`, `#### Scenario:`, `MUST`/`WHEN`/`THEN`) and freeze-list identifiers byte-stable.
- Pass `bash scripts/verify-i18n-wave.sh --files openspec/specs/sdd-install-kit/spec.md`.

**Non-Goals:**

- Specs owned by `translate-specs-wave-1`.
- Editing `sdd-kit/upgrade.sh`, `bootstrap-sdd.sh`, or changing the `[x] Actualização aprovada` checkbox substring (separate functional i18n of runtime UX if ever desired).
- Already-English requirements inside the same file (leave EN prose intact; only normalize residual PT).
- Rewriting `openspec/changes/archive/`.
- Canonical guide, skills/commands, kit templates, hub infra, evaluations, design, course.
- Dual-file `*.en.md` / `*-pt.md`.
- Global G-DoD (`--dod`).
- Changing install/upgrade/integrity semantics — language only.

## Knowledge sources consulted (R8)

- `doc/i18n/GLOSSARY.md` — term bank + freeze/allowlist
- `doc/i18n/WAVES.md` — budgets; `openspec/specs/` in-scope for residual PT only
- `doc/i18n/WAVE-PROPOSAL-TEMPLATE.md` — proposal shape
- `doc/i18n/CURSOR-AUTOMATIONS.md` — propose-factory phase; parallel disjoint proposes
- `openspec/specs/sdd-docs-language/spec.md` — EN default, in-place waves
- AS-IS: `openspec/specs/sdd-install-kit/spec.md`
- `sdd-kit/upgrade.sh` — confirms `[x] Actualização aprovada` is a grep contract (freeze)
- `scripts/verify-i18n-wave.sh`
- Graphify / GitNexus — SKIP / docs-only (markdown spec; no code symbols)
- GitHub Issues — no open issue required (**Issue:** —)
- Prior propose: `translate-specs-wave-1` proposal (open PR #104) — deferred this path to wave-2

## Decisions

### D1: Scope = install-kit capability spec alone

| Option | Verdict |
|--------|---------|
| A — Guide W3 mid-file section | Rejected — G-PT scans whole `--files` paths |
| B — aula-05 alone (~503) | Rejected — exceeds ≤350–400 LOC |
| C — Kit `templates/doc/design/000` (~310) | Deferred — G-MANIFEST; prefer after hub design apply+archive |
| D — Kit design 002+003+004 (~385 / 3 files) | Deferred — same checksum/apply sequencing preference |
| E — `sdd-install-kit` alone (~292 / 1 file) | **Chosen** — explicitly deferred by wave-1; within budgets; residual PT; whole-file G-PT; disjoint from owned set |
| F — Active non-translate `openspec/changes/*/proposal.md` still in PT | Deferred — theme/active-changes wave; lower DoD leverage than capability specs |

**Rationale:** WAVES.md marks `openspec/specs/` as residual-PT only; wave-1 already claimed the other three residual specs; this is the named follow-up.

### D2: In-place substitution only (no dual-file)

**Chosen:** Rewrite Portuguese prose at the same path. Forbidden: `spec.en.md`, `*-pt.md`, or parallel language trees under `openspec/specs/`.

**Rationale:** Normative `sdd-docs-language` / WAVES.md — dual-file EN/PT siblings are forbidden.

### D3: Freeze runtime approval substring; translate surrounding prose

Keep byte-stable in the spec (quoted as today):

- `[x] Actualização aprovada` (and scaffold line containing that phrase) — `upgrade.sh` greps this exact substring before `--apply`
- Script/path identifiers: `sdd-kit/install.sh`, `upgrade.sh`, `verify.sh`, `gen-manifest-checksums.sh`, `scripts/bootstrap-sdd.sh`, `scripts/sdd-upgrade-diff.sh`, `MANIFEST.yaml` keys (`sha256:`, `merge: COPY`, `merge: MERGE`), profile names, ByeByeVibe, OpenSpec keywords

Translate: Portuguese requirement titles (e.g. bootstrap warning; COPY label alignment; dry-run vs apply header), mixed PT sentences inside otherwise-EN requirements, and PT scenario WHEN/THEN prose.

**Allowlist note for G-PT:** the frozen checkbox substring contains deny-list token `Actualização` / approval phrasing — document as wave allowlist exception so apply does **not** “fix” it by translating without updating `upgrade.sh`.

**Rationale:** Language wave must not break the upgrade approval gate.

### D4: Spec delta = lasting EN requirement for this slice

**Chosen:** ADDED requirement under `sdd-docs-language` that `openspec/specs/sdd-install-kit/spec.md` MUST be English after substitution (with the freeze/allowlist exception for the approval checkbox substring). Do not invent a new `sdd-install-kit-i18n` capability. Do not MODIFY normative `sdd-install-kit` requirements beyond language in this change’s delta (apply edits the living `openspec/specs/sdd-install-kit/spec.md` file in place; archive later promotes only the `sdd-docs-language` ADDED slice requirement).

**Rationale:** Same pattern as prior translate-* ADDED slice requirements.

## Risks / Trade-offs

| Risk | Mitigation |
|------|------------|
| Translating `[x] Actualização aprovada` breaks `--apply` gate | Explicit freeze + task Forbidden; G-PT allowlist note |
| Semantic drift of integrity / MERGE / dry-run contracts | Tasks require fact parity; freeze MANIFEST keys and script names |
| Parallel propose factory races | Owned-set includes open PR path lists; install-kit absent as primary on #78/#84/#93–#104 |
| G-PT fails on frozen PT checkbox | Document allowlist in proposal; if script gate still fails, prefer quoting only inside backticks/fences already present and keep surrounding prose EN — do not expand PT |

## Migration plan

1. Human approves this propose (R7) — DRAFT PR.
2. Separate `/opsx:apply translate-specs-wave-2` session after propose merge (or when artifacts are on apply base). Soft: may land independently of wave-1 apply (disjoint paths).
3. Apply substitutes `openspec/specs/sdd-install-kit/spec.md` in place; run wave gates.
4. Archive later (separate session): promote ADDED requirement into `openspec/specs/sdd-docs-language/spec.md`.
5. Follow-up candidates: aula-05 split; kit design template mirrors; guide G-PT strategy; optional later change to EN-localize `upgrade.sh` approval checkbox **with** script+scaffold together.

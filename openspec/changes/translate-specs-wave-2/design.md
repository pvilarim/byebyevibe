# Design — translate-specs-wave-2 (sdd-install-kit residual PT→EN)

## Context

- Layer-1 policy and wave budgets live under `sdd-docs-language` / `doc/i18n/*`.
- `translate-specs-wave-1` (open DRAFT PR #104) owns residual PT in `sdd-ci-gates`, `sdd-post-install-verification`, and `sdd-session-coordination`, and **defers** `openspec/specs/sdd-install-kit/spec.md` (~293 LOC) to wave-2.
- Active translate ownership on current base includes kit W2c/W2d, hub infra, skills 1–6, avaliacoes-1, design 1–2, agents-rules 1/1b/1c. Open translate PRs #78 / #84 / #93–#103 own kit apply, avaliacoes-2, commands, and curso surfaces — none list `sdd-install-kit/spec.md` as primary ownership.
- Most of `sdd-install-kit/spec.md` is already English; residual Portuguese clusters around bootstrap HYBRID warning, upgrade dry-run `COPY` labeling, upgrade header mode text, and the approval checkbox contract `[x] Actualização aprovada` (also mirrored in `sdd-kit/upgrade.sh` and guide scaffolds).
- Canonical guide and aula-05 remain deferred (mid-file / over-budget). Kit `templates/doc/design/` prefers post hub-design apply+archive.

## Goals / Non-Goals

**Goals:**

- Substitute Portuguese **prose** in `openspec/specs/sdd-install-kit/spec.md` with glossary-canonical English **in-place** (whole-file G-PT for free prose).
- Keep normative install/upgrade/verify/bootstrap meaning unchanged.
- Freeze runtime contract strings that shell scripts grep/echo today; quote them literally in the EN-normalized requirement text.
- Pass `bash scripts/verify-i18n-wave.sh --files openspec/specs/sdd-install-kit/spec.md` (with documented allowlist if G-PT still hits frozen literals).

**Non-Goals:**

- Changing `sdd-kit/upgrade.sh` or `bootstrap-sdd.sh` message strings in this wave.
- Specs wave-1 trio or other already-EN specs.
- Kit templates, guide, skills/commands, hub infra, evaluations, design, course.
- Dual-file `*.en.md` / `*-pt.md`.
- Global G-DoD (`--dod`).
- Semantic changes to integrity checks, path traversal, dry-run/apply exclusivity, or approval gate.

## Knowledge sources consulted (R8)

- `doc/i18n/GLOSSARY.md` — term bank + freeze/allowlist
- `doc/i18n/WAVES.md` — budgets; `openspec/specs/` residual-PT only
- `doc/i18n/WAVE-PROPOSAL-TEMPLATE.md` — proposal shape
- `doc/i18n/CURSOR-AUTOMATIONS.md` — propose-factory phase; parallel disjoint proposes
- `openspec/specs/sdd-docs-language/spec.md` — EN default, in-place waves
- `openspec/specs/sdd-install-kit/spec.md` — AS-IS residual PT
- `sdd-kit/upgrade.sh` / `sdd-kit/templates/scripts/bootstrap-sdd.sh` — runtime string contracts
- `scripts/verify-i18n-wave.sh`
- Graphify / GitNexus — SKIP / docs-only (markdown specs; no code symbols)
- GitHub Issues — no open issue required (**Issue:** —)

## Decisions

### D1: Scope = install-kit alone (wave-2 as deferred by wave-1)

| Option | Verdict |
|--------|---------|
| A — Guide W3 mid-file section | Rejected — G-PT scans whole `--files` paths |
| B — aula-05 alone (~503) | Rejected — exceeds ≤350–400 LOC |
| C — Kit `templates/doc/design/002|003|004` (~385) | Deferred — checksum-aware; prefer after hub design apply+archive |
| D — `sdd-install-kit/spec.md` alone (~293) | **Chosen** — named deferral from wave-1; within budget; residual PT; disjoint |
| E — Active `openspec/changes/*/research.md` theme wave | Deferred — optional WAr/active-changes track |

**Rationale:** Continues the specs residual track without overlapping PR #104 ownership; single file keeps apply review small.

### D2: In-place substitution only (no dual-file)

**Chosen:** Rewrite Portuguese prose at the same path. Forbidden: `spec.en.md`, `*-pt.md`, or parallel language trees.

**Rationale:** Normative `sdd-docs-language` / WAVES.md.

### D3: Freeze runtime contract strings; translate surrounding prose

Keep byte-stable when cited:

- `[x] Actualização aprovada` — grepped by `sdd-kit/upgrade.sh --apply`
- Bootstrap stderr: `WARN: package.json e openspec/ coexistem — perfil pode ser HYBRID.` (+ sibling confirmation lines in template)
- Identifiers: `COPY`, `APPLY_TEMPLATE`, `MERGE`, `SDD UPGRADE REPORT (dry-run)`, `SDD UPGRADE APPLY`, paths, OpenSpec keywords

Translate: requirement titles/bodies and WHEN/THEN prose that narrate these contracts in Portuguese.

**Rationale:** Language-only wave must not break live upgrade/bootstrap contracts; EN UX for those strings is a separate coordinated change.

### D4: Spec delta = lasting EN requirement for this slice

**Chosen:** ADDED requirement under `sdd-docs-language` that `sdd-install-kit/spec.md` MUST be English after substitution except documented freeze/allowlist literals. Do not invent a new capability. Do not weaken install-kit normative meaning beyond language.

**Rationale:** Same pattern as prior translate-* ADDED slice requirements.

## Risks / Trade-offs

| Risk | Mitigation |
|------|------------|
| G-PT fails on frozen `Actualização` / `coexistem` / `perfil` inside quotes | Document allowlist in proposal; if gate still fails, add wave-specific note and keep literals — do not “fix” by rewriting script contracts here |
| Semantic drift of approval / HYBRID warn / COPY label | Tasks require literal greps for contract strings + fact parity of behaviors |
| Parallel propose factory races | Owned-set includes PR #104 deferral; this path absent as primary on #78/#84/#93–#103 |
| Accidental edit to wave-1 trio | Explicit non-goal; own only install-kit path |

## Migration plan

1. Human approves this propose (R7) — DRAFT PR.
2. Separate `/opsx:apply translate-specs-wave-2` session after propose merge (or when artifacts are on apply base). Prefer wave-1 apply not required (disjoint files).
3. Apply substitutes install-kit prose in place; run wave gates; honor freeze/allowlist.
4. Archive later (separate session): promote ADDED requirement into `openspec/specs/sdd-docs-language/spec.md`.
5. Optional follow-up: coordinated EN message change for upgrade approval checkbox + bootstrap WARN (script + guide + this spec together).

## Open Questions

- None blocking propose. Whether to EN-migrate runtime strings is deferred to a future change (out of this wave).

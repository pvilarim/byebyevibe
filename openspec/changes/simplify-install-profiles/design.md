# Design: simplify-install-profiles

## Context

The APP↔HYBRID delta in `sdd-kit/MANIFEST.yaml` is exactly one entry: `scripts/verify-task-patterns.sh` (`profiles: [DOCS_SPECS, HYBRID]`). HYBRID's AGENTS.md is merged from the **APP** commands template (`install.sh` `merge_agents_profile()` maps HYBRID → `AGENTS.commands.APP.md`), so with the verifier promoted, HYBRID's payload set equals APP's byte-for-byte. The verifier itself is already profile-aware: it detects the profile by grepping `openspec/project.md`/`AGENTS.md` and softens cross-repo `Pattern:` checks (`repo:path`) from FAIL to SKIP outside DOCS_SPECS — but its detection relies on a Portuguese string (`'perfil APP'`) plus `12.2a`, and broken *local* paths FAIL in every profile. CI runs it fail-closed: `sdd-gates.yml` executes the script directly when present (exit ≠ 0 fails the job); `verify.sh` runs it opportunistically (`-x` check).

The profile-selection UX has no canonical copy: agent-driven installs improvise dialog text from the kit README's terse table ("APP commands + optional rules"), producing jargon a lay operator cannot evaluate ("optional docs/specs rules"). Operators also repeatedly assume the hub's `doc/`/`openspec/` content must be copied into their project; guide §1.6's minimal-fetch footprint already proves it never is, but nothing says so at decision time.

Origin of the DOCS_SPECS-only assignment: change `enrich-tasks-template-code-patterns` (archived 2026-06-16), decision D10 — the pilot repo was this DOCS_SPECS hub. The `sdd-task-patterns` spec meanwhile requires the `Pattern:`/`Gate:` convention in APP repos too (scenario "Code task with pattern and gate").

Sources: `sdd-kit/MANIFEST.yaml`, `sdd-kit/install.sh`, `sdd-kit/templates/scripts/verify-task-patterns.sh`, `sdd-kit/templates/.github/workflows/sdd-gates.yml` (lines 46–49), `sdd-kit/verify.sh`, `doc/byebyevibe-guide.md` §1.6, `openspec/specs/sdd-task-patterns/spec.md`, `openspec/specs/sdd-language-policy/spec.md`, `openspec/changes/archive/2026-06-16-enrich-tasks-template-code-patterns/design.md` (D10).

## Goals / Non-Goals

**Goals:**
- A first-time operator answers one plain question — "will this repository hold application code?" — and receives the complete framework either way.
- The task-pattern verifier reaches APP repos without reddening any existing consumer's CI on upgrade.
- HYBRID disappears from the decision surface while every existing `--profile HYBRID` invocation keeps working.
- The hub-content clarification ("this repo's specs are ByeByeVibe's own development history — your project never receives them") appears at profile-decision time.

**Non-Goals:**
- No fail-closed enforcement of the verifier in APP (future change, gated on field data).
- No change to the three language axes, their prompts, or their persistence (`sdd-language-policy` untouched); the profile copy only gains a sentence separating the two questions.
- No removal of the HYBRID token from MANIFEST `profiles:` lists or from historical docs/changelog entries.
- No change to what DOCS_SPECS installs.

## Decisions

### D1 — Verifier ships to all profiles; enforcement softness lives in the script, not the workflow

`sdd-kit/MANIFEST.yaml` entry for `scripts/verify-task-patterns.sh` becomes `profiles: [APP, DOCS_SPECS, HYBRID]`. Exit semantics become profile-aware **inside the script**: DOCS_SPECS keeps today's behavior (broken local path or cross-repo pattern → FAIL, exit 1); APP and UNKNOWN run **report-only** — broken local paths print as WARN, cross-repo patterns keep today's SKIP, and the script exits 0 with a summary line naming the mode (`report-only (APP profile) — enforcement is a future change`). `sdd-gates.yml` keeps executing the script directly and fail-closed; the APP softness arrives via the exit code, so the workflow needs only its SKIP-message text updated (it currently names "DOCS_SPECS/HYBRID").

*Alternatives considered:* (a) `continue-on-error` for the step in `sdd-gates.yml` — rejected: would also soften DOCS_SPECS, where the gate has been load-bearing since D10. (b) Fail-closed in APP immediately — rejected: C2 upgrades would redden CI on any APP consumer with an active `tasks.md` carrying a broken or aspirational `Pattern:` path; the spec violation is real but the operator never opted into the gate. (c) Install in C1 only, skip on C2 — rejected: creates two classes of APP repos and upgrade.sh has no mechanism for install-scenario-conditional entries.

### D2 — Profile detection: project.md marker first, structural markers second, legacy greps last

Detection order in `verify-task-patterns.sh`: (1) a profile line in `openspec/project.md` (the post-install spec already requires project.md to describe the repo profile); (2) AGENTS.md command-table markers — `12.2b` → DOCS_SPECS, `12.2a` → APP; (3) the current greps (`'DOCS_SPECS'`, `'perfil APP'`) as legacy fallback for pre-1.9.0 installs. UNKNOWN degrades to report-only (safe default: never fail a repo we cannot classify).

*Alternative considered:* a dedicated marker file (e.g. `.sdd/profile`) — rejected: new state file for one consumer; project.md already carries the fact.

### D3 — HYBRID becomes a deprecated alias, normalized at parse time

`install.sh`, `upgrade.sh`, and `bootstrap-sdd.sh` accept `--profile HYBRID`, print one deprecation line (`HYBRID is deprecated — equivalent to APP since kit 1.9.0; installing APP`), and proceed with `PROFILE=APP`. Invalid values still abort naming the allowed values. MANIFEST `profiles:` lists keep the HYBRID token (harmless — normalization means the filter never sees HYBRID) to avoid churning every entry and checksum semantics in one change. The bootstrap ambiguous-HYBRID warning and the preflight HYBRID hint are removed: after this change the coexistence of `package.json` and `openspec/` carries no signal (it is the steady state of every installed APP repo).

*Alternatives considered:* (a) hard-remove HYBRID (reject the value) — rejected: breaks existing operator scripts and the guide's own historical examples for zero gain. (b) Keep HYBRID as a real third profile with clearer copy — rejected: the payload delta is now empty; documenting a distinction that does not exist is the root cause being fixed.

### D4 — One canonical lay-copy block in guide §1.6; runtime strings en + pt-BR; agents derive dialogs from it

Guide §1.6's profile subsection is rewritten around the reframed question ("Will this repository hold application code?") with three mandatory statements: (1) every profile installs the complete framework — profiles only adjust the AGENTS.md command table and a few stack-specific rule files; (2) the hub's `doc/` and `openspec/` content is ByeByeVibe's own development history — target projects never receive it, never need it, and grow their own `openspec/` from day one; (3) the profile question is independent of the language question (three axes, `sdd-language-policy`). Kit README summarizes in ≤3 sentences + link (existing single-source rule from `clarify-install-scope-ux`). Runtime surfaces (install.sh usage/prompts, agent-driven dialogs) carry en + pt-BR strings consistent with the F7 pattern already used by banners. Agent-facing instruction: interactive installs MUST derive profile-dialog option labels from this copy rather than improvising from the table.

*Alternative considered:* auto-detect the profile (presence of `package.json`/`src/`) and skip the question entirely — deferred: detection heuristics mis-fire on monorepos and docs repos with tooling `package.json`; a clear binary question is cheaper than a wrong silent default. Revisit once the two-profile model has soaked.

### D5 — Version and integrity ripple

MANIFEST `version` 1.8.2 → **1.9.0** (contract change: new file reaches APP; profile alias). `gen-manifest-checksums.sh` regenerates sha256 for every touched template. Hub live scripts and `sdd-kit/templates/` mirrors stay in lockstep (existing `verify.sh` parity gate). Guide changelog §14 gains the 1.9.0 entry; guide header and `openspec/project.md` cross-references align.

## Risks / Trade-offs

- **Report-only WARN fatigue in APP:** operators may ignore WARNs until enforcement lands. Accepted — the alternative (immediate fail-closed) breaks upgrades; the summary line names the future enforcement so the WARN reads as a countdown, not noise.
- **HYBRID repos upgrading:** their AGENTS.md already equals APP's; detection via D2 classifies them as APP → report-only. Their previously fail-closed gate becomes report-only — a deliberate softening, called out in the changelog entry.
- **Two sources of profile truth during transition** (project.md marker vs legacy greps): mitigated by strict detection ordering and the UNKNOWN→report-only default.

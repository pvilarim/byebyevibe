# Proposal: simplify-install-profiles

**Issue:** —

## Why

The install-time profile question confuses exactly the audience ByeByeVibe targets: newcomers from vibe coding. Three options (APP / DOCS_SPECS / HYBRID) suggest the user is choosing *how much* of the framework they receive, when in fact every profile installs the complete control plane. The entire APP→HYBRID delta is one file — `scripts/verify-task-patterns.sh`, a checker that validates that `Pattern:` paths in active `tasks.md` files point to files that exist. It was assigned to DOCS_SPECS/HYBRID only because the pilot repo for the change that created it (`enrich-tasks-template-code-patterns`, D10) was a DOCS_SPECS hub — a historical accident, not a design decision. Worse, the `sdd-task-patterns` spec already *requires* the `Pattern:`/`Gate:` convention in APP repos ("Code task with pattern and gate" scenario), yet APP never receives the verifier. Promoting the verifier to all profiles makes HYBRID identical to APP, so the confusing third option can be retired and the install question becomes a binary a layperson can answer: "will this repository hold application code?" A second recurring confusion is addressed in the same copy: operators seeing the hub full of specs assume their project must receive them; the profile question must state plainly that the hub's docs/specs are ByeByeVibe's own development history and are never copied or needed.

## What Changes

- **`scripts/verify-task-patterns.sh` ships to all profiles.** The MANIFEST entry's `profiles:` gains APP. The script gains profile-aware exit semantics: fail-closed in DOCS_SPECS (unchanged), **report-only in APP and UNKNOWN** (broken local `Pattern:` paths print as WARN, exit 0) — so the fail-closed `sdd-gates.yml` step cannot redden existing APP consumers on a C2 upgrade. Promotion to fail-closed in APP is a candidate future change once field data exists.
- **Profile detection inside the verifier is hardened.** Detection order becomes: profile marker in `openspec/project.md`, then AGENTS.md command-table markers (`12.2b` → DOCS_SPECS, `12.2a` → APP), with the current Portuguese-string greps retained only as legacy fallback. UNKNOWN degrades to report-only.
- **HYBRID is retired as a deprecated alias of APP.** `install.sh`, `upgrade.sh`, and `bootstrap-sdd.sh` keep accepting `--profile HYBRID` but normalize it to APP at argument-parsing time with a one-line deprecation notice; invalid values still abort. The bootstrap "ambiguous HYBRID repo" warning and the preflight HYBRID hint are retired — `package.json` + `openspec/` coexisting is the normal post-install state of every APP repo.
- **The profile question gets canonical lay-language copy** (guide §1.6, runtime strings en + pt-BR): the question is reframed as "Will this repository hold application code?" (yes → APP; no, specs/docs only → DOCS_SPECS); the copy MUST state that every profile installs the complete framework (profiles only adjust the AGENTS.md command table and a few stack-specific rule files) and that the hub's `doc/` and `openspec/` content is ByeByeVibe's own development history — target projects never receive it, never need it, and grow their own `openspec/` state. Agent-driven interactive installs derive their dialog options from this copy instead of improvising.
- **Language policy is untouched.** The three language axes (`chat_language`, `docs_language`, `code_language`) remain a separate install step; the new profile copy must not conflate repository profile with language choice.
- **Kit integrity ripple:** template mirrors updated in lockstep (`verify-task-patterns.sh`, `bootstrap-sdd.sh`, `preflight-sdd.sh`, `sdd-gates.yml` SKIP message), checksums regenerated, MANIFEST version **1.8.2 → 1.9.0**, guide changelog §14 entry, docs tables (kit README, guide §1.6) reduced to two active profiles plus a deprecation note.

Out of scope: fail-closed enforcement of the verifier in APP (future change); any change to the language-policy axes or prompts; removing the HYBRID token from MANIFEST `profiles:` lists (kept for transition compatibility).

## Capabilities

### New Capabilities

_None — all changes modify existing install/verification capabilities._

### Modified Capabilities

- `sdd-install-kit`: MANIFEST distributes the task-pattern verifier to all profiles; `install.sh`/`upgrade.sh`/`bootstrap-sdd.sh` normalize HYBRID to APP with a deprecation notice; the ambiguous-HYBRID bootstrap warning is removed; guide §1.6 presents two active profiles with canonical lay-language decision copy including the full-framework statement and the hub-content clarification.
- `sdd-install-narrative`: new requirement — the profile choice is presented in lay language (en + pt-BR), states that every profile installs the complete framework and that hub docs/specs are never copied, and stays separate from the language-axes prompt; interactive agent-driven installs derive dialog options from this canonical copy.
- `sdd-post-install-verification`: `scripts/verify-task-patterns.sh` is present after install in **all** profiles; exit semantics are profile-aware (fail-closed DOCS_SPECS, report-only APP/UNKNOWN).
- `sdd-install-preflight`: the repo-gate profile hint no longer suggests HYBRID; profile hints stay advisory.

## Impact

- **Kit contract:** `sdd-kit/MANIFEST.yaml` (profiles list + version 1.9.0 + regenerated sha256), `sdd-kit/install.sh`, `sdd-kit/upgrade.sh`.
- **Scripts (hub + template mirrors in lockstep):** `scripts/verify-task-patterns.sh`, `scripts/bootstrap-sdd.sh`, `scripts/preflight-sdd.sh`, `.github/workflows/sdd-gates.yml` and their `sdd-kit/templates/` copies.
- **Docs:** `doc/byebyevibe-guide.md` (§1.6 profile block, changelog §14), `sdd-kit/README.md` (profiles table, scenarios mentions).
- **Consumers:** C2 upgrade delivers the verifier to APP repos in report-only mode — no CI reddening; HYBRID installs keep working via the alias. No new dependencies; no workflow topology changes.
- **Language policy (F7):** versioned prose in English; runtime profile-copy strings carry en + pt-BR as today.

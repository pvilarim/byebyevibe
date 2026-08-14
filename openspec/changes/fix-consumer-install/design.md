# Design — fix-consumer-install

## Context

Three explore sessions (read them; this document does not repeat their evidence):

- [`explore-consumer-install-defects/research.md`](../explore-consumer-install-defects/research.md) — 7 defects from real execution; §12 is the adversarial verdict fixing defect 6's scope; §13 is the state of the operator's repo.
- [`explore-agent-mediated-install/research.md`](../explore-agent-mediated-install/research.md) — D1–D7 decisions. **1.16.0 scope; here only as forward-compatibility context.**
- [`explore-python-onboarding-ux/research.md`](../explore-python-onboarding-ux/research.md) — macOS portability; §17 is a real-Mac report (bash 3.2.57, BSD realpath, no flock, no unsuffixed python; `sha256sum` exists at `/sbin` — §4.1 retracted).

Root cause common to everything: the hub validates itself. Baseline: master @ 2b73ccf, v1.14.0 published, kit MANIFEST has 45 entries.

Constraints:

- **No macOS machine.** No gate may depend on executing on a Mac. Portability fixes are by construction: pick forms that are correct on both toolchains instead of probing (temp-file+`mv` instead of `sed -i`; temp file instead of process substitution; manual hash comparison instead of `-c`).
- **Portable gates.** No gawk-only `BINMODE`, no non-portable `sed -i`, no `realpath -m` inside gates. A gate that only passes on Linux lies.
- **Fail-loud lesson (1.14.0):** a step that does not run must fail, never report success. Six known instances of this family → transversal requirement (`sdd-fail-loud`), not six point fixes.
- **Installed base:** 4 installations (3 pre-1.14.0; 1 on 1.14.0 with incomplete payload — consumer-defects §13). They need **repair**, not upgrade; the repair procedure is manual, outside this apply.
- **Order inside apply:** hub-marker detection (D1 below) must land before the smoke test, or the smoke test fails for the wrong reason (defect 4 fires first).

## Goals / Non-Goals

**Goals:**

1. A clean APP-profile consumer install completes with full payload, green `verify.sh`, green `openspec validate --all --strict`, and a materialized language policy — proven by a blocking CI smoke test.
2. macOS portability by construction for every site the real-Mac report flagged.
3. Every "cannot run" state fails loudly (transversal `sdd-fail-loud`).

**Non-Goals:**

- D1/D2 (single acquisition path, kill hub-mode), D3/D4 (profile/language confirmation UX), D5/D6 (hub README/AGENTS.md labeling, tarball INSTALL.md), D7 (reinstall comparison) — 1.16.0.
- Issues #364 (Python-free install) and #363.
- Cutting the 1.15.0 release (manual, post-merge) and repairing the 4 existing installations (manual procedure, post-merge).
- Making `gitnexus`/`graphify` behave on repos without an initial commit (N6) — recorded, not fixed here.

## Decisions

### D1 — Hub marker: `.sdd-hub` file at the hub repo root

**Chosen:** `verify.sh` (and any other hub/consumer branch) tests `[[ -f "$REPO_ROOT/.sdd-hub" ]]`. The file is committed in the hub only, one line of content explaining itself. It is **not** a MANIFEST entry and **not** inside `sdd-kit/`, so it can never reach a consumer: the release tarball carries only `sdd-kit/` + `scripts/bootstrap-sdd.sh` + `scripts/preflight-sdd.sh` (release-recipe scenario in `sdd-install-kit`), and the MANIFEST never lists it.

**Alternatives rejected:**
- *Keep directory heuristic, invert it* — any directory-shaped heuristic breaks again under 1.16.0 D2 (kit whole in every consumer → `templates/` exists in 100% of installs).
- *Marker inside `sdd-kit/` or MANIFEST field* — travels with the kit; consumer with copied kit becomes "hub".
- *Detect by `scripts/cut-release.sh` presence* — another heuristic; same disease.

The hub-identity-by-directory sites are exactly four (adversarial pass, 2026-08-13): `sdd-kit/verify.sh:64` (workflow-template demand) and `:125` (language grandfathering skip), plus `scripts/verify-release-readiness.sh:95` (kit-integrity parity) and `:198` (live-scripts↔templates parity) — the parity blocks were extracted from verify.sh by issue #348 and live in readiness now; verify.sh only orchestrates it. All four move to the marker (+ the readiness template mirror). Consumers with a full copied kit therefore get: no parity noise **and** a real language check. Presence-fallback checks that are not identity tests (verify.sh:82/:93, bootstrap resolution, install.sh:216) stay as they are.

Additionally, the language check in verify.sh becomes **blocking on consumers**: the current `WARN … missing Language policy section` (verify.sh:131) and the absent-file silent skip both become FAIL when the marker is absent — otherwise defect 5's fix would still report a broken install as green (per `sdd-fail-loud`).

### D2 — install.sh derives kit root itself; bootstrap failure becomes fatal

`install.sh` already knows the kit location: `KIT_DIR` (line 6). When `$REPO_ROOT/sdd-kit` is absent, it passes `--kit-root "$(dirname "$KIT_DIR")"` to its own preflight invocation (line 228). No new public flag on `install.sh`; no change to bootstrap's resolution. The spec's "e.g. `bootstrap-sdd.sh`" example becomes "every caller provides or derives a source kit root".

`bootstrap-sdd.sh:309-311`: the `|| WARN` around `install.sh` becomes `exit 1` with an error naming what did not happen ("payload not installed"). Rationale over the counter-argument (GitNexus/Graphify stay non-fatal): those are optional integrations; the kit payload is the reason the command exists.

### D3 — Delete the three self-copying MANIFEST entries

Remove `sdd-kit/install-ui-module.sh`, `sdd-kit/install-probity-module.sh`, `sdd-kit/templates/probity.config.ts` from the MANIFEST (entries at :202-207, :246-251, :253-258). They exist only to compensate hub-mode not delivering the kit; on the canonical tarball path the consumer already has the whole `sdd-kit/`, making entry 40 a src==dest `cp` that kills the install. Deleting them fixes defect 2 at the origin (no src==dest guard needed) and removes the only thing that created `sdd-kit/templates/` in hub-mode consumers.

Consequences accepted and specced: a hub-mode consumer (no local kit until 1.16.0 D2) runs module installers from the source kit — the teaser copy must not assert a local path exists (D8). `sdd-ui-module` / `sdd-probity-module` deltas rewrite the MANIFEST-listing requirements: the kit *ships* the module scripts and config template inside `sdd-kit/` (tarball), it no longer *installs copies of them* via MANIFEST. (`templates/probity.config.ts` stays load-bearing regardless: `install-probity-module.sh:126` reads it directly from the kit.)

Orphan-coverage consequence (adversarial pass): with their MANIFEST entries gone, `templates/install-ui-module.sh` and `templates/install-probity-module.sh` lose sha256 coverage (checksum tooling iterates MANIFEST `source:` fields) and hub parity covers only `templates/scripts/` — drift between `sdd-kit/install-*.sh` and their templates would become undetectable. The readiness hub-parity check is therefore extended to those two live↔template pairs.

### D4 — `project.md` template shipped, WARN→FAIL, verify checks consumers

New template `sdd-kit/templates/openspec/project.md`, MANIFEST entry `merge: MERGE` (copy when absent, keep operator's file). Content: minimal constitution skeleton (Purpose, Stack, Conventions, Constraints, plus a Cross-references section pointing at the guide and the kit — the live `sdd-post-install-verification` constitution requirement demands it) with `[FILL]` placeholders **and the full `## Language policy` block — heading included — around the anchor markers**: the injection's marker branch replaces only *between* the markers and never emits the heading, so bare markers would leave the smoke test's `## Language policy` assertion unsatisfiable. Constraint: the template MUST NOT contain the literal string `DOCS_SPECS` anywhere — `verify-task-patterns.sh` sniffs `project.md` first for profile detection and would flip every consumer into fail-closed DOCS_SPECS mode. `install.sh:104-107`: missing `project.md` after the copy loop becomes FAIL (it can now only mean the MANIFEST entry itself failed). `verify.sh` language check runs on consumers (D1) and FAILs (not WARN) when the block is missing — the two independent safety nets that both failed silently now both bite.

Ordering note: the MANIFEST copy loop runs before `inject_language_policy` (install.sh:436), so the template lands before injection — no sequencing change needed.

### D5 — `_template` ships a valid placeholder delta; the smoke test validates what the kit distributes

New template `sdd-kit/templates/openspec/changes/_template/specs/example-capability/spec.md` with one normative `## ADDED Requirements` block + one scenario (mirroring the operator's proven workaround). MANIFEST entry (COPY, all profiles). The hub does **not** grow its own `openspec/changes/_template/` — hub `openspec list` stays clean; instead the consumer smoke test (D7) runs `openspec validate --all --strict` in the temp repo, which validates the distributed `_template` on every PR. One mechanism proves items 3 and 5.

### D6 — Deliver the guide (defect 6 — decided scope, do not relitigate)

Per the adversarial verdict (consumer-defects §12): mirror `doc/byebyevibe-guide.md` → `sdd-kit/templates/doc/byebyevibe-guide.md`; one COPY MANIFEST entry → `doc/byebyevibe-guide.md` (exact pattern of `sdd-operator-day1.md`); hub↔template parity for the guide in `verify-release-readiness.sh`; delta to the two "never receives it, never needs it" sentences (`sdd-install-narrative` profile-copy requirement, `sdd-install-kit` §1.6 requirement). The delta text says explicitly: this **reverts the 2026-08-05 decision** (`simplify-install-profiles`) and **restores the 2026-06-17 founding design** (guide copied to consumers) — so it reads as a decision, not an accident. The statement becomes: the hub's `openspec/` specs and development history are never copied; the **operator guide is** — a guide file is not the hub's development history, so the 2026-08-05 rationale (operators confused by hub specs) is not violated.

Side effect to confirm at apply (task-gated): `verify-release-readiness.sh:33-35` stops degrading to "INFO: absent" in consumers — version-claim checks start running there. Expected gain (guide version claims now checked where the guide actually lives); the smoke test will catch it if it turns into noise (verify.sh exit 0 assertion).

Checksum discipline: the guide mirror is by far the largest template (175 KB); `gen-manifest-checksums.sh` regeneration is a required task step, and release-readiness parity catches drift.

### D7 — Consumer install smoke test: two variations, one blocking job step

New blocking step(s) in `sdd-gates.yml` (hub workflow; template mirror updated in the same change):

**Variation A — canonical consumer (catches defects 2, 3, 4, 5, 7):** temp repo under `runner.temp` (outside the checkout), `git init` + one initial commit, kit copied in (`cp -R sdd-kit "$T/"` — the tarball layout), then `bash sdd-kit/install.sh --profile APP --chat-lang en --docs-lang en --code-lang en`, then assert:
1. **Every APP-profile MANIFEST entry applied** — parse the MANIFEST (same Python the runner has) and `test -e` each `path:`; never a hardcoded count, which goes stale. "45/45" is the intent; the number is derived.
2. `bash sdd-kit/verify.sh` **exit 0**.
3. `openspec validate --all --strict` **exit 0** (CLI already pinned in the workflow).
4. `openspec/project.md` present **with** the language-policy block (`grep` both markers and `## Language policy`).

**Variation B — hub-mode (catches defect 1):** second temp repo, **no kit copied**; run `bash <checkout>/sdd-kit/install.sh --repo "$T2" --profile APP --chat-lang en ...` from the hub checkout. Assert entries applied + project.md with policy block (skip verify.sh — hub-mode consumers have no local kit until 1.16.0).

**What "verify.sh exit 0" actually measures (corrected by the adversarial pass):** `verify-infra.sh` is **advisory by design** — without a TTY or `--write` it exits 0 regardless of its internal FAILs (verify-infra.sh:226-237), so verify.sh's exit code never depends on gitnexus/graphify. The knowledge CLIs are therefore **not provisioned** in the smoke job: installing them (npm/onnxruntime, uv, grammar builds — the job's whole flake surface) would buy zero gate strength. What the exit 0 assertion genuinely covers: readiness, task-patterns, kit presence checks, the workflow-template check (defect 4 fires exactly here pre-fix), and — after this change makes it blocking — the consumer language-policy check (defect 5). The temp repo still gets an initial commit (cheap, mirrors a real adopting project). This narrowing must be stated in a workflow comment so nobody later "fixes" the job by adding CLI installs for no gain. Never fabricate a green by pre-seeding fake artifacts.

**Spec coexistence:** the live `sdd-ci-gates` requirement "verify-infra.sh runs report-only in CI" mandates the hub's `sdd-kit verify` step be non-blocking; the smoke test's blocking `verify.sh` assertion needs that requirement's scope narrowed to the hub-checkout step, exempting the consumer smoke test — delta added.

The existing DOCS_SPECS greenfield step stays: it covers the empty-target/parent-dir class; the new step covers the consumer class.

### D8 — Optional add-ons teaser: §9.2 copy, remote detection, no dead paths

Replace both language blocks of `print_optional_addons_teaser` with the consumer-defects §9.2 copy ("If you need X, install Y, and get Z / Skip if…" — pt-BR text is ready; write the en equivalent in the same shape). Structural changes:
- **CI gates is not a module:** the message checks `git remote -v` (guarded — `2>/dev/null || true`: install.sh runs under `set -euo pipefail` and `git remote` exits 128 in a non-git target); when empty it says the gates are inert until the repo has a GitHub remote and branch protection is enabled (manual step) — instead of listing "CI gates" as an installable.
- **No dead paths:** module commands are printed relative to the kit that ran the install (`$KIT_DIR`), which exists on both paths; guide pointers are now real because of D6.

The full "where content lives" question from research §9 (option b+c: doc file + `--explain`) is **not** taken here — only the teaser copy and the remote detection. Reason: §9.2's text is decided; the doc/`--explain` split is additive UX that belongs with 1.16.0's INSTALL.md work.

### D9 — AGENTS.md survives the tool phases without reordering

C1 order is `MUST NOT change` (bootstrap:3). Fix at the merge, not the order: `bootstrap-sdd.sh` records whether `AGENTS.md` existed — **at bootstrap start**, before any phase runs (a new snapshot variable; the adversarial pass confirmed no pre-init snapshot exists today, and snapshotting at start is version-proof against `openspec init` behavior drift, N8) — and exports `SDD_AGENTS_PREEXISTED=0|1` to `install.sh`. `merge_agents_profile`: when the file exists but `SDD_AGENTS_PREEXISTED=0`, the content is tool-generated — write the kit AGENTS.md and move the tool-injected content to **`AGENTS.tools-generated.md`** (the gitignored routing file the live `sdd-post-install-verification` spec already mandates for tool output; appending the GitNexus block to AGENTS.md would violate that spec's "MUST NOT contain `gitnexus:start`" requirement and its 150-line cap). When the variable is unset (install.sh run standalone), current KEEP behavior stands — standalone runs have no snapshot and must not guess.

**Alternatives rejected:** teaching the merge to recognize GitNexus block markers — couples the kit to another tool's output format; the snapshot is authoritative and format-blind. Appending the tool block to AGENTS.md — head-on contradiction with `sdd-post-install-verification` "AGENTS entry point is lean" (adversarial finding B1).

### D10 — `openspec init` failure is loud and fatal

`bootstrap:246` loses `2>/dev/null`; the fallback retry stays but a failure of **both** invocations aborts the bootstrap with an error naming the step and the captured diagnostics. Precision (adversarial pass): under `set -e` a double failure already aborts today — the actual defects are narrower: attempt 1's stderr is discarded (the likelier failure is invisible), and the abort is anonymous (no line naming `openspec init` as the culprit). The fix surfaces both. (OpenSpec version drift — consumer on 1.8.0 vs `min_openspec` 1.3.1 — is recorded as an open question, not gated here.)

### D11 — Portability by construction (no probes, no Mac-dependent gates)

- **9a `sed -i` (8 call sites in 7 files):** rewrite as `sed '...' file > tmp && mv tmp file` (temp file via `mktemp`). No BSD/GNU probe — the portable form is correct on both. Sites: `scripts/preflight-sdd.sh:385`, `scripts/verify-infra.sh:55,:240`, `sdd-kit/install-ui-module.sh:139`, + template mirrors.
- **9b heredoc-in-process-substitution (5 sites):** reported failing on bash 3.2. Rewrite: Python writes its TSV to a `mktemp` file (heredoc feeding a plain command — safe), the invocation's exit code is checked explicitly, then `while read … done < "$tmpfile"`. This removes the bash-3.2 risk **and** fixes the known exit-code non-propagation of process substitution in one move. Sites: `sdd-kit/install.sh:400`, `sdd-kit/upgrade.sh:141,:270`, `scripts/sdd-upgrade-diff.sh:38` + its template mirror. `| tr -d '\r'` moves onto the generation pipeline (still metadata-stream-only, per the existing boundary requirement).
- **9c guide §1.6 recipe:** replace `sha256sum -c` with manual comparison — read expected hash from the sidecar, compute actual with `sha256sum || shasum -a 256`, string-compare, fail loudly on mismatch. Works with either tool; no reliance on `-c` support of `/sbin/sha256sum` on macOS (unverified).
- **9d interpreter cascade:** candidate order becomes `python3`, `python3.14`, `python3.13`, `python`, `py -3`, `/usr/bin/python3`. Version-suffixed rungs give macOS real alternatives (today it is single-rung there); `/usr/bin/python3` last because it may be the CLT shim — the resolver already probes by execution, so a shim is rejected, but probing it can be slow/GUI-triggering, hence last. Candidates remain literal command strings (word-splitting convention unchanged).
- **9e `flock`:** `sdd-session-lib.sh` detects `command -v flock` once; when absent it prints one line — advisory lock unavailable on this platform, PID-file check only (best effort) — and skips the flock subshell instead of letting it fail invisibly. The PID-file mechanism (which works everywhere) is unchanged and remains the guaranteed layer.
- **9f hardcoded `python3` outside any cascade (adversarial finding M4):** eight call sites invoke the literal name `python3` with no resolution — `scripts/sdd-session-lib.sh:31,:46,:64,:82`, `scripts/sdd-session-heartbeat.sh:24`, `sdd-kit/install-ui-module.sh:141,:171`, `sdd-kit/install-probity-module.sh:193` — plus template mirrors. These violate the already-live "resolve a Python interpreter by capability" requirement (no spec change needed) and fail on Windows consumers where `python3` typically does not exist; session-lib runs on every session registration. They gain the standard resolution (honour `SDD_PYTHON` from the environment, else the candidate cascade).
- **Recorded, not fixed:** `sdd-kit/upgrade.sh:245` uses `realpath --no-symlinks` with no macOS fallback — same family, but the upgrade path is declared broken and out of scope for 1.15.0 (repair procedure bypasses it); left for the 1.16.0 upgrade work.

### D12 — `sdd-fail-loud` as a capability, not point patches

New spec `sdd-fail-loud` with one transversal requirement: any install/verify/bootstrap step that cannot execute its check or action MUST either fail the run or emit an explicit "did not run, because X" statement — reporting success or silence is forbidden. Scenarios enumerate the known instances as acceptance anchors — now **seven**: bootstrap WARN, `openspec init` silence, `flock` silent no-op, `verify.sh` project.md skip, vacuous readiness, zero-file install, and the one this pass itself surfaced: `verify-infra.sh` FAILs consumers on `.sdd/runtime` missing from `.gitignore`, yet nothing in the install ever writes that entry — a check guaranteed to fail everywhere, masked by verify-infra's advisory exit 0. The fix (installer idempotently ensures the `.gitignore` entry) ships in this change. Point fixes each cite the capability; future gates inherit it. The alternative (scattered requirement patches) leaves the *next* instance ungoverned — the pattern recurred five times in two days precisely because no rule named it, and the adversarial pass finding a seventh while reviewing the fix for the first six is the argument made flesh.

## Risks / Trade-offs

- [Smoke test's `verify.sh exit 0` proves less than "everything green" — verify-infra is advisory by design] → accepted and documented in a workflow comment; the assertions that carry the gate are the per-entry enumeration, strict validation, the policy block, and verify.sh's own blocking checks (workflow template, language policy, readiness). No knowledge CLIs in the job: zero flake surface bought with zero gate strength lost.
- [Guide mirror (175 KB) doubles guide maintenance] → release-readiness parity check FAILs on drift; `cut-release.sh` flow unchanged (mirror lives inside `sdd-kit/`, footprint invariant intact).
- [WARN→FAIL and skip→FAIL changes can redden existing consumers' local verify] → intended: those states were real defects reported green. The repair procedure (manual, post-merge) brings the 4 installs to a state that passes.
- [Deleting the three MANIFEST entries removes module scripts from hub-mode consumers] → accepted until 1.16.0 D2 (kit whole in destination); teaser copy avoids asserting local paths (D8); canonical tarball path unaffected (kit already whole).
- [`/usr/bin/python3` rung may trigger the Xcode CLT GUI prompt on a bare Mac] → placed last in the cascade; only reached when every other rung failed, where today the install dies anyway. Open question below.
- [Reverting a 3-day-old normative decision (guide non-distribution)] → the delta names both prior decisions explicitly; adversarial pass pre-apply re-checks it.
- [Bash-3.2 fixes are by-construction, unverified on a real Mac] → the constructs chosen (temp file + mv, plain heredoc, manual hash compare) are POSIX-portable by definition, not probed; the real-Mac operator can re-run the §14 diagnostic after 1.15.0 as confirmation, but no gate depends on it.

## Migration Plan

1. Apply order inside this change: hub marker (D1) → installer/bootstrap fixes (D2–D4, D9, D10) → templates + MANIFEST (D3–D6) → portability (D11) → teaser (D8) → checksums regen → smoke test (D7) last, so it lands against already-fixed code.
2. After merge (manual, outside apply): cut 1.15.0; write and run the repair procedure for the 4 existing installations (re-acquire footprint + overwrite — per python-onboarding §11, bypassing `upgrade.sh`).
3. Rollback: revert the PR; no data migration exists. Consumers who installed 1.15.0 keep a working payload (fixes are strictly additive to what 1.14.0 promised).

## Open Questions

- Does `/sbin/sha256sum` on macOS 26 support `-c`? (§17.1 left it open — moot for the recipe after 9c, recorded for completeness.)
- Guide §2.8's "optional add-ons at a glance" block still frames CI gates as one of four add-ons while the new teaser calls it a manual step — messaging divergence between surfaces, no spec violation; align the glance wording opportunistically when the guide is next edited.
- Does probing `/usr/bin/python3` on a CLT-less Mac trigger the GUI prompt during the cascade? (Untestable from Windows; rung placed last to minimize exposure.)
- OpenSpec 1.8.0 vs `min_openspec` 1.3.1 — five minors of untested drift (N8). Not gated here; candidate for a dedicated compatibility check in 1.16.0.
- ~~Adversarial pass (mandatory, post-propose / pre-apply)~~ — **executed 2026-08-13**, three clean-context agents (gates / deltas-vs-specs / design-vs-code). Findings: 2 spec-contradiction blockers, 11 defective gates of 26, 1 task on the wrong file, D7's verify-infra premise false, a 7th fail-loud instance, 8 unlisted hardcoded `python3` sites. All corrections folded into this document, the deltas, and tasks.md in the same revision that carries this line.

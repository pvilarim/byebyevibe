# Proposal — fix-consumer-install

**Issue:** — (driven by three explore sessions: `explore-consumer-install-defects`, `explore-agent-mediated-install`, `explore-python-onboarding-ux`)
**Target:** kit **1.15.0** (release cut is manual, after merge)

## Why

v1.14.0 cannot be installed correctly in APP profile by any documented path. The first real consumer install (Windows/Git Bash, scenario C1, `c:\apps\immersivehomes`) surfaced **seven defects in ~40 minutes**; a real macOS report added portability defects on top. Zero of these appeared in 369 hub PRs, because they share one root cause: **the hub validates itself**. CI runs `validate`/`verify`/`readiness` always against the hub — with `sdd-kit/` complete, `templates/` present, no `_template/`, `project.md` hand-written. Each of those conditions is the inverse of what a consumer repository has. This change makes the consumer install work and adds the CI gate that proves it stays working.

## What Changes

Ordered — item 1 is a prerequisite for the smoke test (item 10) not to fail for the wrong reason.

1. **Hub detection by explicit marker** (defects 4, 5). `sdd-kit/verify.sh:64` and `:125` use "does `sdd-kit/templates/` exist?" as the hub heuristic. In APP profile that is always true in consumers: `:64` demands a workflow template the MANIFEST never installs (blocking FAIL), `:125` silently skips the language-policy check. Replace with an explicit repo-root marker.
2. **Hub-mode `--kit-root` asymmetry** (defect 1, blocking, silent). `bootstrap-sdd.sh:104-107` resolves `--kit-root` for *its* preflight; `install.sh:228` runs its own preflight without it → FAIL `sdd-kit/ missing` → install exits 1 → `bootstrap:309-311` downgrades to WARN and **exits 0**. Fix: `install.sh` derives the kit root from `KIT_DIR` itself (no new flag); the bootstrap WARN becomes **FATAL**. The `sdd-install-preflight` spec's "e.g. `bootstrap-sdd.sh`" example becomes "every caller".
3. **`cp: same file`** (defect 2, blocking, APP only). `MANIFEST.yaml:253-258` copies `sdd-kit/templates/probity.config.ts` with destination inside the repo and source inside the kit; with `KIT_DIR == REPO_ROOT/sdd-kit` the copy is src==dest and kills the loop at entry 40/45 under `set -euo pipefail`, losing 5 entries **and** `inject_language_policy`. Fix (forward-compatible with 1.16.0 D2): **delete the three MANIFEST entries** that copy into `sdd-kit/` (`install-ui-module.sh`, `install-probity-module.sh`, `templates/probity.config.ts`) — they exist only to compensate hub-mode.
4. **`project.md` never materializes** (defect 7, gravest). No template exists and non-interactive `openspec init` does not generate it; `install.sh:104` WARNs and returns 0; `verify.sh:125` skips (defect 5). The whole `sdd-language-policy` capability is vacuum in every 1.14.0 APP install. Fix: ship a `project.md` template via MANIFEST (MERGE), the installer WARN becomes FAIL, and verify checks language policy on consumers.
5. **`_template` fails the gate** (defect 3). `MANIFEST.yaml:195-200` installs `_template/proposal.md` without `specs/` → `openspec validate --all --strict` rejects it → red CI on the consumer's first push. The hub is green only because `_template/` does not exist in the hub. Fix: ship `_template` with a normative placeholder delta, and the consumer smoke test (item 10) validates what the kit distributes.
6. **Guide not delivered, 78 dangling references** (defect 6 — scope fixed by the adversarial verdict in consumer-defects research §12). Fix decided: **deliver the guide**. Mirror at `sdd-kit/templates/doc/byebyevibe-guide.md` (inside the tarball without changing the footprint — `sdd-release-flow` invariant intact), one COPY MANIFEST entry → `doc/byebyevibe-guide.md`, hub↔template parity in `verify-release-readiness.sh`, and deltas to the two "never receives it, never needs it" sentences (`sdd-install-narrative:122`, `sdd-install-kit:~133`). The delta states explicitly that this **reverts the 2026-08-05 decision** and **restores the founding design intent of 2026-06-17**.
7. **AGENTS.md destroyed by execution order** (defect 8, confirmed on 2 machines). The C1 order is `MUST NOT change`; `gitnexus analyze` injects its block into `AGENTS.md` before `install.sh`, whose merge sees an existing file and KEEPs it — the kit's AGENTS.md is never written. Fix without reordering: bootstrap snapshots AGENTS.md existence before the tool phases and the installer treats a file that did not pre-exist as tool-generated (write kit content, preserve the injected block).
8. **`openspec init` fails silently.** `bootstrap:246` hides stderr behind `2>/dev/null || retry`. Surface the failure and treat it as fatal (OpenSpec is the pillar the bootstrap exists to install).
9. **macOS portability by construction** (no Mac available; confirmed by the real-Mac report, python-onboarding §17): (a) 6 `sed -i` sites → temp file + `mv`; (b) 5 heredoc-inside-process-substitution sites → Python output to temp file (also fixes exit-code non-propagation); (c) guide §1.6 checksum verification without `-c` (manual hash comparison, works with `sha256sum` or `shasum`); (d) interpreter cascade gains real macOS rungs (`python3.14`, `python3.13`, `/usr/bin/python3`); (e) `flock` absence declared best-effort explicitly — never pretend.
10. **The gate that proves everything** — consumer install smoke test in `sdd-gates.yml`: temp repo outside the checkout, end-to-end APP-profile install, asserting every APP MANIFEST entry applied (not just exit 0), `sdd-kit/verify.sh` exit 0, `openspec validate --all --strict` exit 0, and `openspec/project.md` present with the language-policy block. Catches defects 1, 2, 3, 4, 5, 7 on its own. Includes a hub-mode variation for defect 1.
11. **Optional add-ons message** rewritten in the "If you need X, install Y, and get Z / Skip if…" formula (ready copy in consumer-defects §9.2). "CI gates" stops being listed as a module: it is a manual GitHub step, and the message detects an empty `git remote -v` and says so.

Cross-cutting: the recurring failure family — *a step that cannot run reports success* (6 known instances: empty install pre-1.14.0, vacuous readiness, `flock`, `openspec init`, `verify.sh` without `project.md`, bootstrap WARN) — becomes a **transversal requirement** in a new capability instead of six point fixes.

## Capabilities

### New Capabilities

- `sdd-fail-loud`: a step that cannot run MUST fail or state so explicitly — never report success. Normative home for the vacuous-pass family; existing and future gates inherit it.

### Modified Capabilities

- `sdd-install-preflight`: repo gate — kit-root resolution becomes the obligation of **every caller** (install.sh derives it from `KIT_DIR`), not an example scoped to `bootstrap-sdd.sh`.
- `sdd-install-kit`: hub context defined by explicit marker (both parity requirements); `install.sh` language-policy WARN→FAIL + `project.md` template shipped; `_template` ships a valid placeholder delta; guide delivered to consumers (reverts "never receives it" — §1.6 requirement); optional add-ons teaser formula + remote detection; bootstrap treats kit-install failure and `openspec init` failure as fatal; AGENTS.md merge survives tool-injected pre-existing files; interpreter cascade gains macOS rungs; Python-to-shell boundary uses temp files (bash 3.2 compatible); release recipe checksum step is portable.
- `sdd-install-narrative`: profile-copy statement (2) updated (guide now delivered); teaser copy in lay formula with skip conditions.
- `sdd-language-policy`: hub grandfathering keyed to the explicit marker; policy materializes in every install via shipped `project.md` template.
- `sdd-ci-gates`: new blocking consumer-install smoke test (APP profile, temp repo, four assertions + hub-mode variation).
- `sdd-ui-module`: MANIFEST no longer copies `install-ui-module.sh` into consumer `sdd-kit/` (module runs from the acquired kit).
- `sdd-probity-module`: MANIFEST no longer copies `install-probity-module.sh` / `templates/probity.config.ts` into consumer `sdd-kit/`.
- `sdd-session-coordination`: apply lock declared two-mechanism; `flock` layer stated best-effort where the binary is absent.

## Impact

- **Scripts:** `sdd-kit/install.sh`, `sdd-kit/verify.sh`, `sdd-kit/upgrade.sh`, `sdd-kit/MANIFEST.yaml`, `scripts/bootstrap-sdd.sh`, `scripts/preflight-sdd.sh`, `scripts/verify-infra.sh`, `scripts/sdd-upgrade-diff.sh`, `scripts/verify-release-readiness.sh`, `scripts/sdd-session-lib.sh` + all `sdd-kit/templates/scripts/` mirrors.
- **Templates (new):** `sdd-kit/templates/openspec/project.md`, `sdd-kit/templates/openspec/changes/_template/specs/example-capability/spec.md`, `sdd-kit/templates/doc/byebyevibe-guide.md` (mirror).
- **CI:** `.github/workflows/sdd-gates.yml` (+ template mirror) — new blocking job/steps.
- **Docs:** `doc/byebyevibe-guide.md` §1.6 recipe (portable checksum), hub-marker documentation.
- **Checksums:** `sdd-kit/gen-manifest-checksums.sh` regeneration after template edits.
- **Out of scope (1.16.0):** D1/D2 single acquisition path, D3/D4 confirmation UX, D5/D6 README/AGENTS.md hub labeling + INSTALL.md, D7 reinstall comparison; issues #364 and #363.
- **Manual, outside apply:** cut 1.15.0 after merge; repair procedure for the 4 existing installations (they need repair, not upgrade — the upgrade tool itself is broken).

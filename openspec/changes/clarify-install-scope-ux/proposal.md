# Proposal: clarify-install-scope-ux

**Issue:** —

## Why

Operators installing ByeByeVibe in a second project consistently hit the same question: "do I have to reinstall everything per project?" No canonical file answers it. The install model is sound — machine-level CLIs install once; each project receives a small payload copy plus its own generated state — but the docs never say so, the bootstrap banners don't say so, and `bootstrap-sdd.sh` reinstalls global CLIs unconditionally on every run, contradicting any "install once" message. For a user-friendly tool, the hub→destination flow ("one command from the hub clone installs into any target folder") must be explicit at first contact, at install time, and retrievable later via `/opsx:help`.

## What Changes

- **Guide §1.6 gains a canonical install-scope table** (machine-once / repo-copied / repo-generated) plus a short "hub → destination" flow statement: keep one hub clone per machine; install into any project with `bash <hub>/scripts/bootstrap-sdd.sh <target-repo> --profile <PROFILE>`. Other surfaces must not duplicate the table (a ≤3-sentence summary plus link is allowed).
- **`bootstrap-sdd.sh` gains hub-mode resolution** so the documented command actually works greenfield: today the script resolves `preflight-sdd.sh` and `sdd-kit/install.sh` from the *target* repo, so a fresh target aborts at phase 0 or installs no payload. When the target lacks them, bootstrap MUST fall back to its own source repo (the hub clone it runs from), and the preflight repo gate MUST accept hub-resolved kit presence (delta to `sdd-install-preflight`).
- **`bootstrap-sdd.sh` becomes idempotent for machine-level package installs**: guard only the package-manager commands (`npm install -g`, uv installer, `uv tool install`) behind `command -v`; print an always-visible "already installed — skipping" notice; WARN when the detected OpenSpec version is older than MANIFEST `min_openspec` (pointing to C2b). All idempotent per-repo/config steps (`openspec init`, `gitnexus setup`, `gitnexus analyze`, `graphify install`, `graphify hook install`, `graphify update .`) keep running unconditionally.
- **S-layer banners gain a `Scope:` line** (en + pt-BR): machine-once for OpenSpec/GitNexus/Graphify; "copied into this repo — each project gets its own" for sdd-kit. A new completion message (TTY, non-quiet), printed after the existing unconditional manual-steps block, states where per-project state lives (`openspec/`, `graphify-out/`, `.gitnexus/`) and shows the next-project command with the script's own resolved path as origin.
- **`sdd-kit/README.md` scenarios table gains a Scope column** with per-row values (C1 = `machine + repo`; C2b = `machine`; C2, C3, C1-UI, G2, G4 = `repo`) and a one-line first-contact note linking to guide §1.6.
- **Day-1 doc §0 (Layers) gains the machine-vs-repo scope explanation** (2–3 sentences + link to guide §1.6), so `/opsx:help` narrates it without any skill change. No section renumbering.
- **Template mirrors + checksums + version alignment**: changes to `bootstrap-sdd.sh` and `sdd-operator-day1.md` propagate to `sdd-kit/templates/`, with `gen-manifest-checksums.sh` regenerated; kit version bumps to 1.8.0 with guide changelog §14 entry, guide header version, and `openspec/project.md` cross-references aligned (also fixing the pre-existing guide header 1.6.1 vs MANIFEST 1.7.0 mismatch).

Out of scope: a global `bbv` wrapper CLI or Claude Code plugin packaging (future change); root `README.md` hero edits; any change to per-project state layout.

## Capabilities

### New Capabilities

_None — all changes modify existing install/onboarding capabilities._

### Modified Capabilities

- `sdd-install-kit`: guide §1.6 must document the three install scopes and the hub→destination one-command flow; `bootstrap-sdd.sh` must resolve preflight/kit from its own source repo when the target lacks them (hub mode) and must skip already-installed machine-level package installs (idempotent guard with `min_openspec` staleness WARN); kit README scenarios table must carry a Scope column with enumerated per-row values.
- `sdd-install-narrative`: canonical S-layer copy gains a third `Scope:` line per tool (en + pt-BR); the banner/quiet-mode requirement is updated to admit the Scope line; bootstrap completion message must state per-project state locations and the next-project install command without gating the existing unconditional manual-steps block.
- `sdd-install-preflight`: the repo prerequisite gate must accept hub-resolved `sdd-kit/` presence when bootstrap runs in hub mode against a greenfield target.
- `sdd-operator-onboarding`: day-1 doc §0 must explain machine-once vs per-project scope so `/opsx:help` narration covers it; no new section, no renumbering of the locked §0–§9 spine.

## Impact

- **Docs (hub):** `doc/byebyevibe-guide.md` (§1.6, changelog §14), `sdd-kit/README.md`, `doc/sdd-operator-day1.md` (§0).
- **Scripts (hub + template mirror):** `scripts/bootstrap-sdd.sh` and `sdd-kit/templates/scripts/bootstrap-sdd.sh` (hub-mode resolution + CLI guard + banner Scope lines + completion message); `scripts/preflight-sdd.sh` and its template (hub-resolved kit gate).
- **Kit integrity:** `sdd-kit/MANIFEST.yaml` (version bump + regenerated sha256 via `gen-manifest-checksums.sh`); template mirror of `doc/sdd-operator-day1.md`.
- **No new dependencies; no CI workflow changes.** Consumer repos receive the clarity via C2 upgrade.
- **Language policy (F7):** all versioned prose in English; banners carry en + pt-BR runtime strings as today.

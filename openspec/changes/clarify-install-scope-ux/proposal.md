# Proposal: clarify-install-scope-ux

**Issue:** —

## Why

Operators installing ByeByeVibe in a second project consistently hit the same question: "do I have to reinstall everything per project?" No canonical file answers it. The install model is sound — machine-level CLIs install once; each project receives a small payload copy plus its own generated state — but the docs never say so, the bootstrap banners don't say so, and `bootstrap-sdd.sh` reinstalls global CLIs unconditionally on every run, contradicting any "install once" message. For a user-friendly tool, the hub→destination flow ("one command from the hub clone installs into any target folder") must be explicit at first contact, at install time, and retrievable later via `/opsx:help`.

## What Changes

- **Guide §1.6 gains a canonical install-scope table** (machine-once / repo-copied / repo-generated) plus a short "hub → destination" flow statement: keep one hub clone per machine; install into any project with `bash <hub>/scripts/bootstrap-sdd.sh <target-repo> --profile <PROFILE>`. All other surfaces link here instead of duplicating the table.
- **`bootstrap-sdd.sh` becomes idempotent for machine-level CLIs**: check `command -v` (openspec, gitnexus, graphify/uv) before installing; print "already installed — skipping" instead of re-running `npm install -g`. Behavior must match the new message.
- **S-layer banners gain a `Scope:` line** (en + pt-BR): machine-once for OpenSpec/GitNexus/Graphify; "copied into this repo — each project gets its own" for sdd-kit. Final bootstrap message states where per-project state lives (`openspec/`, `graphify-out/`, `.gitnexus/`) and how to install into the next project.
- **`sdd-kit/README.md` scenarios table gains a Scope column** (`machine` / `repo`) and a one-line first-contact note linking to guide §1.6.
- **Day-1 doc §0 (Layers) gains the machine-vs-repo scope explanation** (2–3 sentences + link to guide §1.6), so `/opsx:help` narrates it without any skill change. No section renumbering.
- **Template mirrors + checksums**: changes to `bootstrap-sdd.sh` and `sdd-operator-day1.md` propagate to `sdd-kit/templates/`, with `gen-manifest-checksums.sh` regenerated; kit version bump + guide changelog §14 entry.

Out of scope: a global `bbv` wrapper CLI or Claude Code plugin packaging (future change); root `README.md` hero edits; any change to per-project state layout.

## Capabilities

### New Capabilities

_None — all changes modify existing install/onboarding capabilities._

### Modified Capabilities

- `sdd-install-kit`: guide §1.6 must document the three install scopes and the hub→destination one-command flow; `bootstrap-sdd.sh` must skip already-installed machine-level CLIs (idempotent guard); kit README scenarios table must carry a Scope column.
- `sdd-install-narrative`: canonical S-layer copy gains a third `Scope:` line per tool (en + pt-BR); bootstrap completion message must state per-project state locations and the next-project install command.
- `sdd-operator-onboarding`: day-1 doc §0 must explain machine-once vs per-project scope so `/opsx:help` narration covers it; no new section, no renumbering of the locked §0–§9 spine.

## Impact

- **Docs (hub):** `doc/byebyevibe-guide.md` (§1.6, changelog §14), `sdd-kit/README.md`, `doc/sdd-operator-day1.md` (§0).
- **Scripts (hub + template mirror):** `scripts/bootstrap-sdd.sh` and `sdd-kit/templates/scripts/bootstrap-sdd.sh` (CLI guard + banner Scope lines + completion message).
- **Kit integrity:** `sdd-kit/MANIFEST.yaml` (version bump + regenerated sha256 via `gen-manifest-checksums.sh`); template mirror of `doc/sdd-operator-day1.md`.
- **No new dependencies; no CI workflow changes.** Consumer repos receive the clarity via C2 upgrade.
- **Language policy (F7):** all versioned prose in English; banners carry en + pt-BR runtime strings as today.

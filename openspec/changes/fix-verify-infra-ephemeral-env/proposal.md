## Why

`scripts/verify-infra.sh` misbehaves in any environment that has not run `bootstrap-sdd.sh` (CI runners, remote agent sandboxes — the dominant way this repo was operated on 2026-08-05):

1. **A read operation mutates a committed file.** The script rewrites `openspec/infra.md` markers with the *local* environment's state. An ephemeral sandbox without global CLIs flips the committed `OpenSpec ✅ 1.3.1` to `❌ —`. In one session this happened three times; each commit used `git add -A`, so only a manual `git checkout -- openspec/infra.md` before each commit kept the false state out of `master`. R10 makes agents trust this file, so a committed false ❌ propagates.
2. **The CLI checks consult the npm registry instead of the machine.** `npx openspec` falls through PATH to the registry and resolves to `openspec@0.0.0` — an abandoned, unrelated package with no binary — producing a confusing error where the honest answer is "not on PATH". `npx gitnexus` triggers a package download. The script's own Graphify check and gap-check section already use `command -v`; the OpenSpec/GitNexus checks are the inconsistency.

The CI workflow already treats the mutation as garbage — `sdd-gates.yml` carries an explicit "Restore infra.md mutated by verify-infra.sh" step. This change makes that intent first-class in the script itself. Every change's final task gate runs `bash sdd-kit/verify.sh`, so each future agent apply session re-hits this until fixed.

## What Changes

- **Write gating:** `verify-infra.sh` updates `openspec/infra.md` markers only when running interactively (TTY) or when passed an explicit `--write` flag. Non-interactive runs without `--write` are **report-only**: no file mutation, findings printed with a report-only notice, exit 0 (advisory — matching how CI already consumes it per D4).
- **PATH-based CLI checks:** OpenSpec and GitNexus presence determined via `command -v` (as Graphify and the gap-check already do), never via bare `npx`/registry resolution. When the binary is present, version (`openspec --version`) and GitNexus index freshness (`gitnexus status` → "up-to-date") are still collected by invoking the binary directly.
- **"Verify with" column** in `openspec/infra.md` (live + kit template) updated from `npx openspec list` / `npx gitnexus status` to direct binary invocations, matching what the checks now measure.
- **Version alignment:** kit + guide **1.8.1 → 1.8.2** (script + template mirror change ⇒ checksum regeneration and MANIFEST bump are owed, unlike a docs-only release); changelog §14 entry; `openspec/project.md` cross-references.

Out of scope: removing the CI restore step (harmless belt-and-braces; may be retired in a later change once 1.8.2 has soaked); `bootstrap-sdd.sh`/`preflight-sdd.sh` (already correct); the `sdd-gates` workflow.

## Capabilities

### New Capabilities

_None._

### Modified Capabilities

- `sdd-workspace-manifest`: the "Infrastructure verification script" requirement gains the write-gating rule (interactive or `--write` only; non-interactive is report-only and leaves the manifest byte-identical) and the offline PATH-lookup rule for CLI presence checks.

## Impact

- **Scripts:** `scripts/verify-infra.sh` + mirror `sdd-kit/templates/scripts/verify-infra.sh`.
- **Manifest surfaces:** `openspec/infra.md` and `sdd-kit/templates/openspec/infra.md` ("Verify with" column only).
- **Kit release:** `sdd-kit/MANIFEST.yaml` 1.8.2 (checksums regenerated), guide header/changelog, `openspec/project.md`.
- **Behavioural note:** in a sandbox without CLIs, `sdd-kit/verify.sh` stops failing on verify-infra (report-only exit 0) and stops dirtying the working tree — future apply-session gates pass without manual reverts.
- **Language policy (F7):** English, per convention.

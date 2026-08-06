## Why

**Issue:** — (follow-up to `add-github-release-flow`, issue #350; no separate issue filed)

`add-github-release-flow` shipped the release machinery and cut `v1.12.0`, but deliberately left the acquisition default alone: the `sdd-install-kit` spec mandates the §1.6 sparse-checkout recipe as the default, and flipping it needed "a delta to that spec plus at least one published release actually existing" (that change's Open Questions). The second condition is now satisfied.

The cost of leaving it is not hypothetical. Today `master` and `v1.12.0` are identical in the install footprint — provably, the three git trees have the same hashes — so nobody is harmed. The first merge that touches `sdd-kit/` ends that: every new install then receives code that never passed `cut-release.sh`, carries no published checksum, has no changelog entry, and cannot be named by a version when someone reports a problem. A framework people install should hand them the last stable point by default; that is what releases are for.

## What Changes

- **BREAKING (for the spec, not for users):** the `sdd-install-kit` requirement "AI-assisted install prompt defaults to lightweight fetch" is inverted — the default becomes the latest published Release; the sparse-checkout recipe is retained and reserved for installing from unreleased `master`.
- Each Release gains a **stable-named asset pair** — `byebyevibe-kit.tar.gz` and `byebyevibe-kit.tar.gz.sha256` — alongside the existing version-stamped pair. This is the whole point of the change: without a version-less filename, GitHub's `releases/latest/download/<asset>` shortcut is unusable, because naming the asset requires already knowing the version. The version-stamped assets stay untouched as the archival, citable artifact §2.18 documents.
- Guide §1.6 gains a **release-download recipe** of comparable length to the sparse-checkout recipe, with checksum verification as a non-optional step, and the two recipes swap primacy.
- Guide §2.0's install prompt reorders its three acquisition options and names the Release first.
- Guide §2.18 documents the new asset pair, and states that a `sdd-kit/` change merged without a release now means installers receive an older kit than `master` — the inverted-debt consequence of this change.
- **No new prerequisite.** The recipe uses `curl` and `tar`, both already present wherever the existing recipe's `git` is (and both ship with Git for Windows). `gh` is deliberately not required: it would add an authenticated CLI to §1.1's prerequisite list to save one line.

## Capabilities

### New Capabilities

(none — this change modifies existing requirements only)

### Modified Capabilities

- `sdd-install-kit`: the acquisition default inverts. The prompt and §1.6 must lead with the published Release; the sparse-checkout recipe becomes the documented path for unreleased `master` rather than the default.
- `sdd-release-flow`: the reproducible-tarball requirement gains the stable-named asset pair, so a downloader can fetch the current release without first resolving its version number.

## Impact

- `doc/byebyevibe-guide.md` — §1.6 (new release-download recipe, recipe primacy swapped), §2.0 (prompt option order), §2.18 (asset inventory, stale-release consequence), changelog entry.
- `.github/workflows/release.yml` — publish step attaches two additional assets built from the same bytes.
- `openspec/specs/sdd-install-kit/spec.md`, `openspec/specs/sdd-release-flow/spec.md` — delta targets.
- `sdd-kit/MANIFEST.yaml` + the three declared version strings — lockstep bump, per the release discipline.
- **Not affected:** `sdd-kit/templates/`, `scripts/bootstrap-sdd.sh`, `scripts/preflight-sdd.sh`, `scripts/cut-release.sh`, `scripts/release-notes.sh`. No template bytes change, so checksums are unchanged and a C2 upgrade delivers no file diff. The tarball's *contents* are therefore identical to `v1.12.0`'s — only the asset inventory grows.
- **Operational:** releases become load-bearing. Before this change a stale release harmed nobody; after it, a `sdd-kit/` change merged without a cut silently downgrades every new install.

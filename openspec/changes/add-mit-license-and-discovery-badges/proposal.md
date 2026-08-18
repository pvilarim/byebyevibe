**Issue:** —

## Why

The hub README is the GitHub first-contact surface, but it has no status chrome (release / CI / license badges) and the repository has **no `LICENSE` file** (`license: null` on GitHub). A visitor who copies GitNexus-style badges blindly would mislabel this project (it is not an npm package; GitNexus is PolyForm Noncommercial, not MIT). Operators who install the composed stack also need a durable warning that **ByeByeVibe MIT does not relicense** OpenSpec, GitNexus, Graphify, or optional modules.

## What Changes

- Add a root **`LICENSE`** with the canonical MIT text, copyright **Pedro Vilarim, 2026**, so GitHub SPDX detection lights up and a **License: MIT** badge is honest.
- Add a root **`NOTICE.md`** listing composed / optional tools with their **own** licenses and a GitNexus **PolyForm Noncommercial** commercial-use caveat. MIT text stays SPDX-pure (no third-party table inside `LICENSE`).
- Add an honest **badge row** to the root README hero (GitHub Release, SDD Gates workflow, License: MIT). No npm, OpenSSF Scorecard, Discord, or third-party license badges.
- Add a short **Licenses** blurb in the README (Docs table + Stack & companions pointer to `NOTICE.md`) stating the stack is **composed, not relicensed**. Do **not** add a new top-level README section (keeps the v2/v3 section order).
- Add a **self-contained license paragraph** to `sdd-kit/README.md` (kit-only / lightweight fetch must still warn about GitNexus). Do **not** ship `LICENSE`/`NOTICE.md` through `install.sh` into consumer repos.
- Spec delta on `sdd-discovery-positioning` so future README edits cannot imply the whole stack is MIT or badge facts this repo does not have.

## Capabilities

### New Capabilities

—

### Modified Capabilities

- `sdd-discovery-positioning`: ADDED requirements for hub MIT `LICENSE`, third-party `NOTICE.md`, honest README status badges, and composed-stack license disclosure (README + kit README). README section order unchanged.

## Impact

- **Modified:** `README.md`, `sdd-kit/README.md`; **new:** `LICENSE`, `NOTICE.md`; delta on `openspec/specs/sdd-discovery-positioning/spec.md`
- **Not modified:** `sdd-kit/install.sh` / `upgrade.sh` / `MANIFEST.yaml` (kit README is not a MANIFEST path; do not copy license files into consumers; no guide checksum bump)
- **Non-goals:** OpenSSF Scorecard action; npm badge; Discord/site badge (D9); GIF/P5; centering or reordering README sections; relicensing GitNexus or any upstream; legal advice beyond recorded SPDX ids
- **Pilot:** waived (docs-only; no new binary/hook/service)
- **Sources:** explore session 2026-08-17; GitNexus README badge markup; GitHub API licenses 2026-08-17 (OpenSpec MIT, GitNexus PolyForm Noncommercial / NOASSERTION, Graphify Apache-2.0, Probity MIT, Impeccable Apache-2.0, OSV-Scanner Apache-2.0, Renovate AGPL-3.0); spec `sdd-discovery-positioning`; discovery design D9 (no Discord badge)

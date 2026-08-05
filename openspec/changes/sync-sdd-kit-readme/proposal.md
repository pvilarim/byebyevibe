## Why

`sdd-kit/README.md` still announces itself as **v1.6.1** while `MANIFEST.yaml` and the guide changelog are at **1.9.0** — three releases of drift. The same file advertises Probity for "APP/HYBRID" two lines away from its own table stating that HYBRID was retired in 1.9.0, promises an automatic review-skill installer "for v1.5.0" (a version that shipped in July), omits every skill and command the kit actually installs (`openspec-help`, `sdd-skill-guidance`, `sdd-tooling-guidance`, `/opsx:help`), omits the OSV-Scanner gate, and documents `bootstrap-sdd.sh` only in its in-repo form — never the hub→destination flow added in 1.8.0. The root README carries the mirror-image defects: it lists HYBRID as an active profile, labels Probity "APP/HYBRID", labels `sdd-kit/README.md` as "pt-BR (+ EN intro)" when that file is canonically English per `sdd-docs-language`, and leaves the very first mention of `sdd-kit/` — the one a first-contact visitor reads — as a bare code span while three later mentions are links.

The drift is not confined to the kit README. The guide carries two version claims and 1.9.0 updated only one — its header blockquote still reads `Canonical install guide (v1.8.2)` while line 22 reads `1.9.0`. Across two files there are three declared version strings, each with an authority field in `MANIFEST.yaml`, and all three have drifted at least once. Nothing enforces any of them, so correcting the numbers alone guarantees a fourth recurrence. A control plane that sells fail-closed gates should gate its own version claims.

## What Changes

- **`sdd-kit/verify.sh` gains a fail-closed version-sync gate (new behavior):** it compares each declared version string against its `MANIFEST.yaml` authority — `sdd-kit/README.md` H1 against `version:`, and the guide's `Canonical install guide (vX.Y.Z)` blockquote and `**Guide version:**` line against `guide_version:`. Each mismatch is a `FAIL` that increments `FAILURES` and reddens `bash sdd-kit/verify.sh`. Absent files skip with INFO; present-but-unparseable claims WARN — so consumer repos (which receive neither the kit README nor the guide) are unaffected, matching the existing kit-integrity/hub-parity pattern.
- **MANIFEST bump `1.9.0` → `1.10.0`** — a new gate is behavior, not docs-only. Guide §14 gains a `1.10.0` entry; `sdd-kit/README.md` H1 becomes `v1.10.0`; both guide header claims become `1.10.0`.
- **`sdd-kit/README.md` brought current with kit reality:** H1 version corrected; HYBRID references in the Probity rows replaced with APP; the dead "planned for v1.5.0" promise replaced with a factual statement about the manual-install status; the Structure block gains `gen-manifest-checksums.sh` and reflects that `templates/` mirrors `.claude/` (skills + commands) alongside `scripts/`, `.cursor/`, `doc/`; a new section documents the three skills and the `/opsx:help` command the kit installs automatically; the CI-gate section names OSV-Scanner and `renovate.json`; Quick commands gain the hub→destination bootstrap invocation; verification copy states the 1.8.2 `--write` / report-only semantics of `verify-infra` and the 1.9.0 profile-aware exit semantics of `verify-task-patterns`.
- **Root README congruence fixes:** the profiles line drops HYBRID (or marks it deprecated) to stop contradicting the kit README; the Probity optional-module row drops "/HYBRID"; the Docs table language cell for `sdd-kit/README.md` becomes `EN`; the first mention of the payload path becomes a link to the folder.
- **`openspec/infra.md` kit-version marker** refreshed from its stale `1.8.1` to the new version (it is a `verify-infra`-owned marker and is currently two releases behind).
- All prose in English (`docs_language: en`). No install/upgrade script logic changes beyond the new `verify.sh` gate; no template content changes, so MANIFEST checksums are unaffected.

**Not in scope:** making the root README's OpenSpec/GitNexus/Graphify links open in a new tab. GitHub's markdown sanitizer strips the `target` attribute from rendered README HTML, and markdown has no equivalent syntax — the request cannot be satisfied on github.com. Recorded here so it is not re-attempted.

## Capabilities

### New Capabilities

(none)

### Modified Capabilities

- `sdd-install-kit`: the "Kit README includes discovery positioning" requirement gains a currency obligation — the README's declared version MUST equal `MANIFEST.yaml` `version:`, and the README MUST document the skills/commands the kit installs, the supply-chain gate, and the hub→destination bootstrap form. Its "Operational content retained" scenario stops naming HYBRID as a live profile.
- `sdd-post-install-verification`: new requirement for the `verify.sh` version-sync gate covering the kit README H1 and both guide header claims (fail-closed on the hub, skipped per-file in repos that lack them).
- `sdd-discovery-positioning`: the root README requirements gain (a) a congruence obligation that profile and module lists MUST NOT present HYBRID as an active profile, (b) an accuracy obligation on the Docs table's language column, and (c) a requirement that the first mention of the `sdd-kit/` payload path be a link to the folder.

## Impact

- **Files:** `sdd-kit/README.md`, `sdd-kit/verify.sh`, `sdd-kit/MANIFEST.yaml` (version fields only), `README.md`, `doc/byebyevibe-guide.md` (both header version claims + §14 changelog entry), `openspec/infra.md` (kit-version marker).
- **Behavior:** `bash sdd-kit/verify.sh` acquires one new failure mode on the hub. CI `sdd-gates` does not invoke `verify.sh`, so the gate does not change CI outcomes for consumers.
- **Consumers:** none affected — no template under `sdd-kit/templates/` changes, so a C2 upgrade delivers no file diffs beyond the MANIFEST version. Consumer repos that do carry `sdd-kit/README.md` (hub-style DOCS_SPECS distributors) inherit the gate on their next kit copy.
- **Risk:** low. The failure mode is a string comparison between two files in the same commit.

## Why

`sdd-kit/install.sh` cannot complete a C1 greenfield install on native Windows, and cannot complete one on **any** platform in a repository that lacks a `.github/` directory. Both defects predate v1.13.0, but v1.13.0 made them far more reachable: it switched the documented default acquisition path to downloading the published Release, so every new installer is now routed onto a kit that fails.

A third symptom of the same family reaches further than install: `sdd-kit/gen-manifest-checksums.sh --check` — the integrity gate that `verify-release-readiness.sh` and `sdd-kit/verify.sh` both depend on — cannot pass on Windows at all. All 45 entries mismatch. This means an operator on Windows cannot verify a release, and `cut-release.sh` requires that gate to exit 0.

Three root causes, each with a distinct blast radius:

1. **The interpreter boundary.** The kit reaches Python exclusively through the name `python3`. The CPython Windows installer does not create `python3.exe` — it creates `python.exe` and the `py.exe` launcher. So on a Windows machine with a perfectly good Python, preflight reports `python3 0.0.0 < minimum 3.10` and the install is refused, pointing the operator at the wrong problem. When the name is fixed, the next defect fires: Python on Windows writes `\r\n` to stdout, `read -r` leaves the `\r` on the last field, and the template integrity check fails printing two hashes that look identical.

2. **The path guard runs before the directory exists.** `install.sh` canonicalises each destination with `realpath` in its path-traversal guard, but creates the parent directory 36 lines later. GNU `realpath` tolerates a missing final component and rejects a missing parent, so installing `.github/workflows/sdd-gates.yml` into a greenfield repository aborts the run. This is the same coreutils binary on Linux; it is not a Windows problem. It has never been caught because the hub and CI already carry `.github/workflows/`.

3. **The path separator leaks across the Python↔coreutils boundary.** Python on Windows joins paths with a backslash, and GNU `sha256sum` escapes any line whose filename contains one by prefixing the whole line with `\`. Splitting that line on whitespace yields `\<hash>` instead of `<hash>`, so every comparison fails. Measured: the same file hashed through a pure POSIX path returns the correct value, and the MANIFEST value, the committed bytes, and the working-tree bytes are all identical — only the reading of the checksum is wrong.

Every fix in this change was measured against a scratch repository, not inferred. With the two boundary fixes applied, a genuine greenfield C1 install completes: 39 files written, exit 0.

One consequence deserves recording rather than only fixing. Before the interpreter was resolvable on the machine where this was found, `verify-release-readiness.sh` **passed vacuously** — its Python block produced nothing, and the gate reported success without checking anything. A release was cut on the strength of that green. The release itself was sound only because `sdd-release-flow` requires every guard to re-run server-side and to trust nothing that `cut-release.sh` reports. That design decision is what prevented a bad release, and it is the reason this defect cost nothing.

## What Changes

- **Resolve the Python interpreter by capability, not by name.** Probe `python3`, then `python`, then `py -3`, accepting the first that reports a version at or above the kit's own floor. Existence is not sufficient evidence — a bare `python` may be Python 2 — so the probe reads `sys.version_info` and the result is a resolved command, not a boolean.
- **Separate the kit's Python floor from Graphify's.** No embedded snippet uses syntax above 3.6. The `3.10+` currently declared in guide §1.1 belongs to Graphify, and conflating them makes the installer refuse hosts it can actually run on.
- **Check the interpreter before any file is touched.** `install.sh` already runs `preflight-sdd.sh --repo` and already aborts on FAIL; the runtime check moves into that existing gate rather than being duplicated across scripts.
- **Normalise the Python↔bash boundary, differently per site class.** Feeds into `read` loops carrying tab-separated metadata get their carriage returns stripped in the shell. File-rewriting sites instead stop translating newlines on both read and write, so a file's original line endings survive a four-line edit.
- **Make an empty template parse fail loudly.** A zero-file install that exits 0 and prints `Done` is the worst available failure mode. **BREAKING** for anyone whose install currently "succeeds" without writing anything: it will now abort.
- **Let the traversal guard canonicalise a path whose parent does not exist yet**, without weakening it — escapes outside the repository root are still caught.
- **Build filesystem paths that the POSIX tools the kit shells out to can read back.** A path assembled with the host's native separator is not interchangeable with one a coreutils program will echo unescaped, and a checksum reader must not assume the first whitespace-delimited token is a hash.
- **Never let a verification gate report success without having verified anything.** A check whose subprocess produced no output must fail, not pass — the release-readiness gate did the latter, and only the server-side re-run caught it.
- **Correct guide §1.1.** It claims native Windows works; that claim was false. Python's role for the installer itself must be stated, not only its role for Graphify.
- **Add a greenfield smoke test to CI.** Install into an empty repository in the `sdd-gates` workflow. This defect class ships again without it — the `realpath` bug would have been caught on Linux the day it was introduced.

Not in scope: removing the Python dependency from the install path (issue #364), and the native-Windows support stance as a documentation question (issue #363). Requiring WSL2 was evaluated and rejected — WSL2 is a real Linux kernel, so requiring it is requiring Linux.

## Capabilities

### New Capabilities

None. This change repairs behaviour that existing capabilities already claim.

### Modified Capabilities

- `sdd-install-kit`: `install.sh` and `upgrade.sh` gain a resolved-interpreter requirement, a newline-normalisation requirement at the Python↔bash boundary, a fail-loud requirement when the template list parses empty, and a corrected path-traversal guard that tolerates a not-yet-created parent directory while still blocking escapes.
- `sdd-install-preflight`: the host matrix stops conflating the kit's interpreter floor with Graphify's, reports the resolved interpreter rather than only the name `python3`, and the repo-mode gate gains the runtime check that `install.sh` depends on.
- `sdd-ci-gates`: the workflow gains a greenfield install smoke test, so a C1 install into an empty repository is exercised on every run.
- `sdd-release-flow`: the release-readiness precondition must be non-vacuous — a check that compared nothing must fail rather than report success, since a green it did not earn is worse than a red.

## Impact

**Code.** `sdd-kit/install.sh` (interpreter, newline, realpath, fail-loud), `sdd-kit/upgrade.sh` (two read-loop feeds), `sdd-kit/templates/scripts/preflight-sdd.sh` (resolution, floor, repo-mode check, infra.md rewrite), `sdd-kit/templates/scripts/sdd-upgrade-diff.sh` and `sdd-kit/templates/scripts/verify-infra.sh` (boundary), `sdd-kit/gen-manifest-checksums.sh` and `sdd-kit/templates/scripts/verify-release-readiness.sh` (path construction, checksum parsing, non-vacuous check), plus `.github/workflows/sdd-gates.yml`.

**Distribution mechanics.** Thirteen scripts exist in both `scripts/` and `sdd-kit/templates/scripts/` and are parity-gated; `MANIFEST.yaml` carries a sha256 for each of its 45 entries. Every template edit requires regenerating checksums and keeping live/template parity green, so the mechanical footprint is larger than the logical one.

**Docs.** Guide §1.1 (prerequisites and the native-Windows claim), and a changelog entry stating plainly that no released version could complete a C1 greenfield install on native Windows, and that the `realpath` defect affected every platform.

**Version.** 1.14.0 rather than 1.13.1: the change adds normative requirements to three capabilities, and `install.sh` will abort where it previously reported success. A patch release is for fixing without changing the contract; here the contract grows.

**Not yanking v1.13.0.** These defects predate it and `sdd-release-flow` reserves withdrawal for content that was wrong when published. The urgency comes from exposure, not from regression.

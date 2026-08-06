## ADDED Requirements

### Requirement: Kit scripts resolve a Python interpreter by capability

Every kit script that invokes Python MUST obtain its interpreter from a single resolution result rather than hardcoding the command name `python3`. Resolution MUST try, in order, `python3`, `python`, and `py -3`, and MUST accept the first candidate that reports a Python version at or above the kit's declared floor.

Resolution MUST validate the **version**, not the presence of the name: a candidate is accepted only if executing it yields a parseable `sys.version_info`. Presence alone is insufficient evidence, because `python` may be Python 2 and, on Windows, an installed-looking `python3` may be an application-execution alias that is not an interpreter at all.

The kit's floor MUST be declared independently of the floor any bundled or optional integration requires. The kit MUST NOT refuse to run on an interpreter that satisfies its own floor merely because a separate component declares a higher one.

When no candidate satisfies the floor, the failure message MUST name every candidate that was tried and the floor that was required, so an operator with a working Python under a different name can tell that the problem is the name and not the absence of Python.

#### Scenario: Interpreter available only as `python`

- **WHEN** a kit script runs on a host where `python3` is absent but `python` reports a version at or above the kit floor
- **THEN** the script resolves and uses `python`, and completes normally

#### Scenario: A name that is not an interpreter is rejected

- **WHEN** a candidate command exists on PATH but does not yield a parseable `sys.version_info` when executed
- **THEN** resolution rejects that candidate and continues to the next one, rather than treating its existence as success

#### Scenario: Failure names the candidates and the floor

- **WHEN** no candidate satisfies the floor
- **THEN** the script exits non-zero with a message naming each candidate tried and the required floor, and does not report a version for a candidate it could not execute

### Requirement: The Python-to-shell boundary preserves data

Where a kit script consumes Python output through a shell `read` loop, the boundary MUST NOT allow a carriage return emitted by the interpreter to become part of a parsed field. This is required because Python translates line endings on standard output on some platforms, and a trailing carriage return on the final field is invisible in error output — a corrupted value and a correct value print identically.

Where a kit script uses Python to rewrite an existing file, the rewrite MUST preserve the file's original line endings. Reading and writing MUST both suppress newline translation, so that editing a small region of a file does not rewrite every line of it.

These two obligations MUST be satisfied by different means. Deleting carriage returns is permitted only on a metadata stream whose fields cannot legitimately contain one; it MUST NOT be applied to file content, where it would silently destroy the original line endings.

#### Scenario: Integrity check is not defeated by a line ending

- **WHEN** an interpreter that translates line endings feeds the template list to `install.sh`
- **THEN** the checksum comparison for each template succeeds against the MANIFEST value, and no template is reported as mismatched when its bytes match

#### Scenario: A small edit produces a small diff

- **WHEN** a kit script rewrites a region of an existing file whose line endings are CRLF
- **THEN** only the edited lines differ, and the file's remaining lines keep their original endings

#### Scenario: File content keeps its carriage returns

- **WHEN** a kit script rewrites a file that legitimately contains carriage returns in its content
- **THEN** those carriage returns survive the rewrite

### Requirement: Checksum verification reads what the hashing tool wrote

Where a kit script builds a filesystem path and hands it to an external hashing tool, the path MUST be constructed so the tool echoes it back unmodified. A path assembled with the host's native separator is not interchangeable with one a POSIX tool will print verbatim: GNU checksum tools escape any output line whose filename contains a backslash by prefixing the entire line, which silently corrupts the field a caller reads.

A caller MUST NOT assume the first whitespace-delimited token of a checksum tool's output is the digest. It MUST either parse the escaped form or construct paths that cannot trigger escaping, and MUST reject a digest that is not a bare hexadecimal string of the expected length rather than comparing it as-is.

A verification pass that completed without comparing any entry MUST fail. Reporting success for a check that examined nothing is worse than reporting failure, because it converts an unverified state into a recorded green.

#### Scenario: Digest is read correctly on a host with a native backslash separator

- **WHEN** the checksum checker runs on a host whose path separator is a backslash, against templates whose recorded digests are correct
- **THEN** every entry verifies, and no entry is reported as mismatched

#### Scenario: An escaped checksum line is not mistaken for a digest

- **WHEN** the hashing tool escapes its output line because the filename it was given contains a backslash
- **THEN** the caller does not compare the escape prefix as part of the digest, and does not report a mismatch for a file whose bytes match

#### Scenario: A checker that compared nothing fails

- **WHEN** the checksum checker completes having compared zero entries
- **THEN** it exits non-zero, rather than reporting that all checksums are correct

### Requirement: An empty template list aborts the install

`sdd-kit/install.sh` MUST verify that the profile-filtered template list it consumed was non-empty, and MUST exit non-zero when it was not. It MUST NOT report completion, and MUST NOT print its next-steps guidance, after applying zero files.

This check is required in addition to shell error handling, because the template list is produced through a construct whose exit status the shell does not propagate — an unusable interpreter yields an empty list that is indistinguishable, to the surrounding shell, from a successful run.

#### Scenario: Zero templates applied

- **WHEN** `install.sh` completes its template loop having applied no files
- **THEN** it exits non-zero with a message stating that no templates were applied, and does not print the completion or next-steps output

#### Scenario: Normal install is unaffected

- **WHEN** `install.sh` applies at least one template for the selected profile
- **THEN** the check passes and the install proceeds to its completion output

## MODIFIED Requirements

### Requirement: Deterministic greenfield install

`sdd-kit/install.sh` MUST validate every destination path against the repository root before writing any file. If a computed destination path escapes `$REPO_ROOT` (e.g. via `..` segments in a MANIFEST `path:` field), the script MUST abort with `ERROR: path traversal blocked` and exit non-zero.

Path validation MUST succeed for a destination whose parent directory does not exist yet. A genuine greenfield repository lacks the directories the install is about to create, and a guard that requires them to pre-exist rejects the exact scenario it is meant to protect. Canonicalisation MUST therefore tolerate missing components while still resolving `..` segments, so the escape check retains its meaning. The guard MUST NOT be satisfied by creating directories before the check runs: validation precedes writes.

#### Scenario: MANIFEST with path traversal attempt

- **WHEN** a MANIFEST entry contains `path: ../../etc/passwd` (or any path resolving outside `$REPO_ROOT`)
- **THEN** `install.sh` prints `ERROR: path traversal blocked` to stderr and exits non-zero without writing any file

#### Scenario: Destination parent does not exist yet

- **WHEN** a MANIFEST entry targets a path whose parent directory is absent from the target repository — for example `.github/workflows/` in a repository that has no `.github/`
- **THEN** path validation succeeds, the parent directory is created, and the file is written

#### Scenario: Traversal is still blocked when the parent is absent

- **WHEN** a MANIFEST entry resolves outside `$REPO_ROOT` and none of its parent directories exist
- **THEN** the escape is still detected and the install aborts without writing any file

### Requirement: install.sh applies repo-only preflight gate

`sdd-kit/install.sh` MUST run repo-only preflight (`scripts/preflight-sdd.sh --repo` or equivalent inline checks matching that mode) before copying templates, unless `--skip-preflight` is passed. It MUST NOT repeat the full host prerequisite scan as part of that gate.

The gate MUST, however, verify the runtime that `install.sh` itself depends on, and MUST abort before any template is copied when that runtime cannot be resolved. This is not a reintroduction of the host scan: it is limited to what the installer will execute during this run, and MUST NOT extend to prerequisites belonging to components the installer does not invoke.

#### Scenario: Standalone install fails without sdd-kit readability

- **WHEN** `install.sh` is invoked in a broken layout where repo preflight would FAIL and `--skip-preflight` is not set
- **THEN** install aborts before template copy

#### Scenario: install does not require host build tools

- **WHEN** `install.sh` runs with repo preflight PASS and host build tools absent
- **THEN** install does not FAIL solely due to missing GitNexus build tools

#### Scenario: Unresolvable interpreter aborts before any write

- **WHEN** `install.sh` runs on a host where no interpreter candidate satisfies the kit floor and `--skip-preflight` is not set
- **THEN** the run aborts during the preflight gate, no file is written to the target repository, and the message identifies the missing runtime

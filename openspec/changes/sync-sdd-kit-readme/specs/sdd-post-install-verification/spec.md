## ADDED Requirements

### Requirement: Declared versions match their MANIFEST authority

`sdd-kit/verify.sh` MUST verify every version string declared in prose against its authority field in `sdd-kit/MANIFEST.yaml`:

| Declared claim | Authority |
|----------------|-----------|
| `sdd-kit/README.md` top-level heading | `version:` |
| `doc/byebyevibe-guide.md` canonical-guide header blockquote | `guide_version:` |
| `doc/byebyevibe-guide.md` `**Guide version:**` line | `guide_version:` |

Each comparison MUST be independent and MUST be fail-closed: a mismatch MUST print a `FAIL` line naming the file, the value it declares, and the authority value; MUST increment the failure count; and MUST cause `bash sdd-kit/verify.sh` to exit non-zero. `version:` and `guide_version:` MUST NOT be conflated — the manifest permits them to differ, and a claim is only ever compared against its own authority.

Each comparison MUST degrade rather than fail when the claim is unavailable: when the file containing the claim is absent, the check MUST print an informational skip line and leave the exit code unchanged; when the file is present but the claim line is missing or contains no parseable `MAJOR.MINOR.PATCH` token, the check MUST print a `WARN` and leave the exit code unchanged.

Comparison MUST be a literal comparison of the extracted semver token against the authority value, ignoring a leading `v` on the declared token.

#### Scenario: Hub with synchronized versions passes

- **WHEN** `sdd-kit/README.md` declares `v1.10.0`, both guide header claims declare `1.10.0`, and `sdd-kit/MANIFEST.yaml` has `version: "1.10.0"` and `guide_version: "1.10.0"`
- **THEN** `bash sdd-kit/verify.sh` reports the version-sync check as OK and the check contributes no failures

#### Scenario: Stale kit README header fails verification

- **WHEN** `sdd-kit/MANIFEST.yaml` `version:` is bumped and the `sdd-kit/README.md` heading still declares the previous version
- **THEN** `bash sdd-kit/verify.sh` prints a FAIL naming `sdd-kit/README.md`, the version it declares, and the MANIFEST version, and exits non-zero

#### Scenario: One stale guide header claim fails verification

- **WHEN** the guide's `**Guide version:**` line matches `guide_version:` but its canonical-guide header blockquote declares an older version
- **THEN** `bash sdd-kit/verify.sh` prints a FAIL for the blockquote claim and exits non-zero, independently of the line that matched

#### Scenario: Consumer without kit README or guide skips those checks

- **WHEN** `bash sdd-kit/verify.sh` runs in a repository that has `sdd-kit/MANIFEST.yaml` but neither `sdd-kit/README.md` nor `doc/byebyevibe-guide.md`
- **THEN** the version-sync checks print informational skip lines and do not affect the exit code

#### Scenario: Custom kit README heading warns without blocking

- **WHEN** a repository carries a `sdd-kit/README.md` whose top-level heading contains no `MAJOR.MINOR.PATCH` token
- **THEN** the version-sync check prints a WARN and does not affect the exit code

#### Scenario: Payload and guide versions may legitimately differ

- **WHEN** `MANIFEST.yaml` records `version:` and `guide_version:` as different values and each declared claim matches its own authority
- **THEN** all version-sync checks pass

#### Scenario: Two-digit minor versions compare correctly

- **WHEN** the kit version is `1.10.0` and every declared claim states it
- **THEN** the checks pass, and no version comparison in the kit relies on lexicographic ordering that would rank `1.10.0` below `1.9.0`

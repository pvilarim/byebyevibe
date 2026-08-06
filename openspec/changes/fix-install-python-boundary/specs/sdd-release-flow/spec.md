## MODIFIED Requirements

### Requirement: Cutting a release is guarded by preconditions

The documented procedure to cut a release MUST, before creating any tag, fetch the remote default branch and remote tags, and then verify that: the working tree is clean; the checkout is on the repository's default branch and points at the same commit as the freshly fetched remote default branch (neither behind nor ahead); `version:` equals `guide_version:` and both equal the requested version; the changelog section for that version resolves to non-empty text; `scripts/verify-release-readiness.sh` exits zero; and no tag of the same name exists locally or on the remote. Any failed precondition — including an unreachable remote — MUST abort with a non-zero exit and a message naming the failed check, leaving the repository unmodified. The procedure MUST offer a dry-run mode that runs every precondition and reports the outcome without creating or pushing anything. The annotated tag's message MUST be only the release title (`v<version>`) — release-note text lives in the GitHub Release body alone, so the tag message can never diverge from it.

Each precondition MUST be non-vacuous: a check that produced no result MUST report failure, not success. A precondition whose helper process failed to run, or ran and compared nothing, MUST NOT be recorded as satisfied. This is not a theoretical safeguard — the readiness check has passed on a host where its own subprocess produced no output, so the operator was told the repository was release-ready by a check that had examined nothing.

#### Scenario: All preconditions hold

- **WHEN** every precondition is satisfied for the requested version
- **THEN** an annotated tag is created and pushed to the remote, and the operator is told which tag was pushed

#### Scenario: Dry-run never mutates

- **WHEN** the procedure runs in dry-run mode, regardless of whether the preconditions pass or fail
- **THEN** no tag is created locally or remotely and no push occurs

#### Scenario: Repo-state check fails

- **WHEN** `scripts/verify-release-readiness.sh` exits non-zero at the commit being released — for example a version-sync mismatch or a stale template checksum
- **THEN** the procedure aborts, no tag is created, and the underlying failure output is shown

#### Scenario: Tag already exists

- **WHEN** a tag with the target name already exists locally or on the remote
- **THEN** the procedure aborts without moving, deleting, or overwriting the existing tag

#### Scenario: Local branch ahead of or behind the remote

- **WHEN** the fetched remote default branch and the local checkout point at different commits — the local branch is behind, ahead, or diverged
- **THEN** the procedure aborts before tagging, so a tag can never point at a commit the remote does not have or skip commits the remote already has

#### Scenario: Remote unreachable

- **WHEN** the initial fetch or the remote tag check cannot reach the remote
- **THEN** the procedure aborts with a message naming the network failure, rather than proceeding on stale local refs

#### Scenario: A precondition that checked nothing does not count as passing

- **WHEN** the readiness check runs on a host where its helper process cannot execute, and it therefore compares no entry
- **THEN** the check reports failure and the cut aborts, rather than reporting that the repository is ready

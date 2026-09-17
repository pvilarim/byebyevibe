# Consumer distribution decision

**Change:** `add-automated-pr-review-pipeline`
**Date:** 2026-09-17
**Decision:** record a follow-up; do **not** change core C1/C2.

## Boundary

Apply proved the workflow in this hub only:

- `.github/workflows/automated-pr-review.yml`
- `scripts/pr-review-check.sh`
- `scripts/pr-review-report.sh`

These paths are **not** MANIFEST entries. `sdd-kit/install.sh` and `sdd-kit/upgrade.sh` do not copy them. Standard C1/C2 therefore cannot silently enable a credentialed paid GitHub Action.

The install guide (§2.19) and `sdd-kit/README.md` describe the hub workflow and the one-time secret **names**. The guide template is updated so consumers can read the operator procedure; reading a section is not activation.

## Why not an optional kit module in this change

Shipping a UI/Probity-style installer (`install-pr-review-module.sh` + template workflow + checksums + profile flags) would expand installer/MANIFEST behavior. Design decision 9 says that expansion is a separate change if it materially alters C1/C2. This apply keeps the reviewed scope hub-first.

## Follow-up (not this change)

A later OpenSpec change may add an **explicitly selected** optional module that copies the workflow only when an operator runs a dedicated installer (never as a default MANIFEST `COPY` on C1). That change must keep:

- no secret values
- no default paid-provider requirement
- `sdd-gates` allowlist unchanged
- the same `pull_request` / least-privilege / base-revision lens rules

Until then, a consumer who wants the pipeline copies the hub files manually after human review.

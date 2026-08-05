## MODIFIED Requirements

### Requirement: Kit README includes discovery positioning for newcomers

`sdd-kit/README.md` MUST begin with (or include near the top, before operational scenario tables) a short positioning section that: (1) states what the kit is in plain language for newcomers arriving from vibe coding / AI-assisted workflows; (2) maps internal scenario codes (at least C1, C2, C3) to human-readable names; and (3) points to the hub root `README.md` and/or the canonical guide for first contact. Operational sections (profiles, commands, structure, CI gates) MUST remain present.

The README MUST additionally stay current with the kit release it ships in:

- Its top-level heading MUST declare the same version as `sdd-kit/MANIFEST.yaml` `version:`, and the guide's header version claims MUST declare `guide_version:` (both enforced by `sdd-kit/verify.sh` — see `sdd-post-install-verification`).
- The Structure section MUST list every executable at the `sdd-kit/` root and MUST indicate that `templates/` mirrors agent-tool directories (`.claude/`, `.cursor/`) in addition to `scripts/` and `doc/`.
- The README MUST document the skills and slash commands the kit installs automatically, distinguishing them from skills that require manual copying.
- The CI-gate section MUST name every blocking gate carried by the shipped `sdd-gates.yml`, including supply-chain scanning when a lockfile is present.
- Entry commands MUST cover the hub→destination invocation form of `bootstrap-sdd.sh` (running the hub's script against a separate target repository), not only the in-repo form.
- Verification copy MUST state the conditions under which `verify-infra.sh` and `verify-task-patterns.sh` are report-only rather than fail-closed.
- Statements about deprecated profiles MUST agree with the profiles table in the same file; forward-looking promises MUST NOT name a kit version that has already shipped.

#### Scenario: Newcomer reads kit README first

- **WHEN** a newcomer opens `sdd-kit/README.md` without prior SDD jargon
- **THEN** they see a positioning/intro section and a human-readable mapping for C1/C2/C3 before or alongside the operational tables

#### Scenario: Operational content retained

- **WHEN** `sdd-kit/README.md` is updated for discovery framing
- **THEN** it still documents install/upgrade entry commands and the active profiles (APP, DOCS_SPECS), with HYBRID shown only as a deprecated alias of APP

#### Scenario: Kit README announces what the kit installs

- **WHEN** an operator reads `sdd-kit/README.md` looking for what a C1 install delivers beyond scripts and rules
- **THEN** the automatically installed skills and the `/opsx:help` command are named, and the manually installed review skills are marked as manual

#### Scenario: Kit README version tracks the release

- **WHEN** a release bumps `sdd-kit/MANIFEST.yaml` `version:`
- **THEN** the `sdd-kit/README.md` heading declares the same version in the same commit, and `bash sdd-kit/verify.sh` passes

#### Scenario: No stale forward promises

- **WHEN** `sdd-kit/README.md` describes work planned for a future kit version
- **THEN** the named version is greater than the current MANIFEST version, or the promise is restated as the current factual status

# Delta — sdd-install-kit

## ADDED Requirements

### Requirement: Hub context is identified by an explicit marker

The distribution hub repository MUST carry a marker file `.sdd-hub` at its repository root, committed in the hub only. The marker MUST NOT be listed in the MANIFEST, MUST NOT live inside `sdd-kit/`, and MUST NOT be part of the release tarball footprint, so no acquisition path can deliver it to a consumer. Every kit script that branches on "am I running in the hub?" (parity checks, grandfathering skips, readiness hub-only claims) MUST test for this marker and MUST NOT infer hub identity from directory shape (e.g. the presence of `sdd-kit/templates/`), because in APP-profile consumers that directory legitimately exists.

#### Scenario: Consumer with a full copied kit is not mistaken for the hub

- **WHEN** `bash sdd-kit/verify.sh` runs in a consumer repository that acquired the whole `sdd-kit/` (tarball path) and has no `.sdd-hub` file
- **THEN** no hub-only check runs against it and no consumer-only check is skipped for it

#### Scenario: Hub is recognized by the marker

- **WHEN** `bash sdd-kit/verify.sh` runs in a repository whose root contains `.sdd-hub`
- **THEN** hub-only parity checks run and hub-grandfathered skips apply

### Requirement: Kit ships a project.md template

The MANIFEST MUST include an entry delivering `openspec/project.md` from `sdd-kit/templates/openspec/project.md` with `merge: MERGE` (copy when absent, keep the operator's file when present) for all profiles. The template MUST contain a minimal constitution skeleton (Purpose, Stack, Conventions, Constraints) with explicit fill-me placeholders and MUST contain the `<!-- SDD_LANGUAGE_POLICY_START -->` / `<!-- SDD_LANGUAGE_POLICY_END -->` anchor markers so language-policy injection always has its target. This entry exists because non-interactive `openspec init` does not generate `project.md`, which left the `sdd-language-policy` capability without a persistence target in every 1.14.0 APP install.

#### Scenario: Greenfield install materializes project.md

- **WHEN** `bash sdd-kit/install.sh --profile APP` completes in a repository with no `openspec/project.md`
- **THEN** `openspec/project.md` exists, contains the constitution skeleton, and contains the language-policy anchor markers with injected values

#### Scenario: Existing project.md is preserved

- **WHEN** the install runs in a repository that already has an operator-written `openspec/project.md`
- **THEN** the operator's file is kept (MERGE semantics) and language-policy injection edits only the anchored block

### Requirement: Distributed change template validates strictly

The kit MUST distribute `openspec/changes/_template/` in a form that passes `openspec validate --all --strict` out of the box: alongside `_template/proposal.md`, the MANIFEST MUST deliver `_template/specs/example-capability/spec.md` containing at least one normative placeholder requirement with one scenario (a valid delta). A consumer's first CI run MUST NOT go red because of kit-delivered scaffolding.

#### Scenario: Fresh consumer passes strict validation

- **WHEN** `openspec validate --all --strict` runs in a repository immediately after a C1 install, before the operator creates any change
- **THEN** validation exits 0, with the `_template` change passing on its placeholder delta

### Requirement: Guide is delivered to consumer installs

The kit MUST deliver `doc/byebyevibe-guide.md` to consumers: a byte-identical mirror MUST exist at `sdd-kit/templates/doc/byebyevibe-guide.md` (inside the tarball without changing the release footprint), and the MANIFEST MUST include a COPY entry installing it to `doc/byebyevibe-guide.md` for all profiles — the exact pattern of `doc/sdd-operator-day1.md`. `scripts/verify-release-readiness.sh` MUST enforce hub↔template parity for the guide mirror, failing on drift.

This reverts the 2026-08-05 decision (`simplify-install-profiles`, "never receives it, never needs it") and restores the founding design intent of 2026-06-17 (`add-sdd-install-kit`, guide copied to consumers): with ~78 references across 23 tarball files pointing at the guide — ten of them fixed by requirement lines in `sdd-operator-onboarding`, `sdd-install-narrative`, and `sdd-install-kit` — delivering the guide is the only fix that satisfies the references instead of rewriting them.

#### Scenario: Consumer receives the guide

- **WHEN** a C1 install completes in any profile
- **THEN** `doc/byebyevibe-guide.md` exists in the consumer repository and the `guia §` / `guide §` pointers printed by the installer and carried by installed files resolve to it

#### Scenario: Guide mirror drift fails readiness

- **WHEN** `doc/byebyevibe-guide.md` and `sdd-kit/templates/doc/byebyevibe-guide.md` differ and `bash scripts/verify-release-readiness.sh` runs in the hub
- **THEN** the parity check reports FAIL and the script exits non-zero

### Requirement: bootstrap-sdd.sh treats kit payload install failure as fatal

When the `sdd-kit/install.sh` phase of `scripts/bootstrap-sdd.sh` exits non-zero, the bootstrap MUST exit non-zero with an error stating that the payload was not installed. A payload that was not copied is not a warning (per `sdd-fail-loud`). The optional-continue behavior for GitNexus and Graphify phases is unaffected: those integrations are optional; the kit payload is the reason the command exists.

#### Scenario: Failed install fails the bootstrap

- **WHEN** `sdd-kit/install.sh` exits 1 during `bash scripts/bootstrap-sdd.sh <target>`
- **THEN** the bootstrap exits non-zero and does not print its completion message

#### Scenario: GitNexus failure still does not abort

- **WHEN** the GitNexus phase fails during bootstrap
- **THEN** the bootstrap continues to the kit install phase, preserving the documented optional-continue behavior

### Requirement: bootstrap-sdd.sh surfaces openspec init failure

The `openspec init` invocation in `scripts/bootstrap-sdd.sh` MUST NOT suppress its diagnostic output on the failure path, and when every attempted invocation fails, the bootstrap MUST exit non-zero surfacing the captured error (per `sdd-fail-loud`). OpenSpec is the first pillar of the C1 order; a bootstrap that continues without it installs a framework whose control plane is missing.

#### Scenario: init failure aborts with the reason visible

- **WHEN** `openspec init` fails in both its attempted invocations during bootstrap
- **THEN** the bootstrap exits non-zero and the operator sees the error output that explains why init failed

### Requirement: AGENTS.md merge distinguishes operator files from tool-generated files

`scripts/bootstrap-sdd.sh` MUST record whether `AGENTS.md` existed in the target before its tool phases (GitNexus/Graphify) run, and MUST communicate that fact to `sdd-kit/install.sh` (e.g. via an exported variable). When `install.sh`'s AGENTS.md merge finds an existing file that did **not** pre-exist the tool phases, it MUST treat the content as tool-generated: write the kit AGENTS.md for the resolved profile and re-append the tool-injected content, instead of keeping the file untouched. The C1 phase order (OpenSpec → GitNexus → Graphify → `install.sh`) MUST NOT change. When `install.sh` runs standalone (no snapshot available), the existing KEEP behavior for pre-existing files stands — without a snapshot the installer must not guess.

#### Scenario: GitNexus-created AGENTS.md does not suppress the kit's

- **WHEN** the target had no `AGENTS.md`, `gitnexus analyze` created one during bootstrap, and the kit install phase runs
- **THEN** the resulting `AGENTS.md` contains the kit's profile content and preserves the GitNexus-injected block, and the installer does not report `KEEP`

#### Scenario: Operator-authored AGENTS.md is still kept

- **WHEN** the target repository already had an `AGENTS.md` before bootstrap started
- **THEN** the merge keeps the operator's file per existing MERGE semantics

### Requirement: In-place file edits are portable across sed variants

Kit and distributed scripts MUST NOT use `sed -i`: BSD and GNU forms of the flag are mutually incompatible and no single invocation works on both. In-place edits MUST be written as an explicit rewrite through a temporary file followed by an atomic `mv` over the original (or an equivalent construct with the same two-toolchain correctness), chosen by construction rather than by runtime probe.

#### Scenario: Edit sites carry no sed -i

- **WHEN** the kit's live scripts and template mirrors are searched for `sed -i`
- **THEN** no call site remains in `scripts/preflight-sdd.sh`, `scripts/verify-infra.sh`, `sdd-kit/install-ui-module.sh`, or their template mirrors

## MODIFIED Requirements

### Requirement: verify.sh validates MANIFEST sha256 parity in hub context

When `sdd-kit/verify.sh` runs in the distribution hub — identified by the explicit `.sdd-hub` marker at the repository root, never by the presence of `sdd-kit/templates/` — it MUST include an integrity parity check that computes the sha256 of each template file and compares it to the corresponding MANIFEST `sha256:` field. Entries without a `sha256:` field SHALL be reported as warnings. Mismatches SHALL be reported as failures and increment the failure counter.

#### Scenario: verify.sh detects stale sha256 in hub

- **WHEN** a template file was edited without regenerating checksums and `bash sdd-kit/verify.sh` is run in a repository carrying `.sdd-hub`
- **THEN** the parity check reports a FAIL for the affected entry and the script exits non-zero

#### Scenario: verify.sh skips parity check in consumer repos

- **WHEN** `bash sdd-kit/verify.sh` is run in a repository without `.sdd-hub`, even when `sdd-kit/templates/` is present (whole-kit acquisition)
- **THEN** the parity check step is recorded as a skip for a legitimately absent subject and does not affect the exit code

### Requirement: verify.sh gates hub live-scripts parity with kit templates

In hub context — identified by the explicit `.sdd-hub` marker at the repository root, never by the presence of `sdd-kit/templates/` — `sdd-kit/verify.sh` MUST compare each live `scripts/<name>.sh` that has a counterpart at `sdd-kit/templates/scripts/<name>.sh` and report a failure when the two differ, so hub↔template drift cannot pass verification silently. Scripts without a template counterpart are exempt.

#### Scenario: Drifted script fails hub verification

- **WHEN** `scripts/verify-task-patterns.sh` differs from `sdd-kit/templates/scripts/verify-task-patterns.sh` and `bash sdd-kit/verify.sh` runs in a repository carrying `.sdd-hub`
- **THEN** verify reports the drifted pair as a failure and exits non-zero

#### Scenario: Consumer repos are unaffected

- **WHEN** `bash sdd-kit/verify.sh` runs in a consumer repo without `.sdd-hub`, including one whose acquisition delivered the full `sdd-kit/templates/`
- **THEN** no parity check is attempted and no failure is reported for it

### Requirement: install.sh writes Language policy into project.md

`install.sh` MUST insert or update a `## Language policy` section in `openspec/project.md` (using anchored markers `<!-- SDD_LANGUAGE_POLICY_START -->` and `<!-- SDD_LANGUAGE_POLICY_END -->` when merging) recording the three BCP-47-style tags (`en` or `pt-BR`). Because the MANIFEST now ships a `project.md` template applied before injection, the file MUST exist by injection time in every successful install; if `openspec/project.md` is still absent when injection runs, `install.sh` MUST FAIL (exit non-zero) naming the missing file — a WARN-and-continue here converted a broken install into a reported success (per `sdd-fail-loud`).

#### Scenario: project.md exists after template apply

- **WHEN** install runs with language flags `pt-BR` / `en` / `en`
- **THEN** `openspec/project.md` contains a Language policy section with those three values between the SDD anchor markers

#### Scenario: project.md missing at injection is fatal

- **WHEN** injection runs and `openspec/project.md` does not exist (the MANIFEST entry itself failed or was removed)
- **THEN** `install.sh` exits non-zero naming `openspec/project.md`, and does not print its next-steps completion output

### Requirement: verify.sh checks language policy on consumer installs

`sdd-kit/verify.sh` MUST check that installed `AGENTS.md` has no unreplaced `{{CHAT_LANG}}`/`{{DOCS_LANG}}`/`{{CODE_LANG}}` placeholders, and — in every repository that does not carry the `.sdd-hub` marker — MUST verify that `openspec/project.md` exists and contains the `## Language policy` section with the anchored axis values. Both checks are blocking (they increment the failure counter): a missing `project.md`, or one without the policy block, is a broken install, not a note (per `sdd-fail-loud`). The check MUST NOT be skipped based on directory shape; only the explicit hub marker exempts a repository (grandfathering per `sdd-language-policy`).

#### Scenario: Verify passes on complete install

- **WHEN** `bash sdd-kit/verify.sh` runs after a successful language-aware install
- **THEN** the language policy check reports OK for both `AGENTS.md` and `openspec/project.md`

#### Scenario: Verify fails on leaked placeholder

- **WHEN** `AGENTS.md` still contains `{{DOCS_LANG}}`
- **THEN** verify reports failure for the language policy check

#### Scenario: Missing project.md fails consumer verification

- **WHEN** `bash sdd-kit/verify.sh` runs in a consumer repository (no `.sdd-hub`) where `openspec/project.md` is absent or lacks the Language policy block
- **THEN** verify reports FAIL for the language policy check and exits non-zero

### Requirement: Guide documents project organization and scenarios

`doc/byebyevibe-guide.md` MUST include section **§1.6** (or equivalent numbered section) documenting: four-layer model (procedure / payload / specs / workspace state), scenarios C1 (greenfield), C2 (SDD upgrade), C2b (CLI-only), C3 (spec propagation without SDD reinstall), and the profile model with **two active profiles** (APP, DOCS_SPECS) plus HYBRID as a deprecated alias of APP. The profile block MUST be written as canonical lay-language decision copy framed by the question "Will this repository hold application code?" and MUST state: (1) every profile installs the complete framework — profiles only adjust the AGENTS.md command table and a few stack-specific rule files; (2) the hub's `openspec/` specs and development history are ByeByeVibe's own and are never copied to the target project, which grows its own `openspec/` state — while the **operator guide (`doc/byebyevibe-guide.md`) is delivered** to every install, restoring the kit's founding design (2026-06-17) and reverting the 2026-08-05 non-distribution decision; (3) the profile question is independent of the language-axes question (`sdd-language-policy`). §1.6 MUST also include a canonical **install-scope table** distinguishing: machine scope (CLIs and MCP config, installed once per machine), repo-copied scope (payload applied by `install.sh` per project), and repo-generated scope (`openspec/`, `graphify-out/`, `.gitnexus/` — born inside each project, never shared between projects). §1.6 MUST document the **hub→destination flow** as the canonical multi-project UX: one hub clone per machine, and installation into any target project via `bash <hub>/scripts/bootstrap-sdd.sh <target-repo> --profile <PROFILE>`. §1.6 MUST state that per-project reinstallation covers only the repo-copied payload — machine-level CLIs are never reinstalled per project. Other surfaces (kit README, day-1 doc, banners) MUST NOT duplicate the scope table or the full profile copy; a short summary of at most three sentences plus a link to §1.6 is permitted.

#### Scenario: Human reads installation scenarios

- **WHEN** an operator opens the canonical guide before first install
- **THEN** §1.6 lists entry commands for each scenario and states that payloads come from `sdd-kit/`, not markdown extraction

#### Scenario: Agent reads installation scenarios

- **WHEN** an agent is prompted to install SDD in a foreign repository
- **THEN** the guide directs it to `sdd-kit/install.sh` with profile flag rather than extracting §12 code blocks for scripts

#### Scenario: Guide-delivery statement replaces the blanket exclusion

- **WHEN** an operator reads the §1.6 profile copy after this change
- **THEN** it states that hub specs/history are never copied while the operator guide is delivered to every install, and no surface still claims the target "never receives" the guide

### Requirement: install.sh emits optional add-ons teaser without installing them

`sdd-kit/install.sh` MUST append an optional add-ons teaser after its standard next-steps output. For each optional module (UI, Probity, Metrics) the teaser MUST use the lay decision formula — what you get if you install it, followed by an explicit "skip if…" condition — rather than bare module names and guide-section numbers. CI gates MUST NOT be presented as an installable module: the teaser MUST state it is a manual GitHub step (branch protection), and when `git remote -v` reports no remote it MUST say the gates are inert until the repository has a GitHub remote. Commands printed MUST resolve against the kit location that ran the install (no dead local paths). The teaser MUST NOT call `install-ui-module.sh`, `install-probity-module.sh`, or otherwise auto-install optional modules. Teaser language MUST follow the resolved `chat_language` when available.

#### Scenario: Successful install shows lay-formula teaser

- **WHEN** `bash sdd-kit/install.sh --profile APP` completes file copy and prints next steps
- **THEN** stdout includes, per module, an "install it and get…" sentence and a "skip if…" condition, and exit code remains success

#### Scenario: Teaser does not invoke UI installer

- **WHEN** the optional add-ons teaser is printed
- **THEN** `install-ui-module.sh` is not executed as part of that `install.sh` run

#### Scenario: Missing remote is named for CI gates

- **WHEN** the install completes in a repository with no git remote configured
- **THEN** the teaser states that CI gates require a GitHub remote and branch protection (manual step) and does not list CI gates as an installable module

### Requirement: Kit scripts resolve a Python interpreter by capability

Every kit script that invokes Python MUST obtain its interpreter from a single resolution result rather than hardcoding the command name `python3`. Resolution MUST try, in order, `python3`, `python3.14`, `python3.13`, `python`, `py -3`, and `/usr/bin/python3`, and MUST accept the first candidate that reports a Python version at or above the kit's declared floor. The version-suffixed rungs exist because on macOS the unsuffixed `python` is absent and `py` does not exist, leaving the previous cascade single-rung there; `/usr/bin/python3` is last because on macOS it may be the Xcode CLT shim, which the execution probe rejects but which is the slowest candidate to probe.

Resolution MUST validate the **version**, not the presence of the name: a candidate is accepted only if executing it yields a parseable `sys.version_info`. Presence alone is insufficient evidence, because `python` may be Python 2 and, on Windows, an installed-looking `python3` may be an application-execution alias that is not an interpreter at all.

The kit's floor is **Python 3.8**, declared in the install guide's prerequisites table and enforced by the resolver's version probe — those two sites and this requirement MUST agree on the number. The floor MUST be declared independently of the floor any bundled or optional integration requires. The kit MUST NOT refuse to run on an interpreter that satisfies its own floor merely because a separate component declares a higher one.

Because one accepted candidate (`py -3`) is a two-word command, resolution MUST yield candidate strings as given (never canonicalised filesystem resolutions of them), and call sites MUST expand the result in a way that preserves word splitting. The resolved command MUST reach every consumer: a check that certifies an interpreter and then executes a different, hardcoded name has verified nothing. Scripts invoked outside the install flow MUST honour an externally supplied resolution when one is provided — treating it as trusted rather than re-probing it — and otherwise resolve by the same candidate order.

When no candidate satisfies the floor, the failure message MUST name every candidate that was tried and the floor that was required, so an operator with a working Python under a different name can tell that the problem is the name and not the absence of Python.

#### Scenario: Interpreter available only as `python`

- **WHEN** a kit script runs on a host where `python3` is absent but `python` reports a version at or above the kit floor
- **THEN** the script resolves and uses `python`, and completes normally

#### Scenario: macOS with only a version-suffixed interpreter

- **WHEN** a kit script runs on a host where neither `python3` nor `python` resolves but `python3.13` reports a version at or above the kit floor
- **THEN** the script resolves and uses `python3.13`, and completes normally

#### Scenario: A name that is not an interpreter is rejected

- **WHEN** a candidate command exists on PATH but does not yield a parseable `sys.version_info` when executed, and a later candidate does
- **THEN** the reported resolution names the later candidate and its version, so the rejection of the earlier one is observable in which command was selected

#### Scenario: The certified interpreter is the executed interpreter

- **WHEN** resolution selects a candidate other than `python3` and the script proceeds past its runtime check
- **THEN** every subsequent Python invocation in that script uses the selected candidate, and no invocation of the literal name `python3` remains on the executed path

#### Scenario: Failure names the candidates and the floor

- **WHEN** no candidate satisfies the floor
- **THEN** the script exits non-zero with a message naming each candidate tried and the required floor, and does not report a version for a candidate it could not execute

### Requirement: The Python-to-shell boundary preserves data

Where a kit script consumes Python output through a shell `read` loop, the boundary MUST NOT allow a carriage return emitted by the interpreter to become part of a parsed field. This is required because Python translates line endings on standard output on some platforms, and a trailing carriage return on the final field is invisible in error output — a corrupted value and a correct value print identically.

The transport for that output MUST be a temporary file, not process substitution: the interpreter writes its list to a temp file, the script checks the interpreter's exit status explicitly and aborts non-zero on failure, and only then reads the file in the `read` loop. This is required for two independent reasons: process substitution does not propagate the producer's exit code (a failed generation would read as an empty, "successful" list — per `sdd-fail-loud`), and a heredoc nested inside process substitution is reported broken on the bash 3.2 that macOS ships. The construct is chosen by construction, not by probing the shell version.

Where a kit script uses Python to rewrite an existing file, the rewrite MUST preserve the file's original line endings. Reading and writing MUST both suppress newline translation, so that editing a small region of a file does not rewrite every line of it.

These two obligations MUST be satisfied by different means. Deleting carriage returns is permitted only on a metadata stream whose fields cannot legitimately contain one; it MUST NOT be applied to file content, where it would silently destroy the original line endings.

#### Scenario: Integrity check is not defeated by a line ending

- **WHEN** an interpreter that translates line endings feeds the template list to `install.sh`
- **THEN** the checksum comparison for each template succeeds against the MANIFEST value, and no template is reported as mismatched when its bytes match

#### Scenario: Failed list generation aborts instead of emptying

- **WHEN** the interpreter invocation that produces the template list exits non-zero
- **THEN** the consuming script exits non-zero naming the failed generation, and does not proceed with an empty list

#### Scenario: No heredoc-inside-process-substitution remains

- **WHEN** `sdd-kit/install.sh`, `sdd-kit/upgrade.sh`, `scripts/sdd-upgrade-diff.sh`, and their template mirrors are searched for `read` loops fed by `< <(` process substitution around an interpreter heredoc
- **THEN** no such construct remains; each site reads from a temporary file whose producer's exit status was checked

#### Scenario: A small edit produces a small diff

- **WHEN** a kit script rewrites a region of an existing file whose line endings are CRLF
- **THEN** only the edited lines differ, and the file's remaining lines keep their original endings

#### Scenario: File content keeps its carriage returns

- **WHEN** a kit script rewrites a file that legitimately contains carriage returns in its content
- **THEN** those carriage returns survive the rewrite

### Requirement: Guide documents a release-download acquisition recipe

`doc/byebyevibe-guide.md` MUST include a concrete, copy-pasteable command sequence that acquires the install footprint from the **latest published GitHub Release** without cloning the repository, and that results in the fetched paths landing at their real relative locations so the existing documented command `bash scripts/bootstrap-sdd.sh --profile <PROFILE>` runs unmodified afterward.

The recipe MUST resolve the current release without the downloader knowing its version number in advance, MUST verify the downloaded archive against its published `.sha256` sidecar **before** extracting it, and MUST fail loudly rather than silently produce a corrupt or partial result when an asset is missing. The verification step MUST be portable across both hashing toolchains the target platforms ship: it MUST work with either `sha256sum` or `shasum -a 256`, and MUST NOT depend on the `-c` flag of any specific implementation — the recipe compares the sidecar's expected digest against a computed digest explicitly and aborts on mismatch. It MUST rely only on tooling already required by guide §1.1 and MUST NOT introduce a new mandatory dependency — in particular it MUST NOT require an authenticated CLI.

#### Scenario: Version is not needed in advance

- **WHEN** an operator follows the release-download recipe without knowing which version is current
- **THEN** the recipe resolves the latest release on its own, and the operator is never asked to substitute a version number into a URL

#### Scenario: Checksum verification precedes extraction

- **WHEN** the release-download recipe is followed
- **THEN** the archive's checksum is verified against the published sidecar before the archive is extracted, and a mismatch stops the procedure

#### Scenario: Verification works without GNU-specific flags

- **WHEN** the recipe's verification step runs on a host that has `shasum` but whose `sha256sum` (if present) may not support `-c`
- **THEN** the step still verifies the archive against the sidecar and fails loudly on mismatch, using explicit digest comparison

#### Scenario: Missing asset fails loudly

- **WHEN** the recipe is followed against a release that does not carry the expected asset
- **THEN** the download step exits non-zero and no error page or partial file is left in place of the archive, so the failure is not misreported later as a corrupt archive

#### Scenario: Recipe lands the documented footprint

- **WHEN** the release-download recipe completes against a target repository that has no `sdd-kit/` yet
- **THEN** the target repository ends up with `sdd-kit/`, `scripts/bootstrap-sdd.sh`, and `scripts/preflight-sdd.sh` populated at their real relative locations, and no hub-only `doc/`, `openspec/`, `.cursor/`, or `.claude/` content is written

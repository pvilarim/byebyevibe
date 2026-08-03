# Delta: sdd-install-kit — clarify-install-scope-ux

## MODIFIED Requirements

### Requirement: Guide documents project organization and scenarios

`doc/byebyevibe-guide.md` MUST include section **§1.6** (or equivalent numbered section) documenting: four-layer model (procedure / payload / specs / workspace state), scenarios C1 (greenfield), C2 (SDD upgrade), C2b (CLI-only), C3 (spec propagation without SDD reinstall), and profile differences APP / DOCS_SPECS / HYBRID. §1.6 MUST also include a canonical **install-scope table** distinguishing: machine scope (CLIs and MCP config, installed once per machine), repo-copied scope (payload applied by `install.sh` per project), and repo-generated scope (`openspec/`, `graphify-out/`, `.gitnexus/` — born inside each project, never shared between projects). §1.6 MUST document the **hub→destination flow** as the canonical multi-project UX: one hub clone per machine, and installation into any target project via `bash <hub>/scripts/bootstrap-sdd.sh <target-repo> --profile <PROFILE>`. §1.6 MUST state that per-project reinstallation covers only the repo-copied payload — machine-level CLIs are never reinstalled per project. Other surfaces (kit README, day-1 doc, banners) MUST NOT duplicate the scope table; a short summary of at most three sentences plus a link to §1.6 is permitted.

#### Scenario: Human reads installation scenarios

- **WHEN** an operator opens the canonical guide before first install
- **THEN** §1.6 lists entry commands for each scenario and states that payloads come from `sdd-kit/`, not markdown extraction

#### Scenario: Agent reads installation scenarios

- **WHEN** an agent is prompted to install SDD in a foreign repository
- **THEN** the guide directs it to `sdd-kit/install.sh` with profile flag rather than extracting §12 code blocks for scripts

#### Scenario: Operator learns install scopes before second project

- **WHEN** an operator reads §1.6 asking whether a second project requires full reinstallation
- **THEN** the install-scope table shows machine-once vs repo-copied vs repo-generated scope, and the hub→destination command shows how to install into a new target folder with one command

#### Scenario: Scope table is single-sourced

- **WHEN** any other canonical surface (kit README, day-1 doc) mentions install scope
- **THEN** it links to guide §1.6 with at most a three-sentence summary, without duplicating the full table

## ADDED Requirements

### Requirement: bootstrap-sdd.sh skips already-installed machine-level package installs

`bootstrap-sdd.sh` MUST guard only its package-manager install commands behind a `command -v` presence check: `npm install -g @fission-ai/openspec@latest` (guard `openspec`), `npm install -g gitnexus` (guard `gitnexus`), and the uv installer plus `uv tool install graphifyy` (guards `uv` and `graphify`). When the guarded tool is present, the script MUST print a skip notice naming the tool (with detected version when `<tool> --version` succeeds) and MUST NOT re-run that install command. Skip notices are phase-level diagnostics: they MUST print regardless of TTY state and `--quiet` (same output class as phase markers). All other bootstrap steps MUST run unconditionally regardless of any skip, because they are idempotent and/or repo-scoped: `openspec init`, `gitnexus setup`, `gitnexus analyze`, `graphify install`, `graphify install --platform cursor`, `graphify hook install`, and `graphify update .`. When `openspec` is present, the script MUST compare its detected version against MANIFEST `min_openspec` and emit a WARN naming scenario C2b when the detected version is older (comparison failure degrades to a notice, never an abort). CLI refresh remains scenario C2b and MUST NOT be triggered implicitly by bootstrap.

#### Scenario: CLI already present is skipped

- **WHEN** `bootstrap-sdd.sh` runs (any TTY/quiet mode) on a machine where `openspec` is already on PATH
- **THEN** stdout contains a skip notice for OpenSpec, no `npm install -g` runs for it, and `openspec init` still executes for the target repo

#### Scenario: Repo-scoped Graphify steps survive the guard

- **WHEN** `bootstrap-sdd.sh` runs on a machine where `graphify` is already on PATH
- **THEN** `uv tool install` is skipped but `graphify install`, `graphify hook install`, and `graphify update .` still execute for the target repo

#### Scenario: Missing CLI is installed

- **WHEN** `bootstrap-sdd.sh` runs on a machine where `gitnexus` is not on PATH
- **THEN** the GitNexus install phase runs as in the pre-change behavior

#### Scenario: Stale OpenSpec triggers C2b warning

- **WHEN** the detected `openspec` version is older than MANIFEST `min_openspec`
- **THEN** the script emits a WARN pointing to scenario C2b and continues

### Requirement: bootstrap-sdd.sh resolves preflight and kit from its own source repo

When the target repo lacks `scripts/preflight-sdd.sh` and `sdd-kit/templates/scripts/preflight-sdd.sh`, `bootstrap-sdd.sh` MUST fall back to the corresponding script under its own source root (the repo containing the running script, resolved from the script's own path). When the target repo lacks `sdd-kit/install.sh`, the script MUST run the source root's `sdd-kit/install.sh` with `--repo <target>` instead of warning and skipping the payload phase. Target-local copies MUST take precedence when present. When neither the target nor the source root provides the needed file, the existing error/warning behavior applies.

#### Scenario: Greenfield target installs payload from hub

- **WHEN** `bash <hub>/scripts/bootstrap-sdd.sh <greenfield-target> --profile APP` runs and the target has no `sdd-kit/`
- **THEN** preflight and `install.sh` resolve from the hub clone, and the target receives the payload copy in one command

#### Scenario: Target-local kit wins

- **WHEN** the target repo carries its own `sdd-kit/install.sh`
- **THEN** bootstrap uses the target's copy, preserving consumer self-bootstrap behavior

### Requirement: Kit README scenarios table documents install scope

The scenarios table in `sdd-kit/README.md` MUST carry a scope column with these row values: C1 = `machine + repo`; C2b = `machine`; C2, C3, C1-UI, G2, and G4 = `repo`. The first-contact section MUST state in one line that CLIs install once per machine while each repo receives its own payload copy, linking to guide §1.6 for the full model.

#### Scenario: Newcomer sees scope at first contact

- **WHEN** a newcomer reads the `sdd-kit/README.md` scenarios table
- **THEN** each scenario row shows its enumerated scope value (C1 showing both scopes), and a link to guide §1.6 provides the full scope model

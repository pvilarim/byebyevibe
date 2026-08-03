# Delta: sdd-install-kit — clarify-install-scope-ux

## MODIFIED Requirements

### Requirement: Guide documents project organization and scenarios

`doc/byebyevibe-guide.md` MUST include section **§1.6** (or equivalent numbered section) documenting: four-layer model (procedure / payload / specs / workspace state), scenarios C1 (greenfield), C2 (SDD upgrade), C2b (CLI-only), C3 (spec propagation without SDD reinstall), and profile differences APP / DOCS_SPECS / HYBRID. §1.6 MUST also include a canonical **install-scope table** distinguishing: machine scope (CLIs and MCP config, installed once per machine), repo-copied scope (payload applied by `install.sh` per project), and repo-generated scope (`openspec/`, `graphify-out/`, `.gitnexus/` — born inside each project, never shared between projects). §1.6 MUST document the **hub→destination flow** as the canonical multi-project UX: one hub clone per machine, and installation into any target project via `bash <hub>/scripts/bootstrap-sdd.sh <target-repo> --profile <PROFILE>`. §1.6 MUST state that per-project reinstallation covers only the repo-copied payload — machine-level CLIs are never reinstalled per project. Other surfaces (kit README, day-1 doc, banners) MUST link to or summarize §1.6 in at most one line rather than duplicating the scope table.

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
- **THEN** it links to guide §1.6 or summarizes it in at most one line, without duplicating the full table

## ADDED Requirements

### Requirement: bootstrap-sdd.sh skips already-installed machine-level CLIs

`bootstrap-sdd.sh` MUST check for the presence of each machine-level CLI (`openspec`, `gitnexus`, `graphify`) via `command -v` before installing it. When the CLI is present, the script MUST print a skip notice including the detected tool (and version when cheaply available) and MUST NOT re-run the global install for that tool. Per-repo steps (`openspec init`, `gitnexus analyze`, `graphify update .`) MUST still run regardless of the skip. When the CLI is absent, installation proceeds as before. CLI refresh remains scenario C2b and MUST NOT be triggered implicitly by bootstrap.

#### Scenario: CLI already present is skipped

- **WHEN** `bootstrap-sdd.sh` runs on a machine where `openspec` is already on PATH
- **THEN** stdout contains a skip notice for OpenSpec, no `npm install -g` runs for it, and `openspec init` still executes for the target repo

#### Scenario: Missing CLI is installed

- **WHEN** `bootstrap-sdd.sh` runs on a machine where `gitnexus` is not on PATH
- **THEN** the GitNexus install phase runs as in the pre-change behavior

### Requirement: Kit README scenarios table documents install scope

The scenarios table in `sdd-kit/README.md` MUST carry a scope column (values such as `machine` / `repo`) indicating where each scenario acts, and the first-contact section MUST state in one line that CLIs install once per machine while each repo receives its own payload copy, linking to guide §1.6 for the full model.

#### Scenario: Newcomer sees scope at first contact

- **WHEN** a newcomer reads the `sdd-kit/README.md` scenarios table
- **THEN** each scenario row shows whether it acts at machine or repo scope, and a link to guide §1.6 provides the full scope model

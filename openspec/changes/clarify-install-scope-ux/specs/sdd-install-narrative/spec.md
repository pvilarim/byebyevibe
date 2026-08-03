# Delta: sdd-install-narrative — clarify-install-scope-ux

## MODIFIED Requirements

### Requirement: Canonical S-layer copy for core tools

The guide and runtime banners/teasers MUST use the refined What / Why now / “Without it…” / You’ll get meanings locked in design D3 for OpenSpec, GitNexus, Graphify, and sdd-kit. Apply MUST NOT invent alternate slogans for these four tools. The sdd-kit row MUST appear in §2.1 (pillars + kit bridge) and/or the install-kit phase narrative/teaser — not only in scripts. Runtime banners MUST additionally carry a third **Scope** line per tool, in both `en` and `pt-BR` string sets: for OpenSpec, GitNexus, and Graphify the Scope line states the tool installs once on the machine and future projects reuse it; for sdd-kit the Scope line states the payload is copied into the current repo and each project receives its own copy. Scope lines MUST match actual bootstrap behavior (machine-level CLIs already present are skipped, per `sdd-install-kit`).

#### Scenario: OpenSpec without-it appears in guide

- **WHEN** the OpenSpec step narrative is rendered in the versioned guide
- **THEN** it states that without OpenSpec, chat turns into code and nobody remembers why (EN wording per design D3)

#### Scenario: Guide OpenSpec What line matches D3

- **WHEN** the OpenSpec step S-layer is rendered in the versioned guide
- **THEN** it presents OpenSpec as the playbook for a change (think → agree → do → keep a record) per design D3 EN What column

#### Scenario: Runtime pt-BR uses Sem ela drafts

- **WHEN** a TTY banner or install teaser runs with `chat_language` (or `--chat-lang` / `SDD_CHAT_LANG`) equal to `pt-BR`
- **THEN** the corresponding “Sem ela…” strings from design D3 are used for those four tools

#### Scenario: Kit without-it visible in guide narrative

- **WHEN** an operator reads §2.1 or the sdd-kit phase description in the install path
- **THEN** they see that without sdd-kit, every repo invents the process from scratch (EN wording per design D3)

#### Scenario: Machine-scope tools show install-once Scope line

- **WHEN** the OpenSpec, GitNexus, or Graphify banner renders on a TTY (either language)
- **THEN** it includes a Scope line stating the tool installs once on the machine and is reused by future projects

#### Scenario: Kit banner shows per-repo Scope line

- **WHEN** the sdd-kit banner renders on a TTY (either language)
- **THEN** it includes a Scope line stating the payload is copied into this repo and each project gets its own

## ADDED Requirements

### Requirement: Bootstrap completion message states per-project state and next-project command

At the end of a successful run, `bootstrap-sdd.sh` MUST print a completion message (respecting `--quiet` / non-TTY suppression rules for didactic output) stating: (a) that this project's durable state now lives in `openspec/`, `graphify-out/`, and `.gitnexus/` inside the project folder and is never shared between projects; and (b) that installing into the next project takes the same single command with a new target path (`bash <hub>/scripts/bootstrap-sdd.sh <target-repo> --profile <PROFILE>`). Both `en` and `pt-BR` string sets MUST be provided.

#### Scenario: Completion message names per-project state

- **WHEN** `bootstrap-sdd.sh` completes successfully on a TTY without `--quiet`
- **THEN** stdout names `openspec/`, `graphify-out/`, and `.gitnexus/` as this project's own state

#### Scenario: Completion message teaches the next-project command

- **WHEN** `bootstrap-sdd.sh` completes successfully on a TTY without `--quiet`
- **THEN** stdout shows the hub→destination command pattern for installing into another project folder

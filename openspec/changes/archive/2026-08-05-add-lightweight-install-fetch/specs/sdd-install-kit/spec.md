## ADDED Requirements

### Requirement: Guide documents minimal install-fetch footprint

`doc/byebyevibe-guide.md` MUST state, in §1.6 or an adjacent subsection, the exact minimal set of repository paths required and sufficient for a genuine C1 greenfield install: the whole `sdd-kit/` subtree plus the root-level `scripts/bootstrap-sdd.sh` and `scripts/preflight-sdd.sh`. The statement MUST note that no other repository path (including hub-only `doc/`, hub-only `openspec/`, or root `.cursor/`/`.claude/`) is read by `install.sh` or by the bootstrap/preflight scripts during C1.

#### Scenario: Operator or agent looks up the minimal footprint

- **WHEN** a reader opens guide §1.6 (or the adjacent subsection) before a greenfield install
- **THEN** they find the three required paths named explicitly, with a statement that no other hub path is required for C1

### Requirement: Guide documents a lightweight no-full-clone fetch recipe

`doc/byebyevibe-guide.md` MUST include at least one concrete, copy-pasteable command sequence that fetches only the minimal install-fetch footprint (per the previous requirement) into a target repository without cloning the full hub repository, and that results in the fetched paths landing at their real relative locations so the existing documented command `bash scripts/bootstrap-sdd.sh --profile <PROFILE>` runs unmodified afterward. The recipe MUST rely only on tooling already required by guide §1.1 (git) and MUST NOT introduce a new mandatory dependency.

#### Scenario: Recipe fetches only the required paths

- **WHEN** the documented lightweight-fetch recipe is followed against a target repository that has no `sdd-kit/` yet
- **THEN** the target repository ends up with `sdd-kit/`, `scripts/bootstrap-sdd.sh`, and `scripts/preflight-sdd.sh` populated, and no hub-only `doc/`, `openspec/`, `.cursor/`, or `.claude/` content is fetched

#### Scenario: Recipe is scoped to greenfield installs only

- **WHEN** the lightweight-fetch recipe is documented
- **THEN** the guide states it applies only when `sdd-kit/` is not already present in the target repository (C1), and does not apply to C2 (upgrade, which requires the existing `sdd-kit/upgrade.sh --dry-run`/`--apply` flow) or C3 (spec propagation, which must not run `install.sh`/`upgrade.sh`)

### Requirement: AI-assisted install prompt defaults to lightweight fetch

The §2.0 AI-assisted installation prompt in `doc/byebyevibe-guide.md` MUST instruct the agent to use the lightweight no-full-clone fetch recipe by default when installing into a genuine greenfield target repository, and MUST reserve a full hub clone for cases where the operator explicitly wants the persistent multi-project hub→destination workflow (per `clarify-install-scope-ux`, guide §1.6).

#### Scenario: Agent prompt names the lightweight fetch first

- **WHEN** an agent follows the §2.0 AI-assisted installation prompt for a target repository with no existing `sdd-kit/`
- **THEN** the prompt directs it to the lightweight-fetch recipe before mentioning a full hub clone, and names the full clone only as the alternative for persistent multi-project reuse

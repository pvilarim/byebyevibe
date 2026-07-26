# sdd-issue-traceability Specification

## Purpose

Normative requirements for traceability between GitHub Issues, OpenSpec changes, and pull requests. Combines a passive `github-mcp-server` MCP (mode D) for issue context during explore/propose with a mandatory `**Issue:**` field in change proposals.

## Requirements

### Requirement: Issue field in proposal template

Every new OpenSpec change proposal MUST include a `**Issue:**` field in `proposal.md`, populated from the sdd-kit template scaffold. The field MUST accept one of:

- A full GitHub Issue URL (e.g. `https://github.com/org/repo/issues/123`)
- A short reference (e.g. `#123`)
- An em dash (`—`) when no GitHub Issue exists or the change was born from a direct prompt

The field MUST be present in `sdd-kit/templates/openspec/changes/_template/proposal.md` for all profiles (APP, DOCS_SPECS, HYBRID).

#### Scenario: Proposal created from GitHub Issue

- **WHEN** an agent runs `/opsx:propose` for work originating from issue #42
- **THEN** `proposal.md` contains `**Issue:** #42` or the full issue URL

#### Scenario: Proposal created from direct prompt

- **WHEN** an agent runs `/opsx:propose` without a linked GitHub Issue
- **THEN** `proposal.md` contains `**Issue:** —`

### Requirement: github-mcp-server as passive MCP for issue context

The workspace MUST document `github-mcp-server` (official GitHub) in `openspec/infra.md` as a passive MCP (mode D). The agent MUST consult it when relevant during explore and propose phases. The MCP MUST NOT intercept edits, MUST NOT add a new interactive pipeline step, and MUST NOT be invoked for trivial tasks (type A).

#### Scenario: Bug fix framing with issue context

- **WHEN** an agent classifies a task as type B and the change has an Issue reference
- **THEN** the agent consults github-mcp to read the originating issue (title, body, acceptance criteria) before writing `proposal.md`

#### Scenario: Feature proposal with issue validation

- **WHEN** an agent runs `/opsx:propose` for a type D task linked to an issue
- **THEN** the agent consults github-mcp to validate proposal scope against the issue's acceptance criteria

#### Scenario: Exploration research with related issues

- **WHEN** an agent conducts type E exploration on a topic with open GitHub Issues
- **THEN** the agent MAY consult github-mcp to read related issues and avoid duplicate changes

#### Scenario: Trivial task does not consult MCP

- **WHEN** an agent classifies a task as type A
- **THEN** the agent MUST NOT consult github-mcp for issue context

### Requirement: MCP configuration with minimum scope

Documentation for github-mcp-server MUST specify minimum scope configuration: `--toolsets issues` where supported, read-only access where the MCP client allows it, and version pin (v1.7.0 for local binary/Docker). Tokens MUST NEVER be committed to the repository.

#### Scenario: Operator installs MCP locally

- **WHEN** an operator follows `doc/sistema-sdd-pedro.md` §2.14 to install github-mcp
- **THEN** the documented configuration limits toolsets to issues and uses OAuth or a token stored only in `~/.cursor/mcp.json`

#### Scenario: Agent reads infra before reinstalling

- **WHEN** `openspec/infra.md` lists github-mcp-server as ✅
- **THEN** the agent uses the MCP directly without web-searching setup guides (R10)

### Requirement: Six-point contract registration

The github-mcp-server integration MUST be registered in all six contract points defined in `metodologia-insercao.md` Fase 3: `openspec/infra.md` (R1), `AGENTS.md` (R2), optional skill (R3 — prefer AGENTS.md if ≤10 lines suffice), `doc/sistema-sdd-pedro.md` §2.14 (R4), `doc/avaliacoes/` (R5), and `sdd-kit/templates/` (R6).

#### Scenario: Agent discovers github-mcp usage rules

- **WHEN** an agent reads `AGENTS.md` Integrações section
- **THEN** it finds ≤10 lines describing when to consult github-mcp by task type (A–E)

#### Scenario: Operator finds human operation guide

- **WHEN** an operator needs to install, verify, or disable github-mcp
- **THEN** `doc/sistema-sdd-pedro.md` §2.14 provides step-by-step instructions including troubleshooting and rollback

# sdd-install-kit Specification (delta)

## ADDED Requirements

### Requirement: Kit README includes discovery positioning for newcomers

`sdd-kit/README.md` MUST begin with (or include near the top, before operational scenario tables) a short positioning section that: (1) states what the kit is in plain language for newcomers arriving from vibe coding / AI-assisted workflows; (2) maps internal scenario codes (at least C1, C2, C3) to human-readable names; and (3) points to the hub root `README.md` and/or the canonical guide for first contact. Operational sections (profiles, commands, structure, CI gates) MUST remain present.

#### Scenario: Newcomer reads kit README first

- **WHEN** a newcomer opens `sdd-kit/README.md` without prior SDD jargon
- **THEN** they see a positioning/intro section and a human-readable mapping for C1/C2/C3 before or alongside the operational tables

#### Scenario: Operational content retained

- **WHEN** `sdd-kit/README.md` is updated for discovery framing
- **THEN** it still documents install/upgrade entry commands and profiles (APP, DOCS_SPECS, HYBRID)

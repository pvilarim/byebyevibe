# sdd-discovery-positioning Specification (delta)

## MODIFIED Requirements

### Requirement: Root README v2 section order and above-fold value

The root `README.md` MUST follow the discovery section order for first-contact visitors: (1) hero with **ByeByeVibe** H1, approved tagline, dual naming (`sdd-kit/` payload), and the phrase that the project is an **installable toolkit for AI-assisted development**; (2) a **Why install this** (or equivalent) subsection with at least four value bullets appearing **before** the Get started CTA; (3) explicit anti-boilerplate / control-plane disclaimer in the above-fold block; (4) Get started with copy-pasteable `sdd-kit/install.sh` dry-run command. Subsequent sections MUST include, in order: The problem; Core tools; User-friendly OpenSpec; Demo; Optional modules; Calibrate as you go; Not another starter kit; Who it's for; Stack & docs; manual About/topics checklist; Maintainer. A dedicated Compare section is NOT required (removed in v3); the competitive evaluation document MUST remain linked from the Docs table (or equivalent docs listing).

#### Scenario: Value bullets appear before install CTA

- **WHEN** a visitor reads the root README from the top
- **THEN** a "Why install" (or equivalent) value subsection with at least four bullets appears before the "Get started" install command block

#### Scenario: Toolkit phrase is explicit

- **WHEN** a visitor reads the opening of the root README
- **THEN** the README states that ByeByeVibe is an installable toolkit for AI-assisted development (Cursor and Claude Code)

#### Scenario: AI-assisted development wording present

- **WHEN** the root README opening is searched for discovery keywords
- **THEN** it contains the phrase "AI-assisted development" (case-insensitive)

#### Scenario: Compare section absent but evaluation doc still linked

- **WHEN** the root README is read after v3
- **THEN** no "Compare (summary)" section is present and the Docs table (or equivalent) still links `doc/avaliacoes/2026-07-26-sdd-discovery-positioning.md` (or its successor path)

## ADDED Requirements

### Requirement: Root README names gap-aware detection with offer-only framing

The root README MUST mention the control plane's proactive gap-detection mechanisms — skill suggestion on repeated re-teaching of domain facts (`sdd-skill-guidance`) and tooling suggestion / static gap-check for CLI/MCP integrations (`sdd-tooling-guidance`, `scripts/verify-infra.sh`) — and MUST frame them as offer-only: no skill is created and no integration is installed without operator decision. The README MUST NOT present these mechanisms as machine learning, self-learning, or automatic adaptation (same register as the G4 no-ML-claims constraint).

#### Scenario: Gap-aware content present

- **WHEN** the root README is read
- **THEN** it references both the skill-suggestion mechanism and the tooling gap-check (e.g. `verify-infra.sh`), in a value bullet, the Calibrate section, or both

#### Scenario: Offer-only framing enforced

- **WHEN** the gap-aware content is read
- **THEN** it states that suggestions are offers (no auto-create / auto-install) and contains no ML or self-learning claims

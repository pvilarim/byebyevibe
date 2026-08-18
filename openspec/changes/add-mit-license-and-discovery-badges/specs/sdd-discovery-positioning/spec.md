## ADDED Requirements

### Requirement: Hub ships an MIT LICENSE file

The hub repository MUST include a root file named `LICENSE` (no extension) containing the canonical MIT License text and a copyright line for **Pedro Vilarim** and year **2026**. The file MUST NOT embed a third-party license table or any non-MIT legal text. GitHub SPDX detection of MIT is the intended outcome.

#### Scenario: LICENSE is present and MIT

- **WHEN** a visitor opens the hub repository root
- **THEN** a `LICENSE` file exists whose body is the MIT License and whose copyright line names Pedro Vilarim and 2026

#### Scenario: LICENSE stays SPDX-pure

- **WHEN** the `LICENSE` file is read
- **THEN** it does not list OpenSpec, GitNexus, Graphify, or other third-party licenses inside that file

### Requirement: Hub ships NOTICE for composed-tool licenses

The hub repository MUST include a root `NOTICE.md` that states ByeByeVibe MIT does **not** relicense composed or optional tools, and MUST list at least: OpenSpec (MIT), GitNexus (PolyForm Noncommercial 1.0.0), Graphify (Apache-2.0), Probity (MIT), Impeccable (Apache-2.0), OSV-Scanner (Apache-2.0), and Renovate (AGPL-3.0), each with a link to the upstream project. The GitNexus row or accompanying sentence MUST state that GitNexus is **not MIT** and that its PolyForm Noncommercial terms do not cover commercial use of the GitNexus software. The NOTICE MUST NOT claim that `sdd-kit/` vendors GitNexus skill files.

#### Scenario: NOTICE lists core and optional tools

- **WHEN** a visitor opens `NOTICE.md`
- **THEN** they find the seven tools above with license names and upstream links, plus the GitNexus noncommercial / not-MIT caveat

#### Scenario: NOTICE does not relicense

- **WHEN** `NOTICE.md` is read
- **THEN** it states that composed tools keep their own licenses and that ByeByeVibe MIT does not replace them

### Requirement: Root README shows honest status badges only

The root README hero (after the approved tagline, before the dual-naming paragraph) MUST include three badges: latest GitHub Release for `pvilarim/byebyevibe`, the SDD Gates Actions workflow badge for `.github/workflows/sdd-gates.yml`, and a License: MIT badge linking to `LICENSE`. The root README MUST NOT display npm version, OpenSSF Scorecard, Discord, or a third-party license (including PolyForm) as if it were this repository’s license.

#### Scenario: Honest badge trio present

- **WHEN** a visitor reads the README hero
- **THEN** they see Release, SDD Gates, and License: MIT badges with the targets above

#### Scenario: Dishonest GitNexus-copy badges absent

- **WHEN** the root README is searched for badge images
- **THEN** it contains no npm-version, OpenSSF Scorecard, or Discord badge URLs

### Requirement: Discovery surfaces disclose composed-stack licenses

The root README MUST state that hub/payload files are MIT and that composed CLIs keep their own licenses, MUST point to `NOTICE.md`, and MUST name GitNexus as PolyForm Noncommercial (not MIT) in the Stack & companions area (or equivalent). The Docs table (or equivalent docs listing) MUST include rows for `LICENSE` and `NOTICE.md`. `sdd-kit/README.md` MUST include a self-contained license paragraph that names MIT for payload files and the GitNexus PolyForm Noncommercial caveat inline, so a kit-only fetch still warns operators. `sdd-kit/install.sh`, `upgrade.sh`, and `MANIFEST.yaml` MUST NOT add `LICENSE` or `NOTICE.md` as installable payload files.

#### Scenario: README points at NOTICE and names GitNexus license

- **WHEN** a visitor reads Stack & companions and the Docs table
- **THEN** they find a `NOTICE.md` pointer, Docs rows for `LICENSE` and `NOTICE.md`, and an explicit GitNexus PolyForm Noncommercial / not-MIT statement

#### Scenario: Kit README warns without the hub tree

- **WHEN** an operator reads `sdd-kit/README.md` without opening hub `NOTICE.md`
- **THEN** the file still states payload files are MIT and that GitNexus is PolyForm Noncommercial (not relicensed)

#### Scenario: Consumer install does not receive LICENSE files

- **WHEN** `sdd-kit/MANIFEST.yaml` is inspected for `LICENSE` or `NOTICE.md` payload paths
- **THEN** neither path is registered for copy/merge into a consumer repository

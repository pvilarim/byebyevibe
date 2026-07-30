#!/usr/bin/env python3
"""Generate missing translate-* OpenSpec proposes (guide W3+, design 001, kit-design 001)."""

from __future__ import annotations

import os
from datetime import date
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
CHANGES = ROOT / "openspec" / "changes"
TODAY = date.today().isoformat()

GUIDE_WAVES = [
    (1, 1, 132, "front matter + §1 Prerequisites", None),
    (2, 133, 297, "§2.0b–2.4 install core (OpenSpec, GitNexus, Graphify)", 1),
    (3, 298, 424, "§2.5–2.8 AGENTS curation + MCP + post-install checklist", 2),
    (4, 425, 621, "§2.11–2.14 UI module, CI gates, supply chain, reviews", 3),
    (5, 622, 839, "§2.15–2.17 GitHub MCP, Probity, SDD metrics", 4),
    (6, 840, 1046, "§2.9 SDD upgrade procedure", 5),
    (7, 1047, 1278, "§3–§4 task classification + master tool table", 6),
    (8, 1279, 1457, "§5–§6 docs cross-refs + research dimension", 7),
    (9, 1458, 1619, "§7–§8 task protocols + system rules overview", 8),
    (10, 1620, 1973, "§9–§10 Cursor + VS Code / Claude Code setup", 9),
    (11, 1974, 2139, "§11 code protocols", 10),
    (12, 2140, 2503, "§12.1–12.5 annex templates (project, AGENTS, design)", 11),
    (13, 2504, 2729, "§12.6–12.10 annex templates (upgrade, tasks patterns)", 12),
    (14, 2730, 2847, "§13 workshop alignment + changelog + appendix", 13),
]

DESIGN_WAVES = [
    (
        3,
        "doc/design/001-pipeline-open-design-shadcn-impeccable.md",
        1,
        325,
        "§1–§3.4 pipeline overview through DESIGN.md schema",
        2,
    ),
    (
        4,
        "doc/design/001-pipeline-open-design-shadcn-impeccable.md",
        326,
        592,
        "§4–§13 shadcn phase through history",
        3,
    ),
]

KIT_DESIGN_WAVES = [
    (
        3,
        "sdd-kit/templates/doc/design/001-pipeline-open-design-shadcn-impeccable.md",
        1,
        325,
        "kit mirror §1–§3.4",
        "translate-design-wave-3",
    ),
    (
        4,
        "sdd-kit/templates/doc/design/001-pipeline-open-design-shadcn-impeccable.md",
        326,
        592,
        "kit mirror §4–§13",
        "translate-design-wave-4",
    ),
]


def write(path: Path, content: str) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text(content, encoding="utf-8")


def openspec_yaml() -> str:
    return f"schema: spec-driven\ncreated: {TODAY}\n"


def spec_delta(change_id: str, path: str, label: str, extra: str = "") -> str:
    manifest = (
        " G-MANIFEST satisfied when kit templates change."
        if "sdd-kit/templates" in path
        else ""
    )
    return f"""## ADDED Requirements

### Requirement: {change_id} target surface is English

The following path MUST be written in English after substitution: `{path}`. Residual Portuguese prose in the substituted slice ({label}) is FORBIDDEN after apply. Dual-file siblings such as `*.en.md` or `*-pt.md` MUST NOT be introduced. Freeze-list tokens (paths, change-ids, `/opsx:*`, package pins, URLs, fenced shell, profile labels, and brand/tool names) MUST remain unaltered aside from intentional non-i18n fixes.{manifest}{extra}

#### Scenario: Per-wave verification passes

- **WHEN** an operator runs the wave gate command after apply
- **THEN** the script exits 0 (including G-PT and G-LINK on `{path}`)

#### Scenario: No dual-file migration

- **WHEN** the wave apply completes
- **THEN** English content remains at `{path}` with no permanent `*.en.md` / `*-pt.md` sibling
"""


def guide_proposal(n: int, start: int, end: int, label: str, prev: int | None) -> str:
    loc = end - start + 1
    cid = f"translate-guide-wave-{n}"
    dep_line = (
        f"- **Apply prerequisite:** `/opsx:apply` + `/opsx:archive` for `translate-guide-wave-{prev}` before applying this wave (sequential mid-file slices on the same file)"
        if prev
        else "- Dependencies: none (first guide slice; infra ✅ — `verify-i18n-wave.sh` already registered)"
    )
    if prev:
        dep_block = f"""- Dependencies: `translate-guide-wave-{prev}` apply+archive before this wave's apply (propose may merge in parallel with other disjoint waves). Infra ✅"""
    else:
        dep_block = "- Dependencies: none (infra ✅ — `verify-i18n-wave.sh` already registered; highest-priority uncovered surface per `doc/i18n/CURSOR-AUTOMATIONS.md`)"
    return f"""**Issue:** —

## Why

`doc/sistema-sdd-pedro.md` (~2847 LOC) is the canonical install guide and the highest-priority uncovered in-scope surface (W3+ in `doc/i18n/WAVES.md`). Prior waves closed entry points, kit, skills, commands, design, and evaluations; no `translate-guide-*` propose exists yet. This change covers lines **{start}–{end}** ({label}, ~{loc} LOC) — within the ≤350–400 LOC mid-file slice budget. Apply is sequential per slice on the same file; proposes for disjoint slices may merge in parallel.

## What Changes

- Replace Portuguese prose with glossary-canonical English **in-place** in `doc/sistema-sdd-pedro.md` for lines **{start}–{end}** only ({label})
- Do **not** edit lines outside this slice in the same apply session
- Preserve freeze-list tokens (paths, change-ids, `/opsx:*`, package pins, URLs, `sdd-kit/` commands, profile codes C1–C3, fenced shell, brand **ByeByeVibe**) byte-stable
- Map operator cues: `Acção`/`Acção` → Action, `[AÇÃO MANUAL]` → `[MANUAL ACTION]`, section anchors updated only when heading text is translated (keep link targets consistent — G-LINK)
- Expand `doc/i18n/GLOSSARY.md` only if this wave introduces a new SDD term not already listed
- Run `bash scripts/verify-i18n-wave.sh --files doc/sistema-sdd-pedro.md` before marking tasks done (whole-file gate; slice must leave zero PT in touched lines)

## Capabilities

### New Capabilities

- _(none — language substitution under existing `sdd-docs-language`)_

### Modified Capabilities

- `sdd-docs-language`: ADDED requirement — guide slice lines {start}–{end} of `doc/sistema-sdd-pedro.md` MUST be English after substitution; dual-file siblings forbidden; freeze-list tokens preserved.

## Impact

- Files modified: `doc/sistema-sdd-pedro.md` (lines {start}–{end} only; optional `doc/i18n/GLOSSARY.md` if new terms)
{dep_block}
- Risks: G-PT scans whole file — out-of-slice PT causes false FAIL until prior slices applied; accidental edits outside slice; broken anchor links after heading translation (G-LINK)
- **Non-goals:** lines outside {start}–{end}; `doc/curso/`; `openspec/changes/archive/`; dual-file `*.en.md` / `*-pt.md`; global G-DoD; path renames; changing install semantics — language only

## Required gates (before marking tasks done)

```bash
bash scripts/verify-i18n-wave.sh --files doc/sistema-sdd-pedro.md
```

Must pass: **G-INV**, **G-GLOSS**, **G-PT**, **G-LINK**, **G-OPENSPEC**.  
N/A: **G-MIRROR**, **G-MANIFEST**. **G-DoD** only after all guide slices + other waves.

**G-SMOKE (advisory):** human confirms 3 critical procedures in this slice remain executable from EN text.

## Freeze / allowlist checklist

- [ ] Shell/CI fences byte-stable
- [ ] Paths, change-ids, `/opsx:*`, pins, URLs, profile codes untouched
- [ ] Edits confined to lines {start}–{end}
- [ ] Glossary forms used; no dual-file siblings
- [ ] Relative links and anchors still resolve (G-LINK)

## Session Handoff stub

```
## Session Handoff

/opsx:apply {cid}

Change: openspec/changes/{cid}/
Read: proposal.md, design.md, tasks.md, doc/i18n/GLOSSARY.md, doc/i18n/WAVES.md, doc/i18n/CURSOR-AUTOMATIONS.md
Gate: bash scripts/verify-i18n-wave.sh --files doc/sistema-sdd-pedro.md
Infra: openspec/infra.md (assume ✅ — do not reinstall)
```
"""


def guide_design(
    change_id: str,
    path: str,
    start: int,
    end: int,
    label: str,
    prev_dep: str | None,
    is_kit: bool,
) -> str:
    loc = end - start + 1
    hub_note = (
        "Hub `translate-design-wave-*` apply should land before kit apply when possible."
        if is_kit
        else "Deferred from `translate-design-wave-2` non-goals (`001` ~592 LOC — split into two waves)."
    )
    dep = (
        f"Soft apply preference: `{prev_dep}` apply+archive before this wave's apply."
        if prev_dep
        else "Dependencies: none for propose (infra ✅)."
    )
    manifest_task = (
        "\n- After template edits: `bash sdd-kit/gen-manifest-checksums.sh` (G-MANIFEST)"
        if is_kit
        else ""
    )
    gates = "G-MANIFEST" if is_kit else "G-MIRROR (N/A)"
    return f"""# Design — {change_id}

## Context

- Layer-1 policy: `sdd-docs-language` / `doc/i18n/*`.
- Target: `{path}` lines **{start}–{end}** ({label}, ~{loc} LOC).
- {hub_note}
- Canonical guide (`doc/sistema-sdd-pedro.md`) is covered by `translate-guide-wave-*` (separate track).

## Goals / Non-Goals

**Goals:**

- Substitute Portuguese prose in the listed slice with glossary-canonical English in-place.
- Pass `bash scripts/verify-i18n-wave.sh --files {path}`.{manifest_task}

**Non-goals:** dual-file siblings; global G-DoD; semantic changes beyond language.

## Decisions

### D1: Mid-file slice on `{path}`

**Chosen:** Lines {start}–{end} only; whole-file path in gate (G-PT scans entire file — prior slices must be apply-complete).

## Risks

| Risk | Mitigation |
|------|------------|
| G-PT fails on untouched PT outside slice | Sequential apply per wave number |
| Broken relative links | G-LINK; careful heading translation |

## Migration Plan

1. Apply EN substitution for lines {start}–{end}.
2. Gate: `bash scripts/verify-i18n-wave.sh --files {path}`.
3. Validate: `OPENSPEC_TELEMETRY=0 npx --yes @fission-ai/openspec@1.3.1 validate {change_id} --strict`.

**Rollback:** `git checkout -- {path}`.
"""


def guide_tasks(
    change_id: str,
    path: str,
    start: int,
    end: int,
    label: str,
    is_kit: bool,
) -> str:
    manifest_gate = ""
    manifest_task = ""
    if is_kit:
        manifest_task = """
- [ ] 2.2 Run `bash sdd-kit/gen-manifest-checksums.sh` after template edit
  - **Pattern:** `sdd-kit/gen-manifest-checksums.sh`
  - **Gate:** `bash sdd-kit/verify.sh`
"""
        manifest_gate = " G-MANIFEST"

    return f"""# Tasks — {change_id}

> Apply after human approval (R7). In-place PT→EN only on lines **{start}–{end}** of `{path}`.

## 1. Prep

- [ ] 1.1 Confirm `doc/i18n/GLOSSARY.md` covers terms for this slice; append only if new SDD terms appear
  - **Pattern:** `doc/i18n/GLOSSARY.md`
  - **Gate:** `test -s doc/i18n/GLOSSARY.md`

## 2. Substitute

- [ ] 2.1 Rewrite lines **{start}–{end}** ({label}) Portuguese prose → glossary-canonical English; do not edit lines outside the slice
  - **Pattern:** `{path}`
  - **Gate:** `bash scripts/verify-i18n-wave.sh --files {path}`
  - **Forbidden:** dual-file siblings; edits outside lines {start}–{end}
{manifest_task}
## 3. Validate

- [ ] 3.1 OpenSpec + task patterns
  - **Pattern:** `scripts/verify-task-patterns.sh`
  - **Gate:** `bash scripts/verify-task-patterns.sh && OPENSPEC_TELEMETRY=0 npx --yes @fission-ai/openspec@1.3.1 validate {change_id} --strict`
  - **Note:** Per-wave gate must pass{manifest_gate} before marking done
"""


def design_proposal(
    n: int,
    path: str,
    start: int,
    end: int,
    label: str,
    prev: int | str | None,
    is_kit: bool,
) -> str:
    loc = end - start + 1
    prefix = "translate-kit-design" if is_kit else "translate-design"
    cid = f"{prefix}-wave-{n}"
    if is_kit:
        dep = f"- Dependencies: soft apply preference — hub `translate-design-wave-{n}` apply+archive before kit apply; serialize vs other in-flight `sdd-kit/templates/` applies. Infra ✅"
        extra_what = "\n- After template edits: run `bash sdd-kit/gen-manifest-checksums.sh` (G-MANIFEST)"
        gates_extra = ", **G-MANIFEST**"
    else:
        dep = (
            f"- **Apply prerequisite:** `translate-design-wave-{prev}` apply+archive before this wave's apply"
            if isinstance(prev, int)
            else "- Dependencies: none for propose (hub design wave-2 deferred `001` split; infra ✅)"
        )
        extra_what = ""
        gates_extra = ""
    return f"""**Issue:** —

## Why

Hub design waves 1–2 own `doc/design/002|003|004` and `000`. The pipeline reference `doc/design/001-pipeline-open-design-shadcn-impeccable.md` (~592 LOC) was explicitly deferred (over single-wave budget). This change covers lines **{start}–{end}** ({label}, ~{loc} LOC) — within ≤350–400 LOC. {"Kit mirror follows hub EN for the same slice." if is_kit else "First half of the split; wave-4 covers the remainder."}

## What Changes

- Replace Portuguese prose with glossary-canonical English **in-place** in:
  - `{path}` (lines **{start}–{end}** only){extra_what}
- Preserve freeze-list tokens, relative links to `000`/`002`/`003`/canonical guide, shadcn/Impeccable/Open Design brand names, fenced shell
- Expand `doc/i18n/GLOSSARY.md` only if new SDD terms appear
- Run `bash scripts/verify-i18n-wave.sh --files {path}` before marking tasks done

## Capabilities

### New Capabilities

- _(none)_

### Modified Capabilities

- `sdd-docs-language`: ADDED requirement — `{path}` slice lines {start}–{end} MUST be English after substitution.

## Impact

- Files modified: `{path}` (lines {start}–{end});{" `sdd-kit/MANIFEST.yaml` checksums only;" if is_kit else ""} optional `doc/i18n/GLOSSARY.md`
{dep}
- **Non-goals:** lines outside slice; dual-file siblings; global G-DoD; changing pipeline recommendations — language only

## Required gates

```bash
bash scripts/verify-i18n-wave.sh --files {path}
```

Must pass: **G-INV**, **G-GLOSS**, **G-PT**, **G-LINK**, **G-OPENSPEC**{gates_extra}.

## Session Handoff stub

```
## Session Handoff

/opsx:apply {cid}

Change: openspec/changes/{cid}/
Read: proposal.md, design.md, tasks.md, doc/i18n/GLOSSARY.md, doc/i18n/WAVES.md
Gate: bash scripts/verify-i18n-wave.sh --files {path}
```
"""


def main() -> None:
    created: list[str] = []

    for n, start, end, label, prev in GUIDE_WAVES:
        cid = f"translate-guide-wave-{n}"
        base = CHANGES / cid
        if base.exists():
            continue
        write(base / ".openspec.yaml", openspec_yaml())
        write(base / "proposal.md", guide_proposal(n, start, end, label, prev))
        write(
            base / "design.md",
            guide_design(cid, "doc/sistema-sdd-pedro.md", start, end, label, None, False),
        )
        write(
            base / "tasks.md",
            guide_tasks(cid, "doc/sistema-sdd-pedro.md", start, end, label, False),
        )
        write(
            base / "specs/sdd-docs-language/spec.md",
            spec_delta(cid, "doc/sistema-sdd-pedro.md", f"lines {start}–{end}"),
        )
        created.append(cid)

    for n, path, start, end, label, prev in DESIGN_WAVES:
        cid = f"translate-design-wave-{n}"
        base = CHANGES / cid
        if base.exists():
            continue
        write(base / ".openspec.yaml", openspec_yaml())
        write(base / "proposal.md", design_proposal(n, path, start, end, label, prev, False))
        write(base / "design.md", guide_design(cid, path, start, end, label, None, False))
        write(base / "tasks.md", guide_tasks(cid, path, start, end, label, False))
        write(
            base / "specs/sdd-docs-language/spec.md",
            spec_delta(cid, path, f"lines {start}–{end}"),
        )
        created.append(cid)

    for n, path, start, end, label, hub_dep in KIT_DESIGN_WAVES:
        cid = f"translate-kit-design-wave-{n}"
        base = CHANGES / cid
        if base.exists():
            continue
        write(base / ".openspec.yaml", openspec_yaml())
        write(
            base / "proposal.md",
            design_proposal(n, path, start, end, label, hub_dep, True),
        )
        write(
            base / "design.md",
            guide_design(cid, path, start, end, label, hub_dep, True),
        )
        write(base / "tasks.md", guide_tasks(cid, path, start, end, label, True))
        write(
            base / "specs/sdd-docs-language/spec.md",
            spec_delta(
                cid,
                path,
                f"lines {start}–{end}",
                " Kit template checksums MUST be regenerated when templates change.",
            ),
        )
        created.append(cid)

    print(f"Created {len(created)} changes:")
    for c in created:
        print(f"  - {c}")


if __name__ == "__main__":
    main()

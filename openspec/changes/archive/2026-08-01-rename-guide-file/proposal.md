**Issue:** —

## Why

`doc/sistema-sdd-pedro.md` is the only author-named file in the repo; the operator decided (explore session 2026-08-01) that file names must reflect the project, not the author. The rename also retires a residual pt-BR name under the EN docs policy. The i18n guide track is IDLE (`translate-guide-next-wave.sh` reports no pending waves), so this is the safe window — the rename must land atomically because four scripts consume the path functionally (i18n gate file list, upgrade-diff version grep, task-pattern regex, translate-propose generator), two of them failing **silently** if missed.

## What Changes

- **Rename** `doc/sistema-sdd-pedro.md` → `doc/byebyevibe-guide.md` via `git mv` (history preserved); add a v1.7.0 changelog entry in the guide's §14 recording the rename.
- **Redirect stub** at the old path (≤5 lines, EN): points to the new path; states that archived changes and historical spec requirements cite the old name by design. GitHub has no file-level redirects — the stub is the only redirect possible for external links and muscle memory.
- **Update all live references** (~60 files): root config docs (`AGENTS.md`, `CLAUDE.md`, `openspec/project.md`, `openspec/infra.md`, `README.md`), the four functional scripts + four pointer-only scripts under `scripts/`, 13 IDE surfaces (`.claude/` + `.cursor/` commands/skills/rules), doc surfaces (`doc/sdd-operator-day1.md`, `doc/design/00{0,1,2}-*.md`, `doc/i18n/{WAVES,GLOSSARY,CURSOR-AUTOMATIONS}.md`, `doc/avaliacoes/README.md`), kit hub files (`sdd-kit/README.md`, `install.sh`, `install-probity-module.sh`), and the 16 `sdd-kit/templates/**` mirrors.
- **Kit release discipline:** MANIFEST `version`/`guide_version` bump 1.6.1 → **1.7.0**, checksums regenerated (`gen-manifest-checksums.sh`), `openspec/project.md` and `AGENTS.md` version cross-references updated — consumer repos pick the rename up through the normal `upgrade.sh` path.
- **Alias record ("clear in the documentation"):** one-line rename note in `openspec/project.md` Cross-references and in `AGENTS.md`: old name → new name, date, "archives and pre-rename spec requirements keep the old name; both refer to the same file".
- **Grep-zero gate:** `git grep -l "sistema-sdd-pedro" -- ':!openspec/changes' ':!openspec/specs' ':!doc/avaliacoes'` must return exactly the stub — covers the two silent failure modes (i18n gate coverage, `GUIDE_VERSION` extraction).
- **Explicit non-goal:** no mass edit of the 14 existing `openspec/specs/` files or any `openspec/changes/` content — historical wave-slice requirements and archives stay verbatim (operator decision); only the two capabilities with live normative path references get deltas.

## Capabilities

### New Capabilities

—

### Modified Capabilities

- `sdd-install-kit`: the three requirements naming the guide path as a live pointer (versioned kit directory / MANIFEST match, guide §1.6 scenarios, version alignment on release) now reference `doc/byebyevibe-guide.md`.
- `sdd-docs-language`: ADDED requirement — canonical guide path reflects the project name; `verify-i18n-wave.sh` targets the new path; legacy path holds only the redirect stub; historical requirements citing the old path are not retro-edited.

## Impact

- **Renamed:** `doc/sistema-sdd-pedro.md` → `doc/byebyevibe-guide.md` (+ stub at old path)
- **Modified:** `AGENTS.md`, `CLAUDE.md`, `openspec/project.md`, `openspec/infra.md`, `README.md`, `doc/sdd-operator-day1.md`, `doc/design/000|001|002`, `doc/i18n/*`, `doc/avaliacoes/README.md`, `scripts/{verify-i18n-wave,sdd-upgrade-diff,verify-task-patterns,gen-missing-translate-proposes.py,translate-guide-next-wave,bootstrap-sdd,sdd-session-check,sdd-metrics}`, `.claude/` + `.cursor/` surfaces (13), `sdd-kit/{README.md,install.sh,install-probity-module.sh}`, `sdd-kit/templates/**` (16) + `MANIFEST.yaml` (version + checksums)
- **Non-goals:** editing `openspec/changes/**` (archives + explore research) or the 14 pre-existing spec files beyond the two deltas; renaming any other file; content changes to the guide beyond the changelog entry
- **Risks:** silent i18n-gate coverage loss and empty `GUIDE_VERSION` (grep-zero gate); checksum drift (fail-closed `verify.sh` gate); hub↔template split-brain (same-commit tasks + `sdd-upgrade-diff.sh`); broken external links (stub); stale specs (alias record; deltas on the two live capabilities)
- **Checksums:** `bash sdd-kit/gen-manifest-checksums.sh` mandatory (16 templates change)
- **Pilot:** waived candidate (mechanical rename + docs; no behavior change beyond path strings; all gates deterministic)
- **Sources:** explore session 2026-08-01 (reference map: 781 occurrences / 259 files, ~75 live); `sdd-kit/README.md:117` version rule; specs `sdd-install-kit`, `sdd-docs-language`

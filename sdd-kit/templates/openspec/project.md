# Project constitution

The single source of truth an agent reads before proposing, designing, or implementing
anything in this repository. Keep it short and true — a stale constitution is worse than
a thin one. Replace every `[FILL]` below; delete lines that do not apply.

## Purpose

[FILL] One paragraph: what this repository is for, and who depends on it.

## Stack

- **Language / runtime:** [FILL]
- **Framework:** [FILL]
- **Package manager:** [FILL]
- **Tests:** [FILL]
- **Build / deploy:** [FILL]

## Conventions

- **Naming:** [FILL]
- **Directory layout:** [FILL]
- **Commits:** [FILL]
- **Reviews:** [FILL]

## Constraints

- [FILL] Anything an agent must never do here (protected paths, forbidden dependencies,
  compliance rules, data that must not leave the repo).
- [FILL] Performance, compatibility, or platform floors that bind every change.

## Language policy

<!-- SDD_LANGUAGE_POLICY_START -->
| Axis | Key | Value |
|------|-----|-------|
| Chat | `chat_language` | en |
| Docs | `docs_language` | en |
| Code | `code_language` | en |
<!-- SDD_LANGUAGE_POLICY_END -->

Configured at C1 install (`sdd-kit/install.sh`). v1 allowlist: `en`, `pt-BR`. See guide §2.1.1.
The block between the two markers is rewritten by the installer — edit the flags, not the table.

## Cross-references

- **Operator guide:** `doc/byebyevibe-guide.md` — install, phases, day-1 operation.
- **Day-1 tutorial:** `doc/sdd-operator-day1.md`.
- **Agent rules:** `AGENTS.md` (entry point) and `openspec/AGENTS.md` (workflow).
- **Kit:** `sdd-kit/` — `MANIFEST.yaml` (payload), `verify.sh` (post-install checks),
  `upgrade.sh` (kit updates).
- **Live specs:** `openspec/specs/` · **Active proposals:** `openspec/changes/`.
- **Infrastructure status:** `openspec/infra.md`.

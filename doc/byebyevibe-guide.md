# AI-Assisted Development System

**GitNexus + Graphify + OpenSpec, integrated in Cursor and VS Code + Claude Code**

> **Canonical install guide (v1.15.1)** — use in any Git repository, manually or via an AI agent. Payloads in `sdd-kit/`; procedure in this document.

## How to use this document

| Mode | Action |
|------|--------|
| **First contact / vibe coder** | §2.0b → root [`README.md`](../README.md) (**ByeByeVibe**) + `bash sdd-kit/install.sh --profile X --dry-run` |
| **Human — new install (C1)** | §2.1 → CLIs → `bash sdd-kit/install.sh --profile X` → §2.8 → §2.12 → §2.13 (APP/HYBRID) |
| **Human — upgrade (C2)** | §2.9 + `bash sdd-kit/upgrade.sh --dry-run` → §12.8 → `--apply` |
| **Human — CLIs only (C2b)** | §2.9.4 — without touching `sdd-kit/templates/` |
| **Spec propagation (C3)** | git/reference in `openspec/specs/` — **without** `install.sh` |
| **AI agent — install** | Prompt §2.0; use `sdd-kit/install.sh`, **do not** extract §12 |
| **AI agent — upgrade** | §2.9.2 + `sdd-kit/upgrade.sh --dry-run` + §12.8 before editing |
| **Pilot / test** | `bash sdd-kit/verify.sh` + checklist §2.8 or §2.9.7 |
| **SDD metrics (G4)** | `bash scripts/sdd-metrics.sh` — §2.17 (mode C; no DevLake) |
| **Automated PR review** | Hub workflow `.github/workflows/automated-pr-review.yml` — §2.19 (not part of C1/C2) |

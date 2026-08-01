**Issue:** —

## Why

Discovery (README / §2.0b) and install narrative (S↔T for the three tools) are adopted, but after C1 operators still lack an **in-IDE day-1 operate** surface: what `explore → propose → apply → archive` means in plain language, where artifacts live, how to prompt explore well, and how to verify each phase with confidence questions. Closing explore merge `explore-sdd-operator-onboarding` (2026-08-01, Option A / D1–D10) makes the ByeByeVibe control plane teachable on day 1 without replacing upstream OpenSpec `/opsx:onboard`.

## What Changes

- **New kit-owned `/opsx:help`:** skill + Cursor/Claude command mirrors that narrate a short canonical EN day-1 doc (mode C / on-demand) — complementary to and **never hiding** upstream `/opsx:onboard`.
- **Short EN day-1 operator doc:** persistent-memory framing, clickable file map (OpenSpec + Graphify + GitNexus), phase spine, explore prompt craft, per-phase confidence prompts, Onboard vs Help in §0.
- **Install / bootstrap tip:** one line (or short block) naming **both** `/opsx:help` and `/opsx:onboard` after C1 next-steps (suggested order: help map → onboard practice).
- **`AGENTS.md` Commands:** one-liner for `/opsx:help` in hub + kit command templates (APP and DOCS_SPECS).
- **Optional soft §2.8 checklist pointer** for `/opsx:help` (non-blocking).
- **Evaluation stub** under `doc/avaliacoes/` (insertion methodology R5) + MANIFEST entries / checksums for new kit templates.
- **Guide pointer** only (short link from §2.7 or §2.8 area) — **not** a wholesale rewrite of §3/§4.

## Capabilities

### New Capabilities

- `sdd-operator-onboarding`: ByeByeVibe day-1 operate surface — `/opsx:help` (kit-owned), canonical day-1 EN doc, Onboard vs Help framing, phase tutorial spine, file map, explore prompt craft, confidence prompts, install tip naming both commands, AGENTS one-liner, optional soft checklist (D1–D10 from explore).

### Modified Capabilities

- `sdd-install-kit`: ship `/opsx:help` skill + command mirrors + day-1 doc via `sdd-kit/templates/` + MANIFEST; emit post-install tip naming `/opsx:help` and `/opsx:onboard`; extend AGENTS command templates with `/opsx:help`.
- `sdd-post-install-verification`: optional non-blocking soft checklist item that `/opsx:help` (or the day-1 doc) is discoverable after C1.

## Impact

- **New:** `doc/sdd-operator-day1.md` (canonical EN day-1); kit templates for skill/commands; hub mirrors under `.cursor/` / `.claude/`; `doc/avaliacoes/2026-08-01-sdd-operator-onboarding.md`; guide short pointer; `AGENTS.md` Commands row
- **Modified:** `sdd-kit/install.sh` (+ optional `bootstrap-sdd.sh` next-steps line); `sdd-kit/MANIFEST.yaml` + checksums; `sdd-kit/templates/AGENTS.commands.*.md`; hub `AGENTS.md` / command templates as shipped
- **Specs:** new `sdd-operator-onboarding`; deltas on `sdd-install-kit`, `sdd-post-install-verification`
- **Non-goals:** always-on tutorial rule; forced C1 interactive menu; patching `openspec-onboard` or core `openspec-*` skills; single CTA that omits `/opsx:onboard`; GIF/asciinema; inventing product `roadmap.md`; rewriting guide §3/§4 wholesale; help subcommands in v1
- **Checksums:** run `bash sdd-kit/gen-manifest-checksums.sh` when templates change
- **Pilot:** waived (docs + inert skill/command templates + tip strings — no new binary/hook; metodologia Phase 2 exception)
- **Sources:** `openspec/changes/explore-sdd-operator-onboarding/research.md` (D1–D10); guide §2.0b, §2.7–2.8, §3, §4.3, §12.3, §12.10; `openspec/specs/sdd-discovery-positioning`, `sdd-install-narrative`, `sdd-install-kit`, `sdd-session-handoff`; `metodologia-insercao.md`; OpenSpec 1.3.1 (`ALL_WORKFLOWS` / onboard)

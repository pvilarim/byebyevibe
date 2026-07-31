**Issue:** —

## Why

C1 install today is command-correct but narratively thin: operators (and agents following §2.0) jump into OpenSpec → GitNexus → Graphify → `install.sh` without a clear “what / why now / without it” story, so the three pillars feel like a checklist instead of a control plane. Optional add-ons (UI, Probity, CI, Metrics) are scattered after §2.8 without a single post-checklist teaser, and TTY bootstrap/install output does not teach in simple language before technical steps. Closing the explore decisions (approach A + slice of B, dual S↔T tone, no menu X, no order change) makes first-contact install teachable for humans and agents without rewriting §4 or changing technical order.

## What Changes

- **Guide §2 didactic layer:** §2.1 gains a 3-pillars diagram + why-the-order (S default + T→§4 link); §2.2–2.4 gain per-step What / Why now / Without it (“Sem ela…”) / You’ll get; after §2.8, a clear **Optional add-ons at a glance** block (UI, Probity, CI, Metrics) — pointers only, always after the checklist, no interactive end-of-C1 menu.
- **Prompt §2.0:** agent MUST explain layer S before each step; layer T (terms/commands/paths) on demand or when the next action requires it; also T→S (technical term → short analogy/scenario).
- **`bootstrap-sdd.sh`:** TTY banners with S-layer context before each major step; `--quiet` for CI/agents (suppress banners, keep errors/warnings).
- **`install.sh` teaser:** after successful install / next-steps, print optional add-ons teaser (points to guide sections / commands) — MUST NOT auto-install modules.
- **Root `README.md`:** one paragraph “How the three tools fit” (OpenSpec / GitNexus / Graphify + kit) without bloating discovery.
- **Runtime operator language:** TTY/banner/teaser strings follow configured `chat_language` when available; versioned guide/README/kit docs remain English (F7 / `docs_language`).

## Capabilities

### New Capabilities

- `sdd-install-narrative`: didactic install narrative for C1 — dual S↔T tone, per-tool “Without it” copy, optional-addons glance after checklist, agent prompt §2.0 behavior, TTY banners / `--quiet`, post-install teaser (no auto-install), README three-tools paragraph.

### Modified Capabilities

- `sdd-install-kit`: `bootstrap-sdd.sh` MUST support didactic TTY banners and `--quiet`; `install.sh` MUST emit optional-addons teaser after C1 payload install without installing optionals.

## Impact

- Modified: `doc/sistema-sdd-pedro.md` (§2.0, §2.1–2.4, post-§2.8 optional block only — **not** §4 rewrite), `README.md`, `sdd-kit/README.md` (pointer if needed), `sdd-kit/templates/scripts/bootstrap-sdd.sh`, hub `scripts/bootstrap-sdd.sh` if present, `sdd-kit/install.sh`
- Specs: new `sdd-install-narrative`; delta on `sdd-install-kit`
- **Non-goals / out of scope:** rewrite §4 master table; GIF/landing; change C1 tool order; interactive menu X at end of C1; auto-install UI/Probity/CI/Metrics; invent “Sem ela…” copy beyond the explore drafts refined in design
- **Checksums:** if templates under `sdd-kit/templates/` change, run `bash sdd-kit/gen-manifest-checksums.sh` before commit
- **Sources:** explore decisions in propose prompt; guide §2 + §4; `README.md`; `sdd-kit/README.md`; `sdd-kit/install.sh`; `templates/scripts/bootstrap-sdd.sh`; `openspec/specs/sdd-install-kit/`; language axes via `sdd-language-policy`
- **Explore merge (2026-07-31):** decisions confirmed (A+B, Y after §2.8, S↔T, F7); design D3/D5 tightened — full S copy table + Install if/Skip if; no apply in merge pass

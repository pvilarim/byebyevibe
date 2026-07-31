## Context

C1 install path (`doc/sistema-sdd-pedro.md` §2, `scripts/bootstrap-sdd.sh`, `sdd-kit/install.sh`) is technically ordered and correct, but the narrative is thin: steps list commands and tree outputs without a durable “what / why now / without it” story. Optional modules (UI §2.11, Probity §2.16, CI §2.12, Metrics §2.17) appear as separate later sections with no single post-checklist glance. Explore closed on **approach A + slice of B**: didactic guide §2, TTY banners + `--quiet`, post-`install.sh` teaser (pointers only), dual **S↔T** tone, audience = human (guide/TTY) **and** agent (§2.0 prompt). Technical tool order MUST NOT change. Versioned artifacts stay English (F7); runtime operator strings follow `chat_language` when resolvable.

Sources: propose prompt (explore decisions); guide §2 + §4; `README.md`; `sdd-kit/README.md`; `sdd-kit/install.sh`; `sdd-kit/templates/scripts/bootstrap-sdd.sh` / `scripts/bootstrap-sdd.sh`; `openspec/specs/sdd-install-kit/`; `sdd-language-policy`.

## Goals / Non-Goals

**Goals:**

- Teach the three pillars + kit in layer **S** by default (simple + “Without it…” + short scenario), with layer **T** (terms/commands/paths) on demand or when the next action requires it; also **T→S** (term → analogy).
- Enrich §2.1–2.4 and §2.0 without rewriting §4 (link T detail to §4).
- Place **Optional add-ons at a glance** strictly after checklist §2.8 (Y confirmed — no end-of-C1 interactive menu).
- Add TTY didactic banners in `bootstrap-sdd.sh` with `--quiet` for CI/agents.
- Emit a post-`install.sh` teaser that points to optionals and MUST NOT install them.
- Add one README paragraph “How the three tools fit”.

**Non-Goals:**

- Rewrite §4 master table / detailed I/O diagrams.
- GIF, landing page, or marketing site work.
- Change C1 CLI/tool order (OpenSpec → GitNexus → Graphify → install.sh → …).
- Interactive menu X / wizard at end of C1.
- Auto-install UI, Probity, CI workflow enablement, or Metrics.
- Invent “Without it…” copy outside the refined drafts below.

## Decisions

### D1 — Approach A + slice of B (confirmed)

| Option | Summary | Verdict |
|--------|---------|---------|
| A only | Guide prose only | Insufficient for TTY/agent install paths |
| B only | Scripts/banners only | Guide remains opaque for humans reading §2 |
| **A + slice of B** | Guide didactic + banners/`--quiet` + teaser | **Chosen** — covers human + agent + CI |
| Full B + menu X | Interactive optional installer | Rejected — explore closed Y = no menu |

### D2 — Dual tone S↔T (not S-only or T-only)

- **S (default):** short plain-language What / Why now / Without it / You’ll get; vibe-coder friendly.
- **T (on demand):** commands, paths, version pins, tree listings already present in §2.2–2.4; deep comparison → link to §4.
- **T→S:** when a technical term appears first in S prose, one short analogy/scenario follows in parentheses or a following sentence.
- Agent §2.0 prompt MUST instruct: explain S before each step; expand T when the operator asks or when the next shell action needs exact commands.

### D3 — Canonical S-layer copy (What / Why now / Without it / You’ll get)

Versioned guide/README use English. Runtime TTY MAY use pt-BR when `chat_language=pt-BR`. Apply MUST NOT invent alternate slogans for these four tools (explore merge 2026-07-31 locked this table).

| Tool | What (EN) | Why now (EN) | Without it… (EN) | You’ll get (EN) |
|------|-----------|--------------|------------------|-----------------|
| OpenSpec | The **playbook** for a change: think → agree → do → keep a record | First: creates the `openspec/` skeleton other steps assume | Without it, chat turns into code and nobody remembers why | Slash commands `/opsx:*`, `openspec/`, change folders |
| GitNexus | The **map of your repo’s code** | Second: indexes code and seeds `AGENTS.md` after the skeleton exists | Without it, the AI edits by vibe and breaks the neighborhood | Local code graph + impact / MCP tools |
| Graphify | The **map of what the team already knows** (docs, decisions, ideas) | Third: adds non-code context without fighting the code index | Without it, the AI reinvents what the team already wrote | `graphify-out/` + `GRAPH_REPORT.md` |
| sdd-kit | The **toolbox** that wires the control plane into *this* repo | After the three CLIs: copies curated rules, scripts, gates | Without it, every repo invents the process from scratch | Templates, `install.sh` / `verify.sh`, CI workflow payload |

| Tool | What (pt-BR, runtime) | Without it… (pt-BR, runtime) |
|------|----------------------|------------------------------|
| OpenSpec | O **roteiro** da mudança: pensar → combinar → fazer → guardar o registro | Sem ela, conversa vira código e ninguém lembra o porquê |
| GitNexus | O **mapa do código** do seu repo | Sem ela, a IA mexe no feeling e quebra o lado |
| Graphify | O **mapa do que o time já sabe** (docs, decisões, ideias) | Sem ela, a IA reinventa o que o time já escreveu |
| sdd-kit | A **caixa de ferramentas** que liga tudo isso no seu projeto | Sem ela, cada repo monta o processo do zero |

**Combined scenario (EN, once in §2.1 — optional repeat shortened in banners):** You ask “add login.” Without OpenSpec, the AI already opens files. Without GitNexus, it edits the wrong place. Without Graphify, it ignores the auth decision you wrote last month. With all three (+ kit), it agrees on a plan, checks impact, and reuses what the team already knows.

Per-tool one-liners (EN, if space is tight): OpenSpec = “decision survives the chat”; GitNexus = “impact before the edit”; Graphify = “docs/concepts before reinventing”; sdd-kit = “same control plane, not a one-off ritual”.

### D4 — §2.1 diagram + why order (S + T→§4)

ASCII (or mermaid) three pillars + kit bridge:

```
Intent (OpenSpec) → Code graph (GitNexus) → Knowledge graph (Graphify) → payloads (sdd-kit)
```

Why order stays S-level: later tools assume earlier artifacts; reversing risks overwrite of `AGENTS.md` / skeleton. One sentence + link: “Full responsibilities matrix → §4.”

### D5 — Optional add-ons after §2.8 only (Y confirmed at explore merge)

New subsection **immediately after** checklist §2.8 and **before** §2.11 (file order today: `### 2.8` → `### 2.11`):

| Add-on | Install if… (S) | Skip if… (S) | Pointer |
|--------|-----------------|--------------|---------|
| UI module (C1-UI) | You have a frontend (`app/`) and want a design-system path | Docs/API-only repo | §2.11 · `install-ui-module.sh` |
| Probity (G2) | APP/HYBRID with tests and you want TDD enforced for B/C/D | DOCS_SPECS / no test runner | §2.16 · `install-probity-module.sh` |
| CI gates | You want merge blocked when specs/tasks fail | Local-only exploration (workflow may still ship in kit) | §2.12 · branch protection manual |
| SDD metrics (G4) | After a few archives, to calibrate lead time/rework | First-day install | §2.17 · `sdd-metrics.sh` on demand |

No prompts, no menu X, no install from this block. The `install.sh` teaser (D7) only **reminds** these exist; operators run them later after §2.8.

### D6 — `bootstrap-sdd.sh` banners + `--quiet`

- Parse `--quiet` / `-q` from argv; positional repo path remains supported (`REPO` default `.`).
- Emit S-layer banner before OpenSpec, GitNexus, Graphify, and kit phases **only when** stdout is a TTY **and** `--quiet` is unset.
- `--quiet`: suppress didactic banners; keep WARN/ERROR and minimal phase markers acceptable for logs (`==> OpenSpec...` MAY remain as machine-friendly progress, or be reduced — prefer keep one-line progress, drop multi-line S prose).
- Non-TTY (CI): treat as quiet for banners even without the flag (CI-safe default); `--quiet` still documented for agents on TTY.
- Locale: EN strings default; if `--chat-lang` or `SDD_CHAT_LANG` is set to `pt-BR`, use pt-BR “Without it…” table for banners. Do not block bootstrap waiting for language policy (policy often absent pre-install).
- Apply same narrative behavior to **both** `sdd-kit/templates/scripts/bootstrap-sdd.sh` and hub `scripts/bootstrap-sdd.sh` (keep template authoritative; sync hub copy / regenerate checksums).

### D7 — `install.sh` teaser (no auto-install)

After existing “Done. Next steps:” checklist pointers (and after dry-run, print `PLAN` teaser only — no implication that modules were installed), append a short **Optional add-ons** block pointing to §2.11 / §2.12 / §2.16 / §2.17 and entry commands. MUST NOT invoke `install-ui-module.sh`, `install-probity-module.sh`, or metrics. Locale: use resolved `CHAT_LANG` from language policy for teaser prose.

### D8 — README paragraph

One short paragraph under Get started or What’s included: how OpenSpec (intent), GitNexus (code), Graphify (knowledge) fit, and that `sdd-kit/` ships the control-plane payloads — link to guide §2.1. Do not duplicate the full §2 didactic structure.

### D9 — Hub bootstrap drift

Hub `scripts/bootstrap-sdd.sh` currently differs slightly from the template (profile detection). This change updates **template first**, then syncs hub script to template narrative + profile-detection behavior already specified by `sdd-install-kit` (HYBRID warning), without expanding profile logic beyond what specs already require.

## Risks / Trade-offs

| Risk | Mitigation |
|------|------------|
| Guide §2 grows long / token-heavy for agents | Keep S blocks ≤ ~8 lines per step; leave trees/commands as T; link §4 instead of duplicating |
| Banner noise in CI logs | Non-TTY auto-quiet + explicit `--quiet` |
| pt-BR runtime strings drift from EN docs | Single table in design/tasks; scripts hold both locales in one function |
| Operators think teaser installs optionals | Wording: “pointers only — not installed”; never call installers |
| Dual bootstrap copies diverge again | Task: edit template, copy to `scripts/`, run checksum script |
| “Sem ela…” tone feels informal for enterprise | Keep one-line scenario; T layer remains formal commands |

## Migration Plan

1. Land guide + README + §2.0 prompt text (docs-only readable immediately).
2. Ship `bootstrap-sdd.sh` + `install.sh` behavior; regenerate MANIFEST checksums if templates change.
3. No consumer data migration; C2 upgrade copies new bootstrap via kit MERGE/COPY as today.
4. Rollback: revert files; no schema/state.

## Open Questions

- None blocking apply — explore closed A+B, Y (addons after §2.8), dual S↔T, audiences, F7 language split. **Explore ↔ propose merge (2026-07-31):** no decision reversals; D3 extended to lock full What / Why now / You’ll get (not only Without it) so apply cannot drift. Apply may tweak banner length for readability without changing requirements.

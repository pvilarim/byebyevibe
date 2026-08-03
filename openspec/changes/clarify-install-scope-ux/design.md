# Design: clarify-install-scope-ux

## Context

The SDD stack splits across three install scopes that no canonical file names explicitly:

1. **Machine scope (install once):** Node/npx, OpenSpec CLI, GitNexus CLI, Graphify CLI (`uv tool install graphifyy`), MCP config (`~/.cursor/mcp.json` / Claude Code user scope).
2. **Repo scope — copied payload (C1 per project):** `AGENTS.md`, `CLAUDE.md`, rules, skills, `scripts/`, CI workflow — copied by `sdd-kit/install.sh`.
3. **Repo scope — generated state:** `openspec/` (specs + changes), `graphify-out/`, `.gitnexus/` — born from each project; cannot be shared or globalized.

Guide §1.6 documents a *different* axis (artifact layers: procedure/payload/specs/state) but not install scope. `bootstrap-sdd.sh` already accepts a target path (`bootstrap-sdd.sh [REPO_PATH]`), which means the hub→destination flow already exists but is undocumented as the canonical UX. The script also runs `npm install -g @fission-ai/openspec@latest` unconditionally on every run — harmless but contradicts any "install once" message. Repo precedent for avoiding doc duplication: "status lives in the manifest, how-to lives in tooling-install" (`doc/tooling-install.md`).

Sources: `sdd-kit/templates/scripts/bootstrap-sdd.sh` (banner + install phases), `doc/byebyevibe-guide.md` §1.6, `doc/sdd-operator-day1.md` §0, `openspec/specs/sdd-install-kit/spec.md`, `openspec/specs/sdd-install-narrative/spec.md`, `openspec/specs/sdd-operator-onboarding/spec.md`.

## Goals / Non-Goals

**Goals:**
- One canonical place (guide §1.6) states the three install scopes and the hub→destination one-command flow; every other surface links to it.
- The operator sees the scope story at three moments: first contact (kit README), install time (banners + completion message), and later recall (`/opsx:help` → day-1 §0).
- `bootstrap-sdd.sh` behavior matches the message: machine-level CLIs already present are skipped with an explicit "already installed — skipping" line.

**Non-Goals:**
- No global wrapper CLI (`bbv init`) and no Claude Code plugin packaging — candidate future change.
- No change to what is machine vs repo scoped; this documents and hardens the existing model, it does not redesign it.
- No root `README.md` hero edits (covered by `sdd-discovery-positioning`; adding it here widens review surface for marginal gain).
- No day-1 section renumbering; §0–§9 spine stays locked (the `/opsx:help` skill narration table depends on it).

## Decisions

### D1 — Canonical scope table lives in guide §1.6; all other surfaces link

A second table ("Install scope") is added to §1.6 alongside the existing four-layer artifact table, plus one sentence: *reinstalling per project = only the copied payload; machine CLIs never reinstall.* Kit README, day-1 §0, and banners reference or summarize in ≤1 line.

*Alternative considered:* full explanation duplicated in kit README and day-1 doc — rejected: three divergence points; violates the repo's existing single-source pattern.

### D2 — Hub→destination is the canonical multi-project UX; no new tool

Documented command, from anywhere on the machine:

```bash
bash <hub-clone>/scripts/bootstrap-sdd.sh /path/to/target-repo --profile APP|DOCS_SPECS|HYBRID
```

One hub clone per machine (origin); N project repos (destinations). This capability already exists (`REPO_PATH` positional arg); the change only consecrates and surfaces it.

*Alternatives considered:* (a) global `bbv` wrapper — new binary, packaging, and upgrade story; disproportionate to the problem; deferred. (b) Claude Code plugin — solves slash-command distribution but not payload/state install; deferred with (a).

### D3 — Idempotent CLI guard in bootstrap, guarded not removed

Each machine-level phase checks `command -v <tool>` first: present → print `<tool> already installed (<version>) — skipping install` and still run the per-repo steps (`openspec init`, `gitnexus analyze`, `graphify update .`), which are per-project by design. Absent → install as today. Per-repo steps are never skipped.

*Alternative considered:* keep unconditional `npm install -g @latest` (self-updating) — rejected: contradicts the banner message, adds network dependency to every bootstrap, and risks drift past pinned `min_openspec`. CLI refresh already has a dedicated scenario (C2b).

### D4 — Banner extension: third `Scope:` line, same didactic format

Existing `What / Without it` pairs gain one line, en + pt-BR:
- OpenSpec/GitNexus/Graphify: "Scope: installs once on your machine — future projects reuse it."
- sdd-kit: "Scope: copied into this repo — each project gets its own."

Completion message (end of bootstrap) states: per-project state lives in `openspec/`, `graphify-out/`, `.gitnexus/`; next project = same one command with a new target path.

*Alternative considered:* separate pre-install "scope explainer" block — rejected: banner bloat; the S-layer contract is short didactic lines.

### D5 — `/opsx:help` coverage via day-1 §0 only; skill untouched

§0 ("Layers: OpenSpec ⊂ ByeByeVibe") gains 2–3 sentences on machine-once vs per-project scope + link to guide §1.6. The `openspec-help` skill stays thin per its own guardrail ("edit `doc/sdd-operator-day1.md` when tutorial content changes").

*Alternative considered:* new day-1 section — rejected: renumbers the locked spine and forces edits to the skill table in two mirrors (`.claude/`, `.cursor/`).

### D6 — Mirror + checksum discipline

`bootstrap-sdd.sh` and `sdd-operator-day1.md` are edited in hub *and* `sdd-kit/templates/`; `bash sdd-kit/gen-manifest-checksums.sh` regenerates sha256; kit version bumps (minor) with a guide changelog §14 entry. `sdd-kit/verify.sh` hub parity gate enforces this.

## Risks / Trade-offs

- [Doc drift: scope story diverges across surfaces] → single canonical table (D1); other surfaces are links/one-liners, checked in review.
- [Banner promises what the script doesn't do] → D3 ships in the same change as D4; tasks order behavior before copy.
- [Stale forgotten checksums abort installs in consumer repos] → `gen-manifest-checksums.sh` is an explicit gated task; `verify.sh` parity gate catches misses.
- [Skipping `npm install -g` leaves an outdated CLI on the machine] → acceptable: C2b covers CLI refresh; guard prints the detected version so the operator can decide.
- [pt-BR banner strings drift from en] → both string sets edited in the same function/case block; task gate greps both.

## Migration Plan

Docs + script change, hub-first: edit hub files → mirror to templates → regen checksums → version bump. Consumers pick it up via standard C2 upgrade (`upgrade.sh --dry-run` → `--apply`). Rollback = git revert; no data or state migration.

## Open Questions

- None blocking. Future change candidate: package `/opsx:*` as a Claude Code plugin + optional `bbv` wrapper (tracked as out of scope here).

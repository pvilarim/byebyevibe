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
- No change to what is machine vs repo scoped; hub-mode resolution (D2) makes the existing model reachable in one command, it does not redesign the model itself.
- No root `README.md` hero edits (covered by `sdd-discovery-positioning`; adding it here widens review surface for marginal gain).
- No day-1 section renumbering; §0–§9 spine stays locked (the `/opsx:help` skill narration table depends on it).

## Decisions

### D1 — Canonical scope table lives in guide §1.6; all other surfaces link

A second table ("Install scope") is added to §1.6 alongside the existing four-layer artifact table, plus one sentence: *reinstalling per project = only the copied payload; machine CLIs never reinstall.* Other surfaces MUST NOT duplicate the table; a short summary (≤3 sentences) plus a link to §1.6 is permitted. (Adversarial review: a strict "one line" rule contradicted the day-1 §0 requirement of 2–3 sentences.)

*Alternative considered:* full explanation duplicated in kit README and day-1 doc — rejected: three divergence points; violates the repo's existing single-source pattern.

### D2 — Hub→destination is the canonical multi-project UX; bootstrap gains hub-mode resolution

Documented command, from anywhere on the machine:

```bash
bash <hub-clone>/scripts/bootstrap-sdd.sh /path/to/target-repo --profile APP|DOCS_SPECS|HYBRID
```

One hub clone per machine (origin); N project repos (destinations). **Correction from adversarial review: this does NOT fully work today.** `bootstrap-sdd.sh` resolves everything target-relative after `cd "$REPO"`: (a) preflight is looked up at `$REPO/scripts/preflight-sdd.sh` / `$REPO/sdd-kit/templates/scripts/preflight-sdd.sh` — a greenfield target has neither → hard exit at phase 0; (b) even past preflight, the repo prerequisite gate (spec `sdd-install-preflight`) FAILs when `sdd-kit/` is absent under the target root; (c) the kit phase looks for `$REPO/sdd-kit/install.sh` and, missing it, WARNs and installs **no payload**.

Therefore bootstrap gains **hub-mode resolution**: let `SOURCE_ROOT` = the script's own repo (`$(cd "$(dirname "$0")/.." && pwd)`). When the target lacks `scripts/preflight-sdd.sh` and `sdd-kit/templates/scripts/preflight-sdd.sh`, fall back to `$SOURCE_ROOT`'s copy. When the target lacks `sdd-kit/install.sh`, run `$SOURCE_ROOT/sdd-kit/install.sh --repo "$REPO"` (the `--repo` flag already exists in `install.sh`). The preflight repo gate is satisfied by hub-resolved kit presence in this mode (delta to `sdd-install-preflight`); the gate still FAILs when neither target nor source carries a kit. Target-local copies always win when present (consumer self-bootstrap unchanged).

*Alternatives considered:* (a) document "copy the kit into the target first" — rejected: guts the one-command promise that motivates the change. (b) global `bbv` wrapper — new binary, packaging, and upgrade story; disproportionate; deferred. (c) Claude Code plugin — solves slash-command distribution but not payload/state install; deferred with (b).

### D3 — Idempotent guard on package installs only; all idempotent steps keep running

The guard wraps **only package-manager install commands**: `npm install -g @fission-ai/openspec@latest` (guard: `command -v openspec`), `npm install -g gitnexus` (guard: `command -v gitnexus`), the uv installer + `uv tool install graphifyy` (guards: `command -v uv` — already present — and `command -v graphify`). Present → print `<tool> already installed (<version>) — skipping install`. Everything else runs unconditionally because it is idempotent and not purely machine-scoped: `openspec init`, `gitnexus setup` (global MCP/skills config, idempotent), `gitnexus analyze`, `graphify install`, `graphify install --platform cursor`, `graphify hook install` (installs the git hook in the **target's** `.git/hooks` — repo-scoped), `graphify update .`. (Adversarial review: guarding the whole `graphify_phase()` would silently drop the commit hook in every second project.)

Staleness safety net: when `openspec` is present, compare its version against MANIFEST `min_openspec` and WARN (pointing to scenario C2b) when older. Version detection commands: `openspec --version`, `gitnexus --version`, `graphify --version`; failure to detect degrades to a notice without version.

*Alternative considered:* keep unconditional `npm install -g @latest` (self-updating) — rejected: contradicts the banner message, adds network dependency to every bootstrap, and risks drift past pinned `min_openspec`. CLI refresh already has a dedicated scenario (C2b).

### D4 — Banner extension: third `Scope:` line; skip notices and completion message channels defined

Existing `What / Without it` pairs gain one line, en + pt-BR:
- OpenSpec/GitNexus/Graphify: "Scope: installs once on your machine — future projects reuse it."
- sdd-kit: "Scope: copied into this repo — each project gets its own."

The unmodified requirement "Bootstrap TTY banners and quiet mode" pins banner content to the archived narrative design's D3 copy — this change adds a MODIFIED delta admitting the Scope line. Naming note: "D3 copy" in that spec refers to the archived `add-install-kit-narrative` design, not this design's D3.

Output channels (adversarial review):
- **Skip notices** (`already installed — skipping`) are phase-marker-level diagnostics: printed always, regardless of TTY/`--quiet` (same class as `==> OpenSpec...`).
- **Completion message** is didactic: TTY-only, suppressed by `--quiet`, printed **after** the existing "Done. Manual steps (required)" block, which remains unconditional and unchanged.
- The next-project command in the completion message uses the script's own resolved source root as origin path (`bash <resolved-source-root>/scripts/bootstrap-sdd.sh <new-target> --profile <PROFILE>`); when the source root carries no `sdd-kit/`, the message instead points to the hub clone requirement (guide §1.6).

*Alternative considered:* separate pre-install "scope explainer" block — rejected: banner bloat; the S-layer contract is short didactic lines.

### D5 — `/opsx:help` coverage via day-1 §0 only; skill untouched

§0 ("Layers: OpenSpec ⊂ ByeByeVibe") gains 2–3 sentences on machine-once vs per-project scope + link to guide §1.6. The `openspec-help` skill stays thin per its own guardrail ("edit `doc/sdd-operator-day1.md` when tutorial content changes").

*Alternative considered:* new day-1 section — rejected: renumbers the locked spine and forces edits to the skill table in two mirrors (`.claude/`, `.cursor/`).

### D6 — Mirror + checksum discipline and version alignment

`bootstrap-sdd.sh`, `preflight-sdd.sh`, and `sdd-operator-day1.md` are edited in hub *and* `sdd-kit/templates/`; `bash sdd-kit/gen-manifest-checksums.sh` regenerates sha256. `sdd-kit/verify.sh` hub parity covers only `templates/scripts/*.sh` — the day-1 doc mirror is therefore gated explicitly by a `diff -q` in tasks (adversarial review: checksum regen would re-stamp a stale template as valid). Version alignment per the existing "Version alignment on release" requirement: MANIFEST `version` and `guide_version` → **1.8.0**, guide header version, changelog §14 entry, and `openspec/project.md` cross-references — which also fixes the pre-existing mismatch (guide header 1.6.1 vs MANIFEST 1.7.0).

## Risks / Trade-offs

- [Doc drift: scope story diverges across surfaces] → single canonical table (D1); other surfaces are ≤3-sentence summaries + link, checked in review.
- [Banner promises what the script doesn't do] → D3 ships in the same change as D4; tasks order behavior before copy.
- [Hub-mode changes greenfield behavior for existing users] → target-local copies always win; hub fallback only fires where today's behavior is a hard error (preflight) or a silent no-op (kit phase) — both strictly worse than the fallback.
- [Stale forgotten checksums abort installs in consumer repos] → `gen-manifest-checksums.sh` is an explicit gated task; `verify.sh` parity gate catches script misses; day-1 doc mirror gated by explicit `diff -q`.
- [Skipping `npm install -g` leaves an outdated CLI on the machine] → `min_openspec` WARN (D3) + C2b covers refresh.
- [Consumer repo prints a next-project command it cannot serve] → completion message resolves its own source root and degrades to hub-clone guidance when no kit is present (D4).
- [pt-BR banner strings drift from en] → both string sets edited in the same function/case block; task gate greps both.

## Migration Plan

Docs + script change, hub-first: edit hub files → mirror to templates → regen checksums → version bump. Consumers pick it up via standard C2 upgrade (`upgrade.sh --dry-run` → `--apply`). Rollback = git revert; no data or state migration.

## Open Questions

- None blocking. Future change candidate: package `/opsx:*` as a Claude Code plugin + optional `bbv` wrapper (tracked as out of scope here).

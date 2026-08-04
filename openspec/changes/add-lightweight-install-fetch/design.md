## Context

See proposal.md for motivation. Two facts, verified by direct inspection rather than assumed, shape this design:

1. **The payload is self-contained.** Every one of the 44 entries in `sdd-kit/MANIFEST.yaml` has a `source:` under `templates/...` inside `sdd-kit/`. `sdd-kit/install.sh` reads exclusively from `$KIT_DIR/$src` (`KIT_DIR` = `sdd-kit` itself). No install-time file comes from hub-only `doc/`, hub-only `openspec/` (its own specs/changes history), or root `.cursor/`/`.claude/` (the hub's own IDE config). Byte-diffing every root `scripts/*.sh` against `sdd-kit/templates/scripts/*.sh` confirms all are identical except four hub-only maintenance scripts (`archive-and-merge.sh`, `close-stale-translate-archive-prs.sh`, `translate-guide-next-wave.sh`, `verify-i18n-wave.sh`) that no MANIFEST entry references.
2. **The path resolution already works against a footprint-only checkout, provided the documented entry points are used.** `scripts/bootstrap-sdd.sh` resolves `SOURCE_ROOT` as `dirname(script)/..` (line 76) purely to support the separate "one hub clone reused across projects" flow (`clarify-install-scope-ux`). When `scripts/bootstrap-sdd.sh` and `scripts/preflight-sdd.sh` are present at the target repo's own root (not just inside `sdd-kit/templates/scripts/`), every fallback branch resolves target-locally (`$REPO/scripts/...`, `$REPO/sdd-kit/...`) with no dependency on `SOURCE_ROOT` at all. This is only true for the *documented* invocation `bash scripts/bootstrap-sdd.sh`; invoking the mirror at `sdd-kit/templates/scripts/bootstrap-sdd.sh` directly is not a supported entry point and is out of scope here.

## Goals / Non-Goals

**Goals:**
- Document, in the canonical guide, the exact minimal set of paths an AI agent (or human) needs to fetch for a genuine C1 greenfield install, with the evidence for why that set is sufficient.
- Provide one concrete, copy-pasteable fetch recipe that lands those paths at their real relative locations, so the existing documented command (`bash scripts/bootstrap-sdd.sh --profile <PROFILE>`) works unmodified — no new invocation syntax to teach.
- Make the lightweight fetch the default suggestion in the §2.0 AI-assisted install prompt, with a full hub clone as the explicit alternative for operators who want the persistent multi-project reuse flow.

**Non-Goals:**
- Changing `install.sh` / `bootstrap-sdd.sh` / `preflight-sdd.sh` logic — traced and confirmed to already work correctly against the minimal footprint.
- Replacing or renegotiating `clarify-install-scope-ux` (hub-clone-per-machine, multi-project reuse) — that remains the right answer for operators bootstrapping many target repos from one place.
- Supporting non-GitHub git hosts with host-specific tricks (e.g., tarball URLs) — the primary recipe uses plain git, which is host-agnostic and already a hard prerequisite (guide §1.1: Git 2.40+).
- Covering C2 (upgrade) or C3 (spec propagation) acquisition — this proposal is scoped to genuine C1 greenfield only, where `sdd-kit/` does not yet exist in the target repo.

## Decisions

**Decision: the minimal footprint is `sdd-kit/` (whole subtree) + `scripts/bootstrap-sdd.sh` + `scripts/preflight-sdd.sh` — not `sdd-kit/` alone.**
Rationale: `sdd-kit/` alone is sufficient for `install.sh` to run (it resolves its own preflight fallback via `$KIT_DIR/templates/scripts/preflight-sdd.sh`), but running the *orchestrator* (`bootstrap-sdd.sh`, which installs OpenSpec/GitNexus/Graphify CLIs before delegating to `install.sh`) via its only-other-location copy (`sdd-kit/templates/scripts/bootstrap-sdd.sh`) is not a documented, supported invocation. Including the two real root scripts costs 32KB and lets the fetch recipe terminate in exactly the command the guide already teaches (`bash scripts/bootstrap-sdd.sh --profile X`), with zero new surface for agents to learn or get wrong.
Alternative considered: document `bash sdd-kit/templates/scripts/bootstrap-sdd.sh .` as a new supported entry point instead of fetching the two extra root scripts. Rejected — it adds a second, less-discoverable command surface for the same operation, and ties the fetch recipe to an internal template-mirror path that could move without notice in a future kit refactor (it is documented today only as an informational mirror reference, not a contract).

**Decision: use plain git (partial clone + non-cone sparse-checkout) as the primary fetch recipe, not a third-party tool or host-specific tarball trick.**
Rationale: Git ≥2.40 is already a hard host prerequisite (guide §1.1), so this introduces zero new dependency. `git clone --filter=blob:none --depth 1 --no-checkout --sparse <repo-url> <tmpdir>` followed by `git sparse-checkout set --no-cone /sdd-kit/ /scripts/bootstrap-sdd.sh /scripts/preflight-sdd.sh` and `git checkout` fetches only the blobs for the three requested paths at the tip commit — no full history, no unrelated top-level directories. The fetched tree is then copied (not moved) into the target repo root, and the temporary clone is discarded, leaving the target repo's own git history untouched.
Alternatives considered:
- *Third-party subdirectory-export tool (degit-style)*: adds a mandatory `npx <pkg>` fetch from the npm registry purely to move files, and only cleanly exports one contiguous subtree per invocation — would need three separate invocations (or two plus a manual curl) to cover `sdd-kit/` and the two root scripts. More moving parts than git alone, for no capability git doesn't already have.
- *GitHub tarball + `tar` extraction*: works, but `tar --wildcards` (needed to filter a codeload tarball by pattern) is a GNU tar extension not available in the `bsdtar` shipped by default on macOS 13+ — one of this guide's two supported host OSes (§1.1). Avoiding wildcards entirely by naming exact prefixed member paths sidesteps that, but still ties the recipe to a GitHub-specific URL scheme (`codeload.github.com`), which the git-based recipe does not.
- *Full shallow clone without sparse-checkout (`--depth 1` only)*: much simpler, but still pulls `doc/` (3.3M) and `openspec/` (5.3M) — the two largest hub-only directories — so it does not solve the actual size/relevance problem this proposal targets.

**Decision: scope the recipe to genuine C1 greenfield only (no `sdd-kit/` present yet), leave C2/C3 untouched.**
Rationale: C2 (upgrade) already has a documented, working flow (`sdd-kit/upgrade.sh --dry-run`/`--apply`) that assumes `sdd-kit/` is already present; C3 (spec propagation) explicitly must not run `install.sh`/`upgrade.sh` at all. Extending the lightweight-fetch framing to those scenarios would duplicate existing, already-correct guidance for no benefit.

## Risks / Trade-offs

- [Non-cone sparse-checkout syntax is less commonly known than cone mode] → Mitigation: the guide ships the exact copy-pasteable block; a task gate runs it against the real repo before publishing to confirm the patterns resolve as intended.
- [A git remote/proxy with `uploadpack.allowFilter` disabled could reject `--filter=blob:none`] → Mitigation: guide documents a one-line fallback (`--depth 1` shallow clone without the blob filter, still sparse-checked-out to the same three paths) for that edge case; GitHub.com itself supports partial clone natively.
- [An agent could run this recipe against a repo that already has `sdd-kit/` (i.e., not actually greenfield)] → Mitigation: guide explicitly gates the recipe on "only when `sdd-kit/` is absent," matching the existing C1-vs-C2 distinction in §2.9.1.
- [Temporary clone directory left behind if a hand-run snippet is interrupted mid-way] → Mitigation: recipe uses `mktemp -d` and an unconditional `rm -rf` at the end; guide notes it is safe to rerun from scratch since nothing is written to the target repo until the final copy step.

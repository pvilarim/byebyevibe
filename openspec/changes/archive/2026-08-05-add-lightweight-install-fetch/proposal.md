## Why

AI-agent-driven greenfield installs (C1) are only ever told to clone the full hub repository ("keep one hub clone per machine" — guide §1.6), but a full clone pulls ~14MB (`doc/` 3.3M + `openspec/` 5.3M + `.git` 4.3M of the hub's own history/specs/course material) when the actual versioned install payload is `sdd-kit/` (504K) plus two root scripts (32K). This forces every agent asked to install ByeByeVibe into a fresh repo to either clone the whole hub unnecessarily or ask the user whether to do so, with no lighter alternative documented anywhere. Verified by tracing `sdd-kit/MANIFEST.yaml` (all 44 entries source from `templates/...`, none from hub-only `doc/`/`openspec/`/root `.cursor/`/`.claude/`) and by byte-diffing every root `scripts/*.sh` against its `sdd-kit/templates/scripts/` mirror (all identical except four hub-only maintenance scripts irrelevant to installs).

## What Changes

- Guide §1.6 (or an adjacent subsection) gains an explicit **minimal install-fetch footprint** statement: exactly which three paths (`sdd-kit/` whole subtree, `scripts/bootstrap-sdd.sh`, `scripts/preflight-sdd.sh`) are necessary and sufficient for a greenfield C1 install, grounded in the MANIFEST/diff evidence, so a reader (human or agent) does not have to infer this from repo layout.
- Guide §2.0 (AI-assisted installation prompt) is updated so agents default to a **lightweight, no-full-clone fetch** of that minimal footprint for genuine greenfield targets, reserving a full hub clone for operators who explicitly want the persistent multi-project hub→destination workflow already documented by `clarify-install-scope-ux`.
- The guide documents one concrete lightweight-fetch recipe as the primary method (with at most one fallback noted), chosen for reliability when executed by an AI agent without additional global tool installs.
- `sdd-kit/README.md` and/or the root `README.md` gain, at most, a short pointer to the new guide subsection — no duplication of the fetch recipe or the footprint table.

Out of scope: any change to `install.sh` / `bootstrap-sdd.sh` internal path-resolution logic (traced and confirmed to already work correctly with a footprint-only fetch, provided the documented invocation paths are used — see design.md); reworking `clarify-install-scope-ux` (already implemented, addresses the separate multi-project-reuse scenario); any change to per-project generated state (`openspec/`, `graphify-out/`, `.gitnexus/`) layout.

## Capabilities

### New Capabilities

_None._

### Modified Capabilities

- `sdd-install-kit`: guide must document the minimal install-fetch footprint (three paths, with rationale) and a lightweight no-full-clone fetch recipe as the default acquisition method for AI-agent-driven greenfield installs; the §2.0 AI-assisted install prompt must reference this method before suggesting a full hub clone.

## Impact

- **Docs (hub):** `doc/byebyevibe-guide.md` (§1.6 and/or new subsection near §2.0/§2.0b), `sdd-kit/README.md` (pointer only), `README.md` (pointer only, if warranted).
- **No script changes.** `sdd-kit/install.sh` and `scripts/bootstrap-sdd.sh`/`preflight-sdd.sh` already resolve correctly against the minimal footprint when invoked via their documented (repo-root-relative) paths — confirmed by tracing the conditional branches, not assumed.
- **No new dependencies; no CI workflow changes.**
- **Language policy (F7):** versioned guide prose in English, per existing convention.

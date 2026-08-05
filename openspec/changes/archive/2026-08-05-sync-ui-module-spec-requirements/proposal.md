## Why

Two behaviours the repository actually ships are mandated by **no live requirement** in `openspec/specs/**`:

1. `sdd-kit/templates/openspec/infra.md:85` ships a `## UI Development Module` section (and the hub's own `openspec/infra.md:98` carries it), but `sdd-workspace-manifest`'s "Manifest sections" requirement does not list that section among the required ones.
2. `doc/byebyevibe-guide.md:608` defines `#### 2.11.1 UI module verification checklist`, referenced from the §2.11 step table (line 596), but no requirement in `sdd-post-install-verification` requires it to exist.

The C1-UI module was specified in change `add-sdd-ui-development-module` (archived on `master` under `openspec/changes/archive/2026-07-26-add-sdd-ui-development-module/`). Its `specs/sdd-workspace-manifest/` and `specs/sdd-post-install-verification/` deltas were written but **never merged into the live specs** — the archive move landed on `master` while those two deltas did not. Verified by reading both archived delta files and grepping the live specs for their requirement bodies.

Consequence: the specs under-describe the shipped product. A future kit refactor could drop the `UI Development Module` template section or guide §2.11.1 and no gate — `openspec validate --all --strict`, `sdd-kit/verify.sh`, or CI — would catch the regression.

The same gap is what makes open PR **#17** (`archive add-sdd-ui-development-module`) the one archive PR in the 2026-08-05 cleanup batch that is not fully redundant with `master`. That PR is not the right vehicle to close the gap: it carries the pre-rename guide path `doc/sistema-sdd-pedro.md` (4 occurrences), stale since v1.7.0, and its requirement headings do not match the archived deltas' headings. This change closes the gap with current wording instead, after which #17 can be closed as superseded.

## What Changes

- `sdd-workspace-manifest`: the "Manifest sections" requirement gains **UI Development Module** in its list of sections `openspec/infra.md` must include.
- `sdd-post-install-verification`: a new requirement mandates guide **§2.11.1** (UI module verification checklist), presented as an extension of the §2.8 checklist rather than a replacement, and reachable from the §2.11 procedure.

**Documentation-only, no implementation work.** Both behaviours already exist at the paths cited above; this change makes the specs describe reality so the existing gates can defend it. No script, template, guide, or kit content is modified — so no `MANIFEST.yaml` version bump and no checksum regeneration.

Out of scope: the `sdd-ui-module` capability spec itself (already live on `master`, 9 requirements, unaffected); the `sdd-install-kit` delta from the same archived change (already reflected on `master`); closing PR #17 (a separate operator action, unblocked by this change).

## Capabilities

### New Capabilities

_None._

### Modified Capabilities

- `sdd-workspace-manifest`: required-sections list for `openspec/infra.md` must include **UI Development Module**.
- `sdd-post-install-verification`: guide must carry a §2.11.1 UI module verification checklist as an extension of §2.8.

## Impact

- **Specs (hub):** `openspec/specs/sdd-workspace-manifest/spec.md`, `openspec/specs/sdd-post-install-verification/spec.md` — both updated at archive time from this change's deltas.
- **No code, no templates, no kit version bump.** Verified: every behaviour these requirements mandate is already present.
- **Language policy (F7):** versioned spec prose in English, per existing convention.

## Context

`add-github-release-flow` built the release machinery and cut `v1.12.0`. It deliberately did not touch the acquisition default, for a stated reason: the `sdd-install-kit` spec mandates the §1.6 sparse-checkout recipe as the default, and inverting that needed "a delta to that spec plus at least one published release actually existing." Both conditions are now met.

Current state, measured rather than assumed:

- The three git trees in the install footprint (`sdd-kit`, `scripts/bootstrap-sdd.sh`, `scripts/preflight-sdd.sh`) have **identical hashes** at `v1.12.0` and at `master`. Nobody is currently harmed by the default.
- The guide is **not** inside `sdd-kit/` — proven by that same hash equality, since the §2.18 troubleshooting row added after the cut did not move the kit tree. Guide-only releases therefore produce content-identical tarballs.
- The published assets are `byebyevibe-kit-1.12.0.tar.gz` and its `.sha256`. Both names carry the version.

That last fact is the whole technical problem. GitHub's stable shortcut is `https://github.com/<owner>/<repo>/releases/latest/download/<asset-name>` — it needs the asset *name*, and the name contains the version, which is what the downloader is trying to discover. Naming it requires already knowing it.

## Goals / Non-Goals

**Goals:**

- Default acquisition = the latest published Release, for both the human path (§1.6) and the AI-agent path (§2.0).
- A release-download recipe no longer than the sparse-checkout recipe it displaces. If the default is more typing, people will keep pasting the recipe and the change is cosmetic.
- Checksum verification as a mandatory step of the documented recipe, not an optional flourish.
- No new entry in §1.1's prerequisite list.

**Non-Goals:**

- Removing the sparse-checkout recipe. It remains the only way to install from unreleased `master`, and the only way to install a state older than the first release.
- Changing what the tarball contains. The footprint is settled (D4 of `add-github-release-flow`).
- Publishing to npm or any package registry.
- Touching `sdd-kit/templates/` or any consumer-facing payload.
- Changing `§2.0b` (first-contact quickstart). It presumes the kit is already present and says nothing about acquisition.

## Decisions

### D1 — Add a stable-named asset pair; keep the version-stamped pair

Each Release gains `byebyevibe-kit.tar.gz` and `byebyevibe-kit.tar.gz.sha256`, built from the same bytes as the version-stamped pair.

This is what makes `releases/latest/download/` usable, and it is the minimum that does. The version-stamped assets stay because they are the citable, archival artifact: §2.18's regeneration command produces exactly that filename, `v1.12.0` already published under it, and a bare `byebyevibe-kit.tar.gz` sitting in a downloads folder identifies nothing.

Losing the version from the *filename* costs less than it appears: the archive's top-level prefix is still `byebyevibe-kit-<version>/`, so extracting a stable-named tarball yields a version-stamped directory, and `sdd-kit/MANIFEST.yaml` inside declares the version authoritatively.

The `.sha256` for the stable-named asset must be generated **against the stable filename**, so `sha256sum -c` succeeds against a file downloaded under that name. Two checksum files with identical hashes and different filenames is the small, deliberate cost.

**Alternative rejected:** rename the asset version-less and drop the version-stamped pair. Cleaner inventory, but it breaks symmetry with the already-published `v1.12.0`, removes the archival name §2.18 documents, and would make a downloaded file self-identify only after extraction.

**Alternative rejected:** a `-latest` suffix (`byebyevibe-kit-latest.tar.gz`). Actively misleading, because the same asset is also reachable pinned per tag (`releases/download/v1.12.0/byebyevibe-kit-latest.tar.gz`), where "latest" is a lie.

### D2 — Acquire with `curl` against the `latest/download` shortcut; no `gh`, no API parsing

Verified against this repository, not assumed:

```
GET /releases/latest/download/byebyevibe-kit-1.12.0.tar.gz
  → 302 Location: /releases/download/v1.12.0/byebyevibe-kit-1.12.0.tar.gz
```

The shortcut resolves the **tag** server-side, unauthenticated, in one redirect. No API call, no token, no `jq`.

A second measurement matters for the recipe's shape: a request for an asset name that does **not** exist redirects identically and only 404s at the final URL. So the failure surfaces late, on the object host.

**Alternative rejected:** `gh release download`. One line shorter, but it adds an authenticated CLI to §1.1's prerequisites — a real cost against the "no new prerequisite" goal — and fails for anyone who has `gh` but no token.

**Alternative rejected:** query `/repos/:owner/:repo/releases/latest` and parse `browser_download_url`. Needs `jq` (new prerequisite) or fragile `grep`/`sed`, and adds a round trip, to arrive where a stable filename already gets you.

### D3 — `curl -fsSL`, and the `-f` is load-bearing

Without `-f`, curl writes the 404 body — GitHub's HTML error page — into the output file and exits 0. `tar` then fails with a gzip-format complaint that points at nothing useful, and a `sha256sum -c` run against the HTML fails for the wrong reason. With `-f`, curl exits non-zero and the recipe stops where the fault is.

Given D2's finding that a missing asset only 404s after the redirect, this is not a hypothetical: it is the exact shape of the failure a downloader hits if the stable-named asset is ever absent from a release — including every release before this change lands.

### D4 — Verification is a step of the recipe, not a suggestion

The recipe downloads both files and runs `sha256sum -c` before extracting. A checksum published next to an artifact that the documented procedure never checks is decoration; and the `.sha256` sidecar is one of the two things `add-github-release-flow`'s acceptance criteria bought.

On Windows this is why the recipe belongs in Git Bash rather than PowerShell: `sha256sum` and `tar` both ship with Git for Windows, while PowerShell's `Get-FileHash` has different output and no `-c` mode.

### D5 — Primacy swaps; the sparse-checkout recipe stays, re-scoped

§1.6 leads with the release-download recipe. The sparse-checkout recipe follows, explicitly scoped to "installing from unreleased `master`" — development against the hub, or a state predating the first release. §2.0's three-option list reorders to match, with the Release first and the full hub clone still reserved for the persistent multi-project workflow.

Nothing is deleted. The recipe stops being the default and becomes the answer to a narrower, still-real question.

### D6 — Releases become load-bearing, and the guide has to say so

This is the consequence that makes the change more than a text edit. Before it, a `sdd-kit/` change merged without a release harmed nobody, because every install came from `master`. After it, the same omission silently hands every new installer an **older** kit than `master`. The debt inverts sign.

There is no mechanism proposed to enforce this — a gate that fails CI whenever `sdd-kit/` moves ahead of the last release would fire on every legitimate in-progress branch, which is worse than the problem. Instead §2.18 states the consequence plainly next to the cut procedure, where an operator about to merge a kit change will read it. If it turns out to bite in practice, a warning (not a gate) in `verify-release-readiness.sh` is the natural follow-up, and it deserves the evidence of having actually happened first.

## Risks / Trade-offs

| Risk | Mitigation |
|------|------------|
| The stable-named asset is absent from every release published before this change, so `releases/latest/download/byebyevibe-kit.tar.gz` 404s until the next cut | The change ships with a version bump and its own release; the guide's new recipe is only correct from that release onward. D3's `-f` makes the interim failure loud rather than a corrupt extract. `v1.12.0` remains installable by its version-stamped name |
| A kit change merged without cutting a release now downgrades new installs | D6 — stated in §2.18 next to the cut procedure. Deliberately not enforced by a gate, which would fire on every in-progress branch |
| Two asset pairs with identical bytes and different checksum files invites "which one do I trust?" | §2.18 states they are the same bytes and why both exist: stable name for acquisition, version-stamped name for citation and archival |
| Someone follows the recipe in PowerShell and hits missing `sha256sum` | D4 — the recipe is documented as Git Bash on Windows, with the reason given rather than asserted |
| An agent reads §2.0 and still uses sparse-checkout | The requirement is normative in `sdd-install-kit`, so it is reviewable, but a prompt is instructions and not a mechanism. Accepted: the same limitation the current default already has, pointed the other way |
| The `latest` shortcut's behaviour changes on GitHub's side | It is a documented, long-standing endpoint, and the failure mode is a 404 that D3 turns into a hard stop. The version-stamped URL remains a stable fallback and stays documented |
| Merge collision with any concurrent change on §1.6 / §2.0 / the changelog | Mechanical and expected on kit changes; serialize the merges |

## Migration Plan

1. `.github/workflows/release.yml` — build the stable-named copies from the same tar stream, generate the `.sha256` against the stable filename, attach all four assets to the draft before publishing.
2. Guide §1.6 — new release-download recipe first, sparse-checkout recipe re-scoped and moved below it.
3. Guide §2.0 — reorder the three acquisition options; Release first, hub clone and sparse-checkout after.
4. Guide §2.18 — document the four-asset inventory and D6's stale-release consequence.
5. Spec deltas — `sdd-install-kit` (default inverts), `sdd-release-flow` (stable-named asset pair required).
6. Version bump in lockstep + changelog entry; `verify-release-readiness.sh` and `sdd-kit/verify.sh` green.
7. Merge, then cut the release — the first one whose assets make the new recipe work.

Rollback before the release: revert the commit. The guide reverts to the recipe default and no published asset is invalidated, because this change only ever *adds* assets. After the release: the stable-named assets stay valid; reverting the documentation is enough, no republication needed.

## Open Questions

None blocking.

Deliberately deferred: whether `verify-release-readiness.sh` should warn when `sdd-kit/` has moved ahead of the last published tag (D6 — wants evidence of the omission actually happening); and whether the root `README.md` install section should mirror §1.6's new order (it currently points at the guide rather than duplicating a recipe, which is the behaviour `clarify-install-scope-ux` established and this change has no reason to disturb).

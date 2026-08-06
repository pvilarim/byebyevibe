## 1. Release-note extraction

- [ ] 1.1 Create `scripts/release-notes.sh <version>`: print the body of the `### <version> (YYYY-MM-DD)` section of `doc/byebyevibe-guide.md` `## Guide changelog`, verbatim, ending at the next `^### ` or `^## ` heading. Anchor the match on the escaped version followed by ` (` so `1.1.0` cannot be satisfied by `1.11.0`. Exit non-zero with a message naming the version and the file when the section is absent or its body is empty. `set -euo pipefail`, same header-comment style as the sibling scripts.
  - **Pattern:** `scripts/verify-release-readiness.sh`
  - **Gate:** `test -x scripts/release-notes.sh`
- [ ] 1.2 Verify extraction against the two most recent real entries and against the collision and absence cases.
  - **Gate:** `bash scripts/release-notes.sh 1.11.0 | grep -q 'Release-readiness gate' && bash scripts/release-notes.sh 1.10.0 | grep -q 'Version-sync gate' && ! bash scripts/release-notes.sh 1.1.0 >/dev/null 2>&1 && ! bash scripts/release-notes.sh 9.9.9 >/dev/null 2>&1`

## 2. Guarded release cut

- [ ] 2.1 Create `scripts/cut-release.sh <version>` implementing every precondition from design D1/D8 in order, aborting non-zero and leaving the repo unmodified on the first failure: clean working tree; on the default branch (`master`) and not behind `origin/master`; `version:` equals `guide_version:` in `sdd-kit/MANIFEST.yaml`; both equal the requested version; `bash scripts/release-notes.sh <version>` succeeds with non-empty output; `bash scripts/verify-release-readiness.sh` exits zero; tag `v<version>` absent locally and on the remote.
  - **Pattern:** `scripts/verify-release-readiness.sh`
  - **Gate:** `test -x scripts/cut-release.sh`
- [ ] 2.2 On all preconditions passing, create the annotated tag `v<version>` with the extracted notes as the tag message, push it with `git push origin "v<version>"`, and print the pushed tag name.
  - **Gate:** `grep -q 'git push origin' scripts/cut-release.sh && grep -q 'git tag -a' scripts/cut-release.sh`
- [ ] 2.3 Confirm the divergence guard and the mismatch guard fire, using a throwaway copy of the MANIFEST so the live repo state is never edited.
  - **Gate:** `! bash scripts/cut-release.sh 9.9.9 >/dev/null 2>&1`

## 3. Release workflow

- [ ] 3.1 Create `.github/workflows/release.yml`: trigger `on: push: tags: ['v*']`, `permissions: contents: write`, `runs-on: ubuntu-latest`, `actions/checkout` pinned by SHA with `fetch-depth: 0`. Do not add any other third-party Action (design D6).
  - **Pattern:** `.github/workflows/sdd-gates.yml`
  - **Gate:** `grep -q 'contents: write' .github/workflows/release.yml && grep -qE "tags:" .github/workflows/release.yml`
- [ ] 3.2 Add the two publication guards: `bash scripts/verify-release-readiness.sh`, and an ancestry assertion that the tagged commit is contained in `origin/master` (`git merge-base --is-ancestor "$GITHUB_SHA" origin/master`). Both blocking, no `continue-on-error`.
  - **Gate:** `grep -q 'verify-release-readiness.sh' .github/workflows/release.yml && grep -q 'merge-base --is-ancestor' .github/workflows/release.yml`
- [ ] 3.3 Build the artifact exactly as specified in design D5 — `git archive --format=tar --prefix="byebyevibe-kit-${VERSION}/" "v${VERSION}" sdd-kit scripts/bootstrap-sdd.sh scripts/preflight-sdd.sh | gzip -n` — and write a `.sha256` sidecar next to it.
  - **Gate:** `grep -q 'git archive --format=tar' .github/workflows/release.yml && grep -q 'gzip -n' .github/workflows/release.yml`
- [ ] 3.4 Guard on `command -v gh` with an explicit failure message before the build steps (design risk table), then publish with `gh release create "v${VERSION}" --verify-tag --title "v${VERSION}" --notes-file <(bash scripts/release-notes.sh "$VERSION")` (or an equivalent temp-file form) attaching both assets, authenticated via `GITHUB_TOKEN`. No third-party release Action.
  - **Gate:** `grep -q 'gh release create' .github/workflows/release.yml && [ "$(grep -c 'uses:' .github/workflows/release.yml)" -eq 1 ]`
- [ ] 3.5 Confirm `.github/workflows/sdd-gates.yml` is unmodified by this change and still declares `contents: read`.
  - **Pattern:** `.github/workflows/sdd-gates.yml`
  - **Gate:** `grep -q 'contents: read' .github/workflows/sdd-gates.yml && git diff --quiet HEAD -- .github/workflows/sdd-gates.yml`

## 4. Documentation

- [ ] 4.1 Add `### 2.18 Release flow (cut-release) — operation` to `doc/byebyevibe-guide.md`, after §2.17, modeled on §2.12's structure: what it does, the single-axis decision and the lockstep invariant, the `bash scripts/cut-release.sh <version>` command, the precondition list with the failure message for each, the verbatim `git archive` regeneration command, the byte-identity caveat from design D5, and a troubleshooting table.
  - **Pattern:** `doc/byebyevibe-guide.md`
  - **Gate:** `grep -q '### 2.18' doc/byebyevibe-guide.md && grep -q 'cut-release.sh' doc/byebyevibe-guide.md`
- [ ] 4.2 In §1.6 "Lightweight fetch recipe", add a pointer offering the Release tarball as the simpler path for anyone installing a released version, keeping the sparse-checkout recipe as the option for unreleased `master`.
  - **Pattern:** `doc/byebyevibe-guide.md`
  - **Gate:** `grep -n 'Lightweight fetch recipe' -A 6 doc/byebyevibe-guide.md | grep -q 'Release'`
- [ ] 4.3 Add the release-flow row to the §5 / `AGENTS.md` command tables so `scripts/cut-release.sh` is discoverable alongside the other `scripts/` entries.
  - **Pattern:** `AGENTS.md`
  - **Gate:** `grep -q 'cut-release.sh' AGENTS.md`

## 5. Version and changelog

- [ ] 5.1 Bump `sdd-kit/MANIFEST.yaml` `version:` and `guide_version:` 1.11.0 → 1.12.0 together (design D9 — the single tag axis requires lockstep).
  - **Pattern:** `sdd-kit/MANIFEST.yaml`
  - **Gate:** `grep -qE '^version: "1\.12\.0"' sdd-kit/MANIFEST.yaml && grep -qE '^guide_version: "1\.12\.0"' sdd-kit/MANIFEST.yaml`
- [ ] 5.2 Sync all three declared version strings in the same commit so `verify-release-readiness.sh` never goes red: `sdd-kit/README.md` H1, the guide's `Canonical install guide (vX.Y.Z)` blockquote, and the guide's `**Guide version:**` line.
  - **Pattern:** `sdd-kit/README.md`
  - **Gate:** `bash scripts/verify-release-readiness.sh`
- [ ] 5.3 Add the `### 1.12.0 (YYYY-MM-DD)` entry to `doc/byebyevibe-guide.md` `## Guide changelog`, describing the release flow, the single-axis decision, the tarball, and the fact that no template bytes changed so a C2 upgrade delivers no diff.
  - **Pattern:** `doc/byebyevibe-guide.md`
  - **Gate:** `grep -q '### 1.12.0' doc/byebyevibe-guide.md && bash scripts/release-notes.sh 1.12.0 | grep -q .`
- [ ] 5.4 Confirm no checksum regeneration is needed — nothing under `sdd-kit/templates/` changed.
  - **Gate:** `bash sdd-kit/gen-manifest-checksums.sh --check`

## 6. Verification

- [ ] 6.1 Run the repo-state gate standalone — must exit 0.
  - **Gate:** `bash scripts/verify-release-readiness.sh`
- [ ] 6.2 Run the full local verify — must exit 0.
  - **Gate:** `bash sdd-kit/verify.sh`
- [ ] 6.3 Dry-run the artifact build against `HEAD` (not a tag) and confirm the footprint matches §1.6's sparse-checkout list and that two consecutive builds are byte-identical.
  - **Gate:** `D=$(mktemp -d) && for i in 1 2; do git archive --format=tar --prefix=t/ HEAD sdd-kit scripts/bootstrap-sdd.sh scripts/preflight-sdd.sh | gzip -n | sha256sum | cut -d" " -f1 > "$D/h$i"; done && diff -q "$D/h1" "$D/h2" && tar tzf <(git archive --format=tar --prefix=t/ HEAD sdd-kit scripts/bootstrap-sdd.sh scripts/preflight-sdd.sh | gzip -n) | grep -q 't/scripts/bootstrap-sdd.sh'`
- [ ] 6.4 Validate the change against OpenSpec.
  - **Gate:** `npx --yes @fission-ai/openspec@1.3.1 validate --all --strict`

## 7. Manual follow-up (outside apply)

- [ ] 7.1 [MANUAL ACTION REQUIRED] [BLOCKING — before any release is cut] Close `add-release-readiness-gate` task 6.1: add `Release readiness (blocking)` as a required status check under GitHub Settings → Branches for `master`. Until this is done, `master` can carry a commit the gate would reject (research.md D-REL-2).
  - **Gate:** — (GitHub repository setting, not a repo file; verify by opening a PR with a deliberate version-sync mismatch and confirming merge is blocked)
- [ ] 7.2 [MANUAL ACTION REQUIRED] After merge, cut the first release: `bash scripts/cut-release.sh 1.12.0`. Confirm the Release appears with the extracted 1.12.0 notes and both assets, and that the published `.sha256` matches a local regeneration from the tag.
  - **Gate:** — (post-merge operator action; verify on the Releases page and with `sha256sum -c`)

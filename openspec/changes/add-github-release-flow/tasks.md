## 1. Release-note extraction

- [x] 1.1 Create `scripts/release-notes.sh <version> [source-file]`: print the body of the `### <version> (` section of the source file (default `doc/byebyevibe-guide.md`), verbatim, ending at the next line starting with `### ` or `## `, or at end of file. Anchor the match on the escaped version followed by ` (` so `1.1.0` cannot be satisfied by `1.11.0`; the date shape is NOT part of the anchor, so the legacy `### 1.0.0 (2026-05)` entry extracts normally. Exit non-zero with a message naming the version and the file when the section is absent OR when it contains no non-blank body line. The optional second argument is the test hook required by the spec. `set -euo pipefail`, same header-comment style as the sibling scripts.
  - **Pattern:** `scripts/verify-release-readiness.sh`
  - **Gate:** `test -x scripts/release-notes.sh`
- [x] 1.2 Verify extraction against real entries and hermetic fixtures: `1.11.0` and `1.10.0` extract; `1.1.0` (which EXISTS at the changelog's tail) returns its own body and nothing from `1.11.0`; the legacy `1.0.0` extracts; an absent version fails; an empty-bodied section (fixture file) fails.
  - **Gate:** `bash scripts/release-notes.sh 1.11.0 | grep -q 'Release-readiness gate' && bash scripts/release-notes.sh 1.1.0 | grep -q 'install artifact' && ! bash scripts/release-notes.sh 1.1.0 | grep -q 'Release-readiness gate' && bash scripts/release-notes.sh 1.0.0 | grep -q . && ! bash scripts/release-notes.sh 9.9.9 2>/dev/null && F=$(mktemp) && printf '## Guide changelog\n\n### 2.0.0 (2026-01-01)\n\n### 1.9.9 (2026-01-01)\n\n- real body\n' > "$F" && ! bash scripts/release-notes.sh 2.0.0 "$F" 2>/dev/null && bash scripts/release-notes.sh 1.9.9 "$F" | grep -q 'real body' && rm -f "$F"`

## 2. Guarded release cut

- [x] 2.1 Create `scripts/cut-release.sh <version> [--dry-run]`. First action: `git fetch origin master --tags` — an unreachable remote aborts with a named error. Then verify, in order, aborting non-zero with a message naming the failed check: clean working tree; on `master` AND `HEAD` equals the freshly fetched `origin/master` commit exactly (behind, ahead, and diverged all fail); `version:` equals `guide_version:` in `sdd-kit/MANIFEST.yaml` (divergence message must name both fields and values, per D1); both equal the requested version; `bash scripts/release-notes.sh <version>` succeeds with non-empty output; `bash scripts/verify-release-readiness.sh` exits zero; tag `v<version>` absent locally and on the remote. With `--dry-run`, report every precondition's outcome and exit without creating or pushing anything, even when all pass.
  - **Pattern:** `scripts/verify-release-readiness.sh`
  - **Gate:** `test -x scripts/cut-release.sh && grep -q 'dry-run\|dry_run\|DRY_RUN' scripts/cut-release.sh && grep -q 'git fetch origin' scripts/cut-release.sh`
- [x] 2.2 On all preconditions passing (and not `--dry-run`), create the annotated tag with `git tag -a "v<version>" -m "v<version>"` — the message is the title only; notes live exclusively in the Release body (design D8b) — push it with `git push origin "v<version>"`, and print the pushed tag name.
  - **Gate:** `grep -q 'git tag -a' scripts/cut-release.sh && grep -q 'git push origin' scripts/cut-release.sh`
- [x] 2.3 Exercise the guards without any possibility of a real push: (a) in the live repo, `--dry-run` for the current MANIFEST version must reach the precondition report without tagging (it will report the branch check as failed during apply — that is the expected output, assert the named check appears); (b) copy the repo to a throwaway directory (`cp -R` or `git worktree`), edit the COPY's `sdd-kit/MANIFEST.yaml` `guide_version:` to a different value, run the copy's `scripts/cut-release.sh <version> --dry-run`, and assert the output names the `version:`/`guide_version:` divergence specifically; (c) same copy technique for the requested-version mismatch, asserting its named message. All three runs use `--dry-run`, so even an inverted guard cannot push.
  - **Gate:** `bash scripts/cut-release.sh 9.9.9 --dry-run 2>&1 | grep -qi 'version' && ! git ls-remote --tags origin 2>/dev/null | grep -q 'v9.9.9'`

## 3. Release workflow

- [x] 3.1 Create `.github/workflows/release.yml`: trigger `on: push: tags: ['v*']`, `permissions: contents: write`, `runs-on: ubuntu-latest`, `actions/checkout` pinned to a full commit SHA with `fetch-depth: 0`. No other `uses:` reference of any kind (design D6). First step after checkout: assert the tag name matches `^v[0-9]+\.[0-9]+\.[0-9]+$`, failing explicitly on any other `v*` tag (design D8 #1).
  - **Pattern:** `.github/workflows/sdd-gates.yml`
  - **Gate:** `grep -q 'contents: write' .github/workflows/release.yml && grep -q 'tags:' .github/workflows/release.yml && grep -qE 'v\[0-9\]\+|v\[0-9]' .github/workflows/release.yml`
- [x] 3.2 Add the remaining server-side guards in D8 order, all blocking, no `continue-on-error`: ancestry — resolve the tag to its commit explicitly (`git rev-parse "$GITHUB_SHA^{commit}"`, since GITHUB_SHA names the tag object for annotated tags) and assert `git merge-base --is-ancestor` against `origin/master`; tag↔MANIFEST — assert the version parsed from the tag name equals `version:` in `sdd-kit/MANIFEST.yaml` at the checked-out tagged commit (design D8 #3 — this is the guard that stops a mislabeled hand-pushed tag); readiness — `bash scripts/verify-release-readiness.sh`; `command -v gh` presence check with an explicit failure message.
  - **Gate:** `grep -q 'merge-base --is-ancestor' .github/workflows/release.yml && grep -q '\^{commit}' .github/workflows/release.yml && grep -q 'verify-release-readiness.sh' .github/workflows/release.yml && grep -q 'command -v gh' .github/workflows/release.yml`
- [x] 3.3 Notes extraction as its own blocking step (design D8 #5): run `bash scripts/release-notes.sh "$VERSION" > notes.md` and assert `notes.md` is non-empty with `test -s notes.md`. NEVER inline the extractor into the publish command via process substitution — bash does not propagate its exit status, which would publish an empty-bodied Release on extraction failure. Then build the artifact exactly as design D5 specifies — `git archive --format=tar --prefix="byebyevibe-kit-${VERSION}/" "v${VERSION}" sdd-kit scripts/bootstrap-sdd.sh scripts/preflight-sdd.sh | gzip -n > "byebyevibe-kit-${VERSION}.tar.gz"` — write the `.sha256` sidecar, and append the git-version footer to `notes.md` (`Built with git $(git --version | grep -oE '[0-9.]+') on ubuntu-latest`, design D11).
  - **Gate:** `grep -q 'release-notes.sh' .github/workflows/release.yml && grep -q 'test -s notes.md' .github/workflows/release.yml && ! grep -q 'notes-file <(' .github/workflows/release.yml && grep -q 'git archive --format=tar' .github/workflows/release.yml && grep -q 'gzip -n' .github/workflows/release.yml && grep -q 'git --version' .github/workflows/release.yml`
- [x] 3.4 Publish draft-first (design D10), with `env: GH_TOKEN: ${{ github.token }}` on the publish step (the token is NOT ambient — `gh` fails without this): if a draft Release for the tag already exists from a failed prior run, delete it first (`gh release delete … --yes` guarded on draft status); `gh release create "v${VERSION}" --verify-tag --draft --title "v${VERSION}" --notes-file notes.md` attaching both assets; then `gh release edit "v${VERSION}" --draft=false`.
  - **Gate:** `grep -q 'GH_TOKEN' .github/workflows/release.yml && grep -q -- '--draft' .github/workflows/release.yml && grep -q -- '--draft=false' .github/workflows/release.yml && grep -q 'gh release create' .github/workflows/release.yml`
- [x] 3.5 Confirm `.github/workflows/sdd-gates.yml` is untouched by this change, comparing against the merge base with `origin/master` (comparing against HEAD would be tautological once committed), and that `release.yml`'s only `uses:` lines reference `actions/checkout`.
  - **Pattern:** `.github/workflows/sdd-gates.yml`
  - **Gate:** `git fetch -q origin master && git diff --quiet "$(git merge-base HEAD origin/master)" HEAD -- .github/workflows/sdd-gates.yml && [ -z "$(grep -E '^\s*uses:' .github/workflows/release.yml | grep -v 'actions/checkout')" ]`

## 4. Documentation

- [x] 4.1 Add `### 2.18 Release flow (cut-release) — operation` to `doc/byebyevibe-guide.md`, inserted immediately before the `### 2.9 Upgrading an existing installation` heading (the file's §2 subsections are not in numeric order; §2.17 is the last numbered subsection before §2.9, so this placement is both "after §2.17 in the file" and unambiguous). Model on §2.12's structure: what it does, the single-axis decision and the lockstep invariant, `bash scripts/cut-release.sh <version> [--dry-run]`, the precondition list with each named failure message, the five server-side workflow guards, the yank policy (published versions are immutable; withdraw via a new patch version — D10), the verbatim `git archive` regeneration command, the byte-identity caveat plus the Release-body git-version footer (D5/D11), and a troubleshooting table. Also add §2.18 to the guide's table of contents item for §2.
  - **Pattern:** `doc/byebyevibe-guide.md`
  - **Gate:** `grep -q '### 2.18' doc/byebyevibe-guide.md && grep -q 'cut-release.sh' doc/byebyevibe-guide.md && grep -n '### 2.18' doc/byebyevibe-guide.md | head -1 | cut -d: -f1 | xargs -I{} test {} -lt "$(grep -n '### 2.9 Upgrading' doc/byebyevibe-guide.md | head -1 | cut -d: -f1)"`
- [x] 4.2 In §1.6, immediately after the "Lightweight fetch recipe" code block and its fallback paragraph, add a short pointer: for released versions, downloading `byebyevibe-kit-<version>.tar.gz` from the GitHub Release (verifying the `.sha256`) replaces the recipe; the recipe remains the path for unreleased `master`. Mention the same alternative in the §2.0 AI-assisted install prompt WITHOUT changing its default — the `sdd-install-kit` spec mandates the sparse-checkout recipe as the default acquisition path, and flipping that default is explicitly out of scope (design Open Questions).
  - **Pattern:** `doc/byebyevibe-guide.md`
  - **Gate:** `awk '/#### Lightweight fetch recipe/,/^## 2\./' doc/byebyevibe-guide.md | grep -qi 'release' && awk '/### 2.0 AI-assisted/,/### 2.2/' doc/byebyevibe-guide.md | grep -qi 'tarball\|release'`
- [x] 4.3 Add `bash scripts/cut-release.sh <version>` to the Commands table in the hub's `AGENTS.md` (and only there — the guide's §12.2a/§12.2b command tables are consumer `AGENTS.md` templates, and consumers do not release the kit, so those templates MUST NOT gain this row).
  - **Pattern:** `AGENTS.md`
  - **Gate:** `grep -q 'cut-release.sh' AGENTS.md && ! awk '/### 12.2a/,/### 12.3/' doc/byebyevibe-guide.md | grep -q 'cut-release'`
- [x] 4.4 Fix the dead changelog anchor in the guide header: line ~22's `[Guide changelog](#changelog-do-guia)` points at a Portuguese slug, but the `## Guide changelog` heading generates `#guide-changelog`. Fix this one link (the release flow's §2.18 will reference the changelog; shipping it next to a dead link to that same changelog is avoidable). The rest of the legacy TOC anchor rot stays out of scope.
  - **Pattern:** `doc/byebyevibe-guide.md`
  - **Gate:** `! grep -q 'changelog-do-guia' doc/byebyevibe-guide.md`

## 5. Version and changelog

- [x] 5.1 Bump `sdd-kit/MANIFEST.yaml` `version:` and `guide_version:` 1.11.0 → 1.12.0 together (design D9 — the single tag axis requires lockstep).
  - **Pattern:** `sdd-kit/MANIFEST.yaml`
  - **Gate:** `grep -qE '^version: "1\.12\.0"' sdd-kit/MANIFEST.yaml && grep -qE '^guide_version: "1\.12\.0"' sdd-kit/MANIFEST.yaml`
- [x] 5.2 Sync all three declared version strings in the same commit so `verify-release-readiness.sh` never goes red: `sdd-kit/README.md` H1, the guide's `Canonical install guide (vX.Y.Z)` blockquote, and the guide's `**Guide version:**` line.
  - **Pattern:** `sdd-kit/README.md`
  - **Gate:** `bash scripts/verify-release-readiness.sh`
- [x] 5.3 Add the `### 1.12.0 (YYYY-MM-DD)` entry to `doc/byebyevibe-guide.md` `## Guide changelog`, describing the release flow, the single-axis decision, the tarball, the yank policy, and the fact that no template bytes changed so a C2 upgrade delivers no diff.
  - **Pattern:** `doc/byebyevibe-guide.md`
  - **Gate:** `grep -q '### 1.12.0' doc/byebyevibe-guide.md && bash scripts/release-notes.sh 1.12.0 | grep -q .`
- [x] 5.4 Confirm no checksum regeneration is needed — nothing under `sdd-kit/templates/` changed.
  - **Gate:** `bash sdd-kit/gen-manifest-checksums.sh --check`

## 6. Verification

- [x] 6.1 Run the repo-state gate standalone — must exit 0.
  - **Gate:** `bash scripts/verify-release-readiness.sh`
- [x] 6.2 Run the full local verify — must exit 0.
  - **Gate:** `bash sdd-kit/verify.sh`
- [x] 6.3 Dry-run the artifact build against `HEAD` (not a tag): two consecutive builds must be byte-identical, and the archive must contain all three footprint components from §1.6's sparse-checkout list. Written bash-only (no process substitution — gates may run under `sh`), with temp cleanup.
  - **Gate:** `D=$(mktemp -d) && git archive --format=tar --prefix=t/ HEAD sdd-kit scripts/bootstrap-sdd.sh scripts/preflight-sdd.sh | gzip -n > "$D/a1.tgz" && git archive --format=tar --prefix=t/ HEAD sdd-kit scripts/bootstrap-sdd.sh scripts/preflight-sdd.sh | gzip -n > "$D/a2.tgz" && cmp -s "$D/a1.tgz" "$D/a2.tgz" && tar tzf "$D/a1.tgz" > "$D/list" && grep -q 't/scripts/bootstrap-sdd.sh' "$D/list" && grep -q 't/scripts/preflight-sdd.sh' "$D/list" && grep -q 't/sdd-kit/MANIFEST.yaml' "$D/list" && rm -rf "$D"`
- [x] 6.4 Validate the change against OpenSpec.
  - **Gate:** `npx --yes @fission-ai/openspec@1.3.1 validate --all --strict`

## 7. Manual follow-up (outside apply)

- [ ] 7.1 [MANUAL ACTION REQUIRED] [BLOCKING — before any release is cut] Verify `add-release-readiness-gate` task 6.1 is closed (branch protection: `Release readiness (blocking)` required on `master`). That task list is the authoritative tracker — this entry is a verification pointer, not a second tracker; do not mark it done here while it is open there. Until it is done, `master` can carry a commit the gate would reject (research.md D-REL-2).
  - **Gate:** — (GitHub repository setting; verify by opening a PR with a deliberate version-sync mismatch and confirming merge is blocked)
- [ ] 7.2 [MANUAL ACTION REQUIRED] [RECOMMENDED — before any release is cut] Add a GitHub tag ruleset restricting creation of `v*` tags (Settings → Rules → Rulesets → target: tags `v*`) to repository admins. The workflow's server-side guards bound what a stray tag can publish, but only a ruleset controls who can create one — the tag-side counterpart of task 7.1's branch protection.
  - **Gate:** — (GitHub repository setting; verify by attempting a `v*` tag push from a non-admin context)
- [ ] 7.3 [MANUAL ACTION REQUIRED] After merge and after 7.1/7.2: cut the first release with `bash scripts/cut-release.sh 1.12.0 --dry-run`, review the precondition report, then rerun without `--dry-run`. Confirm the Release appears with the extracted 1.12.0 notes plus the git-version footer and both assets, and that the published `.sha256` matches a local regeneration from the tag (`sha256sum -c`).
  - **Gate:** — (post-merge operator action; verify on the Releases page and with `sha256sum -c`)

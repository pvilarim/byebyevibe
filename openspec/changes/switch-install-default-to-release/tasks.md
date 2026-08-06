## 1. Release assets

- [ ] 1.1 In `.github/workflows/release.yml`, after the existing `git archive … | gzip -n` build step, create the stable-named copies from the **same file** (`cp`, not a second `git archive` — a rebuild is a second chance to differ) as `byebyevibe-kit.tar.gz`, and generate its sidecar with `sha256sum byebyevibe-kit.tar.gz > byebyevibe-kit.tar.gz.sha256` so the checksum file names the stable filename and `sha256sum -c` succeeds against a file downloaded under it (design D1). Do NOT use a `-latest` suffix — the same asset is reachable pinned per tag, where that would be false.
  - **Pattern:** `.github/workflows/release.yml`
  - **Gate:** `grep -qF 'byebyevibe-kit.tar.gz' .github/workflows/release.yml && grep -qF 'byebyevibe-kit.tar.gz.sha256' .github/workflows/release.yml && ! grep -q 'kit-latest' .github/workflows/release.yml && python3 -c "import yaml,sys; yaml.safe_load(open('.github/workflows/release.yml'))"`
- [ ] 1.2 Attach all four assets in the single `gh release create … --draft` invocation, so the draft is complete before it is flipped published (design D10 — publication stays atomic; a second upload step would reopen the partial-release window the draft-first design closed).
  - **Gate:** `awk '/gh release create/,/gh release edit/' .github/workflows/release.yml > /tmp/g12 && grep -c 'byebyevibe-kit' /tmp/g12 | xargs -I{} test {} -ge 5 && grep -q -- '--draft=false' .github/workflows/release.yml && rm -f /tmp/g12`
- [ ] 1.3 Assert the stable and version-stamped archives are byte-identical in the workflow itself (`cmp -s`), failing the run if they diverge. Cheap, and it is the one place the spec's "MUST be byte-identical" claim can be mechanically held.
  - **Gate:** `grep -q 'cmp -s' .github/workflows/release.yml && python3 -c "import yaml,sys; d=yaml.safe_load(open('.github/workflows/release.yml')); assert not any('continue-on-error' in s for s in d['jobs']['release']['steps'])"`

## 2. Guide §1.6 — acquisition recipes

- [ ] 2.1 Add `#### Release download (default, C1 greenfield)` immediately **before** `#### Lightweight fetch recipe`. Body: the two `curl -fsSL` calls against `https://github.com/pvilarim/byebyevibe/releases/latest/download/byebyevibe-kit.tar.gz` and its `.sha256`, then `sha256sum -c`, then `tar xzf`, then the copy into place, then cleanup. `-f` is mandatory and its reason must be stated inline: without it curl writes the 404 body into the file and exits 0, so a missing asset resurfaces later as a bogus gzip error (design D3, measured — a request for an absent asset redirects identically and only 404s at the object host). Verification MUST appear before extraction (design D4). State that on Windows this belongs in Git Bash, because `sha256sum` and `tar` ship with Git for Windows while PowerShell has no `sha256sum -c`.
  - **Pattern:** `doc/byebyevibe-guide.md`
  - **Gate:** `grep -q '#### Release download' doc/byebyevibe-guide.md && D=$(grep -n '#### Release download' doc/byebyevibe-guide.md | head -1 | cut -d: -f1) && L=$(grep -n '#### Lightweight fetch recipe' doc/byebyevibe-guide.md | head -1 | cut -d: -f1) && test "$D" -lt "$L" && awk -v a="$D" -v b="$L" 'NR>=a && NR<b' doc/byebyevibe-guide.md > /tmp/g21 && grep -q 'curl -fsSL' /tmp/g21 && grep -qF 'releases/latest/download/byebyevibe-kit.tar.gz' /tmp/g21 && grep -q 'sha256sum -c' /tmp/g21 && V=$(grep -n 'sha256sum -c' /tmp/g21 | head -1 | cut -d: -f1) && X=$(grep -n 'tar xzf' /tmp/g21 | head -1 | cut -d: -f1) && test "$V" -lt "$X" && rm -f /tmp/g21`
- [ ] 2.2 Re-scope the `#### Lightweight fetch recipe` block: its heading and opening note must state it is for installing from **unreleased `master`** (development against the hub, or a state predating the first Release), not the default. Keep the recipe, the fallback paragraph, and the existing C1-only/not-C2/not-C3 scoping intact — the `sdd-install-kit` delta requires it to survive, because no Release covers unreleased `master`.
  - **Pattern:** `doc/byebyevibe-guide.md`
  - **Gate:** `awk '/#### Lightweight fetch recipe/,/^## 2\./' doc/byebyevibe-guide.md > /tmp/g22 && grep -qi 'unreleased' /tmp/g22 && grep -q 'sparse-checkout set --no-cone' /tmp/g22 && grep -qi 'allowFilter' /tmp/g22 && rm -f /tmp/g22`
- [ ] 2.3 Update the release-tarball pointer added by `add-github-release-flow` (the "Released versions — download the kit tarball instead" paragraph): it now duplicates §2.1's recipe. Reduce it to a cross-reference, or fold its content into §2.1 — do not leave two descriptions of the same download.
  - **Pattern:** `doc/byebyevibe-guide.md`
  - **Gate:** `test "$(grep -c 'releases/latest/download' doc/byebyevibe-guide.md)" -ge 1 && test "$(awk '/### 1.6 /,/^## 2\./' doc/byebyevibe-guide.md | grep -c 'sha256sum -c')" -le 1`

## 3. Guide §2.0 — agent prompt

- [ ] 3.1 Reorder the three bullets of the prompt's "Acquiring the SDD system files" block: Release download first and labelled default; lightweight fetch second, conditioned on unreleased `master`; full hub clone third, conditioned on the persistent multi-project workflow. Each non-default option keeps an explicit selecting condition. Add the instruction to verify the `.sha256` before extracting, and state that no version number needs to be known in advance — both are normative in the `sdd-install-kit` delta.
  - **Pattern:** `doc/byebyevibe-guide.md`
  - **Gate:** `awk '/Acquiring the SDD system files/,/Narrative \(dual/' doc/byebyevibe-guide.md > /tmp/g31 && R=$(grep -n -i 'release' /tmp/g31 | head -1 | cut -d: -f1) && S=$(grep -n -i 'sparse-checkout\|lightweight fetch' /tmp/g31 | head -1 | cut -d: -f1) && C=$(grep -n -i 'full hub clone\|clone the full hub' /tmp/g31 | head -1 | cut -d: -f1) && test "$R" -lt "$S" && test "$S" -lt "$C" && grep -qi 'sha256' /tmp/g31 && rm -f /tmp/g31`
- [ ] 3.2 Confirm the §12.2a/§12.2b consumer `AGENTS.md` command templates are untouched, compared against the merge base with `origin/master` (consumers install the kit; acquisition is an operator concern, and those templates carry neither recipe today).
  - **Gate:** `git fetch -q origin master && git diff --quiet "$(git merge-base HEAD origin/master)" HEAD -- AGENTS.md || true; awk '/### 12.2a/,/### 12.3/' doc/byebyevibe-guide.md | grep -qv 'releases/latest/download'`

## 4. Guide §2.18 — release-flow operation

- [ ] 4.1 Update §2.18's asset section to the four-asset inventory: the version-stamped pair (citable, archival, what the documented regeneration command reproduces by name) and the stable-named pair (acquisition, byte-identical). State plainly that they are the same bytes and why both exist, so nobody has to guess which to trust.
  - **Pattern:** `doc/byebyevibe-guide.md`
  - **Gate:** `awk '/### 2.18/,/### 2.9 Upgrading/' doc/byebyevibe-guide.md > /tmp/g41 && grep -qF 'byebyevibe-kit.tar.gz' /tmp/g41 && grep -qiE 'same bytes|byte-identical|identical bytes' /tmp/g41 && rm -f /tmp/g41`
- [ ] 4.2 Add the stale-release consequence (design D6) to §2.18, next to the cut procedure where an operator about to merge a kit change will read it: now that installs default to the latest Release, merging a `sdd-kit/` change without cutting one silently hands every new installer an **older** kit than `master`. State that this is deliberately not enforced by a gate, and why — such a gate would fire on every in-progress branch.
  - **Pattern:** `doc/byebyevibe-guide.md`
  - **Gate:** `awk '/### 2.18/,/### 2.9 Upgrading/' doc/byebyevibe-guide.md | grep -qiE 'older kit than|behind the last release|stale release' `

## 5. Version and changelog

- [ ] 5.1 Bump `sdd-kit/MANIFEST.yaml` `version:` and `guide_version:` 1.12.0 → 1.13.0 together (minor: new documented acquisition default). Use a line-anchored edit — `guide_version: "1.12.0"` contains `version: "1.12.0"` as a substring, which silently breaks a naive replace.
  - **Pattern:** `sdd-kit/MANIFEST.yaml`
  - **Gate:** `grep -qE '^version: "1\.13\.0"' sdd-kit/MANIFEST.yaml && grep -qE '^guide_version: "1\.13\.0"' sdd-kit/MANIFEST.yaml`
- [ ] 5.2 Sync the three declared version strings in the same commit: `sdd-kit/README.md` H1, the guide's `Canonical install guide (vX.Y.Z)` blockquote, and the guide's `**Guide version:**` line. `sdd-kit/README.md` is stored with **CRLF** line endings — edit it without normalising them, or the diff balloons to the whole file.
  - **Pattern:** `sdd-kit/README.md`
  - **Gate:** `bash scripts/verify-release-readiness.sh && git diff --numstat sdd-kit/README.md | awk '{exit ($1>2 || $2>2)}'`
- [ ] 5.3 Add the `### 1.13.0 (YYYY-MM-DD)` changelog entry: the inverted default, the stable-named asset pair and why a version-less name was required at all, the mandatory checksum verification, the retained sparse-checkout recipe and its new scope, and the stale-release consequence. Note that no template bytes changed, so a C2 upgrade delivers no diff and the tarball's contents are identical to 1.12.0's — only the asset inventory grows.
  - **Pattern:** `doc/byebyevibe-guide.md`
  - **Gate:** `grep -q '### 1.13.0' doc/byebyevibe-guide.md && bash scripts/release-notes.sh 1.13.0 | grep -q . && bash scripts/release-notes.sh 1.13.0 | grep -qiE 'asset|tarball'`
- [ ] 5.4 Confirm no checksum regeneration is needed — nothing under `sdd-kit/templates/` changed.
  - **Gate:** `bash sdd-kit/gen-manifest-checksums.sh --check`

## 6. Verification

- [ ] 6.1 Repo-state gate standalone.
  - **Gate:** `bash scripts/verify-release-readiness.sh`
- [ ] 6.2 Full local verify.
  - **Gate:** `bash sdd-kit/verify.sh`
- [ ] 6.3 Simulate the workflow's asset step locally against `HEAD`: build the archive, copy it to the stable name, generate both sidecars, and assert `cmp -s` passes and each `sha256sum -c` verifies against its own filename. Bash-only, no process substitution (gates may run under `sh`), with temp cleanup.
  - **Gate:** `D=$(mktemp -d) && git archive --format=tar --prefix=byebyevibe-kit-t/ HEAD sdd-kit scripts/bootstrap-sdd.sh scripts/preflight-sdd.sh | gzip -n > "$D/byebyevibe-kit-t.tar.gz" && cp "$D/byebyevibe-kit-t.tar.gz" "$D/byebyevibe-kit.tar.gz" && ( cd "$D" && sha256sum byebyevibe-kit-t.tar.gz > byebyevibe-kit-t.tar.gz.sha256 && sha256sum byebyevibe-kit.tar.gz > byebyevibe-kit.tar.gz.sha256 && cmp -s byebyevibe-kit-t.tar.gz byebyevibe-kit.tar.gz && sha256sum -c byebyevibe-kit-t.tar.gz.sha256 >/dev/null && sha256sum -c byebyevibe-kit.tar.gz.sha256 >/dev/null ) && rm -rf "$D"`
- [ ] 6.4 Validate the change against OpenSpec.
  - **Gate:** `npx --yes @fission-ai/openspec@1.3.1 validate --all --strict`

## 7. Manual follow-up (outside apply)

- [ ] 7.1 [MANUAL ACTION REQUIRED] After merge, cut `1.13.0` (`bash scripts/cut-release.sh 1.13.0 --dry-run`, review, then without the flag). This is the release whose assets make §1.6's new default recipe actually work — until it exists, `releases/latest/download/byebyevibe-kit.tar.gz` 404s, because `v1.12.0` carries only the version-stamped pair.
  - **Gate:** — (post-merge operator action)
- [ ] 7.2 [MANUAL ACTION REQUIRED] After the cut, walk the new §1.6 recipe end-to-end in a scratch directory on a machine that is not this repo — download, verify, extract — and confirm `bash scripts/bootstrap-sdd.sh --profile DOCS_SPECS --dry-run` runs against the extracted footprint. Documenting a default nobody has executed is how the `-f` class of bug ships.
  - **Gate:** — (operator action; verify by running the guide's own commands verbatim)

## 1. Interpreter resolution

- [ ] 1.1 Add a `resolve_python` helper to `sdd-kit/templates/scripts/preflight-sdd.sh` that probes `python3`, `python`, `py -3` in that order and accepts the first whose `sys.version_info` meets the kit floor (3.8, per design D2). Probe the **version**, never `command -v` alone — `python` may be Python 2, and on Windows a `python3` on PATH may be an execution alias that is not an interpreter (design D1). Export the winner as `SDD_PYTHON`. Keep it under 15 lines; the loop below is the whole shape.
  - **Pattern:** `sdd-kit/templates/scripts/preflight-sdd.sh`
  - **Gate:** `bash -c 'f=sdd-kit/templates/scripts/preflight-sdd.sh; grep -q "resolve_python" $f && grep -q "SDD_PYTHON" $f && grep -q "py -3" $f && grep -q "version_info" $f && ! grep -qE "command -v python3.*&&.*OK" $f'`
- [ ] 1.2 Replace the host Python check so it reports the **resolved command and its version** instead of asserting the name `python3`. When nothing resolves, the FAIL message must name every candidate tried and must not print a fabricated version — the current `python3 0.0.0 < minimum 3.10` sends an operator who already has Python to reinstall it (spec: *No interpreter resolvable*).
  - **Pattern:** `sdd-kit/templates/scripts/preflight-sdd.sh`
  - **Gate:** `bash -c '! grep -q "0\.0\.0" sdd-kit/templates/scripts/preflight-sdd.sh'`
- [ ] 1.3 Split the two floors. The kit floor (3.8) gates install; Graphify's 3.10 becomes a WARN attributed to Graphify, never a FAIL for Python itself. Guide §2.9.4 already permits deferring Graphify, so its floor must not block an operator who is not installing it.
  - **Pattern:** `sdd-kit/templates/scripts/preflight-sdd.sh`
  - **Gate:** `bash -c 'f=sdd-kit/templates/scripts/preflight-sdd.sh; grep -q "3\.8" $f && grep -qi "graphify" $f && ! grep -qE "FAIL.*python.*3\.10" $f'`
- [ ] 1.4 Add the interpreter check to **repo** mode, scoped to that runtime only — not the full host scan, which `sdd-install-kit` explicitly forbids repeating there. This is what makes a direct `install.sh` run safe, since it calls preflight in repo mode only.
  - **Pattern:** `sdd-kit/templates/scripts/preflight-sdd.sh`
  - **Gate:** `bash -c 'cd "$(mktemp -d)" && mkdir sdd-kit && bash '"$PWD"'/sdd-kit/templates/scripts/preflight-sdd.sh --repo 2>&1 | grep -qiE "python|interpreter"'`

## 2. Boundary — feeds into `read` loops

- [ ] 2.1 Strip carriage returns on the four Python feeds that supply `read` loops with tab-separated metadata: `sdd-kit/install.sh:350`, `sdd-kit/upgrade.sh:132`, `sdd-kit/upgrade.sh:261`, `sdd-kit/templates/scripts/sdd-upgrade-diff.sh:29`. The filter belongs on the feed itself (`… << 'PY' | tr -d '\r'`), where the corruption enters. Safe here and only here: the payload is hashes and paths, which cannot legitimately contain `\r` (design D4).
  - **Pattern:** `sdd-kit/install.sh`
  - **Gate:** `bash -c 'for f in sdd-kit/install.sh sdd-kit/upgrade.sh sdd-kit/templates/scripts/sdd-upgrade-diff.sh; do grep -q "tr -d" $f || exit 1; done; test "$(grep -c "tr -d" sdd-kit/upgrade.sh)" -ge 2'`
- [ ] 2.2 Verify the fix against the defect it was found by: build the profile-filtered list and assert no field ends with `\r`. This is the check that was impossible to eyeball — a corrupted hash and a correct one print identically.
  - **Gate:** `bash -c 'bash -c "sed -n \"/^done < <(python3/,/^)/p\" sdd-kit/install.sh" >/dev/null; python3 -c "print(1)" >/dev/null 2>&1 || exit 0; bash sdd-kit/install.sh --profile DOCS_SPECS --dry-run 2>&1 | od -c | grep -q "\\\\r" && exit 1 || exit 0'`

## 3. Boundary — file rewrites

- [ ] 3.1 Stop translating newlines in the three Python blocks that rewrite files: `sdd-kit/install.sh:111` (language policy), `sdd-kit/templates/scripts/preflight-sdd.sh:364` (infra.md stamp), `sdd-kit/templates/scripts/verify-infra.sh:246`. Use `newline=""` on **both** `open()` calls — read as well as write. Reading without it already normalises CRLF to LF, so writing alone does not fix it; that asymmetry is what turned a 4-line stamp into a 153-line diff (design D4).
  - **Pattern:** `sdd-kit/templates/scripts/verify-infra.sh`
  - **Gate:** `bash -c 'for f in sdd-kit/install.sh sdd-kit/templates/scripts/preflight-sdd.sh sdd-kit/templates/scripts/verify-infra.sh; do test "$(grep -c "newline=\"\"" $f)" -ge 2 || exit 1; done'`
- [ ] 3.2 Do **not** apply `tr -d` to any of these three sites. Deleting carriage returns from file content destroys the original line endings — the opposite of what §3.1 is for. Assert the separation mechanically so a later edit cannot blur it.
  - **Gate:** `bash -c 'awk "/^inject_language_policy|^_stamp|^update_infra/,/^}/" sdd-kit/install.sh sdd-kit/templates/scripts/verify-infra.sh | grep -q "tr -d" && exit 1 || exit 0'`

## 4. install.sh guards

- [ ] 4.1 Change the traversal guard at `sdd-kit/install.sh:234` to `realpath -m --no-symlinks`, so a destination whose parent does not exist yet can still be canonicalised. Measured: `-m` still resolves `..`, so `../escape` and `../../etc/passwd` remain outside `$REPO_ROOT` and are still caught by the existing prefix check. Do **not** hoist `mkdir -p` above the guard — that would write to the filesystem to satisfy a check whose purpose is to run before writes (design D6).
  - **Pattern:** `sdd-kit/install.sh`
  - **Gate:** `grep -q 'realpath -m --no-symlinks' sdd-kit/install.sh && grep -q 'path traversal blocked' sdd-kit/install.sh`
- [ ] 4.2 Prove the guard still blocks after the change, with the parent absent — the case §4.1 newly allows through canonicalisation must still be rejected on escape.
  - **Gate:** `bash -c 'R=$(mktemp -d); mkdir -p "$R/repo"; p=$(realpath -m --no-symlinks "$R/repo/../../etc/passwd"); case "$p" in "$R/repo"/*) rm -rf "$R"; exit 1;; *) rm -rf "$R"; exit 0;; esac'`
- [ ] 4.3 Count the templates the loop applied and exit non-zero when the count is zero, before the completion output. Process substitution does not propagate exit status, so `set -euo pipefail` cannot see an empty feed — a counter is the direct evidence, and avoids adding a temp file to the hottest path (design D5).
  - **Pattern:** `sdd-kit/install.sh`
  - **Gate:** `bash -c 'grep -qiE "no templates|APPLIED_COUNT|applied 0" sdd-kit/install.sh && awk "/Done\. Next steps/{found=1} END{exit !found}" sdd-kit/install.sh'`
- [ ] 4.4 Confirm the completion banner is unreachable on a zero-file run: simulate an empty feed and assert non-zero exit with no `Done.` in the output.
  - **Gate:** `bash -c 'T=$(mktemp -d); cd "$T"; git init -q .; cp -R '"$PWD"'/sdd-kit .; mkdir -p scripts; cp '"$PWD"'/scripts/preflight-sdd.sh scripts/; sed -i "s|^files:|files_disabled:|" sdd-kit/MANIFEST.yaml; ! bash sdd-kit/install.sh --profile DOCS_SPECS 2>&1 | grep -q "Done\."; rc=$?; cd /; rm -rf "$T"; exit $rc'`

## 5. Checksum reader and non-vacuous gates

- [ ] 5.1 Fix path construction in `sdd-kit/gen-manifest-checksums.sh:72` and the equivalent in `verify-release-readiness.sh`. `os.path.join` uses the host separator, so on Windows it emits `…/sdd-kit\templates/…`; GNU `sha256sum` then escapes the whole output line with a leading `\`, and `stdout.split()[0]` returns `\<hash>`. All 45 entries mismatch while the bytes are correct. Build the path with `/` explicitly rather than the native separator.
  - **Pattern:** `sdd-kit/gen-manifest-checksums.sh`
  - **Gate:** `bash -c 'grep -q "os.path.join" sdd-kit/gen-manifest-checksums.sh && exit 1; exit 0'`
- [ ] 5.2 Reject a digest that is not a bare lowercase hex string of the expected length, instead of comparing whatever the first token happens to be. The escape prefix is invisible in a diff of two hashes and cost a full debugging session to find.
  - **Pattern:** `sdd-kit/gen-manifest-checksums.sh`
  - **Gate:** `bash -c 'grep -qE "fullmatch|\[0-9a-f\]\{64\}" sdd-kit/gen-manifest-checksums.sh'`
- [ ] 5.3 Make a zero-comparison run fail in both the checksum checker and `verify-release-readiness.sh`. A gate that examined nothing must not record a green — this one did, and a release was cut on it.
  - **Pattern:** `sdd-kit/templates/scripts/verify-release-readiness.sh`
  - **Gate:** `bash -c 'grep -qiE "compared 0|no entries|nothing to verify|checked 0" sdd-kit/gen-manifest-checksums.sh sdd-kit/templates/scripts/verify-release-readiness.sh'`
- [ ] 5.4 Prove the checker now passes on this host — it currently fails 45/45 with correct bytes, so a green here is direct evidence the parsing fix works.
  - **Gate:** `bash sdd-kit/gen-manifest-checksums.sh --check`
- [ ] 5.5 Prove the vacuous path is closed: force the helper to be unavailable and assert the readiness gate reports failure rather than success.
  - **Gate:** `bash -c 'PATH=/usr/bin:/bin bash -c "command -v python3 >/dev/null && exit 0"; ! env SDD_PYTHON=/nonexistent bash scripts/verify-release-readiness.sh >/dev/null 2>&1'`

## 6. Mirror, checksums, parity

- [ ] 6.1 Mirror every edited `sdd-kit/templates/scripts/*.sh` to its live counterpart in `scripts/`. Thirteen scripts are dual-maintained and parity-gated; a missed mirror fails `verify-release-readiness.sh` late, after the diff already looks finished.
  - **Pattern:** `scripts/preflight-sdd.sh`
  - **Gate:** `bash -c 'for b in preflight-sdd.sh verify-infra.sh sdd-upgrade-diff.sh; do cmp -s "scripts/$b" "sdd-kit/templates/scripts/$b" || exit 1; done'`
- [ ] 6.2 Regenerate the MANIFEST checksums — every edited template invalidates its `sha256:` entry, and a stale one reproduces the exact integrity failure this change exists to fix.
  - **Pattern:** `sdd-kit/MANIFEST.yaml`
  - **Gate:** `bash sdd-kit/gen-manifest-checksums.sh --check`
- [ ] 6.3 Run the kit's own verification in hub context.
  - **Gate:** `bash sdd-kit/verify.sh`

## 7. CI greenfield smoke test

- [ ] 7.1 Add a greenfield install job to `.github/workflows/sdd-gates.yml`: create an empty repo in the runner, place the documented footprint, run the installer. The target must not be the hub checkout and must not be pre-seeded with `.github/` — that seeding is exactly what hid the defect.
  - **Pattern:** `.github/workflows/sdd-gates.yml`
  - **Gate:** `bash -c 'grep -qiE "greenfield" .github/workflows/sdd-gates.yml && python3 -c "import yaml; yaml.safe_load(open(\".github/workflows/sdd-gates.yml\"))"'`
- [ ] 7.2 Assert file count **and** one file under a newly created parent — `.github/workflows/sdd-gates.yml` in the target is the specific path that aborted the run, so it is the assertion with evidence behind it. An exit code alone did not catch this defect and must not be the only check.
  - **Pattern:** `.github/workflows/sdd-gates.yml`
  - **Gate:** `bash -c 'awk "/greenfield/,0" .github/workflows/sdd-gates.yml | grep -qE "\.github/workflows/sdd-gates\.yml" && awk "/greenfield/,0" .github/workflows/sdd-gates.yml | grep -qiE "wc -l|count"'`
- [ ] 7.3 Do not pin the new job to a third-party Action. `sdd-ci-gates` authorises exactly one external Action (OSV) and no others without its own change.
  - **Gate:** `bash -c 'test "$(grep -cE "^\s+uses:" .github/workflows/sdd-gates.yml)" -eq "$(grep -cE "^\s+uses: (actions/|google/osv-scanner-action)" .github/workflows/sdd-gates.yml)"'`

## 8. Guide, version, changelog

- [ ] 8.1 Correct guide §1.1. The row claims *"Native Windows works but WSL2 avoids 80% of issues"* — measured false: no released version could complete a C1 greenfield install on native Windows. State Python's role for the **installer** (kit floor 3.8), separately from Graphify's 3.10, since §2.9.4 permits deferring Graphify.
  - **Pattern:** `doc/byebyevibe-guide.md`
  - **Gate:** `bash -c 'awk "/^### 1\.1 /,/^### 1\.2 /" doc/byebyevibe-guide.md > /tmp/g71; grep -q "3.8" /tmp/g71 && grep -qi "installer\|install.sh" /tmp/g71 && ! grep -q "80% of issues" /tmp/g71; rc=$?; rm -f /tmp/g71; exit $rc'`
- [ ] 8.2 Bump `sdd-kit/MANIFEST.yaml` `version:` and `guide_version:` 1.13.0 → 1.14.0 together. Minor, not patch: three capabilities gain normative requirements and `install.sh` now aborts where it printed `Done`. Use a line-anchored edit — `guide_version: "1.13.0"` contains `version: "1.13.0"` as a substring, which a naive replace corrupts silently.
  - **Pattern:** `sdd-kit/MANIFEST.yaml`
  - **Gate:** `grep -qE '^version: "1\.14\.0"' sdd-kit/MANIFEST.yaml && grep -qE '^guide_version: "1\.14\.0"' sdd-kit/MANIFEST.yaml`
- [ ] 8.3 Sync the three declared version strings: `sdd-kit/README.md` H1, the guide's `Canonical install guide (vX.Y.Z)` blockquote, and the guide's `**Guide version:**` line. `sdd-kit/README.md` is stored with **CRLF** — edit it without normalising, or the diff balloons to the whole file (the same class of bug this change fixes).
  - **Pattern:** `sdd-kit/README.md`
  - **Gate:** `bash scripts/verify-release-readiness.sh && git diff --numstat sdd-kit/README.md | awk '{exit ($1>2 || $2>2)}'`
- [ ] 8.4 Add the `### 1.14.0 (YYYY-MM-DD)` changelog entry. State plainly, without softening: no released version could complete a C1 greenfield install on native Windows, and the `realpath` defect affected **every** platform in a repository without `.github/`. Name the behaviour change — installs that silently wrote nothing now abort. Note that v1.13.0 is not withdrawn: these defects predate it, and it raised exposure rather than causing it.
  - **Pattern:** `doc/byebyevibe-guide.md`
  - **Gate:** `bash -c 'grep -q "### 1.14.0" doc/byebyevibe-guide.md && bash scripts/release-notes.sh 1.14.0 | grep -qiE "windows" && bash scripts/release-notes.sh 1.14.0 | grep -qiE "greenfield|realpath|every platform"'`

## 9. Verification

- [ ] 9.1 End-to-end greenfield install locally, the proof this change exists to deliver. Baseline measured before the fix: exit 1 at `.github/workflows/sdd-gates.yml`. Expected after: exit 0 with a populated target.
  - **Gate:** `bash -c 'T=$(mktemp -d); cd "$T"; git init -q .; cp -R '"$PWD"'/sdd-kit .; mkdir -p scripts; cp '"$PWD"'/scripts/bootstrap-sdd.sh '"$PWD"'/scripts/preflight-sdd.sh scripts/; bash sdd-kit/install.sh --profile DOCS_SPECS >/dev/null 2>&1 && test -f .github/workflows/sdd-gates.yml && test "$(find . -type f -not -path "./.git/*" -not -path "./sdd-kit/*" | wc -l)" -ge 20; rc=$?; cd /; rm -rf "$T"; exit $rc'`
- [ ] 9.2 Confirm the resolver works when `python3` is absent — the native-Windows case, simulated by removing it from PATH.
  - **Gate:** `bash -c 'PATH=$(echo "$PATH" | tr ":" "\n" | grep -v WindowsApps | grep -v "$HOME/bin" | paste -sd:) bash scripts/preflight-sdd.sh --host 2>&1 | grep -qiE "python.*(3\.[0-9]+)" '`
- [ ] 9.3 Repo-state gate and full local verify.
  - **Gate:** `bash scripts/verify-release-readiness.sh && bash sdd-kit/verify.sh`
- [ ] 9.4 Validate the change against OpenSpec.
  - **Gate:** `npx --yes @fission-ai/openspec@1.3.1 validate --all --strict`
- [ ] 9.5 Task pattern verifier.
  - **Gate:** `bash scripts/verify-task-patterns.sh`

## 10. Manual follow-up (outside apply)

- [ ] 10.1 [MANUAL ACTION REQUIRED] After merge, cut `1.14.0` (`bash scripts/cut-release.sh 1.14.0 --dry-run`, review, then without the flag). Until it is cut, `releases/latest/download/` keeps serving the 1.13.0 kit — which is the broken one, and which the §1.6 default now points every new installer at.
  - **Gate:** — (post-merge operator action)
- [ ] 10.2 [MANUAL ACTION REQUIRED] Walk the §1.6 recipe end-to-end against the new release on native Windows in Git Bash, with no `python3` shim on PATH. That configuration is the one this change exists for, and CI cannot reproduce it.
  - **Gate:** — (operator action; the absence of the shim is the point of the test)

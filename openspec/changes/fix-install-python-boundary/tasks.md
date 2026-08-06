## 1. Interpreter resolution (preflight)

- [ ] 1.1 Add a `resolve_python` helper to `sdd-kit/templates/scripts/preflight-sdd.sh` that probes `python3`, `python`, `py -3` in that order and accepts the first whose `sys.version_info` meets the kit floor (3.8, design D2). Probe by **executing** each candidate to read the version — never `command -v`, which cannot probe the two-word `py -3` and succeeds for the Windows Store alias stub. Store the winner in `SDD_PYTHON` as a candidate **name**, never a resolved filesystem path (Windows paths contain spaces and the expansion is deliberately unquoted, design D1). Keep it under 15 lines.
  - **Pattern:** `sdd-kit/templates/scripts/preflight-sdd.sh`
  - **Gate:** `bash -c 'f=sdd-kit/templates/scripts/preflight-sdd.sh; grep -q "resolve_python" $f && grep -q "SDD_PYTHON" $f && grep -q "py -3" $f && grep -q "version_info" $f'`
- [ ] 1.2 Replace the host Python check so it reports the **resolved command and its version** instead of asserting the name `python3`. When nothing resolves, the FAIL message must name every candidate tried and must not print a fabricated version — the current `python3 0.0.0 < minimum 3.10` sends an operator who already has Python to reinstall it.
  - **Pattern:** `sdd-kit/templates/scripts/preflight-sdd.sh`
  - **Gate:** `bash -c '! grep -q "0\.0\.0" sdd-kit/templates/scripts/preflight-sdd.sh'`
- [ ] 1.3 Split the two floors. The kit floor (3.8) gates install; Graphify's 3.10 becomes a WARN attributed to Graphify, never a FAIL for Python itself. Guide §2.9.4 already permits deferring Graphify. The floor may be written as `3.8` or as the tuple `(3, 8)` — the gate accepts both.
  - **Pattern:** `sdd-kit/templates/scripts/preflight-sdd.sh`
  - **Gate:** `bash -c 'f=sdd-kit/templates/scripts/preflight-sdd.sh; grep -qE "3\.8|\(3, ?8\)" $f && grep -qi "graphify" $f && ! grep -qE "FAIL.*[Pp]ython.*3\.10" $f'`
- [ ] 1.4 Add the interpreter check to **repo** mode, scoped to that runtime only (the spec forbids pulling the rest of the host scan in), and emit the resolution as **exactly one stdout line** `SDD_PYTHON=<candidate>` — human output already goes to stderr, so stdout is the machine channel the parent captures (design D3).
  - **Pattern:** `sdd-kit/templates/scripts/preflight-sdd.sh`
  - **Gate:** `bash -c 'out=$(bash sdd-kit/templates/scripts/preflight-sdd.sh --repo 2>/dev/null); test "$(echo "$out" | grep -c .)" -eq 1 && echo "$out" | grep -qE "^SDD_PYTHON=[A-Za-z0-9 .-]+$"'`
- [ ] 1.5 Convert preflight's **own** Python call sites (the version probe at ~191, the MCP parse at ~285, the infra.md stamp at ~364, `emit_json` at ~428) to unquoted `$SDD_PYTHON`. A script that certifies `python` works and then executes `python3` under `set -euo pipefail` crashes after telling the operator everything is fine — on a `python`-only host, `--json` dies at exit 127 today.
  - **Pattern:** `sdd-kit/templates/scripts/preflight-sdd.sh`
  - **Gate:** `bash -c 'test "$(grep -c "\$SDD_PYTHON" sdd-kit/templates/scripts/preflight-sdd.sh)" -ge 4'`

## 2. Interpreter consumption (install and standalone scripts)

- [ ] 2.1 In `sdd-kit/install.sh`, capture preflight's stdout at the existing gate (line 222): `SDD_PYTHON="$(bash "$PREFLIGHT_SCRIPT" --repo …)"` keeping the `|| abort` shape, parse the `SDD_PYTHON=` line, **export** the value, and convert both call sites (line 111 language policy, line 350 template feed) to unquoted `$SDD_PYTHON`. When `--skip-preflight` is passed, fall back to the same inline cascade as 2.2. This is the transport the adversarial review found missing: an `export` inside the child dies with the child, so without the capture the install certifies `python` and then executes `python3`.
  - **Pattern:** `sdd-kit/install.sh`
  - **Gate:** `bash -c 'grep -q "SDD_PYTHON" sdd-kit/install.sh && ! grep -qE "python3 - \"\$(MANIFEST|project_md)" sdd-kit/install.sh'`
- [ ] 2.2 Give the standalone scripts the same resolution: `sdd-kit/upgrade.sh` (feeds at 132 and 261), `sdd-kit/gen-manifest-checksums.sh` (45), `sdd-kit/templates/scripts/verify-release-readiness.sh` (93), `sdd-kit/templates/scripts/sdd-upgrade-diff.sh` (29), `sdd-kit/templates/scripts/verify-infra.sh` (91, 246). Each honours `SDD_PYTHON` from the environment when set — **trusted as-is, no re-probing** (that is what lets a test force a broken interpreter) — and otherwise runs the same ≤6-line candidate cascade with a loud failure naming the candidates. Add the one-line comment at each unquoted expansion site naming the convention (design risk: a quoting cleanup breaks the `py -3` rung).
  - **Pattern:** `sdd-kit/upgrade.sh`
  - **Gate:** `bash -c 'for f in sdd-kit/upgrade.sh sdd-kit/gen-manifest-checksums.sh sdd-kit/templates/scripts/verify-release-readiness.sh sdd-kit/templates/scripts/sdd-upgrade-diff.sh sdd-kit/templates/scripts/verify-infra.sh; do grep -q "SDD_PYTHON" "$f" || exit 1; done'`

## 3. Boundary — feeds into `read` loops

- [ ] 3.1 Strip carriage returns on the four Python feeds that supply `read` loops with tab-separated metadata: `sdd-kit/install.sh:350`, `sdd-kit/upgrade.sh:132`, `sdd-kit/upgrade.sh:261`, `sdd-kit/templates/scripts/sdd-upgrade-diff.sh:29`. The pipe attaches after the heredoc delimiter on the opening line (`… << 'PY' | tr -d '\r'` — validated as legal bash whose heredoc feeds Python, not `tr`). Safe here and only here: the payload is hashes and paths, which cannot legitimately contain `\r` (design D4).
  - **Pattern:** `sdd-kit/install.sh`
  - **Gate:** `bash -c "for f in sdd-kit/install.sh sdd-kit/templates/scripts/sdd-upgrade-diff.sh; do grep -qF \"| tr -d\" \"\$f\" || exit 1; done; test \"\$(grep -cF '| tr -d' sdd-kit/upgrade.sh)\" -ge 2"`
- [ ] 3.2 Prove the feed parses end-to-end on this host: dry-run in a scratch clone must plan the full template list. The integrity check runs before the dry-run branch, so on Windows the pre-fix CR corruption aborts this with a bogus mismatch — the gate is host-specific evidence, vacuous on Linux and real here, which is exactly the configuration that matters.
  - **Gate:** `bash -c 'R=$(git rev-parse --show-toplevel); T=$(mktemp -d); cd "$T" && git init -q . && cp -R "$R/sdd-kit" . && mkdir -p scripts && cp "$R/scripts/preflight-sdd.sh" scripts/ && n=$(bash sdd-kit/install.sh --profile DOCS_SPECS --dry-run --skip-preflight 2>/dev/null | grep -c "PLAN \["); cd /; rm -rf "$T"; test "${n:-0}" -ge 20'`

## 4. Boundary — file rewrites

- [ ] 4.1 Stop translating newlines in the **two** Python blocks that rewrite files: `sdd-kit/install.sh:111` (language policy) and `sdd-kit/templates/scripts/verify-infra.sh:246`. Use `newline=''` on **both** `open()` calls — read as well as write; reading without it already normalises CRLF to LF, so writing alone does not fix it. Do **not** touch `preflight-sdd.sh:364`: review confirmed that block already preserves endings via `read_bytes()`/`write_bytes()` (its interpreter *name* is fixed by 1.5; its newline handling is correct and rewriting it is churn with regression risk).
  - **Pattern:** `sdd-kit/templates/scripts/verify-infra.sh`
  - **Gate:** `bash -c "for f in sdd-kit/install.sh sdd-kit/templates/scripts/verify-infra.sh; do test \"\$(grep -cE 'newline=(\"\"|'\\'''\\'')' \"\$f\")\" -ge 2 || exit 1; done"`
- [ ] 4.2 Keep `tr -d` out of the file-rewrite paths — deleting carriage returns from file content destroys the original endings, the opposite of 4.1. Assert the separation on the regions that actually rewrite: the `inject_language_policy` function in `install.sh` and the Python heredoc region in `verify-infra.sh`.
  - **Gate:** `bash -c 'awk "/inject_language_policy\(\)/,/^}/" sdd-kit/install.sh | grep -q "tr -d" && exit 1; awk "/<<.?PY/,/^PY$/" sdd-kit/templates/scripts/verify-infra.sh | grep -q "tr -d" && exit 1; exit 0'`

## 5. install.sh guards

- [ ] 5.1 Change the traversal guard at `sdd-kit/install.sh:234` to `realpath -m --no-symlinks`, so a destination whose parent does not exist yet can still be canonicalised — measured: `-m` still resolves `..`, so escapes remain caught by the existing prefix check. Because `-m` is GNU-only and guide §1.1 declares macOS supported, probe `-m` support once at startup and fall back to lexical normalisation via `$SDD_PYTHON -c 'import posixpath,sys; print(posixpath.normpath(sys.argv[1]))'` (deliberately `posixpath`). Do **not** hoist `mkdir -p` above the guard (design D6).
  - **Pattern:** `sdd-kit/install.sh`
  - **Gate:** `grep -q 'realpath -m --no-symlinks' sdd-kit/install.sh && grep -q 'path traversal blocked' sdd-kit/install.sh`
- [ ] 5.2 Prove the guard by driving it, not by re-testing coreutils: a scratch install whose MANIFEST carries a traversal entry must abort with the guard's message and exit non-zero, with the destination parent absent.
  - **Gate:** `bash -c 'R=$(git rev-parse --show-toplevel); T=$(mktemp -d); cd "$T" && git init -q . && cp -R "$R/sdd-kit" . && mkdir -p scripts && cp "$R/scripts/preflight-sdd.sh" scripts/ && printf "files:\n  - path: ../escape.txt\n    source: templates/scripts/verify-infra.sh\n    merge: COPY\n" > sdd-kit/MANIFEST.yaml && out=$(bash sdd-kit/install.sh --profile DOCS_SPECS --skip-preflight 2>&1); rc=$?; cd /; rm -rf "$T"; test $rc -ne 0 && echo "$out" | grep -q "path traversal blocked"'`
- [ ] 5.3 Count the templates the loop applied and exit non-zero before the completion output when the count is zero. Process substitution does not propagate exit status, so `set -euo pipefail` cannot see an empty feed; the `done < <(…)` loop runs in the current shell, so a plain counter survives past `done` (validated), and dry-run still increments it because PLAN returns happen inside `apply_file`.
  - **Pattern:** `sdd-kit/install.sh`
  - **Gate:** `bash -c 'grep -qiE "no templates|APPLIED_COUNT|applied 0" sdd-kit/install.sh'`
- [ ] 5.4 Prove the banner is unreachable on a genuinely empty feed. Empty it by deleting the `- path:` entry lines — the parser is key-blind and only anchors on `- path:`, so renaming the `files:` header (the first draft's simulation) does **not** empty it; that was measured at 45 entries either way.
  - **Gate:** `bash -c 'R=$(git rev-parse --show-toplevel); T=$(mktemp -d); cd "$T" && git init -q . && cp -R "$R/sdd-kit" . && mkdir -p scripts && cp "$R/scripts/preflight-sdd.sh" scripts/ && sed -i "/^  - path:/d" sdd-kit/MANIFEST.yaml && out=$(bash sdd-kit/install.sh --profile DOCS_SPECS --skip-preflight 2>&1); rc=$?; cd /; rm -rf "$T"; test $rc -ne 0 && ! echo "$out" | grep -q "Done\."'`

## 6. Checksum reader and non-vacuous gates

- [ ] 6.1 Fix path construction in **both** `sdd-kit/gen-manifest-checksums.sh` (line 72) and `sdd-kit/templates/scripts/verify-release-readiness.sh` (~115): join with `/` explicitly, never `os.path.join`, whose native `\` separator makes GNU `sha256sum` escape the whole output line. Note `pathlib` is not a fix — it also yields `\` on Windows.
  - **Pattern:** `sdd-kit/gen-manifest-checksums.sh`
  - **Gate:** `bash -c 'for f in sdd-kit/gen-manifest-checksums.sh sdd-kit/templates/scripts/verify-release-readiness.sh; do grep -q "os.path.join" "$f" && exit 1; done; exit 0'`
- [ ] 6.2 In the same two files, reject any digest that is not bare 64-char lowercase hex before comparing — the `\` escape prefix is invisible when two hashes are printed side by side and cost a full debugging session.
  - **Pattern:** `sdd-kit/gen-manifest-checksums.sh`
  - **Gate:** `bash -c 'for f in sdd-kit/gen-manifest-checksums.sh sdd-kit/templates/scripts/verify-release-readiness.sh; do grep -qE "fullmatch|\[0-9a-f\]\{64\}" "$f" || exit 1; done'`
- [ ] 6.3 Make a zero-comparison run fail in **each** of the two files (per-file check — a single grep across both passes when only one has the guard). Respect the spec's carve-outs: entries without `sha256:` stay WARN-and-proceed; consumer-repo parity skips stay skips; only "entries were selected and none got compared" fails.
  - **Pattern:** `sdd-kit/templates/scripts/verify-release-readiness.sh`
  - **Gate:** `bash -c 'for f in sdd-kit/gen-manifest-checksums.sh sdd-kit/templates/scripts/verify-release-readiness.sh; do grep -qiE "compared 0|no entries|nothing to verify|checked 0" "$f" || exit 1; done'`
- [ ] 6.4 Prove the parser on this host against a **scratch** kit copy (the real MANIFEST is legitimately stale until section 7 regenerates it): regenerate checksums in the copy, then assert every stored digest is clean 64-hex and the count matches the entry count. Pre-fix this fails on Windows because regen itself stores `\`-prefixed digests — which also means a regen-then-check round-trip alone would pass vacuously; the hex assertion is the real check.
  - **Gate:** `bash -c 'R=$(git rev-parse --show-toplevel); T=$(mktemp -d); cp -R "$R/sdd-kit" "$T/kit" && bash "$T/kit/gen-manifest-checksums.sh" >/dev/null 2>&1; h=$(grep -cE "^    sha256: \"[0-9a-f]{64}\"$" "$T/kit/MANIFEST.yaml"); n=$(grep -cE "^  - path:" "$T/kit/MANIFEST.yaml"); rm -rf "$T"; test "$h" -eq "$n" && test "$n" -ge 40'`
- [ ] 6.5 Prove the vacuous path is closed and **attributable**: with a deliberately broken forced interpreter, the readiness script must fail (non-zero) *and* say why in terms of the interpreter — an unattributed failure would pass at this point in the tree for unrelated reasons (unmirrored templates), proving nothing.
  - **Gate:** `bash -c 'out=$(env SDD_PYTHON=/nonexistent bash sdd-kit/templates/scripts/verify-release-readiness.sh 2>&1); rc=$?; test $rc -ne 0 && echo "$out" | grep -qiE "python|interpreter"'`

## 7. Mirror, checksums, parity

- [ ] 7.1 Mirror every edited `sdd-kit/templates/scripts/*.sh` to its live counterpart in `scripts/` — including `verify-release-readiness.sh`, which the first draft's mirror list omitted and which would otherwise only explode at the final readiness gate.
  - **Pattern:** `scripts/preflight-sdd.sh`
  - **Gate:** `bash -c 'for b in preflight-sdd.sh verify-infra.sh sdd-upgrade-diff.sh verify-release-readiness.sh; do cmp -s "scripts/$b" "sdd-kit/templates/scripts/$b" || exit 1; done'`
- [ ] 7.2 Regenerate the real MANIFEST checksums, then check them. This must come **after** all template edits and **before** any gate that runs `--check` against the live MANIFEST — the first draft ran the check mid-edit, where genuine mismatches from its own earlier tasks made it unpassable.
  - **Pattern:** `sdd-kit/MANIFEST.yaml`
  - **Gate:** `bash sdd-kit/gen-manifest-checksums.sh --check`
- [ ] 7.3 Run the kit's own verification in hub context.
  - **Gate:** `bash sdd-kit/verify.sh`

## 8. CI greenfield smoke test

- [ ] 8.1 Add a greenfield install job to `.github/workflows/sdd-gates.yml`: create an empty repo under `${{ runner.temp }}`, place the documented footprint, run the installer. The target must not be the hub checkout and must not be pre-seeded with `.github/` — that seeding is exactly what hid the defect. (Workflow YAML validity is covered by the existing workflow tooling; the gate here checks presence and placement without coupling to PyYAML, which nothing in the repo declares.)
  - **Pattern:** `.github/workflows/sdd-gates.yml`
  - **Gate:** `bash -c 'grep -qiE "greenfield" .github/workflows/sdd-gates.yml && grep -q "runner.temp" .github/workflows/sdd-gates.yml'`
- [ ] 8.2 Assert file count **and** one file under a newly created parent — `.github/workflows/sdd-gates.yml` in the target is the specific path that aborted the run. An exit code alone did not catch this defect and must not be the only check.
  - **Pattern:** `.github/workflows/sdd-gates.yml`
  - **Gate:** `bash -c 'awk "/greenfield/,0" .github/workflows/sdd-gates.yml | grep -qE "\.github/workflows/sdd-gates\.yml" && awk "/greenfield/,0" .github/workflows/sdd-gates.yml | grep -qiE "wc -l|count"'`
- [ ] 8.3 Do not pin the new job to a third-party Action. `sdd-ci-gates` authorises exactly one external Action (OSV) and no others without its own change.
  - **Gate:** `bash -c 'test "$(grep -cE "^\s+uses:" .github/workflows/sdd-gates.yml)" -eq "$(grep -cE "^\s+uses: (actions/|google/osv-scanner-action)" .github/workflows/sdd-gates.yml)"'`

## 9. Guide, version, changelog

- [ ] 9.1 Correct guide §1.1. The row claims *"Native Windows works but WSL2 avoids 80% of issues"* — measured false. State Python's role for the **installer** (kit floor 3.8), separately from Graphify's 3.10, since §2.9.4 permits deferring Graphify.
  - **Pattern:** `doc/byebyevibe-guide.md`
  - **Gate:** `bash -c 'G=$(mktemp); awk "/^### 1\.1 /,/^### 1\.2 /" doc/byebyevibe-guide.md > "$G"; grep -q "3\.8" "$G" && grep -qiE "installer|install\.sh" "$G" && ! grep -q "80% of issues" "$G"; rc=$?; rm -f "$G"; exit $rc'`
- [ ] 9.2 Bump `sdd-kit/MANIFEST.yaml` `version:` and `guide_version:` 1.13.0 → 1.14.0 together. Minor, not patch: four capabilities gain normative requirements and `install.sh` now aborts where it printed `Done`. Line-anchored edit — `guide_version:` contains `version:` as a substring.
  - **Pattern:** `sdd-kit/MANIFEST.yaml`
  - **Gate:** `grep -qE '^version: "1\.14\.0"' sdd-kit/MANIFEST.yaml && grep -qE '^guide_version: "1\.14\.0"' sdd-kit/MANIFEST.yaml`
- [ ] 9.3 Sync the three declared version strings: `sdd-kit/README.md` H1, the guide's `Canonical install guide (vX.Y.Z)` blockquote, and the guide's `**Guide version:**` line. `sdd-kit/README.md` is stored with **CRLF** — the gate asserts that property directly instead of measuring the diff, which is empty once apply commits and would pass exactly when bypassed.
  - **Pattern:** `sdd-kit/README.md`
  - **Gate:** `bash -c 'grep -q "1\.14\.0" sdd-kit/README.md && awk "/\r$/{n++} END{exit !(n>5)}" sdd-kit/README.md'`
- [ ] 9.4 Add the `### 1.14.0 (YYYY-MM-DD)` changelog entry. State plainly: no released version could complete a C1 greenfield install on native Windows; the `realpath` defect affected **every** platform in a repository without `.github/`; checksum verification could not pass on Windows at all; and the release-readiness gate once passed vacuously — the server-side re-run is what protected v1.13.0. Name the behaviour change: installs that silently wrote nothing now abort. v1.13.0 is not withdrawn.
  - **Pattern:** `doc/byebyevibe-guide.md`
  - **Gate:** `bash -c 'grep -q "### 1.14.0" doc/byebyevibe-guide.md && bash scripts/release-notes.sh 1.14.0 | grep -qi "windows" && bash scripts/release-notes.sh 1.14.0 | grep -qiE "greenfield|realpath|every platform"'`

## 10. Verification

- [ ] 10.1 End-to-end greenfield install locally — the proof this change exists to deliver. Baseline before the fix: exit 1 at `.github/workflows/sdd-gates.yml`; expected after: exit 0, populated target, the workflows file present.
  - **Gate:** `bash -c 'R=$(git rev-parse --show-toplevel); T=$(mktemp -d); cd "$T" && git init -q . && cp -R "$R/sdd-kit" . && mkdir -p scripts && cp "$R/scripts/bootstrap-sdd.sh" "$R/scripts/preflight-sdd.sh" scripts/ && bash sdd-kit/install.sh --profile DOCS_SPECS >/dev/null 2>&1 && test -f .github/workflows/sdd-gates.yml && test "$(find . -type f -not -path "./.git/*" -not -path "./sdd-kit/*" | wc -l)" -ge 20; rc=$?; cd /; rm -rf "$T"; exit $rc'`
- [ ] 10.2 Exercise the fallback rung with `python3` genuinely absent. The gate asserts its own precondition — if `python3` still resolves after the PATH filter (any Linux host), it passes trivially and proves nothing; on this Windows host, with the filter removing the shim and the Store alias, it exercises the `python` rung for real. Host-specific by nature; task 11.2 is the authoritative version.
  - **Gate:** `bash -c 'FP=$(echo "$PATH" | tr ":" "\n" | grep -viE "windowsapps" | grep -vF "$HOME/bin" | paste -sd:); PATH="$FP" command -v python3 >/dev/null && exit 0; PATH="$FP" bash sdd-kit/templates/scripts/preflight-sdd.sh --host 2>&1 | grep -qiE "OK.*python.*3\.[0-9]+"'`
- [ ] 10.3 Repo-state gate and full local verify — both must pass **on this Windows host**, which they cannot today; their passing is itself evidence for the checksum-reader fix.
  - **Gate:** `bash scripts/verify-release-readiness.sh && bash sdd-kit/verify.sh`
- [ ] 10.4 Validate the change against OpenSpec.
  - **Gate:** `npx --yes @fission-ai/openspec@1.3.1 validate --all --strict`
- [ ] 10.5 Task pattern verifier.
  - **Gate:** `bash scripts/verify-task-patterns.sh`

## 11. Manual follow-up (outside apply)

- [ ] 11.1 [MANUAL ACTION REQUIRED] After merge, cut `1.14.0` (`bash scripts/cut-release.sh 1.14.0 --dry-run`, review, then without the flag). Until it is cut, `releases/latest/download/` keeps serving the 1.13.0 kit — the broken one the §1.6 default now points every new installer at.
  - **Gate:** — (post-merge operator action)
- [ ] 11.2 [MANUAL ACTION REQUIRED] Walk the §1.6 recipe end-to-end against the new release on native Windows in Git Bash, **after removing the `python3` shim from `~/bin`** (restore it afterwards if desired). With the shim present the cascade resolves `python3` and the `python` rung — the one this change exists for — is never exercised. CI cannot reproduce this configuration.
  - **Gate:** — (operator action; the absence of the shim is the point of the test)

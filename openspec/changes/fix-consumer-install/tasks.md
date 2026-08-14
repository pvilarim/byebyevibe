# Tasks — fix-consumer-install

Order is normative: group 1 is the prerequisite for the smoke test (group 6) not to fail for the wrong reason (design D1, Migration Plan). Line references are against master @ 2b73ccf.

## 1. Hub detection by explicit marker (D1 — defects 4 and 5)

- [ ] 1.1 Create `.sdd-hub` at the hub repo root: one comment line stating what it is (hub-identity marker — never ship to consumers; scripts branch on it instead of directory shape). It MUST NOT be added to `sdd-kit/MANIFEST.yaml` and MUST NOT live inside `sdd-kit/`, so no acquisition path can deliver it.
  - **Gate:** `bash -c 'test -f .sdd-hub && ! grep -q "sdd-hub" sdd-kit/MANIFEST.yaml'`
- [ ] 1.2 In `sdd-kit/verify.sh`, replace the two hub-identity directory tests with the marker: line 64 (`sdd-gates template` check — hub-only) and line 125 (language-policy grandfathering skip). Presence-fallback checks that are not hub-identity (Probity report-only at :82, metrics at :93) stay as they are. The skip message at :126 keeps naming the grandfathering but its guard becomes `[[ -f "$REPO_ROOT/.sdd-hub" ]]`.
  - **Pattern:** `sdd-kit/verify.sh`
  - **Gate:** `bash -c 'test "$(grep -c "\.sdd-hub" sdd-kit/verify.sh)" -ge 2 && ! grep -B1 "sdd-gates template" sdd-kit/verify.sh | grep -q "templates \]\]\|templates\"\]\]" && grep -B2 "hub distribution repo" sdd-kit/verify.sh | grep -q "sdd-hub"'`
- [ ] 1.3 Move the two hub-parity blocks of `verify.sh` (MANIFEST sha256 parity and live-scripts↔templates parity) onto the same marker, recording an explicit skip line in consumers ("skipped: not the hub" — a legitimately absent subject per `sdd-fail-loud`, never silence). Audit `scripts/verify-release-readiness.sh` and `sdd-kit/upgrade.sh` for any other hub-identity-by-directory test and switch what is found; file-presence degradations that are not identity tests stay.
  - **Pattern:** `sdd-kit/verify.sh`
  - **Gate:** `bash -c 'grep -qi "not the hub" sdd-kit/verify.sh && test "$(grep -c "\.sdd-hub" sdd-kit/verify.sh)" -ge 3'`

## 2. Hub-mode payload and bootstrap honesty (D2, D9, D10 — defects 1, 7/8-order, init silence)

- [ ] 2.1 In `sdd-kit/install.sh`, derive the source kit root when the target has none: before the preflight call at :228, if `[[ ! -d "$REPO_ROOT/sdd-kit" ]]`, append `--kit-root "$(dirname "$KIT_DIR")"` to the preflight invocation (`KIT_DIR` is line 6). No new public flag. Confirm `scripts/preflight-sdd.sh` accepts `--kit-root` in `--repo` mode (it does for `--all`; extend if repo mode rejects it) — mirror `sdd-kit/templates/scripts/preflight-sdd.sh` in the same edit.
  - **Pattern:** `sdd-kit/install.sh`
  - **Gate:** `bash -c 'grep -q "kit-root" sdd-kit/install.sh && grep -q "KIT_DIR" sdd-kit/install.sh'`
- [ ] 2.2 In `scripts/bootstrap-sdd.sh:309-311` (and the template mirror), the `install.sh` failure stops being WARN: exit non-zero with an error stating the payload was not installed. GitNexus/Graphify optional-continue behavior is untouched.
  - **Pattern:** `scripts/bootstrap-sdd.sh`
  - **Gate:** `bash -c 'for f in scripts/bootstrap-sdd.sh sdd-kit/templates/scripts/bootstrap-sdd.sh; do grep -q "payload" "$f" || exit 1; grep -q "WARN: sdd-kit/install.sh failed" "$f" && exit 1; done; exit 0'`
- [ ] 2.3 In `scripts/bootstrap-sdd.sh:246` (and mirror), stop silencing `openspec init`: capture stderr of the first attempt, and when the fallback also fails, exit non-zero printing the captured output (per `sdd-fail-loud`).
  - **Pattern:** `scripts/bootstrap-sdd.sh`
  - **Gate:** `bash -c 'for f in scripts/bootstrap-sdd.sh sdd-kit/templates/scripts/bootstrap-sdd.sh; do grep -q "openspec init" "$f" || exit 1; grep "openspec init" "$f" | grep -q "2>/dev/null" && exit 1; done; exit 0'`
- [ ] 2.4 AGENTS.md order fix without reordering (C1 order is MUST NOT change): `bootstrap-sdd.sh` records `AGENTS.md` existence before the GitNexus/Graphify phases and exports `SDD_AGENTS_PREEXISTED=0|1` to the kit install phase. In `sdd-kit/install.sh`, `merge_agents_profile` treats an existing file with `SDD_AGENTS_PREEXISTED=0` as tool-generated: write the kit profile AGENTS.md and re-append the previous (tool-injected) content; unset variable → current KEEP behavior stands. Mirror the bootstrap edit.
  - **Pattern:** `scripts/bootstrap-sdd.sh`
  - **Gate:** `bash -c 'for f in scripts/bootstrap-sdd.sh sdd-kit/templates/scripts/bootstrap-sdd.sh sdd-kit/install.sh; do grep -q "SDD_AGENTS_PREEXISTED" "$f" || exit 1; done'`
- [ ] 2.5 Prove hub-mode end to end on this host: installing from the hub checkout into a kit-less temp repo must apply the payload (defect 1 was exit 0 with zero files).
  - **Gate:** `bash -c 'R=$(git rev-parse --show-toplevel); T=$(mktemp -d); (cd "$T" && git init -q .); bash "$R/sdd-kit/install.sh" --profile APP --repo "$T" --chat-lang en --docs-lang en --code-lang en >/dev/null 2>&1 && test -f "$T/AGENTS.md" && test -f "$T/openspec/project.md" && ok=1; rm -rf "$T"; test "${ok:-0}" = 1'`

## 3. MANIFEST payload (D3, D4, D5, D6 — defects 2, 7, 3, 6)

- [ ] 3.1 Delete the three MANIFEST entries whose destination is inside `sdd-kit/` (`sdd-kit/install-ui-module.sh` :202-207, `sdd-kit/install-probity-module.sh` :246-251, `sdd-kit/templates/probity.config.ts` :253-258). They were src==dest self-copies on the whole-kit path (defect 2) and the only creator of the false hub heuristic. The files themselves stay in the kit.
  - **Pattern:** `sdd-kit/MANIFEST.yaml`
  - **Gate:** `bash -c '! grep -q "path: sdd-kit/" sdd-kit/MANIFEST.yaml && test -f sdd-kit/install-ui-module.sh && test -f sdd-kit/install-probity-module.sh && test -f sdd-kit/templates/probity.config.ts'`
- [ ] 3.2 Create `sdd-kit/templates/openspec/project.md`: minimal constitution skeleton (Purpose, Stack, Conventions, Constraints) with `[FILL]` placeholders and the `<!-- SDD_LANGUAGE_POLICY_START/END -->` anchor markers. Add the MANIFEST entry → `openspec/project.md`, `merge: MERGE`, all profiles, with a gate command.
  - **Pattern:** `sdd-kit/templates/openspec/infra.md`
  - **Gate:** `bash -c 'f=sdd-kit/templates/openspec/project.md; test -f $f && grep -q "SDD_LANGUAGE_POLICY_START" $f && grep -A4 "path: openspec/project.md" sdd-kit/MANIFEST.yaml | grep -q "merge: MERGE"'`
- [ ] 3.3 Create `sdd-kit/templates/openspec/changes/_template/specs/example-capability/spec.md` with one normative `## ADDED Requirements` placeholder requirement + one `#### Scenario:` (the operator's proven workaround shape). Add the MANIFEST entry (COPY, all profiles).
  - **Pattern:** `openspec/changes/fix-consumer-install/specs/sdd-fail-loud/spec.md`
  - **Gate:** `bash -c 'f=sdd-kit/templates/openspec/changes/_template/specs/example-capability/spec.md; test -f $f && grep -q "## ADDED Requirements" $f && grep -q "#### Scenario:" $f && grep -q "_template/specs" sdd-kit/MANIFEST.yaml'`
- [ ] 3.4 Mirror the guide: copy `doc/byebyevibe-guide.md` → `sdd-kit/templates/doc/byebyevibe-guide.md` (byte-identical) and add the MANIFEST COPY entry → `doc/byebyevibe-guide.md`, all profiles — the exact pattern of the `doc/sdd-operator-day1.md` entry. This reverts 2026-08-05 and restores the 2026-06-17 founding intent (delta says so; see `specs/sdd-install-kit/spec.md`).
  - **Pattern:** `sdd-kit/MANIFEST.yaml`
  - **Gate:** `bash -c 'cmp -s doc/byebyevibe-guide.md sdd-kit/templates/doc/byebyevibe-guide.md && grep -q "path: doc/byebyevibe-guide.md" sdd-kit/MANIFEST.yaml'`
- [ ] 3.5 Add guide hub↔template parity to `scripts/verify-release-readiness.sh` (and mirror): FAIL on drift between `doc/byebyevibe-guide.md` and `sdd-kit/templates/doc/byebyevibe-guide.md`. While there, confirm the :33-35 "INFO: absent" degradation now only fires where the guide is legitimately absent — with the guide delivered, version-claim checks run in consumers (expected gain; the smoke test will surface it if it turns into noise).
  - **Pattern:** `scripts/verify-release-readiness.sh`
  - **Gate:** `bash -c 'for f in scripts/verify-release-readiness.sh sdd-kit/templates/scripts/verify-release-readiness.sh; do grep -q "templates/doc/byebyevibe-guide.md" "$f" || exit 1; done'`

## 4. install.sh behavior (D4 fail-loud, D8 teaser — defects 7 and message)

- [ ] 4.1 In `inject_language_policy` (`sdd-kit/install.sh:104-107`): a missing `openspec/project.md` at injection time becomes FAIL — print an ERROR naming the file and exit non-zero (the MANIFEST now ships the template, so absence means the entry itself failed; WARN-and-continue converted a broken install into a reported success).
  - **Pattern:** `sdd-kit/install.sh`
  - **Gate:** `bash -c 'awk "/inject_language_policy\(\)/,/^}/" sdd-kit/install.sh | grep -q "exit 1" && ! awk "/inject_language_policy\(\)/,/^}/" sdd-kit/install.sh | grep -q "WARN openspec/project.md missing"'`
- [ ] 4.2 Rewrite `print_optional_addons_teaser` (both language blocks, `sdd-kit/install.sh:456-493`) with the §9.2 copy from `openspec/changes/explore-consumer-install-defects/research.md` (pt-BR ready; write the en equivalent in the same shape): per module (UI, Probity, Metrics) an "install it and get…" sentence plus "skip if…" condition. CI gates becomes a manual-GitHub-step line, and when `git remote -v` is empty the message says the gates are inert until a remote exists. No dead local paths: module commands print relative to `$KIT_DIR`.
  - **Pattern:** `openspec/changes/explore-consumer-install-defects/research.md`
  - **Gate:** `bash -c 'grep -q "git remote" sdd-kit/install.sh && grep -qi "pule se" sdd-kit/install.sh && grep -qi "skip if" sdd-kit/install.sh'`

## 5. macOS portability by construction (D11 — 9a…9e)

- [ ] 5.1 Remove every `sed -i` call site: `scripts/preflight-sdd.sh:385`, `scripts/verify-infra.sh:55,:240`, `sdd-kit/install-ui-module.sh:139`, plus the three template mirrors (`templates/scripts/preflight-sdd.sh`, `templates/scripts/verify-infra.sh`, `templates/install-ui-module.sh`). Portable form: `sed '…' file > tmp && mv tmp file` via `mktemp` — no BSD/GNU probe.
  - **Pattern:** `scripts/verify-infra.sh`
  - **Gate:** `bash -c 'for f in scripts/preflight-sdd.sh scripts/verify-infra.sh sdd-kit/install-ui-module.sh sdd-kit/templates/scripts/preflight-sdd.sh sdd-kit/templates/scripts/verify-infra.sh sdd-kit/templates/install-ui-module.sh; do grep -q "sed -i" "$f" && exit 1; done; exit 0'`
- [ ] 5.2 Replace the five heredoc-inside-process-substitution feeds with temp-file transport: the interpreter writes its TSV to a `mktemp` file (plain heredoc — safe on bash 3.2), the script checks the interpreter's exit status explicitly and aborts non-zero on failure (naming the failed generation), then `while read … done < "$tmpfile"`. Move `| tr -d '\r'` onto the generation step (metadata stream only). Sites: `sdd-kit/install.sh:400`, `sdd-kit/upgrade.sh:141,:270`, `scripts/sdd-upgrade-diff.sh:38` + `sdd-kit/templates/scripts/sdd-upgrade-diff.sh:38`.
  - **Pattern:** `sdd-kit/install.sh`
  - **Gate:** `bash -c 'for f in sdd-kit/install.sh sdd-kit/upgrade.sh scripts/sdd-upgrade-diff.sh sdd-kit/templates/scripts/sdd-upgrade-diff.sh; do grep -qF "< <(\$SDD_PYTHON" "$f" && exit 1; done; exit 0'`
- [ ] 5.3 Prove the empty-feed abort survived the 5.2 rewrite: an install whose MANIFEST has no `- path:` entries must exit non-zero without printing "Done." (deleting entry lines with a portable filter, not `sed -i`).
  - **Gate:** `bash -c 'R=$(git rev-parse --show-toplevel); T=$(mktemp -d); (cd "$T" && git init -q . && cp -R "$R/sdd-kit" . && grep -v "^  - path:" sdd-kit/MANIFEST.yaml > m && mv m sdd-kit/MANIFEST.yaml); out=$(cd "$T" && bash sdd-kit/install.sh --profile DOCS_SPECS --skip-preflight --chat-lang en --docs-lang en --code-lang en 2>&1); rc=$?; rm -rf "$T"; test $rc -ne 0 && ! echo "$out" | grep -q "Done\."'`
- [ ] 5.4 Make the guide §1.6 recipe's checksum step portable (9c): replace `sha256sum -c` in the two recipe blocks with explicit comparison — read expected digest from the sidecar, compute actual via `sha256sum || shasum -a 256`, string-compare, abort loudly on mismatch. §2.18 regeneration prose updated to match.
  - **Pattern:** `doc/byebyevibe-guide.md`
  - **Gate:** `bash -c '! grep -q "sha256sum -c byebyevibe-kit" doc/byebyevibe-guide.md && grep -q "shasum -a 256" doc/byebyevibe-guide.md'`
- [ ] 5.5 Extend the interpreter cascade (9d) to `python3`, `python3.14`, `python3.13`, `python`, `py -3`, `/usr/bin/python3` (that order; suffixed rungs give macOS real alternatives, `/usr/bin/python3` last because it may be the CLT shim) — in `scripts/preflight-sdd.sh` (:112 and the repo-mode resolver), `sdd-kit/install.sh` (:242 fallback), and every standalone cascade (`sdd-kit/upgrade.sh`, `sdd-kit/gen-manifest-checksums.sh`, `sdd-kit/templates/scripts/{verify-release-readiness,sdd-upgrade-diff,verify-infra}.sh` + live copies) — keeping candidates as literal strings (word-splitting convention) and failure messages naming every candidate tried.
  - **Pattern:** `scripts/preflight-sdd.sh`
  - **Gate:** `bash -c 'for f in scripts/preflight-sdd.sh sdd-kit/templates/scripts/preflight-sdd.sh sdd-kit/install.sh sdd-kit/upgrade.sh; do grep -q "python3.13" "$f" || exit 1; done'`
- [ ] 5.6 Declare `flock` best-effort (9e) in `scripts/sdd-session-lib.sh` + template mirror: probe `command -v flock` once; when absent print exactly one line (advisory lock unavailable on this platform — PID-file check is the active guard) and skip the flock subshell instead of letting it fail invisibly. PID-file mechanism unchanged.
  - **Pattern:** `scripts/sdd-session-lib.sh`
  - **Gate:** `bash -c 'for f in scripts/sdd-session-lib.sh sdd-kit/templates/scripts/sdd-session-lib.sh; do grep -q "command -v flock" "$f" || exit 1; grep -qi "PID-file" "$f" || exit 1; done'`

## 6. The gate that proves everything (D7 — consumer smoke test)

- [ ] 6.1 Add the blocking "Consumer install smoke test" to `.github/workflows/sdd-gates.yml` (+ template mirror), variation A: temp repo under `runner.temp` outside the checkout, `git init` + initial commit, `cp -R sdd-kit` in, `install.sh --profile APP` with explicit language flags; assert (1) every APP-profile MANIFEST entry's destination exists — enumerated from the MANIFEST at run time, no hardcoded count; (2) `bash sdd-kit/verify.sh` exit 0 — the job provisions pinned `gitnexus` (+ `gitnexus analyze`) and `uv`+`graphify` (+ `graphify update .`) so the exit 0 is genuine, never a fabricated artifact; (3) `openspec validate --all --strict` exit 0; (4) `openspec/project.md` contains `## Language policy` and both anchor markers.
  - **Pattern:** `.github/workflows/sdd-gates.yml`
  - **Gate:** `bash -c 'for f in .github/workflows/sdd-gates.yml sdd-kit/templates/.github/workflows/sdd-gates.yml; do grep -q "Consumer install smoke" "$f" || exit 1; grep -q "profile APP" "$f" || exit 1; done'`
- [ ] 6.2 Variation B (hub-mode, defect 1) in the same job: second temp repo, no kit copied; run the checkout's `sdd-kit/install.sh --repo` against it; assert entries applied + `project.md` with the policy block (no verify.sh — hub-mode consumers have no local kit until 1.16.0 D2).
  - **Pattern:** `.github/workflows/sdd-gates.yml`
  - **Gate:** `bash -c 'grep -q "hub-mode" .github/workflows/sdd-gates.yml'`
- [ ] 6.3 Rehearse variation A locally minus the knowledge CLIs (they are CI-provisioned): full APP install into a temp repo, then per-entry enumeration, strict validation, and the policy block — the assertions that catch defects 2, 3, 4, 5 and 7 must pass on this host before the workflow lands.
  - **Gate:** `bash -c 'R=$(git rev-parse --show-toplevel); T=$(mktemp -d); (cd "$T" && git init -q . && cp -R "$R/sdd-kit" . && bash sdd-kit/install.sh --profile APP --chat-lang en --docs-lang en --code-lang en >/dev/null 2>&1 && test -f doc/byebyevibe-guide.md && test -f openspec/changes/_template/specs/example-capability/spec.md && grep -q "SDD_LANGUAGE_POLICY_START" openspec/project.md && openspec validate --all --strict >/dev/null 2>&1) && ok=1; rm -rf "$T"; test "${ok:-0}" = 1'`

## 7. Checksums and final verification

- [ ] 7.1 Regenerate MANIFEST checksums (`bash sdd-kit/gen-manifest-checksums.sh`) after all template edits — the guide mirror (175 KB) and the new templates enter here — and confirm release readiness passes.
  - **Pattern:** `sdd-kit/gen-manifest-checksums.sh`
  - **Gate:** `bash scripts/verify-release-readiness.sh`
- [ ] 7.2 Full local verification: strict validation of the whole workspace, task-pattern verifier, and hub verify (now marker-driven) all green.
  - **Gate:** `bash -c 'openspec validate --all --strict >/dev/null && bash scripts/verify-task-patterns.sh >/dev/null && bash sdd-kit/verify.sh >/dev/null'`

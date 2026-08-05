## 1. Version bump (must land before the gate — design Migration Plan)

- [ ] 1.1 Bump `sdd-kit/MANIFEST.yaml`: `version: "1.9.0"` → `"1.10.0"` and `guide_version: "1.9.0"` → `"1.10.0"`. Do not touch `min_openspec`, `profiles`, or any `sha256:` field (no template content changes in this change).
  - **Pattern:** sdd-kit/MANIFEST.yaml
  - **Gate:** `grep -q '^version: "1.10.0"' sdd-kit/MANIFEST.yaml && grep -q '^guide_version: "1.10.0"' sdd-kit/MANIFEST.yaml && grep -q '^min_openspec: "1.3.1"' sdd-kit/MANIFEST.yaml && echo OK`

- [ ] 1.2 Update the `sdd-kit/README.md` H1 to `# ByeByeVibe — sdd-kit v1.10.0`.
  - **Pattern:** sdd-kit/README.md
  - **Gate:** `head -1 sdd-kit/README.md | grep -q 'sdd-kit v1.10.0' && echo OK`

- [ ] 1.3 Update both guide header version claims to 1.10.0: the canonical-guide blockquote (`Canonical install guide (v1.8.2)` → `(v1.10.0)`) and the `**Guide version:**` line (`1.9.0` → `1.10.0`).
  - **Pattern:** doc/byebyevibe-guide.md
  - **Gate:** `grep -q 'Canonical install guide (v1.10.0)' doc/byebyevibe-guide.md && grep -q '^- \*\*Guide version:\*\* 1.10.0' doc/byebyevibe-guide.md && ! grep -q 'Canonical install guide (v1.8.2)' doc/byebyevibe-guide.md && echo OK`

- [ ] 1.4 Add a `### 1.10.0 (<today>)` entry at the top of guide §14 (Guide changelog) summarizing: the `verify.sh` version-sync gate, the kit README currency pass, the root README congruence fixes, and MANIFEST **1.9.0 → 1.10.0** with checksums unchanged.
  - **Pattern:** doc/byebyevibe-guide.md
  - **Gate:** `grep -q '^### 1.10.0 ' doc/byebyevibe-guide.md && awk '/^## Guide changelog/{f=1} f&&/^### /{print;exit}' doc/byebyevibe-guide.md | grep -q '1.10.0' && echo OK`

- [ ] 1.5 Refresh the stale `kit-version` marker in `openspec/infra.md` from `1.8.1` to `1.10.0` (manual one-off; `verify-infra.sh` owns this marker but only rewrites it on a `--write`/TTY run).
  - **Pattern:** openspec/infra.md
  - **Gate:** `grep -q '<!-- kit-version -->1.10.0<!-- /kit-version -->' openspec/infra.md && echo OK`

## 2. Version-sync gate in `sdd-kit/verify.sh`

- [ ] 2.1 Extract `guide_version:` alongside the existing `KIT_VER` parse at the top of `verify.sh` (the `version:` grep already there), storing it as `GUIDE_VER`; print it on the existing banner lines.
  - **Pattern:** sdd-kit/verify.sh
  - **Gate:** `grep -q 'guide_version' sdd-kit/verify.sh && echo OK`

- [ ] 2.2 Add a `==> version sync` block immediately **before** the `==> kit-integrity (hub only)` block. For each of the three claims, extract the semver token from its claim line, strip a leading `v`, and compare against its authority (`KIT_VER` for the kit README H1, `GUIDE_VER` for both guide header claims). Per design D3: file absent → INFO skip; claim line missing or token unparseable → WARN; mismatch → `FAIL` naming file, declared value and authority value, plus `((FAILURES++))`; match → OK. Keep each comparison independent so one FAIL does not mask another.
  - **Pattern:** sdd-kit/verify.sh
  - **Gate:** `grep -q 'version sync' sdd-kit/verify.sh && bash sdd-kit/verify.sh 2>&1 | grep -q 'version sync' && echo OK`

- [ ] 2.3 Prove the gate fails closed: temporarily set the kit README H1 to a wrong version, confirm `verify.sh` exits non-zero with a FAIL naming the file, then restore.
  - **Gate:** `cp sdd-kit/README.md /tmp/rm.bak && sed -i '1s/v1\.10\.0/v0.0.1/' sdd-kit/README.md && ! bash sdd-kit/verify.sh >/tmp/vs.out 2>&1; grep -q 'FAIL' /tmp/vs.out && grep -q 'sdd-kit/README.md' /tmp/vs.out && cp /tmp/rm.bak sdd-kit/README.md && bash sdd-kit/verify.sh >/dev/null 2>&1 && echo OK`

- [ ] 2.4 Prove the gate degrades: run the same check with `sdd-kit/README.md` temporarily moved away and confirm an INFO/skip line with exit code unchanged, then restore.
  - **Gate:** `mv sdd-kit/README.md /tmp/rm2.bak && bash sdd-kit/verify.sh >/tmp/vs2.out 2>&1; ec=$?; mv /tmp/rm2.bak sdd-kit/README.md; [ "$ec" -eq 0 ] && grep -qi 'skip\|INFO' /tmp/vs2.out && echo OK`

## 3. `sdd-kit/README.md` currency pass

- [ ] 3.1 Replace the two `APP/HYBRID` Probity references (first-contact table row and the Structure comment for `install-probity-module.sh`) with `APP`, so they stop contradicting the profiles table's own deprecation line.
  - **Pattern:** sdd-kit/README.md
  - **Gate:** `! grep -q 'APP/HYBRID' sdd-kit/README.md && grep -q 'HYBRID.*deprecated' sdd-kit/README.md && echo OK`

- [ ] 3.2 Replace the dead "planned for v1.5.0 if APP-repo validation confirms adoption" promise with the current factual status of the review skills (manual install, no automatic installer shipped).
  - **Pattern:** sdd-kit/README.md
  - **Gate:** `! grep -q 'v1.5.0' sdd-kit/README.md && echo OK`

- [ ] 3.3 Update the Structure block: add `gen-manifest-checksums.sh` with a one-line purpose, and change the `templates/` comment so it names `.claude/` (skills + commands) alongside `scripts/`, `.cursor/`, `doc/`.
  - **Pattern:** sdd-kit/README.md
  - **Gate:** `grep -q 'gen-manifest-checksums.sh' sdd-kit/README.md && grep -q '\.claude/' sdd-kit/README.md && echo OK`

- [ ] 3.4 Add a section documenting what the kit installs automatically for agent tooling: skills `openspec-help`, `sdd-skill-guidance`, `sdd-tooling-guidance` (both `.claude/` and `.cursor/` mirrors), the `/opsx:help` command, and the docs they depend on (`doc/sdd-operator-day1.md`, `doc/tooling-install.md`). Place it above the existing manual-install review-skills section and state the automatic vs manual distinction explicitly.
  - **Pattern:** sdd-kit/README.md
  - **Gate:** `grep -q 'sdd-tooling-guidance' sdd-kit/README.md && grep -q 'sdd-skill-guidance' sdd-kit/README.md && grep -q 'opsx:help' sdd-kit/README.md && grep -q 'doc/tooling-install.md' sdd-kit/README.md && echo OK`

- [ ] 3.5 Extend the CI-gate section to name every blocking gate in the shipped `sdd-gates.yml` — `openspec validate` (pinned `min_openspec`), `verify-task-patterns.sh`, and **OSV-Scanner** when a root lockfile is present — plus the `renovate.json` template for APP. Keep the existing branch-protection `[MANUAL ACTION REQUIRED]` note.
  - **Pattern:** sdd-kit/README.md
  - **Gate:** `grep -q 'OSV' sdd-kit/README.md && grep -q 'renovate.json' sdd-kit/README.md && grep -q 'MANUAL ACTION REQUIRED' sdd-kit/README.md && echo OK`

- [ ] 3.6 Add the hub→destination bootstrap form to Quick commands: `bash <hub>/scripts/bootstrap-sdd.sh <target-repo> --profile <PROFILE>`, labelled as the one-command hub-to-target flow (guide §1.6), next to the existing in-repo invocation.
  - **Pattern:** sdd-kit/README.md
  - **Gate:** `grep -q 'bootstrap-sdd.sh <target-repo>' sdd-kit/README.md || grep -qE 'bootstrap-sdd\.sh .*target' sdd-kit/README.md && echo OK`

- [ ] 3.7 State the report-only conditions next to `verify.sh` in Quick commands (or in a short note below it): `verify-infra.sh` writes `openspec/infra.md` markers only on a TTY or with `--write` (kit 1.8.2), and `verify-task-patterns.sh` is fail-closed in DOCS_SPECS but report-only in APP/UNKNOWN (kit 1.9.0).
  - **Pattern:** sdd-kit/README.md
  - **Gate:** `grep -q -- '--write' sdd-kit/README.md && grep -qi 'report-only' sdd-kit/README.md && echo OK`

## 4. Root README congruence

- [ ] 4.1 Make the first payload mention a link: `The install payload lives in [`sdd-kit/`](./sdd-kit/).`
  - **Pattern:** README.md
  - **Gate:** `grep -q 'install payload lives in \[`sdd-kit/`\](./sdd-kit/)' README.md && echo OK`

- [ ] 4.2 Drop `HYBRID` from the Get started profiles line (leave `APP · DOCS_SPECS` with the existing link to `sdd-kit/README.md`, which carries the deprecation detail) and drop `/HYBRID` from the Probity row of Optional modules.
  - **Pattern:** README.md
  - **Gate:** `! grep -q 'HYBRID' README.md && grep -q 'DOCS_SPECS' README.md && echo OK`

- [ ] 4.3 Correct the Docs table language cell for `sdd-kit/README.md` from `pt-BR (+ EN intro)` to `EN`.
  - **Pattern:** README.md
  - **Gate:** `! grep -q 'pt-BR (+ EN intro)' README.md && grep -q 'sdd-kit/README.md' README.md && echo OK`

## 5. Verify

- [ ] 5.1 Run `bash sdd-kit/verify.sh` and confirm it passes with the new gate active (kit-integrity must still be OK — no template changed, so no checksum regeneration is expected).
  - **Gate:** `bash sdd-kit/verify.sh 2>&1 | tee /tmp/v5.out | tail -1 | grep -q 'passed' && grep -q 'OK: kit-integrity' /tmp/v5.out && echo OK`

- [ ] 5.2 Confirm checksums are untouched by this change (documentation and `verify.sh` are not MANIFEST-tracked templates).
  - **Gate:** `bash sdd-kit/gen-manifest-checksums.sh --check && git diff --name-only | grep -qv '^sdd-kit/MANIFEST.yaml$' && echo OK`

- [ ] 5.3 Run `bash scripts/verify-task-patterns.sh` (hub is DOCS_SPECS — fail-closed) and `bash scripts/verify-infra.sh`, then `npx openspec validate --all --strict`.
  - **Gate:** `bash scripts/verify-task-patterns.sh && npx -y @fission-ai/openspec@1.3.1 validate --all --strict && echo OK`

- [ ] 5.4 Confirm no residual Portuguese prose was introduced in the edited surfaces (`docs_language: en`).
  - **Gate:** `bash scripts/verify-i18n-wave.sh --files sdd-kit/README.md,README.md || echo "review manually"`

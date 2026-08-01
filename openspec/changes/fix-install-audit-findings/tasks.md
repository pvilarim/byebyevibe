# Tasks — fix-install-audit-findings

> Apply after human approval (R7). Every template edit under `sdd-kit/templates/` requires checksum regen (task 6.1) before the final gate. Hub scripts and their template counterparts must be edited **pairwise** to keep the new drift gate (task 5.1) green.

## 1. Bootstrap fixes (`scripts/bootstrap-sdd.sh` + template)

- [x] 1.1 Snapshot the profile hint before `openspec init`: capture `openspec/` presence into a variable at bootstrap start (before phase 0 output ends) and use it in the kit-install HYBRID test instead of re-testing `-d openspec` post-init (design D1; ≤10 lines)
  - **Pattern:** `scripts/bootstrap-sdd.sh`
  - **Gate:** `grep -q 'PRE_INIT' scripts/bootstrap-sdd.sh && bash -n scripts/bootstrap-sdd.sh`
- [x] 1.2 Add `--profile APP|DOCS_SPECS|HYBRID` flag: validate at parse time (exit non-zero on invalid before phase 0), skip auto-detection when set, pass through to `install.sh`; fix the HYBRID WARN recovery text to reference `--profile` instead of "1st argument" (design D2; ≤15 lines)
  - **Pattern:** `scripts/bootstrap-sdd.sh`
  - **Gate:** `bash scripts/bootstrap-sdd.sh --profile FOO 2>&1 | grep -q 'APP' ; test "${PIPESTATUS[0]}" -ne 0 && ! grep -q '1st argument' scripts/bootstrap-sdd.sh`
- [x] 1.3 Make the Graphify phase non-fatal (WARN + continue, mirroring the GitNexus block) and `export PATH="$HOME/.local/bin:$PATH"` right after the uv curl installer (design D3; ≤12 lines)
  - **Pattern:** `scripts/bootstrap-sdd.sh`
  - **Gate:** `grep -q '.local/bin' scripts/bootstrap-sdd.sh && grep -qc 'WARN.*[Gg]raphify' scripts/bootstrap-sdd.sh`
- [x] 1.4 Mirror 1.1–1.3 into `sdd-kit/templates/scripts/bootstrap-sdd.sh` (identical content)
  - **Pattern:** `sdd-kit/templates/scripts/bootstrap-sdd.sh`
  - **Gate:** `diff -q scripts/bootstrap-sdd.sh sdd-kit/templates/scripts/bootstrap-sdd.sh`

## 2. Profile validation and dry-run purity (`sdd-kit/install.sh`, `sdd-kit/upgrade.sh`)

- [x] 2.1 `install.sh`: validate `$PROFILE` against `APP|DOCS_SPECS|HYBRID` immediately after arg parsing (before preflight and before the manifest loop), error naming allowed values (≤8 lines)
  - **Pattern:** `sdd-kit/install.sh`
  - **Gate:** `! bash sdd-kit/install.sh --profile FOO --skip-preflight --dry-run >/dev/null 2>&1`
- [x] 2.2 `install.sh`: delete the loop-level `chmod +x` that runs under `--dry-run` (redundant with the guarded one in `apply_file`; design D9; ≤4 lines removed)
  - **Pattern:** `sdd-kit/install.sh`
  - **Gate:** `test "$(grep -c 'chmod +x' sdd-kit/install.sh)" -eq 1`
- [x] 2.3 `upgrade.sh`: apply the same profile validation whenever `--profile` is supplied (≤8 lines)
  - **Pattern:** `sdd-kit/upgrade.sh`
  - **Gate:** `! bash sdd-kit/upgrade.sh --from 1.0.0 --to 1.6.1 --apply --profile FOO >/dev/null 2>&1`

## 3. Preflight per-mode stamping (`scripts/preflight-sdd.sh` + template)

- [x] 3.1 Pass the mode into `stamp_infra`; when mode is `repo`, update only `preflight-timestamp` and `preflight-warns`, never `preflight-ides` / `preflight-mcp` (design D5; ≤10 lines)
  - **Pattern:** `scripts/preflight-sdd.sh`
  - **Gate:** `bash -n scripts/preflight-sdd.sh && grep -q 'repo' scripts/preflight-sdd.sh`
- [x] 3.2 Mirror 3.1 into `sdd-kit/templates/scripts/preflight-sdd.sh` (identical content)
  - **Pattern:** `sdd-kit/templates/scripts/preflight-sdd.sh`
  - **Gate:** `diff -q scripts/preflight-sdd.sh sdd-kit/templates/scripts/preflight-sdd.sh`

## 4. Honest module status (Probity, UI)

- [x] 4.1 `install-probity-module.sh`: decide package-row status from `grep -q '@nizos/probity' package.json` after the npm step (✅ only on actual install; `pending` on skip/decline); split the infra table so the package row's verify command checks `package.json`, config row keeps `test -f probity.config.ts` (design D6; ≤15 lines)
  - **Pattern:** `sdd-kit/install-probity-module.sh`
  - **Gate:** `bash -n sdd-kit/install-probity-module.sh && grep -q "package.json" sdd-kit/install-probity-module.sh`
- [x] 4.2 Mirror 4.1 into `sdd-kit/templates/install-probity-module.sh`
  - **Pattern:** `sdd-kit/templates/install-probity-module.sh`
  - **Gate:** `diff -q sdd-kit/install-probity-module.sh sdd-kit/templates/install-probity-module.sh`
- [x] 4.3 `install-ui-module.sh`: replace the `--yes && node>=24` ✅ heuristic with a single post-`maybe_install_impeccable` check on `.cursor/skills/impeccable` presence (design D7; ≤10 lines)
  - **Pattern:** `sdd-kit/install-ui-module.sh`
  - **Gate:** `bash -n sdd-kit/install-ui-module.sh && grep -q 'skills/impeccable' sdd-kit/install-ui-module.sh`
- [x] 4.4 Mirror 4.3 into `sdd-kit/templates/install-ui-module.sh`
  - **Pattern:** `sdd-kit/templates/install-ui-module.sh`
  - **Gate:** `diff -q sdd-kit/install-ui-module.sh sdd-kit/templates/install-ui-module.sh`

## 5. Hub drift gate + reconciliation

- [x] 5.1 Reconcile current drift **before** the gate lands: port live `scripts/verify-task-patterns.sh` (newer — archive resolution) into `sdd-kit/templates/scripts/verify-task-patterns.sh`; port template `sdd-kit/templates/scripts/sdd-upgrade-diff.sh` (newer — TSV source-aware parsing) into `scripts/sdd-upgrade-diff.sh` (design D8)
  - **Pattern:** `scripts/verify-task-patterns.sh`
  - **Gate:** `diff -q scripts/verify-task-patterns.sh sdd-kit/templates/scripts/verify-task-patterns.sh && diff -q scripts/sdd-upgrade-diff.sh sdd-kit/templates/scripts/sdd-upgrade-diff.sh`
- [x] 5.2 `verify.sh`: add hub-only parity block — for each `sdd-kit/templates/scripts/*.sh` with a live `scripts/<basename>` counterpart, `diff -q`; any difference increments FAILURES (design D8; ≤15 lines)
  - **Pattern:** `sdd-kit/verify.sh`
  - **Gate:** `grep -q 'templates/scripts' sdd-kit/verify.sh && bash -n sdd-kit/verify.sh`
- [x] 5.3 `gen-manifest-checksums.sh`: standard arg loop — accept `--check`/`--help`, reject unknown args with usage + exit 2 before any hashing (design D10; ≤12 lines)
  - **Pattern:** `sdd-kit/gen-manifest-checksums.sh`
  - **Gate:** `! bash sdd-kit/gen-manifest-checksums.sh --hlep >/dev/null 2>&1 && bash sdd-kit/gen-manifest-checksums.sh --help >/dev/null`

## 6. Checksums, docs, validation

- [x] 6.1 Regenerate MANIFEST checksums after all template edits
  - **Pattern:** `sdd-kit/gen-manifest-checksums.sh`
  - **Gate:** `bash sdd-kit/gen-manifest-checksums.sh --check`
- [x] 6.2 Guide touch-ups in `doc/sistema-sdd-pedro.md` §2: document bootstrap `--profile` and Graphify WARN-and-continue posture (prose only, where §2 describes current behavior)
  - **Pattern:** `doc/sistema-sdd-pedro.md`
  - **Gate:** `grep -q 'bootstrap-sdd.sh --profile\|--profile.*bootstrap' doc/sistema-sdd-pedro.md`
- [x] 6.3 Full verification: kit verify + task patterns + strict OpenSpec validate
  - **Pattern:** `scripts/verify-task-patterns.sh`
  - **Gate:** `bash sdd-kit/verify.sh && bash scripts/verify-task-patterns.sh && OPENSPEC_TELEMETRY=0 npx --yes @fission-ai/openspec@1.3.1 validate fix-install-audit-findings --strict`

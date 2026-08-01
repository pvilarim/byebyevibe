## 1. Preflight script (kit + hub)

- [x] 1.1 Create `sdd-kit/templates/scripts/preflight-sdd.sh` with `--host|--repo|--all` (default `--all`), optional `--json`, `--profile`, `--repo-root`; implement FAIL/WARN/SKIP matrix from design D2–D4 (Git/Node≥20.19/npm/Python≥3.10 FAIL; uv WARN; build-tools WARN + three escapes; IDE advisory; repo `sdd-kit/`+writable FAIL)
  - **Pattern:** `sdd-kit/templates/scripts/verify-infra.sh`
  - **Gate:** `test -s sdd-kit/templates/scripts/preflight-sdd.sh && bash -n sdd-kit/templates/scripts/preflight-sdd.sh && grep -qE '\-\-host|\-\-repo|\-\-all' sdd-kit/templates/scripts/preflight-sdd.sh && grep -q 'GITNEXUS_SKIP_OPTIONAL_GRAMMARS' sdd-kit/templates/scripts/preflight-sdd.sh && grep -qE '2\.9\.4|C2b' sdd-kit/templates/scripts/preflight-sdd.sh`

- [x] 1.2 Add infra.md Preflight stamp logic (update `preflight-timestamp|ides|warns|mcp` markers; create section if missing) without touching SDD Stack markers
  - **Pattern:** `sdd-kit/templates/scripts/verify-infra.sh`
  - **Gate:** `grep -q 'preflight-timestamp' sdd-kit/templates/scripts/preflight-sdd.sh && grep -q 'Preflight (last run)' sdd-kit/templates/scripts/preflight-sdd.sh`

- [x] 1.3 Copy hub mirror `scripts/preflight-sdd.sh` from the kit template (same content)
  - **Pattern:** `scripts/bootstrap-sdd.sh`
  - **Gate:** `diff -q sdd-kit/templates/scripts/preflight-sdd.sh scripts/preflight-sdd.sh && test -x scripts/preflight-sdd.sh || chmod +x scripts/preflight-sdd.sh`

## 2. Bootstrap and install integration

- [x] 2.1 Wire `sdd-kit/templates/scripts/bootstrap-sdd.sh`: parse `--skip-preflight`; before OpenSpec, resolve preflight script (repo `scripts/` then kit template fallback); run `--all`; abort on FAIL
  - **Pattern:** `sdd-kit/templates/scripts/bootstrap-sdd.sh`
  - **Gate:** `bash -n sdd-kit/templates/scripts/bootstrap-sdd.sh && grep -q 'skip-preflight' sdd-kit/templates/scripts/bootstrap-sdd.sh && grep -q 'preflight-sdd' sdd-kit/templates/scripts/bootstrap-sdd.sh`

- [x] 2.2 Sync hub `scripts/bootstrap-sdd.sh` with the kit template bootstrap preflight wiring
  - **Pattern:** `scripts/bootstrap-sdd.sh`
  - **Gate:** `grep -q 'skip-preflight' scripts/bootstrap-sdd.sh && grep -q 'preflight-sdd' scripts/bootstrap-sdd.sh`

- [x] 2.3 Wire `sdd-kit/install.sh`: add `--skip-preflight`; before template copy, run repo-only preflight (`--repo`) when not skipped; do not invoke `--host`
  - **Pattern:** `sdd-kit/install.sh`
  - **Gate:** `bash -n sdd-kit/install.sh && grep -q 'skip-preflight' sdd-kit/install.sh && grep -qE 'preflight-sdd.*--repo|--repo.*preflight' sdd-kit/install.sh`

## 3. infra.md template and verify boundaries

- [x] 3.1 Add `## Preflight (last run)` section with four markers to `sdd-kit/templates/openspec/infra.md`
  - **Pattern:** `sdd-kit/templates/openspec/infra.md`
  - **Gate:** `grep -q '## Preflight (last run)' sdd-kit/templates/openspec/infra.md && grep -q 'preflight-timestamp' sdd-kit/templates/openspec/infra.md && grep -q 'preflight-ides' sdd-kit/templates/openspec/infra.md && grep -q 'preflight-warns' sdd-kit/templates/openspec/infra.md && grep -q 'preflight-mcp' sdd-kit/templates/openspec/infra.md`

- [x] 3.2 Add the same Preflight section scaffold to hub `openspec/infra.md` (placeholder values)
  - **Pattern:** `openspec/infra.md`
  - **Gate:** `grep -q '## Preflight (last run)' openspec/infra.md && grep -q 'preflight-timestamp' openspec/infra.md`

- [x] 3.3 Update `sdd-kit/templates/scripts/verify-infra.sh` (+ hub `scripts/verify-infra.sh`) header/comment: MUST NOT write `preflight-*` markers; confirm no `replace_between` calls use `preflight-`
  - **Pattern:** `sdd-kit/templates/scripts/verify-infra.sh`
  - **Gate:** `grep -qi 'preflight' sdd-kit/templates/scripts/verify-infra.sh && ! grep -q 'replace_between.*"preflight-' sdd-kit/templates/scripts/verify-infra.sh && grep -qi 'preflight' scripts/verify-infra.sh && ! grep -q 'replace_between.*"preflight-' scripts/verify-infra.sh`

- [x] 3.4 Optional soft WARN in `sdd-kit/verify.sh` when Preflight timestamp is placeholder/`—` (non-blocking; do not increment failure counter)
  - **Pattern:** `sdd-kit/verify.sh`
  - **Gate:** `bash -n sdd-kit/verify.sh && grep -qi 'preflight' sdd-kit/verify.sh`

## 4. MANIFEST and checksums

- [x] 4.1 Add MANIFEST COPY entry for `scripts/preflight-sdd.sh` → `templates/scripts/preflight-sdd.sh` with documentation-only `gate:` string (no eval)
  - **Pattern:** `sdd-kit/MANIFEST.yaml`
  - **Gate:** `grep -A5 'path: scripts/preflight-sdd.sh' sdd-kit/MANIFEST.yaml | grep -q 'templates/scripts/preflight-sdd.sh'`

- [x] 4.2 Run `bash sdd-kit/gen-manifest-checksums.sh` so the new entry has a valid `sha256`
  - **Pattern:** `sdd-kit/gen-manifest-checksums.sh`
  - **Gate:** `bash sdd-kit/gen-manifest-checksums.sh && python3 -c "import re,sys; t=open('sdd-kit/MANIFEST.yaml').read(); m=re.search(r'path: scripts/preflight-sdd.sh.*?sha256: \"([0-9a-f]{64})\"', t, re.S); sys.exit(0 if m else 1)"`

## 5. Guide documentation

- [x] 5.1 Update guide §1 to point operators at `bash scripts/preflight-sdd.sh --all` as the automated prerequisite check
  - **Pattern:** `doc/sistema-sdd-pedro.md`
  - **Gate:** `grep -n 'preflight-sdd' doc/sistema-sdd-pedro.md | head -1 | grep -q .`

- [x] 5.2 Insert phase 0 (Preflight) into §2.0 / §2.1 install order and AI install prompt before OpenSpec
  - **Pattern:** `doc/sistema-sdd-pedro.md`
  - **Gate:** `grep -qiE 'phase 0|fase 0|Preflight' doc/sistema-sdd-pedro.md && grep -q 'preflight-sdd' doc/sistema-sdd-pedro.md`

- [x] 5.3 Add optional soft §2.8 checklist item for Preflight section stamped (non-blocking)
  - **Pattern:** `doc/sistema-sdd-pedro.md`
  - **Gate:** `awk '/### 2.8/,/### 2.9/' doc/sistema-sdd-pedro.md | grep -qi 'preflight'`

## 6. Validation

- [x] 6.1 Run `bash scripts/verify-task-patterns.sh` for this change’s Pattern paths
  - **Gate:** `bash scripts/verify-task-patterns.sh 2>&1 | tail -20`

- [x] 6.2 Validate OpenSpec change strictly
  - **Gate:** `OPENSPEC_TELEMETRY=0 npx --yes @fission-ai/openspec@1.3.1 validate add-sdd-install-preflight --strict`

## 1. verify-infra.sh behaviour

- [x] 1.1 Gate manifest writes on interactivity: write `openspec/infra.md` markers only when stdout is a TTY or `--write` was passed; non-interactive runs without `--write` print a report-only notice naming `--write`, leave the file byte-identical, and exit 0 regardless of check outcomes (interactive runs keep today's authoritative behaviour: writes + non-zero exit on core failures). The only in-repo caller, `sdd-kit/verify.sh:34` (`run_check` inherits stdout, no pipe), passes TTY-ness through — verified 2026-08-05, no caller change needed.
  - **Pattern:** `scripts/verify-infra.sh` — existing marker-update block and exit logic
  - **Invariants:** `openspec/changes/fix-verify-infra-ephemeral-env/specs/sdd-workspace-manifest/spec.md` (Requirement: Infrastructure verification script — write-gating scenarios)
  - **Gate:** `bash scripts/verify-infra.sh </dev/null >/tmp/vi.out 2>&1; test $? -eq 0 && git diff --quiet -- openspec/infra.md && grep -qi 'report-only' /tmp/vi.out && grep -q -- '--write' /tmp/vi.out`
  - **Forbidden:** detecting agents/CI via vendor env vars (`$CI`, platform-specific variables) — TTY and `--write` are the only signals

- [x] 1.2 Switch OpenSpec and GitNexus presence checks to `PATH` lookup (`command -v`), matching the Graphify check and the gap-check section; collect detail only when the binary is present, by direct invocation (`openspec --version`; `gitnexus status` keeping the existing "up-to-date" freshness grep) — never through `npx`
  - **Pattern:** `scripts/verify-infra.sh` — existing Graphify PATH-lookup block as the in-file model
  - **Invariants:** `openspec/changes/fix-verify-infra-ephemeral-env/specs/sdd-workspace-manifest/spec.md` (Requirement: Infrastructure verification script — offline presence scenario)
  - **Gate:** `grep -q 'command -v openspec' scripts/verify-infra.sh && grep -q 'command -v gitnexus' scripts/verify-infra.sh && ! grep -qE 'npx (-y )?(openspec|gitnexus)' scripts/verify-infra.sh`
  - **Forbidden:** `npx -y @fission-ai/openspec@...` as a presence check (downloads on demand — always-green, blinds C2b staleness; rejected in design.md)

- [x] 1.3 Update the "Verify with" column for the OpenSpec and GitNexus rows in `openspec/infra.md` **and** `sdd-kit/templates/openspec/infra.md` from `npx openspec list` / `npx gitnexus status` to direct binary invocations (`openspec list` / `gitnexus status`), so the column matches what the check now measures
  - **Pattern:** `openspec/infra.md` (SDD Stack table), `sdd-kit/templates/openspec/infra.md` (same table)
  - **Gate:** `! grep -q 'npx openspec' openspec/infra.md && ! grep -q 'npx gitnexus' openspec/infra.md && ! grep -q 'npx openspec' sdd-kit/templates/openspec/infra.md && ! grep -q 'npx gitnexus' sdd-kit/templates/openspec/infra.md`
  - **Forbidden:** touching the Preflight section markers (owned by `preflight-sdd.sh` per its header contract)

## 2. Kit release 1.8.2

- [x] 2.1 Mirror the updated script to `sdd-kit/templates/scripts/verify-infra.sh` (byte-identical to root); bump `sdd-kit/MANIFEST.yaml` `version` and `guide_version` to `"1.8.2"`; bump guide header and add a changelog §14 entry referencing this change-id; update `openspec/project.md` cross-references to v1.8.2; run `bash sdd-kit/gen-manifest-checksums.sh` (template content changed — checksums MUST change for verify-infra.sh and the infra.md template, and only those)
  - **Pattern:** `sdd-kit/MANIFEST.yaml` (version fields), `doc/byebyevibe-guide.md` (§14 changelog entry style of 1.8.1), `openspec/project.md` (Cross-references)
  - **Invariants:** `openspec/specs/sdd-install-kit/spec.md` (Requirement: Version alignment on release)
  - **Gate:** `diff -q scripts/verify-infra.sh sdd-kit/templates/scripts/verify-infra.sh && grep -qE '^version: "1\.8\.2"' sdd-kit/MANIFEST.yaml && grep -qE '^guide_version: "1\.8\.2"' sdd-kit/MANIFEST.yaml && grep -q '1.8.2' doc/byebyevibe-guide.md && grep -q '1.8.2' openspec/project.md && grep -q 'fix-verify-infra-ephemeral-env' doc/byebyevibe-guide.md`
  - **Forbidden:** bumping the version without the changelog entry, or regenerating checksums before the template mirror is byte-identical

- [x] 2.2 Final consistency pass: strict OpenSpec validation, task-pattern verification, and full kit verification — which, with 1.1 in place, must now pass in this non-interactive environment without dirtying the working tree
  - **Gate:** `npx --yes @fission-ai/openspec@1.3.1 validate --all --strict && bash scripts/verify-task-patterns.sh && bash sdd-kit/verify.sh && git diff --quiet -- openspec/infra.md`

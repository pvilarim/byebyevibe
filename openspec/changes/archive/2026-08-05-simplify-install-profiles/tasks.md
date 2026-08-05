# Tasks — simplify-install-profiles

## 1. Kit contract (D1, D3, D5)

- [x] 1.1 Update `sdd-kit/MANIFEST.yaml`: entry `scripts/verify-task-patterns.sh` gains APP in `profiles:` (→ `[APP, DOCS_SPECS, HYBRID]`); bump `version:` and `guide_version:` to `1.9.0`
  - **Pattern:** `sdd-kit/MANIFEST.yaml` (existing entry style, e.g. `scripts/sdd-metrics.sh` with all-profiles list)
  - **Gate:** `grep -A6 'path: scripts/verify-task-patterns.sh' sdd-kit/MANIFEST.yaml | grep -q 'profiles: \[APP, DOCS_SPECS, HYBRID\]' && grep -q '^version: "1.9.0"' sdd-kit/MANIFEST.yaml`
  - **Forbidden:** removing the HYBRID token from any `profiles:` list; touching other entries' `profiles:`

- [x] 1.2 Normalize HYBRID → APP at argument parsing in `sdd-kit/install.sh`, `sdd-kit/upgrade.sh`, and `scripts/bootstrap-sdd.sh` (+ template mirror): accept `--profile HYBRID`, print one deprecation notice naming kit 1.9.0, proceed as APP; invalid values still abort naming allowed values
  - **Pattern:** `sdd-kit/install.sh` (existing profile-validation case block)
  - **Invariants:** `openspec/changes/simplify-install-profiles/specs/sdd-install-kit/spec.md` (alias accepted, never rejected; invalid values still abort)
  - **Gate:** `grep -qi 'deprecat' sdd-kit/install.sh && grep -qi 'deprecat' sdd-kit/upgrade.sh && grep -qi 'deprecat' scripts/bootstrap-sdd.sh && diff -q scripts/bootstrap-sdd.sh sdd-kit/templates/scripts/bootstrap-sdd.sh`
  - **Forbidden:** rejecting `--profile HYBRID` with a non-zero exit

- [x] 1.3 Remove the ambiguous-HYBRID warning from `scripts/bootstrap-sdd.sh` and the HYBRID profile hint from `scripts/preflight-sdd.sh`; mirror both into `sdd-kit/templates/scripts/`
  - **Pattern:** `scripts/preflight-sdd.sh` (existing WARN emission style)
  - **Gate:** `diff -q scripts/bootstrap-sdd.sh sdd-kit/templates/scripts/bootstrap-sdd.sh && diff -q scripts/preflight-sdd.sh sdd-kit/templates/scripts/preflight-sdd.sh && ! grep -qi 'may be HYBRID' scripts/bootstrap-sdd.sh`
  - **Forbidden:** turning the retired hint into a FAIL; changing any other preflight gate

## 2. Verifier behavior (D1, D2)

- [x] 2.1 Add profile-aware exit semantics to `scripts/verify-task-patterns.sh` (+ template mirror): DOCS_SPECS unchanged (fail-closed); APP/UNKNOWN report-only — broken local `Pattern:` paths print WARN, cross-repo keeps SKIP, exit 0 with a summary naming the mode and the future-enforcement note
  - **Pattern:** `sdd-kit/templates/scripts/verify-task-patterns.sh` (existing FAILURES/WARNINGS counters and summary block)
  - **Invariants:** `openspec/changes/simplify-install-profiles/specs/sdd-post-install-verification/spec.md` (DOCS_SPECS exit code unchanged)
  - **Gate:** `grep -qi 'report-only' scripts/verify-task-patterns.sh && diff -q scripts/verify-task-patterns.sh sdd-kit/templates/scripts/verify-task-patterns.sh && bash scripts/verify-task-patterns.sh`
  - **Forbidden:** softening DOCS_SPECS exit semantics; changing the `Pattern:` extraction format

- [x] 2.2 Harden profile detection in the same script: (1) profile marker in `openspec/project.md`; (2) AGENTS.md markers `12.2b` → DOCS_SPECS / `12.2a` → APP; (3) current greps as legacy fallback; UNKNOWN → report-only
  - **Pattern:** `sdd-kit/templates/scripts/verify-task-patterns.sh` (existing PROFILE detection block, lines 12–17)
  - **Gate:** `grep -q '12.2b' scripts/verify-task-patterns.sh && grep -q 'openspec/project.md' scripts/verify-task-patterns.sh && diff -q scripts/verify-task-patterns.sh sdd-kit/templates/scripts/verify-task-patterns.sh`
  - **Forbidden:** dropping the legacy fallback greps (pre-1.9.0 installs)

- [x] 2.3 Update the `sdd-gates.yml` SKIP message (hub + template) — the script is now expected in all profiles, so the message no longer names DOCS_SPECS/HYBRID
  - **Pattern:** `sdd-kit/templates/.github/workflows/sdd-gates.yml` (existing task-patterns step, lines 46–49)
  - **Gate:** `! grep -q 'DOCS_SPECS/HYBRID' .github/workflows/sdd-gates.yml && diff -q .github/workflows/sdd-gates.yml sdd-kit/templates/.github/workflows/sdd-gates.yml`
  - **Forbidden:** adding `continue-on-error` to the step; changing workflow topology

## 3. Canonical lay copy and docs (D4)

- [x] 3.1 Rewrite the profile block in `doc/byebyevibe-guide.md` §1.6: two active profiles framed by "Will this repository hold application code?"; the three mandatory statements (complete framework in every profile; hub docs/specs are ByeByeVibe's own development history — never copied, never needed; profile question independent of the language axes); HYBRID deprecation note
  - **Pattern:** `doc/byebyevibe-guide.md` (§1.6 existing table + prose style)
  - **Invariants:** `openspec/changes/simplify-install-profiles/specs/sdd-install-narrative/spec.md` (three statements mandatory; single-sourced in §1.6)
  - **Gate:** `grep -qi 'application code' doc/byebyevibe-guide.md && grep -qi 'development history' doc/byebyevibe-guide.md && grep -qi 'HYBRID.*deprecated\|deprecated.*HYBRID' doc/byebyevibe-guide.md`
  - **Forbidden:** duplicating the full copy block in the kit README (≤3-sentence summary + link only)

- [x] 3.2 Update `sdd-kit/README.md`: profiles table reduced to APP / DOCS_SPECS with a deprecation line for HYBRID; scenarios/quick-commands mentions aligned; ≤3-sentence lay summary linking to guide §1.6
  - **Pattern:** `sdd-kit/README.md` (existing Profiles table)
  - **Gate:** `grep -qi 'deprecated' sdd-kit/README.md && grep -q '§1.6' sdd-kit/README.md`
  - **Forbidden:** exceeding the three-sentence summary rule from `clarify-install-scope-ux`

- [x] 3.3 Add en + pt-BR runtime strings for the profile decision to `sdd-kit/install.sh` usage/help output and the agent-facing instruction (interactive installs derive dialog options from the §1.6 canonical copy) to the guide's AI-assisted install prompt section
  - **Pattern:** `sdd-kit/install.sh` (existing usage help and pt-BR/en runtime string pattern)
  - **Gate:** `grep -qi 'application code' sdd-kit/install.sh && grep -qi 'código de aplicação' sdd-kit/install.sh`
  - **Forbidden:** conflating profile strings with the language-axes prompts

## 4. Integrity and release alignment (D5)

- [x] 4.1 Regenerate MANIFEST checksums for every touched template (`gen-manifest-checksums.sh`); add the 1.9.0 changelog entry to guide §14; align guide header and `openspec/project.md` cross-references
  - **Pattern:** `sdd-kit/MANIFEST.yaml` (sha256 field format)
  - **Gate:** `bash sdd-kit/verify.sh`
  - **Forbidden:** hand-editing sha256 values

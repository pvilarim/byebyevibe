# Tasks — clarify-install-scope-ux

## 1. Canonical scope model in guide §1.6 (D1, D2)

- [ ] 1.1 Add the install-scope table to `doc/byebyevibe-guide.md` §1.6 (rows: machine-once / repo-copied / repo-generated with example artifacts per row), the hub→destination flow paragraph with the command `bash <hub>/scripts/bootstrap-sdd.sh <target-repo> --profile <PROFILE>`, and a sentence stating per-project reinstall covers only the repo-copied payload (machine CLIs are not reinstalled per project)
  - **Pattern:** `doc/byebyevibe-guide.md` (§1.6 existing four-layer table style)
  - **Invariants:** `openspec/changes/clarify-install-scope-ux/specs/sdd-install-kit/spec.md` (scope table single-sourced in §1.6; ≤3-sentence summaries elsewhere)
  - **Gate:** `grep -q 'Install scope' doc/byebyevibe-guide.md && grep -q 'bootstrap-sdd.sh <target-repo>' doc/byebyevibe-guide.md && grep -qiE 'not reinstalled per project|only the repo-copied payload' doc/byebyevibe-guide.md`
  - **Forbidden:** duplicating the full scope table in any other file

## 2. Bootstrap behavior + banners (D2, D3, D4) — hub and template in lockstep

- [ ] 2.1 Add hub-mode resolution to `scripts/bootstrap-sdd.sh`: resolve `SOURCE_ROOT` from the script's own path; fall back to `$SOURCE_ROOT` for `preflight-sdd.sh` and `sdd-kit/install.sh --repo <target>` when the target lacks them (target-local copies win); add a source-kit-root flag (`--kit-root`) to `scripts/preflight-sdd.sh` so the repo gate accepts hub-resolved kit presence; mirror both scripts into `sdd-kit/templates/scripts/`
  - **Pattern:** `sdd-kit/templates/scripts/bootstrap-sdd.sh` (existing preflight lookup and kit phase blocks)
  - **Invariants:** `openspec/changes/clarify-install-scope-ux/specs/sdd-install-preflight/spec.md` (gate still FAILs when neither target nor source has a kit)
  - **Gate:** `grep -q 'SOURCE_ROOT' scripts/bootstrap-sdd.sh && grep -q -- '--kit-root' scripts/preflight-sdd.sh && diff -q scripts/bootstrap-sdd.sh sdd-kit/templates/scripts/bootstrap-sdd.sh && diff -q scripts/preflight-sdd.sh sdd-kit/templates/scripts/preflight-sdd.sh`
  - **Forbidden:** changing behavior when the target already carries scripts/ and sdd-kit/ (consumer self-bootstrap)

- [ ] 2.2 Add the idempotent package-install guard: wrap only the package-manager commands (npm install -g for openspec/gitnexus; uv installer + uv tool install for graphify) behind command -v checks; print an always-visible skip notice with detected version; WARN against MANIFEST min_openspec when the detected openspec is older (never abort); keep `openspec init`, `gitnexus setup`, `gitnexus analyze`, `graphify install`, `graphify hook install`, `graphify update .` unconditional; mirror into the template copy
  - **Pattern:** `sdd-kit/templates/scripts/bootstrap-sdd.sh` (existing phase structure: banner → install → init)
  - **Invariants:** `openspec/changes/clarify-install-scope-ux/specs/sdd-install-kit/spec.md` (guard covers package installs only; skip notices print in quiet mode)
  - **Gate:** `grep -q 'already installed' scripts/bootstrap-sdd.sh && grep -qE 'command -v ("?\$(cli|tool)"?|openspec)' scripts/bootstrap-sdd.sh && grep -q 'min_openspec' scripts/bootstrap-sdd.sh && diff -q scripts/bootstrap-sdd.sh sdd-kit/templates/scripts/bootstrap-sdd.sh`
  - **Forbidden:** skipping `openspec init`, `gitnexus setup`, `gitnexus analyze`, `graphify install`, `graphify hook install`, or `graphify update .` when a CLI is already present; gating skip notices behind TTY/quiet checks

- [ ] 2.3 Add the third `Scope:` line to the four S-layer banners in both language sets (en: "installs once on your machine — future projects reuse it" for the three CLIs; "copied into this repo — each project gets its own" for sdd-kit; pt-BR equivalents), in `scripts/bootstrap-sdd.sh` and mirrored in `sdd-kit/templates/scripts/bootstrap-sdd.sh`
  - **Pattern:** `sdd-kit/templates/scripts/bootstrap-sdd.sh` (banner function case block, en + pt-BR)
  - **Invariants:** `openspec/changes/clarify-install-scope-ux/specs/sdd-install-narrative/spec.md` (Scope line per tool, both languages; locked D3 slogans unchanged)
  - **Gate:** `test "$(grep -c 'Scope:' scripts/bootstrap-sdd.sh)" -ge 4 && test "$(grep -c 'Escopo:' scripts/bootstrap-sdd.sh)" -ge 4 && diff -q scripts/bootstrap-sdd.sh sdd-kit/templates/scripts/bootstrap-sdd.sh`
  - **Forbidden:** altering the locked What / Without-it archived-D3 slogans

- [ ] 2.4 Add the didactic completion message (TTY-only, suppressed by `--quiet`) printed after the existing unconditional "Done. Manual steps (required)" block, en + pt-BR: names `openspec/`, `graphify-out/`, `.gitnexus/` as this project's own state and shows the next-project command with the resolved source root as origin (hub-clone pointer when the source root has no sdd-kit); mirror into the template copy
  - **Pattern:** `sdd-kit/templates/scripts/bootstrap-sdd.sh` (existing didactic-output gating)
  - **Invariants:** `openspec/changes/clarify-install-scope-ux/specs/sdd-install-narrative/spec.md` (manual-steps block stays unconditional and unchanged)
  - **Gate:** `grep -q 'graphify-out/' scripts/bootstrap-sdd.sh && grep -q '\.gitnexus/' scripts/bootstrap-sdd.sh && grep -qi 'next project' scripts/bootstrap-sdd.sh && grep -q 'Done. Manual steps (required):' scripts/bootstrap-sdd.sh && diff -q scripts/bootstrap-sdd.sh sdd-kit/templates/scripts/bootstrap-sdd.sh`
  - **Forbidden:** gating or editing the "Done. Manual steps (required)" block

## 3. First-contact and recall surfaces (D1, D5)

- [ ] 3.1 Add the `Scope` column to the scenarios table in `sdd-kit/README.md` with enumerated row values (C1 = machine + repo; C2b = machine; C2, C3, C1-UI, G2, G4 = repo) and the one-line first-contact note ("CLIs install once per machine; each repo receives its own payload copy") linking to guide §1.6
  - **Pattern:** `sdd-kit/README.md` (existing Scenarios table)
  - **Gate:** `grep -qE '\| *Scope' sdd-kit/README.md && grep -qi 'once per machine' sdd-kit/README.md && grep -q 'machine + repo' sdd-kit/README.md && test "$(grep -c '§1.6' sdd-kit/README.md)" -ge 2`
  - **Forbidden:** reproducing the full §1.6 scope table in the README

- [ ] 3.2 Add the 2–3 sentence machine-vs-repo scope passage inside §0 of `doc/sdd-operator-day1.md` (link to guide §1.6; no new numbered section, no renumbering, no skill edits); mirror into `sdd-kit/templates/doc/sdd-operator-day1.md`
  - **Pattern:** `doc/sdd-operator-day1.md` (§0 existing prose style)
  - **Invariants:** `openspec/changes/clarify-install-scope-ux/specs/sdd-operator-onboarding/spec.md` (locked §0–§9 spine)
  - **Gate:** `grep -qi 'once per machine' doc/sdd-operator-day1.md && grep -q '§1.6' doc/sdd-operator-day1.md && test "$(grep -c '^## ' doc/sdd-operator-day1.md)" -eq 10 && diff -q doc/sdd-operator-day1.md sdd-kit/templates/doc/sdd-operator-day1.md && test -z "$(git status --porcelain -- .claude/skills/openspec-help .cursor/skills/openspec-help)"`
  - **Forbidden:** editing `.claude/skills/openspec-help/` or `.cursor/skills/openspec-help/`

## 4. Kit integrity and release alignment (D6)

- [ ] 4.1 Run `bash sdd-kit/gen-manifest-checksums.sh`; bump `sdd-kit/MANIFEST.yaml` `version` and `guide_version` to 1.8.0; update the guide header version (fixing the pre-existing 1.6.1 header vs 1.7.0 MANIFEST mismatch), add the changelog §14 entry referencing this change-id, and align `openspec/project.md` cross-references. Note: `sdd-kit/verify.sh` re-stamps `openspec/infra.md` timestamps via verify-infra — run it last and commit the stamp
  - **Pattern:** `sdd-kit/MANIFEST.yaml` (version + sha256 fields)
  - **Gate:** `grep -q 'clarify-install-scope-ux' doc/byebyevibe-guide.md && grep -qE '^version: "1\.8\.0"' sdd-kit/MANIFEST.yaml && grep -q '1.8.0' doc/byebyevibe-guide.md && grep -q '1.8.0' openspec/project.md && bash sdd-kit/verify.sh`
  - **Forbidden:** regenerating checksums before the hub↔template mirrors (tasks 2.x, 3.2) are in lockstep

- [ ] 4.2 Final consistency pass: completion-detecting greps plus strict validation and task-pattern verification
  - **Gate:** `grep -q 'Install scope' doc/byebyevibe-guide.md && grep -qE '^version: "1\.8\.0"' sdd-kit/MANIFEST.yaml && npx --yes @fission-ai/openspec@1.3.1 validate --all --strict && bash scripts/verify-task-patterns.sh`

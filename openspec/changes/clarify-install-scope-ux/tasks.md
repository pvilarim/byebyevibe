# Tasks — clarify-install-scope-ux

## 1. Canonical scope model in guide §1.6 (D1, D2)

- [ ] 1.1 Add the install-scope table to `doc/byebyevibe-guide.md` §1.6 (rows: machine-once / repo-copied / repo-generated with example artifacts per row), the hub→destination flow paragraph with the command `bash <hub>/scripts/bootstrap-sdd.sh <target-repo> --profile <PROFILE>`, and the sentence stating per-project reinstall covers only the repo-copied payload
  - **Pattern:** `doc/byebyevibe-guide.md` (§1.6 existing four-layer table style)
  - **Invariants:** `openspec/changes/clarify-install-scope-ux/specs/sdd-install-kit/spec.md` (scope table single-sourced in §1.6)
  - **Gate:** `grep -q 'Install scope' doc/byebyevibe-guide.md && grep -q 'bootstrap-sdd.sh <target-repo>' doc/byebyevibe-guide.md && grep -qi 'never reinstalled per project' doc/byebyevibe-guide.md`
  - **Forbidden:** duplicating the full scope table in any other file

## 2. Bootstrap behavior + banners (D3, D4) — hub and template in lockstep

- [ ] 2.1 Add the idempotent CLI guard to `scripts/bootstrap-sdd.sh`: `command -v` check per machine-level CLI (openspec, gitnexus, graphify) that prints `already installed — skipping` (with version when cheap) and bypasses only the global install, never the per-repo steps (`openspec init`, `gitnexus analyze`, `graphify update .`); mirror the identical edit into `sdd-kit/templates/scripts/bootstrap-sdd.sh`
  - **Pattern:** `sdd-kit/templates/scripts/bootstrap-sdd.sh` (existing phase structure: banner → install → init)
  - **Gate:** `grep -q 'already installed' scripts/bootstrap-sdd.sh && grep -q 'command -v openspec' scripts/bootstrap-sdd.sh && diff -q scripts/bootstrap-sdd.sh sdd-kit/templates/scripts/bootstrap-sdd.sh`
  - **Forbidden:** skipping `openspec init`, `gitnexus analyze`, or `graphify update .` when a CLI is already present

- [ ] 2.2 Add the third `Scope:` line to the four S-layer banners in both language sets (en: "installs once on your machine — future projects reuse it" for the three CLIs; "copied into this repo — each project gets its own" for sdd-kit; pt-BR equivalents), in `scripts/bootstrap-sdd.sh` and mirrored in `sdd-kit/templates/scripts/bootstrap-sdd.sh`
  - **Pattern:** `sdd-kit/templates/scripts/bootstrap-sdd.sh` (banner function case block, en + pt-BR)
  - **Invariants:** `openspec/changes/clarify-install-scope-ux/specs/sdd-install-narrative/spec.md` (Scope line per tool, both languages)
  - **Gate:** `test "$(grep -c 'Scope:' scripts/bootstrap-sdd.sh)" -ge 4 && test "$(grep -c 'Escopo:' scripts/bootstrap-sdd.sh)" -ge 4 && diff -q scripts/bootstrap-sdd.sh sdd-kit/templates/scripts/bootstrap-sdd.sh`
  - **Forbidden:** altering the locked What / Without-it D3 slogans

- [ ] 2.3 Add the completion message at the end of a successful bootstrap run (didactic output rules: TTY only, suppressed by `--quiet`), en + pt-BR: names `openspec/`, `graphify-out/`, `.gitnexus/` as this project's own state and shows the hub→destination command for the next project; mirror into the template copy
  - **Pattern:** `sdd-kit/templates/scripts/bootstrap-sdd.sh` (existing didactic-output gating)
  - **Gate:** `grep -q 'graphify-out/' scripts/bootstrap-sdd.sh && grep -q '.gitnexus/' scripts/bootstrap-sdd.sh && grep -qi 'next project' scripts/bootstrap-sdd.sh && diff -q scripts/bootstrap-sdd.sh sdd-kit/templates/scripts/bootstrap-sdd.sh`

## 3. First-contact and recall surfaces (D1, D5)

- [ ] 3.1 Add the `Scope` column (`machine` / `repo`) to the scenarios table in `sdd-kit/README.md` and the one-line first-contact note ("CLIs install once per machine; each repo receives its own payload copy") linking to guide §1.6
  - **Pattern:** `sdd-kit/README.md` (existing Scenarios table)
  - **Gate:** `grep -q 'Scope' sdd-kit/README.md && grep -qi 'once per machine' sdd-kit/README.md && grep -q '§1.6' sdd-kit/README.md`
  - **Forbidden:** reproducing the full §1.6 scope table in the README

- [ ] 3.2 Add the 2–3 sentence machine-vs-repo scope passage inside §0 of `doc/sdd-operator-day1.md` (link to guide §1.6; no new numbered section, no renumbering, no skill edits); mirror into `sdd-kit/templates/doc/sdd-operator-day1.md`
  - **Pattern:** `doc/sdd-operator-day1.md` (§0 "Layers" existing prose style)
  - **Invariants:** `openspec/changes/clarify-install-scope-ux/specs/sdd-operator-onboarding/spec.md` (locked §0–§9 spine)
  - **Gate:** `grep -qi 'once per machine' doc/sdd-operator-day1.md && grep -q '§1.6' doc/sdd-operator-day1.md && test "$(grep -c '^## ' doc/sdd-operator-day1.md)" -eq 10 && git diff --quiet -- .claude/skills/openspec-help .cursor/skills/openspec-help`
  - **Forbidden:** editing `.claude/skills/openspec-help/` or `.cursor/skills/openspec-help/`

## 4. Kit integrity and release alignment (D6)

- [ ] 4.1 Run `bash sdd-kit/gen-manifest-checksums.sh`, bump `sdd-kit/MANIFEST.yaml` `version` (minor, from 1.7.0), and add the guide changelog §14 entry referencing this change-id
  - **Pattern:** `sdd-kit/MANIFEST.yaml` (version + sha256 fields)
  - **Gate:** `bash sdd-kit/verify.sh && grep -q 'clarify-install-scope-ux' doc/byebyevibe-guide.md`

- [ ] 4.2 Final consistency pass: strict validation plus task-pattern verification
  - **Gate:** `npx --yes @fission-ai/openspec@1.3.1 validate --all --strict && bash scripts/verify-task-patterns.sh`

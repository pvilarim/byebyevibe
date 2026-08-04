## 1. Minimal footprint + lightweight fetch recipe in the guide

- [ ] 1.1 Add the minimal install-fetch footprint statement to `doc/byebyevibe-guide.md` §1.6 (or an adjacent subsection immediately after it): name the three required paths (`sdd-kit/`, `scripts/bootstrap-sdd.sh`, `scripts/preflight-sdd.sh`) and state that no other repository path (hub-only `doc/`, hub-only `openspec/`, root `.cursor/`/`.claude/`) is read by `install.sh` or the bootstrap/preflight scripts during C1
  - **Pattern:** `doc/byebyevibe-guide.md` (§1.6 existing install-scope table style)
  - **Invariants:** `openspec/changes/add-lightweight-install-fetch/specs/sdd-install-kit/spec.md` (Requirement: Guide documents minimal install-fetch footprint)
  - **Gate:** `grep -q 'scripts/bootstrap-sdd.sh' doc/byebyevibe-guide.md && grep -q 'scripts/preflight-sdd.sh' doc/byebyevibe-guide.md && grep -qiE 'minimal install-fetch footprint|minimal fetch footprint' doc/byebyevibe-guide.md`
  - **Forbidden:** stating `sdd-kit/` alone is sufficient (the two root scripts are required too — see design.md decision)

- [ ] 1.2 Add a new subsection titled exactly `### 2.0a Lightweight install-fetch (no full clone)` documenting the git-based lightweight fetch recipe (partial clone with `--filter=blob:none`, non-cone `sparse-checkout set --no-cone` on exactly the three paths, copy into the target repo root, discard the temporary clone). Before the commands, include a short plain-language (S-layer) explanation of what the recipe does and why — new terms (`sparse-checkout`, `--filter=blob:none`) MUST NOT appear without a one-line analogy/scenario first, per the existing `sdd-install-narrative` "Dual S-T install narrative tone" requirement. State explicitly that this recipe applies only to genuine C1 greenfield installs (`sdd-kit/` absent), not C2/C3. Do NOT suggest `bash scripts/bootstrap-sdd.sh --dry-run` anywhere — that script has no `--dry-run` flag (only `sdd-kit/install.sh` does); if a dry preview is wanted, point to `sdd-kit/install.sh --dry-run` instead
  - **Pattern:** `doc/byebyevibe-guide.md` (§2.0b existing quickstart block style; §2.2–§2.4 for the S-before-commands tone)
  - **Invariants:** `openspec/changes/add-lightweight-install-fetch/specs/sdd-install-kit/spec.md` (Requirement: Guide documents a lightweight no-full-clone fetch recipe); `openspec/specs/sdd-install-narrative/spec.md` (Requirement: Dual S-T install narrative tone)
  - **Gate:** `sec="$(sed -n '/^### 2\.0a Lightweight install-fetch/,/^### /p' doc/byebyevibe-guide.md)"; grep -q 'sparse-checkout' <<<"$sec" && grep -q -- '--filter=blob:none' <<<"$sec" && grep -qiE 'greenfield[- ]only|only.{0,20}greenfield' <<<"$sec"`
  - **Forbidden:** presenting the recipe as applicable to C2 (upgrade) or C3 (spec propagation); suggesting a `--dry-run` flag on `bootstrap-sdd.sh`; introducing `sparse-checkout` or `--filter=blob:none` with no preceding plain-language sentence

- [ ] 1.3 Update the §2.0 AI-assisted installation prompt so it names the lightweight fetch recipe (§2.0a) before mentioning a full hub clone, reserving the full clone for operators who explicitly want the persistent multi-project hub→destination workflow (link to §1.6)
  - **Pattern:** `doc/byebyevibe-guide.md` (§2.0 existing prompt block)
  - **Invariants:** `openspec/changes/add-lightweight-install-fetch/specs/sdd-install-kit/spec.md` (Requirement: AI-assisted install prompt defaults to lightweight fetch)
  - **Gate:** `sec="$(sed -n '/^### 2\.0 AI-assisted installation (prompt)/,/^### /p' doc/byebyevibe-guide.md)"; grep -qiE 'lightweight|sparse-checkout' <<<"$sec"`
  - **Forbidden:** removing the existing hub-clone / `bootstrap-sdd.sh` instructions for the multi-project reuse case

- [ ] 1.4 Soften the sentence in `doc/sdd-operator-day1.md` §0 that presents "one command from the hub clone" as the sole greenfield install method (it would otherwise contradict the new §2.0a default), so it also names the lightweight fetch as an alternative for a first, no-persistent-clone install. Do NOT add a new section, do NOT renumber existing `## ` sections, do NOT touch `.claude/skills/openspec-help` or `.cursor/skills/openspec-help`. Mirror the edit into `sdd-kit/templates/doc/sdd-operator-day1.md`
  - **Pattern:** `doc/sdd-operator-day1.md` (§0 existing prose)
  - **Gate:** `grep -qi 'lightweight' doc/sdd-operator-day1.md && test "$(grep -c '^## ' doc/sdd-operator-day1.md)" -eq 10 && diff -q doc/sdd-operator-day1.md sdd-kit/templates/doc/sdd-operator-day1.md && test -z "$(git status --porcelain -- .claude/skills/openspec-help .cursor/skills/openspec-help)"`
  - **Forbidden:** adding a new numbered section; renumbering §0–§9; editing the `openspec-help` skill files

## 2. First-contact pointer (no duplication)

- [ ] 2.1 Add a one-line pointer (no more than 2 lines) in `sdd-kit/README.md` to the new guide subsection §2.0a, without restating the three-path footprint list or the fetch recipe commands themselves
  - **Pattern:** `sdd-kit/README.md` (existing "Discovery / hero" pointer line)
  - **Gate:** `grep -qi 'lightweight' sdd-kit/README.md && ! grep -q 'sparse-checkout' sdd-kit/README.md`
  - **Forbidden:** reproducing the fetch recipe, the footprint table, or the three explicit paths in `sdd-kit/README.md`

## 3. Version and changelog alignment

- [ ] 3.1 Bump guide header version 1.8.0 → 1.8.1; add a changelog §14 entry referencing this change-id (`add-lightweight-install-fetch`); bump `sdd-kit/MANIFEST.yaml` `version` and `guide_version` to `"1.8.1"`; update `openspec/project.md` Cross-references to v1.8.1; run `bash sdd-kit/gen-manifest-checksums.sh` (no template content changed, so checksums are expected to stay the same — this confirms it)
  - **Pattern:** `sdd-kit/MANIFEST.yaml` (version / guide_version fields), `openspec/project.md` (Cross-references line referencing guide version)
  - **Invariants:** `openspec/specs/sdd-install-kit/spec.md` (Requirement: Version alignment on release)
  - **Gate:** `grep -qE '^version: "1\.8\.1"' sdd-kit/MANIFEST.yaml && grep -qE '^guide_version: "1\.8\.1"' sdd-kit/MANIFEST.yaml && grep -q '1.8.1' doc/byebyevibe-guide.md && grep -q '1.8.1' openspec/project.md && grep -q 'add-lightweight-install-fetch' doc/byebyevibe-guide.md`
  - **Forbidden:** bumping `MANIFEST.yaml` version without a matching guide header entry and changelog line

- [ ] 3.2 Final consistency pass: strict OpenSpec validation, task-pattern verification, and kit verification
  - **Gate:** `npx --yes @fission-ai/openspec@1.3.1 validate --all --strict && bash scripts/verify-task-patterns.sh && bash sdd-kit/verify.sh`

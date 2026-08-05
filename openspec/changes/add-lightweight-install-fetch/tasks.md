## 1. Minimal footprint + lightweight fetch recipe in the guide

- [x] 1.1 Add the minimal install-fetch footprint statement to `doc/byebyevibe-guide.md` §1.6 (or an adjacent subsection immediately after it): name the three required paths (`sdd-kit/`, `scripts/bootstrap-sdd.sh`, `scripts/preflight-sdd.sh`) and state that no other repository path (hub-only `doc/`, hub-only `openspec/`, root `.cursor/`/`.claude/`) is read by `install.sh` or the bootstrap/preflight scripts during C1
  - **Pattern:** `doc/byebyevibe-guide.md` (§1.6 existing install-scope table style)
  - **Invariants:** `openspec/changes/add-lightweight-install-fetch/specs/sdd-install-kit/spec.md` (Requirement: Guide documents minimal install-fetch footprint)
  - **Gate:** `grep -q 'scripts/bootstrap-sdd.sh' doc/byebyevibe-guide.md && grep -q 'scripts/preflight-sdd.sh' doc/byebyevibe-guide.md && grep -qiE 'minimal install-fetch footprint|minimal fetch footprint' doc/byebyevibe-guide.md`
  - **Forbidden:** stating `sdd-kit/` alone is sufficient (the two root scripts are required too — see design.md decision)

- [x] 1.2 Add a new subsection documenting the git-based lightweight fetch recipe (partial clone with `--filter=blob:none`, non-cone `sparse-checkout set --no-cone` on exactly the three paths, copy into the target repo root, discard the temporary clone), explicitly scoped to genuine C1 greenfield installs only
  - **Pattern:** `doc/byebyevibe-guide.md` (§2.0b existing quickstart block style)
  - **Invariants:** `openspec/changes/add-lightweight-install-fetch/specs/sdd-install-kit/spec.md` (Requirement: Guide documents a lightweight no-full-clone fetch recipe)
  - **Gate:** `grep -q 'sparse-checkout' doc/byebyevibe-guide.md && grep -q -- '--filter=blob:none' doc/byebyevibe-guide.md && grep -qi 'greenfield' doc/byebyevibe-guide.md`
  - **Forbidden:** presenting the recipe as applicable to C2 (upgrade) or C3 (spec propagation)

- [x] 1.3 Update the §2.0 AI-assisted installation prompt so it names the lightweight fetch recipe before mentioning a full hub clone, reserving the full clone for operators who explicitly want the persistent multi-project hub→destination workflow (link to §1.6)
  - **Pattern:** `doc/byebyevibe-guide.md` (§2.0 existing prompt block)
  - **Invariants:** `openspec/changes/add-lightweight-install-fetch/specs/sdd-install-kit/spec.md` (Requirement: AI-assisted install prompt defaults to lightweight fetch)
  - **Gate:** `sed -n '/^### 2.0 /,/^### 2.1 /p' doc/byebyevibe-guide.md | grep -qiE 'lightweight|sparse-checkout'`
  - **Forbidden:** removing the existing hub-clone / `bootstrap-sdd.sh` instructions for the multi-project reuse case

## 2. First-contact pointer (no duplication)

- [x] 2.1 Add a one-line pointer in `sdd-kit/README.md` to the new guide subsection, without duplicating the footprint list or the fetch recipe itself
  - **Pattern:** `sdd-kit/README.md` (existing "Discovery / hero" pointer line)
  - **Gate:** `grep -qi 'lightweight' sdd-kit/README.md && ! grep -q 'sparse-checkout' sdd-kit/README.md`
  - **Forbidden:** reproducing the fetch recipe or the footprint table in `sdd-kit/README.md`

## 3. Version and changelog alignment

- [x] 3.1 Bump guide header version 1.8.0 → 1.8.1; add a changelog §14 entry referencing this change-id (`add-lightweight-install-fetch`); bump `sdd-kit/MANIFEST.yaml` `version` and `guide_version` to `"1.8.1"`; update `openspec/project.md` Cross-references to v1.8.1; run `bash sdd-kit/gen-manifest-checksums.sh` (no template content changed, so checksums are expected to stay the same — this confirms it)
  - **Pattern:** `sdd-kit/MANIFEST.yaml` (version / guide_version fields), `openspec/project.md` (Cross-references line referencing guide version)
  - **Invariants:** `openspec/specs/sdd-install-kit/spec.md` (Requirement: Version alignment on release)
  - **Gate:** `grep -qE '^version: "1\.8\.1"' sdd-kit/MANIFEST.yaml && grep -qE '^guide_version: "1\.8\.1"' sdd-kit/MANIFEST.yaml && grep -q '1.8.1' doc/byebyevibe-guide.md && grep -q '1.8.1' openspec/project.md && grep -q 'add-lightweight-install-fetch' doc/byebyevibe-guide.md`
  - **Forbidden:** bumping `MANIFEST.yaml` version without a matching guide header entry and changelog line

- [x] 3.2 Final consistency pass: strict OpenSpec validation, task-pattern verification, and kit verification
  - **Gate:** `npx --yes @fission-ai/openspec@1.3.1 validate --all --strict && bash scripts/verify-task-patterns.sh && bash sdd-kit/verify.sh`

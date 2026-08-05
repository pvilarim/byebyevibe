## 1. Verify the mandated behaviours are genuinely present

These tasks assert reality matches the new requirements **before** the deltas land in the live specs. If a gate fails, the requirement is wrong (or the behaviour regressed) — pause rather than weakening the gate.

- [x] 1.1 Confirm the kit template and the hub manifest both carry the `## UI Development Module` section, so the amended "Manifest sections" requirement is satisfiable by a fresh install
  - **Pattern:** `sdd-kit/templates/openspec/infra.md`, `openspec/infra.md`
  - **Invariants:** `openspec/changes/sync-ui-module-spec-requirements/specs/sdd-workspace-manifest/spec.md` (Requirement: Manifest sections)
  - **Gate:** `grep -q '^## UI Development Module' sdd-kit/templates/openspec/infra.md && grep -q '^## UI Development Module' openspec/infra.md`
  - **Forbidden:** adding the section to either file — it is already present; this task only verifies

- [x] 1.2 Confirm guide §2.11.1 exists and is referenced from §2.11
  - **Pattern:** `doc/byebyevibe-guide.md`
  - **Invariants:** `openspec/changes/sync-ui-module-spec-requirements/specs/sdd-post-install-verification/spec.md` (Requirement: UI module verification checklist)
  - **Gate:** `grep -q '^#### 2\.11\.1 UI module verification checklist' doc/byebyevibe-guide.md && sed -n '/^### 2\.11 /,/^#### 2\.11\.1 /p' doc/byebyevibe-guide.md | grep -q '2\.11\.1'`
  - **Forbidden:** editing the guide — the checklist already exists; this task only verifies

## 2. Consistency pass

- [x] 2.1 Strict OpenSpec validation, task-pattern verification, and confirmation that no payload changed (so no `MANIFEST.yaml` bump is owed)
  - **Gate:** `npx --yes @fission-ai/openspec@1.3.1 validate --all --strict && bash scripts/verify-task-patterns.sh && git diff --quiet HEAD -- sdd-kit/ && grep -qE '^version: "1\.8\.1"' sdd-kit/MANIFEST.yaml`
  - **Forbidden:** bumping `sdd-kit/MANIFEST.yaml` or regenerating checksums — this change ships no payload content

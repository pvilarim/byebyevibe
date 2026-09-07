## 1. S1 — Evaluation note

- [ ] 1.1 Create `doc/avaliacoes/2026-09-05-astra-orchestrator.md` from the evaluation template. Preserve the explore verdict (possibility, not runtime). Split the decision as in design D1. Point at `research.md` instead of copying §1–§8. Restate cabe / não cabe (D4). English only.
  - **Pattern:** `doc/avaliacoes/TEMPLATE.md`
  - **Invariants:** Orchestrator role is the current-phase agent (`sdd-session-handoff`)
  - **Forbidden:** ChangeState / PolicyEngine / event bus / `/opsx:orchestrate`; claiming GPT-6 / Astra product capabilities; rewriting `research.md` verdict
  - **Gate:** `test -s doc/avaliacoes/2026-09-05-astra-orchestrator.md && grep -q 'Discarded' doc/avaliacoes/2026-09-05-astra-orchestrator.md && grep -q 'explore-astra-orchestrator/research.md' doc/avaliacoes/2026-09-05-astra-orchestrator.md && grep -q 'current' doc/avaliacoes/2026-09-05-astra-orchestrator.md && ! grep -qiE 'GPT-6 (can|will|ships|is generally available)' doc/avaliacoes/2026-09-05-astra-orchestrator.md && echo OK`

- [ ] 1.2 Add one index row at the top of the evaluation table in `doc/avaliacoes/README.md` for 2026-09-05 Astra orchestrator (Discarded as new hub runtime; role already shipping; official product claims Deferred).
  - **Pattern:** `doc/avaliacoes/README.md`
  - **Forbidden:** removing or rewriting Deer / LifeOS / G6 rows
  - **Gate:** `grep -q '2026-09-05-astra-orchestrator.md' doc/avaliacoes/README.md && grep -q 'Discarded' doc/avaliacoes/README.md && echo OK`

## 2. S2 — Guide pointer

- [ ] 2.1 After the §3.4 pipeline diagram in `doc/byebyevibe-guide.md`, add a short paragraph: orchestrator = agent of **this** phase; artifacts = memory; human or Cursor Automation = scheduler; gates = VALIDATE with evidence. Link the S1 note. Do not bump guide version.
  - **Pattern:** `doc/byebyevibe-guide.md`
  - **Invariants:** Orchestrator role is the current-phase agent (`sdd-session-handoff`)
  - **Forbidden:** `/opsx:orchestrate`; new phase in the diagram; editing `AGENTS.md` or `doc/sdd-operator-day1.md`; changing `version:` / `guide_version:`
  - **Gate:** `grep -A90 '### 3.4 Full visual pipeline' doc/byebyevibe-guide.md | grep -q 'orchestrator' && grep -A90 '### 3.4 Full visual pipeline' doc/byebyevibe-guide.md | grep -q '2026-09-05-astra-orchestrator.md' && grep -q '1.15.1' doc/byebyevibe-guide.md && echo OK`

- [ ] 2.2 Copy the same §3.4 pointer into `sdd-kit/templates/doc/byebyevibe-guide.md` so the kit COPY payload matches the hub guide.
  - **Pattern:** `sdd-kit/templates/doc/byebyevibe-guide.md`
  - **Forbidden:** other template edits; kit version bump
  - **Gate:** `diff -q doc/byebyevibe-guide.md sdd-kit/templates/doc/byebyevibe-guide.md && echo OK`

- [ ] 2.3 Regenerate MANIFEST checksums after the guide template edit. Do not change `version:` or `guide_version:`.
  - **Pattern:** `sdd-kit/gen-manifest-checksums.sh`
  - **Forbidden:** bumping `sdd-kit/MANIFEST.yaml` `version:` or `guide_version:`
  - **Gate:** `bash sdd-kit/gen-manifest-checksums.sh && grep -q 'version: "1.15.1"' sdd-kit/MANIFEST.yaml && grep -q 'guide_version: "1.15.1"' sdd-kit/MANIFEST.yaml && echo OK`

## 3. Guardrails

- [ ] 3.1 Confirm no runtime, S3, S4, or constitution edit landed.
  - **Pattern:** `openspec/changes/explore-astra-orchestrator/design.md`
  - **Forbidden:** new `.ts` / `workflow.ts` / PolicyEngine; `openspec/project.md` edit; new `/opsx:*` skill
  - **Gate:** `! git diff --name-only -- openspec/project.md AGENTS.md doc/sdd-operator-day1.md | grep -q . && echo OK`

## 4. Validate

- [ ] 4.1 Validate the change and task patterns.
  - **Gate:** `OPENSPEC_TELEMETRY=0 npx --yes @fission-ai/openspec@1.3.1 validate explore-astra-orchestrator --strict && bash scripts/verify-task-patterns.sh`

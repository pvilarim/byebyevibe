## 1. Canonical skill `sdd-skill-guidance` (D-A, D-E)

- [ ] 1.1 Create `.claude/skills/sdd-skill-guidance/SKILL.md` — detection signals catalog (law/norm/table, company thresholds, domain-fact correction as gold signal, re-explaining/re-pasting, proprietary step-by-step), standard three-part suggestion message verbatim (will / won't self-update + stale warning / user decides), one-suggestion-per-session cap, creation hygiene (search-before-create, description diet, task-based naming, `references/` for dense data), "verified on YYYY-MM" staleness marker, archive rule-of-three question. Frontmatter description: 1–2 trigger-focused sentences, mode C.
  - **Pattern:** `.claude/skills/openspec-help/SKILL.md`
  - **Invariants:** `openspec/changes/add-skill-guidance/specs/sdd-skill-guidance/spec.md` (detection signals, suggestion message, hygiene rules)
  - **Gate:** `test -f .claude/skills/sdd-skill-guidance/SKILL.md && grep -q 'verified on' .claude/skills/sdd-skill-guidance/SKILL.md && grep -qi 'one suggestion per session' .claude/skills/sdd-skill-guidance/SKILL.md`
  - **Forbidden:** always-on injection; persona-based naming; instructing skill authoring before development starts

- [ ] 1.2 Mirror to `.cursor/skills/sdd-skill-guidance/SKILL.md` (same body; frontmatter per Cursor skill convention)
  - **Pattern:** `.cursor/skills/openspec-help/SKILL.md`
  - **Gate:** `test -f .cursor/skills/sdd-skill-guidance/SKILL.md && grep -q 'verified on' .cursor/skills/sdd-skill-guidance/SKILL.md`

- [ ] 1.3 Copy both live skills into `sdd-kit/templates/.claude/skills/sdd-skill-guidance/SKILL.md` and `sdd-kit/templates/.cursor/skills/sdd-skill-guidance/SKILL.md`
  - **Gate:** `diff -q .claude/skills/sdd-skill-guidance/SKILL.md sdd-kit/templates/.claude/skills/sdd-skill-guidance/SKILL.md && diff -q .cursor/skills/sdd-skill-guidance/SKILL.md sdd-kit/templates/.cursor/skills/sdd-skill-guidance/SKILL.md`

## 2. Day-1 doc section + `/opsx:help` narration (D-D)

- [ ] 2.1 Insert `## 7. Skills — memory beyond specs` in `doc/sdd-operator-day1.md` (litmus test, skill vs spec vs `project.md` boundary, agent-routed creation, create → measure → prune with rule of three, staleness marker, explicit "no skills required before development" line, pointer to `sdd-skill-guidance`); renumber "Next step" to `## 8.`; add the repetition question to "Confidence (archive)" in §6.
  - **Pattern:** `doc/sdd-operator-day1.md`
  - **Invariants:** `openspec/changes/add-skill-guidance/specs/sdd-operator-onboarding/spec.md` (no always-on rule; no forced pre-dev authoring)
  - **Gate:** `grep -q '^## 7. Skills' doc/sdd-operator-day1.md && grep -q '^## 8. Next step' doc/sdd-operator-day1.md && grep -qi 'rule of three' doc/sdd-operator-day1.md`

- [ ] 2.2 Sync `sdd-kit/templates/doc/sdd-operator-day1.md` with the live doc
  - **Gate:** `diff -q doc/sdd-operator-day1.md sdd-kit/templates/doc/sdd-operator-day1.md`

- [ ] 2.3 Update `openspec-help` skill (live `.claude` + `.cursor` and both kit templates): section table gains §7 Skills row, `§0–§7` → `§0–§8`, handoff ref `§7` → `§8`, one "Keep framing honest" bullet on skills (memory over chat; when to create; ask the agent to create it)
  - **Pattern:** `.claude/skills/openspec-help/SKILL.md`
  - **Gate:** `! grep -rl '§0–§7' .claude/skills/openspec-help .cursor/skills/openspec-help sdd-kit/templates/.claude/skills/openspec-help sdd-kit/templates/.cursor/skills/openspec-help && grep -q 'Skills' .claude/skills/openspec-help/SKILL.md`

- [ ] 2.4 Update `/opsx:help` command mirrors (`.claude/commands/opsx/help.md`, `.cursor/commands/opsx-help.md`, and both kit template copies) `§0–§7` → `§0–§8`
  - **Gate:** `! grep -l '§0–§7' .claude/commands/opsx/help.md .cursor/commands/opsx-help.md sdd-kit/templates/.claude/commands/opsx/help.md sdd-kit/templates/.cursor/commands/opsx-help.md`

## 3. Detection clauses on hub explore/propose surfaces (D-B)

- [ ] 3.1 Add compact "Skill suggestion (domain-density detection)" section (~12 lines: signal list, three-part message skeleton, ≤1/session cap, pointer to `sdd-skill-guidance`) to `.claude/commands/opsx/explore.md` and `.claude/skills/openspec-explore/SKILL.md`
  - **Pattern:** `.claude/skills/openspec-apply-change/SKILL.md` (inline custom-section precedent: "Session coordination")
  - **Gate:** `grep -q 'domain-density' .claude/commands/opsx/explore.md && grep -q 'domain-density' .claude/skills/openspec-explore/SKILL.md`

- [ ] 3.2 Same section on `.cursor/commands/opsx-explore.md` and `.cursor/skills/openspec-explore/SKILL.md`
  - **Gate:** `grep -q 'domain-density' .cursor/commands/opsx-explore.md && grep -q 'domain-density' .cursor/skills/openspec-explore/SKILL.md`

- [ ] 3.3 Same section on `.claude/commands/opsx/propose.md` and `.claude/skills/openspec-propose/SKILL.md`
  - **Gate:** `grep -q 'domain-density' .claude/commands/opsx/propose.md && grep -q 'domain-density' .claude/skills/openspec-propose/SKILL.md`

- [ ] 3.4 Same section on `.cursor/commands/opsx-propose.md` and `.cursor/skills/openspec-propose/SKILL.md`
  - **Gate:** `grep -q 'domain-density' .cursor/commands/opsx-propose.md && grep -q 'domain-density' .cursor/skills/openspec-propose/SKILL.md`

## 4. Archive confidence question (D-C)

- [ ] 4.1 Add the repetition question ("Did anything in this change repeat a procedure or explanation from a previous change? Rule of three: 1st normal, 2nd note it, 3rd extract a skill") to `.claude/commands/opsx/archive.md`, `.cursor/commands/opsx-archive.md`, `.claude/skills/openspec-archive-change/SKILL.md`, `.cursor/skills/openspec-archive-change/SKILL.md`
  - **Invariants:** `openspec/changes/add-skill-guidance/specs/sdd-skill-guidance/spec.md` (archive-time repetition question)
  - **Gate:** `test "$(grep -lri 'rule of three' .claude/commands/opsx/archive.md .cursor/commands/opsx-archive.md .claude/skills/openspec-archive-change/SKILL.md .cursor/skills/openspec-archive-change/SKILL.md | wc -l)" = 4`

## 5. Kit registration + evaluation record (D-F)

- [ ] 5.1 Add MANIFEST entries for the two new skill templates (profiles APP/DOCS_SPECS/HYBRID, merge COPY, documentary `gate:` fields)
  - **Pattern:** `sdd-kit/MANIFEST.yaml` (openspec-help entries block)
  - **Gate:** `test "$(grep -c 'sdd-skill-guidance' sdd-kit/MANIFEST.yaml)" -ge 2`

- [ ] 5.2 Regenerate checksums for new and modified templates
  - **Gate:** `bash sdd-kit/gen-manifest-checksums.sh && bash sdd-kit/gen-manifest-checksums.sh --check`

- [ ] 5.3 Create `doc/avaliacoes/2026-08-01-skill-guidance.md` from the template (Decision: Adopted; cites explore research D1–D10) and add its row to `doc/avaliacoes/README.md`
  - **Pattern:** `doc/avaliacoes/TEMPLATE.md`
  - **Gate:** `test -s doc/avaliacoes/2026-08-01-skill-guidance.md && grep -q 'skill-guidance' doc/avaliacoes/README.md`

## 6. Validation

- [ ] 6.1 OpenSpec strict validation passes for this change
  - **Gate:** `npx -y @fission-ai/openspec@1.3.1 validate add-skill-guidance --strict`

- [ ] 6.2 Task patterns verify clean (DOCS_SPECS boundary)
  - **Gate:** `bash scripts/verify-task-patterns.sh`

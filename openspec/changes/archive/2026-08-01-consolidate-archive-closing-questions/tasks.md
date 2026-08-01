# Tasks — consolidate-archive-closing-questions

## 1. Archive skill mirrors — rewrite step 4b

- [x] 1.1 Rewrite step 4b in `.claude/skills/openspec-archive-change/SKILL.md`: replace the three "ask the operator" blocks with the consolidated closing assessment (agent self-assessment with evidence per design D1, always-printed 3-line verdict, single `AskUserQuestion` `multiSelect` prompt only when ≥1 positive signal, never blocks)
  - **Pattern:** `.claude/skills/openspec-archive-change/SKILL.md`
  - **Gate:** `grep -q 'consolidated closing assessment' .claude/skills/openspec-archive-change/SKILL.md && ! grep -q 'And the repetition confidence question' .claude/skills/openspec-archive-change/SKILL.md`
- [x] 1.2 Mirror the same rewrite in `.claude/commands/opsx/archive.md`
  - **Pattern:** `.claude/commands/opsx/archive.md`
  - **Gate:** `grep -q 'consolidated closing assessment' .claude/commands/opsx/archive.md && ! grep -q 'And the repetition confidence question' .claude/commands/opsx/archive.md`
- [x] 1.3 Mirror the rewrite in `.cursor/skills/openspec-archive-change/SKILL.md` with the Cursor asymmetry (plain-text chat question instead of `AskUserQuestion`; no Claude Code harness tool names)
  - **Pattern:** `.cursor/skills/openspec-archive-change/SKILL.md`
  - **Gate:** `grep -q 'consolidated closing assessment' .cursor/skills/openspec-archive-change/SKILL.md && ! grep -q 'AskUserQuestion' .cursor/skills/openspec-archive-change/SKILL.md`
- [x] 1.4 Mirror the rewrite in `.cursor/commands/opsx-archive.md` (same Cursor asymmetry)
  - **Pattern:** `.cursor/commands/opsx-archive.md`
  - **Gate:** `grep -q 'consolidated closing assessment' .cursor/commands/opsx-archive.md && ! grep -q 'AskUserQuestion' .cursor/commands/opsx-archive.md`

## 2. Guidance skill copies — update archive-time sentence

- [x] 2.1 Update the "At archive time, the workflow asks…" sentence in the installed copies `.claude/skills/sdd-skill-guidance/SKILL.md` and `.cursor/skills/sdd-skill-guidance/SKILL.md` to describe the agent-evaluated consolidated assessment (verdict always printed, prompt only on positive signal)
  - **Pattern:** `.claude/skills/sdd-skill-guidance/SKILL.md`
  - **Gate:** `grep -q 'consolidated closing assessment' .claude/skills/sdd-skill-guidance/SKILL.md && grep -q 'consolidated closing assessment' .cursor/skills/sdd-skill-guidance/SKILL.md`
- [x] 2.2 Apply the same sentence update to the kit templates `sdd-kit/templates/.claude/skills/sdd-skill-guidance/SKILL.md` and `sdd-kit/templates/.cursor/skills/sdd-skill-guidance/SKILL.md`
  - **Pattern:** `sdd-kit/templates/.claude/skills/sdd-skill-guidance/SKILL.md`
  - **Gate:** `grep -q 'consolidated closing assessment' sdd-kit/templates/.claude/skills/sdd-skill-guidance/SKILL.md && grep -q 'consolidated closing assessment' sdd-kit/templates/.cursor/skills/sdd-skill-guidance/SKILL.md`

## 3. Kit manifest

- [x] 3.1 Regenerate manifest checksums after the template edits and verify the kit
  - **Pattern:** `sdd-kit/MANIFEST.yaml`
  - **Gate:** `bash sdd-kit/gen-manifest-checksums.sh && bash sdd-kit/verify.sh`

## 4. Validation

- [x] 4.1 Validate all specs and deltas strictly
  - **Gate:** `npx -y @fission-ai/openspec@1.3.1 validate --all --strict`
- [x] 4.2 Verify task pattern paths resolve
  - **Gate:** `bash scripts/verify-task-patterns.sh`

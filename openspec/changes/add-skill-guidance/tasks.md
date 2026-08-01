## 1. Day-1 doc section and evaluation

- [ ] 1.1 Add skill-guidance section to `doc/sdd-operator-day1.md` (EN): litmus test, skill vs spec vs project.md boundary, agent-routed creation, create → measure → prune lifecycle, signal catalog, standard will/won't/decide message, no pre-development skill-authoring requirement
  - **Pattern:** `doc/sdd-operator-day1.md`
  - **Gate:** `grep -qi 'skill' doc/sdd-operator-day1.md && grep -qi 'competent generalist' doc/sdd-operator-day1.md && grep -q 'references/' doc/sdd-operator-day1.md && grep -qi 'one suggestion per session' doc/sdd-operator-day1.md && grep -qi 'verified on' doc/sdd-operator-day1.md`

- [ ] 1.2 Add evaluation stub `doc/avaliacoes/2026-08-01-sdd-skill-guidance.md` (insertion methodology R5; v2 deferred scope incl. Cursor telemetry asymmetry; ownership note for future upstream skill-suggestion) and index row in `doc/avaliacoes/README.md`
  - **Pattern:** `doc/avaliacoes/TEMPLATE.md`
  - **Gate:** `test -s doc/avaliacoes/2026-08-01-sdd-skill-guidance.md && grep -q '2026-08-01-sdd-skill-guidance' doc/avaliacoes/README.md && grep -qi 'PostToolUse\|telemetry' doc/avaliacoes/2026-08-01-sdd-skill-guidance.md`

## 2. Kit skill `skill-guidance` (templates + hub mirrors)

- [ ] 2.1 Create kit template `sdd-kit/templates/.cursor/skills/skill-guidance/SKILL.md`: trigger description tuned to domain-density signals (user corrects domain fact, cites local norm, states company thresholds, re-explains prior material); body = detection → standard message (≤1/session, offer-only) → creation hygiene checklist (search-before-create/extend, description diet, task naming, `references/` for dense data, "verified on YYYY-MM" for volatile data)
  - **Pattern:** `sdd-kit/templates/.cursor/skills/openspec-help/SKILL.md`
  - **Gate:** `test -s sdd-kit/templates/.cursor/skills/skill-guidance/SKILL.md && grep -qi 'one suggestion per session' sdd-kit/templates/.cursor/skills/skill-guidance/SKILL.md && grep -qi 'verified on' sdd-kit/templates/.cursor/skills/skill-guidance/SKILL.md && grep -qi 'search.*before.*creat\|extend an existing' sdd-kit/templates/.cursor/skills/skill-guidance/SKILL.md`

- [ ] 2.2 Mirror Claude template `sdd-kit/templates/.claude/skills/skill-guidance/SKILL.md` identical to Cursor content (G-MIRROR)
  - **Pattern:** `sdd-kit/templates/.claude/skills/openspec-help/SKILL.md`
  - **Gate:** `diff -q sdd-kit/templates/.cursor/skills/skill-guidance/SKILL.md sdd-kit/templates/.claude/skills/skill-guidance/SKILL.md`

- [ ] 2.3 Sync hub mirrors `.cursor/skills/skill-guidance/SKILL.md` and `.claude/skills/skill-guidance/SKILL.md` from kit templates
  - **Pattern:** `.cursor/skills/openspec-help/SKILL.md`
  - **Gate:** `diff -q sdd-kit/templates/.cursor/skills/skill-guidance/SKILL.md .cursor/skills/skill-guidance/SKILL.md && diff -q sdd-kit/templates/.claude/skills/skill-guidance/SKILL.md .claude/skills/skill-guidance/SKILL.md`

- [ ] 2.4 Register `skill-guidance` in `openspec/infra.md` Skills table (both surfaces)
  - **Pattern:** `openspec/infra.md`
  - **Gate:** `grep -q 'skill-guidance' openspec/infra.md`

## 3. Activation clauses (thin — full content stays in skill + day-1 doc)

- [ ] 3.1 Add ≤8-line detection clause to hub explore wrappers `.claude/commands/opsx/explore.md` and `.cursor/commands/opsx-explore.md` (signals one-liner; follow `skill-guidance`; cap; offer-only)
  - **Pattern:** `.claude/commands/opsx/explore.md`
  - **Gate:** `grep -q 'skill-guidance' .claude/commands/opsx/explore.md && grep -q 'skill-guidance' .cursor/commands/opsx-explore.md`

- [ ] 3.2 Add the same thin clause to hub propose wrappers `.claude/commands/opsx/propose.md` and `.cursor/commands/opsx-propose.md`
  - **Pattern:** `.claude/commands/opsx/propose.md`
  - **Gate:** `grep -q 'skill-guidance' .claude/commands/opsx/propose.md && grep -q 'skill-guidance' .cursor/commands/opsx-propose.md`

- [ ] 3.3 Add archive repetition confidence question (rule of three) to hub archive wrappers `.claude/commands/opsx/archive.md` and `.cursor/commands/opsx-archive.md`; resolve design open question on whether the kit archive skill mirror also carries it
  - **Pattern:** `.claude/commands/opsx/archive.md`
  - **Gate:** `grep -qiE 'repeat|rule of three' .claude/commands/opsx/archive.md && grep -qiE 'repeat|rule of three' .cursor/commands/opsx-archive.md`

- [ ] 3.4 Add thin pointer (not full tutorial) to kit rule template `sdd-kit/templates/.cursor/rules/015-session-phases.mdc` so target projects get the detection clause without patched wrappers
  - **Pattern:** `sdd-kit/templates/.cursor/rules/015-session-phases.mdc`
  - **Gate:** `grep -q 'skill-guidance' sdd-kit/templates/.cursor/rules/015-session-phases.mdc`

## 4. MANIFEST, checksums, validation

- [ ] 4.1 Add MANIFEST entries for `skill-guidance` templates (both surfaces) with grep-able gates, following the `openspec-help` entry pattern
  - **Pattern:** `sdd-kit/MANIFEST.yaml`
  - **Gate:** `grep -q 'skill-guidance' sdd-kit/MANIFEST.yaml`

- [ ] 4.2 Regenerate MANIFEST checksums after template edits
  - **Pattern:** `sdd-kit/gen-manifest-checksums.sh`
  - **Gate:** `bash sdd-kit/gen-manifest-checksums.sh && grep -A3 'skill-guidance' sdd-kit/MANIFEST.yaml | grep -q sha256`

- [ ] 4.3 Run full validation: OpenSpec strict + task-pattern verifier
  - **Pattern:** `scripts/verify-task-patterns.sh`
  - **Gate:** `npx --yes @fission-ai/openspec@1.3.1 validate --all --strict --no-interactive && bash scripts/verify-task-patterns.sh`

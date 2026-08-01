## 1. Canonical skill `sdd-tooling-guidance` (D-A, D-G)

- [x] 1.1 Create `.claude/skills/sdd-tooling-guidance/SKILL.md` — resolution cascade (override → CLI → MCP → suggest → manual) with second-manual-fall trigger, CLI-first rationale + per-tool MCP exceptions ("key → CLI → MCP unless only MCP delivers the capability"), session-only override, conversational signal catalog with paste caveat, security-hardened three-part suggestion message verbatim (will / won't-with-security-and-context-cost / decide, "no" recorded as `declined`), shared one-per-session cap, durable-refusal check against `openspec/infra.md`, pointer to `doc/tooling-install.md`; MAY reference Claude Code harness tools (`SearchMcpRegistry`, `ListConnectors`) with an asymmetry note. Frontmatter description: 1–2 trigger-focused sentences, mode C.
  - **Pattern:** `.claude/skills/sdd-skill-guidance/SKILL.md`
  - **Invariants:** `openspec/changes/add-tooling-guidance/specs/sdd-tooling-guidance/spec.md` (cascade, suggestion message, shared cap, durable refusals)
  - **Gate:** `test -f .claude/skills/sdd-tooling-guidance/SKILL.md && grep -q 'declined' .claude/skills/sdd-tooling-guidance/SKILL.md && grep -qi 'never install' .claude/skills/sdd-tooling-guidance/SKILL.md && grep -q 'doc/tooling-install.md' .claude/skills/sdd-tooling-guidance/SKILL.md`
  - **Forbidden:** auto-install/auto-configure instructions; always-on injection; a second per-session suggestion slot

- [x] 1.2 Mirror to `.cursor/skills/sdd-tooling-guidance/SKILL.md` — same body except the documented asymmetry: replace harness-tool references with "suggest + point to `doc/tooling-install.md`" (no Claude Code tool names presented as available)
  - **Pattern:** `.cursor/skills/sdd-skill-guidance/SKILL.md`
  - **Gate:** `test -f .cursor/skills/sdd-tooling-guidance/SKILL.md && grep -q 'doc/tooling-install.md' .cursor/skills/sdd-tooling-guidance/SKILL.md && ! grep -q 'SearchMcpRegistry' .cursor/skills/sdd-tooling-guidance/SKILL.md`

- [x] 1.3 Copy both live skills into `sdd-kit/templates/.claude/skills/sdd-tooling-guidance/SKILL.md` and `sdd-kit/templates/.cursor/skills/sdd-tooling-guidance/SKILL.md`
  - **Gate:** `diff -q .claude/skills/sdd-tooling-guidance/SKILL.md sdd-kit/templates/.claude/skills/sdd-tooling-guidance/SKILL.md && diff -q .cursor/skills/sdd-tooling-guidance/SKILL.md sdd-kit/templates/.cursor/skills/sdd-tooling-guidance/SKILL.md`

## 2. R10 cascade + hub apply-surface clauses (D-B)

- [x] 2.1 Extend R10 in `AGENTS.md` with one sentence stating the resolution order for external-tool actions (override → CLI → MCP → suggest → manual)
  - **Pattern:** `AGENTS.md`
  - **Invariants:** `openspec/changes/add-tooling-guidance/specs/sdd-workspace-manifest/spec.md` (R10 carries the cascade)
  - **Gate:** `grep -q 'R10' AGENTS.md && grep -A2 'R10' AGENTS.md | grep -qi 'CLI.*MCP'`

- [x] 2.2 Add compact "Tooling cascade (CLI → MCP → manual)" section (~10 lines: cascade skeleton, second-manual-fall trigger, shared cap, pointer to `sdd-tooling-guidance`) to `.claude/commands/opsx/apply.md` and `.claude/skills/openspec-apply-change/SKILL.md`
  - **Pattern:** `.claude/skills/openspec-apply-change/SKILL.md` (inline custom-section precedent: "Session coordination (apply)")
  - **Gate:** `grep -q 'Tooling cascade' .claude/commands/opsx/apply.md && grep -q 'Tooling cascade' .claude/skills/openspec-apply-change/SKILL.md`

- [x] 2.3 Same section on `.cursor/commands/opsx-apply.md` and `.cursor/skills/openspec-apply-change/SKILL.md`
  - **Gate:** `grep -q 'Tooling cascade' .cursor/commands/opsx-apply.md && grep -q 'Tooling cascade' .cursor/skills/openspec-apply-change/SKILL.md`

## 3. Shared cap across mechanisms (D-C)

- [x] 3.1 In the existing "Skill suggestion (domain-density detection)" sections of the eight hub explore/propose surfaces (`.claude/commands/opsx/{explore,propose}.md`, `.cursor/commands/opsx-{explore,propose}.md`, `.claude/skills/openspec-{explore,propose}/SKILL.md`, `.cursor/skills/openspec-{explore,propose}/SKILL.md`), amend the cap line: the one-suggestion cap is shared with tooling suggestions (`sdd-tooling-guidance`), strongest signal wins
  - **Pattern:** `.claude/commands/opsx/propose.md` (existing cap line)
  - **Invariants:** `openspec/changes/add-tooling-guidance/specs/sdd-skill-guidance/spec.md` (shared cap MODIFIED requirement)
  - **Gate:** `test "$(grep -rl 'shared' .claude/commands/opsx/explore.md .claude/commands/opsx/propose.md .cursor/commands/opsx-explore.md .cursor/commands/opsx-propose.md .claude/skills/openspec-explore/SKILL.md .claude/skills/openspec-propose/SKILL.md .cursor/skills/openspec-explore/SKILL.md .cursor/skills/openspec-propose/SKILL.md | wc -l)" = 8`

## 4. Durable refusals + static gap-check (D-D, D-E)

- [x] 4.1 Extend `scripts/verify-infra.sh` with an advisory "Tooling gap-check" report: presence/absence of `.mcp.json` and `.cursor/mcp.json`, `PATH` availability of CLIs listed in `openspec/infra.md`, `.env.example` key names (commented-out key reported as "considered and declined"), suppression of rows whose manifest status is `declined`; gaps NEVER cause a non-zero exit; existing marker ownership untouched (Preflight section remains `preflight-sdd.sh`'s)
  - **Pattern:** `scripts/verify-infra.sh`
  - **Invariants:** `openspec/changes/add-tooling-guidance/specs/sdd-workspace-manifest/spec.md` (gap-check, declined suppression); never read `.env`
  - **Gate:** `bash scripts/verify-infra.sh >/dev/null && grep -qi 'gap' scripts/verify-infra.sh && grep -q 'declined' scripts/verify-infra.sh`

- [x] 4.2 Document the `declined` status value in `openspec/infra.md` (Agent rule section: `declined` = durable refusal, do not re-suggest; cascade rungs still apply) and sync `sdd-kit/templates/scripts/verify-infra.sh` with the live script
  - **Pattern:** `openspec/infra.md`
  - **Gate:** `grep -q 'declined' openspec/infra.md && diff -q scripts/verify-infra.sh sdd-kit/templates/scripts/verify-infra.sh`

## 5. Day-1 §8 tooling section + `/opsx:help` narration (D-F)

- [x] 5.1 Insert `## 8. Tooling — CLI → MCP → manual` in `doc/sdd-operator-day1.md` (cascade in plain language, key → CLI → MCP hierarchy with MCP-only exception, MCP permanent context cost, session override, never-install-unprompted, status in `infra.md` / how-to in `doc/tooling-install.md`); renumber "Next step" to `## 9.`; add the manual-work question to "Confidence (archive)" in §6
  - **Pattern:** `doc/sdd-operator-day1.md`
  - **Invariants:** `openspec/changes/add-tooling-guidance/specs/sdd-operator-onboarding/spec.md` (offer-only; never install unprompted; no always-on rule)
  - **Gate:** `grep -q '^## 8. Tooling' doc/sdd-operator-day1.md && grep -q '^## 9. Next step' doc/sdd-operator-day1.md && grep -qi 'manually that' doc/sdd-operator-day1.md`

- [x] 5.2 Sync `sdd-kit/templates/doc/sdd-operator-day1.md` with the live doc
  - **Gate:** `diff -q doc/sdd-operator-day1.md sdd-kit/templates/doc/sdd-operator-day1.md`

- [x] 5.3 Update `openspec-help` skill (live `.claude` + `.cursor` and both kit templates): section table gains the §8 Tooling row, `§0–§8` → `§0–§9`, handoff ref `§8` → `§9`, one "Keep framing honest" bullet on tooling (cascade; suggest-only; CLI default)
  - **Pattern:** `.claude/skills/openspec-help/SKILL.md`
  - **Gate:** `! grep -rl '§0–§8' .claude/skills/openspec-help .cursor/skills/openspec-help sdd-kit/templates/.claude/skills/openspec-help sdd-kit/templates/.cursor/skills/openspec-help && grep -q 'Tooling' .claude/skills/openspec-help/SKILL.md`

- [x] 5.4 Update `/opsx:help` command mirrors (`.claude/commands/opsx/help.md`, `.cursor/commands/opsx-help.md`, and both kit template copies) `§0–§8` → `§0–§9`
  - **Gate:** `! grep -l '§0–§8' .claude/commands/opsx/help.md .cursor/commands/opsx-help.md sdd-kit/templates/.claude/commands/opsx/help.md sdd-kit/templates/.cursor/commands/opsx-help.md`

## 6. Per-tool install doc (D-H)

- [x] 6.1 Create `doc/tooling-install.md` — entry pattern (official-doc link + verification command + "verified on YYYY-MM" marker), seeded with the tools already named in `openspec/infra.md` (github-mcp-server; Figma MCP as the MCP-only exception exemplar); no speculative catalog. Copy to `sdd-kit/templates/doc/tooling-install.md`
  - **Pattern:** `doc/design/002-ui-module-install.md`
  - **Invariants:** `openspec/changes/add-tooling-guidance/specs/sdd-tooling-guidance/spec.md` (per-tool install documentation pattern)
  - **Gate:** `test -s doc/tooling-install.md && grep -q 'verified on' doc/tooling-install.md && diff -q doc/tooling-install.md sdd-kit/templates/doc/tooling-install.md`

- [x] 6.2 Reference `doc/tooling-install.md` from `openspec/infra.md` (MCP Servers section header note, mirroring the UI-module row precedent)
  - **Pattern:** `openspec/infra.md`
  - **Gate:** `grep -q 'tooling-install' openspec/infra.md`

## 7. Archive confidence question (spec: archive-time manual-work question)

- [x] 7.1 Add the manual-work question ("Was anything in this change done manually that a configured integration would have done?") to `.claude/commands/opsx/archive.md`, `.cursor/commands/opsx-archive.md`, `.claude/skills/openspec-archive-change/SKILL.md`, `.cursor/skills/openspec-archive-change/SKILL.md` — same register as the existing confidence questions, non-blocking
  - **Pattern:** `.claude/commands/opsx/archive.md` (repetition confidence question precedent)
  - **Invariants:** `openspec/changes/add-tooling-guidance/specs/sdd-tooling-guidance/spec.md` (archive-time manual-work question)
  - **Gate:** `test "$(grep -lri 'manually that' .claude/commands/opsx/archive.md .cursor/commands/opsx-archive.md .claude/skills/openspec-archive-change/SKILL.md .cursor/skills/openspec-archive-change/SKILL.md | wc -l)" = 4`

## 8. Kit registration + evaluation record (D-I)

- [x] 8.1 Add MANIFEST entries for the new templates (two skill mirrors, `doc/tooling-install.md`; profiles APP/DOCS_SPECS/HYBRID, merge COPY, documentary `gate:` fields)
  - **Pattern:** `sdd-kit/MANIFEST.yaml` (sdd-skill-guidance entries block)
  - **Gate:** `test "$(grep -c 'sdd-tooling-guidance' sdd-kit/MANIFEST.yaml)" -ge 2 && grep -q 'tooling-install' sdd-kit/MANIFEST.yaml`

- [x] 8.2 Regenerate checksums for new and modified templates
  - **Gate:** `bash sdd-kit/gen-manifest-checksums.sh && bash sdd-kit/gen-manifest-checksums.sh --check`

- [x] 8.3 Create `doc/avaliacoes/2026-08-01-tooling-guidance.md` from the template (Decision: Adopted; cites explore research D1–D12) and add its row to `doc/avaliacoes/README.md`
  - **Pattern:** `doc/avaliacoes/TEMPLATE.md`
  - **Gate:** `test -s doc/avaliacoes/2026-08-01-tooling-guidance.md && grep -q 'tooling-guidance' doc/avaliacoes/README.md`

## 9. Validation

- [x] 9.1 OpenSpec strict validation passes for this change
  - **Gate:** `npx -y @fission-ai/openspec@1.3.1 validate add-tooling-guidance --strict`

- [x] 9.2 Task patterns verify clean (DOCS_SPECS boundary)
  - **Gate:** `bash scripts/verify-task-patterns.sh`

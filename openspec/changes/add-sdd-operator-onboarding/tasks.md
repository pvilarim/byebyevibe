## 1. Canonical day-1 doc and evaluation

- [x] 1.1 Create `doc/sdd-operator-day1.md` (EN) with outline §0–§7 from design D3 (Onboard vs Help, memory, map, four phases + craft/confidence, next step)
  - **Pattern:** `doc/sistema-sdd-pedro.md`
  - **Gate:** `test -s doc/sdd-operator-day1.md && grep -q '/opsx:help' doc/sdd-operator-day1.md && grep -q '/opsx:onboard' doc/sdd-operator-day1.md && grep -qiE 'explore|propose|apply|archive' doc/sdd-operator-day1.md && grep -qiE 'confidence|validate' doc/sdd-operator-day1.md && grep -q 'openspec/changes' doc/sdd-operator-day1.md`

- [x] 1.2 Add evaluation stub `doc/avaliacoes/2026-08-01-sdd-operator-onboarding.md` (Option A adopted; onboard complementary; non-goals; collision note) and index row in `doc/avaliacoes/README.md`
  - **Pattern:** `doc/avaliacoes/TEMPLATE.md`
  - **Gate:** `test -s doc/avaliacoes/2026-08-01-sdd-operator-onboarding.md && grep -q '2026-08-01-sdd-operator-onboarding' doc/avaliacoes/README.md && grep -qiE 'Adopted|/opsx:help' doc/avaliacoes/2026-08-01-sdd-operator-onboarding.md`

## 2. /opsx:help skill and commands (hub + kit)

- [x] 2.1 Create kit template skill `sdd-kit/templates/.cursor/skills/openspec-help/SKILL.md` that narrates `doc/sdd-operator-day1.md` (thin orchestration; mode C; Session Handoff optional)
  - **Pattern:** `.cursor/skills/openspec-explore/SKILL.md`
  - **Gate:** `test -s sdd-kit/templates/.cursor/skills/openspec-help/SKILL.md && grep -q 'sdd-operator-day1' sdd-kit/templates/.cursor/skills/openspec-help/SKILL.md && grep -q '/opsx:onboard' sdd-kit/templates/.cursor/skills/openspec-help/SKILL.md`

- [x] 2.2 Mirror Claude skill template `sdd-kit/templates/.claude/skills/openspec-help/SKILL.md` to Cursor skill content (G-MIRROR)
  - **Pattern:** `.claude/skills/openspec-explore/SKILL.md`
  - **Gate:** `diff -q sdd-kit/templates/.cursor/skills/openspec-help/SKILL.md sdd-kit/templates/.claude/skills/openspec-help/SKILL.md`

- [x] 2.3 Create kit command mirrors `sdd-kit/templates/.cursor/commands/opsx-help.md` and `sdd-kit/templates/.claude/commands/opsx/help.md` invoking the help skill stance
  - **Pattern:** `.cursor/commands/opsx-explore.md`
  - **Gate:** `test -s sdd-kit/templates/.cursor/commands/opsx-help.md && test -s sdd-kit/templates/.claude/commands/opsx/help.md && grep -q 'opsx:help\|/opsx:help\|openspec-help' sdd-kit/templates/.cursor/commands/opsx-help.md`

- [x] 2.4 Sync hub mirrors: `.cursor/skills/openspec-help/`, `.claude/skills/openspec-help/`, `.cursor/commands/opsx-help.md`, `.claude/commands/opsx/help.md` from kit templates
  - **Pattern:** `.claude/commands/opsx/explore.md`
  - **Gate:** `test -s .cursor/skills/openspec-help/SKILL.md && test -s .claude/skills/openspec-help/SKILL.md && test -s .cursor/commands/opsx-help.md && test -s .claude/commands/opsx/help.md`

## 3. Discoverability (install tip, AGENTS, guide, infra)

- [x] 3.1 Add day-1 operate tip in `sdd-kit/install.sh` naming `/opsx:help` and `/opsx:onboard` (before add-ons teaser; honor CHAT_LANG)
  - **Pattern:** `sdd-kit/install.sh`
  - **Gate:** `grep -q '/opsx:help' sdd-kit/install.sh && grep -q '/opsx:onboard' sdd-kit/install.sh`

- [x] 3.2 Add equivalent one-line reminder to kit + hub `bootstrap-sdd.sh` manual next-steps
  - **Pattern:** `sdd-kit/templates/scripts/bootstrap-sdd.sh`
  - **Gate:** `grep -q '/opsx:help' sdd-kit/templates/scripts/bootstrap-sdd.sh && grep -q '/opsx:help' scripts/bootstrap-sdd.sh`

- [x] 3.3 Add `/opsx:help` row to hub `AGENTS.md` Commands and kit `AGENTS.commands.APP.md` + `AGENTS.commands.DOCS_SPECS.md`
  - **Pattern:** `sdd-kit/templates/AGENTS.commands.DOCS_SPECS.md`
  - **Gate:** `grep -q '/opsx:help' AGENTS.md && grep -q '/opsx:help' sdd-kit/templates/AGENTS.commands.DOCS_SPECS.md && grep -q '/opsx:help' sdd-kit/templates/AGENTS.commands.APP.md`

- [x] 3.4 Add optional soft §2.8 checklist item + short §2.7 pointer to day-1 doc / `/opsx:help` in guide (no §3/§4 rewrite)
  - **Pattern:** `doc/sistema-sdd-pedro.md`
  - **Gate:** `awk '/### 2\\.8/,/### 2\\.11/' doc/sistema-sdd-pedro.md | grep -q '/opsx:help\\|sdd-operator-day1' && grep -q 'sdd-operator-day1' doc/sistema-sdd-pedro.md`

- [x] 3.5 Register `/opsx:help` in `openspec/infra.md` Skills (and kit `templates/openspec/infra.md` if present)
  - **Pattern:** `openspec/infra.md`
  - **Gate:** `grep -q 'openspec-help\\|/opsx:help' openspec/infra.md`

## 4. MANIFEST, checksums, validation

- [x] 4.1 Add MANIFEST entries for help skill, commands, and `doc/sdd-operator-day1.md` templates (COPY, all profiles)
  - **Pattern:** `sdd-kit/MANIFEST.yaml`
  - **Gate:** `grep -q 'openspec-help' sdd-kit/MANIFEST.yaml && grep -q 'opsx-help\\|opsx/help' sdd-kit/MANIFEST.yaml && grep -q 'sdd-operator-day1' sdd-kit/MANIFEST.yaml`

- [x] 4.2 Regenerate MANIFEST checksums after template edits
  - **Pattern:** `sdd-kit/gen-manifest-checksums.sh`
  - **Gate:** `bash sdd-kit/gen-manifest-checksums.sh && grep -A2 'openspec-help' sdd-kit/MANIFEST.yaml | grep -q sha256`

- [x] 4.3 Validate this change strictly with OpenSpec
  - **Gate:** `OPENSPEC_TELEMETRY=0 npx --yes @fission-ai/openspec@1.3.1 validate add-sdd-operator-onboarding --strict`

- [x] 4.4 Run task-pattern verifier
  - **Pattern:** `scripts/verify-task-patterns.sh`
  - **Gate:** `bash scripts/verify-task-patterns.sh`

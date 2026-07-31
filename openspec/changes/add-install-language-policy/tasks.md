# Tasks: add-install-language-policy

## 1. Spec and template foundations

- [ ] 1.1 Update `sdd-kit/templates/AGENTS.core.md` Communication: replace `[Adapt: pt-BR]` with three-axis F7 block and `{{CHAT_LANG}}`, `{{DOCS_LANG}}`, `{{CODE_LANG}}` placeholders
  - **Pattern:** `sdd-kit/templates/AGENTS.core.md`
  - **Invariants:** `sdd-language-policy` — AGENTS.md Communication generated from policy
  - **Gate:** `grep -q '{{CHAT_LANG}}' sdd-kit/templates/AGENTS.core.md && grep -q 'docs_language\|Documentation\|docs language' sdd-kit/templates/AGENTS.core.md`

- [ ] 1.2 Add Language policy snippet to guide §12.1 `project.md` template and new §2.1.1 Language setup prose in `doc/sistema-sdd-pedro.md` (≤80 lines for §2.1.1 slice)
  - **Pattern:** `doc/sistema-sdd-pedro.md` §12.1
  - **Invariants:** `sdd-language-policy` — Guide documents language setup
  - **Gate:** `grep -q '2.1.1\|Language setup\|Language policy' doc/sistema-sdd-pedro.md && grep -q 'chat_language\|docs_language\|code_language' doc/sistema-sdd-pedro.md`

## 2. install.sh language resolution and persistence

- [ ] 2.1 Add `--chat-lang`, `--docs-lang`, `--code-lang` flags and `validate_locale()` allowlist (`en`, `pt-BR`) to `sdd-kit/install.sh`; default missing values to `en`
  - **Pattern:** `sdd-kit/install.sh`
  - **Invariants:** `sdd-language-policy` — v1 allowed values; Defaults en
  - **Gate:** `bash sdd-kit/install.sh --help 2>&1 | grep -qE 'chat-lang|docs-lang|code-lang'`

- [ ] 2.2 Implement interactive TTY prompts (three numbered menus) when flags absent; log applied defaults
  - **Pattern:** `sdd-kit/install.sh`
  - **Invariants:** `sdd-language-policy` — Three language axes configured at install
  - **Gate:** `grep -qE 'chat_language|docs_language|code_language|read -r' sdd-kit/install.sh`

- [ ] 2.3 Substitute placeholders in `merge_agents_profile` / AGENTS generation; inject `## Language policy` into `openspec/project.md` via `<!-- SDD_LANGUAGE_POLICY_START -->` anchors
  - **Pattern:** `sdd-kit/install.sh`
  - **Invariants:** `sdd-install-kit` — install.sh writes Language policy; AGENTS placeholders substituted
  - **Gate:** `grep -q 'SDD_LANGUAGE_POLICY_START' sdd-kit/install.sh && grep -q 'CHAT_LANG' sdd-kit/install.sh`

- [ ] 2.4 Smoke test in temp dir: `openspec init` stub or minimal `project.md` + `install.sh --profile DOCS_SPECS --chat-lang pt-BR --docs-lang en --code-lang en --repo <tmpdir>` — no `{{*}}` in AGENTS.md
  - **Pattern:** `sdd-kit/install.sh`
  - **Gate:** documented manual smoke in apply session OR script exits 0 and `! grep -q '{{' <tmpdir>/AGENTS.md 2>/dev/null` when run

## 3. Verification and kit parity

- [ ] 3.1 Add language policy checks to `sdd-kit/verify.sh` (no `{{CHAT_LANG}}` leak; `project.md` has Language policy when present)
  - **Pattern:** `sdd-kit/verify.sh`
  - **Invariants:** `sdd-install-kit` — verify.sh checks language policy
  - **Gate:** `grep -q 'LANGUAGE_POLICY\|Language policy\|CHAT_LANG' sdd-kit/verify.sh`

- [ ] 3.2 Update `sdd-kit/templates/scripts/bootstrap-sdd.sh` post-install message to mention language flags / §2.1.1
  - **Pattern:** `sdd-kit/templates/scripts/bootstrap-sdd.sh`
  - **Gate:** `grep -qE 'chat-lang|Language|2\.1\.1' sdd-kit/templates/scripts/bootstrap-sdd.sh`

- [ ] 3.3 Regenerate MANIFEST checksums if any `sdd-kit/templates/` file changed
  - **Pattern:** `sdd-kit/gen-manifest-checksums.sh`
  - **Gate:** `bash sdd-kit/gen-manifest-checksums.sh && bash sdd-kit/verify.sh`

## 4. Guide checklist and validation

- [ ] 4.1 Add §2.8 checklist item for Language policy in `project.md` + Communication in `AGENTS.md`
  - **Pattern:** `doc/sistema-sdd-pedro.md` §2.8
  - **Gate:** `grep -q 'Language policy' doc/sistema-sdd-pedro.md`

- [ ] 4.2 Run OpenSpec validate and task-pattern verify
  - **Gate:** `OPENSPEC_TELEMETRY=0 npx --yes @fission-ai/openspec@1.3.1 validate add-install-language-policy --strict`
  - **Gate:** `bash scripts/verify-task-patterns.sh openspec/changes/add-install-language-policy/tasks.md`

## 5. Hub grandfather (documentation only — no hub AGENTS/project edit)

- [ ] 5.1 Confirm proposal/design/specs state hub is grandfathered; no task modifies hub `AGENTS.md` or `openspec/project.md` Communication/Conventions
  - **Invariants:** `sdd-language-policy` — Hub distribution repo grandfathered
  - **Gate:** `! git diff --name-only | grep -xE 'AGENTS.md|openspec/project.md'` (no changes to those paths in this change)

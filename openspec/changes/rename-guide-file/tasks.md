# Tasks — rename-guide-file

## 1. Rename, stub, changelog (D1, D2)

- [ ] 1.1 `git mv doc/sistema-sdd-pedro.md doc/byebyevibe-guide.md`; create the ≤5-line EN redirect stub at `doc/sistema-sdd-pedro.md` per design D2; add guide changelog §14 entry `v1.7.0` (rename-only release) and update the guide header version
  - **Invariants:** `openspec/changes/rename-guide-file/specs/sdd-docs-language/spec.md` (stub content, no retro-edits)
  - **Gate:** `test -f doc/byebyevibe-guide.md && test "$(wc -l < doc/sistema-sdd-pedro.md)" -le 5 && grep -q 'byebyevibe-guide.md' doc/sistema-sdd-pedro.md && grep -q '1\.7\.0' doc/byebyevibe-guide.md`
  - **Forbidden:** content edits to the guide beyond header version + changelog entry

## 2. Root config docs + alias record (D5)

- [ ] 2.1 Replace the guide path in `AGENTS.md`, `CLAUDE.md`, `openspec/project.md`, `openspec/infra.md`, `README.md`; bump guide version refs to v1.7.0 (`AGENTS.md` map row, `openspec/project.md` Cross-references); add the one-line alias note to `openspec/project.md` Cross-references and `AGENTS.md` per design D5
  - **Pattern:** `openspec/project.md` (Cross-references block)
  - **Gate:** `test "$(grep -c 'sistema-sdd-pedro' AGENTS.md)" = 1 && test "$(grep -c 'sistema-sdd-pedro' openspec/project.md)" = 1 && ! grep -q 'sistema-sdd-pedro' CLAUDE.md openspec/infra.md README.md && grep -q 'renamed' AGENTS.md && grep -oE 'byebyevibe-guide\.md[^v]*v[0-9]+\.[0-9]+\.[0-9]+' openspec/project.md | grep -q 'v1\.7\.0'`
  - **Note:** the alias notes intentionally contain the old name — the D7 grep-zero gate whitelists them by exact-line inspection in task 7.1

## 3. Scripts — functional first (D3)

- [ ] 3.1 Update the four functional scripts: `scripts/verify-i18n-wave.sh` (file list entry), `scripts/sdd-upgrade-diff.sh` (grep regex `sistema-sdd-pedro` → `byebyevibe-guide`), `scripts/verify-task-patterns.sh` (path regex), `scripts/gen-missing-translate-proposes.py` + `scripts/translate-guide-next-wave.sh` (target path + gate strings)
  - **Pattern:** `scripts/sdd-upgrade-diff.sh:14` (regex to adapt)
  - **Invariants:** `openspec/changes/rename-guide-file/specs/sdd-docs-language/spec.md` (gates target new path)
  - **Gate:** `grep -q 'byebyevibe-guide.md' scripts/verify-i18n-wave.sh && grep -q 'byebyevibe-guide' scripts/sdd-upgrade-diff.sh && grep -q 'byebyevibe-guide' scripts/verify-task-patterns.sh && ! grep -rl 'sistema-sdd-pedro' scripts/verify-i18n-wave.sh scripts/sdd-upgrade-diff.sh scripts/verify-task-patterns.sh scripts/gen-missing-translate-proposes.py scripts/translate-guide-next-wave.sh`

- [ ] 3.2 Update the four pointer-only scripts: `scripts/bootstrap-sdd.sh`, `scripts/sdd-session-check.sh`, `scripts/sdd-metrics.sh` (comments/echos §-references keep section numbers, only the path changes)
  - **Pattern:** `scripts/sdd-metrics.sh` (echo lines)
  - **Gate:** `! grep -rl 'sistema-sdd-pedro' scripts/bootstrap-sdd.sh scripts/sdd-session-check.sh scripts/sdd-metrics.sh`

## 4. IDE surfaces

- [ ] 4.1 Replace the guide path in the 13 live IDE files: `.claude/commands/opsx/{apply,propose}.md`, `.claude/skills/openspec-{apply-change,archive-change,help,propose}/SKILL.md`, `.cursor/commands/opsx-{apply,propose}.md`, `.cursor/skills/openspec-{apply-change,archive-change,help,propose}/SKILL.md`, `.cursor/rules/016-session-coordination.mdc`
  - **Pattern:** `.claude/skills/openspec-help/SKILL.md`
  - **Gate:** `! grep -rl 'sistema-sdd-pedro' .claude/ .cursor/`

## 5. Doc surfaces + kit hub files

- [ ] 5.1 Replace the guide path in `doc/sdd-operator-day1.md`, `doc/design/000-impeccable-design-system-guia.md`, `doc/design/001-pipeline-open-design-shadcn-impeccable.md`, `doc/design/002-ui-module-install.md`, `doc/i18n/{WAVES,GLOSSARY,CURSOR-AUTOMATIONS}.md`, `doc/avaliacoes/README.md` (live index only — dated `doc/avaliacoes/2026-*` files stay verbatim)
  - **Gate:** `! grep -rl 'sistema-sdd-pedro' doc/ --include='*.md' | grep -v 'doc/avaliacoes/2026-' | grep -v 'doc/sistema-sdd-pedro.md'`
  - **Forbidden:** edits to `doc/avaliacoes/2026-*` files

- [ ] 5.2 Replace the guide path in `sdd-kit/README.md` (incl. the version rule at line 117), `sdd-kit/install.sh` (§2.8 checklist echo), `sdd-kit/install-probity-module.sh`
  - **Gate:** `! grep -rl 'sistema-sdd-pedro' sdd-kit/README.md sdd-kit/install.sh sdd-kit/install-probity-module.sh`

## 6. Kit templates + release (D6)

- [ ] 6.1 Replace the guide path in all 16 `sdd-kit/templates/**` files that cite it (`.claude/` + `.cursor/` mirrors, `AGENTS.core.md`, `CLAUDE.md`, `openspec/infra.md`, `doc/**`, `install-probity-module.sh`, `scripts/**` mirrors of task 3 files); hub file and its template mirror must be identical where a mirror exists
  - **Pattern:** `sdd-kit/templates/scripts/sdd-upgrade-diff.sh`
  - **Gate:** `! grep -rl 'sistema-sdd-pedro' sdd-kit/templates/ && diff -q scripts/sdd-upgrade-diff.sh sdd-kit/templates/scripts/sdd-upgrade-diff.sh && diff -q scripts/verify-task-patterns.sh sdd-kit/templates/scripts/verify-task-patterns.sh`

- [ ] 6.2 Bump `sdd-kit/MANIFEST.yaml` `version` and `guide_version` to `1.7.0`; regenerate checksums via `bash sdd-kit/gen-manifest-checksums.sh`
  - **Invariants:** `openspec/changes/rename-guide-file/specs/sdd-install-kit/spec.md` (version alignment)
  - **Gate:** `grep -q 'version: "1.7.0"' sdd-kit/MANIFEST.yaml && grep -q 'guide_version: "1.7.0"' sdd-kit/MANIFEST.yaml && bash sdd-kit/verify.sh`

## 7. Final gates (D7)

- [ ] 7.1 Grep-zero sweep: no live reference to the old name outside exclusion zones except the stub and the two one-line alias notes
  - **Gate:** `test "$(git grep -l 'sistema-sdd-pedro' -- ':!openspec/changes' ':!openspec/specs' ':!doc/avaliacoes' | grep -v -e '^doc/sistema-sdd-pedro.md$' -e '^AGENTS.md$' -e '^openspec/project.md$' | wc -l)" = 0 && test "$(git grep -c 'sistema-sdd-pedro' -- AGENTS.md)" = 1 && test "$(git grep -c 'sistema-sdd-pedro' -- openspec/project.md)" = 1`

- [ ] 7.2 End-to-end functional proof: version extraction and validators pass on the renamed path
  - **Gate:** `grep -oE 'byebyevibe-guide\.md[^v]*v[0-9]+\.[0-9]+\.[0-9]+' openspec/project.md | grep -q 'v1\.7\.0' && bash scripts/verify-task-patterns.sh && npx -y @fission-ai/openspec@1.3.1 validate --all --strict`

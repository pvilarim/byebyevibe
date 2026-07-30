## Why

The SDD system has `simplify-review` (avoidable complexity) and `security-reviewer` (vulnerabilities), but no skill that digs into **logical bugs, edge cases, and contract violations** in AI-generated code — exactly the defect category most frequent and most costly to find in late human review. This was identified as gap G7 in `openspec/changes/explore-oss-coverage-gaps/research.md` and prioritized as the second item in the recommended implementation order.

## What Changes

- New skill `correctness-review` in `.claude/skills/correctness-review/SKILL.md` with mirror in `.cursor/skills/correctness-review/SKILL.md`
- Registration at the 6 insertion-contract points (metodologia-insercao.md Phase 3): `infra.md`, `AGENTS.md`, skill files, guide `doc/sistema-sdd-pedro.md`, `doc/avaliacoes/`, and integration instruction in `sdd-kit` for production repos
- Update the "Post-implementation reviews" section in `AGENTS.md` with the skill's position in the pipeline order (post-apply, before `simplify-review`)
- New spec `sdd-correctness-review` that normalizes: when to invoke, output format, boundaries (what never to flag), and SDD flow integration

## Capabilities

### New Capabilities

- `sdd-correctness-review`: On-demand review skill focused on correctness — logical bugs, edge cases, contract and invariant violations, unexpected behavior in AI-generated code — positioned in the post-apply pipeline before `simplify-review`

### Modified Capabilities

- `sdd-workspace-manifest`: Add `correctness-review` line in the Skills section of `openspec/infra.md`

## Impact

- New files: `.claude/skills/correctness-review/SKILL.md`, `.cursor/skills/correctness-review/SKILL.md`, `openspec/specs/sdd-correctness-review/spec.md`
- Modified: `AGENTS.md` (Post-implementation reviews section + Commands table), `openspec/infra.md` (Skills), `doc/sistema-sdd-pedro.md` (new operation subsection), `doc/avaliacoes/` (adoption entry)
- No new runtime dependencies; no binary, hook, or out-of-band LLM consumption — the skill operates via direct agent invocation (mode C — on demand), identical to `simplify-review`
- Pilot waived: insertion does not install a binary or hook (exception approved in `metodologia-insercao.md` Phase 2); design.md MUST include A–E matrix and rollback plan (user requirement)

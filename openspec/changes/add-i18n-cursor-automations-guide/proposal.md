**Issue:** —

## Why

PT→EN substitution produces many small OpenSpec waves (`translate-*-wave-N`). Operators need a durable guide for using **Cursor Automations / Cloud Agents** to batch **propose** and **apply** without violating one-phase-per-session, wave budgets, or merge gates. Without it, each wave is launched ad hoc and the Automations product has no repo-local playbook to `@` or read.

## What Changes

- Add operator guide `doc/i18n/CURSOR-AUTOMATIONS.md` (English): how to automate i18n wave propose/apply with Cursor Automations, Cloud Agents, `/multitask`, Session Handoff stubs, and merge-gate semantics
- Point to the guide from `doc/i18n/WAVES.md`
- Extend `sdd-docs-language` so the Automations guide is a required i18n inventory artifact (alongside GLOSSARY / WAVES / WAVE-PROPOSAL-TEMPLATE)
- **Non-goals:** installing Cursor product features; committing secrets/API keys; auto-merging PRs; changing wave budgets; implementing the Automations themselves inside this repo

## Capabilities

### New Capabilities

- _(none)_

### Modified Capabilities

- `sdd-docs-language`: ADDED requirement — repository MUST include `doc/i18n/CURSOR-AUTOMATIONS.md` as the operator playbook for Cursor Automations / Cloud Agents on translation waves; WAVES inventory MUST link to it; guide MUST document that manual merge is not a blocker for parallel **propose** of disjoint waves, and MUST include copy-paste Automation prompt stubs that `@` / read this path.

## Impact

- Files: `doc/i18n/CURSOR-AUTOMATIONS.md` (new), `doc/i18n/WAVES.md` (pointer), OpenSpec change + delta spec
- Dependencies: none (infra ✅ — Cursor Automations are a product surface; this change only documents how to use them against this repo)
- Risks: guide drifts from Cursor product UI; mitigate with “product URLs + local SDD constraints” split and dated sources
- Consumers: humans and Cursor Automation prompts that instruct agents to read `doc/i18n/CURSOR-AUTOMATIONS.md`

## Session Handoff stub

```
## Session Handoff

/opsx:apply add-i18n-cursor-automations-guide

Change: openspec/changes/add-i18n-cursor-automations-guide/
Read: proposal.md, design.md, tasks.md, doc/i18n/WAVES.md
Infra: openspec/infra.md (assume ✅ — do not reinstall)
```

## ADDED Requirements

### Requirement: Cursor Automations playbook for translation waves

The repository MUST include `doc/i18n/CURSOR-AUTOMATIONS.md` as the operator playbook for using Cursor Automations and Cloud Agents on PT→EN substitution waves. The playbook MUST be English (F7). It MUST:

1. Explain how to launch **propose** and **apply** as separate agent runs (one SDD phase per run) using Session Handoff stubs
2. State that **manual merge is not a blocker** for creating proposes of **disjoint** waves in parallel
3. State that **apply** of a wave requires that wave’s propose artifacts to be available on the branch/base the apply agent uses (typically after the propose PR is merged), and that **dependent** applies (explicit prerequisite waves) remain sequential
4. Include copy-paste prompt stubs that instruct the agent to read `doc/i18n/CURSOR-AUTOMATIONS.md`, `doc/i18n/WAVES.md`, `doc/i18n/WAVE-PROPOSAL-TEMPLATE.md`, and `doc/i18n/GLOSSARY.md`
5. Reference wave budgets and `scripts/verify-i18n-wave.sh` gates without relaxing them

`doc/i18n/WAVES.md` MUST link to `CURSOR-AUTOMATIONS.md` so operators discover the playbook from the wave inventory.

#### Scenario: Operator lists i18n docs after apply

- **WHEN** an operator lists `doc/i18n/` after this requirement is applied
- **THEN** `CURSOR-AUTOMATIONS.md` exists, is non-empty, and is linked from `WAVES.md`

#### Scenario: Automation prompt can reference the playbook path

- **WHEN** an operator configures a Cursor Automation whose instructions say to read `doc/i18n/CURSOR-AUTOMATIONS.md`
- **THEN** a Cloud Agent cloning this repository can open that path and follow the propose-only or apply-only stubs without needing chat history from a prior explore session

#### Scenario: Parallel proposes not blocked by manual merge

- **WHEN** wave A’s propose PR is still awaiting manual merge and wave B targets a disjoint file slice
- **THEN** the playbook documents that wave B’s `/opsx:propose` MAY proceed in parallel; it MUST NOT claim that all proposes must wait for every prior wave PR to merge

#### Scenario: Apply waits for propose availability

- **WHEN** an operator follows the apply stub for `translate-<surface>-wave-N`
- **THEN** the playbook requires confirming `openspec/changes/translate-<surface>-wave-N/` exists on the apply base (normally after propose merge) before editing in-scope files, and requires running `bash scripts/verify-i18n-wave.sh --files …` before marking tasks done

# Tasks — add-i18n-cursor-automations-guide

> Apply after human approval (R7). Docs-only. **Issue:** —

## 1. Guide

- [x] 1.1 Create `doc/i18n/CURSOR-AUTOMATIONS.md` (English) covering: Cursor Automations / Cloud Agents for i18n waves; one phase per run; parallel disjoint proposes; merge vs apply gates; copy-paste Automation + Session Handoff stubs; how Automations `@`/read this path
- [x] 1.2 Add a discovery link from `doc/i18n/WAVES.md` to `CURSOR-AUTOMATIONS.md`

## 2. Verify

- [x] 2.1 Run `OPENSPEC_TELEMETRY=0 npx --yes @fission-ai/openspec@1.3.1 validate add-i18n-cursor-automations-guide --strict`
- [x] 2.2 Confirm guide answers: (a) can Automations read this doc by path? (b) is manual merge a blocker for all proposes?

**Issue:** —

## Why

Operators leaving vibe-code have no guidance on how the agent should reach external tools (CLI vs MCP vs manual dashboard narration) and the system never detects that an integration is missing: the agent silently narrates manual steps session after session, MCPs get suggested or installed without their security and permanent-context-cost trade-offs stated, and a declined integration gets re-suggested because nothing records the refusal. The skill-guidance mechanism (`sdd-skill-guidance`, archived change `add-skill-guidance`) proved the pattern — offer-only suggestion, three-part message, hard anti-noise cap, dual surface — but tooling gaps differ in kind: they are statically detectable on the filesystem, they carry a real security surface (credentials, third-party servers, prompt injection), and refusals must persist across sessions. Closing explore merge `explore-tooling-guidance` (2026-08-01, D1–D12).

## What Changes

**v1 (this change — guidance text + one advisory script extension):**

- **Resolution cascade (normative core):** when the agent needs to act on an external tool, it MUST follow: session operator override → CLI configured (default) → MCP configured (fallback) → suggest configuring (offer-only, capped) → manual instructions (last resort). Falling to manual narration a second time for the same tool in a session IS the gold detection signal — the cascade closes its own loop. CLI-first is the default with per-tool exceptions where only MCP delivers the capability (e.g. structured design context). Rule R10 in `AGENTS.md` gains the cascade as the resolution order it already implies.
- **Static gap-check (primary mechanism, inversion vs skills):** `scripts/verify-infra.sh` extends to report presence/absence of MCP config (`.mcp.json` / `.cursor/mcp.json`), CLI availability for manifest-listed tools, and `.env.example` key names — report absence, never infer need (stack-inference deferred to v2). A commented-out key in `.env.example` is treated as "considered and declined". No new script.
- **Durable refusals:** `openspec/infra.md` tables accept a `declined` status value; a declined integration MUST NOT be re-suggested. Skills never needed this — re-suggesting a forbidden integration suggests violating policy.
- **Security-hardened suggestion message:** fixed three-part format (will / won't / decide) where the "won't" part MUST state: no auto-install ever, what data the MCP server sees, where keys live, install only from trusted registries/official sources, and the permanent per-session context cost of MCP schemas ("for occasional use, CLI + key is cheaper").
- **Shared anti-noise cap:** at most **one proactive suggestion per session across mechanisms** (skill + tooling), strongest signal wins — amends the `sdd-skill-guidance` cap rather than adding a second slot.
- **Conversational signal catalog (secondary layer):** repeat manual narration (gold), user pastes external-tool output, user asks for content "to paste elsewhere", credential/401 errors, user re-describes external system state — with the documented caveat that manual paste can be a policy choice, not a gap.
- **Day-1 doc tooling section:** new §8 in `doc/sdd-operator-day1.md` — cascade pedagogy, key → CLI → MCP hierarchy, MCP context cost, session override; "Next step" renumbers to §9; `/opsx:help` narrates it.
- **Per-tool install how-to:** new `doc/tooling-install.md` (official-doc link + verification command over transcribed walkthroughs; "verified on YYYY-MM" marker per entry), referenced from `openspec/infra.md` rows — mirrors the UI-module precedent (`doc/design/002-ui-module-install.md`).
- **Archive confidence question:** "was anything in this change done manually that an integration would have done?" — same register as the existing confidence questions.
- **Dual surface with documented asymmetry:** all guidance ships as `.claude/` + `.cursor/` mirrors via `sdd-kit/templates/` + MANIFEST; Claude Code surfaces may point to native harness tools (`SearchMcpRegistry`, `ListConnectors`), Cursor degrades to "suggest + point to `doc/tooling-install.md`" — recorded per-surface, no parity assumed.
- **Evaluation stub** under `doc/avaliacoes/` (insertion methodology R5) indexed in `doc/avaliacoes/README.md`.

**v2 (annotated follow-up — NOT built here):** stack-inference gap analysis ("you use Supabase but have no Supabase tooling"); durable per-tool preference column in `infra.md`; per-tool usage telemetry (same Cursor degradation problem as skills v2); preflight-time gap WARNs if the verify-infra report proves insufficient.

## Capabilities

### New Capabilities

- `sdd-tooling-guidance`: external-tool resolution cascade (override → CLI → MCP → suggest → manual), CLI-first default with per-tool MCP exceptions, session-only override, static gap-check via `verify-infra.sh` (report absence, not need), durable `declined` refusals, security-hardened offer-only suggestion message, conversational signal catalog, archive confidence question, per-tool install doc pattern, dual-surface delivery with documented Claude Code/Cursor asymmetry, and v2 non-goals recorded as deferred requirements.

### Modified Capabilities

- `sdd-skill-guidance`: the one-suggestion-per-session cap becomes **shared across proactive suggestion mechanisms** (skill + tooling), strongest signal wins.
- `sdd-workspace-manifest`: R10 gains the resolution cascade; `infra.md` tables accept the `declined` status value; `verify-infra.sh` gains the tooling gap-check (MCP config presence, manifest-listed CLI availability, `.env.example` key names, commented-key-as-declined).
- `sdd-operator-onboarding`: day-1 doc gains the tooling section; `/opsx:help` narrates it.
- `sdd-install-kit`: ship the new/updated guidance templates and the extended `verify-infra.sh` (both IDE surfaces where applicable) via `sdd-kit/templates/` + MANIFEST checksums.

## Impact

- **New:** skill `sdd-tooling-guidance` (`.claude/` + `.cursor/` + kit templates); `doc/tooling-install.md`; day-1 §8 tooling section; archive confidence question; gap-check output in `verify-infra.sh`; `declined` status in `infra.md`; `doc/avaliacoes/` evaluation stub; spec `sdd-tooling-guidance`
- **Modified:** `AGENTS.md` (R10 cascade); `scripts/verify-infra.sh` + kit template; `doc/sdd-operator-day1.md` (§8 insert, §8→§9 renumber) + kit template; `openspec-help` skill + `/opsx:help` command mirrors (§0–§8 → §0–§9, ×8 files); hub apply surfaces (compact cascade clause); hub archive surfaces (confidence question); explore/propose skill-suggestion sections (one-line shared-cap note); `openspec/infra.md`; `sdd-kit/MANIFEST.yaml` + checksums; deltas on `sdd-skill-guidance`, `sdd-workspace-manifest`, `sdd-operator-onboarding`, `sdd-install-kit`
- **Non-goals (v1):** auto-install or auto-configuration of any MCP/CLI/key (offer-only, always — "never install unprompted", no exceptions); always-on suggestion rule; suggesting MCP servers outside trusted registries/official sources; usage telemetry or monitoring; durable per-tool override (session-only in v1); stack-inference gap analysis; a second per-session suggestion slot; changes to `scripts/sdd-metrics.sh` or `scripts/preflight-sdd.sh`
- **Risks:** suggestion fatigue (shared cap, offer-only); operators installing MCPs they use sporadically (context-cost warning baked into the message); stale install instructions (official-link + verify-command pattern, "verified on YYYY-MM" markers); false positives on manual-paste signals (documented caveat; static check primary; durable refusals)
- **Checksums:** run `bash sdd-kit/gen-manifest-checksums.sh` when templates change
- **Pilot:** waived candidate (guidance text + advisory report-only script extension — no gate, hook, or install-path behavior change)
- **Sources:** `openspec/changes/explore-tooling-guidance/research.md` (D1–D12); archived change `2026-08-01-add-skill-guidance` (pattern mirrored); specs `sdd-skill-guidance`, `sdd-workspace-manifest`, `sdd-operator-onboarding`, `sdd-install-kit`; `doc/design/002-ui-module-install.md` (per-tool doc precedent)

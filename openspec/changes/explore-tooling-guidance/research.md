# Research — tooling gap detection and CLI→MCP→manual cascade (explore merge)

**Explore session:** 2026-08-01 · **Status:** exploration captured — feeds a future proposal `add-tooling-guidance`
**Scope question:** should ByeByeVibe detect missing external-tool integrations (CLI, MCP, `.env` keys) the way it detects skill-worthy repetition, and suggest configuring them — and what resolution order should the agent follow when acting on external tools?

## Context

- The skill-guidance mechanism (spec `sdd-skill-guidance`, archived change `add-skill-guidance`) established the pattern to mirror: three touchpoints (day-1 pedagogy, conversational detection in explore/propose, archive-time question), offer-only three-part suggestion message (will / won't / decide), hard anti-noise cap, dual-surface delivery, monitoring deferred to v2.
- Foundation for a static tooling check **already exists**: `scripts/preflight-sdd.sh` writes "MCP names (advisory)" into `openspec/infra.md`; `scripts/verify-infra.sh` maintains the manifest; `infra.md` already has **MCP Servers** and **Env vars (names only, from `.env.example`)** sections; rule R10 (`AGENTS.md`) obliges the agent to read `infra.md` before installing/reinstalling MCP, CLIs, plugins, or skills.
- `/opsx:help` (skill `openspec-help`) already routes install intent: step 4 says *"Read `openspec/infra.md` only if the operator asks to install tools."* The skill is deliberately thin (guardrail: content lives in docs, not in the skill body).
- Precedent for per-tool install how-to: UI module rows in `infra.md` point to `doc/design/002-ui-module-install.md` ("status in the manifest, how-to in a dedicated doc").
- Advisory cadence pattern available for reuse: `sdd-metrics.sh` stamp file, nudge at N=5 archives / T=30 days (guide §2.17), mode C.
- This repo currently has no `.mcp.json` and no `.env.example` — the gap-check would report exactly that.

## Decisions

### D1 — Tooling gaps are statically detectable; the static check is the primary mechanism (inversion vs skills)

Domain density only surfaces in conversation, so skill guidance made conversational detection primary. Tooling gaps live on the filesystem: `.mcp.json` / `.cursor/mcp.json` presence and contents, CLIs on `PATH`, key names in `.env.example`. A deterministic script (extension of `verify-infra.sh` / `preflight-sdd.sh`, **not** a new script) is cheaper, token-free, has no probabilistic false positives, and runs identically on both IDE surfaces. Conversational detection (D5) is the secondary layer.

### D2 — Resolution cascade for external-tool actions (normative core)

```
Action on an external tool needed
│
├─ 1. Operator override for this session ("use MCP first")?  → honor it, no debate
├─ 2. CLI configured?                                        → use CLI (default)
├─ 3. MCP configured?                                        → use MCP (fallback)
├─ 4. Neither?  → suggest configuring (offer-only, capped)
│                 └─ declined or still unconfigured …
└─ 5. Manual instructions (last resort) — and the gold detection signal
```

Falling to step 5 **is** the detectable event: the agent knows when it is narrating manual steps. Second fall for the same tool in a session ⇒ the suggestion fires (subject to the shared cap, D7). No separate "manual-action counter" heuristic is needed — the cascade closes its own loop.

### D3 — CLI-first is the default, with per-tool exceptions where only MCP delivers the capability

Rationale for CLI-first: zero permanent context cost (MCP schemas charge every session), controllable output, scriptable, works in CI. Exception class: tools where no CLI covers the use case (e.g. Figma structured design context) — there MCP is not fallback but the only rich path. The hierarchy is decided **per tool, not by dogma**; the pedagogy records "key → CLI → MCP, unless only MCP delivers the capability".

### D4 — Override scope: session-only in v1; durable per-tool preference deferred

The user-stated override ("MCP first") is honored for the current session. A durable per-tool preference is plausible (natural home: a "preference" column in the `infra.md` MCP/CLI tables, which R10 already forces the agent to read) but is deferred — v1 changes no manifest schema.

### D5 — Conversational signal catalog (secondary layer)

| Signal | Indicates |
|--------|-----------|
| Agent narrates manual dashboard steps for the same tool a 2nd+ time (= cascade step 5 repeat) | **Gold signal** — self-observed, high precision |
| User manually pastes external-tool output (ticket, screenshot, log) | Missing read integration |
| User repeatedly asks for content "to paste elsewhere" | Missing write integration |
| Credential/401 error on a command the agent ran | Missing `.env` key |
| User re-describes external system state ("in the DB it looks like…") | Missing read access |

Caveat vs skills: manual paste is sometimes a *choice* (e.g. company policy forbids integration), not a gap — precision is lower than domain-density signals, which reinforces D1 (static first) and D6 (durable refusals).

### D6 — Where the skill analogy breaks; each break shapes a requirement

1. **Security surface.** A skill is repo text; an MCP is credentials + a third-party server + prompt-injection surface (tool output is untrusted content entering context). The "won't" part of the suggestion message must carry: what data the server sees, where keys live, install only from trusted sources/registries. "Never create unprompted" hardens into "never **install/configure** unprompted" — no exceptions.
2. **Permanent context cost.** Every active MCP charges its tool schemas to every session. The mechanism must not push operators into installing MCPs they use sporadically — the suggestion message states the trade-off explicitly ("for occasional use, CLI + key is cheaper").
3. **Durable refusals.** Declining a tooling suggestion must stick across sessions (skills never needed this — a wrong skill suggestion wastes 30 s; re-suggesting a forbidden integration suggests violating policy). v1 needs a recorded-refusal location so the suggestion never re-fires for a declined tool (candidate: a "declined" status value in the `infra.md` tables; alternative: a small `openspec/tooling-declined.md` — open question).
4. **False-positive social cost.** An existing `.env.example` with a commented-out key is itself a "considered and declined" signal the static check must respect.

### D7 — Shared suggestion cap across mechanisms

With two suggestion mechanisms live (skill + tooling), two pop-ups per session is intrusive. Cap is **shared: at most one proactive suggestion per session, of either kind**, strongest signal wins. Whether this lands as an amendment to the `sdd-skill-guidance` spec or as a requirement of the new capability referencing it is an open question for propose.

### D8 — Vibe-coder profile: automation is served silently by the cascade, not by loosening the cap

Operators leaving vibe-code want maximum automation. The cascade satisfies that **silently** — the system always uses the best available path with zero questions. The desire for automation justifies making steps 2–3 excellent; it does not justify more suggestions. Suggestion stays the rare bottom rung.

### D9 — `/opsx:help` as install entry point: yes, advantageous — but instructions do not live in the skill

The routing already exists (help step 4 → `infra.md`); v1 fills in the missing endpoints while respecting the "keep this skill thin" guardrail:

```
/opsx:help ──narrates──▶ day-1 § (new) "Tooling: CLI → MCP → manual"
                            │ (pedagogy: cascade, MCP context cost,
                            │  key→CLI→MCP hierarchy, session override)
                            ▼
                 openspec/infra.md  (STATUS: what is ✅/❌/declined)
                            ▼
                 doc/tooling-install.md  (HOW-TO per tool: CLI install,
                 MCP config, expected .env.example key names,
                 "verified on YYYY-MM" marker)
```

Mirrors the UI-module precedent exactly (`infra.md` row → `doc/design/002-ui-module-install.md`). Day-1 renumbering cost is known and priced (the `add-skill-guidance` change already did §7/§8 renumbering once).

### D10 — Install instructions are the most perishable content in the repo; two mitigators

(a) "verified on YYYY-MM" marker on every tool entry (inherited from skill hygiene); (b) prefer *official-doc link + verification command* over transcribed step-by-step — `infra.md` already models this with its "Verify with" column. The agent installs better from "here is the official doc and the command that proves it worked" than from a frozen six-month-old walkthrough.

### D11 — Static gap-check v1 scope: report absence, do not infer need

v1 reports what is absent/present (`.mcp.json`, CLIs, `.env.example` keys) without inferring which integrations the project *should* have from `project.md`/dependency manifests. Stack-inference ("you use Supabase but have no Supabase tooling") is higher-value but higher-false-positive; deferred to v2. Periodic layer: gap-check rides the existing metrics cadence (N=5/T=30) plus one archive confidence question ("was anything in this change done manually that an integration would have done?") — same register as the existing confidence questions.

### D12 — Dual-surface asymmetry, documented like the telemetry asymmetry

Claude Code has native harness tools for this mechanism (`SearchMcpRegistry`, `SuggestConnectors`, `ListConnectors`) — surfaces there may instruct the agent to use them. Cursor has no equivalent: degradation path is "suggest + point to `doc/tooling-install.md`". Same treatment the `sdd-skill-guidance` spec gave the `PostToolUse` telemetry asymmetry: recorded per-surface, no parity assumed.

## Non-goals (carried into proposal)

Auto-install or auto-configuration of any MCP/CLI/key (offer-only, always); always-on suggestion rule; suggesting MCP servers outside trusted registries/official sources; usage telemetry or monitoring tooling in v1; durable per-tool override in v1 (D4); stack-inference gap analysis in v1 (D11); a second per-session suggestion slot (cap is shared, D7).

## Open questions for propose/design

- Durable-refusal location: "declined" status inside `infra.md` tables vs a dedicated `openspec/tooling-declined.md` (leaning: `infra.md` status value — one manifest, already R10-protected).
- Shared cap (D7): amendment to `sdd-skill-guidance` spec vs requirement in the new capability that references it.
- Gap-check delivery: new section in `verify-infra.sh` output vs preflight-only (leaning: both — verify writes the manifest sections, preflight surfaces WARNs).
- v2 candidates: stack-inference gap analysis; durable per-tool preference column; per-tool usage telemetry (same Cursor degradation problem as skills v2).

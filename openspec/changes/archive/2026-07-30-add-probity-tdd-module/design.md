## Context

### Current state

- **G2** in `explore-oss-coverage-gaps/research.md`: R6 without enforcement; original candidate TDD Guard (PreToolUse + reporters per test runner).
- **Supersession (2026-07):** [Probity](https://github.com/nizos/probity) is the official successor — reads session transcript (prompts, test runs, edits) instead of custom reporters ([migrating-from-tdd-guard.md](https://github.com/nizos/probity/blob/main/docs/migrating-from-tdd-guard.md)).
- **SDD stack:** GitNexus + Graphify already use PreToolUse; Probity will be the third in-band hook (mode B — the only gap of this kind).
- **Precedent:** C1-UI (`install-ui-module.sh`, spec `sdd-ui-module`, `doc/design/002-ui-module-install.md`).
- **Pipeline reviews:** `correctness-review` positioned "after tests (R6/TDD Guard)" — outdated text.

### Phase 0 checks

| # | Check | Result |
|---|-------|--------|
| V1 | Already installed? | No — `openspec/infra.md` does not list Probity |
| V2 | Surface | PreToolUse (mode B) — shared with GitNexus/Graphify |
| V3 | Collision | None — `probity.config.ts` and `install-probity-module.sh` are free |
| V4 | Profile | APP/HYBRID with tests; SKIP DOCS_SPECS |
| V5 | Hook stacking | **Pilot required** — measure p95 with 3 hooks |
| F1 | Security | `@nizos/probity@1.10.0` pinned; advisories before apply; optional `forbidCommandPattern(/rm\s+-rf/)` aligned with `050-security` |
| F2 | License | MIT |
| F3 | Governance | Active — v1.10.0 npm (Jul/2026); maintainer nizos (same as TDD Guard) |
| F4 | Reversibility | `install-probity-module.sh --uninstall` + remove plugin/hook |
| F5 | Operability | Globs exclude docs; uninstall plugin = disable module |

### External sources (R8)

| Resource | URL |
|----------|-----|
| Probity repo | https://github.com/nizos/probity |
| Setup (Claude Code, Codex, Copilot CLI) | https://github.com/nizos/probity/blob/main/docs/setup.md |
| Rules (`enforceTdd`, `forbidCommandPattern`, `requireCommand`) | https://github.com/nizos/probity/blob/main/docs/rules.md |
| TDD Guard → Probity migration | https://github.com/nizos/probity/blob/main/docs/migrating-from-tdd-guard.md |
| TDD Guard (legacy) | https://github.com/nizos/tdd-guard — "grew into Probity" |
| Cursor third-party hooks | https://cursor.com/docs/reference/third-party-hooks |
| npm | `@nizos/probity@1.10.0` |

---

## Goals / Non-Goals

**Goals:**

- Materialize R6 in APP/HYBRID repos via `enforceTdd()` on PreToolUse during apply
- Optional post-C1 module with `--detect` / `--apply` / `--dry-run` / `--yes`
- Replace TDD Guard with Probity across all SDD documentation (historical note preserved)
- Register in the 6-point contract; delta spec `sdd-probity-module`
- Quantified pilot before MANIFEST bump
- Fail-closed: kit MUST ship `probity.config.ts` template (without config, Probity blocks)

**Non-Goals:**

- Integrate TDD Guard in the kit (legacy; mention migration only)
- Probity mandatory in DOCS_SPECS
- Replace CI (`sdd-gates` + `npm test` on merge)
- Duplicate TDD Guard lint integration (`requireCommand` lint before commit — document as optional gap)
- Always-on `.mdc` rule for Probity
- `eval` of the `gate:` field in MANIFEST (F-SEC-5)

---

## Decisions

### D1: Tool — Probity, not TDD Guard

**Choice:** `@nizos/probity@1.10.0` as the definitive G2 candidate.

**Rationale:** Official maintainer superseded TDD Guard; Probity eliminates reporters per test runner (reads transcript); supports Vitest + pytest (stack in `openspec/project.md`); same PreToolUse surface.

**Discarded alternative:** TDD Guard — legacy; extra reporters; maintainer recommends Probity for new projects.

---

### D2: Trigger mode — B (in-band), not C

**Choice:** PreToolUse hook via Claude Code plugin (`/plugin install probity@probity`) or manual `.claude/settings.json`.

**Rationale:** G2 requires intercepting Write/Edit without a failing test — only a hook satisfies this. `metodologia-insercao.md` reserves mode B for G2.

**Disable (replaces TDD Guard toggle):**

| Method | When |
|--------|------|
| Globs in `probity.config.ts` | Exclude `doc/**`, `openspec/**`, `sdd-kit/**` — type A/docs |
| A–E classification (R1) | Type A: agent does not edit production code; globs as safety net |
| Uninstall plugin / remove hook | Docs-only session or operator prefers manual R6 |
| `--detect` SKIP | Repo without test runner (Vitest/Jest/pytest) |

---

### D3: Config template — `probity.config.ts`

**Choice:** Kit template with scope restricted to production code and tests.

```ts
import { defineConfig, enforceTdd, forbidCommandPattern } from '@nizos/probity'

export default defineConfig({
  rules: [
    {
      files: [
        'app/**', 'components/**', 'lib/**', 'src/**',
        '**/*.{test,spec}.{ts,tsx,js,jsx}',
        'tests/**', 'test/**', '__tests__/**',
        '!doc/**', '!openspec/**', '!sdd-kit/**',
      ],
      rules: [
        enforceTdd({
          instructions: (defaults) => `${defaults}

### SDD R6 addendum
- Bug fix (type B): MUST demonstrate a failing test reproducing the bug before changing production code.
- Refactor (type C): existing tests MUST stay green; new behaviour requires new failing tests first.
- Feature (type D): red-green-refactor cycle per acceptance criterion.`,
        }),
      ],
    },
    forbidCommandPattern({
      match: /rm\s+-rf/,
      reason: 'Destructive rm blocked per SDD security rule 050-security.',
    }),
  ],
})
```

**Notes:**

- `fastPath: false` by default (AI validator checks refactor step)
- Python: install `@ast-grep/lang-python` in the same scope if pytest fast-path is desired
- No config at repo root → Probity fail-closed (blocks writes)

---

### D4: Kit script — `install-probity-module.sh`

**Choice:** Script separate from `install.sh`, analogous to C1-UI.

**Flow:**

1. `--detect`: checks `package.json` + test runner (vitest/jest/pytest in scripts or deps); SKIP if DOCS_SPECS without tests
2. `--dry-run`: lists operations
3. `--apply`: copies `probity.config.ts`, `npm install -D @nizos/probity@1.10.0`, updates `openspec/infra.md`, plugin/hook instructions
4. `--yes`: accepts npm install without interactive prompt
5. `--uninstall`: removes config, documented hook entries, devDependency

**Does not:** alter C1 core; install TDD Guard; modify `<!-- gitnexus:start -->` blocks in AGENTS.md

---

### D5: PreToolUse stacking (GitNexus + Graphify + Probity)

**Suggested order in hook array:** GitNexus → Graphify → Probity (Probity last — TDD blocking decision after indexing).

**Risk:** accumulated latency per edit + Probity validator LLM cost.

**Mitigation:** restricted `files` scope; default `maxEvents`/`maxContentChars`; pilot measures p95.

---

### D6: Cursor IDE support

**Status:** [NEEDS VERIFICATION] — Cursor supports third-party hooks ([docs](https://cursor.com/docs/reference/third-party-hooks)); Claude PreToolUse → Cursor preToolUse mapping to validate in pilot.

**Pilot plan:**

1. Test `.cursor/hooks.json` with `npx @nizos/probity --agent claude-code` (or Cursor flag when documented)
2. Confirm Write/Edit trigger hook
3. If it fails: document in guide §2.16 "Claude Code primary; Cursor — [pilot result]"

Probity officially supports: Claude Code, Codex, GitHub Copilot CLI — **not** Cursor natively yet.

---

### D7: A–E matrix (activation)

| Type | Probity enforceTdd | correctness-review | CI sdd-gates |
|------|-------------------|-------------------|--------------|
| A — Trivial | off (globs) | no | runs |
| B — Bug fix | **on** | yes | runs |
| C — Refactor | on | yes (diff > ~80 lines) | runs |
| D — Feature | on | yes | runs |
| E — Exploration | n/a (no prod code) | n/a | validates artifacts |

**Updated pipeline:**

```
/opsx:apply → [implementation] → enforceTdd (R6/Probity)
  → correctness-review (B/C/D)
  → simplify-review (optional)
  → security-reviewer (if applicable)
  → commit → sdd-gates (CI)
```

---

### D8: 6-point contract

| # | Destination | Content |
|---|-------------|---------|
| R1 | `openspec/infra.md` + template | `@nizos/probity@1.10.0` · optional module · `test -f probity.config.ts` |
| R2 | `AGENTS.md` + `AGENTS.core.md` | ≤10 lines Integrations; A–E matrix; pipeline reviews |
| R3 | `.claude/skills/probity-guard/` + `.cursor/skills/` mirror | **Only if** AGENTS.md Integrations >10 lines after R2; description = when to consult troubleshooting |
| R4 | `doc/sistema-sdd-pedro.md` §2.16 | Human: install, pilot, Cursor, disable, rollback |
| R5 | `doc/avaliacoes/` G2 | "Adopted" after archive |
| R6 | `sdd-kit/install-probity-module.sh`, templates, MANIFEST bump, `verify.sh` check |

Post-install: `graphify update .` + `npx gitnexus analyze --force`

---

### D9: Lint gap (optional, not in initial apply scope)

TDD Guard integrated lint-before-commit. Probity offers `requireCommand({ before: git commit, command: /npm run lint/ })` — **do not** include in default template (SDD repos vary in linter). Document in §2.16 as opt-in.

---

### D10: Optional skill `probity-guard`

**Choice:** create skill only if R2 exceeds ~10 lines in Integrations.

**Minimum content:** when to auto-invoke (troubleshooting enforceTdd block, temporary override, uninstall), links to guide §2.16.

---

## Risks / Trade-offs

| Risk | Mitigation |
|------|------------|
| Unacceptable PreToolUse p95 latency with 3 hooks | Quantified pilot; `files` scope; abort MANIFEST promotion if criterion fails |
| False positives on type C refactor | Pilot N sessions; tuning `instructions`; documented temporary override |
| Cursor without native support | Pilot; Claude Code fallback; document limitation |
| LLM cost per write (AI validator) | Restricted scope; default `maxEvents`; budget in pilot |
| Agent re-proposes TDD Guard | Historical note in research/evaluation |
| No config → total block | Kit MUST ship template; `--detect` warns |

---

## Pilot (Phase 2 — required before MANIFEST)

**Repo:** APP worktree with Vitest or pytest — **not** this DOCS_SPECS hub.

**Prerequisites:** C1 + GitNexus + Graphify active; R11 register/check/release.

### Success criteria (quantified)

| Criterion | Threshold | Measurement |
|-----------|-----------|-------------|
| Extra PreToolUse latency p95 | **< 8s** per Write/Edit with 3 hooks active | Probity `--debug` JSONL + hook timestamps; N≥30 edits |
| Type C false positives | **< 15%** unjustified blocks | N≥5 type C apply sessions; operator classifies |
| Type B R6 compliance | **100%** bugs with failing test before fix | N≥3 type B sessions |
| Cursor IDE hooks | Write/Edit trigger hook **OR** document "Claude Code only" | Manual test 10 edits |

**Failure:** "Deferred" decision in evaluation; artifacts removed from pilot repo; MANIFEST not bumped.

---

## Migration Plan

### Apply (this change — DOCS_SPECS hub)

1. Create script + templates in sdd-kit (without activating in this repo)
2. Update documentation (canonical list in `tasks.md`)
3. Promote spec `sdd-probity-module`
4. Update delta `sdd-correctness-review`

### Post-apply (APP operator)

```bash
bash sdd-kit/install-probity-module.sh --detect
bash sdd-kit/install-probity-module.sh --apply --yes
/plugin marketplace add nizos/probity
/plugin install probity@probity
# Restart Claude Code session
```

### Rollback

```bash
bash sdd-kit/install-probity-module.sh --uninstall
/plugin uninstall probity@probity
npm uninstall @nizos/probity
rm -f probity.config.ts
# Revert openspec/infra.md Probity section
```

---

## Open Questions

1. **Cursor hooks:** pilot result determines whether §2.16 lists Cursor as supported or "Claude Code only".
2. **Skill probity-guard:** create or not depends on final AGENTS.md Integrations size (decision at apply).
3. **MANIFEST version bump:** only after green pilot — apply of this change may leave MANIFEST entry with `profiles: [APP, HYBRID]` but comment "promote after pilot" OR include entry and mark pilot as manual pre-merge gate.

## Context

- Explore sessions established F7 (chat MAY differ from versioned artifacts) and `sdd-docs-language` (EN default on the hub, PT→EN substitution waves).
- `sdd-kit/install.sh` today copies `AGENTS.core.md` with `[Adapt: pt-BR]` — no structured language policy.
- User decision: **v1 allowlist = `en` and `pt-BR` only**; defaults `en/en/en`; this hub stays grandfathered (chat pt-BR, docs/code EN).

## Goals / Non-Goals

**Goals:**

- Ask operator for chat, docs, and code language at C1 install (interactive or flags).
- Persist choices in `openspec/project.md` (Language policy table) and `AGENTS.md` (Communication).
- Agents in new sessions read persisted policy without relying on chat history.
- Support non-interactive install via `--chat-lang`, `--docs-lang`, `--code-lang` (each `en` or `pt-BR`).
- Document hub grandfather clause so hub EN waves are not invalidated.

**Non-Goals:**

- Locales beyond `en` / `pt-BR` in v1.
- Dual-file bilingual artifacts (`*.en.md` / `*-pt.md`).
- Changing this hub's existing `AGENTS.md` or `openspec/project.md`.
- `upgrade.sh` language re-prompt (future change).
- Blocking `sdd-gates` on language policy (verify via `sdd-kit/verify.sh` report/check).

## Decisions

### D1 — Three axes, independent

| Axis | Key | Scope |
|------|-----|-------|
| Chat | `chat_language` | Agent replies to operator; not versioned prose |
| Docs | `docs_language` | OpenSpec artifacts (proposal, design, specs, tasks), skills, rules prose, `doc/` |
| Code | `code_language` | Comments, UI strings, error messages; identifiers stay English/ASCII |

**Rationale:** User requested three separate definitions; chat choice must not authorize docs/code in a different configured language.

### D2 — v1 allowlist `en` | `pt-BR`

**Chosen:** reject any other value at install with clear error.

**Alternative rejected:** free-form BCP-47 — more validation, glossary, and verify-script work without proven demand.

### D3 — Defaults `en` / `en` / `en`

Enter or omit flags → all three `en`. Log: `Using language defaults: chat=en docs=en code=en`.

### D4 — Persistence locations

1. **`openspec/project.md`** — `## Language policy` table (SoT for configured values).
2. **`AGENTS.md` Communication** — operational instructions derived from table (agent reads every session).

No `.sdd/language.json` in v1 — avoids split-brain; optional follow-up.

### D5 — Template substitution in `install.sh`

`AGENTS.core.md` placeholders:

- `{{CHAT_LANG}}` → `en` or `pt-BR`
- `{{DOCS_LANG}}` → `en` or `pt-BR`
- `{{CODE_LANG}}` → `en` or `pt-BR`

`project.md`: if file exists (post-`openspec init`), MERGE-append or replace Language policy section via anchored block `<!-- SDD_LANGUAGE_POLICY_START -->` … `<!-- SDD_LANGUAGE_POLICY_END -->`.

### D6 — Hub grandfather clause

Distribution hub (DOCS_SPECS payload source) keeps:

- `chat_language`: operator preference (currently pt-BR in practice)
- `docs_language`: `en` (normative; PT→EN waves continue)
- `code_language`: `en`

`sdd-docs-language` i18n gates (G-PT, G-DoD) remain hub tooling for EN migration — not enforced on consumer repos with `docs_language=pt-BR`.

### D7 — Interactive vs non-interactive

- TTY + no language flags → prompt three questions (numbered menu en/pt-BR).
- Flags present → skip prompts; validate allowlist.
- `--dry-run` → print planned language policy without writing.

## Risks / Trade-offs

| Risk | Mitigation |
|------|------------|
| `AGENTS.md` exists → MERGE_PROFILE skips fresh Communication | Document manual merge; or add `--force-agents` follow-up |
| `project.md` MERGE misses Language policy | Anchored HTML comment block + verify gate |
| Consumer chooses `pt-BR` docs → no G-PT on hub script | Document in guide; script reads `docs_language` or skips outside hub |
| Placeholder leak if substitution fails | Gate: `grep` must not find `{{CHAT_LANG}}` in installed AGENTS.md |

## Migration Plan

1. Apply change → archive → promote `sdd-language-policy` spec.
2. Hub: no mandatory re-install; grandfather documented in spec.
3. New consumer C1 installs get prompt/flags automatically on next kit version.
4. Existing consumers: optional manual edit of `project.md` + `AGENTS.md` or re-run install with flags on fresh AGENTS (document in guide §2.9 note).

## Open Questions

- Whether `upgrade.sh` should offer language re-configure on major kit bump (deferred).
- Whether `openspec/changes/_template/proposal.md` should include a language reminder line (optional polish).

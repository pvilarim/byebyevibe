**Issue:** —

## Why

New SDD installations copy `AGENTS.core.md` with only a `[Adapt: pt-BR]` placeholder — agents do not see the full chat-vs-artifacts rule, and operators cannot choose documentation or code language at install time. The hub already runs chat in pt-BR with English docs/code (F7), but that policy is not captured during C1 install in consumer repos. Operators need three independent, persisted language axes (chat, docs, code) with safe defaults (`en` / `en` / `en`).

## What Changes

- **New capability `sdd-language-policy`:** three language axes — `chat_language`, `docs_language`, `code_language` — configured at C1 install; v1 allowed values `en` and `pt-BR` only; defaults `en` for all three when skipped.
- **`sdd-kit/install.sh`:** interactive prompt (or flags `--chat-lang`, `--docs-lang`, `--code-lang`) before copying templates; writes Language policy into `openspec/project.md` and Communication section into `AGENTS.md`.
- **`sdd-kit/templates/AGENTS.core.md`:** replace `[Adapt: pt-BR]` with parameterized F7-style block (`{{CHAT_LANG}}`, `{{DOCS_LANG}}`, `{{CODE_LANG}}`).
- **Guide `doc/sistema-sdd-pedro.md`:** new §2.1.1 Language setup; §2.8 checklist item; §12.1 `project.md` template gains Language policy table.
- **`sdd-docs-language` (delta):** hub distribution repo remains grandfathered (EN docs + PT→EN waves); consumer repos follow configured `docs_language`; `verify-i18n-wave.sh` G-PT/G-DoD applies only when `docs_language` is `en` on hub migration surfaces.
- **Hub repo (this workspace):** no retroactive change to current `AGENTS.md` / `openspec/project.md` — grandfather clause documents existing pt-BR chat + EN docs/code.

## Capabilities

### New Capabilities

- `sdd-language-policy`: three-axis language model; install-time capture; persistence in `openspec/project.md` + `AGENTS.md`; v1 locale allowlist (`en`, `pt-BR`); defaults; hub grandfather clause.

### Modified Capabilities

- `sdd-install-kit`: `install.sh` MUST prompt or accept flags for three languages and materialize policy before template copy completes.
- `sdd-docs-language`: hub EN-default + migration waves remain; consumer repos MAY set `docs_language` to `pt-BR` at install; i18n verification scope clarified.

## Impact

- New: `openspec/specs/sdd-language-policy/spec.md` (on archive), `openspec/changes/add-install-language-policy/specs/*`
- Modified: `sdd-kit/install.sh`, `sdd-kit/templates/AGENTS.core.md`, `sdd-kit/verify.sh`, `doc/sistema-sdd-pedro.md` (guide slices), `sdd-kit/templates/scripts/bootstrap-sdd.sh` (pointer)
- **Non-goals:** arbitrary BCP-47 locales beyond `en`/`pt-BR` in v1; dual-file `*.pt.md` siblings; mass re-translation of hub content; changing this hub's current language setup; making language prompts blocking in CI dry-runs (flags required for non-interactive)
- **Follow-up (out of scope):** v2 locale expansion (`es`, `fr`, …); `upgrade.sh` re-prompt on kit upgrade

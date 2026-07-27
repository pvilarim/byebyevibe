## ADDED Requirements

### Requirement: Kit-scripts wave-2 verify-infra residual-PT scripts are English

The verify-infra script paths `scripts/verify-infra.sh` and `sdd-kit/templates/scripts/verify-infra.sh` MUST be written in English after the kit-scripts substitution wave. Residual Portuguese prose in these files is FORBIDDEN after apply, including operator-facing `echo` / stderr messages and the match-and-rewrite chrome strings previously used against `openspec/infra.md` (timestamp line, env-table headers, and the Agent rule section anchor) that matched the wave deny-list or Portuguese manifesto labels. Dual-file siblings such as `*.en.sh`, `*-pt.sh`, `*.en.md`, or `*-pt.md` MUST NOT be introduced for these paths. Freeze-list tokens (paths including `scripts/verify-infra.sh`, `sdd-kit/templates/scripts/verify-infra.sh`, `openspec/infra.md`, and `sdd-kit/MANIFEST.yaml`; HTML comment marker names such as `openspec-version`, `mcp-list`, and `kit-version`; status glyphs ✅/❌; `[NEEDS VERIFICATION]`; env var **names**; slash commands such as `/opsx:*`; fenced shell commands; and brand/tool names including ByeByeVibe, OpenSpec, GitNexus, and Graphify) MUST remain unaltered aside from intentional non-i18n fixes. Script control flow and hub↔template content equivalence MUST keep the same meaning after prose is normalized to glossary-canonical English. Chrome vocabulary MUST align to the kit English manifesto forms already present in `sdd-kit/templates/openspec/infra.md` (`Last verified`, `Variable | Present | Verify with`, `## Agent rule`). When the kit template file is edited, `sdd-kit/MANIFEST.yaml` checksums for that template MUST be regenerated via `bash sdd-kit/gen-manifest-checksums.sh` so kit integrity remains honest.

#### Scenario: Kit-scripts wave-2 files pass per-wave verification

- **WHEN** an operator runs `bash scripts/verify-i18n-wave.sh --files scripts/verify-infra.sh,sdd-kit/templates/scripts/verify-infra.sh` after the kit-scripts substitution is applied (including MANIFEST checksum regeneration)
- **THEN** the script exits 0 (including G-PT and G-MANIFEST on those paths)

#### Scenario: No dual-file migration for kit-scripts wave-2

- **WHEN** the kit-scripts substitution wave apply completes
- **THEN** English content is at `scripts/verify-infra.sh` and `sdd-kit/templates/scripts/verify-infra.sh` and no permanent language-suffixed sibling exists for those paths

#### Scenario: Verify-infra contracts remain stable

- **WHEN** an operator runs `bash scripts/verify-infra.sh` after substitution against an English `openspec/infra.md` whose chrome matches the kit manifesto labels
- **THEN** core SDD checks, HTML marker status updates, timestamp refresh on the `Last verified` line, and env-table rewrite against `## Agent rule` remain equivalent to the pre-wave Portuguese-chrome scripts while comments and operator-facing messages are English

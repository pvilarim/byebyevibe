## ADDED Requirements

### Requirement: Kit-scripts wave-3 bootstrap residual-PT scripts are English

The bootstrap script paths `scripts/bootstrap-sdd.sh` and `sdd-kit/templates/scripts/bootstrap-sdd.sh` MUST be written in English after the kit-scripts substitution wave. Residual Portuguese prose in these files is FORBIDDEN after apply, including comments and operator-facing `echo` / stderr messages (shared GitNexus optional-continue banner, failure warnings, and — on the template only — HYBRID coexistence warning lines) that matched the wave deny-list or remaining Portuguese operator chrome. Dual-file siblings such as `*.en.sh`, `*-pt.sh`, `*.en.md`, or `*-pt.md` MUST NOT be introduced for these paths. Freeze-list tokens (paths including `scripts/bootstrap-sdd.sh`, `sdd-kit/templates/scripts/bootstrap-sdd.sh`, `sdd-kit/install.sh`, `sdd-kit/MANIFEST.yaml`, and `openspec/project.md`; profile enum names `APP`, `DOCS_SPECS`, and `HYBRID`; slash commands such as `/opsx:*`; fenced shell commands; and brand/tool names including ByeByeVibe, OpenSpec, GitNexus, and Graphify) MUST remain unaltered aside from intentional non-i18n fixes. Script control flow and the intentional hub↔template profile-detection divergence MUST keep the same meaning after prose is normalized to glossary-canonical English. When the kit template file is edited, `sdd-kit/MANIFEST.yaml` checksums for that template MUST be regenerated via `bash sdd-kit/gen-manifest-checksums.sh` so kit integrity remains honest. Operator-facing bootstrap stderr remains the runtime source-of-truth for those messages (including the template HYBRID warning); other artifacts MUST NOT re-embed legacy Portuguese tokens from these scripts as normative quoted contracts in this wave.

#### Scenario: Kit-scripts wave-3 files pass per-wave verification

- **WHEN** an operator runs `bash scripts/verify-i18n-wave.sh --files scripts/bootstrap-sdd.sh,sdd-kit/templates/scripts/bootstrap-sdd.sh` after the kit-scripts substitution is applied (including MANIFEST checksum regeneration)
- **THEN** the script exits 0 (including G-PT and G-MANIFEST on those paths)

#### Scenario: No dual-file migration for kit-scripts wave-3

- **WHEN** the kit-scripts substitution wave apply completes
- **THEN** English content is at `scripts/bootstrap-sdd.sh` and `sdd-kit/templates/scripts/bootstrap-sdd.sh` and no permanent language-suffixed sibling exists for those paths

#### Scenario: Bootstrap contracts remain stable

- **WHEN** an operator runs `bash scripts/bootstrap-sdd.sh` (hub) or the kit template copy after substitution
- **THEN** OpenSpec init, optional GitNexus continue-on-failure, Graphify setup, and `sdd-kit/install.sh --profile …` invocation remain equivalent to the pre-wave scripts while comments and operator-facing messages are English, and the template-only HYBRID coexistence warning behavior is preserved (not removed and not ported into the hub by this wave)

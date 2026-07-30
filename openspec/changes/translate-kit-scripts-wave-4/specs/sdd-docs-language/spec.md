## ADDED Requirements

### Requirement: Kit-scripts wave-4 upgrade.sh residual-PT script is English

The kit upgrade script path `sdd-kit/upgrade.sh` MUST be written in English after the kit-scripts substitution wave. Residual Portuguese prose in this file is FORBIDDEN after apply, including comments, dry-run `UPGRADE_REPORT.md` scaffold headings and labels, operator-facing `echo` / stderr messages, and the approval checkbox text plus the matching `grep` needle used by `--apply`. Dual-file siblings such as `*.en.sh`, `*-pt.sh`, `*.en.md`, or `*-pt.md` MUST NOT be introduced for this path. Freeze-list tokens (paths including `sdd-kit/upgrade.sh`, `sdd-kit/MANIFEST.yaml`, and `UPGRADE_REPORT.md`; flags `--from`, `--to`, `--profile`, `--dry-run`, `--apply`, `--force`, and `--repo`; merge classification labels `KEEP_LOCAL`, `MERGE`, `COPY`, `NEW`, and `SKIP`; profile enum names `APP`, `DOCS_SPECS`, and `HYBRID`; slash commands such as `/opsx:*`; fenced shell commands; and brand/tool names including ByeByeVibe and OpenSpec) MUST remain unaltered aside from intentional non-i18n fixes. Upgrade control flow (dry-run report scaffolding, approval gate before COPY apply, main/master branch safety, and template integrity checks) MUST keep the same meaning after prose is normalized to glossary-canonical English. The approval checkbox string written into new `UPGRADE_REPORT.md` scaffolds and the string grepped by `--apply` MUST remain identical to each other after substitution; `sdd-kit/upgrade.sh` remains the runtime source-of-truth for that needle. Other artifacts MUST NOT be edited in this wave solely to re-quote a legacy Portuguese checkbox token.

#### Scenario: Kit-scripts wave-4 file passes per-wave verification

- **WHEN** an operator runs `bash scripts/verify-i18n-wave.sh --files sdd-kit/upgrade.sh` after the kit-scripts substitution is applied
- **THEN** the script exits 0 (including G-PT on that path)

#### Scenario: No dual-file migration for kit-scripts wave-4

- **WHEN** the kit-scripts substitution wave apply completes
- **THEN** English content is at `sdd-kit/upgrade.sh` and no permanent language-suffixed sibling exists for that path

#### Scenario: Upgrade approval gate remains coherent

- **WHEN** an operator runs `bash sdd-kit/upgrade.sh --from … --to … --dry-run` and later `--apply` with a matching checked approval checkbox in `UPGRADE_REPORT.md` after substitution
- **THEN** the dry-run scaffold and the `--apply` grep needle use the same English approval string, `--apply` still refuses an unchecked or missing report, and COPY/MERGE/profile/`--force`/integrity behavior remains equivalent to the pre-wave script while comments and operator-facing messages are English

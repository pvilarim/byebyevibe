## ADDED Requirements

### Requirement: Kit-scripts wave-6 templates/install-ui-module.sh residual-PT script is English

The kit UI-module installer template path `sdd-kit/templates/install-ui-module.sh` MUST be written in English after the kit-scripts substitution wave. Residual Portuguese prose in this file is FORBIDDEN after apply, including comments, operator-facing `echo` / stderr messages, and the embedded `openspec/infra.md` UI Development Module table chrome (headers and cell wording) written by the script. Dual-file siblings such as `*.en.sh`, `*-pt.sh`, `*.en.md`, or `*-pt.md` MUST NOT be introduced for this path. Freeze-list tokens (paths including `sdd-kit/templates/install-ui-module.sh`, `sdd-kit/install-ui-module.sh`, `doc/design/002-ui-module-install.md`, `openspec/infra.md`, and `openspec/project.md`; flags `--detect`, `--dry-run`, `--apply`, `--yes`, and `--repo`; brand/tool names including Impeccable, Open Design, Pencil, Figma MCP, and shadcn; slash commands such as `/opsx:*`; and fenced shell commands) MUST remain unaltered aside from intentional non-i18n fixes. Install-ui-module control flow (detect inventory, dry-run planning, design-doc install, infra section update, and optional Impeccable install) MUST keep the same meaning after prose is normalized to glossary-canonical English. When this template under `sdd-kit/templates/` is edited, `sdd-kit/MANIFEST.yaml` checksums for the corresponding `source:` MUST be refreshed via `bash sdd-kit/gen-manifest-checksums.sh` in the same apply. The hub path `sdd-kit/install-ui-module.sh` is out of scope for this wave’s file list and MUST NOT be required to change in the same apply.

#### Scenario: Kit-scripts wave-6 file passes per-wave verification

- **WHEN** an operator runs `bash scripts/verify-i18n-wave.sh --files sdd-kit/templates/install-ui-module.sh` after the kit-scripts substitution is applied
- **THEN** the script exits 0 (including G-PT and G-MANIFEST on that path)

#### Scenario: No dual-file migration for kit-scripts wave-6

- **WHEN** the kit-scripts substitution wave apply completes
- **THEN** English content is at `sdd-kit/templates/install-ui-module.sh` and no permanent language-suffixed sibling exists for that path

#### Scenario: Embedded infra UI-module chrome stays English-aligned

- **WHEN** a consumer install copies this MANIFEST `source:` template (or an operator runs the template script with `--apply` / `--dry-run` planning that would write the same section) after substitution
- **THEN** the embedded UI Development Module table uses English headers equivalent to `Component` / `Status` / `Verify with` and English on-demand / in-session cell wording, without reintroducing Portuguese `Componente`, `Estado`, `Verificar com`, `sob demanda`, or `sessão` tokens into newly written section text, while detect/apply/impeccable control flow remains equivalent to the pre-wave script

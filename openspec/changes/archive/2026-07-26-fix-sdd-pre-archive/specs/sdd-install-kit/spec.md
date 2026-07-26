# sdd-install-kit Specification (delta)

## MODIFIED Requirements

### Requirement: install.sh sem dead code

`sdd-kit/install.sh` MUST NOT contain code blocks that produce output (stdout/stderr) without that output being consumed by any pipe, process substitution, or variable. Any `python3 - <<'PY'` block that generates TSV from MANIFEST files MUST be encapsulated inside a process substitution `< <(...)` feeding a `while read`.

#### Scenario: Sintaxe do script verificada

- **WHEN** `bash -n sdd-kit/install.sh` é executado
- **THEN** sai com código 0 (sem erros de sintaxe)

#### Scenario: Apenas um bloco python3 heredoc presente

- **WHEN** o conteúdo de `sdd-kit/install.sh` é inspeccionado
- **THEN** existe exactamente 1 ocorrência de `python3 - <<'PY'` (dentro do process substitution `< <(...)`)

### Requirement: Versão do guia sincronizada

All version references in `doc/sistema-sdd-pedro.md` — in the file header and in the §2.0 installation prompt — MUST reflect the current MANIFEST version (`version` in `sdd-kit/MANIFEST.yaml`). At version 1.4.0, all occurrences MUST read `v1.4.0`.

#### Scenario: Cabeçalho do guia com versão correcta

- **WHEN** a linha 5 de `doc/sistema-sdd-pedro.md` é lida
- **THEN** contém `v1.4.0`

#### Scenario: Prompt §2.0 com versão correcta

- **WHEN** a linha 149 de `doc/sistema-sdd-pedro.md` é lida
- **THEN** contém `v1.4.0`
